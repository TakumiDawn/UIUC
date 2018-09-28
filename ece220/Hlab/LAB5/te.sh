#!/bin/bash
# A grader for MP1

module load lc3tools

if [![ -f prog1.asm ]] ; then
  echo 'The file "prog1.asm" does not exist.'
else
  echo 'The file "prog1.asm" exists.'
  lc3as prog1.asm
  diff myoutone testoneout
fi
