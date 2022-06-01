#!/usr/bin/env bash

_err()     { printf 'ERROR: %s\n' "$*" 1>&2; exit 1; }
_is_link() { [[ -L "$1" ]]; }
_is_file() { [[ -f "$1" ]]; }
_is_dir()  { [[ -d "$1" ]]; }
_exists()  { [[ -e "$1" ]]; }
_link()    { ln -sv "$1" "$2"; }

_unlink() {
    local basename basedir file src tgt
    basename="$1" # home, config
    pushd "$basename" >/dev/null || return 1
    [[ -f basedir ]] || { printf "\n? Ignoring '%s', missing 'basedir' file.\n\n" "$basename"; popd >/dev/null || return 1; return 0; }
    basedir=$(head -1 basedir)
    echo "+ UnLinking folder/files in '$basename'..."
    find . -maxdepth 1 -mindepth 1 \( -type f -o -type d \) -not -name 'basedir' -print0 | \
        while IFS= read -r -d '' file
    do
        [[ "$file" != "basedir" ]] || continue
        tgt="${HOME}/${basedir}/${file}"
        if _exists "$tgt"; then
            tgt=$(realpath --no-symlinks "$HOME/$basedir/$file") || exit 1
        fi
        src=$(realpath "$(pwd -P)/$file") || exit 1

        if _is_link "$tgt"; then
            if [[ $(realpath "$src") == $(realpath "$tgt") ]]; then
                rm -v "$tgt"
            else
                _err "Target is a different link than expected, delete it: '$tgt'."
            fi
        else
            if _is_dir "$tgt"; then
                _err "Target is a folder, delete it: '$tgt'."
            fi
            if _is_file "$tgt"; then
                _err "Target is a file, delete it: '$tgt'."
            fi
        fi
    done
    popd >/dev/null || return 1
}

find . -maxdepth 1 -mindepth 1 -type d -not -name '.git' -print0 | \
    while IFS= read -r -d '' folder
do
    _unlink "$folder" || exit 1
done
