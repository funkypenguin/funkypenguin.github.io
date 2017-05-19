---
layout: post
category: postmortem
date: 2016-08-19 12:40:50
title: "Spacecraft and IT systems fail for the same reasons"
excerpt: "Surprisingly common factors affect the failure of both"
tags: failure, bias
---

In [SOHO MISSION INTERRUPTION FAILURE INVESTIGATION](http://umbra.nascom.nasa.gov/soho/SOHO_final_report.html), I read the fascinating postmortem of the near-loss of the SOHO observatory due to what can only be described as basic operational process fails. (The craft was later [spectacularly recovered](http://soho.nascom.nasa.gov/about/Recovery/))

The story of the fail, commented, below:

![SOHO observatory](https://www.funkypenguin.co.nz/images/soho-observatory.jpg)

## What went wrong
In summary, human error compounded on human error, and resulting poor judgement resulted in the wrong corrective action being taken, which ultimately resulted in loss of all telemetry to the spacecraft.

> Problems encountered in other programs using similar gyros led to introduction of additional changes following launch to further preserve gyro lifetime.

​The standards were changed during the life of the program.

> The difference with the events leading to this incident was that the operation had been compressed into a continuous sequence. This required a new script and first time utilization of paths within previously modified procedures.

​Amount of change to a routine well-known process was a contributing factor, as was the "compressed" timeline (do more in less time, which pressures staff to take shortcuts)

> Due to an omission in the modified predefined command sequence actually used, the onboard software function that activates the gyro needed by ESR was not enabled. This omission resulted in the removal of the functionality of the normal safe mode and ultimately caused the catastrophic sequence of events.

​Omissions are harder to detect than errors, and even careful peer-reviews can miss them. Automated monitoring (in addition to human expertise) is required to prevent minor oversights becoming massive disasters.

> Following the momentum management maneuver, Gyro B, which is used for fault detection, was erroneously left in its high gain setting, resulting in an indicated roll rate of 20 times greater than actual. The incorrect gain was due to an error in another predefined command sequence; this error resulted in an on-board fault detection output that triggered an ESR.

​When you change routine processes, or use established processes in new ways, previously unknown issues can surface, and given the right circumstances, combine to create failure. Mitigation is ensuring review and standards are applied to even routine processes, every time.

> The personnel on the ground were not aware of either of these facts at that time.

​Monitoring that's not detailed enough (or too noisy!) can drown out the critical information, reducing the value of the monitoring.

> A rapid decision was made that Gyro B was faulty because its output disagreed with the rate indicated by Gyro A. This decision led to the commanding off of Gyro B.

My takeaway here is that the decision was ___rapid___ - a knee-jerk response without careful examination and evaluation. As we'll note later, the information on the state of Gyro A was available, but was "too hard to interpret" or was not evaluated carefully, due to assumption bias (the cause of the discrepancy was believed to be known, so alternative possibilities were not tested). 

A correlation to IT from [Prophecy](http://www.prophecy.net.nz)'s experience is that when a virtual machine exhibits symptoms associated with under-resourcing (sluggish response, high CPU load), simply adding more resource can either create [further problems](http://www.gabesvirtualworld.com/how-too-many-vcpus-can-negatively-affect-your-performance/), or simply mask an underlying root cause (like an actual software fault).

> The incorrect diagnosis of a Gyro B fault and the subsequent ground response to this diagnosis ultimately resulted in loss of attitude control, subsequent loss of telemetry, and loss of power and thermal control

​There you go. The faulty diagnosis is the root of all further failures (although there were other contributing factors)

> At any time during the over five hour emergency situation, the verification of the spinning status of Gyro A would have precluded the mishap.

​Monitoring is invaluable. But you have to ___look___ at it, ___interpret___ it, and ___trust___ it.
​
## Contributing factors

> Though some of these modifications were made at the request of the SOHO Science Team, they were not necessarily driven by any specific requirement changes. The procedure modifications appear to have not been adequately controlled by ATSC configuration board, properly documented, nor reviewed and approved by ESA and/or NASA. The verification process was accomplished using a NASA computer-based simulator. There was no code walk-through as well as no independent review either by ESA, MMS, or an entity directly involved in the change implementation. No hard copy of the command procedure set exists, and the latest versions are stored electronically without adequate notification of procedure modifications.

This is huge. The takeaway:

1. Changes were made without clear requirements / justification.
2. Insufficient care was taken to ensure that the changes would not have a negative impact.
3. When procedures were updated, they were simply refreshed electronically, and there was no formal notification that the processes had changed.

> multiple ground operations procedures were modified. Each change was considered separately, and there appears to have been little evaluation performed to determine whether any of the modifications had system reliability or contingency mode implications; or whether the use of this modified procedure set should have been accompanied with operational constraints.

Multiple system changes were effected without regard for interactions with other systems. Potential mitigation would be when the change set is too large, a top-down review is necessitated.

### Lack of change control

> The functional content of an operational procedure, A_CONFIG_N, was modified without updating the procedure name and without communicating either to ESA or MMS the fact that there had been a functional change. Consequently, a cursory review of a ground operations script of procedure names, rather than a review of the commands generated by the procedure, contributed to the initiation of a calamitous sequence of events. The A_CONFIG_N procedure had been developed to simply reconfigure the three roll gyros after calibration; however, the procedure had also been modified to provide options to perform gyro spin down.

The documentation was out of date, and changes had not been effectively communicated.

> Unfortunately, this software enable command had not been included as part of the modification to A_CONFIG_N due to a lack of system knowledge of the person who modified the procedure. Coupled with the inadequate change review process described above and the fact that the enable command was missing, the likely impact of not enabling Gyro A in this procedure was not recognized.

Lack of adequate peer review from subject-matter experts.

### Pressure causes poor decision-making

> The operations team did not take advantage of the 48 hour minimum safe mode design, and initiated recovery almost immediately after each of the two emergency safe mode entries that occurred prior to the loss of the spacecraft. The operations team did not appear to respect the seriousness of the safe mode entries. It is to be noted that in March 1998, a similar shortcut in the recovery from ESR 3 led to ESR 4. Recovery had been effected without long-term spacecraft impact, thus developing a false sense of confidence in the operations team in the ability to recover from an ESR.

So there was a by-design 48-hour window intended to asses a problem before initiating a recovery. By acting too fast to resolve a problem based on overconfidence, a catastrophic problem was created. Operations staff are motivated to respond quickly and to "fix problems", but this motivation can create artificial pressure which leads to poor judgement. If systems have multiple levels of redundancy, we should use this redundancy to provide time for clear-headed responses.

### Early failure indications were ignored

> It is noted that the previous ESRâs 3 and 4 had also been triggered by ground software problems and that a recommended comprehensive review of the software and procedures had not been implemented due to higher priorities given to other tasks of the FOT.

Warning signs (previous failures) were ignored due to other tasks being prioritised.

> In fact, analysis indicated that this condition had occurred several months prior and no one had recognized this change in the spacecraft configuration.

Inadequate monitoring or monitoring wasn't trusted (due to noise?).

## Established processes were not followed

> The operations script specifically states that the Gyro A is to be spinning upon entry into safe mode and instructs the operator to evaluate the three telemetry frames that had been stored prior to the anomaly before proceeding toward recovery.
> 
> Neither the confirmation of Gyro A state nor the evaluation of the three previous telemetry frames was performed. These omissions resulted in a failure to notice that Gyro A was not spinning - a state which rendered the safe mode unstable.

Failure to follow documented procedure, possibly due to carelessness or casual familiarity with the routine.

> Standard procedure requires a Materials Review Board (MRB) before such a critical action (a declared key component failure) can be taken. The MRB would have provided a formal process for senior management and engineering staff to review and decide on the risks involved. An MRB was not convened.

Standard procedure was not followed, shortcuts were taken, and the very thing that the MRB was established to prevent is what happened.

> This ambitious plan included the calibration of three gyros and a momentum management event performed in a compressed timeline never attempted previously, a yaw maneuver that exceeded previously established positional offset bias constraints, a 24-hour roll maneuver, phased reaction wheel maintenance, momentum management, a station keeping maneuver, and the loading of a star sensor software patch. The plan was to execute this timeline using the SOHO core team with no augmented staff. The planned activities were intensive and there was no contingency time built into the schedule.

Sounds like a typical sales/commercial-driven push on ops and engineering to deliver results on a tight timeline with no extra resources, resulting in predictable errors in judgement and shortcuts taken.

> Due to the compressed nature of the gyro calibration and the momentum management, neither the ESA technical support manager, the MMS engineer, nor the FOT had the time available to analyze the results of the gyro calibrations. Therefore, valuable information that should have been factored into the recovery scenario was not taken into consideration.

People are human. Increase the pressure, increase the mistakes. Protect by establishing "gates" (like the MRB described above, which was ignored) to enforce procedures are followed.

> The second safe mode trigger (ESR-6) occurred while the MMS engineer was trouble shooting discrepancies between NASA and ESA simulator results required for the upcoming science maneuver, and responding to a science investigator's need to service his instrument. These caused a distraction; yet no one directed that the plan should be aborted until all of the problems could be better understood. Clearly in their haste to continue, inappropriate decisions were made, an autonomous safety net was disabled, and the spacecraft was inappropriately commanded leading to the loss of communications with the SOHO spacecraft. Ironically, the motivation for the aggressive flight operations plan was to restore the spacecraft to perform science as quickly as possible.

Pressure from the "customer" causes the operational / support staff to make hasty decisions, which ultimately causes disaster for the "customer". Effective leadership's role in this case would have been to command the slowing down of response, the disregard of the immediate "urgent" issues in favour of the "important" ones (proper understanding of the fault before acting).

> The level of support is judged not commensurate with the intent that ESA retain full responsibility for the health and safety of the spacecraft. They were understaffed to perform this function in other than routine situations.

Under-resourcing support staff leads to resource bottlenecks and poor results and in non-routine situations.

> The Mission Management Plan requires that the NASA project operations director be responsible for programmatic matters, to provide "overall technical direction" to the FOT, and to "interface" with the ESA technical support manager. The position has been descoped over time by NASA from a dedicated individual during launch and commissioning, to one NASA individual expending less than 10% of his time tracking SOHO operations. In addition, this position changed hands five times throughout the life of the mission; the most recent change occurring three weeks prior to the event... A direct result of this operational structure was the lack of clear leadership in the handling of contingency situations.

It's hardly a surprise that there was a lack of leadership if the new guy (as of 3 weeks ago) is allocated less than 10% of his time on the project. 10% of three weeks is 12 hours. To manage a ___spacecraft___.

> The transfer of management authority to the SOHO Project Scientist resident at GSFC left no manager, either from NASA or ESA, as the clear champion of spacecraft health and safety.

In IT terms, the customer was given the task of dictating the priorities and resources devoted to maintaining the infrastructure they relied on, instead of the IT service provider.

> There were significant training opportunities for the original FOT staff; however as turnover occurred, training opportunities became more limited.

Lack of training / upskilling / induction / skills transfer lead to a degradation of system familiarity and proficiency.

> These conditions were worsened by the ATSC decision to eliminate the Lead Engineer position and distribute Lead Engineer responsibilities across Observatory Engineers and the Flight Operations Manager. The FOT was left without any clear management focus and with decreasing flexibility in the allocation and execution of work assignments.

Cost-cutting efforts resulted in a lack of clear leadership and management focus.

> A deficiency report that was written in 1994, stating that the SOHO control center was unable to display this data in a convenient (user friendly) format, was never resolved.

Old issues ignored undermine the reliability of the system. The usability of the monitoring platform is as important as its functionality. There's no point monitoring something in a way that can't be interpreted.

> As part of the planning of the ambitious timeline for the week of June 24, the NASA simulator was unable to independently substantiate the planned sequence of events. In fact, the NASA simulation results indicated that problems existed in the planned timeline. Analysis of the differing simulation results (ESA vs. NASA simulator runs) was continuing as the timeline execution was in process. This, in itself, was an indirect factor in the failure scenario since the technical support staff were distracted by the on-going simulation evaluation rather than focusing on the ESR recovery efforts.

Testing in dev indicated issues in production deployment, but the production implementation went ahead ___while___ techincians were trying to make it work in dev.

> It is further noted that the simulator had not been maintained with all on-board software changes that had been implemented on the spacecraft.

Dev environment did not match production environment.

## Actions to avoid future failure

> 1. An ESA and NASA review of the process for SOHO operational procedure change should be implemented forthwith. The review should critically assess the process from beginning to end. The review should include matters such as who can initiate a change, who agrees it should be made, how is the modification process monitored, how is it validated, how is it introduced into operations, how it is signed-off, how are the users of the procedure informed of the change, and how are users trained on the new version.

Changes to established procedure can produce more failure than no procedures. Effective change management process (including signoff) is required.

> ESA and NASA should re-assess staffing to ensure it is commensurate with the complexity and criticality of the SOHO mission and consistent with the updated Mission Management Plan. The staffing should be strengthened as required. Surge capability should exist to support non-routine and contingency operati

Staffing should align with the complexity and criticality of supported system, with room to "burst" on non-routine and contingency operations.

> 2. The operations scripts (the string of procedures used by the FOT) for other than routine science operations should be put under configuration control and any change formally approved by ESA and NASA. Each time such a script is changed, the whole script should be validated.

Formal change control and retesting required.

> 4. ESA/ESOC should lead an independent assessment of the capabilities of the NASA SOHO simulator and provide recommendations for suggested maintenance and enhancements.

Make dev match prod.

> If possible, automatic monitoring should be extended to all telemetry.

Monitor what you care about.

> An ESA and NASA board should review all outstanding Ground System Problem Reports and the plans to close them.

Ensure all known faults are resolved.

> ESA and NASA flight operations personnel should be conversant with both the ESA and NASA systems to the maximum extent possible to form a more synergistic, integrated team.

Training and skills-transfer are critical.