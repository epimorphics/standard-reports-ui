.PHONY:	assets auth check clean image lint local publish realclean run tag test vars

ACCOUNT?=$(shell aws sts get-caller-identity | jq -r .Account)
ALPINE_VERSION?=3.16
AWS_REGION?=eu-west-1
BUNDLER_VERSION?=$(shell tail -1 Gemfile.lock | tr -d ' ')
ECR?=${ACCOUNT}.dkr.ecr.eu-west-1.amazonaws.com
GPR_OWNER?=epimorphics
NAME?=$(shell awk -F: '$$1=="name" {print $$2}' deployment.yaml | sed -e 's/[[:blank:]]//g')
PAT?=$(shell read -p 'Github access token:' TOKEN; echo $$TOKEN)
PORT?=3003
RUBY_VERSION?=$(shell cat .ruby-version)
SHORTNAME?=$(shell echo ${NAME} | cut -f2 -d/)
STAGE?=dev
API_SERVICE_URL?=http://standard-reports-manager:8080

BRANCH:=$(shell git rev-parse --abbrev-ref HEAD)
COMMIT=$(shell git rev-parse --short HEAD)
VERSION?=$(shell /usr/bin/env ruby -e 'require "./app/lib/version" ; puts Version::VERSION')
TAG?=$(shell printf '%s-%s-%08d' ${VERSION} ${COMMIT} ${GITHUB_RUN_NUMBER})

${TAG}:
	@echo ${TAG}

IMAGE?=${NAME}/${STAGE}
REPO?=${ECR}/${IMAGE}

GITHUB_TOKEN=.github-token
BUNDLE_CFG=.bundle/config

${BUNDLE_CFG}: ${GITHUB_TOKEN}
	@./bin/bundle config set --local rubygems.pkg.github.com ${GPR_OWNER}:`cat ${GITHUB_TOKEN}`

${GITHUB_TOKEN}:
	@echo ${PAT} > ${GITHUB_TOKEN}

all: image

assets: auth
	@./bin/bundle config set --local without 'development test'
	@./bin/bundle install
	@./bin/rails assets:clean assets:precompile

auth: ${GITHUB_TOKEN} ${BUNDLE_CFG}

check: lint test
	@echo "All checks passed."

clean:
	@[ -d public/assets ] && ./bin/rails assets:clobber || :
	@@ rm -rf bundle coverage log node_modules

image: auth
	@echo Building ${REPO}:${TAG} ...
	@docker build \
		--build-arg ALPINE_VERSION=${ALPINE_VERSION} \
		--build-arg RUBY_VERSION=${RUBY_VERSION} \
		--build-arg BUNDLER_VERSION=${BUNDLER_VERSION} \
		--build-arg VERSION=${VERSION} \
		--build-arg git_branch=${BRANCH} \
		--build-arg git_commit_hash=${COMMIT} \
		--build-arg github_run_number=${GITHUB_RUN_NUMBER} \
		--build-arg image_name=${NAME} \
		--tag ${REPO}:${TAG} \
		.
	@echo Done.

lint: assets
	@./bin/bundle exec rubocop

local:
	@echo "Installing all packages ..."
	@./bin/bundle install
	@echo "Starting local server ..."
	@./bin/rails server -p ${PORT}

publish: image
	@echo Publishing image: ${REPO}:${TAG} ...
	@docker push ${REPO}:${TAG} 2>&1
	@echo Done.

realclean: clean
	@rm -f ${GITHUB_TOKEN} ${BUNDLE_CFG}

run: start
	@if docker network inspect dnet > /dev/null 2>&1; then echo "Using docker network dnet"; else echo "Create docker network dnet"; docker network create dnet; sleep 2; fi
	@docker run -p ${PORT}:3000 -e API_SERVICE_URL=${API_SERVICE_URL} --network dnet --rm --name ${SHORTNAME} ${REPO}:${TAG}

server: assets start
	@export SECRET_KEY_BASE=$(./bin/rails secret)
	@API_SERVICE_URL=${API_SERVICE_URL} ./bin/rails server -p ${PORT}

start:
	@docker stop ${SHORTNAME} > /dev/null 2>&1 || :
	@echo "Starting ${SHORTNAME} ..."

tag:
	@echo ${TAG}

test: assets
	@echo "Running tests ..."
	@./bin/rails test

vars:
	@echo "Docker: ${REPO}:${TAG}"
	@echo "ACCOUNT = ${ACCOUNT}"
	@echo "ALPINE_VERSION = ${ALPINE_VERSION}"
	@echo "AWS_REGION = ${AWS_REGION}"
	@echo "BUNDLER_VERSION = ${BUNDLER_VERSION}"
	@echo "ECR = ${ECR}"
	@echo "GPR_OWNER = ${GPR_OWNER}"
	@echo "NAME = ${NAME}"
	@echo "RUBY_VERSION = ${RUBY_VERSION}"
	@echo "SHORTNAME = ${SHORTNAME}"
	@echo "STAGE = ${STAGE}"
	@echo "COMMIT = ${COMMIT}"
	@echo "TAG = ${TAG}"
	@echo "VERSION = ${VERSION}"
