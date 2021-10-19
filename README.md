# LTLSensitivityToLength
Procedures and artefacts to reproduce experiments on "length" sensitivity of LTL formulas.

The requirements for this setup include:

* A version of Spot : https://spot.lrde.epita.fr/ to both translate LTL to an automaton and analyze its sensitivity.
* The models and formulas from the [Model Checking Contest 2021](https://mcc.lip6.fr). We grab these from our [PNMCC Models 2021](https://github.com/yanntm/pnmcc-models-2021) repository that itself builds the files using the official distribution of the MCC.
* Our test/runner framework for these examples, available from https://github.com/yanntm/pnmcc-tests

Then we need a MCC compatible tool that can compete in the LTL category of the contest. We used~:

* A version of [ITS-tools](http://ddd.lip6.fr) : we use the version packaged for the MCC competition, available from here : [ITS-tools for MCC](https://github.com/yanntm/ITS-commandline)
* A version of [Tapaal](https://www.tapaal.net/) : we build it from the source repositories with flags to enable MCC mode. See repository here : https://bazaar.launchpad.net/~verifypn-maintainers/verifypn/new-trunk/files/head:/Scripts/MCC21/competition-scripts and https://code.launchpad.net/verifypn

The files of this repository are available under the terms of Gnu Public License v3.

(c) 2021; Yann Thierry-Mieg - CNRS - Sorbonne Université
