#!/bin/bash
filename=tag.txt
filelines=`cat $filename`  #reading the non-merge commit id file
declare -A arr   #declaring a hashmap for storing different warning types
messages_lines=`awk '{print $2}' message_types.txt` # reading the file which contains diff warning types
for message in $messages_lines ;
do
  arr[$message]=0
done
total_num_warnings=0
#generates patch_file for every commit and runs checkpatch.pl
#Aggregates errors and warnings using awk
for line in $filelines ;
do 
 #echo $line
 patch_file=$(git format-patch -1 $line 2>/dev/null)
 patch_result=$(perl ./scripts/checkpatch.pl --show-types $patch_file)
 rm -rf $patch_file  #deleting the generated patch file


 errors=$(echo "$patch_result" | awk -F":" '/ERROR/{print $1}')
 warnings=$(echo "$patch_result" | awk -F":" '/WARNING/{print $2}')
 #num_warnings=$(echo "$patch_result" | awk '/total/{print $4}')
 total_num_warnings=$(())
 #echo $line $warnings
 #Storing the warnings ingathered in a hashmap
 for warn in $warnings ;
 do
   if ! [[ -z $warn ]]; then
   arr[$warn]=$((arr[$warn]+1))
   fi
 done
 #if [[ "$line" == "bf71bc16e021" ]]; then
 #  break
 # fi
done

#Finding the most reported error
max=Message
min=Message
for i in ${!arr[@]};
do
  echo $i ${arr[$i]} >> "error_report.txt"
  (( ${arr[$i]} < ${arr[$min]} )) && min=$i
  (( ${arr[$i]} > ${arr[$max]} )) && max=$i
done
echo "Most reported error is $max and it occurs ${arr[$max]} times"
echo "Most reported error is $max and it occurs ${arr[$max]} times" >> "error_report.txt"
