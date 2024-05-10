# BrainIronWES

The code used in the paper Gong et al. "Whole-Exome Sequencing Identifies Protein-Coding Variants Associated with Brain Iron in 29,828 Individuals" in Nature Communications (2024).

The data utilized for these analyses originates from the UK Biobank cohort.

For the operation of this project, the installation of the following software or package is required:
SAIGE-GENE+ R package (https://github.com/saigegit/SAIGE)
TwoSampleMR version 0.5.6 R package (MRCIEU/TwoSampleMR: R package for performing 2-sample MR using MR-Base database (github.com))
PLINK v2.0 (https://www.cog-genomics.org/plink/2.0/)

The scripts EWAS_code.sh, Common_code.sh, and LOVO_code.sh utilize the SAIGE-GENE+ package for the identification of genetic variants associated with brain iron accumulation. Specifically, EWAS_code.sh is used for detecting rare variants, Common_code.sh for common variants, and LOVO_code.sh is employed to identify the most significant variants driving the observed associations.

The scripts conditional_code.sh utilize the SAIGE-GENE+ package and PLINK software to assess the interaction of rare and common variants.

The scripts MR_code_example.R utilize the TwoSampleMR package to validate 490 the causal relationship and the simulate_WES_power.R was used to show the power calculation of the cohorts.
![image](https://github.com/weikanggong/BrainIronWES/assets/13175862/b70c0620-bac1-4ecd-9378-7840c9463441)

