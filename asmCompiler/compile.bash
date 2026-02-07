#!/bin/bash

if [ $# -ne 2 ]; then
	echo "Usage: ./compile.bash <fileName.asm> <executable name>"
	exit 1
fi

fileName=$1
baseName=$(basename "$fileName" .asm)
objFile="${baseName}.o"
EXEC=$2

# Grabs extension of provided file
fileExt="${fileName#*.}"

if [ "$fileExt" != "asm" ]; then
	echo "ERROR: This script is for assembly files only."
	exit 1
else
	nasm -f elf32 "$fileName" -o "$objFile"
	ld -m elf_i386 "$objFile" -o "$EXEC"
fi
