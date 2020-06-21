#!/bin/sh -f

if [ ! "$1" = "cadmin" ] && [ ! "$1" = "root" ] && [ ! "$1" = "nuqadmin" ] && [ ! "$1" = "student" ]
then rm -r /Users/$1
fi