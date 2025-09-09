# SRBMiner-Multi Docker

SRBMiner-Multi Docker is a containerized cryptocurrency mining solution that packages the high-performance SRBMiner-Multi software for CPU and AMD GPU mining. The project creates and publishes Docker images to multiple container registries (Docker Hub, GHCR, and Quay.io).

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## Working Effectively

### Bootstrap and Build
- **Docker build**: `docker build --build-arg VERSION_TAG=2.9.7 -t srbminer-multi .`
  - Build time: ~10 seconds clean build. NEVER CANCEL. Set timeout to 30+ minutes for safety.
  - Uses Debian stable-slim base image
  - Downloads SRBMiner-Multi from GitHub releases using wget (SSL workaround included)
- **Build script**: `./build.sh`
  - Builds Docker image and attempts to push to all registries
  - Build phase: ~1-2 seconds (with cache), ~10 seconds (clean)
  - Push phase: Will fail without proper authentication (expected in development)
  - NEVER CANCEL: Set timeout to 60+ minutes for complete build and push operations

### Testing and Validation
- **Run container**: `docker run --rm test-image`
  - Container starts mining software with default configuration
  - Exits quickly if pool connection fails (expected behavior)
  - Use environment variables to customize: ALGO, POOL_ADDRESS, WALLET_USER, PASSWORD, EXTRAS
- **Test different algorithms**: `docker run --rm -e ALGO=cpupower -e POOL_ADDRESS=test.pool.com:4444 test-image`
- **API testing**: Container exposes port 80 for SRBMiner API when --api-enable flag is used
  - Start with port mapping: `docker run -d -p 8080:80 test-image`
  - API endpoints depend on SRBMiner-Multi version and configuration

### Build Process Validation
Always validate these scenarios after making changes:
1. **Basic build**: `docker build -t test .` completes successfully
2. **Container startup**: `docker run --rm test` shows miner parameters and attempts connection
3. **Custom configuration**: Test with different ALGO and POOL_ADDRESS environment variables
4. **GitHub Actions**: Verify `.github/workflows/docker-image.yml` still works with your changes

## Environment Setup

### Prerequisites
- Docker Engine installed and running
- For builds: Access to GitHub releases (github.com)
- For pushes: Authentication to Docker registries (docker.io, ghcr.io, quay.io)

### Build Arguments and Environment Variables
- `VERSION_TAG`: SRBMiner-Multi version to download (default: 2.5.3, current: 2.9.7)
- `ALGO`: Mining algorithm (default: "randomx")
- `POOL_ADDRESS`: Mining pool URL (default: "stratum+ssl://rx.unmineable.com:443")
- `WALLET_USER`: Wallet address for mining
- `PASSWORD`: Pool password (default: "x")
- `EXTRAS`: Additional SRBMiner flags (default: "--api-enable --api-port 80 --disable-auto-affinity --disable-gpu")

## Known Issues and Workarounds

### SSL Certificate Issue
The Dockerfile uses `wget --no-check-certificate` to download SRBMiner-Multi releases due to SSL certificate chain issues in some environments. This is a known limitation.

### Registry Authentication
The `build.sh` script will fail to push images without proper authentication tokens. This is expected in development environments. The build portion will succeed.

### Container Exit Behavior
Containers exit quickly when they cannot connect to mining pools. This is normal SRBMiner behavior, not a Docker issue.

## Common Tasks

The following are validated commands and their expected outcomes:

### Repository Structure
```
.github/workflows/    # CI/CD pipelines
├── docker-image.yml  # Main build workflow (runs ./build.sh)
└── snyk-container.yml # Security scanning
Dockerfile           # Main container definition
build.sh            # Build and push script
start_zergpool.sh   # Container entrypoint script
README.md           # Basic usage documentation
LICENSE             # Apache License 2.0
```

### Build Commands
```bash
# Basic build with default version (2.5.3)
docker build -t srbminer-multi .

# Build with specific version
docker build --build-arg VERSION_TAG=2.9.7 -t srbminer-multi .

# Build and tag for multiple registries (like build.sh does)
./build.sh
```

### Run Commands
```bash
# Default configuration
docker run --rm srbminer-multi

# Custom algorithm and pool
docker run --rm -e ALGO=cpupower -e POOL_ADDRESS=your.pool.com:4444 -e WALLET_USER=your_wallet srbminer-multi

# With API port exposed
docker run -d -p 8080:80 --name miner srbminer-multi
```

### File Structure Inside Container
```
/opt/SRBMiner-Multi/
├── SRBMiner-MULTI        # Main executable
├── start_zergpool.sh     # Startup script
└── [other SRBMiner files from release]
```

## CI/CD Pipeline
- **GitHub Actions**: Automatically builds on push to main branch
- **Security Scanning**: Snyk container vulnerability scanning
- **Multi-registry Publishing**: Pushes to docker.io, ghcr.io, and quay.io (requires secrets)

## Troubleshooting
- If build fails with SSL errors: Verify wget --no-check-certificate is used in Dockerfile
- If container exits immediately: Check pool connectivity or use test pool
- If push fails: Verify registry authentication (expected to fail in development)
- If GitHub Actions fail: Check if VERSION_TAG in build.sh matches available releases

## Development Workflow
1. Make changes to Dockerfile or scripts
2. Test build: `docker build -t test .`
3. Test container: `docker run --rm test`
4. Validate with different configurations
5. Submit PR (GitHub Actions will validate the build)