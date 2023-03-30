#! /bin/bash


##########################
# Step 0 : install debian dependencies

echo -e "***************************\nPart 0 : Install Java, R script language (we need sudo for this) \n***************************"

cd tacas22/packages

sudo dpkg -i *.deb

cd -


##########################
# Step 1 : analyze sensitivity

echo -e "***************************\nPart 1 : Compute LTL sensitivity for a few models\n***************************"


cd tacas22/ITS-Tools-MCC

# use the flags to analyze sensitivity, output stats and quit
cp BenchKit_head.analyze.sh BenchKit_head.sh

# run a few tests
./run_test.pl oracle/BART-PT-020-LTLC.out
./run_test.pl oracle/AirplaneLD-COL-0100-LTLC.out
./run_test.pl oracle/Vasy2003-PT-none-LTLF.out

# Or all of them !
# for i in oracle/*LTLC.out oracle/*LTLF.out ; do ./run_test.pl $i ; done

# each run builds a "LTLCardinalitystats.csv" or "LTLFireabilitystats.csv" 
# in the INPUTS/model folder

# it also builds for each lengthening/shortening formula :

# "original" model with limited reductions to full LTL with X
# model.LTLCardinality.12.pnml
# reduced model with structural reductions which are "Reductions" of the language per Def 7
# model.LTLCardinality.12.red.pnml

# formula for "original" model
# LTLCardinality.12.red.xml
# formula for "reduced" model
# LTLCardinality.12.red.xml


# consolidate the logs into a single log all these stats

# headerline of the stats
head -1 INPUTS/AirplaneLD-COL-0100/LTLCardinalitystats.csv > reduction.csv
for i in INPUTS/*/LTL*stats.csv ; do tail -n +2 $i >> reduction.csv ; done ;


echo "Successfully generated results CSV for reductions/analysis of sensitivity. See ~/tacas22/ITS-tools-MCC/reduction.csv"

###############################
#### Step 2 : run an MCC model-checker with both reduced and original model/formula pairs
## collect logs and compute a CSV summary file from these raw logs.

echo -e "***************************\nPart 2 : Invoke ITS-tools and Tapaal\n***************************"
echo "Press enter for Step 2"
read input

# restore "normal" flags to ITS-tools, we don't want to analyze sensitivity and quit anymore
cp BenchKit_head.noslcl.sh BenchKit_head.sh

# this script simulates locally the experiment we did on a large cluster
# our script is runslcl_oar.sh but it relies on reservation system OAR
# this script invokes the tools and stores their outputs in 
# itsLog/ and tapaalLog/ respectively.
# it then runs an analysis of the raw logs to obtain some CSV
# please read it for more details on its operation.
./run_slcl_local.sh


echo "Full logs of runs are stored in ~/tacas22/ITS-tools-MCC/tapaalLog/ ~/tacas22/ITS-tools-MCC/itsLog/"

echo "Successfully generated results CSV for tapaal and ITS. See ~/tacas22/ITS-tools-MCC/logTapaal.csv and ~/tacas22/ITS-tools-MCC/logITS.csv (using Perl)"

# back to home folder
cd

##########################
### Step 3 : build tables from the CSV + formulas of literature

echo -e "***************************\nPart 3 : table 2 on LTL sensitivity\n***************************"
echo "Press enter for Step 3"
read input


cd ~/tacas22/LTLPatterns

# run shorter experiments : all properties from Dwyer and Spot, skip RERS (1 hour ?)
# only use the models treated at step 1 for MCC.
# you can edit this script to include RERS models.
./collect_stats.sh

# Warning the mcc data reported correspond to the values computed above at step 1,
# so they concern only 3 models if you are running this demo.sh script.

echo "Warning the mcc data reported correspond to the values computed above at step 1, so they concern only 3 models if you are running this demo.sh script. RERS data (2k formulas) skipped it takes ~ 1 hour."


############################
##########################
### Step 4 : build tables and plots from the CSV

echo -e "***************************\nPart 4 : scatter plots \n***************************"
echo "Press enter for Step 4"
read input


cd ~/tacas22/Rscripts

cd clusterLog/
# run analysis
Rscript ../plots.R

evince plots.pdf &

cd ..

echo "Warning these plots are based on logs collected on our cluster. They were used for the figures of the paper"
read input

cd localLog/

# rename log, kill header line
tail -n +2 ~/tacas22/ITS-Tools-MCC/reduction.csv > ./slclltl.csv
# rename
cp ~/tacas22/ITS-Tools-MCC/logITS.csv logsITS.csv
# copy
cp ~/tacas22/ITS-Tools-MCC/logTapaal.csv .


# run analysis
Rscript ../plots.R

evince plots.pdf &

cd -

echo "Warning the mcc data reported correspond to the values computed at step 1 (so don't expect many points on the scatter plots)."
read input


