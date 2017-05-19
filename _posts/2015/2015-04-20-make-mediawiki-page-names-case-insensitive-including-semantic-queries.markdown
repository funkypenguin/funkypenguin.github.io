---
layout: page
title: "Make mediawiki page names case insensitive, including semantic queries"
date: "2015-04-20 12:23"
categories:
  - howto
---
At [Prophecy][1], We use [MediaWiki][2] for our internal documentation. Our use has become more sophisticated over time, and we've recently made a small change which I hope will make the wiki even more usable in future.

[1]: http://www.prophecy.net.nz
[2]: https://www.mediawiki.org/wiki/MediaWiki

<div class="panel radius" markdown="1">
**Table of Contents**
{: #toc }
*  TOC
{:toc}
</div>

## The default behaviour

By default, MediaWiki page titles are case-sensitive. This means that "Funky Penguin" and "funky penguin" are two unique pages. This makes sense for Wikipedia, which maintains a massive and list of page names, which need to be accessible in multiple languages.

For a small internal wiki though, it's less than idea, because:

1. Case-sensitivity makes it harder to find pages, and easier to accidentally create duplicates. You might create a page titled "Customer ABC Inc", but a colleague would enter it as "Customer ABC inc", and complain that the page is not found. Worse still, your colleague might __re-create__ the page as "Customer ABC inc", and now you have two differing pages each containing a version of your customer documentation
2. Mediawiki's default behaviour is to capitalize the first link of the page, no matter what. This can be a nuisance when recording device details on the wiki (say, 'router1.isp.co.nz'), since the resulting page will be called 'Router1.isp.co.nz', and when staff copy/paste to/from the wiki, all sorts of inconsistencies will result

## The new behaviour

We now treat each wiki page as case-insensitive. That means "**Funky Penguin**", "**funky penguin**", and "**FuNKy PEnguIn**" now all point to the same page.

We also treat all [Semantic Mediawiki][3] data as case-insensitive, so that a search for pages with property "customer" set to "ibm" will also match pages with property "Customer" set to "IBM".

[This page at ITW3](http://itw3.com/en/Disabling_MediaWiki_case_sensitive_URLs) was the basis for the following changes.

## How to make MediaWiki case-insensitive

### High-Level Summary

I did the following to effect the desired behavior:

1. Identify and resolve any duplicates page names which would prevent us from making the page titles case-insensitive
2. Update the collation on the page_title field in the database, to a case-insensitive collation
3. Prevent MediaWiki from capitalizing the first letter of the page title
4. Update the SMW database tables to make searches case-insensitive

### Identify duplicate pages

I wrote this script to help identify duplicate page names. Fortunately we didn't have many (about 30 over 10 years)

<script src="https://gist.github.com/funkypenguin/b0e433ab0737bbb0be49.js"></script>

In each case, I had to specify the namespace (0 is the default namespace), and then I simply clicked on the __first__ URL returned (I knew this to be the oldest page) and deleted the page.

Once the script returns no results, it's safe to proceed with changing the database collation

### Update database collation

Bearing in mind that my database is named "wikidb", with prefix set to "mediawiki", I ran the following:

{% highlight php %}
    mysql wikidb -s -N -e "alter table mediawiki_page modify page_title
    varchar(255) character set latin1 collate latin1_general_ci;"
{% endhighlight %}

### Prevent capitalization

Provided MediaWiki is > version 1.2.4, the following will [disable capitalization](http://www.mediawiki.org/wiki/Manual:$wgCapitalLinks) of the first letter of wiki page titles:

{% highlight php %}
    $wgCapitalLinks = false;
{% endhighlight %}

### Update SMW

Updating the Semantic Mediawiki database tables was a bit more complicated. The following database update [was necessary](http://semantic-mediawiki.org/wiki/Thread:Help_talk:Selecting_pages/Case_insensitive_query_possible%3F/reply_(3))

{% highlight mysql %}
ALTER TABLE wikidb.mediawiki_smw_object_ids CHANGE smw_title smw_title_bak varbinary(255);
ALTER TABLE wikidb.mediawiki_smw_object_ids ADD smw_title VARCHAR(255) AFTER smw_namespace;
UPDATE wikidb.mediawiki_smw_object_ids SET smw_title = CAST(smw_title_bak AS CHAR) ;

-- smw_sort_key
ALTER TABLE wikidb.mediawiki_smw_object_ids CHANGE smw_sortkey smw_sortkey_bak varbinary(255);
ALTER TABLE wikidb.mediawiki_smw_object_ids ADD smw_sortkey VARCHAR(255) AFTER smw_subobject;
UPDATE wikidb.mediawiki_smw_object_ids SET smw_sortkey = CAST(smw_sortkey_bak AS CHAR) ;

-- smw_di_blob
ALTER TABLE wikidb.mediawiki_smw_di_blob CHANGE o_hash o_hash_bak varbinary(255);
ALTER TABLE wikidb.mediawiki_smw_di_blob ADD o_hash VARCHAR(255) AFTER o_blob;
UPDATE wikidb.mediawiki_smw_di_blob SET o_hash = CAST(o_hash_bak AS CHAR) ;
{% endhighlight %}

After making this update, I launched a refresh of all semantic data by running ````extensions/SemanticMediaWiki/maintenance/SMW_refreshData.php```` and ````maintenance/runJobs.php```` from the command line.

[3]: https://semantic-mediawiki.org/
