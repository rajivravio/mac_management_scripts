#!/bin/bash

#This script checks for the 2018-001 Apple Security patch for Meltdown on macOS.
#If it is not present then it checks to see if the user is on High Seirra (10.13)
#which has the patch built in.

if grep -q '2018\-001' /Library/Receipts/InstallHistory.plist; then
   echo "<result>patched</result>"
else
   if grep -q '10\.13' /System/Library/CoreServices/SystemVersion.plist; then
      echo "<result>patched</result>"
   else
      echo "<result>unpatched</result>"
   fi 
fi
