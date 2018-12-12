SOURCE_DIR=./source/public
DEPLOY_DIR=./_deploy
PUBLIC_DIR=./_public

init: initialize setup gh-pages init-data guide

guide:
	clear
	cat ./lib/haroopress/QUICK.markdown

initialize:
	bash -l -c 'nvm use 0.10;npm install -g node-gyp'
	git submodule update --init --recursive
	cd ./node_modules/robotskirt;node-gyp rebuild
	cd ./node_modules/locally/;npm install

update:
	@echo "========================================"
	@echo "= update & initialize git submodules"
	@echo "========================================"
	git pull origin master
	cd ./source/themes;git pull origin master
	npm update
	cd ./node_modules/robotskirt;node-gyp rebuild

init-data: 
	bash -l -c 'nvm use 0.10'
	@echo "========================================"
	@echo "= create default data set"
	@echo "========================================"
	./bin/init.js

setup:
	bash -l -c 'nvm use 0.10'
	@echo "========================================"
	@echo "= configurate haroopress"
	@echo "========================================"
	./bin/setup.js

gh-pages: clear
	bash -l -c 'nvm use 0.10'
	@echo "========================================"
	@echo "= setup repository for deployment"
	@echo "========================================"
	cd ./bin/;./gh-pages.js

clear: 
	@echo "========================================"
	@echo "= clear public & deployment directories"
	@echo "========================================"
	bash -l -c 'nvm use 0.10; ./bin/clear.js'

gen: clear 
	@echo "========================================"
	@echo "= generate to static page"
	@echo "========================================"
	bash -l -c 'nvm use 0.10; ./bin/gen.js'
	mkdir -p ${PUBLIC_DIR}/slides/@asserts
	cp -R ./lib/shower/themes ${PUBLIC_DIR}/slides/@asserts
	cp -R ./lib/shower/scripts ${PUBLIC_DIR}/slides/@asserts
	cp -R ./lib/bootstrap/* ${PUBLIC_DIR}

preview: gen
	@echo "========================================"
	@echo "= preview static page"
	@echo "========================================"
	bash -l -c 'nvm use 0.10; ./bin/preview.js'
	
deploy: gen
	@echo "========================================"
	@echo "= deploy to github"
	@echo "========================================"
	bash -l -c 'nvm use 0.10; cd ./bin; ./deploy.js "${msg}"'

new-post:
	bash -l -c 'nvm use 0.10; cd ./bin;./new-post.js'

new-page:
	bash -l -c 'nvm use 0.10; cd ./bin;./new-page.js'

new-slide:
	bash -l -c 'nvm use 0.10; cd ./bin;./new-slide.js'

octopress:
	@echo "========================================"
	@echo "= convert from octopress"
	@echo "========================================"
	cd ./bin/convert/;./octopress.js

usenvm:
	bash -l -c 'nvm use 0.10'

defaultnmv:
	bash -l -c 'nvm use default'

.PHONY: init update build clear
