CARGO_IMAGE = rust:1.39.0-slim-stretch
CARGO_BIN = .cargo .rustup
CURRENT_UID = $(shell id -u):$(shell id -g)
CARGO = CURRENT_UID=$(CURRENT_UID) docker-compose run --rm cargo
CARGO_SHELL = CURRENT_UID=$(CURRENT_UID) docker-compose run --rm --entrypoint bash cargo
NODE = docker-compose run --rm node

$(CARGO_BIN):
	@docker run --rm -v ${PWD}:/opt/app -w /opt/app -e USER=$(CURRENT_UID) -it $(CARGO_IMAGE) \
	sh -c "rustup component add clippy --toolchain 1.39.0-x86_64-unknown-linux-gnu && \
	apt-get update && apt-get install -y curl && \
	curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh && \
	cp -R /usr/local/cargo .cargo && cp -R /usr/local/rustup .rustup"

shell: $(CARGO_BIN)
	@$(CARGO_SHELL)

clean: $(CARGO_BIN)
	@$(CARGO) clean
	@rm -rf pkg target dist

deps: $(CARGO_BIN)
	@$(CARGO) fetch

lint: $(CARGO_BIN)
	@$(CARGO) clippy

build: $(CARGO_BIN)
	@$(CARGO_SHELL) -c "wasm-pack build --target nodejs"

run:
	@$(NODE) index.js
