#!/bin/sh -f

for home in $(ls /Users | grep -v nuqadmin | grep -v Shared | grep -v cadmin | grep -v root | grep -v Guest | grep -v student)
do
	rm -r /Users/$home
done