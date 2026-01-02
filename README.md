# KoboldCpp Docker Build

This repo builds a GPU-enabled KoboldCpp image and runs it with Docker Compose. You can continue to build locally or configure a private (self-hosted) GitHub Actions runner to publish ready-to-load Docker image artifacts and a registry image address consumable from any Compose deployment.

## Local workflow

1. Download or place your GGUF models in `/home/damjan/KoboldCPP` so they are mounted into the container.
2. Build the image:
   ```bash
   ./prepare_image.sh
   ```
3. Launch the service:
   ```bash
   docker compose up -d
   ```
   The container listens on port 5001 and inherits CUDA access from the host as defined in `compose.yml`. Override the image via `KCPP_IMAGE=... docker compose up -d` if you want to pull from GHCR instead of the local tag.

### Referencing the published image

After the workflow completes, the image is available at:

```
ghcr.io/dam-pav/koboldcpp-custom:<git-sha>
ghcr.io/dam-pav/koboldcpp-custom:latest
```

To use the remote image inside `compose.yml`, either replace the `image` line directly or drive it via an environment variable, for example:

```yaml
services:
   koboldcpp:
      image: ${KCPP_IMAGE:-ghcr.io/your-account/koboldcpp-custom:latest}
```

Then set `KCPP_IMAGE=ghcr.io/your-account/koboldcpp-custom:<git-sha>` (or `:latest`) when deploying. Compose will pull the matching GHCR image automatically.

If the repository is private, authenticate Docker before pulling:

```bash
echo "<pat-with-read-packages>" | docker login ghcr.io -u <github-username> --password-stdin
```

Generate a classic PAT (or fine-grained PAT) with at least the `read:packages` scope for hosts that only need to run the container.
