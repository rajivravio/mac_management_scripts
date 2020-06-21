#!/bin/bash

IFS=', ' read -r -a postInstallPID <<< "$postInstallPIDstr"

for element in "${postInstallPID[@]}"
do
    echo "$element"
done