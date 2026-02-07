#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Usage: ./test.bash <fileName.ext>"
	exit 1
fi

file=$1

# Find any empty fields within the txt file
while IFS=',' read -r f1 f2 f3; do
	counter=$(( $counter + 1 ))

	# Print out any lines w/ empty fields
	if [[ -z $f1 || -z $f2 || -z $f3 ]]; then
		echo "Line $counter:  $f1, $f2, $f3"
	fi

	# Checks if field 1 is anything but valid device types && not empty
	if [[ -n $f && ! $f1 =~ ^(tablet|television|mobile phone|laptop|computer|projector|vehicle)$ ]]; then	
		echo "Line $counter: $f1, $f2, $f3"
	fi
	
	# Checks whether or not Serial Number fits format: SN-[32 nums/chars]
	if [[ ! $f3 =~ ^SN-([a-zA-Z0-9]{32})$ && -n $f3 ]]; then
		echo "Line $counter: $f1, $f2, $f3"
	fi

done < "$file"

# This assigns a "key" [valid manufacturers] to specific devices. Adjust as needed.
# In the end, this creates a new file called "mismatch.txt" that holds said mismatched 
# devices/manufacterers to avoid watching 5000 lines generate at the speed of light. 
awk -F',' 'BEGIN { 
	valid["mobile phone"] = "OnePlus LG Samsung Apple Xiaomi Vivo Google Huawei Motorola Sony"
	valid["tablet"] = "Sony Apple Samsung Microsoft Lenovo LG Acer Asus OnePlus"
	valid["television"] = "Insignia Samsung LG Sony Xiaomi TCL Hisense VIZIO"	
	valid["laptop"] = "HP Apple Dell Lenovo Acer Asus Microsoft Samsung IBM Gateway"
	valid["computer"] = "HP Apple Dell Lenovo Acer Asus Microsoft Samsung IBM Gateway"
	valid["projector"] = "Dell Panasonic Epson BenQ Sony Optoma ViewSonic"
	valid["vehicle"] = "Chevorlet Ford KIA Jeep Hyundai GM"
}
{
	device = $1
	manufacturer = $2

	if (valid[device] !~ "(^| )" manufacturer "( |$)") {
		print  "Line: " NR, $0
	}
}' $file > mismatch.txt
