---
layout: "post"
title: "Summary of AWS Application Integration services circa Feb 2019"
date: "2019-02-17 09:19"
excerpt: "In preparation for the AWS Certified Solutions Architect - Professional, I read up on all the AWS Application Integration services, summarised each in my own words.."
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

<div class="panel radius" markdown="1">
**Table of Contents**
{: #toc }
*  TOC
{:toc}
</div>

---
This post covers only the "_Application Integration_" services. See the followup posts in this series for more services ;)

* [Analytics](/notes/summary-of-aws-analytics-services-circa-feb-2019/)
* [Application Integration](/notes/summary-of-aws-application-integration-services-circa-feb-2019/) (this post)
* [AR and VR](/notes/summary-of-aws-ar-vr-services-circa-feb-2019/)
* [AWS Cost management](/notes/summary-of-aws-cost-management-services-circa-feb-2019/)
* [Blockchain](/notes/summary-of-aws-blockchain-services-circa-feb-2019/)
* [Business Applications](/notes/summary-of-aws-business-applications-services-circa-feb-2019/)
* [Compute Services](/notes/summary-of-aws-compute-services-circa-feb-2019/)
* [Customer Engagement](/notes/summary-of-aws-customer-engagement-services-circa-feb-2019/)
* [Database](/notes/summary-of-aws-database-services-circa-feb-2019/)
* [Desktop and App Streaming](/notes/summary-of-aws-desktop-and-app-streaming-services-circa-feb-2019/)
* [Developer Tools](/notes/summary-of-aws-developer-tools-services-circa-feb-2019/)
* [Game Tech](/notes/summary-of-aws-game-tech-services-circa-feb-2019/)
* [Internet of Things (IoT)](/notes/summary-of-aws-iot-services-circa-feb-2019/)
* [Machine Learning](/notes/summary-of-aws-machine-learning-services-circa-feb-2019/)
* [Management and Governance](/notes/summary-of-aws-management-and-governance-services-circa-feb-2019/)
* [Media Services](/notes/summary-of-aws-media-services-circa-feb-2019/)
* [Migration and Transfer](/notes/summary-of-aws-migration-and-transfer-services-circa-feb-2019/)
* [Mobile Services](/notes/summary-of-aws-mobile-services-circa-feb-2019/)
* [Networking and Content Delivery](/notes/summary-of-aws-networking-and-cdn-services-circa-feb-2019/)
* [Robotics](/notes/summary-of-aws-robotics-services-circa-feb-2019/)
* [Satellite](/notes/summary-of-aws-satellite-services-circa-feb-2019/)
* [Security, Identity, and Compliance](/notes/summary-of-aws-security-services-circa-feb-2019/)
* [Storage](/notes/summary-of-aws-storage-services-circa-feb-2019/)

---

## AWS Step Functions (Yahoo Pipes for AWS services)

[AWS Step Functions](https://aws.amazon.com/step-functions/) visually join the output of one AWS function (say, a Lambda function) to another (AWS Glue, for example). The Step Function tracks success/failure of each step along the "pipeline", and can retry/debug failed steps. Step functions comprised of multiple, simple Lamba functions are preferable to single, complex Lamba functions. You [pay based on the amount of "state transitions"](https://aws.amazon.com/step-functions/pricing/) across your functions, and and the first 4,000 transitions are free.

## Amazon MQ (Managed Apache ActiveMQ message broker)

[Amazon MQ](https://aws.amazon.com/amazon-mq/) is a managed instance of [Apache ActiveMQ](http://activemq.apache.org/), an open-source message broker supporting advanced features and multiple open standards (MQTT, Stomp, etc). [You pay per-instance](https://aws.amazon.com/amazon-mq/pricing/), and the smallest instance (_mq.t2.micro_) is free under the [Free Tier](https://aws.amazon.com/free/).

## Amazon Simple Queue Service / SQS (Amazon-baked message broker/queuing)

[Amazon Simple Queue Service (SQS)](https://aws.amazon.com/sqs/) is Amazon's own queuing system (_unlike managed Apache MQ, above_). It's serverless, and [you pay per-request](https://aws.amazon.com/sqs/pricing/), starting with 1,000,000 free requests per month. SQS probably offers tighter integration with other AWS services than MQ (_for example, AWS Lambda [now supports SQS as an event source](https://aws.amazon.com/about-aws/whats-new/2018/04/aws-lambda-now-supports-amazon-sqs-as-event-source/)_).

## Amazon Simple Notification Service/SNS (Push-based pub/sub many-to-many messaging)

[Amazon Simple Notification Service (SNS)](https://aws.amazon.com/sns/) is Amazon's managed pub/sub system, intended to manage the "heavy lifting" of "fanning out" push-based messages to multiple notification recipients. You'd use SNS to power your app's push notifications, or to send password-reset emails from your website. As with SQS, SNZ is serverless, and [you pay per-notification](https://aws.amazon.com/sns/pricing/), starting with 1,000,000 free notifications per month, and ~$1 per one million notifications thereafter.

## Amazon Simple Workflow Service/SWF (Background task execution/pipelining)

[Amazon Simple Workflow Service/SWF](https://aws.amazon.com/swf) manages the background execution of a series of automated tasks. You [pay per workflow execution](https://aws.amazon.com/swf/pricing/), with 1,000 free workflows to start.

Here's one of Amazon's possible use cases:

> Video encoding using Amazon S3 and Amazon EC2. In this use case, large videos are uploaded to Amazon S3 in chunks. The upload of chunks has to be monitored. After a chunk is uploaded, it is encoded by downloading it to an Amazon EC2 instance. The encoded chunk is stored to another Amazon S3 location. After all of the chunks have been encoded in this manner, they are combined into a complete encoded file which is stored back in its entirety to Amazon S3. Failures could occur during this process due to one or more chunks encountering encoding errors. Such failures need to be detected and handled through Amazon SWF's cloud workflow management.
