# Features

This repository is a collection of reusable Dev Container Features that can be used to customize development containers.

> This repository follows the [dev container Feature distribution specification](https://containers.dev/implementors/features-distribution/).

## Available Features

The following Features are currently available in this repository:

| Feature Name | Description                        |
| ------------ | ---------------------------------- |
| vim          | Installs the latest version of Vim |

## Usage

To use a Feature from this repository in your devcontainer.json, reference it using the ghcr.io registry and your GitHub username.
For example, to include the vim Feature:

```json
{
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/kechako/features/vim:1": {}
  }
}
```
