all: build run

build:
	docker build --rm -t dm4tw/ctf-box .

run:
	mkdir -p ./share
	docker run --privileged -p 2222:22 -v $(PWD)/share:/root/share --name=ctf -it dm4tw/ctf-box
