# facets wrappers
Scripts to run FACETS (https://github.com/mskcc/facets) on Costello lab exome data


1. Make your run config file: Run create_input_snp_pileup.py on the latest version of the config file and then subset it to contain only the patients you care about.
2. Run: To both perform the required upstream analysis plus the FACETS run itself, run the command “qsub -l vmem=20gb run_snp-pileup.sh”, which takes the bam files specified in the snp_pileup_input.txt (the config file you made in step 1), performs a pileup on them, and then performs FACETS on each tumor:normal combo.
