# LTLSensitivityToLength : LTL artefacts on length-sensitivity

Procedures and artefacts to reproduce experiments on "length" sensitivity of LTL formulas.

We use both Tapaal https://www.tapaal.net/ and ITS-Tools https://lip6.github.io/ITSTools-web/ in these experiments on models taken from the model-checking competition 2021 https://mcc.lip6.fr/.

## Workflow and steps

Please refer to the source of the "~/demo.sh" file for more details on the different steps.

 * Step 0 : download the VM provided by the conference from here :  https://zenodo.org/record/5562597 Click the ".ova" to download the VM then open it and start it with VirtualBox. 
 * Step 1 : login to the VM with user/pass : tacas22/tacas22. You can change keyboard setting by doing : right click background, Display Setting, left in "Region & Language", "Input sources", first "Add" French/your keyboard type (it is in "other") then remove "US-en" using the garbage can icon. Right-click background->"Open in terminal" will now give us a terminal with correct keyboard.
 * Step 2 : Download and deploy artefact in the VM. Use the Zenodo link [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5644977.svg)](https://doi.org/10.5281/zenodo.5644977)  to download and place it at the root of the tacas22 home: in `/home/tacas22/`. Then deploy with `tar xvzf home.tgz`.
 * Step 3 : There are several Readme with more details but the rest is done using the `demo.sh` so simply run it. It will enact the further steps. 

### Steps in the demo

Much more detail is available in the `~/demo.sh` file.

 * Step 0 : install debian dependencies. We use R language and modern Java.
 * Step 1 : Analyze sensitivity to length of LTL formulas and compute reduced models. This step is handled by ITS-tools. Because the benchmark is so huge we only reproduce using three model instances (out of 2822). More examples can be run by editing "step 1" of demo.sh to add more runs.
 * Step 2 : run an MCC model-checker with both reduced and original model/formula pairs. Collect logs and compute a CSV summary file from these raw logs. We run both Tapaal and ITS-Tools. We did our best to simulate the conditions we ran in (we capture output in OAR.XX.out and OAR.XX.err files), but we use a cluster and OAR to reserve cpu on it in the full experiment so the match is not perfect. The actual scripts we used on the cluster are also part of this distribution however.
 * Step 3 : build tables from the CSV and formulas of literature on sensitivity to length in practice. This corresponds to the Table in section 4.1 of the paper. For a large set of formulas we compute whether it is stutter insensitive, shortening insensitive, lengthening insensitive, or arbitrary. This step can actually be performed after or before Step 2 it only depends on data produced at step 1.
 * Step 4 : build tables and plots from the CSV of Step 2 using R. The demo script builds both the plots using the data you have just collected at step 1 and using the full data from our experiment. To make these auditable, we provide the CSV resulting from our cluster run in `~/tacas22/Rscripts/clusterLog` as well as all the logs of this run in the `~/tacas22/logsCluster.tgz` that were parsed to build the CSV.

## Contents

We have deployed all dependencies.
 * ~/usr/ contains local installations of the LTL manipulation library Spot and of libraried required for R (used in analysis)
 * ~/tapaal/ contains Tapaal, configured for MCC mode. It was built from the bzr depot of Tapaal from source, following instructions helpfully provided by the authors Jiri Srba et al.
 * ~/tacas22/Spot-Binary-Builds/ is the folder used to build Spot with appropriate flags. We used "build_cluster.sh" script. You do not need to do this however it is deployed in ~/usr/local. The companion github is https://github.com/yanntm/Spot-Binary-Builds.
 * ~/tacas22/packages/ contains the apt-get debian packages needed to run our demo. Essentially we need R language and Java language support.

There are instructions on how to rebuild these dependencies from scratch in each subfolder. Again it is not necessary to do so with the provided archive.

Then the tools/models :
 * ~/tacas22/ITS-Tools-MCC contains the ITS-Tools distribution as well as the inputs from the MCC'21 edition. Both of these are extracted and installed following the instruction on the three github : https://github.com/yanntm/pnmcc-models-2021 (curated/annotated models from MCC 21) https://github.com/yanntm/pnmcc-tests (For the test/runner framework) https://github.com/yanntm/ITS-Tools-MCC (For ITS-tools distributed for the MCC)
 * ~/tacas22/LTLPatterns/ contains formulas collected from the literature as well as a script to analyze their sensitiivty and compute metrics on them. See the README in that folder for more details.
 * ~/tacas22/Rscripts/ contains scripts to analyze the results and produce plots used in the paper. See the README in that folder for more details. It also contains the CSV produced from our cluster run (in clusterLog/) to reproduce the plots (these were built using the full logs provided in ~/tacas22/logsCluster.tgz and analyzed with the perl scripts from the ~/tacas22/ITS-Tools-MCC folder)


The requirements for this setup include:

* A version of Spot : https://spot.lrde.epita.fr/ to both translate LTL to an automaton and analyze its sensitivity.
* The models and formulas from the [Model Checking Contest 2021](https://mcc.lip6.fr). We grab these from our [PNMCC Models 2021](https://github.com/yanntm/pnmcc-models-2021) repository that itself builds the files using the official distribution of the MCC.
* Our test/runner framework for these examples, available from https://github.com/yanntm/pnmcc-tests

Then we need a MCC compatible tool that can compete in the LTL category of the contest. We used~:

* A version of [ITS-tools](http://ddd.lip6.fr) : we use the version packaged for the MCC competition, available from here : [ITS-tools for MCC](https://github.com/yanntm/ITS-commandline)
* A version of [Tapaal](https://www.tapaal.net/) : we build it from the source repositories with flags to enable MCC mode. See repository here : https://bazaar.launchpad.net/~verifypn-maintainers/verifypn/new-trunk/files/head:/Scripts/MCC21/competition-scripts and https://code.launchpad.net/verifypn


# License

This work is provided under the terms of GPL v3 or more recent.

(C) Yann Thierry-Mieg, Denis Poitrenaud, Etienne Renault, Emmanuel Paviot-Adet. Sorbonne Université, CNRS. 2021.
