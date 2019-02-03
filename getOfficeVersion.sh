#!/bin/sh
if [ -d /Applications/Microsoft\ Word.app ] ; then
    RESULT=$( sudo defaults read /Applications/Microsoft\ Outlook.app/Contents/Info.plist CFBundleShortVersionString )
    echo "<result>$RESULT</result>"
else
    echo "<result>Not Installed</result>"
fi