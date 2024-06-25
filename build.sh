#!/bin/bash

set -e

SOURCE=${BASH_SOURCE[0]}
while [ -L "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

# Find the newest file in a directory
find_newest() {
    newest=""
    for file in "$1"/*; do
        if [ -z "$newest" -o "$newest" -ot "$file" ]; then
            newest=$file
        fi
    done
    echo "$file"
}

tmpdir=
cleanup() {
    [ -d "$tmpdir" ] && rm -rf "$tmpdir"
}
trap cleanup EXIT

# Iterate over chart source folders
for chart in "$DIR"/source/*; do
    if [ ! -f "$chart/Chart.yaml" ]; then continue; fi
    cname=`basename "$chart"`

    # If there is an existing output directory, find the newest file in it
    outdir="$DIR/charts/$cname"
    if [ -d "$outdir" ]; then
        newest_file=`find_newest "$outdir"`
        if [ -z "$newest_file" ]; then break; fi

        newest_ut=`date -r "$newest_file" +%s`
        newer=false
        for file in "$chart"/* "$chart"/*/*; do
            file_ut=`date -r "$file" +%s`
            delta=`expr $file_ut - $newest_ut || true`
            if [ $delta -gt 5 ]; then
                #echo "Found newer file: $file"
                newer=true
                break
            fi
        done

        if [ "$newer" != "true" ]; then continue; fi
    else
        mkdir -p "$outdir"
    fi

    echo "Building chart $cname"

    tmpdir=`mktemp -d -p "$DIR"`
    tdname=`basename "$tmpdir"`
    cd "$DIR"
    mkdir "$tdname/$cname"
    helm package -d "$tdname/$cname" "source/$cname"
    helm repo index --merge "index.yaml" --url charts/ "$tdname"
    mv "$tdname/$cname"/* "charts/$cname"
    mv "$tmpdir/index.yaml" "$DIR"
    rm -rf "$tmpdir"
    tmpdir=

done

