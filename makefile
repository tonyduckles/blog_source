# Deploying
site-build: site-init site-clean gems-install
	./script/jekyll-build

site-git-remote-url = git@github.com:tonyduckles/tonyduckles.github.io.git
site-init:
	test -d "_site" || git clone -o deploy $(site-git-remote-url) _site

site-clean:
	find _site -maxdepth 1 | grep -Ev "^_site$$|/.git" | xargs rm -rf

site-diff:
	cd _site && git diff

site-commit:
	./script/site-commit

site-deploy:
	./script/site-deploy-push

# Update Gemfile
gems-install:
	./script/bundle

gems-update:
	./script/bundle update

# Testing
site-serve:
	./script/jekyll-serve

htmlproofer:
	./script/htmlproofer
