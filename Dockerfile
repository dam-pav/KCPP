# CUDA runtime so the binary can actually use your GPUs
FROM nvidia/cuda:12.4.0-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

# Just what we need to fetch the binary
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
    && rm -rf /var/lib/apt/lists/*

# Where we'll put the binary
WORKDIR /opt

# Download the latest Linux x64 KoboldCpp binary
# (prebuilt, includes CUDA/Vulkan support)
RUN curl -fLo /opt/koboldcpp \
      https://github.com/LostRuins/koboldcpp/releases/latest/download/koboldcpp-linux-x64 \
    && chmod +x /opt/koboldcpp

# Directory where your models will be mounted
RUN mkdir -p /app/models

# Runtime env defaults
ENV KCPP_MODEL=/app/models/model.gguf \
    KCPP_ARGS="" \
    KCPP_HOST=0.0.0.0 \
    KCPP_PORT=5001

# Simple entrypoint: no wrappers, no build script.
# If you want to add flags like --usecublas, put them into KCPP_ARGS.
ENTRYPOINT ["/bin/bash", "-lc", "exec /opt/koboldcpp --model \"$KCPP_MODEL\" --host \"$KCPP_HOST\" --port \"$KCPP_PORT\" $KCPP_ARGS"]
