#!/bin/bash
#BATCH -p DCU
#SBATCH -N 1
#SBATCH -n 9
#SBATCH --ntasks-per-node=9
#SBATCH -o %j.out
#SBATCH -e %j.err
pheno="Left_Dentate"
##RNASE12
gene='RNASE12'
i="14" # i denotes chr
for t in {1..26};do
Rscript /home1/Huashan1/SAIGE/extdata/step2_SPAtests.R \
--bedFile=/home1/Huashan1/UKB_WES_data/qcstep5/unrelated_0_0884/ukb_wes_chr${i}_sample_qc_final_unrelated.bed \
--bimFile=/home1/Huashan1/UKB_WES_data/qcstep5/unrelated_0_0884/ukb_wes_chr${i}_sample_qc_final_unrelated.bim \
--famFile=/home1/Huashan1/UKB_WES_data/qcstep5/unrelated_0_0884/ukb_wes_chr${i}_sample_qc_final_unrelated.fam \
--SAIGEOutputFile=${file1}${pheno}/result/${gene}/snp${t}.txt \#different SNP file exclude every SNP
--AlleleOrder=ref-first \
--minMAF=0 \
--minMAC=0.5 \
--GMMATmodelFile=/home1/Huashan1/zdd_data/Fuyan/SAIGE/${pheno}/STEP1/${pheno}_s1_chr${i}.rda \
--varianceRatioFile=/home1/Huashan1/zdd_data/Fuyan/SAIGE/${pheno}/STEP1/${pheno}_s1_chr${i}.varianceRatio.txt \
--sparseGRMFile=/home1/Huashan1/UKB_WES_data/SAIGE/Huashan1/GRM/UKB_GRM_relatednessCutoff_0.05_5000_randomMarkersUsed_unrelated_2nd_relatednessCutoff_0.05_5000_randomMarkersUsed.sparseGRM.mtx \
--sparseGRMSampleIDFile=/home1/Huashan1/UKB_WES_data/SAIGE/Huashan1/GRM/UKB_GRM_relatednessCutoff_0.05_5000_randomMarkersUsed_unrelated_2nd_relatednessCutoff_0.05_5000_randomMarkersUsed.sparseGRM.mtx.sampleIDs.txt \
--groupFile=${file1}${gene}/snp${t}.txt \
--annotation_in_groupTest="lof,misszense:lof" \
--maxMAF_in_groupTest=0.00001,0.0001,0.001,0.01 \
--is_output_markerList_in_groupTest=TRUE \
--LOCO=FALSE \
--is_fastTest=TRUE