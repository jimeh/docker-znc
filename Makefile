USER=tronpaul

build:
	docker build -t ${USER}/znc .

.PHONY: build
