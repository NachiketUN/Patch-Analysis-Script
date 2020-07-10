#!/bin/bash
read -p 'Commits File: ' filename
filelines=`cat $filename`  #reading the commit id file
#generates patch_file for every commit and runs checkpatch.pl
#Aggregates errors and warnings using awk
for line in $filelines ;
do 
 #echo $line
 #line=b08418b54831
 patch_file=$(git format-patch -1 $line 2>/dev/null)
 patch_result=$(perl ./scripts/checkpatch.pl --show-types $patch_file)
 rm -rf $patch_file  #deleting the generated patch file

errors=$(echo "$patch_result" |awk -v li=$line -F":" '/ERROR/ {severity=$1; type=$2; desc=$3; getline; file=$3; line=$4; getline; print "\""li"\"" "| " "\""severity"\"" "| " "\""type"\"" "| " "\""file"\"" "| " "\""line"\"" "| " "\""desc"\"" "| " "\""$0"\"" "| "}')
warnings=$(echo "$patch_result" |awk -v li=$line -F":" '/WARNING/ {severity=$1; type=$2; desc=$3; getline; file=$3; line=$4; getline; print "\""li"\"" "| " "\""severity"\"" "| " "\""type"\"" "| " "\""file"\"" "| " "\""line"\"" "| " "\""desc"\"" "| " "\""$0"\"" "| "}')
if ! [[ -z "$errors" ]]; then
echo "$errors" >> result.csv
fi

if ! [[ -z "$warnings" ]]; then
echo "$warnings" >> result.csv
fi

#if [[ "$line" == "b08418b54831" ]]; then
#   break
#fi

done

