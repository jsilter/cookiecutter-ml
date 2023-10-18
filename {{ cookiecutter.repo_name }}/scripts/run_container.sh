#!/bin/bash

# Initialize variables with default values
interactive_mode=false
container_name=""

# Function to display usage instructions
function show_usage {
  echo "Usage: $0 [-i] <image_name> [container_name]"
  echo "Options:"
  echo "  -i       Run interactively (optional)"
  exit 1
}

# Process options
while getopts ":i" opt; do
  case $opt in
    i)
      interactive_mode=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      show_usage
      ;;
  esac
done

# Shift the processed options
shift $((OPTIND-1))

# Check if an image name is provided as the first argument
if [ $# -lt 1 ]; then
  show_usage
fi

# Get the image name from the first argument
image_name="$1"

# If a container name is provided as the second argument, use it
if [ $# -ge 2 ]; then
  container_name="--name $2"
fi

# Create the "data" directory on the host if it doesn't exist
mkdir -p "$(pwd)/data"

# Run the Docker container interactively or non-interactively based on the option
# Expose common ports (-p) and mount the "data" directory
# Container will be deleted when finished (--rm flag)
common_args="--rm $container_name -p 7680:7680 -p 8501:8501 -p 8888:8888 -v $(pwd)/data:/workspace/data $image_name"
if [ "$interactive_mode" = true ]; then
  # Run interactively and capture the container ID
  echo "Running interactively"
  docker run -it ${common_args} /bin/bash
else
  echo "Running non-interactively as background"
  docker run -d ${common_args}
fi
