#!/usr/bin/ruby
# WebExcursions, a script for gathering new Pinboard links with a certain tag
# and generating Markdown/Jekyll posts when enough are collected.
# Brett Terpstra 2013
#
# -f to force writing out current bookmarks to file regardless of count

%w[fileutils set net/https zlib rexml/document time base64 uri cgi stringio].each do |filename|
  require filename
end
$conf = {}
$conf['debug'] = true
# Pinboard credentials
$conf['user'] = 'funkypenguin'
$conf['password'] = 'vAFrafvacl'
# Where to store the database
$conf['db_location'] = File.expand_path("./webexcursions")
# Tag to use for finding bloggable bookmarks
$conf['blog_tag'] = 'bon'
# How many posts must be gathered before publishing
$conf['min_count'] = 5
# relative location of folder for creating drafts
$conf['drafts_folder'] = '_posts/2018'
# template for post headers
$conf['post_template'] =<<ENDTEMPLATE
---
title: "Bookmarks of note / #{Time.now.strftime('%B %d, %Y')}"
layout: post
categories:
- bookmarks
comments: false
crosspost_to_medium: false
tags: bookmarks-of-note
---
ENDTEMPLATE

class Net::HTTP
  alias_method :old_initialize, :initialize
  def initialize(*args)
    old_initialize(*args)
    @ssl_context = OpenSSL::SSL::SSLContext.new
    @ssl_context.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end
end

class Utils
  def debug_msg(message,sticky = true)
    if $conf['debug']
      $stderr.puts message
    end
  end
end

class Pinboard
  attr_accessor :user, :pass, :existing_bookmarks, :new_bookmarks
  def initialize
    # Make storage directory if needed
    FileUtils.mkdir_p($conf['db_location'],:mode => 0755) unless File.exists? $conf['db_location']

    # load existing bookmarks database
    @existing_bookmarks = self.read_bookmarks
  end
  # Store a Marshal dump of a hash
  def store obj = @existing_bookmarks, file_name = $conf['db_location']+'/bookmarks.stash', options={:gzip => false }
    marshal_dump = Marshal.dump(obj)
    file = File.new(file_name,'w')
    file = Zlib::GzipWriter.new(file) unless options[:gzip] == false
    file.write marshal_dump
    file.close
    return obj
  end
  # Load the Marshal dump to a hash
  def load file_name
    begin
      file = Zlib::GzipReader.open(file_name)
    rescue Zlib::GzipFile::Error
      file = File.open(file_name, 'r')
    ensure
      obj = Marshal.load file.read
      file.close
      return obj
    end
  end
  # Set up credentials for Pinboard.in
  def set_auth(user,pass)
    @user = user
    @pass = pass
  end

  def new_bookmarks
     return self.unique_bookmarks
  end

  def existing_bookmarks
    @existing_bookmarks
  end

  # retrieves the XML output from the Pinboard API
  def get_xml(api_call)
    xml = ''
    http = Net::HTTP.new('api.pinboard.in', 443)
    http.use_ssl = true
    http.start do |http|
    	request = Net::HTTP::Get.new(api_call)
    	request.basic_auth @user,@pass
    	response = http.request(request)
    	response.value
    	xml = response.body
    end
    return REXML::Document.new(xml)
  end
  # converts Pinboard API output to an array of URLs
  def bookmarks_to_array(doc)
    bookmarks = []
    doc.elements.each('posts/post') do |ele|
      post = {}
      ele.attributes.each {|key,val|
        post[key] = val;
      }
      bookmarks.push(post)
    end
    return bookmarks
  end
  # compares bookmark array to existing bookmarks to find new urls
  def unique_bookmarks
      xml = self.get_xml("/v1/posts/recent?tag=#{$conf['blog_tag']}&count=100")
      bookmarks = self.bookmarks_to_array(xml)
      unless @existing_bookmarks.nil?
        old_hrefs = @existing_bookmarks.map { |x| x['href'] }
        bookmarks.reject! { |s| old_hrefs.include? s['href'] }
      end
      return bookmarks
  end
  # wrapper for load
  def read_bookmarks
    # if the file exists, read it
    if File.exists? $conf['db_location']+'/bookmarks.stash'
      return self.load $conf['db_location']+'/bookmarks.stash'
    else # new database
      return []
    end
  end

  def read_current_excursion
    # if the file exists, read it
    if File.exists? $conf['db_location']+'/current.stash'
      return self.load $conf['db_location']+'/current.stash'
    else # new database
      return []
    end
  end
end

util = Utils.new
pb = Pinboard.new

pb.set_auth($conf['user'], $conf['password'])

# retrieve recent bookmarks
new_bookmarks = pb.new_bookmarks

# load the current draft stash
current_excursion = pb.read_current_excursion
if new_bookmarks.count > 0 || current_excursion.count > 0
  util.debug_msg("Found #{new_bookmarks.count} unindexed bookmarks.",false)
else
  util.debug_msg("No new bookmarks. Exiting.",false)
  exit
end

# merge new bookmarks into main database
existing_hrefs = current_excursion.map { |x| x['href'] }
new_bookmarks.each {|bookmark|
  pb.existing_bookmarks.push(bookmark)
  unless existing_hrefs.include? bookmark['href']
    current_excursion.push(bookmark)
  end
}

pb.store

# if there are 5 or more bookmarks, create a draft post and clear cache
if current_excursion.length >= $conf['min_count'].to_i || ARGV[0] == '-f'
  output = $conf['post_template']
  current_excursion.each_with_index {|bookmark, i|
    output += "* [#{bookmark['description']}](#{bookmark['href']})\n"
    output += "&#8594; #{bookmark['extended'].gsub(/\n+/,' ')}\n\n"
  }
  output += "Bookmarks are automatically generated from my [pinboard](https://pinboard.in) account, you can see them all tagged as #[bon](https://pinboard.in/u:funkypenguin/t:bon/)"
  File.open("#{$conf['drafts_folder']}/#{Time.now.strftime('%Y-%m-%d').downcase}-of-note-#{Time.now.strftime('%d-%B-%Y').downcase}.markdown",'w+') do |f|
    f.puts output
  end
  current_excursion = []
  FileUtils.mv($conf['db_location']+'/current.stash',$conf['db_location']+"/published-#{Time.now.strftime('%Y-%m-%d-%s')}.stash")
else # fewer than five bookmarks, list existing and dump stash
  puts "There are currently #{current_excursion.count} bookmarks collected."
  current_excursion.each_with_index {|bookmark, i|
    puts "#{i.to_s}: #{bookmark['description']}"
  }
  pb.store(current_excursion, $conf['db_location']+'/current.stash', options={:gzip => false })
end



