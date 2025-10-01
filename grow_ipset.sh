#!/bin/bash
usage () {
 echo "Usage: grow_ipset.sh [-me maxelem] [-hs hashsize] setname
Default maxelem is no change, default hashsize is no change" 1>&2
}
dir=/var/lib/shorewall
while [ $# -gt 1 ]
do
 case $1 in
   -hs)
    shift
    hs="$e"
    shift
    ;;
   -me)
    shift
    me="$1"
    shift
    ;;
   *)
    shift
    usage
    exit 1
    ;;
 esac
done
o="$1"
if ! ipset -q list -t "$o" > /dev/null
then
 echo "$o not a known ipset" 1>&2
 usage
 exit 2
fi
if [ ! "$o" ]
then
 usage
 exit 3
fi
if op=$(grep Head <(ipset list -t "$o"))
then
 echo $op | {
 read _ _ family _ hashsize _ maxelem _ timeout
 nm=${me:-$maxelem}
 nhs=${hs:-$hashsize}
 echo $o from maxelem $maxelem to $nm, hashsize from $hashsize to $nhs
 tt="tmp$$"
 ipset create $tt hash:ip family $family hashsize $nhs maxelem $nm timeout 0 comment && ipset -f $dir/${tt}.sav save $o && ipset swap $o $tt && tail -n +2 $dir/${tt}.sav | ipset restore
 }
fi
