#!/bin/sh
for i in `find $2 -type f -name "*.pub" -printf "%f\n"`
do
    echo $i;
    suffix=".pub";
    j=${i%$suffix}; #Remove suffix
    echo $j;
    k=$(find . -type f -name "$i")
    echo $k
    echo "$1"d
    if [ $1 = "create" ];  then
    	kubectl $1 secret $j --from-file=$k -n sftp 
    else 
    	kubectl $1 secret $j -n sftp 
    fi
    echo "####################"
done

