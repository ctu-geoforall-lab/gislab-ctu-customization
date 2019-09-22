#!/bin/sh

if test -z "$1" ; then
    echo "usage: $0 path/to/csv"
    exit 1
fi

process_csv() {
SEP=','
tail -n +3 "$1" | while read line || [ -n "$line" ];
do           
    fname=`echo $line | cut -d $SEP -f2 | iconv -f utf-8 -t us-ascii//TRANSLIT`
    sname=`echo $line | cut -d $SEP -f1 | iconv -f utf-8 -t us-ascii//TRANSLIT `
    name=`echo $sname | iconv -f utf-8 -t us-ascii//TRANSLIT | tr '[:upper:]' '[:lower:]'`
    passwd=`echo $fname | iconv -f utf-8 -t us-ascii//TRANSLIT | tr '[:upper:]' '[:lower:]'`
    mail="$name@gislab.fsv.cvut.cz"

    sudo gislab-deluser -f $name
    sudo gislab-adduser -g $fname -l $sname -m $mail -a $2 -p ${passwd} $name
done
}

filepath="$1"
filename=`basename "$filepath"`
group=`echo "${filename%%.csv}" | cut -d'_' -f5 | sed 's/155//g' | tr '[:upper:]' '[:lower:]'`

echo $filepath
echo $filename
echo $group

sudo gislab-addgroup $group
process_csv "$filepath" $group

sudo gislab-deluser -f landa
sudo gislab-adduser -g Martin -l Landa -m landa@gislab.fsv.cvut.cz -a $group -p martin landa

exit 0
