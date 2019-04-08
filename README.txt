# AddressTranslationAndIramCache


///////////////////////////////////////////////
Group 327
Ori Yeffet
Omri Dassa
///////////////////////////////////////////////

=============================================================================================================================================
Git reposetory content
=============================================================================================================================================
	Async FIFO ramp Task.
	Excel commit log file.
	Reports directory
	Synthesis logs directory
	Top level schems directory
	MAS directory
	Testbench directory


=============================================================================================================================================
Async FIFO ramp Task:
=============================================================================================================================================
FIFO - First In First Out - a Data Structure.
The task is a part of the ramp to Logic Design.
The task includes:
	1: Writing MAS - Micro Architectural Spec
	2: bring up of Design and Verification enviorment 
	3: advanced design concepts such as : CDC (clock domain crossing) , using a register file , ect.
	4: formal verification using Jasper tool.
	5: applying testbench.
	6: Code and MAS review.

verilog files reside in : ./async_fifo_task
MAS FILE is at : ./async_fifo_task
=============================================================================================================================================
Excel commit log file:
=============================================================================================================================================
as Intel doesnt aprove us to share its inner GIT system 
we will maintain a Excel commit log file with documentation of our commits in Intel inner git system.
updated - 8.4.19

=============================================================================================================================================
Reports directory:
=============================================================================================================================================
this folder contain all the report's that submitted by us to the course stuff

contain:
final_reportThirdYear
Group327_y3_presentation
midReportThirdYear
miniReportThirdYear
progress report 1
report1semesterA
progress report 2
progress report 3
Group327_y4_presentation
group327_y4_mid_year_report
DemoDayPresentation
progress report 4

=============================================================================================================================================
Synthesis logs directory:
=============================================================================================================================================
at this folder you can find Address Translation & IRAM Cache Synthesis tools logs.
the logs contain : information about - size (Flip Flop and Combinatorical cells count ) , timing (timeing of the logic paths of the design).

contain:
Address Translation :
area , timing, syntesis gates

Cache :
area , timing, syntesis gates

=============================================================================================================================================
Schemes directory:
=============================================================================================================================================
at this folder you will find the schemes of both Address Translation & IRAM Cache
the drawings are sited in a Microsoft Viso files: cache.vsdx, at.vsdx.

contain:
Address Translation (at.vsdx) content : 
 Top Level - p0, Top Level - p1 , final calculator , final wrapper for AT, AT_high_level.
	
IRAM Cache (cache.vsdx) content:
Oriantation , Top Level , detailed schemes.

=============================================================================================================================================
MAS directory:
=============================================================================================================================================
at this folder you can find Address Translation & IRAM Cache MASs

contain:
Empty
WIP - with Intel legal department 2.1.19
MAS cache - done 
MAS Address Translation - done
note that the finished mas is to the architectial demand we got so far.


=============================================================================================================================================
Testbench directory:
=============================================================================================================================================
at this folder one can find : Address Translation & IRAM Cache wave diagrams of the testbenches .

contain:
at_1 - basic test for mvp AT
cache_1 - basic test for mvp Cache


