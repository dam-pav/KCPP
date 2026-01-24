# KoboldCpp GPU Docker Setup

This repository provides a ready‑to‑run Docker and Docker Compose setup for running the KoboldCpp inference server with NVIDIA GPU acceleration. It pulls the prebuilt KoboldCpp binary (CUDA/Vulkan enabled) and exposes the service on a configurable port. Designed to automatically mount your model directory and start KoboldCpp with GPU‑friendly defaults (CuBLAS, flash attention, etc.).

## Features
- Uses NVIDIA CUDA runtime image (Ubuntu 22.04)
- Downloads the latest KoboldCpp Linux x64 binary at build time
- Designed for GGUF models mounted from the host
- Simple configuration via environment variables


## Prerequisites
- NVIDIA GPU with drivers installed on the host
- Docker with NVIDIA Container Toolkit configured (so containers can use the GPU)
- Docker Compose v2

## Quick Start
1. Place your GGUF model file on the host, for example:
	- `/home/you/models/your-model.gguf`

### Docker Compose
2. Copy `docker-compose.yml` to a suitable folder on your host. Create a `.env` file next to `docker-compose.yml`:

	```env
	KCPP_MODEL_FILE=your-model.gguf
	KCPP_MODELS_PATH=/home/you/models

	# Optional overrides
	# KCPP_GPU_SELECTION=all       # or 0,1,...
	# KCPP_PORT=5001
	# KCPP_CONTEXT_SIZE=32768
	# KCPP_TENSOR_SPLIT="1 1"    # dual GPU example
	```

3. Start the service:

	```bash
	docker compose up -d
	```

### Portainer

2. Create a new stack using Git. Point it to `https://github.com/dam-pav/KCPP.git`. Add the environment variables as required.

3. Deploy.

### Web UI
4. Open the KoboldCpp web UI:

	- `http://localhost:5001`


## Configuration

Key environment variables used by `docker-compose.yml`:

- `KCPP_MODEL_FILE` – Model filename (e.g. `model.gguf`) inside the mounted models directory.
- `KCPP_MODELS_PATH` – Host path to your models directory, mounted to `/app/models` in the container.
- `KCPP_PORT` – External port for the KoboldCpp server (default `5001`).
- `KCPP_CONTEXT_SIZE` – Context size passed as `--contextsize` (e.g. `32768`, `65536`, `131072`).
- `KCPP_GPU_SELECTION` – Which GPU(s) to use (`all`, `0`, `1`, `0,1`, etc.).
- `KCPP_TENSOR_SPLIT` – Tensor split configuration for multi‑GPU setups (e.g. `"1"` for single GPU, `"1 1"` for dual GPU).

## GPU Selection

If you select a single GPU (set KCPP_GPU_SELECTION to the GPU index instead of 'all') make sure you also set KCPP_TENSOR_SPLIT. When two GPUs are used the tensor split is '1 1'. When a single GPU is used however, you must set the split to simply '1'. There is no if/then syntax in compose so you need to do this manually in the setup.

## Advanced Configuration

In case you need to tweak more than just the environment variable values you'll need to customize the compose file. For instance, if you want to use additional arguments (KCPP_ARGS). 

In Portainer you can start with a default git stack and detach from git later.
