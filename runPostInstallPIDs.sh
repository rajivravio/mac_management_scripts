#!/bin/bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# This script was designed to be used in a Self Service policy to run sets of Policies  
# on macOS machines. This is useful for users to update machines in a familiar way and for 
# techs to provide Office update instructions/troubleshoot.
#
# VERSION: v1.4
#
# REQUIREMENTS:
#           - Jamf Pro
#           - MAU  running version 2.0 or later
#           - Look over the USER VARIABLES and configure as needed. 
#
#
# Written by: Rajiv Ravishankar | NUQ 
#
# Created On: July 8th, 2019
# Updated On: July 8th, 2019
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#

##Run user defined post-install tasks
postInstallPIDstr="$4"

##Split the srting of Jamf policy IDs into an iterable array
IFS=', ' read -r -a postInstallPID <<< "$postInstallPIDstr"
for element in "${postInstallPID[@]}"
do
	/usr/local/jamf/bin/jamf policy -id "$element"
done