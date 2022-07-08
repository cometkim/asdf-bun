#!/bin/bash

set -eo pipefail

GITHUB_REPO="Jarred-Sumner/bun"
REPO_URL="https://github.com/$GITHUB_REPO"

cmd="curl -s"
if [ -n "$GITHUB_API_TOKEN" ]; then
 cmd="$cmd -H 'Authorization: token $GITHUB_API_TOKEN'"
fi

# stolen from https://github.com/rbenv/ruby-build/pull/631/files#diff-fdcfb8a18714b33b07529b7d02b54f1dR942
function sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

function list_github_releases() {
  $cmd \
    -H 'Accept: application/vnd.github+json' \
    "https://api.github.com/repos/$GITHUB_REPO/releases" |
    grep -o '"tag_name": "bun-v.*"' |
    sed -r 's/"tag_name": "bun-v(.*)"/\1/'
}

function list_github_tags() {
  git ls-remote --tags --refs "$REPO_URL" |
    grep -o 'refs/tags/bun-v.*' | cut -d/ -f3- |
    sed 's/^bun-v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

function get_platform() {
  case "$OSTYPE" in
    darwin*) echo -n "darwin" ;;
    linux*) echo -n "linux" ;;
    *) fail "Unsupported platform" ;;
  esac
}

function get_arch() {
  case "$(uname -m)" in
    x86_64) echo -n "x64" ;;
    aarch64|arm64) echo -n "aarch64" ;;
    *) fail "Unsupported architecture" ;;
  esac
}

function get_bin_url() {
  local version=$1
  local platform=$2
  local arch=$3

  local url="$REPO_URL/releases/download/bun-v$version/bun-$platform-$arch.zip"

  echo -n "$url"
}

function get_source_url() {
  local version=$1

  echo -n "$REPO_URL/archive/bun-v$version.zip"
}

function get_temp_dir() {
  local tmpdir
  tmpdir=$(mktemp -d asdf-bun.XXXX)

  echo -n "$tmpdir"
}

function fail() {
  echo -e "\e[31mFail:\e[m $*" 1>&2
  exit 1
}
