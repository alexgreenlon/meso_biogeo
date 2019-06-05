library(ggplot2)

otu7A.cons.table<-read.table("results/pangenome/roary/phylophlan-markers-ani-groups/i-90/Otu01/number_of_conserved_genes.Rtab")
otu7A.cons<-colMeans(otu7A.cons.table)
otu7A.cons.sd<-apply(otu7A.cons.table,2,sd)
otu7A.tot.table<-read.table("results/pangenome/roary/phylophlan-markers-ani-groups/i-90/Otu01/number_of_genes_in_pan_genome.Rtab")
otu7A.tot<-colMeans(otu7A.tot.table)
otu7A.tot.sd<-apply(otu7A.tot.table,2,sd)
otu7A.genes=data.frame(genes_to_genomes = c(otu7A.cons,otu7A.tot),genomes = c(c(1:length(otu7A.cons)),c(1:length(otu7A.cons))),Key = c(rep("Conserved genes",length(otu7A.cons)), rep("Total genes",length(otu7A.tot))))

otu5C.cons.table<-read.table("results/pangenome/roary/phylophlan-markers-ani-groups/i-90/Otu02/number_of_conserved_genes.Rtab")
otu5C.cons<-colMeans(otu5C.cons.table)
otu5C.cons.sd<-apply(otu5C.cons.table,2,sd)
otu5C.tot.table<-read.table("results/pangenome/roary/phylophlan-markers-ani-groups/i-90/Otu02/number_of_genes_in_pan_genome.Rtab")
otu5C.tot<-colMeans(otu5C.tot.table)
otu5C.tot.sd<-apply(otu5C.tot.table,2,sd)
otu5C.genes=data.frame(genes_to_genomes = c(otu5C.cons,otu5C.tot),genomes = c(c(1:length(otu5C.cons)),c(1:length(otu5C.cons))),Key = c(rep("Conserved genes",length(otu5C.cons)), rep("Total genes",length(otu5C.tot))))

otu1A.cons.table<-read.table("results/pangenome/roary/phylophlan-markers-ani-groups/i-90/Otu03/number_of_conserved_genes.Rtab")
otu1A.cons<-colMeans(otu1A.cons.table)
otu1A.cons.sd<-apply(otu1A.cons.table,2,sd)
otu1A.tot.table<-read.table("results/pangenome/roary/phylophlan-markers-ani-groups/i-90/Otu03/number_of_genes_in_pan_genome.Rtab")
otu1A.tot<-colMeans(otu1A.tot.table)
otu1A.tot.sd<-apply(otu1A.tot.table,2,sd)
otu1A.genes=data.frame(genes_to_genomes = c(otu1A.cons,otu1A.tot),genomes = c(c(1:length(otu1A.cons)),c(1:length(otu1A.cons))),Key = c(rep("Conserved genes",length(otu1A.cons)), rep("Total genes",length(otu1A.tot))))

otu5A.cons.table<-read.table("results/pangenome/roary/phylophlan-markers-ani-groups/i-90/Otu04/number_of_conserved_genes.Rtab")
otu5A.cons<-colMeans(otu5A.cons.table)
otu5A.cons.sd<-apply(otu5A.cons.table,2,sd)
otu5A.tot.table<-read.table("results/pangenome/roary/phylophlan-markers-ani-groups/i-90/Otu04/number_of_genes_in_pan_genome.Rtab")
otu5A.tot<-colMeans(otu5A.tot.table)
otu5A.tot.sd<-apply(otu5A.tot.table,2,sd)
otu5A.genes=data.frame(genes_to_genomes = c(otu5A.cons,otu5A.tot),genomes = c(c(1:length(otu5A.cons)),c(1:length(otu5A.cons))),Key = c(rep("Conserved genes",length(otu5A.cons)), rep("Total genes",length(otu5A.tot))))

otu2A.cons.table<-read.table("results/pangenome/roary/phylophlan-markers-ani-groups/i-90/Otu05/number_of_conserved_genes.Rtab")
otu2A.cons<-colMeans(otu2A.cons.table)
otu2A.cons.sd<-apply(otu2A.cons.table,2,sd)
otu2A.tot.table<-read.table("results/pangenome/roary/phylophlan-markers-ani-groups/i-90/Otu05/number_of_genes_in_pan_genome.Rtab")
otu2A.tot<-colMeans(otu2A.tot.table)
otu2A.tot.sd<-apply(otu2A.tot.table,2,sd)
otu2A.genes=data.frame(genes_to_genomes = c(otu2A.cons,otu2A.tot),genomes = c(c(1:length(otu2A.cons)),c(1:length(otu2A.cons))),Key = c(rep("Conserved genes",length(otu2A.cons)), rep("Total genes",length(otu2A.tot))))

otu6A.cons.table<-read.table("results/pangenome/roary/phylophlan-markers-ani-groups/i-90/Otu06/number_of_conserved_genes.Rtab")
otu6A.cons<-colMeans(otu6A.cons.table)
otu6A.cons.sd<-apply(otu6A.cons.table,2,sd)
otu6A.tot.table<-read.table("results/pangenome/roary/phylophlan-markers-ani-groups/i-90/Otu06/number_of_genes_in_pan_genome.Rtab")
otu6A.tot<-colMeans(otu6A.tot.table)
otu6A.tot.sd<-apply(otu6A.tot.table,2,sd)
otu6A.genes=data.frame(genes_to_genomes = c(otu6A.cons,otu6A.tot),genomes = c(c(1:length(otu6A.cons)),c(1:length(otu6A.cons))),Key = c(rep("Conserved genes",length(otu6A.cons)), rep("Total genes",length(otu6A.tot))))

otu4A.cons.table<-read.table("results/pangenome/roary/phylophlan-markers-ani-groups/i-90/Otu07/number_of_conserved_genes.Rtab")
otu4A.cons<-colMeans(otu4A.cons.table)
otu4A.cons.sd<-apply(otu4A.cons.table,2,sd)
otu4A.tot.table<-read.table("results/pangenome/roary/phylophlan-markers-ani-groups/i-90/Otu07/number_of_genes_in_pan_genome.Rtab")
otu4A.tot<-colMeans(otu4A.tot.table)
otu4A.tot.sd<-apply(otu4A.tot.table,2,sd)
otu4A.genes=data.frame(genes_to_genomes = c(otu4A.cons,otu4A.tot),genomes = c(c(1:length(otu4A.cons)),c(1:length(otu4A.cons))),Key = c(rep("Conserved genes",length(otu4A.cons)), rep("Total genes",length(otu4A.tot))))

otu5B.cons.table<-read.table("results/pangenome/roary/phylophlan-markers-ani-groups/i-90/Otu08/number_of_conserved_genes.Rtab")
otu5B.cons<-colMeans(otu5B.cons.table)
otu5B.cons.sd<-apply(otu5B.cons.table,2,sd)
otu5B.tot.table<-read.table("results/pangenome/roary/phylophlan-markers-ani-groups/i-90/Otu08/number_of_genes_in_pan_genome.Rtab")
otu5B.tot<-colMeans(otu5B.tot.table)
otu5B.tot.sd<-apply(otu5B.tot.table,2,sd)
otu5B.genes=data.frame(genes_to_genomes = c(otu5B.cons,otu5B.tot),genomes = c(c(1:length(otu5B.cons)),c(1:length(otu5B.cons))),Key = c(rep("Conserved genes",length(otu5B.cons)), rep("Total genes",length(otu5B.tot))))

otu4B.cons.table<-read.table("results/pangenome/roary/phylophlan-markers-ani-groups/i-90/Otu09/number_of_conserved_genes.Rtab")
otu4B.cons<-colMeans(otu4B.cons.table)
otu4B.cons.sd<-apply(otu4B.cons.table,2,sd)
otu4B.tot.table<-read.table("results/pangenome/roary/phylophlan-markers-ani-groups/i-90/Otu09/number_of_genes_in_pan_genome.Rtab")
otu4B.tot<-colMeans(otu4B.tot.table)
otu4B.tot.sd<-apply(otu4B.tot.table,2,sd)
otu4B.genes=data.frame(genes_to_genomes = c(otu4B.cons,otu4B.tot),genomes = c(c(1:length(otu4B.cons)),c(1:length(otu4B.cons))),Key = c(rep("Conserved genes",length(otu4B.cons)), rep("Total genes",length(otu4B.tot))))

otu1E.cons.table<-read.table("results/pangenome/roary/phylophlan-markers-ani-groups/i-90/Otu10/number_of_conserved_genes.Rtab")
otu1E.cons<-colMeans(otu1E.cons.table)
otu1E.cons.sd<-apply(otu1E.cons.table,2,sd)
otu1E.tot.table<-read.table("results/pangenome/roary/phylophlan-markers-ani-groups/i-90/Otu10/number_of_genes_in_pan_genome.Rtab")
otu1E.tot<-colMeans(otu1E.tot.table)
otu1E.tot.sd<-apply(otu1E.tot.table,2,sd)
otu1E.genes=data.frame(genes_to_genomes = c(otu1E.cons,otu1E.tot),genomes = c(c(1:length(otu1E.cons)),c(1:length(otu1E.cons))),Key = c(rep("Conserved genes",length(otu1E.cons)), rep("Total genes",length(otu1E.tot))))

otu8A.cons.table<-read.table("results/pangenome/roary/phylophlan-markers-ani-groups/i-90/Otu11/number_of_conserved_genes.Rtab")
otu8A.cons<-colMeans(otu8A.cons.table)
otu8A.cons.sd<-apply(otu8A.cons.table,2,sd)
otu8A.tot.table<-read.table("results/pangenome/roary/phylophlan-markers-ani-groups/i-90/Otu11/number_of_genes_in_pan_genome.Rtab")
otu8A.tot<-colMeans(otu8A.tot.table)
otu8A.tot.sd<-apply(otu8A.tot.table,2,sd)
otu8A.genes=data.frame(genes_to_genomes = c(otu8A.cons,otu8A.tot),genomes = c(c(1:length(otu8A.cons)),c(1:length(otu8A.cons))),Key = c(rep("Conserved genes",length(otu8A.cons)), rep("Total genes",length(otu8A.tot))))

otu1C.cons.table<-read.table("results/pangenome/roary/phylophlan-markers-ani-groups/i-90/Otu12/number_of_conserved_genes.Rtab")
otu1C.cons<-colMeans(otu1C.cons.table)
otu1C.cons.sd<-apply(otu1C.cons.table,2,sd)
otu1C.tot.table<-read.table("results/pangenome/roary/phylophlan-markers-ani-groups/i-90/Otu12/number_of_genes_in_pan_genome.Rtab")
otu1C.tot<-colMeans(otu1C.tot.table)
otu1C.tot.sd<-apply(otu1C.tot.table,2,sd)
otu1C.genes=data.frame(genes_to_genomes = c(otu1C.cons,otu1C.tot),genomes = c(c(1:length(otu1C.cons)),c(1:length(otu1C.cons))),Key = c(rep("Conserved genes",length(otu1C.cons)), rep("Total genes",length(otu1C.tot))))

otu2B.cons.table<-read.table("results/pangenome/roary/phylophlan-markers-ani-groups/i-90/Otu13/number_of_conserved_genes.Rtab")
otu2B.cons<-colMeans(otu2B.cons.table)
otu2B.cons.sd<-apply(otu2B.cons.table,2,sd)
otu2B.tot.table<-read.table("results/pangenome/roary/phylophlan-markers-ani-groups/i-90/Otu13/number_of_genes_in_pan_genome.Rtab")
otu2B.tot<-colMeans(otu2B.tot.table)
otu2B.tot.sd<-apply(otu2B.tot.table,2,sd)
otu2B.genes=data.frame(genes_to_genomes = c(otu2B.cons,otu2B.tot),genomes = c(c(1:length(otu2B.cons)),c(1:length(otu2B.cons))),Key = c(rep("Conserved genes",length(otu2B.cons)), rep("Total genes",length(otu2B.tot))))

otu1D.cons.table<-read.table("results/pangenome/roary/phylophlan-markers-ani-groups/i-90/Otu14/number_of_conserved_genes.Rtab")
otu1D.cons<-colMeans(otu1D.cons.table)
otu1D.cons.sd<-apply(otu1D.cons.table,2,sd)
otu1D.tot.table<-read.table("results/pangenome/roary/phylophlan-markers-ani-groups/i-90/Otu14/number_of_genes_in_pan_genome.Rtab")
otu1D.tot<-colMeans(otu1D.tot.table)
otu1D.tot.sd<-apply(otu1D.tot.table,2,sd)
otu1D.genes=data.frame(genes_to_genomes = c(otu1D.cons,otu1D.tot),genomes = c(c(1:length(otu1D.cons)),c(1:length(otu1D.cons))),Key = c(rep("Conserved genes",length(otu1D.cons)), rep("Total genes",length(otu1D.tot))))

#1A="#13073A"
##1B="#261758"
#1C="#403075",
#1D="#615192",
#1E="#887CAF",
#2A="#806D15",
#2B="#AA9739",
##2C="#D4C26A",
##2D="#FFF0AA",
##3A="#6F256F",
#4A="#6A7B15",
#4B="#91A437",
#5A="#123652",
#5B="#29506D",
#5C="#496D89",
#6A="#2D882D",
#7A="#801515",
##7B="#AA3939",
##7D="#D46A6A",
#8A="#AA7939"

color1="#801515" # 7A
color2="#496D89" # 5C
color3="#13073A" # 1A
color4="#123652" # 5A
color5="#806D15" # 2A
color6="#2D882D" # 6A
color7="#6A7B15" # 4A
color8="#29506D" # 5B
color9="#91A437" # 4B
color10="#887CAF" # 1E
color11="#AA7939" # 8A
color12="#403075" # 1C
color13="#AA9739" # 2B
color14="#615192" # 1D

ggplot(data=otu7A.genes,aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key)) + xlim(1,15) + ylim(0,20000) + geom_line(color=color1,size=1.5) +
    geom_line(data=otu5C.genes,aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key),color=color2,size=1.5) +
    geom_line(data=otu1A.genes,aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key),color=color3,size=1.5) +
    geom_line(data=otu5A.genes,aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key),color=color4,size=1.5) +
    geom_line(data=otu2A.genes,aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key),color=color5,size=1.5) +
    geom_line(data=otu6A.genes,aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key),color=color6,size=1.5) +
    geom_line(data=otu4A.genes,aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key),color=color7,size=1.5) +
    geom_line(data=otu5B.genes,aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key),color=color8,size=1.5) +
    geom_line(data=otu4B.genes,aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key),color=color9,size=1.5) +
    geom_line(data=otu1E.genes,aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key),color=color10,size=1.5) +
    geom_line(data=otu8A.genes,aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key),color=color11,size=1.5) +
    geom_line(data=otu1C.genes,aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key),color=color12,size=1.5) +
    geom_line(data=otu2B.genes,aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key),color=color13,size=1.5) +
    geom_line(data=otu1D.genes,aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key),color=color14,size=1.5) +
    xlab("Number of genomes") +ylab("Number of genes") +  theme(legend.justification=c(0,1),legend.position=c(0,1)) +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) + 
    ggsave(filename="results/pangenome/roary/phylophlan-markers-ani-groups/i-90/meso-phylophlan-ani-groups.conserved_vs_total_genes.final-colors.0-15.genomes.no-bg.png", scale=1)

#ggplot(data=otu7A.genes,aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key)) + xlim(1,15) + ylim(0,20000) + geom_line(color=color1,size=1.5) +
ggplot(data=otu7A.genes,aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key)) + geom_line(color=color1,size=1.5) +
    geom_line(data=otu5C.genes,aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key),color=color2,size=1.5) +
    geom_line(data=otu1A.genes,aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key),color=color3,size=1.5) +
    geom_line(data=otu5A.genes,aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key),color=color4,size=1.5) +
    geom_line(data=otu2A.genes,aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key),color=color5,size=1.5) +
    geom_line(data=otu6A.genes,aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key),color=color6,size=1.5) +
    geom_line(data=otu4A.genes,aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key),color=color7,size=1.5) +
    geom_line(data=otu5B.genes,aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key),color=color8,size=1.5) +
    geom_line(data=otu4B.genes,aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key),color=color9,size=1.5) +
    geom_line(data=otu1E.genes,aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key),color=color10,size=1.5) +
    geom_line(data=otu8A.genes,aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key),color=color11,size=1.5) +
    geom_line(data=otu1C.genes,aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key),color=color12,size=1.5) +
    geom_line(data=otu2B.genes,aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key),color=color13,size=1.5) +
    geom_line(data=otu1D.genes,aes(x = genomes, y = genes_to_genomes, group = Key, linetype=Key),color=color14,size=1.5) +
    xlab("Number of genomes") +ylab("Number of genes") +  theme(legend.justification=c(0,1),legend.position=c(0,1)) +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) + 
    ggsave(filename="results/pangenome/roary/phylophlan-markers-ani-groups/i-90/meso-phylophlan-ani-groups.conserved_vs_total_genes.final-colors.no-lim.genomes.no-bg.png", scale=1)

vec.len<-max(length(as.vector(otu7A.cons)),length(as.vector(otu5C.cons)),length(as.vector(otu1A.cons)),length(as.vector(otu5A.cons)),length(as.vector(otu2A.cons)),length(as.vector(otu6A.cons)),length(as.vector(otu4A.cons)),
    length(as.vector(otu5B.cons)),length(as.vector(otu4B.cons)),length(as.vector(otu1E.cons)),length(as.vector(otu8A.cons)),length(as.vector(otu1C.cons)),length(as.vector(otu2B.cons)),length(as.vector(otu1D.cons)))

length(otu5C.cons)<-vec.len
length(otu5C.cons.sd)<-vec.len
length(otu5C.tot)<-vec.len
length(otu5C.tot.sd)<-vec.len

length(otu1A.cons)<-vec.len
length(otu1A.cons.sd)<-vec.len
length(otu1A.tot)<-vec.len
length(otu1A.tot.sd)<-vec.len

length(otu5A.cons)<-vec.len
length(otu5A.cons.sd)<-vec.len
length(otu5A.tot)<-vec.len
length(otu5A.tot.sd)<-vec.len

length(otu2A.cons)<-vec.len
length(otu2A.cons.sd)<-vec.len
length(otu2A.tot)<-vec.len
length(otu2A.tot.sd)<-vec.len

length(otu6A.cons)<-vec.len
length(otu6A.cons.sd)<-vec.len
length(otu6A.tot)<-vec.len
length(otu6A.tot.sd)<-vec.len

length(otu4A.cons)<-vec.len
length(otu4A.cons.sd)<-vec.len
length(otu4A.tot)<-vec.len
length(otu4A.tot.sd)<-vec.len

length(otu5B.cons)<-vec.len
length(otu5B.cons.sd)<-vec.len
length(otu5B.tot)<-vec.len
length(otu5B.tot.sd)<-vec.len

length(otu4B.cons)<-vec.len
length(otu4B.cons.sd)<-vec.len
length(otu4B.tot)<-vec.len
length(otu4B.tot.sd)<-vec.len

length(otu1E.cons)<-vec.len
length(otu1E.cons.sd)<-vec.len
length(otu1E.tot)<-vec.len
length(otu1E.tot.sd)<-vec.len

length(otu8A.cons)<-vec.len
length(otu8A.cons.sd)<-vec.len
length(otu8A.tot)<-vec.len
length(otu8A.tot.sd)<-vec.len

length(otu1C.cons)<-vec.len
length(otu1C.cons.sd)<-vec.len
length(otu1C.tot)<-vec.len
length(otu1C.tot.sd)<-vec.len

length(otu2B.cons)<-vec.len
length(otu2B.cons.sd)<-vec.len
length(otu2B.tot)<-vec.len
length(otu2B.tot.sd)<-vec.len

length(otu1D.cons)<-vec.len
length(otu1D.cons.sd)<-vec.len
length(otu1D.tot)<-vec.len
length(otu1D.tot.sd)<-vec.len

alldata<-cbind(otu7A.core.mean=as.vector(otu7A.cons),otu7A.core.sd=as.vector(otu7A.cons.sd),otu7A.pan.mean=as.vector(otu7A.tot),otu7A.pan.sd=as.vector(otu7A.tot.sd),
    otu5C.core.mean=as.vector(otu5C.cons),otu5C.core.sd=as.vector(otu5C.cons.sd),otu5C.pan.mean=as.vector(otu5C.tot),otu5C.pan.sd=as.vector(otu5C.tot.sd),
    otu1A.core.mean=as.vector(otu1A.cons),otu1A.core.sd=as.vector(otu1A.cons.sd),otu1A.pan.mean=as.vector(otu1A.tot),otu1A.pan.sd=as.vector(otu1A.tot.sd),
    otu5A.core.mean=as.vector(otu5A.cons),otu5A.core.sd=as.vector(otu5A.cons.sd),otu5A.pan.mean=as.vector(otu5A.tot),otu5A.pan.sd=as.vector(otu5A.tot.sd),
    otu2A.core.mean=as.vector(otu2A.cons),otu2A.core.sd=as.vector(otu2A.cons.sd),otu2A.pan.mean=as.vector(otu2A.tot),otu2A.pan.sd=as.vector(otu2A.tot.sd),
    otu6A.core.mean=as.vector(otu6A.cons),otu6A.core.sd=as.vector(otu6A.cons.sd),otu6A.pan.mean=as.vector(otu6A.tot),otu6A.pan.sd=as.vector(otu6A.tot.sd),
    otu4A.core.mean=as.vector(otu4A.cons),otu4A.core.sd=as.vector(otu4A.cons.sd),otu4A.pan.mean=as.vector(otu4A.tot),otu4A.pan.sd=as.vector(otu4A.tot.sd),
    otu5B.core.mean=as.vector(otu5B.cons),otu5B.core.sd=as.vector(otu5B.cons.sd),otu5B.pan.mean=as.vector(otu5B.tot),otu5B.pan.sd=as.vector(otu5B.tot.sd),
    otu4B.core.mean=as.vector(otu4B.cons),otu4B.core.sd=as.vector(otu4B.cons.sd),otu4B.pan.mean=as.vector(otu4B.tot),otu4B.pan.sd=as.vector(otu4B.tot.sd),
    otu1E.core.mean=as.vector(otu1E.cons),otu1E.core.sd=as.vector(otu1E.cons.sd),otu1E.pan.mean=as.vector(otu1E.tot),otu1E.pan.sd=as.vector(otu1E.tot.sd),
    otu8A.core.mean=as.vector(otu8A.cons),otu8A.core.sd=as.vector(otu8A.cons.sd),otu8A.pan.mean=as.vector(otu8A.tot),otu8A.pan.sd=as.vector(otu8A.tot.sd),
    otu1C.core.mean=as.vector(otu1C.cons),otu1C.core.sd=as.vector(otu1C.cons.sd),otu1C.pan.mean=as.vector(otu1C.tot),otu1C.pan.sd=as.vector(otu1C.tot.sd),
    otu2B.core.mean=as.vector(otu2B.cons),otu2B.core.sd=as.vector(otu2B.cons.sd),otu2B.pan.mean=as.vector(otu2B.tot),otu2B.pan.sd=as.vector(otu2B.tot.sd),
    otu1D.core.mean=as.vector(otu1D.cons),otu1D.core.sd=as.vector(otu1D.cons.sd),otu1D.pan.mean=as.vector(otu1D.tot),otu1D.pan.sd=as.vector(otu1D.tot.sd))

write.csv(alldata,"~/pangenome.gene-accumulation-curves.csv")

otu7A.df<-data.frame(genomes=integer(),genes=integer(),stringsAsFactors=FALSE)
for (i in 1:length(otu7A.tot.table[1,])){
    new.genomes<-c(otu7A.df$genomes,rep(i,10))
    new.genes<-c(otu7A.df$genes,otu7A.tot.table[,i])
    otu7A.df<-data.frame(genomes=new.genomes,genes=new.genes)
}
otu7A.fit<-nls(genes~k*genomes^y,data=otu7A.df,start=c(k=6000,y=0))

otu5C.df<-data.frame(genomes=integer(),genes=integer(),stringsAsFactors=FALSE)
for (i in 1:length(otu5C.tot.table[1,])){
    new.genomes<-c(otu5C.df$genomes,rep(i,10))
    new.genes<-c(otu5C.df$genes,otu5C.tot.table[,i])
    otu5C.df<-data.frame(genomes=new.genomes,genes=new.genes)
}
otu5C.fit<-nls(genes~k*genomes^y,data=otu5C.df,start=c(k=6000,y=0))

otu1A.df<-data.frame(genomes=integer(),genes=integer(),stringsAsFactors=FALSE)
for (i in 1:length(otu1A.tot.table[1,])){
    new.genomes<-c(otu1A.df$genomes,rep(i,10))
    new.genes<-c(otu1A.df$genes,otu1A.tot.table[,i])
    otu1A.df<-data.frame(genomes=new.genomes,genes=new.genes)
}
otu1A.fit<-nls(genes~k*genomes^y,data=otu1A.df,start=c(k=6000,y=0))

otu5A.df<-data.frame(genomes=integer(),genes=integer(),stringsAsFactors=FALSE)
for (i in 1:length(otu5A.tot.table[1,])){
    new.genomes<-c(otu5A.df$genomes,rep(i,10))
    new.genes<-c(otu5A.df$genes,otu5A.tot.table[,i])
    otu5A.df<-data.frame(genomes=new.genomes,genes=new.genes)
}
otu5A.fit<-nls(genes~k*genomes^y,data=otu5A.df,start=c(k=6000,y=0))

otu2A.df<-data.frame(genomes=integer(),genes=integer(),stringsAsFactors=FALSE)
for (i in 1:length(otu2A.tot.table[1,])){
    new.genomes<-c(otu2A.df$genomes,rep(i,10))
    new.genes<-c(otu2A.df$genes,otu2A.tot.table[,i])
    otu2A.df<-data.frame(genomes=new.genomes,genes=new.genes)
}
otu2A.fit<-nls(genes~k*genomes^y,data=otu2A.df,start=c(k=6000,y=0))

otu6A.df<-data.frame(genomes=integer(),genes=integer(),stringsAsFactors=FALSE)
for (i in 1:length(otu6A.tot.table[1,])){
    new.genomes<-c(otu6A.df$genomes,rep(i,10))
    new.genes<-c(otu6A.df$genes,otu6A.tot.table[,i])
    otu6A.df<-data.frame(genomes=new.genomes,genes=new.genes)
}
otu6A.fit<-nls(genes~k*genomes^y,data=otu6A.df,start=c(k=6000,y=0))

otu4A.df<-data.frame(genomes=integer(),genes=integer(),stringsAsFactors=FALSE)
for (i in 1:length(otu4A.tot.table[1,])){
    new.genomes<-c(otu4A.df$genomes,rep(i,10))
    new.genes<-c(otu4A.df$genes,otu4A.tot.table[,i])
    otu4A.df<-data.frame(genomes=new.genomes,genes=new.genes)
}
otu4A.fit<-nls(genes~k*genomes^y,data=otu4A.df,start=c(k=6000,y=0))

otu5B.df<-data.frame(genomes=integer(),genes=integer(),stringsAsFactors=FALSE)
for (i in 1:length(otu5B.tot.table[1,])){
    new.genomes<-c(otu5B.df$genomes,rep(i,10))
    new.genes<-c(otu5B.df$genes,otu5B.tot.table[,i])
    otu5B.df<-data.frame(genomes=new.genomes,genes=new.genes)
}
otu5B.fit<-nls(genes~k*genomes^y,data=otu5B.df,start=c(k=6000,y=0))

otu4B.df<-data.frame(genomes=integer(),genes=integer(),stringsAsFactors=FALSE)
for (i in 1:length(otu4B.tot.table[1,])){
    new.genomes<-c(otu4B.df$genomes,rep(i,10))
    new.genes<-c(otu4B.df$genes,otu4B.tot.table[,i])
    otu4B.df<-data.frame(genomes=new.genomes,genes=new.genes)
}
otu4B.fit<-nls(genes~k*genomes^y,data=otu4B.df,start=c(k=6000,y=0))

otu1E.df<-data.frame(genomes=integer(),genes=integer(),stringsAsFactors=FALSE)
for (i in 1:length(otu1E.tot.table[1,])){
    new.genomes<-c(otu1E.df$genomes,rep(i,10))
    new.genes<-c(otu1E.df$genes,otu1E.tot.table[,i])
    otu1E.df<-data.frame(genomes=new.genomes,genes=new.genes)
}
otu1E.fit<-nls(genes~k*genomes^y,data=otu1E.df,start=c(k=6000,y=0))

otu8A.df<-data.frame(genomes=integer(),genes=integer(),stringsAsFactors=FALSE)
for (i in 1:length(otu8A.tot.table[1,])){
    new.genomes<-c(otu8A.df$genomes,rep(i,10))
    new.genes<-c(otu8A.df$genes,otu8A.tot.table[,i])
    otu8A.df<-data.frame(genomes=new.genomes,genes=new.genes)
}
otu8A.fit<-nls(genes~k*genomes^y,data=otu8A.df,start=c(k=6000,y=0))

otu1C.df<-data.frame(genomes=integer(),genes=integer(),stringsAsFactors=FALSE)
for (i in 1:length(otu1C.tot.table[1,])){
    new.genomes<-c(otu1C.df$genomes,rep(i,10))
    new.genes<-c(otu1C.df$genes,otu1C.tot.table[,i])
    otu1C.df<-data.frame(genomes=new.genomes,genes=new.genes)
}
otu1C.fit<-nls(genes~k*genomes^y,data=otu1C.df,start=c(k=6000,y=0))

otu2B.df<-data.frame(genomes=integer(),genes=integer(),stringsAsFactors=FALSE)
for (i in 1:length(otu2B.tot.table[1,])){
    new.genomes<-c(otu2B.df$genomes,rep(i,10))
    new.genes<-c(otu2B.df$genes,otu2B.tot.table[,i])
    otu2B.df<-data.frame(genomes=new.genomes,genes=new.genes)
}
otu2B.fit<-nls(genes~k*genomes^y,data=otu2B.df,start=c(k=6000,y=0))

otu1D.df<-data.frame(genomes=integer(),genes=integer(),stringsAsFactors=FALSE)
for (i in 1:length(otu1D.tot.table[1,])){
    new.genomes<-c(otu1D.df$genomes,rep(i,10))
    new.genes<-c(otu1D.df$genes,otu1D.tot.table[,i])
    otu1D.df<-data.frame(genomes=new.genomes,genes=new.genes)
}
otu1D.fit<-nls(genes~k*genomes^y,data=otu1D.df,start=c(k=6000,y=0))

gammas<-cbind(otu=c("7A","5C","1A","5A","2A","6A","4A","5B","4B","1E","8A","1C","2B","1D"),
    gamma=c(summary(otu7A.fit)$coefficients[2,1],
            summary(otu5C.fit)$coefficients[2,1],
            summary(otu1A.fit)$coefficients[2,1],
            summary(otu5A.fit)$coefficients[2,1],
            summary(otu2A.fit)$coefficients[2,1],
            summary(otu6A.fit)$coefficients[2,1],
            summary(otu4A.fit)$coefficients[2,1],
            summary(otu5B.fit)$coefficients[2,1],
            summary(otu4B.fit)$coefficients[2,1],
            summary(otu1E.fit)$coefficients[2,1],
            summary(otu8A.fit)$coefficients[2,1],
            summary(otu1C.fit)$coefficients[2,1],
            summary(otu2B.fit)$coefficients[2,1],
            summary(otu1D.fit)$coefficients[2,1]))
            
write.csv(gammas,"~/pangenome.gammas.csv")