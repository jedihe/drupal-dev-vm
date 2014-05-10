#!/bin/sh

#
# Usage:
# testrunner.sh TestClass /path/to/testclass/dir
#                                               ^ (no trailing slash)
#

while inotifywait -qq --exclude=".(swp|txt)" -e modify $2 -r; do
  phpunit $1 $2/tests/$1.php
  echo "Last run on $(date)"
done
