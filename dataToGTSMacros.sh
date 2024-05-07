#!/bin/bash

# convert csv into macros returning gts

src_dir="data"
dest_dir="macros/data"

process_file() {
    local src_file=$1
    local dest_file=$2
    local src_filename=$(basename "$src_file")
    local src_folder=$(basename $(dirname "$src_file"))
    
    local suffix="
'>
'%0A' SPLIT
0 REMOVE DROP

NEWGTS 'raw_data' RENAME
{
  'name' '$src_filename' DUP 0 SWAP SIZE 4 - SUBSTRING
  'dataset' '$src_folder'
  'source' 'numenta_anomaly_benchmark'
}
RELABEL

SWAP
<%
  ',' SPLIT
  DUP SIZE 1 == <% DROP CONTINUE %> IFT
  [ 't' 'v' ] LSTORE
  [
    \$t ' ' 'T' REPLACE '.000000Z' + TOTIMESTAMP
    \$v TODOUBLE
  ]
  ADDVALUE
%>
FOREACH
%>"

    local prefix="<%
<'"

    # Ensure the destination directory exists
    mkdir -p "$(dirname "$dest_file")"
    
    # Append prefix and suffix, then change file extension
    # (echo "$prefix"; cat "$src_file"; echo "$suffix") > "${dest_file%.*}.mc2"

    # Using a heredoc to handle complex multiline strings with special characters
    cat > "${dest_file%.*}.mc2" <<EOF
$prefix
$(cat "$src_file")
$suffix
EOF
}

# Export the process_file function to be available in subshells
export -f process_file

# Export variables to be available in subshells
export src_dir dest_dir

# Find all files in source directory and process each one
find "$src_dir" -type f -exec bash -c 'process_file "$0" "${0/"$src_dir"/"$dest_dir"}"' {} \;

rm $dest_dir/README.mc2

echo "Done."
