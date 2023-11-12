# asdf-bun
[![CI](https://github.com/cometkim/asdf-bun/actions/workflows/ci.yml/badge.svg)](https://github.com/cometkim/asdf-bun/actions/workflows/ci.yml)

[asdf](https://asdf-vm.com/) version manager plugin for installing [Bun](https://bun.sh)

## Installation

```bash
asdf plugin add bun
```

## Usage

Check [asdf](https://github.com/asdf-vm/asdf) readme for instructions on how to install & manage versions.

## About global installations

<details>
  <summary>TL;DR: Don't use Bun for global installations</summary>

  You can use it. You just need to add your `globalBinPath`(default: `$HOME/.bun/bin`) to `$PATH`

  But Bun has a problem of not being well-suited to handle global installations.
  https://gist.github.com/cometkim/eb2842d67b40e583e4886e9b897a6af0
  
  This plugin could override the behavior like the [asdf-nodejs plugin does for NPM](https://github.com/asdf-vm/asdf-nodejs/blob/master/shims/npm), but I believe that's not the correct move. I would not recommend managing global installations via Bun until this is discussed upstream (https://github.com/oven-sh/bun/issues/6928)
  
</details>



## LICENSE

MIT
