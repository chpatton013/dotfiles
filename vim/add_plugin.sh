#!/bin/sh
# This script was derived from the work of Marc Zych (https://github.com/marczych)

if [ "$#" != "1" ]
then
   echo "Usage: $0 <git url>"
   exit
fi

REPONAME=`echo "$1" | sed 's/^.*\///' | sed 's/\..*$//'`

git submodule add $1 vim/bundle/$REPONAME
