# Deploying
site-build:
	./script/jekyll-build

site-diff:
	cd _site && git diff

site-commit:
	./script/site-commit

site-deploy:
	./script/site-deploy-push
	test -f script/site-deploy-rsync && ./script/site-deploy-rsync

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
