#!/usr/bin/env bash

_err()     { printf 'ERROR: %s\n' "$*" 1>&2; exit 1; }
_is_link() { [[ -L "$1" ]]; }
_is_file() { [[ -f "$1" ]]; }
_is_dir()  { [[ -d "$1" ]]; }
_exists()  { [[ -e "$1" ]]; }
_link()    { ln -sv "$1" "$2"; }

_create_links() {
    local basename basedir file src tgt
    basename="$1" # home, config
    pushd "$basename" >/dev/null || return 1
    [[ -f basedir ]] || _err "Missing 'basedir' file in '$basename'."
    basedir=$(head -1 basedir)
    echo "+ Linking folder/files in '$basename'..."
    find . -maxdepth 1 -mindepth 1 \( -type f -o -type d \) -not -name 'basedir' -print0 | \
        while IFS= read -r -d '' file
    do
        [[ "$file" != "basedir" ]] || continue
        tgt="${HOME}/${basedir}/${file}"
        if _exists "$tgt"; then
            tgt=$(realpath --no-symlinks ${HOME}/${basedir}/${file}) || exit 1
        fi
        src=$(realpath $(pwd -P)/${file}) || exit 1

        if _is_link "$tgt"; then
            if [[ $(realpath $src) == $(realpath $tgt) ]]; then
                echo "   [OK] $tgt"
                continue
            else
                _err "Target is a different link than expected, delete it: '$tgt'."
            fi
        fi

        if _is_dir "$tgt"; then
            _err "Target is a folder, delete it: '$tgt'."
        fi

        if _is_file "$tgt"; then
            _err "Target is a file, delete it: '$tgt'."
        fi

        mkdir -p $(dirname -- "$tgt")
        ln -sv "$src" "$tgt" || _err "Could not link '$tgt'."
    done
    popd >/dev/null || return 1
}

find . -maxdepth 1 -mindepth 1 -type d -not -name '.git' -print0 | \
    while IFS= read -r -d '' folder
do
    _create_links "$folder" || exit 1
done
