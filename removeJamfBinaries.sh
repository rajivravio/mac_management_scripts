#!/bin/sh

#Update the off board flag for jss inventory
defaults write /Library/Preferences/com.studentoffboarding.plist scriptWasRun -bool YES

#Update the jss inventory + extension attributes
jamf recon

#Deleting the object from the jss is a manual step that needs to be done after this one.
jamf removeFramework
