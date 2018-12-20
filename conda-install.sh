#!/bin/bash
requirements=$1

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
        echo 
        echo ">> Installing: ${cmd}"
        ${cmd}
    fi
done < ${requirements}



