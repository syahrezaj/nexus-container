FROM ubuntu:22.04

RUN apt update && \
	apt install curl && \
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh 

RUN source $HOME/.cargo/env

RUN apt update && \
	apt install -y build-essential pkg-config libssl-dev protobuf-compiler && \
	apt install git

RUN git clone https://github.com/kira1752/nexus-cli.git 

RUN cd ~/nexus-cli/clients/cli && \
	cargo build --release && \
	cp target/release/nexus-network /usr/local/bin/nexus-network && \
	chmod +x /usr/local/bin/nexus-network

RUN nexus-network start --node-id 25693881 --max-threads 4

CMD ["--wait"]
