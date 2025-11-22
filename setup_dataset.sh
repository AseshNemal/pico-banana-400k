#!/bin/bash
# Setup script for Pico-Banana-400K dataset
# This will download Open Images source files and prepare them for mapping

set -e  # Exit on error

echo "🚀 Starting dataset setup..."

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI not found. Please install it first:"
    echo "   https://aws.amazon.com/cli/"
    exit 1
fi

# Download Open Images packed files
echo "📦 Downloading train_0.tar.gz (this may take a while)..."
aws s3 --no-sign-request --endpoint-url https://s3.amazonaws.com cp s3://open-images-dataset/tar/train_0.tar.gz .

echo "📦 Downloading train_1.tar.gz (this may take a while)..."
aws s3 --no-sign-request --endpoint-url https://s3.amazonaws.com cp s3://open-images-dataset/tar/train_1.tar.gz .

# Create folder for extracted images
echo "📁 Creating openimage_source_images directory..."
mkdir -p openimage_source_images

# Extract the tar files
echo "📂 Extracting train_0.tar.gz..."
tar -xvzf train_0.tar.gz -C openimage_source_images

echo "📂 Extracting train_1.tar.gz..."
tar -xvzf train_1.tar.gz -C openimage_source_images

# Download metadata CSV
echo "📊 Downloading metadata CSV..."
if command -v wget &> /dev/null; then
    wget https://storage.googleapis.com/openimages/2018_04/train/train-images-boxable-with-rotation.csv
elif command -v curl &> /dev/null; then
    curl -O https://storage.googleapis.com/openimages/2018_04/train/train-images-boxable-with-rotation.csv
else
    echo "❌ Neither wget nor curl found. Please install one of them."
    exit 1
fi

echo "✅ Setup complete! You can now run the mapping script:"
echo "   python3 map_openimage_url_to_local.py"
