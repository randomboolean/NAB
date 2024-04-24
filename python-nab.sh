#!/bin/bash
# Ensuring the script stops on any errors
set -e

# Check if at least one argument is provided
if [ $# -eq 0 ]; then
    echo "No arguments provided. Usage: ./docker-python.sh <script> [<args>]"
    exit 1
fi

# Run the Docker command with passed arguments
docker run -it --rm --platform linux/amd64 --name python-nab -v "$PWD":/usr/src/myapp -w /usr/src/myapp python-nab python "$@"
