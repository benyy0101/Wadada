#!/bin/bash

GIT_ROOT_DIRECTORY=$(git rev-parse --show-toplevel)
echo ${GIT_ROOT_DIRECTORY}

echo "step 1. Configurating git hooks" 
cp -f ${GIT_ROOT_DIRECTORY}/infra/prepare-commit-msg ${GIT_ROOT_DIRECTORY}/.git/hooks
if [ $? -ne 0 ]; 
then
    echo "Error occured. Contact to infra engineer in your team."
    exit 1
else
    echo "Git hook config done."
fi

echo "step 2. Identifying diff between bigcase and smallcase" 
git config core.ignorecase false
if [ $? -ne 0 ]; 
then
    echo "Error occured. Contact to infra engineer in your team."
    exit 1
else
    echo "Git ignorecase config done."
fi
