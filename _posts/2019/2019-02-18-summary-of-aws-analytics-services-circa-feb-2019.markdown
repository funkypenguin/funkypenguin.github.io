---
layout: "post"
title: "Summary of AWS Analytics services circa Feb 2019"
date: "2019-02-17 09:19"
excerpt: "In preparation for the AWS Certified Solutions Architect - Professional, I read up on all the AWS Analytics services, summarised each in my own words.."
image:
  path: /images/aws_analytics.jpg
  caption: <A HREF='https://www.flickr.com/photos/cgpgrey/4890649506/'>Lego People</A> by <A HREF='http://www.cgpgrey.com/'>GCPGrey.com</A>
category:
  - notes
tags:
  - aws
---
In preparing to take the "[AWS Certified Solutions Architect - Professional](https://aws.amazon.com/certification/certified-solutions-architect-professional/)" exam, I found myself reading through the whitepapers and reference architectures.

The "[Overview of Amazon Webservices](https://docs.aws.amazon.com/aws-technical-content/latest/aws-overview/introduction.html)" whitepaper describes the 140 (!) [currently available AWS services](https://docs.aws.amazon.com/aws-technical-content/latest/aws-overview/amazon-web-services-cloud-platform.html), so I thought I'd note down below my own description of each service and how it's priced.

This post covers only the "Analytics" services. See followup posts for more services ;)

* Analytics (this post)
* Application Integration
* AR and VR
* AWS Cost management
* Blockchain
* Business Applications
* Compute Services
* Customer Engagement
* Database
* Desktop and App Streaming
* Developer Tools
* Game Tech
* Internet of Things (IoT)
* Machine Learning
* Management and Governance
* Media Services
* Migration and Transfer
* Mobile Services
* Networking and Content Delivery
* Robotics
* Satellite
* Security, Identity, and Compliance
* Storage

<div class="panel radius" markdown="1">
**Table of Contents**
{: #toc }
*  TOC
{:toc}
</div>

## Amazon Athena (Serverlessly query structured data with SQL)

[Amazon Athena](https://aws.amazon.com/athena/) makes structured data (_CSV, log files_) stored in S3 queryable via SQL. The use case might be analysing raw data (_think millions of rows of CSV_) without having to "_massage_" the data into a relational database first. You're [charged $5/TB](https://aws.amazon.com/athena/pricing/?nc=sn&loc=3) of data scanned for your query, with a minimum of 10MB (_so smallest charge would be $0.00005_).

## Amazon EMR (Managed Big Data framework)

[Amazon EMR](https://aws.amazon.com/emr/) _(Elastic MapReduce_) is a managed data analytics framework for performing big-data analysis of your S3 "_data lake_" (_structured/unstructured data sprayed into an S3 bucket_). It's a **managed** service in that EMR handles the building/management/scaling of the [Hadoop](https://searchdatamanagement.techtarget.com/definition/Hadoop) / [Spark](https://searchdatamanagement.techtarget.com/definition/Apache-Spark) cluster (_by spinning up/down EC2 instances_), leaving you to play with the higher functions like plugging in 3rd-party analysis tools, running queries, and **using** the cluster to perform your big data analysis.  

You're [charged per-second per cluster instance](https://aws.amazon.com/emr/pricing/?nc=sn&loc=4) (_there are a few instance variants_), and you pay standard EC2 pricing for the EC2 instances required to run your instance.

(_TIL: Hadoop was named after co-creator Doug Cutting's son's toy elephant_)

## Amazon CloudSearch (Managed search service for your website/apps)

[Amazon CloudSearch ](https://aws.amazon.com/cloudsearch/)is a managed service for providing a "search" function in an app or website. It includes all the machinery scrape your target data (_say, 1,000,000 cat photos in S3, or your 10-year-old forum history_), build indexes, execute queries, and scale up / down based on demand. You're [charged per hour](https://aws.amazon.com/cloudsearch/pricing/) that CloudSearch instance is running (_there are a few instance variants_), and you pay "as you go" to upload data into the instance, rebuild indexes, and transfer data "in" and "out" of CloudSearch.

## Amazon Elasticsearch Service (Managed Elasticsearch cluster)

[Amazon Elasticsearch Service](https://aws.amazon.com/elasticsearch-service/) is a managed ElasticSearch cluster for performing analysis of data (i.e., logs via logstash). You access your instance via the Elasticsearch API, so it "_just works_" with popular Elasticsearch cohorts like Kibana, logstash. The service integrates with your **other** AWS services (_Lambda, Firehose, Cloudwatch, etc_). You're [charged per hour per cluster instance](https://aws.amazon.com/elasticsearch-service/pricing/?nc=sn&loc=3) (_there are **many** instance variants_), and you can run the _t2.small.elasticsearch_ instance under the [AWS Free Tier](https://aws.amazon.com/free/).


## Amazon Kinesis

[Amazon Kinesis](https://aws.amazon.com/kinesis/) is a managed service to process streaming data (_e.g. telemetry from IoT devices, or video streams from traffic cams_). There are 4 capabilities available:

### Amazon Kinesis Data Streams (Low-level, flexible platform for streamed data processing)

[Amazon Kinesis Data Streams](https://aws.amazon.com/kinesis/data-streams/) is the base service which acts as the "building block" for the subsequent 3 capabilities. Data Streams receives your streaming data (_scaling on demand_), and provides the capability to perform realtime analytics, trigger Lambda functions, send it to Apache Spark in EMR, etc. You are [charged based on your number of "shards"](https://aws.amazon.com/kinesis/data-streams/pricing/) (relates to throughput) as well as PUTs. You can also pay additional "shard hours" to increase your stream data retention from 24 hours (_default_) all the way to 72 hours (_maximum_). Here's a diagram:

![](https://d1.awsstatic.com/Products/product-name/diagrams/product-page-diagram_Amazon-Kinesis-Data-Streams.074de94302fd60948e1ad070e425eeda73d350e7.png)

### Amazon Kinesis Data Firehose (Simple version of Data Streams for common use case)

[Amazon Kinesis Data Firehose](https://aws.amazon.com/kinesis/data-firehose/) is a "_simplified_" service built on Data Streams (_above_), intended to be easier to use for the most common use-case : streaming data into S3, RedShift, ElasticSearch or Splunk. There's no analytics in the pipeline - any analysis you want to do on the data has to be done _after_ the data has been sent to its destination (_you **can** send the same data to multiple destinations, i.e., S3 **and** Redshift_). However, you can [use Lamba to do lightweight transformation of the data](https://aws.amazon.com/blogs/compute/amazon-kinesis-firehose-data-transformation-with-aws-lambda/) before it's delivered to S3 and friends. Pricing is simple - [you're charged](https://aws.amazon.com/kinesis/data-firehose/pricing/) for the amount of data ingested (_S3, Redshift etc are priced separately_). Here's a diagram:

![](https://d1.awsstatic.com/Products/product-name/diagrams/product-page-diagram_Amazon-Kinesis-Data-Firehose.9340b812ab86518341c47b24316995b3792bf6e1.png)

### Amazon Kinesis Data Analytics (Perform realtime analytics on data stream)

[Amazon Kinesis Data Analytics](https://aws.amazon.com/kinesis/data-analytics/) is the analysis component of Kinesis, which can perform realtime analytics against incoming Data Stream. Data can be analysed using SQL queries, or Java libraries which integrate with a suite of other AWS tools (_S3, DynamoDB, etc_). You're [charged per hour per Kinesis Processing Unit (KPU)](https://aws.amazon.com/kinesis/data-analytics/pricing/), being an instance with 1 vCPU and 4GB RAM. KPUs auto-scale based on demand, and you're charged an additional KPU if you use Java, for application orchestration. Here's a diagram:

![](https://d1.awsstatic.com/Products/product-name/diagrams/product-page-diagram_Amazon-Kinesis-Data-Analytics.cf473c775449f721253e75499195c8a8dfb3d86c.png)

### Amazon Kinesis Video Streams (Video-specific stream processing featuring machine learning and recognition)

[Amazon Kinesis Video Streams](https://aws.amazon.com/kinesis/video-streams/) provides the ability to ingest **video** data for analysis and storage. It provides a SDK-based method for manufacturers to get data _into_ AWS, and integrates with Amazon's Machine Learning and video recognition services. You are [charged simply based on data ingested, consumed, and stored](https://aws.amazon.com/kinesis/video-streams/pricing/). Here's a diagram:

![](https://d1.awsstatic.com/Products/product-name/diagrams/product-page-diagram_Amazon-Kinesis-video-streams_how-it-works.5f5eaca85b3026303a5c3f34ef004c0a136bc526.png)

## Amazon Redshift (Managed data warehouse)

[Amazon Redshift](https://aws.amazon.com/redshift/) is a managed data warehouse service ("data warehouses" are for structured data, while "_data lakes_" for raw data). It plugs into traditional BI tools, scales up while offering excellent performance at low prices. Interestingly, "Redshift Spectrum" allows you to run queries against structured data stored in S3, as well as traditional EBS volumes which support Redshift. Snapshots of your data warehouse can also be backed up to S3. You're [charged nothing for the RedShift service](https://aws.amazon.com/redshift/pricing/), just the underlying EC2 and EBS elements which comprise your cluster.

## Amazon Quicksight (Managed business intelligence / reporting)

[Amazon Quicksight](https://aws.amazon.com/quicksight/) is a managed business intelligence (BI) service. You feed it your data (_be it twitter trends, on-premise spreadsheets, or existing data in AWS_), and use it to "author" dashboards for your users to consume. There's some machine learning (ML) involved, to augment your analytics. You're [charged per-author](https://aws.amazon.com/quicksight/pricing/) on a monthly basis, and per-session on a user basis.


## AWS Data Pipeline (Automate transfer / transform of data in/out of AWS services)

[AWS Data Pipeline](https://aws.amazon.com/datapipeline/) is a managed ETL (_Extract-Transform-Load_) service, which automates the movement of your data. Data Pipeline includes a "visual pipeline builder, and you might use it, for example, to grab your CloudWatch logs from S3, transform them into a structured format, and then push them into Redshift for data warehousing. Pricing seems [almost a giveaway](https://aws.amazon.com/datapipeline/pricing/), and obviously you pay for the related AWS services that Data Pipeline would utilise (_S3, RedShift, etc_).

## AWS Glue (Like Data Pipeline but vastly improved with ML, serverless, etc)

[AWS Glue](https://aws.amazon.com/glue/) is the "_cool cousin_" of Data Pipeline. It's also used for ETL, but it can "discover" the structure of your semi-structured data by crawling it, and then generates code (which you can change) to perform transformations. For example, you could use Glue to ingest your webserver logs from S3, "enrich" the data by tying customer account ID to your CRM data, and then export the data in a structured form into Redshift. As a "serverless" service, you p[ay for the resources used to run your ETL jobs](https://aws.amazon.com/glue/pricing/) only while they're running. You also pay minimally for crawling and storing schemas.

## AWS Lake Formation (Automates and simplifies the setup of data lakes)

[AWS Lake Formation](https://aws.amazon.com/lake-formation/) (_in preview_) is a high-level service which abstracts much of the complexity of creating and managing a "_data lake_". Lake Formation covers crawling your existing datasets for schemas, cleaning/de-duping/sorting and then migrating data into the data lake, plus all the security elements re _who_ may access _what_ data.

## Amazon Managed Streaming for Kafka (MSK) (Managed Kafka cluster)

[Amazon Managed Streaming for Kafka (MSK)](https://aws.amazon.com/msk/) is a managed Kafka cluster service (_Kafka supports traditional message brokering as well as "[streams](https://kafka.apache.org/documentation/streams/)"_). MSK provides a ready-to-go Kafka cluster configured to best practices. You [pay per-broker, per hour](https://aws.amazon.com/msk/pricing/), based on broker instance size.
