#!/bin/bash
if readlink $0; then
  MYREALPATH=`readlink $0`
  MYDIR=`dirname $0`/`dirname $MYREALPATH`
else
  MYDIR=`dirname $0`
fi
ROOT=`dirname $0`/..
SCANDIR=$ROOT/src
pmd pmd -d $SCANDIR -f csv -R $MYDIR/apex-security-ruleset.xml | $MYDIR/pmd-post-process.rb $1