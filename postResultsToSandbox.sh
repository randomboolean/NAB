#!/bin/bash

# Define the directory containing the .mc2 files
dest_dir="macros/results"

# Define the URL to post the data
url="https://sandbox.senx.io/api/v0/exec"

# Write token
token="'4dwUGy.gv8xrBjzG_Q.myuxWtbtXVmv3vVn5igleKH3.VKRtancy3CG504LKlg6tm5TYYUS1759rsL47Ro6oXd.uWZlzHuW.zcxc.pnSyv6gVEsVNCRixJL9L2RH8AfJPOQGxofxVO79.kWdQXRSNjvwGQgFOSNTVgOm1mTGWneymyA6SRNkOGnUsM6hq7ZIpPwDCzzaxmQox3IF6SLMoXlYOpV2X2AzmcyVWWpyB76_.u4qabs6e6N2RETiDQZr_tXUo81aL2R'"

# Iterate over each .mc2 file in the directory
for file in "$dest_dir"/*/*/*.mc2; do
    echo "Processing file: $file"

    # Create a temporary file
    tmp_file="$(mktemp)"
    
    # Append update warpscript to the temporary file
    cat "$file" > "$tmp_file"
    echo "EVAL" >> "$tmp_file"
    echo "$token" >> "$tmp_file"
    echo "UPDATE" >> "$tmp_file"
    
    # Send the temporary file content as a POST request
    curl -X POST --data-binary @"$tmp_file" "$url"
    
    # Clean up the temporary file
    rm "$tmp_file"
done

echo "All files processed and sent."
