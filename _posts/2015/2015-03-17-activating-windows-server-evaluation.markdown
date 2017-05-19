---
layout: page
title: "Activating Windows Server Evaluation"
categories:
  - note
header: no
tags:
  - windows
date: "2015-03-17"
excerpt: No, you can't just "activate" an Evaluation version
---
Internally, our build process for Windows Servers (2012r2 in this case) is to build the VM on the Evaluation media available from Microsoft, and then apply the licence during the grace period.

It turns out that you can't "Activate" an Evaluation copy of Windows Server with a Production licence - it's not valid.

The "Activation" (which is automatically done on an evaluation version) is for the Evaluation product.

I followed a [technet][1]
 article detailing how to change editions from Evaluation to Full.

 For example, I ran the following command

 ``` DISM /online /Set-Edition:ServerStandard /ProductKey:XXXXX-XXXXX-XXXXX-XXXXX-XXXXX /AcceptEula ```


   [1]: https://technet.microsoft.com/en-us/library/jj574204.aspx
