#!/bin/bash

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Help messages:
usage="$(basename "$0") [-h] -- program to install conda packages based on requirements.txt file.

Use the following commenting line:
# conda install xyz
to run a conda install.

Arguments:
    -h  show this help text
    -d  dummy run" 

dummy=false

while getopts ':hd' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    d) dummy=true
        ;;
    :) printf "missing argument for -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
done
shift $((OPTIND - 1))

requirements=$1

# The main program starts from here:

function print_current_conda_env () {
    echo "Your current conda env is:"
    while read -r line
    do
        if [[ ${line} =~ .*\* ]]
        then
            echo "${line}"
        fi
    done <<< "$(conda env list)"
}

print_current_conda_env

while read line 
do
    if [[ ${line} =~ ^\#[[:space:]]conda[[:space:]]install ]]
    then 
        cmd=${line:2}

        if [ "${dummy}" = true ]
        then
            echo 
            echo ">> (Dummy) Installing: ${cmd}"
        else
            echo 
            echo ">> Installing: ${cmd}"
            ${cmd}
        fi
    fi
done < ${requirements}



