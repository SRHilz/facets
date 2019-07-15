# Created: 2018.02.09
# By: Stephanie R Hilz

# Usage: Runs FACETs

library(facets)

# User supplied variables
args = commandArgs(trailingOnly=TRUE)
dirPath <- args[1] 

out = c('sample', 'dipLogR', 'purity', 'ploidy')

for (file in list.files(path=dirPath, pattern='*.gz')){
  print(file)
  local = c()
  rcmat = readSnpMatrix(paste0(dirPath, file))
  local <- append(local, gsub('[.]gz','', file))
  xx = preProcSample(rcmat)
  oo = procSample(xx, cval=150)
  local <- append(local, oo$dipLogR)
  fit = emcncf(oo)
  print(fit$purity)
  local <- append(local, fit$purity)
  local <- append(local, fit$ploidy)
  pdf(gsub('[.]gz','_samplePlot.pdf', file))
  plotSample(x=oo, emfit=fit)
  dev.off()
  pdf(gsub('[.]gz','_sampleSpiderPlot.pdf', file))
  logRlogORspider(oo$out, oo$dipLogR)
  dev.off()
  out <- rbind(out, local)
}

write.table(out, file=paste0(dirPath,'/','FACETS.txt'), col.names=FALSE, quote=FALSE, row.names=FALSE, sep='\t')