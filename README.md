# KoboldCpp GPU Docker Setup

This repository provides a ready-to-run Docker and Docker Compose setup for running the KoboldCpp inference server with NVIDIA GPU acceleration. It pulls the prebuilt KoboldCpp binary (CUDA/Vulkan enabled) and exposes the service on a configurable port. Designed to automatically mount your model directory and start KoboldCpp with GPU-friendly defaults.

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
	# Required environment variables:
	# KCPP_MODEL_FILE=<model.gguf>
	# KCPP_MODELS_PATH=<path to your models directory>

	# Optional environment variables:
	# KCPP_PORT=5001
	# KCPP_GPU_SELECTION=all,0,1,etc.

	# KoboldCpp parameters:
	# KCPP_TENSOR_SPLIT= '1 1' for dual gpu, '1' for single gpu
	# KCPP_CONTEXT_SIZE=32768
	# KCPP_CONTEXT_SIZE=65536
	# KCPP_CONTEXT_SIZE=131072
	# KCPP_QUANTKV=2
	# KCPP_GPULAYERS=999
	# KCPP_THREADS=12
	# KCPP_BATCHSIZE=256
	# KCPP_MAXREQUESTSIZE=64
	# KCPP_DEFAULTGENAMT=2048

	# These work as switches. If the var has any content, including "0" or "false", the flag will be added. If the var is empty or not set, the flag will be omitted.
	# KCPP_USECUDA=1
	# KCPP_SMARTCONTEXT=1
	# KCPP_JINJA=1
	# KCPP_JINJA_TOOLS=1
	# KCPP_LOWVRAM=1
	# KCPP_NOFLASHATTENTION=1
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
- `KCPP_TENSOR_SPLIT` – Tensor split configuration for multi-GPU setups (e.g. `"1"` for single GPU, `"1 1"` for dual GPU).
- `KCPP_USECUDA` – Adds `--usecuda` when set.
- `KCPP_SMARTCONTEXT` – Adds `--smartcontext` when set.
- `KCPP_JINJA` – Adds `--jinja` when set.
- `KCPP_JINJA_TOOLS` – Adds `--jinja_tools` when set.
- `KCPP_LOWVRAM` – Adds `--lowvram` when set.
- `KCPP_NOFLASHATTENTION` – Adds `--noflashattention` when set.

Switch-style variables are evaluated by the container entrypoint when `KCPP_ARGS` is parsed into the final argument list. If the variable contains any value at all, even `0` or `false`, the corresponding flag is added. Leave it unset or empty to omit the flag.

The compose file uses YAML's `>-` folding style for `KCPP_ARGS` so Docker does not include a trailing newline in the environment variable. That trailing newline can confuse KoboldCpp's argument parser with this entrypoint pattern.

## GPU Selection

If you select a single GPU (set `KCPP_GPU_SELECTION` to the GPU index instead of `all`) make sure you also set `KCPP_TENSOR_SPLIT`. When two GPUs are used the tensor split is `1 1`. When a single GPU is used you must set the split to simply `1`. There is no if/then syntax in Compose, so you need to do this manually in the setup.

## Advanced Configuration

If you need to tweak more than just the environment variable values, customize [`docker-compose.yml`](/home/damjan/KCPP/docker-compose.yml). For instance, you can add extra arguments through `KCPP_ARGS`.

In Portainer you can start with a default git stack and detach from git later.
