#!/bin/bash
# A WIP to be developed as the semester goes on
# When downloading all zip submissions from canvas, students often incorrectly name their zip files the requested format
# This is to handle cases where such an issue is particularly excessive ! Many things below can be automated, but are kept
# simple as the goal was to identify and document, not necessarily fix it automatically.

for file in *.zip; do

	rmSpaces=${file// /}
	id=$(echo "$rmSpaces" | sed -E 's/.+[-_]([a-zA-Z]{3}[0-9]{3})(-[0-9]+)?\.zip/\1/')
	holder="a1-$id.zip"
	mv -- "$file" "a1-$id.zip"
	
	if unzip -o "$holder" '*.bash' -d "a1-$id"; then
		rm -rf "a1-$id.zip"
	else
		echo "Failed to extract from a1-$id.zip" 2>/dev/null
	fi
	
	if find . -name "__MACOSX" -type d; then
		echo "Student $id -- mac2unix before running." 2>/dev/null
	elif find . -name ".DS_Store" -type d; then
		echo "Student $id -- dos2unix before running." 2>/dev/null
	fi

done

find . -name ".*.sw[a-z]" -type f -delete
