# Copyright 2020 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

ALL_ARCH = amd64 arm64

SHELL := /bin/bash
GOOS ?= $(shell go env GOOS)
GOARCH ?= $(shell go env GOARCH)
GOPROXY ?= $(shell go env GOPROXY)
GIT_VERSION := $(shell git describe --dirty --tags --match='v*')
VERSION ?= $(GIT_VERSION)
INSTALL_PATH ?= $(OUTPUT)/bin
LDFLAGS ?= -w -s -X k8s.io/component-base/version.gitVersion=$(VERSION)

ecr-credential-provider:
	 GO111MODULE=on CGO_ENABLED=0 GOOS=$(GOOS) GOARCH=$(GOARCH) GOPROXY=$(GOPROXY) go build \
		-trimpath \
		-ldflags="$(LDFLAGS)" \
		-o=ecr-credential-provider-$(GOARCH) \
		cloud-provider-aws/cmd/ecr-credential-provider/*.go

ecr-credential-provider.exe:
	 GO111MODULE=on CGO_ENABLED=0 GOOS=windows GOPROXY=$(GOPROXY) go build \
		-trimpath \
		-ldflags="$(LDFLAGS)" \
		-o=ecr-credential-provider.exe \
		cloud-provider-aws/cmd/ecr-credential-provider/*.go

ecr-credential-provider-amd64:
	$(MAKE) GOARCH=amd64 ecr-credential-provider

ecr-credential-provider-arm64:
	$(MAKE) GOARCH=arm64 ecr-credential-provider

all: ecr-credential-provider-amd64 ecr-credential-provider-arm64 ecr-credential-provider.exe

.PHONY: all ecr-credential-provider-amd64 ecr-credential-provider-arm64 ecr-credential-provider ecr-credential-provider.exe
