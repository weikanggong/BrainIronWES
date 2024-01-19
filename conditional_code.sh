#!/bin/bash
#BATCH -p DCU
#SBATCH -N 1
#SBATCH -n 9
#SBATCH --ntasks-per-node=9
#SBATCH -o %j.out
#SBATCH -e %j.err
cd /home1/Huashan1/zdd_data/Fuyan/conditional/
#ARMC5 chr16:31,458,080-31,467,167
gene='ARMC5'
path1='/home1/Huashan1/zdd_data/Fuyan/conditional'
plink --bfile /share_storage/home1/Vinceyang/UKB_gene_v3_imp_qc/UKB_gene_v3_imp_qc_chr16 \
--chr 16 \
--from-bp 30958080 \
--to-bp 31967167 \
--maf 0.005 \
--make-bed \
--out ${path1}/${gene}_common_maf0.005

#Left_Dentate
pheno='Left_Dentate'
#ARMC5
gene='ARMC5'
i='16'
plink2 --bfile ${path2}/${gene}_common_maf0.005 \
--remove ${path4}/QC/data/ID_unavailable.txt \
--exclude /share_storage/home1/Vinceyang/dyt_data/GWAS/sh/snp_chr${i}.txt \
--glm hide-covar \
--covar ${path2}/${pheno}/cov.txt \
--covar-variance-standardize \
--pheno ${path2}/${pheno}/${pheno}.txt \
--geno 0.1 \
--hwe 1e-50 midp \
--out ${path2}/${pheno}/${gene}_${pheno}_gwas_result

pheno='Left_Dentate'
#ARMC5
gene='ARMC5'
i='16'
/home1/Huashan1/wbs_data/software/plink1.9/plink --bfile /share_storage/home1/Vinceyang/dyt_data/GWAS/data/1000G_Phase_3/EUR/EUR.1kg.phase3.v5a \
--clump ${path2}/${pheno}/${gene}_${pheno}_gwas_result.PHENO1.glm.linear \
--clump-p1 1e-05 \
--clump-r2 0.1 \
--clump-field P \
--clump-snp-field ID \
--out ${path2}/${pheno}/clump/${gene}_${pheno}_gwas_result

###exclude clumpped independant SNPs as covariants####
Pheno="pheno"
i=3
Rscript  step1_fitNULLGLMM.R \
--sparseGRMFile=/UKB_GRM_relatednessCutoff_0.05_5000_randomMarkersUsed_unrelated_2nd_relatednessCutoff_0.05_5000_randomMarkersUsed.sparseGRM.mtx \
--sparseGRMSampleIDFile=/UKB_GRM_relatednessCutoff_0.05_5000_randomMarkersUsed_unrelated_2nd_relatednessCutoff_0.05_5000_randomMarkersUsed.sparseGRM.mtx.sampleIDs.txt \
--plinkFile=/ukb_wes_chr${i}_sample_qc_final_unrelated \
--useSparseGRMtoFitNULL=FALSE \
--useSparseGRMforVarRatio=TRUE \
--nThreads=30 \
--IsOverwriteVarianceRatioFile=TRUE \
--isCovariateOffset=FALSE \
--traitType=quantitative \
--isCateVarianceRatio=FALSE \
--cateVarRatioMinMACVecExclude=20 \
--cateVarRatioMaxMACVecInclude=50000 \
--phenoFile=conditional_data.csv \
--phenoCol=${Pheno} \
--covarColList=PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10,sex,age,snp1,snp2,snp3 \
--qCovarColList=sex \
--sampleIDColinphenoFile=eid \
--outputPrefix=${Pheno}_s1_chr${i} \
--IsOverwriteVarianceRatioFile=TRUE

i=4
Rscript step2_SPAtests.R \
--bedFile=/ukb_wes_chr${i}_sample_qc_final_unrelated.bed \
--bimFile=/ukb_wes_chr${i}_sample_qc_final_unrelated.bim \
--famFile=/ukb_wes_chr${i}_sample_qc_final_unrelated.fam \
--sparseGRMFile=/UKB_GRM_relatednessCutoff_0.05_5000_randomMarkersUsed_unrelated_2nd_relatednessCutoff_0.05_5000_randomMarkersUsed.sparseGRM.mtx \
--sparseGRMSampleIDFile=/UKB_GRM_relatednessCutoff_0.05_5000_randomMarkersUsed_unrelated_2nd_relatednessCutoff_0.05_5000_randomMarkersUsed.sparseGRM.mtx.sampleIDs.txt \
--groupFile=/SnpEff_gene_group_chr${i}.txt \
--AlleleOrder=ref-first \
--minMAF=0 \
--minMAC=0.5 \
--annotation_in_groupTest="lof,missense:lof" \
--is_output_markerList_in_groupTest=TRUE \
--LOCO=FALSE \
--is_fastTest=FALSE \
--maxMAF_in_groupTest=0.0001,0.001,0.01 \
--GMMATmodelFile=/${Pheno}_s1_chr${i}.rda \
--varianceRatioFile=/${Pheno}_s1_chr${i}.varianceRatio.txt \
--SAIGEOutputFile=/${Pheno}_gene_s2_chr${i}.txt

