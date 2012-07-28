#!/bin/sh

if [ "$#" != "1" ]
then
   echo "Usage: $0 <git url>"
   exit
fi

REPONAME=`echo "$1" | sed 's/^.*\///' | sed 's/\..*$//'`

git submodule add $1 vim/.vim/bundle/$REPONAME
