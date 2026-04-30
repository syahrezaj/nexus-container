FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    pkg-config \
    libssl-dev \
    protobuf-compiler \
    git \
    openssh-server \
    && rm -rf /var/lib/apt/lists/*

# Install Rust (properly)
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Clone and build
WORKDIR /app
RUN git clone https://github.com/kira1752/nexus-cli.git .

WORKDIR /app/clients/cli
RUN cargo build --release

# Install binary
RUN cp target/release/nexus-network /usr/local/bin/

EXPOSE 9090
# Run at container start (NOT build time)
CMD ["systemctl start ssh"]
