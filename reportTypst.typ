#import "lib/common.typ": course, prjName
#import "lib/reportLib.typ": config, firstPage, tableOfContentPage

#firstPage(prjName)

#tableOfContentPage(imageList: false, tableList: false)

#show: config.with()

/*
Example of questions that your report is
expected to address.
• How do you store updates?
• How do you manage timeouts?
• How do you control crashes?
• What operations does a new coordinator perform?
• How do you ensure election does not block forever?

short report of 3–4 pages (max. 6 pages)

Provided sections are example and can be changed. Default were:
• Project Structure
• System Design
• Implementation
• Information about the use of LLM tools (the only one that is mandatory)


Can add all packages you want
*/

#include "chapters/01_Read_Write_Mgmt.typ"
#include "chapters/02_Coordinator_Election.typ"
#include "chapters/03_Crash_Mgmt.typ"
#include "chapters/04_LLM.typ"
