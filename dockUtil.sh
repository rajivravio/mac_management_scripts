#!/bin/bash

###############################################################################################################
#
# DESCRIPTION: dockUtil.sh is a script that adds and removes dock icons to match student lab defaults. Script
# requires dockutil to be installed to work.
# Minimum requirements: macOS 10.13
#
##############################################################################################################


# Putting Self Serfice
/usr/local/bin/dockutil --add /Applications/Self\ Service.app

# Putting Adobe Photoshop 2018
/usr/local/bin/dockutil --add /Applications/Adobe\ Photoshop\ CC\ 2018/Adobe\ Photoshop\ CC\ 2018.app

# Putting Outlook 
/usr/local/bin/dockutil --add /Applications/Microsoft\ Outlook.app

# Putting Microsoft Word 
/usr/local/bin/dockutil --add /Applications/Microsoft\ Word.app

# Putting Microsoft Excel 
/usr/local/bin/dockutil --add /Applications/Microsoft\ Excel.app

#Putting Microsoft Power Point
/usr/local/bin/dockutil --add /Applications/Microsoft\ PowerPoint.app

# Putting Adone Premiere Pro 2018
/usr/local/bin/dockutil --add /Applications/Adobe\ Premiere\ Pro\ CC\ 2018/Adobe\ Premiere\ Pro\ CC\ 2018.app

# Remove Photoshop 2017 from Dock station
/usr/local/bin/dockutil --remove 'Adobe Photoshop CC 2017'

# Remove Premiere Pro 2017 from Dock station
/usr/local/bin/dockutil --remove 'Adobe Premiere Pro CC 2017'

# Remove Maps from Dock station
/usr/local/bin/dockutil --remove 'Maps'

# Remove Photos from Dock station
/usr/local/bin/dockutil --remove 'Photos'

# Remove Pages from Dock station
/usr/local/bin/dockutil --remove 'Pages'

# Remove Numbers from Dock station
/usr/local/bin/dockutil --remove 'Numbers'

# Remove Keynote from Dock station
/usr/local/bin/dockutil --remove 'Keynote'