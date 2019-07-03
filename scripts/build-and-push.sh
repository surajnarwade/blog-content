#!/bin/bash
#
# This script takes in commit message as an argument and then builds the
# website using hugo. Copies the output to the repo of website and does.
# Commits output in both repos and then pushes it to the origin master

# Script Reference: https://raw.githubusercontent.com/surajssd/blog_contents/master/hack/build-and-publish.sh
set -euo pipefail

function err() {
  echo "$@" >&2
}

function commit() {
  git add .
  git commit -m "$@"
  git push origin master
}

# check if the commit message was provided
msg="$*"
if [[ -z "${msg}" ]]; then
  err "please provide a commit message"
  exit 1
fi

repo="surajnarwade.github.io"

hugo
cp -r public/* ../${repo}/
commit "${msg}"

cd ../${repo}/
commit "${msg}"
