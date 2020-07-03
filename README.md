# Patch-Analysis-Script
Bash Script for running checkpatch.pl using Commit IDs or direct file names as parameters.

## Steps to run the script
Place the script in the root of linux kernel folder.
Then run chmod to make it executable.
``` chmod +x panalysis.sh ```

Usage
``` ./panalysis.sh [-g <git commit id>] [-f <file(.c or .patch) name or directory>] ```
  
 For example :
 ``` ./panalysis.sh -g c0a3132963db68f1fbbd0e316b73de100fee3f -f drivers/staging/fbtft/ ```
