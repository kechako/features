#!/bin/bash

set -e

PROTOC_VERSION=${VERSION}
PREFIX=/usr/local

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

install_packages() {
    local packages=()
    if ! command -v curl >/dev/null 2>&1; then
        packages+=("curl" "ca-certificates")
    fi
    if ! command -v jq >/dev/null 2>&1; then
        packages+=("jq")
    fi
    if ! command -v unzip >/dev/null 2>&1; then
        packages+=("unzip")
    fi
    if [ ${#packages[@]} -eq 0 ]; then
        echo "required packages are already installed."
        return 0
    fi
    apt-get update && apt-get install -y --no-install-recommends "${packages[@]}"
    return 0
}

get_release_url() {
    local version="$1"
    local arch="$2"
    local endpoint="https://api.github.com/repos/protocolbuffers/protobuf/releases/latest"
    if [ "$version" != "latest" ]; then
        endpoint="https://api.github.com/repos/protocolbuffers/protobuf/releases/tags/v${version}"
    fi

    local url=$(curl -v \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "${endpoint}" \
        | jq -r ".assets[] | select(.name | contains(\"linux-${arch}\")) | .browser_download_url")
    printf "$url"
    return 0
}

install_protoc() {
    local arch=""
    case "$(uname -m)" in
        aarch64|arm64)
            arch="aarch_64"
            ;;
        x86_64|amd64)
            arch="x86_64"
            ;;
        *)
            echo "Unsupported architecture: $(uname -m)"
            exit 1
            ;; 
    esac

    local download_url=$(get_release_url "${PROTOC_VERSION}" "${arch}")
    local tmpdir=$(mktemp -d)
    local protoc_zip="${tmpdir}/protoc.zip"

    # download & install protoc
    curl -o "${protoc_zip}" -sL "${download_url}"
    unzip "${protoc_zip}" -d "${PREFIX}"

    # cleanup
    rm -rf "${tmpdir}"
}

install_packages
install_protoc

protoc --version

echo "protoc installation completed successfully!"
