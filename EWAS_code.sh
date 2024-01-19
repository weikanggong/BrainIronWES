#!/bin/bash
#BATCH -p DCU
#SBATCH -N 1
#SBATCH -n 9
#SBATCH --ntasks-per-node=9
#SBATCH -o %j.out
#SBATCH -e %j.err
conda activate RSAIGE
Pheno="pheno"
mkdir ${Pheno}
echo ${Pheno}
cd /${Pheno}/
mkdir STEP1
mkdir STEP2
for i in {1..22};do
	Rscript  step1_fitNULLGLMM.R \
   --sparseGRMFile=UKB_GRM_relatednessCutoff_0.05_5000_randomMarkersUsed_unrelated_2nd_relatednessCutoff_0.05_5000_randomMarkersUsed.sparseGRM.mtx \
    --sparseGRMSampleIDFile=UKB_GRM_relatednessCutoff_0.05_5000_randomMarkersUsed_unrelated_2nd_relatednessCutoff_0.05_5000_randomMarkersUsed.sparseGRM.mtx.sampleIDs.txt \
		--plinkFile=/ukb_wes_chr${i}_sample_qc_final_unrelated \
		--useSparseGRMtoFitNULL=FALSE \
		--useSparseGRMforVarRatio=TRUE \
		--nThreads=40 \
		--IsOverwriteVarianceRatioFile=TRUE \
		--isCovariateOffset=FALSE \
		--traitType=quantitative \
		--isCateVarianceRatio=FALSE \
		--cateVarRatioMinMACVecExclude=20 \
		--cateVarRatioMaxMACVecInclude=50000 \
		--phenoFile=T2star_data_omna.csv \
		--phenoCol=${Pheno} \
		--covarColList=PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10,sex,age \
		--qCovarColList=sex \
		--sampleIDColinphenoFile=eid \
		--outputPrefix=/${Pheno}/STEP1/${Pheno}_s1_chr${i} \
		--IsOverwriteVarianceRatioFile=TRUE #p-value TRUE FALSE
   
   
	Rscript /step2_SPAtests.R \
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
	--GMMATmodelFile=/${Pheno}/STEP1/${Pheno}_s1_chr${i}.rda \
	--varianceRatioFile=/${Pheno}/STEP1/${Pheno}_s1_chr${i}.varianceRatio.txt \
	--SAIGEOutputFile=/${Pheno}/STEP2/${Pheno}_s2_chr${i}.txt
 done