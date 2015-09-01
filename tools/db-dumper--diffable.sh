#!/bin/bash

#
# Usage: script.sh /path/to/output/dir DBname
#                                     ^ (no trailing slash!)
#
# DBName is used for DBUser and DBPass, host is localhost.
#

#set -x

#
# Usage: dumptables --data=[yes|no] table1 table2 ... tableN
#
function dumptables {
  if [[ $1 == "--data=yes" ]]
  then
    DATAFLAG=""
    DUMPMSG="full table"
  else
    DATAFLAG="--no-data"
    DUMPMSG="structure for table"
  fi

  # Remove data setting from list of tables
  shift
  for arg in $@; do
    DUMPFILE=${args[0]}/$arg.sql
    echo "Dumping $DUMPMSG $arg into file $DUMPFILE"
    mysqldump --user=${args[1]} --password=${args[1]} ${args[1]} $DATAFLAG --order-by-primary --skip-extended-insert --skip-comments $arg > $DUMPFILE
  done
}

args=("$@")

echo "=================================================="
echo "Output dir: $1"
echo "Ensuring the output dir exists..."
mkdir -p $1
echo "DBName: $2"
echo ""

# Exclude caches from full dump
FULLTABLES=$(echo "USE $2; SHOW TABLES;" | mysql -u$2 -p$2 $2 | tail -n +2 | grep -v "^cache" | sort)
echo "$FULLTABLES" > $1/tables-list.txt
dumptables --data=yes $FULLTABLES

# Only dump structure for caches
STRUCTURETABLES=$(echo "USE $2; SHOW TABLES;" | mysql -u$2 -p$2 $2 | tail -n +2 | grep "^cache" | sort)
echo "$STRUCTURETABLES" >> $1/tables-list.txt
dumptables --data=no $STRUCTURETABLES
