#!/bin/sh

/usr/bin/id -u <CN>
sleep 3
/usr/bin/id -u <CN2>
sleep 3

UIDCHECK=`id -u <CN>`
DOMAIN=$( dsconfigad -show | awk '/Active Directory Domain/{print $NF}' )
COUNT=0

while [[ "$UIDCHECK" != <UID OF CN> ]]; do
	
	if [[ "$COUNT" == 10 ]]; then
	    exit
	fi
	
    if [[ "$DOMAIN" == "DOMAIN" ]]; then
        /usr/sbin/dsconfigad -username <SVC ACC> -password <PASSWORD> -remove -force
        sleep 10
    fi
    
    /usr/bin/dscacheutil -flushcache 
    /usr/bin/killall -HUP mDNSResponder
    /usr/sbin/dsconfigad -add <DOMAIN> -computer "`hostname -s`" -mobile enable -mobileconfirm disable -force -username <SVC ACC> -password <PASSWORD> -ou "OU=,OU=,DC=,DC=,DC="
    UIDCHECK=`id -u <CN>`
    ((COUNT++))
    echo "$COUNT"
    sleep 10
done


