#!/bin/bash
#
#
#     Created by A.Hodgson
#      Date: 2019/06/05
#      Purpose: Output various computer logs that are only exportable through the API
#  
#
######################################

##############################################################
#
# Log Export Options
#
##############################################################

#Screen Sharing
function screenSharing() # (serial)
{
	#call the API 
	callAPI "$1"

#create a template file to parse the XML response
cat << EOF > /tmp/stylesheet.xslt
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text"/>
	<xsl:template match="/">
		<xsl:for-each select="computer_history/screen_sharing_logs/screen_sharing_log">
			<xsl:text>$1</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="date_time"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="status"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="details"/>
			<xsl:text>
			</xsl:text>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
EOF

	#parse the API response and output the desired values based on the template above
	usageData=$( echo "$device_info" | xsltproc /tmp/stylesheet.xslt - )
	#output results
	outputData "$1" "$usageData" "$responseStatus"
}

#Jamf Remote
function jamfRemote() # (serial)
{
	#call the API
	callAPI "$1"

#create a template file to parse the XML response
cat << EOF > /tmp/stylesheet.xslt
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text"/>
	<xsl:template match="/">
		<xsl:for-each select="computer_history/casper_remote_logs/casper_remote_log">
			<xsl:text>$1</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="date_time"/>
			<xsl:text>, </xsl:text>
			<xsl:value-of select="status"/>
			<xsl:text>
			</xsl:text>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
EOF


	#parse the API response and output the desired values based on the template above
	usageData=$( echo "$device_info" | xsltproc /tmp/stylesheet.xslt - )
	#output results
	outputData "$1" "$usageData" "$responseStatus"
}


#Computer Usage
function computerUsage() # (serial)
{
	#call the API
	callAPI "$1"

#create a template file to parse the XML response
cat << EOF > /tmp/stylesheet.xslt
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text"/>
	<xsl:template match="/">
		<xsl:for-each select="computer_history/computer_usage_logs/usage_log">
			<xsl:text>$1</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="event"/>
			<xsl:text>, </xsl:text>
			<xsl:value-of select="username"/>
			<xsl:text>, </xsl:text>
			<xsl:value-of select="date_time"/>
			<xsl:text>
			</xsl:text>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
EOF


	#parse the API response and output the desired values based on the template above
	usageData=$( echo "$device_info" | xsltproc /tmp/stylesheet.xslt - )
	#output results
	outputData "$1" "$usageData" "$responseStatus"
}


#Policy Logs
function policyLogs() # (serial)
{
	#call the API
	callAPI "$1"

#create a template file to parse the XML response
cat << EOF > /tmp/stylesheet.xslt
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text"/>
	<xsl:template match="/">
		<xsl:for-each select="computer_history/policy_logs/policy_log">
			<xsl:text>$1</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="policy_name"/>
			<xsl:text>, </xsl:text>
			<xsl:value-of select="username"/>
			<xsl:text>, </xsl:text>
			<xsl:value-of select="date_completed"/>
			<xsl:text>, </xsl:text>
			<xsl:value-of select="status"/>
			<xsl:text>
			</xsl:text>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
EOF


	#parse the API response and output the desired values based on the template above
	usageData=$( echo "$device_info" | xsltproc /tmp/stylesheet.xslt - )
	#output results
	outputData "$1" "$usageData" "$responseStatus"
}


#Completed MDM Commands
function mdmCommands() # (serial)
{
	#call the API
	callAPI "$1"

#create a template file to parse the XML response
cat << EOF > /tmp/stylesheet.xslt
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text"/>
	<xsl:template match="/">
		<xsl:for-each select="computer_history/commands/completed/command">
			<xsl:text>$1</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="name"/>
			<xsl:text>, </xsl:text>
			<xsl:value-of select="completed"/>
			<xsl:text>
			</xsl:text>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
EOF


	#parse the API response and output the desired values based on the template above
	usageData=$( echo "$device_info" | xsltproc /tmp/stylesheet.xslt - )
	#output results
	outputData "$1" "$usageData" "$responseStatus"
}

##############################################################
#
# Serial Option Functions
#
##############################################################

#CSV Option
function CSVreader() # (serialCSV)
{
	#read serial CSV into array
	IFS=$'\n' read -d '' -r -a serialnumbers < $serial_CSV
	length=${#serialnumbers[@]}

	#process all serial numbers in array and call desired log option function
	for ((i=0; i<$length;i++));
	do
		#trim the fat
		serial=$(echo ${serialnumbers[i]} | sed 's/,//g' | sed 's/ //g'| tr -d '\r\n')
		#call appropriate function for log option
		case $log_option in
			1)
				screenSharing "$serial"
				;;
			2)
				jamfRemote "$serial"
				;;
			3)
				computerUsage "$serial"
				;;
			4)
				policyLogs "$serial"
				;;
			5)
				mdmCommands "$serial"
				;;
		esac
	done
}

#single Serial Option
function singleSerial() # (serial)
{
	#call appropriate function for log option
	case $log_option in
		1)
			screenSharing "$1"
			;;
		2)
			jamfRemote "$1"
			;;
		3) 
			computerUsage "$1"
			;;
		4)
			policyLogs "$1"
			;;
		5)
			mdmCommands "$1"
			;;
esac
}

##############################################################
#
# Processor Functions
#
##############################################################

function callAPI() # (serial)
{
	#notify user in terminal of progress
	echo "Processing serial number: $1"
	#get device information from the API
	device_info=$(curl --write-out "%{http_code}" -sku "Accept: text/xml" -u "$apiUser":"$apiPass" "$jssURL/JSSResource/computerhistory/serialnumber/$1")
	responseStatus=${device_info: -3}
	#trim response status off the information
	device_info=$(sed 's/.\{3\}$//' <<< "$device_info")
}

function outputData() # (serial, API data, response status)
{
	#write log entries to output file
	if [ "$3" == "404" ] 
	then
		echo "$1,Serial Number Not Found" >> "$file"
	elif [ "$3" == "200" ]
	then 
		if [ -z "$2" ]
		then
			echo "$1,No Data" >> "$file"
		else
			echo "$2" >> "$file"
		fi
	else
		echo "Device not found in Jamf"
		echo "Device not found in Jamf" >> "$file"
	fi
}

##############################################################
#
# Main Function
#
##############################################################

#prompt user for variables
read -p "Enter your Jamf Pro URL (eg. https://example.jamfcloud.com or https://onprem.jamfserver.com:8443): " jssURL
read -p "Enter a username used for authentication to the API: " apiUser
#user password hidden from terminal
prompt="Please enter your API user password: "
while IFS= read -p "$prompt" -r -s -n 1 char 
do
if [[ $char == $'\0' ]];     then
    break
fi
if [[ $char == $'\177' ]];  then
    prompt=$'\b \b'
    apiPass="${password%?}"
else
    prompt='*'
    apiPass+="$char"
fi
done
echo ""

#check the status of the API credentials before proceeding, exit script if fails
echo "Validating API credentials...."
apiCreds=$(curl --write-out %{http_code} --silent --output /dev/null -sku "Accept: text/xml" -u "$apiUser":"$apiPass" "$jssURL/JSSResource/activationcode")
if [ "$apiCreds" == "200" ]
then
	echo "Validated, proceeding."
	echo ""
else
	echo "Credentials or URL not valid, please try again. Exiting script...."
	exit 0
fi

#prompt user for log option and loop until we have a valid option 
while true; do
	echo "Log Report Options:"
	echo "1 - Screen Sharing"
	echo "2 - Jamf Remote"
	echo "3 - Computer Usage"
	echo "4 - Policy Logs"
	echo "5 - Completed MDM Commands"
	read -p "Please enter an option number: " log_option

	case $log_option in 
		1)
			break
			;;
		2)
			break
			;;
		3)
			break
			;;
		4)
			break
			;;
		5)
			break
			;;
		*)
			echo "That is not a valid choice, try a number from the list."
			echo ""
     		;;
    esac
done

#file format and output
loggedInUser=$(/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }')
dt=$(date +"%a, %h %d, %Y  %r")

#format based save file based on logging option
case $log_option in
	1)
		filename="Screen Sharing Logs - $dt.csv"
		#set the file location
		file="/Users/$loggedInUser/Downloads/$filename"
		#write header values
		echo "Serial Number,Date/Time,Status,Details" >> "$file"
		;;
	2)
		filename="Jamf Remote Logs - $dt.csv"
		#set the file location
		file="/Users/$loggedInUser/Downloads/$filename"
		#write header values
		echo "Serial Number,Date/Time,Status" >> "$file"
		;;
	3)
		filename="Computer Usage Logs - $dt.csv"
		#set the file location
		file="/Users/$loggedInUser/Downloads/$filename"
		#write header values
		echo "Serial Number,Event,Username,Date/Time" >> "$file"
		;;
	4)
		filename="Computer Policy Logs - $dt.csv"
		#set the file location
		file="/Users/$loggedInUser/Downloads/$filename"
		#write header values
		echo "Serial Number,Policy Name,Username,Date Run,Status" >> "$file"
		;;
	5)
		filename="Completed Computer MDM Commands - $dt.csv"
		#set the file location
		file="/Users/$loggedInUser/Downloads/$filename"
		#write header values
		echo "Serial Number,Command Name,Date/Time Completed" >> "$file"
		;;	
esac
echo "" 

#prompt user for serial option and loop until we have a valid option 
while true; do
	echo "Serial Number Options:"
	echo "1 - Single Serial Number"
	echo "2 - CSV of Serial Numbers"
	read -p "Please enter an option number: " serial_option

	case $serial_option in 
		1)
			break
			;;
		2)
			break
			;;
		*)
			echo "That is not a valid choice, try a number from the list."
			echo ""
     		;;
    esac
done
echo ""


#call necessary functions for a single serial number or process a CSV
case $serial_option in
	1) 
		read -p "Please enter your serial number: " sn
		singleSerial $sn
		;;
	2)
		read -p "Drag and drop your CSV of Serial Numbers: " serial_CSV
		CSVreader $serial_CSV
		;;
esac

#output results file
echo ""
echo "Results stored to $file"