# OpenPonk: BPMN

This is an unoffical updated version of BPMN extension for [OpenPonk tool](https://openponk.org).

## Installation

Requires Pharo 12 image - clean or with loaded OpenPonk.

In Playground, execute following script:
```
Metacello new
    baseline: 'BPMN';
    repository: 'github://OpenPonk/BPMN';
    load
```