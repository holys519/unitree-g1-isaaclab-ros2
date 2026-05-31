FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/.local/bin:/opt/dimos/.venv/bin:${PATH}"
ENV TORCH_CUDA_INDEX_URL=https://download.pytorch.org/whl/cu124

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash-completion \
    bluez \
    build-essential \
    ca-certificates \
    curl \
    dbus \
    ffmpeg \
    git \
    git-lfs \
    iproute2 \
    iputils-ping \
    libglib2.0-0 \
    libgl1 \
    libsm6 \
    libusb-1.0-0 \
    libxext6 \
    libxrender1 \
    net-tools \
    pciutils \
    portaudio19-dev \
    python3.12 \
    python3.12-dev \
    python3.12-venv \
    sudo \
    tini \
    vim \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN curl -LsSf https://astral.sh/uv/install.sh | sh

WORKDIR /opt/dimos
RUN uv venv --python python3.12 .venv \
    && uv pip install --python .venv/bin/python --upgrade pip \
    && uv pip install --python .venv/bin/python --index-url ${TORCH_CUDA_INDEX_URL} \
        "torch==2.5.1+cu124" \
        "torchvision==0.20.1+cu124" \
    && printf "torch==2.5.1+cu124\ntorchvision==0.20.1+cu124\n" > /tmp/torch-constraints.txt \
    && uv pip install --python .venv/bin/python --extra-index-url ${TORCH_CUDA_INDEX_URL} \
        --constraint /tmp/torch-constraints.txt \
        "dimos[base,unitree,visualization,web]"

WORKDIR /workspace
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["sleep", "infinity"]
