setwd("/path/")
wes_results =  read.csv('WES_results.csv')

cMAC <- c(seq(1, 50, 5),seq(50, 350, 50))
cBETA <- wes_results$BETA_Burden
cSE <- wes_results$SE_Burden
ratio = cBETA/cSE
indx = order(abs(ratio))
#print(ratio[indx])
cBETA = cBETA[indx]
cSE = cSE[indx]

N <- 30620

set.seed(2024)
power <- data.frame(matrix(0, nrow = length(cMAC), ncol = length(cBETA[seq(1,length(cBETA),20)])))
colnames(power) <- paste("cBETA", cBETA[seq(1,length(cBETA),20)], sep = "_")
rownames(power) <- paste("cMAC", cMAC, sep = "_")

start_time <- Sys.time()
for (k in 1:17) {
  for (n in seq(1,length(cBETA),20)) {
      p <- c(rep(0, 1000))
      i = 1
      while (i <= 1000) {
        x <- c(rep(1, cMAC[k]), rep(0, N - cMAC[k]))
        x <- sample(x)
        x <- (x - mean(x))/  sqrt(var(x))
        #print(x)
        y = rnorm(N, mean = cBETA[n] * x, sd = sqrt(N)*cSE[n])
        dat <- data.frame(cbind(x, y))
        fit <- lm(y ~ x, data = dat)
        p[i] <- summary(fit)$coefficients[2, 4]
        i <- i + 1
    }
    power[k, (n-1)/20+1] <- length(p[p < 1.7e-8]) / length(p)
    #rm(p)
    print(paste(k, (n-1)/20+1,"finished"))
    print(paste("Power:",power[k, (n-1)/20+1]))
  }
}

write.csv(power, "power.csv", quote = F)

end_time <- Sys.time()
end_time - start_time
