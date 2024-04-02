#!/bin/bash

set -euo pipefail

git config -f .gitmodules --get-regexp '^submodule\..*\.path$' |
    while read path_key path
    do
        url_key=$(echo $path_key | sed 's/\.path/.url/');
        branch_key=$(echo $path_key | sed 's/\.path/.branch/');

        if [ ! $(git config --get "$url_key") ]; then
            if [ -d "$path" ] && [ ! $(git config --get "$url_key") ]; then
                mv "$path" "$path""_backup_""$(date +'%Y%m%d%H%M%S')";
            fi;
            url=$(git config -f .gitmodules --get "$url_key");

            branch=$(git config -f .gitmodules --get "$branch_key");
            if [ ! "$branch" ]; then branch="master"; fi;

            git submodule add -f -b "$branch" "$url" "$path";
        fi;
    done;