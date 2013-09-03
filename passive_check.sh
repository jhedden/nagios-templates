#! /bin/sh
# Simple nagios passive check
# You'll need to udpate this for your environment and command output

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

PROGNAME=`basename $0`
PROGPATH=`dirname $0`
STATUS=""

COMMAND=""
TIMESTAMP=`date +%s`
OK_STATE=""
WARN_STATE=""

#. $PROGPATH/utils.sh

print_help() {
    echo "Usage: $PROGNAME "
}

print_results() {
    echo "[$TIMESTAMP] PROCESS_SERVICE_CHECK_RESULT;$1;$PROGNAME;$2;$3"
}

case "$1" in
    -h)
       print_help
       exit 0
       ;;
   * )
       OUTPUT=`$COMMAND 1>&1 2>/dev/null`
       STATUS=$?
       if [ "$STATUS" -eq 0 ]; then
           IFS=$'\n'
           for line in $OUTPUT; do
               STATE="SOMETHING"
               if echo $OK_STATE; then
                   print_results $NAME 0 $STATE
               elif echo $WARN_STATE; then
                   print_results $NAME 1 $STATE
               else
                   print_results $NAME 2 $STATE
               fi
           done
       else
           print_results $NAME 3 "PROCESSING ERROR"
           echo UNKNOWN
           exit -1
       fi
       ;;
esac
