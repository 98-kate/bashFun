#!/bin/bash

fileSize=0;
blkSz=4096;
ptrSz=4;

read -p "Enter file size (e.g. 64): " fileNumSize
read -p "Enter data unit type (KB, MB, or GB): " dataUnit
# Takes a file size (e.g. 734.15) and depending on storage unit type 
# performs conversion of file size to Bytes. 
# If dataUnit == GB then 734.15*2^30 and fileSize == 788287560089.60 
# "bc <<<" -> heredoc string to send directly to stdin, uses default scale=0 -> not good for FP
# echo -> runs w/ flags and ideal for FP-math/precise devision, output piped as stdin to bc

maths() {
# Division for dataBlocks=ceil(fileSize/blockSize)
dataBlocks=$(perl -e "use POSIX; print ceil($fileSize/$blkSz)")
echo "Number of data blocks (# of direct pointers): $dataBlocks"

ptrsPerBlk=$(perl -e "use POSIX; print $blkSz / $ptrSz")
blksDirectPtrs=$(perl -e "use POSIX; print ceil(($dataBlocks-12) / $ptrsPerBlk)")
echo "Blocks of direct pointers (# of indirect pointers needed): $blksDirectPtrs"

blksIndirectPtrs=$(perl -e "use POSIX; print ceil(($blksDirectPtrs-1) / $ptrsPerBlk)")
echo "Blocks of indirect pointers (# of double indirect pointers needed): $blksIndirectPtrs"

blksDbIndirectPtrs=$(perl -e "use POSIX; print ceil(($blksIndirectPtrs-1) / $ptrsPerBlk)")
echo "Blocks of double indirect pointers (# of triple indirect pointers needed): $blksDbIndirectPtrs"

totalBlocks=$((dataBlocks + blksDirectPtrs + blksIndirectPtrs + blksDbIndirectPtrs))
echo "Total blocks needed: $totalBlocks"
}

case "${dataUnit^^}" in
  "KB") fileSize=$(echo "scale=2; $fileNumSize*(2^10)" | bc -l) maths ;;
  "MB") fileSize=$(echo "scale=2; $fileNumSize*(2^20)" | bc -l) maths ;;
  "GB") fileSize=$(echo "scale=2; $fileNumSize*(2^30)" | bc -l) maths ;;
   *) echo "Invalid data unit type provided: Use KB, MB, or GB only." ;;
esac
