VERSION := $(shell cat package.json | jq -r '.version')

.PHONY: test clean configtest

deps:
	npm install

install: lambda
	terraform plan
	terraform apply

lambda:
	@echo "Factory package files..."
	@if [ ! -d build ] ;then mkdir build; fi
	@cp index.js build/index.js
	-cp config.json build/config.json
	@if [ ! -d build/node_modules ] ;then mkdir build/node_modules; fi
	@cp -R node_modules/ build/node_modules/
	@cp -R libs build/
	@cp -R bin build/
	@rm -rf build/bin/darwin
	@echo "Create package archive..."
	@cd build && zip -rq aws-lambda-image.zip .
	@mv build/aws-lambda-image.zip ./

release:
	zip -r opszero-image-resizer-$(VERSION).zip Makefile config.json.example dist README.md video_resizer.tf
	cp opszero-image-resizer-$(VERSION).zip output.zip
	curl -T opszero-image-resizer-$(VERSION).zip ftp://ftp.sendowl.com --user $(SENDOWL_FTP_USER):$(SENDOWL_FTP_PASSWORD)



test:
	./node_modules/mocha/bin/_mocha -R spec --timeout 10000 tests/*.test.js

configtest:
	@./bin/configtest

clean:
	@echo "clean up package files"
	@if [ -f aws-lambda-image.zip ]; then rm aws-lambda-image.zip; fi
	@rm -rf build/*
