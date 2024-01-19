#!/bin/bash
#BATCH -p DCU
#SBATCH -N 1
#SBATCH -n 9
#SBATCH --ntasks-per-node=9
#SBATCH -o %j.out
#SBATCH -e %j.err
conda activate RSAIGE
Pheno="pheno"
echo ${Pheno}
cd /${Pheno}/
	for i in {4,5,6,12,13,14,15};do
	Rscript /step2_SPAtests.R \
	--bedFile=/ukb_wes_chr${i}_sample_qc_final_unrelated.bed \
	--bimFile=/ukb_wes_chr${i}_sample_qc_final_unrelated.bim \
	--famFile=/ukb_wes_chr${i}_sample_qc_final_unrelated.fam \
	--sparseGRMFile=/UKB_GRM_relatednessCutoff_0.05_5000_randomMarkersUsed_unrelated_2nd_relatednessCutoff_0.05_5000_randomMarkersUsed.sparseGRM.mtx \
	--sparseGRMSampleIDFile=/UKB_GRM_relatednessCutoff_0.05_5000_randomMarkersUsed_unrelated_2nd_relatednessCutoff_0.05_5000_randomMarkersUsed.sparseGRM.mtx.sampleIDs.txt \
	--AlleleOrder=alt-first \
	--minMAF=0 \
	--minMAC=0.5 \
  --pCutoffforFirth=0.05 \
  --is_Firth_beta=TRUE \
  --is_output_moreDetails=TRUE \
	--LOCO=FALSE \
	--is_fastTest=FALSE \
	--GMMATmodelFile=/${Pheno}/STEP1/${Pheno}_s1_chr${i}.rda \
	--varianceRatioFile=/${Pheno}/STEP1/${Pheno}_s1_chr${i}.varianceRatio.txt \
	--SAIGEOutputFile=/${Pheno}/single/${Pheno}_common_chr${i}.txt
		done
done