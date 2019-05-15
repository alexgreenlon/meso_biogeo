library("ggplot2")
library(reshape2)

syntwindat<-read.table("greenlon-meso-biogeo-data/synt-window.all-by-all.comparisons.num.txt",header=T)
syntwindf<-data.frame(source = syntwindat$source.num, ref = syntwindat$ref.num,nRF=syntwindat$nRF)

ggplot(syntwindf,aes(source,ref)) + geom_tile(aes(fill = nRF), colour = "white") + scale_fill_gradient(low="red",high="yellow") +
  ylab("Syntenic-gene order in symbiosis-island genes") + xlab("") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(), panel.border=element_blank(), legend.position = "none") +
  scale_x_continuous(position = "top") +
    ggsave("F4B.synt-window.nRF.png",bg="transparent")

acast(syntwindf,source~ref,value.var="nRF")
excelheatmap<-acast(syntwindf,source~ref,value.var="nRF")
write.table(excelheatmap,"synt-window.gene-heatmap.txt")

syntdat<-read.table("greenlon-meso-biogeo-data/synt.all-by-all.comparisons.min-max.txt",header=T)
syntdf<-data.frame(source = syntdat$source.ord, ref = syntdat$ref.ord,nRF=syntdat$nRF)
ggplot(syntdf,aes(source,ref)) + geom_tile(aes(fill = nRF), colour = "white") + scale_fill_gradient(low="red",high="yellow") +
  ylab("Syntenic-gene order in symbiosis-island genes") + xlab("") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank()) +
#    scale_x_discrete(position = "top") + theme(legend.position="none")
    ggsave("synt-genes.nRF.png")

turksymcoredat<-read.csv("greenlon-meso-biogeo-data/core-gene-phylogenies.pb-plus-turk-mesos.all-by-all-sorted.csv",header=T)
turksymcoredf<-data.frame(source = turksymcoredat$source.ord, ref = turksymcoredat$ref.ord,nRF=turksymcoredat$nRF)

ggplot(turksymcoredf,aes(source,ref)) + geom_tile(aes(fill = nRF), colour = "white") + scale_fill_gradient(low="red",high="yellow") +
  ylab("Syntenic-gene order in symbiosis-island genes") + xlab("") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank()) +
  ggsave("turk-and-pb-sym-core.nRF.png")

symcoredat<-read.table("greenlon-meso-biogeo-data/core-gene-phylogenies-sliding-windows.all-by-all.min-support-91.ordered.txt",header=F)
symcoredf<-data.frame(source = symcoredat$V1, ref = symcoredat$V2,nRF=symcoredat$V3)

ggplot(symcoredf,aes(source,ref)) + geom_tile(aes(fill = nRF), colour = "white") + scale_fill_gradient(low="red",high="yellow") +
  ylab("Syntenic-gene order in symbiosis-island genes") + xlab("") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank()) +
  ggsave("sym-core-windows.nRF.png")
