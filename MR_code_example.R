###################################################MR##########################################
#load packages
library(TwoSampleMR)
library(MRInstruments)
library(data.table)
library(tidyr)
library(plyr)

#prepare exposure data
for (i in c("X24467","X24468","X24469","X24470","X24471","X24472","X24473","X24474","X24475","X24476","X24477","X24478","X24479","X24480","X24481","X24482","Left_red_nucleus","Right_red_nucleus","Left_subthalamic_nucleus","Right_subthalamic_nucleus","Left_globus_pallidus_externa","Right_globus_pallidus_externa","Left_globus_pallidus_interna","Right_globus_pallidus_interna","Left_Dentate","Right_Dentate")) {
  pheno<-i
  file_path<-paste("/path/total.",pheno,".glm.linear",sep = "")
  exposure_data<- as.data.frame(fread(file_path))
  names(exposure_data)[1]<-"CHR"
  exposure_data<-format_data(exposure_data,
                             snp_col = "ID",beta_col = "BETA",
                             se_col = "SE",effect_allele_col = "A1",
                             other_allele_col = "AX",eaf_col ="A1_FREQ",
                             pval_col = "P",samplesize_col = "OBS_CT",
                             chr_col = "CHR",pos_col ="POS")
  exposure_data<-exposure_data[exposure_data$pval.exposure<5e-8,]
  exposure_data_clumped<-clump_data(exposure_data,clump_r2 = 0.01)
  write.csv(exposure_data_clumped,paste("/path/",pheno,"_clumped_5e8_ld0.01.csv",sep=""),row.names = F,quote = F)
}

#prepare outcome data
for (i in c("X24467","X24468","X24469","X24470","X24471","X24472","X24473","X24474","X24475","X24476","X24477","X24478","X24479","X24480","X24481","X24482","Left_red_nucleus","Right_red_nucleus","Left_subthalamic_nucleus","Right_subthalamic_nucleus","Left_globus_pallidus_externa","Right_globus_pallidus_externa","Left_globus_pallidus_interna","Right_globus_pallidus_interna","Left_Dentate","Right_Dentate")) {
  file_name<-i
  file_path<-paste("/path/",file_name,"_clumped.csv",sep = "")
  exposure_data_clumped_variants<-as.data.frame(fread(file_path))
  
  ###AD
  outcome_data<-read_outcome_data(snps=exposure_data_clumped_variants$SNP,filename="/path/AD_Kunkle2019.txt",
                                  sep="\t",snp_col = "MarkerName",beta_col = "Beta",
                                  se_col = "SE",effect_allele_col = "Effect_allele",
                                  other_allele_col = "Non_Effect_allele",
                                  pval_col = "Pvalue",samplesize_col = "N",
                                  chr_col = "CHR",pos_col ="Position")
  write_path<-paste("/path/",file_name,"_AD_Kunkle2019_5e8.txt",sep = "")
  write.table(outcome_data,write_path,sep = "\t",row.names = F,quote = F)
  
  ###PD
  outcome_data<-read_outcome_data(snps=exposure_data_clumped_variants$SNP,filename="/path/PD.txt",
                                  sep=" ",snp_col="SNP",
                                  beta_col="BETA",se_col="SE",
                                  effect_allele_col="A1",
                                  other_allele_col="A2",
                                  eaf_col="FRQ",samplesize_col = "N",
                                  pval_col = "P")
  write_path<-paste("/path/",file_name,"_PD_Nalls2019_5e8.txt",sep = "")
  write.table(outcome_data,write_path,sep = "\t",row.names = F,quote = F)
  
  ###Depression
  outcome_data<-read_outcome_data(snps=exposure_data_clumped_variants$SNP,filename="/path/no23andMe_rmUKBB.txt",
                                  sep="\t",snp_col="SNP",
                                  beta_col="BETA",se_col="SE",
                                  effect_allele_col="A1",
                                  other_allele_col="A2",ncase_col = "Nca",
                                  ncontrol_col = "Nco",     
                                  pval_col = "P")
  write_path<-paste("/path/",file_name,"_Depression_Wray2018_5e8.txt",sep = "")
  write.table(outcome_data,write_path,sep = "\t",row.names = F,quote = F)
  
  ###Bipolar
  outcome_data<-read_outcome_data(snps=exposure_data_clumped_variants$SNP,filename="/path/BIP2019.txt",
                                  sep="\t",snp_col="SNP",
                                  beta_col="BETA",se_col="SE",
                                  effect_allele_col="A1",
                                  other_allele_col="A2",ncase_col = "Nca",
                                  ncontrol_col = "Nco", 
                                  pval_col = "P")
  write_path<-paste("/path/",file_name,"_Bipolar_Stahl2019_5e8.txt",sep = "")
  write.table(outcome_data,write_path,sep = "\t",row.names = F,quote = F)
}

###run MR
result_all<-data.frame(id.exposure=as.character(0),id.outcome=as.character(0),outcome=as.character(0),exposure=as.character(0),method=as.character(0),nsnp=as.numeric(0),b=as.numeric(0),se=as.numeric(0),pval=as.numeric(0),lo_ci=as.numeric(0),up_ci=as.numeric(0),or=as.numeric(0),or_lci95=as.numeric(0),or_uci95=as.numeric(0),pheno_exposure=as.character(0),pheno_outcome=as.character(0),egger_intercept=as.numeric(0),pleiotropy_p=as.numeric(0))

for (pheno in c("X24467","X24468","X24469","X24470","X24471","X24472","X24473","X24474","X24475","X24476","X24477","X24478","X24479","X24480","X24481","X24482","Left_red_nucleus","Right_red_nucleus","Left_subthalamic_nucleus","Right_subthalamic_nucleus","Left_globus_pallidus_externa","Right_globus_pallidus_externa","Left_globus_pallidus_interna","Right_globus_pallidus_interna","Left_Dentate","Right_Dentate")) {
  
  exposure_path<-paste("/path/",pheno,"_clumped.csv",sep="")
  exposure_data_clumped<- as.data.frame(fread(exposure_path))
  
  for (i in c("AD_Kunkle2019","Bipolar_Stahl2019","Depression_Wray2018","PD_Nalls2019")){
    file_path<-paste("/path/",pheno,"_",i,"_5e8.txt",sep = "")
    outcome_data<-as.data.frame(fread(file_path))
    dat<-harmonise_data(exposure_dat=exposure_data_clumped,outcome_dat = outcome_data)
    results<-mr(dat,method_list = c("mr_wald_ratio","mr_egger_regression","mr_weighted_median","mr_ivw_mre"))
    results_OR<-generate_odds_ratios(results)
    results_OR$pheno_exposure<-pheno
    results_OR$pheno_outcome<-i
    results_OR$egger_intercept<-mr_pleiotropy_test(dat)$egger_intercept
    results_OR$pleiotropy_p<-mr_pleiotropy_test(dat)$pval
    result_all<-rbind.fill(result_all,results_OR)
  }
}
write_path<-paste("/path/","result_all.txt",sep = "")
write.table(result_all,write_path,sep = "\t",row.names = F,quote = F)
