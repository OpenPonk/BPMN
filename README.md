# OpenPonk: BPMN

[![Nightly](https://github.com/OpenPonk/BPMN/actions/workflows/nightly.yml/badge.svg)](https://github.com/OpenPonk/BPMN/actions/workflows/nightly.yml) [![Coverage Status](https://coveralls.io/repos/github/OpenPonk/BPMN/badge.svg?branch=master)](https://coveralls.io/github/OpenPonk/BPMN?branch=master)

BPMN 2.0 diagram editor, validator, token-flow simulator, and XML serializer for the [OpenPonk](https://openponk.org) modeling platform.

## Download

Download pre-built portable archives from [Releases](https://github.com/OpenPonk/BPMN/releases), or get the all-in-one build at [openponk.org/#download](https://openponk.org/#download).

## Installation

See [openponk.org/#direct-installation](https://openponk.org/#direct-installation) for the supported Pharo version.

```smalltalk
Metacello new
	baseline: 'OpenPonkBPMN';
	repository: 'github://OpenPonk/BPMN';
	load.
```

## Documentation

Part of the [OpenPonk](https://openponk.org) platform. For architecture, the repository catalog, and contributing guidelines, see [`OpenPonk/.github`](https://github.com/OpenPonk/.github/blob/main/profile/README.md).
