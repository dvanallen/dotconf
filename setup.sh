#!/bin/sh

#If we dont have the dotconf files for some reason, grab them.
if [ ! -d ~/dotconf ]
then
    git clone --recursive https://github.com/dvanallen/dotconf.git ~/dotconf
fi

#Make a backup of existing dotconf files and copy over the new ones.
DOTCONF_FILES=~/dotconf/home/*
for file in $DOTCONF_FILES
do
    if [ -f ~/.${file##*/} ]
    then
        mv ~/.${file##*/} ~/.${file##*/}.bk
    fi
    cp -r ~/dotconf/home/${file##*/} ~/.${file##*/}
done

