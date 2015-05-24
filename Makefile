all: build run

build:
	docker build --rm -t dm4tw/ctf .

run:
	mkdir -p ./share
	docker run --privileged -p 2222:22 -v $(PWD)/share:/root/share --rm -it dm4tw/ctf
