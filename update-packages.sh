#!/usr/bin/env bash

set -e
set -x

nix-update --flake --commit --version=branch chicago95
