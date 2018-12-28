WORK_DIR=/build
RACKET_DIR=racket
RUNTIME_FILE=runtime.rkt
LAYER_ZIP=lambda-racket-runtime.zip
EXAMPLE_ZIP=racket-demo.zip

build:
	docker run \
		--rm \
		--volume $(shell pwd)/:/build \
		--workdir $(WORK_DIR) \
		amazonlinux:latest \
		/bin/bash -c \
			"yum -y update && yum -y install tar gzip \
			&& curl -o /tmp/install.sh https://mirror.racket-lang.org/installers/7.1/racket-minimal-7.1-x86_64-linux.sh \
			&& chmod +x /tmp/install.sh \
			&& echo yes | /tmp/install.sh --in-place --dest $(RACKET_DIR)"

archive:
	rm -rf $(LAYER_ZIP)
	zip -r $(LAYER_ZIP) bootstrap $(RUNTIME_FILE) $(RACKET_DIR)

demo-archive:
	rm -rf $(EXAMPLE_ZIP)
	zip -j $(EXAMPLE_ZIP) example/demo.rkt