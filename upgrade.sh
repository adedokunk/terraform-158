#!/bin/bash

# Exit script if any command fails
set -e

# Get the new version from the command line argument
new_ver=$1
echo "New version: $new_ver"

# Simulate release of the new Docker image
docker tag nginx:1.23.3 adedokunk/nginx:$new_ver

# Push the new version to Docker Hub
docker push adedokunk/nginx:$new_ver

# Create a temporary folder
tmp_dir=$(mktemp -d)
echo "Temporary directory: $tmp_dir"

# Clone the GitHub repo
git clone https://github.com/adedokunk/lesson-158.git $tmp_dir

# Update the image tag in the deployment YAML file
sed -i '' -e "s/adedokunk\/nginx:.*/adedokunk\/nginx:$new_ver/g" $tmp_dir/my-app/1-deployment.yaml

# Commit and push the changes to the GitHub repository
cd $tmp_dir
git add .
git commit -m "Update image to $new_ver"
git push

# Optionally, remove the temporary folder on build agents
rm -rf $tmp_dir
