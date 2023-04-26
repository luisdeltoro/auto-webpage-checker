#!/bin/bash

# Create a temporary directory to store the packaged files
mkdir out/lambda_package

# Install the Python dependencies to the temporary directory
pip install -r python/requirements.txt -t out/lambda_package

# Copy the Python script to the temporary directory
cp -r python/src/awc out/lambda_package

# Zip the contents of the temporary directory into a ZIP file
cd out/lambda_package
zip -r9 ../awc-lambda.zip .

# Return to the parent directory and clean up the temporary directory
cd ..
rm -rf lambda_package
