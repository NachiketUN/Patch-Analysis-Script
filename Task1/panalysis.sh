#!/bin/bash

usage() { echo "Usage: $0 [-g <git commit id>] [-f <file(.c or .patch) name or directory>]" 1>&2; exit 1; }
if [ ! -f ./scripts/checkpatch.pl ]; then
  echo "Run this script in root of your linux git folder"
  exit 1;
fi
while getopts ":g:f:" o; do
    case "${o}" in
        g)
            g=${OPTARG}
            patch_file=$(git format-patch -1 --pretty=fuller $g 2>/dev/null)
            result=$?
            if [ $result -ne 0 ]; then
              echo "Commit ID is invalid"
              usage
              exit 1;
            else
              echo "Generating patch from commit"
            fi
            ;;
        f)
            file=${OPTARG}
            if [ ! -e "$file" ]; then
                echo "$file does not exist"
                usage
                exit 1;
            fi
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ ! -z "${patch_file}" ]; then
  perl ./scripts/checkpatch.pl $patch_file
fi
if [ ! -z "${file}" ]; then
  if [[ $file == *.c ]] || [[ $file == *.patch ]]; then
    perl ./scripts/checkpatch.pl $file
  else
    perl ./scripts/checkpatch.pl ${file}*
  fi
else
  usage
fi

echo "-------------End of Checkpatch output---------------"
