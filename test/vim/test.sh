#!/bin/bash

# This test can be run with the following command (from the root of the repository):
#
#     devcontainer features test \
#                   --features vim \
#                   --remote-user root \
#                   --skip-scenarios   \
#                   --base-image mcr.microsoft.com/devcontainers/base:ubuntu

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
check "vim version" vim --version

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults