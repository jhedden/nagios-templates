#! /bin/sh
# Simple nagios active check
# You'll need to udpate this for your environment and command output

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

PROGNAME=`basename $0`
PROGPATH=`dirname $0`
STATUS=""
COMMAND=""

#. $PROGPATH/utils.sh

print_help() {
    echo "Usage: $PROGNAME "
}

if [ $# -ne 1 ]; then
    print_help
    exit 0
fi

case "$1" in
    -h)
       print_help
       exit 0
       ;;
   * )
       OUTPUT=`$COMMAND 1>&1 2>/dev/null`
       STATUS=$?
       if [ "$STATUS" -eq 0 ]; then
           NODE_STATE=`echo $OUTPUT | sed -e 's/.*State=\(\S*\).*/\1/'`
           if [[ $OUTPUT == *State=DOWN* ]]; then
               REASON=`echo $OUTPUT | sed -e 's/.*Reason=\(.*\) \[.*/\1/'`
               if [[ $REASON == *[Aa][Cc][Kk]* ]]; then
                   echo "WARN - $REASON"
                   exit 1
                else
                   echo "CRITICAL - $REASON"
                   exit 2
                fi
           fi
           echo OK
           exit 0
       elif [ "$STATUS" -eq 1 ];then
           echo "CRITICAL - $OUTPUT"
           exit 2
       else
           echo UNKNOWN
           exit -1
       fi
       ;;
esac
