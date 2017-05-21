---
layout: post
category: link
date: 22-05-2017 11:57:27
title: "How Basic Performance Analysis Saved Us Millions - Heap Blog"
excerpt: "The significant saving in money and performance that can be gained by questioning assumptions."
tags: ""
link: "https://blog.heapanalytics.com/basic-performance-analysis-saved-us-millions/"
---


> This suggests a simple change we could make: **instead of inserting all of the events individually, we could batch insert many events going to the same table**. By using a single command to insert many events, Postgres would only need to fetch and parse the index metadata once per batch. We had thought of batching our inserts before to reduce transaction counts, but never to save CPU resources, as we assumed all the CPU was going towards evaluating index predicates.

> Initial benchmarks of batched inserts showed a 10x reduction in CPU usage. Once we obtained these results, we began testing the batched inserts in production. Ultimately, we did get about a 10x improvement to ingestion throughput when using batches of an average size of ~50 events. Here is what our ingestion latency for different kafka partitions looked like right before and after we deployed batching

Impressive, the the significant saving in money and performance that can be gained by questioning assumptions:

 <cite>- [How Basic Performance Analysis Saved Us Millions - Heap Blog](https://blog.heapanalytics.com/basic-performance-analysis-saved-us-millions/)</cite>