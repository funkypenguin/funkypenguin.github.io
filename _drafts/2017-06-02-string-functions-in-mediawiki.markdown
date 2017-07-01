---
layout: "post"
title: "String functions in mediawiki"
date: "2017-06-02 19:14"
excerpt: "Creating mailto links in mediawiki"
---
At Prophecy, we use rely on mediawiki for almost all of our documentation. We use the Semantic Mediawiki extension to make mediawiki behave like a "lightweight database" - associating properties with pages, and editing them with forms.

Today's challenge was to create a mailto:// link from the contents of a semantically defined page. Here's what I ended up with:

    [mailto:(permit system)?Subject=
    {{urlencode:{{#show: {{PAGENAME}} |
    ?Description}}|PATH}}&Body=Details%0A---%0AApproved%20MOP%3A%20%20
    {{canonicalurl:{{PAGENAME}}}}%0A%0AStart%3A%20%20
    {{urlencode:{{#show: {{PAGENAME}} | ?Start}|PATH}}%0AEnd%3A%20%20%20%20
    {{urlencode:{{#show: {{PAGENAME}} | ?Finish}}|PATH}}
    %0A%0AEventum%20Case%3A%20%20
    {{#show: {{PAGENAME}} | Jira Link#nowiki}}
    %0A%0A%0A%0AInstructions%0A---%0A1.%20Send%20this%20email%0A2.%20Wait%20for%20a%20response%20from%20Eventum%20to%20indicate%20the%20PTW%20has%20been%20created%0A3.%20Click%20the%20link%20in%20the%20email%20to%20the%20PTW%20case%2C%20and%20change%20the%20status%20to%20%22waiting%20approval%22%0A4.%20See%20approval%20from%20a%20PTW%20approver Click here]


Let's break it down:

    {{#show: {{PAGENAME}} | ?Secret Identity}}

This is a semantic mediawiki query, meaning "show me the property of the current page (i.e., "Batman") called "Secret Identity"

    {{urlencode:{{#show: {{PAGENAME}}|PATH}}}}

This returns out the name of the current page, URL-encoded with %20 replacing spaces

    {{canonicalurl:{{PAGENAME}}}}

This is a mediawiki function which outputs the URL to the specified page. No need to URL-encode it, it's already a URL!

Using all of the above, I used an [online mailto link generator](http://www.cha4mot.com/t_mailto.html) to mock up the email I wanted with placeholders, and then replaced the placeholders with the mediawiki black magic above

Example:

````
Subject: PAGENAME
Body:

Hi SECRETIDENTITY,

I know your real name. Send RANSOMAMOUNT to lex@luthorcorp.com ASAP,
or I'll tweet it to the world!

Yours in villany,
Lex luthorcorp
````
