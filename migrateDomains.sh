#!/bin/sh

# Name:  migrateDomains.sh
# Date:  06 Feb 2016 v1.0
# Author:  Steve Wood (swood@integer.com)  https://www.jamf.com/jamf-nation/discussions/11061/migration-from-old-ad-domain-to-new-domain
# Edited by: Rajiv Ravishankar (rrs@northwestern.edu/rajivravio@gmail.com)
# Purpose:  used to move users from Qatar  domain to a ADS/Qatar/Computers
#
# Prequisites:  
# 	You'll need a policy in your JSS check policy #714 Standard - Bind to ADS in Qatar JSS for details
# 	Wired connection - Add feature to confirm eth0 active?
#	Hostname < 15 characters - Add feature to check compliance?

# Globals & Logging 
LOGPATH='/Library/Logs'  # change this line to point to your local logging directory
if [[ ! -d "$LOGPATH" ]]; then
    mkdir $LOGPATH
fi
set -xv; exec 1> $LOGPATH/movedomainslog.txt 2>&1  # you can name the log file what you want
version=1.1
oldAD='qatar.northwestern.edu'
currentAD=`dsconfigad -show | grep -i "active directory domain" | awk '{ print $5 }'`

# let the user know what we are doing

banner=`/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType hud -title "Moving Domains" -heading "Moving Domains Header" -description "We are moving your user account from QATAR to ADS.  When we are completed, and your computer restarts, you will be able to login to your computer with your new domain credentials. Please contact helpdesk@qatar.northwestern.edu for assitance if you have trouble logging in" -button1 "Proceed" -button2 "Not Now" -defaultButton 1 -cancelButton 2 -timeout 180 -countdown` 

if [[ $banner == "2" ]]; then

    echo "User canceled the move."
    exit 1

fi

# Grab current user name
loggedInUser=`/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }'`

##### if you do not have OD deployed you can remove the follwing lines
# unbind from LDAP
# sinc there is no easy way to determine if bound to OD, we will just run against our OD for good measure

#dsconfigldap -r <YOUR OD DOMAIN>
#####

# ensure time is set from the same server as the dc. Change this to whatever time server is relevent
# on reuse
ntpdate -u time.northwestern.edu


# unbind from AD
# check to see if we are bound to our current AD or not.  If not we can skip this

if [[ "$currentAD" = "$oldAD" ]]; then

    # remove the config for our old AD
    # you need a user in your AD that has the rights to remove computers from the domain
    # first we try to remove it clean from QATAR but it that fails we try to force. The force leaves
    # cruft in the Qatar domain after unbind but in this particular migration we do not care
    # please remove the second -remove command when reusing this script for other migrations

    dsconfigad -remove $oldAD -username svc.ad.bind -password 7gCAHA\)E=g6Di6YF7.tFY6sb
    dsconfigad -remove $oldAD -force -u xxx -p xxx

fi

# remove the local user from the machine so we get the proper UID assigned in dscl
dscl . delete /Users/$loggedInUser

# bind to new AD
# using a JAMF policy to bind to the new AD. The policy numbe ris important. Take care when resuing this script 
# to ensure this is accounted for
jamf policy -id 714

# last ditch effort to manually bind if jamf is unreachable
dsconfigad -a adstest3_vm -u nuq.svc.bind -p bigger!than!ever!be4 -ou "OU=Computers,OU=Qatar,DC=ads,DC=northwestern,DC=edu" -domain ads.northwestern.edu -mobile enable -localhome enable -useuncpath enable -groups "Domain Admins,Enterprise Admins" -alldomains enable # can also use a custom trigger for the policy

# reset permissions
### some of the code below is courtesy of Ben Toms (@macmule)

###
# Get the Active Directory Node Name
# This step is known to fail when a computer record already exists in ads
# The permission reset that follows locks users out adNodeName, domainUsersPrimaryGroupID, accountUniqueID
# If re-using the script, add logic to break execution of the chown if those variables are empty
###
adNodeName=`dscl /Search read /Groups/Domain\ Users | awk '/^AppleMetaNodeLocation:/,/^AppleMetaRecordName:/' | head -2 | tail -1 | cut -c 2-`

###
# Get the Domain Users groups Numeric ID
###

domainUsersPrimaryGroupID=`dscl /Search read /Groups/Domain\ Users | grep PrimaryGroupID | awk '{ print $2}'`

accountUniqueID=`dscl "$adNodeName" -read /Users/$loggedInUser 2>/dev/null | grep UniqueID | awk '{ print $2}'`

###
# to-do add break logic to prevent chown when no nodename/GI or UID available here
###

chown -R $accountUniqueID:$domainUsersPrimaryGroupID /Users/$loggedInUser

# restart the computer when done
# to make sure everything is working properly we will restart
# this is sectioned off since the restart has been set through jamf
# uncomment if you wish to use the script manually or if you wish to check the logs before restart
# logs located in /Library/Logs/	

#shutdown -r now