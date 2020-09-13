#!/bin/bash
#
##
#$ -clear
#$ -S /bin/bash
#$ -cwd
#$ -j y
#

cd $PBS_O_WORKDIR
rscript=/home/shared/cbc/software_cbc/R/R-3.4.4-20180315/bin/Rscript

# USAGE: To run, make sure input file is up to date and launch with "qsub -l vmem=20gb run_snp-pileup.sh"

# PART 1: creates input arrays from a samples file (snp_pileup_input.txt) that we will loop through - only things in this file will be run through the pipeline
patientARRAY=($(cat /costellolab/data1/shilz/tools/facets/snp_pileup_input.txt | cut -f 1))
normalidARRAY=($(cat /costellolab/data1/shilz/tools/facets/snp_pileup_input.txt | cut -f 2))
tumoridARRAY=($(cat /costellolab/data1/shilz/tools/facets/snp_pileup_input.txt | cut -f 3))
normalbamARRAY=($(cat /costellolab/data1/shilz/tools/facets/snp_pileup_input.txt | cut -f 4))
tumorbamARRAY=($(cat /costellolab/data1/shilz/tools/facets/snp_pileup_input.txt | cut -f 5))
sampleARRAY=($(cat /costellolab/data1/shilz/tools/facets/snp_pileup_input.txt | cut -f 6))

# PART 2: Loops through arrays above and runs snp-pileup, a piece of c++ code that prepares FACETS input from bam files
for ((i=0; i<${#patientARRAY[*]}; i++));
do
    mkdir -p /costellolab/data1/shilz/data/facets/${patientARRAY[i]}
    ~/tools/snp-pileup -g -q15 -Q20 -P100 -r25,0 -d1000 ~/database/commonSNPs/hg19/00-common_all.vcf /costellolab/data1/shilz/data/facets/${patientARRAY[i]}/${patientARRAY[i]}_${sampleARRAY[i]}_${normalidARRAY[i]}_vs_${tumoridARRAY[i]} ${normalbamARRAY[i]} ${tumorbamARRAY[i]}
done

# PART 3: Runs FACETS by patient, and creates a final output summary file, FACETS.txt, for each patient, which includes the purity for each sample
#patientARRAY=(Patient469 Patient486) # can use this to override PART 1 if ever just want to rerun facets post-PART2 (comment both parts out) for specific patients
patientuniqARRAY=($(echo "${patientARRAY[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
for patient in ${patientuniqARRAY[@]}
do
    echo $patient
    ${rscript} /costellolab/data1/shilz/tools/facets/runFACETS.R /costellolab/data1/shilz/data/facets/${patient}/
done
echo "Finished"
