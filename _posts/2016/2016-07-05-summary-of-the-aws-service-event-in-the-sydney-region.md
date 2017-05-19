---
layout: post
date: 2016-07-05 17:58:19
title: "Electricity is hard. Test failure rigorously"
tags: postmortem
category: postmortem
---
In the [Summary of the AWS Service Event in the Sydney Region]( http://aws.amazon.com/message/4372T8), I read:

> A latent bug in our instance management software led to a slower than expected recovery of the remaining instances. The team worked over the next several hours to manually recover these remaining instances. Instances were recovered continually during this time, and by 8AM PDT, nearly all instances had been recovered.

Latent bugs which are harmless under BAU conditions can be massively damaging under failure conditions.

> Normally, when utility power fails, electrical load is maintained by multiple layers of power redundancy. Every instance is served by two independent power delivery line-ups, each providing access to utility power, uninterruptable power supplies (UPSs), and back-up power from generators. If either of these independent power line-ups provides power, the instance will maintain availability. During this weekend’s event, the instances that lost power lost access to both their primary and secondary power as several of our power delivery line-ups failed to transfer load to their generators. These particular power line-ups utilize a technology known as a diesel rotary uninterruptable power supply (DRUPS), which integrates a diesel generator and a mechanical UPS. Under normal operation, the DRUPS uses utility power to spin a flywheel which stores energy. If utility power is interrupted, the DRUPS uses this stored energy to continue to provide power to the datacenter while the integrated generator is turned on to continue to provide power until utility power is restored. The specific signature of this weekend’s utility power failure resulted in an unusually long voltage sag (rather than a complete outage). Because of the unexpected nature of this voltage sag, a set of breakers responsible for isolating the DRUPS from utility power failed to open quickly enough. Normally, these breakers would assure that the DRUPS reserve power is used to support the datacenter load during the transition to generator power. Instead, the DRUPS system’s energy reserve quickly drained into the degraded power grid. The rapid, unexpected loss of power from DRUPS resulted in DRUPS shutting down, meaning the generators which had started up could not be engaged and connected to the datacenter racks.

A detailed explanation of a non-computer (power) failure.

> While we have experienced excellent operational performance from the power configuration used in this facility, it is apparent that we need to enhance this particular design to prevent similar power sags from affecting our power delivery infrastructure. In order to prevent a recurrence of this correlated power delivery line-up failure, we are adding additional breakers to assure that we more quickly break connections to degraded utility power to allow our generators to activate before the UPS systems are depleted.

Remediation of the non-computer failure.

> We will also be starting a program to regularly test our recovery processes on unoccupied, long-running hosts in our fleet. By continually testing our recovery workflows on long-running hosts, we can assure that no latent issues or configuration setting exists that would impact our ability to quickly remediate customer impact when instances need to be recovered.

It's good practice to perform failure / restore tests, and unused / dev / low-load hosts are a good candidate for "real world" tests. We perform routine simulations of various failure scenarios (hardware and power), over extended periods (i.e. one day, rather than 30 minutes) to detect latent non-critical faults. Recently this testing uncovered a latent issue in a highly-available email platform which had historical configuration differences, resulting in service impact for a small subset of customers. This fault would not have been apparent in a brief (usually after-hours) failover test.