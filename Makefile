all: build serve

serve:
	zola --config ./config.toml serve

build:
	zola --config ./config.toml build


.PHONY: all serve build
