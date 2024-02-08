#!/bin/bash

# alac-transfer.sh
# Ivan Otaku
# Feb 6, 2024
#
# use like: sh alac-transfer.sh -r -k /my/input /my/output
# INPUT:
# #1 Input Folder
# #2 Output Folder
#
# OPTIONS:
# -r: recursively create output folder

# get arguments
args=()
while [ $# -ge 1 ];do
    getopts "rk" opt
    case "$opt" in
        r)
            # recursion mode
            RECURSION=1
            shift
            OPTIND=1
            ;;
        k)
            # keep folder relative path
            KEEP=1
            shift
            OPTIND=1
            ;;
        *)
            args+=($1)
            shift
            OPTIND=1
            ;;
    esac
done

# set input folder
RES_DIR=${args[0]}
# set output folder
OUT_DIR=${args[1]}

# ffmpeg cmd, you can use self ffmpeg path instead or append other options which you need here 
FFMPEG_CMD=ffmpeg

# goto input dirctory
cd "$RES_DIR"

# extensions for audio file
# effective extensions contains: mp3,wav,aac,flac,ogg or else regular type which support in ffmpeg
extensions=("mp3" "wav" "aac" "flac" "ogg")

# scan regular audio in target folder,
# then convert audio file to alac encoding format(.m4a).
# if there is a folder inner, it will been scanned too.
# when converting, the original relative path will be retained.
function list_d {
    tar=$1
    echo scan "$tar" ... ...

    # list folder
    for f in $tar/*
    do
        if [ -d "$f" ]
        then
            # scan dirctory
            if [ "$RECURSION" ];then
                list_d "$f"
            fi
        else
            # list extensions and test
            for ext in ${extensions[@]}
            do
                if [[ $f == *."$ext" ]];then
                    if [ "$KEEP" ];then
                        # use relative path with input folder
                        fn=${f##$RES_DIR}
                    else
                        # use filename only
                        fn=${f##*/}
                    fi
                    # sub extension
                    fn=${fn%.*}
                    # set output path and name-extension
                    fn=$OUT_DIR/$fn.m4a
                    # prepare output folder
                    mkdir -p "${fn%/*}"

                    echo flat $f to $fn ... ...
                    # set input(-i $f) output($fn), copy video stream(album cover), and set output encoding format to ALAC
                    $FFMPEG_CMD -i "$f" -c:v copy -c:a alac -y "$fn"
                    echo trans $f to $fn success!
                fi
            done
        fi
    done
}

# start
if [ "$RES_DIR" ];then
    list_d $RES_DIR
fi
