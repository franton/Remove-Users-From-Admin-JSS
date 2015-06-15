#!/bin/bash

# Script to grab the authorised admin users and remove admin rights from all other users.

# Author      : contact@richard-purves.com
# Version 1.0 : 15-06-2015 - Initial Version

# Set up needed variables here

localadmin="root,admin"
ethernet=$(ifconfig en0|grep ether|awk '{ print $2; }')
apiurl=`/usr/bin/defaults read /Library/Preferences/com.jamfsoftware.jamf.plist jss_url`
apiuser="apiuser"
apipass=""

# Grab user info from extension attribute for target computer and process.

# Retrieve the computer record data from the JSS API

cmd="curl --silent --user ${apiuser}:${apipass} --request GET ${apiurl}JSSResource/computers/macaddress/${ethernet//:/.}"
hostinfo=$( ${cmd} )

# Reprogram IFS to treat commas as a newline

OIFS=$IFS
IFS=$','

# Now parse the data and get the usernames

adminusers=${hostinfo##*Admin Users\<\/name\><type>String</type><value>}
adminusers=${adminusers%%\<\/value\>*}

# Parse that variable into an array for easier processing

read -a array <<< "$adminusers"
array+=($localadmin)

# Set IFS back to normal

IFS=$OIFS

# Loop to check name(s) are present on the mac and process them out of the admin group.  

# Start by looping round all users in /Users 

for Account in `ls /Users`
do

# Zero the exemption flag variable. We operate on the presumption of guilt here!

exempt=0

# Ok now generate a for loop based on the array we set up earlier.

	for (( loop=0; loop<=${#array[@]}; loop++ ))
	do

	# Does the user in the array match the current user in "Account"?

		if [[ $Account == ${array[$loop]} ]];
		then
		# Account is authorised. Flag as exempt from demotion
			exempt=1
		fi
	done

	# Check for exemption.

	if [ $exempt = 0 ];
	then
		echo "removing "${array[$loop]}" from admin group"
		dseditgroup -o edit -d "${array[$loop]}" -t user admin
	else
		echo "account "${array[$loop]}" is authorised to have these rights"
	fi

done

# Finished!

exit 0
