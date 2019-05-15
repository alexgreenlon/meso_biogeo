library(ggplot2)
library(sp)
library(seqinr)
library(vegan)
library(reshape2)

load("distance-matrix-regression-analyses.12.6.18.Robj")

obvi.phylophlanaln<-read.alignment("obvi-meso-and-min-meso-refs.phylophlan-markers.concat.aln.ffn",format="fasta")
obvi.phylophlandist<-as.matrix(dist.alignment(obvi.phylophlanaln,matrix="identity"))
phylophlanaln<-read.alignment("nod-meso.phylophlan-markers.concat.aln.fasta",format="fasta")
phylophlandist<-as.matrix(dist.alignment(phylophlanaln,matrix="identity"))
symaln<-read.alignment("nod-meso.sym-genes.concat.aln.no-blanks.fasta",format="fasta")
symdist<-as.matrix(dist.alignment(symaln,matrix="identity"))
panaln<-read.alignment("all.accessory_binary_genes.all-obvi-i-90.TG.fasta",format="fasta")
pandist<-as.matrix(dist.alignment(panaln,matrix="identity"))

geopoints<-read.csv("nod-meso.lat-lon.etc.csv",header=T)
geomat2<-data.frame(x=geopoints$lon,y=geopoints$lat)
geodist2<-spDists(as.matrix(geomat2),longlat=TRUE)
rownames(geodist2)<-geopoints$sample
colnames(geodist2)<-geopoints$sample

alldata<-read.csv("all-genomes.all-info.5.4.18.tsv",header=T,row.names=2,sep='\t')
alldatasub<-alldata[rownames(geodist2),]

obvi.meso.data<-read.table("ovbi-meso-data.txt",sep="\t",header=T)
fields.list<-read.table("fields-for-ani-analysis.txt",header=F)

phylophlandistsub<-phylophlandist[rownames(alldatasub),rownames(alldatasub)]
pandist.sub<-pandist[rownames(alldatasub),rownames(alldatasub)]
symdistsub<-symdist[rownames(alldatasub),rownames(alldatasub)]
geodist2sub<-geodist2[rownames(alldatasub),rownames(alldatasub)]

pandist.sub.sq=pandist.sub*pandist.sub
phylophlandist.sq=phylophlandist*phylophlandist

mantel(pandist.sub,phylophlandistsub)
mantel(pandist.sub,geodist2sub)
mantel(phylophlandistsub,geodist2sub)

alldata5a<-subset(alldata.sub,revised.ani.otu=="5A")
phylophlandist5a<-phylophlandist[rownames(alldata5a),rownames(alldata5a)]
pandist5a<-pandist[rownames(alldata5a),rownames(alldata5a)]
symdist5a<-symdist[rownames(alldata5a),rownames(alldata5a)]
geodist25a<-geodist2[rownames(alldata5a),rownames(alldata5a)]

mantel(pandist5a,phylophlandist5a)
mantel(pandist5a,geodist25a)
mantel(phylophlandist5a,geodist25a)

library(ecodist)
MRM(as.dist(pandist.sub)~as.dist(geodist2sub)+as.dist(phylophlandistsub))
MRM(as.dist(pandist5a)~as.dist(geodist25a)+as.dist(phylophlandist5a))

df<-data.frame(pan=pandist.sub[lower.tri(pandist.sub)],phylo=phylophlandistsub[lower.tri(phylophlandistsub)],geo=geodist2sub[lower.tri(geodist2sub)])
ggplot(df,aes(x=geo,y=pan,color=phylo))+geom_point()+scale_color_gradient(low="blue",high="red")

ggplot(df,aes(x=phylo,y=pan,color=geo)) + geom_point(size=0.1,alpha=0.5) + scale_color_gradient(low="red",high="yellow") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.line = element_line(colour = "black", size = 1, linetype = "solid")) +
    ylab("Pangenome distance")+xlab("Nucleotide difference (1 - ANI)")+labs(color="Geographic \ndistance (km)") +
    theme(legend.position = c(0.2,0.8)) +
    ggsave("F3C.core-vs-pan-vs-geo-dist.png")

alldist<-read.table("geophylosymdists.pangenome-set.txt",header=T)
nams=with(alldist,unique(c(as.character(min.genome),as.character(max.genome))))
geodist<-with(alldist,structure(geodist,Size=length(nams),Labels=nams,Diag=FALSE,Upper=FALSE,method="user",class="dist"))
nodanddist<-with(alldist,structure(phylophlan.marker.and,Size=length(nams),Labels=nams,Diag=FALSE,Upper=FALSE,method="user",class="dist"))
nodsymdist<-with(alldist,structure(sym.gene.and,Size=length(nams),Labels=nams,Diag=FALSE,Upper=FALSE,method="user",class="dist"))

andlong<-read.csv("and.all-pairs.csv",header=T)
nams=with(andlong,unique(c(as.character(A),as.character(B))))
anddist<-as.matrix(with(andlong,structure(and,Size=length(nams),Labels=nams,Diag=FALSE,Upper=FALSE,method="user",class="dist")))

df<-data.frame(pan=pandist.sub[lower.tri(pandist.sub)],phylo=phylophlandist[lower.tri(phylophlandist)],geo=geodist2sub[lower.tri(geodist2sub)],pan.sq=pandist.sub.sq[lower.tri(pandist.sub.sq)],phylo.sq=phylophlandist.sq[lower.tri(phylophlandist.sq)]))
ggplot(df,aes(x=phylo.sq,y=pan.sq,color=geo))+geom_point(size=0.1,alpha=0.5)+scale_color_gradient(low="red",high="yellow")+ylab("Pangenome distance")+xlab("Nucleotide difference (1 - ANI)")+labs(color="Geographic \ndistance (km)")

obvi.phylophlandist.test<-obvi.phylophlandist
obvi.phylophlandist.test[lower.tri(obvi.phylophlandist.test,diag=T)]<-NA
obvi.phylophlandist.long<-data.frame(Var1=character(),Var2=character(),value=double(),field=character(),inoc=character(),stringsAsFactors=FALSE)
field.df<-data.frame(row.names=as.vector(fields.list$V1))
for (i in 1:length(rownames(fields.list))){
  field<-toString(fields.list$V1[i])
  inoc<-toString(fields.list$V2[i])
  g.in.field<-as.vector(obvi.meso.data[which(obvi.meso.data$unique.field==field),]$sample_title)
  field.df[field,1]<-mean(obvi.phylophlandist.test[g.in.field,g.in.field],na.rm=T)
  temp.df<-melt(as.matrix(obvi.phylophlandist.test[g.in.field,g.in.field]))
  temp.df$field<-field
  temp.df$inoc<-inoc
  obvi.phylophlandist.long<-rbind(obvi.phylophlandist.long,temp.df)
}
field.df

obvi.phylophlandist.long<-subset(obvi.phylophlandist.long,value!="NA")
t.test(obvi.phylophlandist.long$value ~ obvi.phylophlandist.long$inoc)

country.list<-c("AU","CA","ET","IN","MR","TU","US")
obvi.phylophlandist.country.long<-data.frame(Var1=character(),Var2=character(),value=double(),field=character(),inoc=character(),stringsAsFactors=FALSE)

for (i in 1:length(country.list)){
  country<-toString(country.list[i])
  g.in.country<-as.vector(obvi.meso.data[which(obvi.meso.data$Country.of.origin==country),]$sample_title)
  temp.df<-melt(as.matrix(obvi.phylophlandist.test[g.in.country,g.in.country]))
  temp.df$country<-country
  obvi.phylophlandist.country.long<-rbind(obvi.phylophlandist.country.long,temp.df)
}

obvi.phylophlandist.country.long<-subset(obvi.phylophlandist.country.long,value!="NA")
tapply(obvi.phylophlandist.country.long$value,obvi.phylophlandist.country.long$country,mean)

country.lm<-lm(obvi.phylophlandist.country.long$value ~ obvi.phylophlandist.country.long$country)
summary(country.lm)
anova(country.lm)

country.aov<-aov(obvi.phylophlandist.country.long$value ~ obvi.phylophlandist.country.long$country)
TukeyHSD(x=country.aov)

all.assigned.data<-read.table("all-ani-assigned-genomes.data.tsv",header=T,sep='\t')
country.counts<-table(all.assigned.data$Country.of.origin,all.assigned.data$ANI95.OTU)
rowSums(country.counts)
diversity(country.counts)
diversity(rrarefy(country.counts[2:7,],sample=40))
diversity(rrarefy(country.counts,sample=6))
