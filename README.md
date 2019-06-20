# ComputerHistoryExporter Script

This script leverages the Jamf Pro API to export a variety of logs that are not exportable from web UI. 

Log Options
1. Screensharing Logs
1. Jamf Remote Logs
1. Computer Usage Logs
1. Policy Logs
1. Completed MDM commands

You will need a Jamf Pro user account with at least read access to computers and a Jamf Pro url (Cloud hosted or on-prem).

Option to process a single serial number or a CSV of serial numbers.

#### API calls eat up server resources, this script will make 1 API call device. It is advised to use caution before proceeding during heavy traffic times of the day if processing a large number of devices. 

## Process to run script
1. Open Terminal 
1. Type "sudo bash /path/to/ComputerHistoryExporter.sh"
1. Fill in data as prompted.
1. Data will be be in created output file: "/Users/~loggedInUser~/Downloads/~LogOption-Date.csv"
