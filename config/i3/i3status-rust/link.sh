#!/usr/bin/env bash

cd "$(dirname "$0")" || exit 1
ln -sf "${HOSTNAME}.toml" "config.toml"
