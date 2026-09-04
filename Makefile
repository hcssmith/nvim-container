build:
	docker build . -t hcssmith/nvim-container

debug:
	docker build --progress=plain . -t hcssmith/nvim-container 2>&1 | tee build.log

run: build
	docker run --rm -it \
		-v "$(pwd)":/workspace \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-e DISPLAY=$(DISPLAY) \
		hcssmith/nvim-container

project-builder: build
	docker run --rm -it \
		-v /src/project_builder:/workspace \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-e DISPLAY=$(DISPLAY) \
		hcssmith/nvim-container

prune-cache:
	docker builder prune -f

install:
	install -D -m 755 cnvim ~/.local/bin/cnvim

.PHONY: build debug run project-builder prune-cache install
