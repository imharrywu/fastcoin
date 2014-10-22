#!/bin/bash
UNIX_PATH_PREFIX="$1"
SOURCE_NSI=share/setup.nsi
TEMP_NSI=share/setup.nsi.temp

cp $SOURCE_NSI $TEMP_NSI

while read -r line; do 
matchline=$(echo -ne $line | grep "$UNIX_PATH_PREFIX")
if ! [ -z "$matchline" ] ; then
	unix_path=$(echo -n $line | sed -ne "s@^.*\(${UNIX_PATH_PREFIX}[^ \*\\\"]*\).*\$@\1@p")
	echo "[*] "$unix_path
	win_path=$(echo -n $unix_path | sed -e 's@^/\([a-zA-Z]\)@\1:@g')
	win_path=$(echo -n $win_path | sed -e 's@/@\\@g')
	win_path=$(echo -n $win_path | sed -e 's@\\@\\\\@g')
	echo "    >> "$win_path
	sed -i -e "s@$unix_path@$win_path@g" $TEMP_NSI
fi;
done < $SOURCE_NSI

mv $TEMP_NSI $SOURCE_NSI
