# KoboldCpp Docker Build

This repo builds a GPU-enabled KoboldCpp image and runs it with Docker Compose. You can continue to build locally or configure a private (self-hosted) GitHub Actions runner to publish ready-to-load Docker image artifacts.

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
   The container listens on port 5001 and inherits CUDA access from the host as defined in `compose.yml`.

## Create the GitHub repository

1. Sign in to GitHub and create an empty repository (e.g., `username/kcpp`). Leave "Initialize this repository" unchecked.
2. Add the remote and push the current tree:
   ```bash
   git remote add origin git@github.com:username/kcpp.git
   git branch -M main
   git push -u origin main
   ```

## Register a private worker (self-hosted runner)

1. In your GitHub repo, open **Settings → Actions → Runners**.
2. Choose **New self-hosted runner**, select **Linux / x64**, and follow the provided install script on the private machine that can reach your GPUs and Docker daemon.
3. Keep the runner service running (`./run.sh` or `./svc.sh install && ./svc.sh start`).
4. Optional: assign repository-specific labels if you want to dedicate the runner to this project; update the workflow's `runs-on` value accordingly.

## GitHub Actions workflow

The workflow defined in `.github/workflows/build-image.yml` runs on each push to `main` and on manual `workflow_dispatch` events. It performs the following steps on the private runner:

1. Checks out the repo.
2. Builds the Docker image with tag `koboldcpp-custom:<git-sha>`.
3. Exports the image to `artifacts/koboldcpp-custom-<git-sha>.tar.gz` using `docker save`.
4. Uploads the archive as a workflow artifact named `koboldcpp-image-<git-sha>` (kept for 14 days).

To build on demand, open **Actions → Build KoboldCpp Image → Run workflow** and choose the branch.

## Using the artifact

1. Download the artifact from the workflow run page.
2. Load it into Docker on any host with compatible GPUs:
   ```bash
   gunzip -c koboldcpp-custom-<git-sha>.tar.gz | docker load
   docker tag koboldcpp-custom:<git-sha> koboldcpp-custom:homoai
   ```
3. Deploy with the provided `compose.yml` (or use `docker run`) once the `koboldcpp-custom:homoai` tag exists locally.

With this setup, every commit to `main` produces a reproducible Docker image that can be carried across machines via workflow artifacts while keeping the build hardware private.
