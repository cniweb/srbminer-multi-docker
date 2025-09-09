#!/bin/bash
# Define image name, version and registries
image="srbminer-multi"
version="2.9.7"
declare -a available_registries=()

# Function to login to registries and track which ones are available
login_to_registries() {
  echo "Logging into Docker registries..."
  
  # Login to Docker Hub
  if [[ -n "$DOCKER_USERNAME" && -n "$DOCKER_PASSWORD" ]]; then
    echo "Logging into Docker Hub..."
    echo "$DOCKER_PASSWORD" | docker login docker.io -u "$DOCKER_USERNAME" --password-stdin
    if [ $? -eq 0 ]; then
      echo "✓ Docker Hub login successful"
      available_registries+=("docker.io")
    else
      echo "✗ Docker Hub login failed"
      exit 1
    fi
  else
    echo "⚠ Docker Hub credentials not provided. Skipping docker.io registry."
  fi

  # Login to GitHub Container Registry
  if [[ -n "$GITHUB_TOKEN" ]]; then
    echo "Logging into GitHub Container Registry..."
    # Use repository owner username for GHCR authentication
    echo "$GITHUB_TOKEN" | docker login ghcr.io -u "cniweb" --password-stdin
    if [ $? -eq 0 ]; then
      echo "✓ GitHub Container Registry login successful"
      available_registries+=("ghcr.io")
    else
      echo "✗ GitHub Container Registry login failed"
      exit 1
    fi
  else
    echo "⚠ GitHub token not provided. Skipping ghcr.io registry."
  fi

  # Login to Quay.io
  if [[ -n "$QUAY_USERNAME" && -n "$QUAY_PASSWORD" ]]; then
    echo "Logging into Quay.io..."
    echo "$QUAY_PASSWORD" | docker login quay.io -u "$QUAY_USERNAME" --password-stdin
    if [ $? -eq 0 ]; then
      echo "✓ Quay.io login successful"
      available_registries+=("quay.io")
    else
      echo "✗ Quay.io login failed"
      exit 1
    fi
  else
    echo "⚠ Quay.io credentials not provided. Skipping quay.io registry."
  fi
}

# Login to configured registries
login_to_registries

# Check if we have at least one registry configured
if [[ ${#available_registries[@]} -eq 0 ]]; then
  echo "❌ No registry credentials provided. Cannot push images."
  echo "Please configure at least one of the following:"
  echo "  - Docker Hub: DOCKER_USERNAME and DOCKER_PASSWORD"
  echo "  - GitHub Container Registry: GITHUB_TOKEN"
  echo "  - Quay.io: QUAY_USERNAME and QUAY_PASSWORD"
  exit 1
fi

echo "Available registries: ${available_registries[*]}"

# Build the image using the first available registry
echo "Building Docker image..."
docker build . --build-arg VERSION_TAG=$version --tag ${available_registries[0]}/cniweb/$image:$version

# Check if the command was successful
if [ $? -ne 0 ]; then
  echo "❌ Docker build failed!"
  exit 1
fi

echo "✓ Docker build succeeded!"

# Tag and push the images
echo "Tagging and pushing images to configured registries..."
for registry in "${available_registries[@]}"; do
  echo "Processing registry: $registry"
  docker tag ${available_registries[0]}/cniweb/$image:$version $registry/cniweb/$image:$version
  docker tag ${available_registries[0]}/cniweb/$image:$version $registry/cniweb/$image:latest
  
  # Push both versioned and latest tags
  echo "Pushing $registry/cniweb/$image:$version..."
  docker push $registry/cniweb/$image:$version
  if [ $? -ne 0 ]; then
    echo "❌ Failed to push $registry/cniweb/$image:$version"
    exit 1
  fi
  
  echo "Pushing $registry/cniweb/$image:latest..."
  docker push $registry/cniweb/$image:latest
  if [ $? -ne 0 ]; then
    echo "❌ Failed to push $registry/cniweb/$image:latest"
    exit 1
  fi
  
  echo "✓ Successfully pushed to $registry"
done

echo "🎉 All images built and pushed successfully!"

