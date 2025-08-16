#!/usr/bin/env bash

copy_scripts() {
    local src="$1"
    local dst="${2%/}"

    pushd "$src" &>/dev/null || return
    for folder in */; do
        folder="${folder%/}"
        echo "Processing folder: $folder"

        for file in "$folder"/*; do
            [[ -f "$file" ]] || continue
            filename="$(basename "$file")"
            newname="${folder}_${filename}"
            if [[ -e "$dst/$newname" ]]; then
                echo "File $dst/$newname already exists, removing it."
                rm "$dst/$newname"
            fi
            
            if [[ ! -x "$file" ]]; then
                echo "Making $file executable"
                chmod +x "$file"
            fi

            echo "Copying $file -> $dst/$newname"
            cp "$file" "$dst/$newname"
        done
        echo ""
    done

    popd &>/dev/null || return
}

copy_scripts "./scripts/" "$SCRIPT_BIN"
