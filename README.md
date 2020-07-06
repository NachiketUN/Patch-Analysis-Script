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

## Non-merge commits in linux kernel v5.7

1. Storing a list of non-merge commit ids in a file.
```
git log --oneline --pretty="%h" --no-merges  v5.6..v5.7 > tag.txt
```
2. Storing all the warning message types in a file.
```
./scripts/checkpatch.pl --list-types > message_types.txt
```
3. Run genpatch.sh which generates patch files, runs checkpatch.pl, aggregates the warnings using a hashmap and outputs a file with warnings and their corresponding count. 
```
./genpatch.sh
```

### File Descriptions
1. error_report.txt     -         contains the warnings and corresponding count(no of times a warning occured in analysis)
2. tag.txt              -         list of Non-merge commits in linux kernel v5.7
3. message_types.txt    -         list of warnings outputed by running ```./scripts/checkpatch.pl --list-types```
4. genpatch.sh          -         script which runs patch analysis on non-merge commits in v5.7
5. panalysis.sh         -         script to run checkpatch.pl on commit id or a file.

### Results
The most common warnings and their count are as below.
1) COMMIT_LOG_LONG_LINE - 112
2) QUOTED_WHITESPACE_BEFORE_NEWLINE - 24
3) LONG_LINE - 23
