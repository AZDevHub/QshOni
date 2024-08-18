#!/bin/bash

# Function to recursively rename .clp files to .clle
rename_clp_to_clle() {
    local dir="$1"
    
    # Find all files in the directory matching *.clp (case insensitive)
    find "$dir" -type f -iname "*.clp" | while read -r file
    do
        # Get the base name without the extension
        base_name="${file%.*}"
        
        # Build the new filename with .clle extension
        new_file="${base_name}.CLLE"
        
        # Rename the file
        mv "$file" "$new_file"
        
        # Log the change
        echo "Renamed: $file to $new_file"
    done
}

# Specify the directory you want to start the search from
directory_to_search="$1"

# Call the function to rename .clp files to .clle
rename_clp_to_clle "$directory_to_search"
