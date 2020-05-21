# Makefile to build sine and libsndfile for Amazon Linux 2.

IMAGE = sine
NAME = sine-build
OUTDIR = ./build

.PHONY: all

all: copy

build: Dockerfile
	docker build -t $(IMAGE) -f Dockerfile .

copy: build
	mkdir -p $(OUTDIR)
	docker create --name $(NAME) $(IMAGE)
	docker cp $(NAME):/usr/local/lib64/libsndfile.so.1.0.29 $(OUTDIR)
	docker cp $(NAME):/usr/local/lib64/libsndfile.so.1 $(OUTDIR)
	docker cp $(NAME):/usr/local/lib64/libsndfile.so $(OUTDIR)
	docker cp $(NAME):/opt/sine/install/bin/sine $(OUTDIR)
	docker rm $(NAME)

clean:
	rm -rf $(OUTDIR)
	docker rm $(NAME) || true
	docker rmi $(IMAGE) || true
