#! /usr/bin/bash
ren(){
[[ "$1" =~ -h|--help ]]&&{ echo -e "\nFor more help go to https://github.com/abdulbadii/GNU-ext-regex-rename/blob/master/README.md"
	mv --help|sed -Ee 's/\bmv\b/ren/;8a\ \ -c\t\t\t\tCase sensitive search' -e '14a\ \ -N\t\t\t\tNot to really execute only tell what it will do. It is useful as a test' ;}
unset f N i o
c=-iregex;I=i;
if [[ "${@: -1}" =~ ' ;;' ]];then
for a
{
case ${a:0:6} in
-f????) f=${a:2};f=${f#=};;
-N) N=1;;
-c) c=-regex;I=;;
-[HLPRSTabdfilnpstuvxz]) o=$o$a\ ;;
-*) echo Unrecognized option \'$a\';return;;
*)
if [ -n "$f" ] && [ ! -f "$f" ];then
	f=$(echo $f| sed -E 's~\\\\~\\~g ;s~\\~/~g ;s~\b([a-z]):(/|\W)~/\1/~i')
	[ -f $f ]||{ echo file does not exist;return;}
fi
[[ $a =~ ^(.+)\;\;[\ ]*(.+)$ ]]
x=${BASH_REMATCH[1]};y=${BASH_REMATCH[2]}

# PCRE --> GNU-ext regex
x=$(echo $x |sed -E 's/(\[.*?)\\\w([^]]*\])/\1a-z0-9\2/g; s/(\[.*?)\\\d([^]]*\])/\10-9\2/g ;s/\\\d/[0-9]/g; s/([^\])\.\*/\1[^\/]*/g; s/\.?\*\*/.*/g ;s/\s+$//')
v=${x#.\*}
if [[ "$x" =~ ^\(*(/|[a-z]:) ]] ;then
	s=$(echo $x |sed -E 's/([^[|*+\\{.]+).*/\1/;s~(.+)/.*~\1~;s/[()]//g')	#the first longest literal
else s=~+;x=$PWD/$x
fi
IFS=$'\n';LC_ALL=C
if((N));then
	if [ "$f" ];then	while read -r F
	do	[ -e $F ] ||{ F=$(echo $F|sed -E 's/[^!#-~]*([!#-~]+)[^!#-~]*/\1/;s~(\\+|//+)~/~g;s~\b([a-z]):(/|\W)~/\1/~i')
			[ -e $F ] ||continue;}
		t=`echo $F | sed -E "s!$v!$y!$I"`
		[ $F = $t ]||{
		echo -ne '\033[0;36m'Would' '
		if [ ${F%/*} = ${t%/*} ] ;then	echo -n Rename
		elif [ ${F##*/} = ${t##*/} ];then	echo -n Move
		else	echo -n Move then rename
		fi
		echo -e '\033[0m'" $F -> $t\n"
		}
	done<$f
	else	for F in `find $s -regextype posix-extended $c "$x" |head -n499`
	{	t=`echo $F | sed -E "s!$v!$y!$I"`
		[ $F = $t ]||{
		echo -ne '\033[0;36m'Would' '
		if [ ${F%/*} = ${t%/*} ];then	echo -n Rename
		elif [ ${F##*/} = ${t##*/} ];then	echo -n Move
		else	echo -n Move then rename
		fi
		echo -e ' \033[0m'"$F -> $t"
		}
	}
	fi
else
	B='-bS .old'
	if [ "$f" ];then	while read -r F
	do	[ -e $F ] ||{ F=$(echo $F|sed -E 's/[^!#-~]*([!#-~]+)[^!#-~]*/\1/;s~(\\+|//+)~/~g;s~\b([a-z]):(/|\W)~/\1/~i')
			[ -e $F ] ||continue;}
		t=`echo $F | sed -E "s!$v!$y!$I"`
		[ $F = $t ]||{
		mkdir -p "${t%/*}"
		command mv  $o "$F" "$t" &&{
		echo -ne '\033[0;36m'
		if [ ${F%/*} = ${t%/*} ];then	echo -e Renaming'\033[0m' $F -\> $t
		elif [ ${F##*/} = ${t##*/} ];then	echo -e Moving'\033[0m' $F -\> $t
		else	echo -e Moving and renaming'\033[0m' $F -\> $t
		fi; }
		}
	done<$f
	else F==
		while([ "$F" ])
		do F=
		for F in `find $s -regextype posix-extended $c "$x" |head -n499`
		{
		t=`echo $F | sed -E "s|$v|$y|$I"`
		[ $F = $t ]||{
		mkdir -p "${t%/*}"
		command mv $o "$F" "$t" &&{
		echo -ne '\033[0;36m'
		if [ ${F%/*} = ${t%/*} ];then	echo -e Renaming'\033[0m' $F -\> $t
		elif [ ${F##*/} = ${t##*/} ];then	echo -e Moving'\033[0m' $F -\> $t
		else	echo -e Moving and renaming'\033[0m' $F -\> $t
		fi; }
		}; }
		done
	fi
fi
unset IFS;;esac
}
else	t=${@: -1};mkdir -p "${t%/*}";mv -v $o ${@: -2} $t
fi
}
