build:
	docker build -t ${USER}/znc .

push: build
	docker push ${USER}/znc

.PHONY: default
