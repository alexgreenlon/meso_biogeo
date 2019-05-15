library(ape)
library(vegan)
library(ggplot2)
library(reshape2)
library(RColorBrewer)
library(plyr)
library(matrixStats)
library(VennDiagram)

# function to generate estimate of variance from constrained ordination analysis
# from https://github.com/hzi-bifo/BarleyMeta/blob/master/cpcoa.plot.func.R
# from https://github.com/hzi-bifo/BarleyMeta/blob/master/figure_2_and_s2.R

variability_table <- function(cca){
        chi <- c(cca$tot.chi,
                       cca$CCA$tot.chi, cca$CA$tot.chi)
        variability_table <- cbind(chi, chi/chi[1])
        colnames(variability_table) <- c("inertia", "proportion")
        rownames(variability_table) <- c("total", "constrained", "unconstrained")
        return(variability_table)
}

cca_ci <- function(cca, permutations=5000){

        var_tbl <- variability_table(cca)
        p <- permutest(cca, permutations=permutations)
        ci <- quantile(p$F.perm, c(.05,.95),names=F)*p$chi[1]/var_tbl["total", "inertia"]
        return(ci)

}

cap_var_props <- function(cca){

        eig_tot <- sum(cca$CCA$eig)
        var_propdf <- cca$CCA$eig/eig_tot
        return(var_propdf)
}

# load data

biodiv.dist.tab<-read.csv("greenlon-meso-biogeo-data/0.2-deg-cells.10-clusters.dist-mat.csv",header=T,row.names=1)
biodiv.squares.old.data<-read.table("greenlon-meso-biogeo-data/biodiv-0.2deg-squares.soil-type.lat.cluster.tsv",header=T,row.names=1,sep="\t")
biodiv.squares.data<-read.table("greenlon-meso-biogeo-data/biodiv-0.2deg-squares.all-geo-data.9.29.18.tsv",header=T,row.names=1,sep='\t')
biodiv.squares.data$biodiv.cluster<-biodiv.squares.old.data$biodiv.cluster
biodiv.squares.data$square.id<-rownames(biodiv.squares.data)
biodiv.squares.data$country<-substr(biodiv.squares.data$square.id,start=1,stop=2)
grids.counts<-read.csv("greenlon-meso-biogeo-data/biodiv-0.2-grids.clade-counts.tsv",head=T,row.names=1,sep='\t')
grids.counts.melt<-melt(as.matrix(grids.counts),variable.name="grid",value.name="count")
grids.counts.melt<-merge(grids.counts.melt,biodiv.squares.data,by.x="Var2",by.y="square.id")

# set color schemes
cluster.levels<-c("A1","A2","A4","B1","B4","B5","B6","A3","B2","B3")
#cluster.colors<-c("#a6cee3","#1f78b4","#33a02c","#fb9a99","#ff7f00","#cab2d6","#6a3d9a","#b2df8a","#e31a1c","#fdbf6f")
cluster.colors<-c("#a6cee3","#1f78b4","#b2df8a","#33a02c","#fb9a99","#e31a1c","#fdbf6f","#ff7f00","#cab2d6","#6a3d9a")
cluster.cols<-c("A1"="#a6cee3","A2"="#1f78b4","A3"="#b2df8a","A4"="#33a02c","B1"="#fb9a99","B2"="#e31a1c","B3"="#fdbf6f","B4"="#ff7f00","B5"="#cab2d6","B6"="#6a3d9a")
clade.levels<-c("1","2","3","4","5","6","7","8")
clade.colors<-c("#403075","#AA9739","#6F256F","#91A437","#29506D","#2D882D","#AA3939","#AA7939")
clade.cols<-c("Clade.1"="#403075","Clade.2"="#AA9739","Clade.3"="#6F256F","Clade.4"="#91A437","Clade.5"="#29506D","Clade.6"="#2D882D","Clade.7"="#AA3939","Clade.8"="#AA7939","Clade.9"="#808080","Clade.10"="#000000")
otu.levels<-c("1A","1B","1C","1D","1E","2A","2B","2C","2D","3A","4A","4B","5A","5B","5C","6A","7A","7B","7D","8A")
otu.colors<-c("#13073A","#261758","#403075","#615192","#887CAF","#806D15","#AA9739","#D4C26A","#FFF0AA","#6F256F","#6A7B15","#91A437","#123652","#29506D","#496D89","#2D882D","#801515","#AA3939","#D46A6A","#AA7939")
cluster.cols<-c("A1"="#a6cee3","A2"="#1f78b4","A4"="#33a02c","B1"="#fb9a99","B4"="#ff7f00","B5"="#cab2d6","B6"="#6a3d9a","A3"="#b2df8a","B2"="#e31a1c","B3"="#fdbf6f")
otu.cols<-c("1A"="#13073A","1B"="#261758","1C"="#403075","1D"="#615192","1E"="#887CAF","2A"="#806D15","2B"="#AA9739","2C"="#D4C26A","2D"="#FFF0AA","3A"="#6F256F","4A"="#6A7B15","4B"="#91A437","5A"="#123652","5B"="#29506D","5C"="#496D89","6A"="#2D882D","7A"="#801515","7B"="#AA3939","7D"="#D46A6A","8A"="#AA7939")
soil.levels<-c("Haplic Leptosols","Haplic Vertisols","Haplic Calcisols","Haplic Cambisols","Lithic Leptosols","Haplic Luvisols","Calcic Vertisols","Rendzic Leptosols","Haplic Phaeozems","Mollic Vertisols","Haplic Regosols (Eutric)","Haplic Kastanozems","Aric Regosols")
soil.colors<-c("#988F98","#A88E99","#FFEF51","#FDE260","#B4BDB6","#F99491","#A87188","#A2A2A2","#D5EADB","#A851A2","#FDDA9C","#D28769","#FDE4B7")
soil.cols<-c("Haplic Leptosols"="#988F98","Haplic Vertisols"="#A88E99","Haplic Calcisols"="#FFEF51","Haplic Cambisols"="#FDE260","Lithic Leptosols"="#B4BDB6","Haplic Luvisols"="#F99491","Calcic Vertisols"="#A87188","Rendzic Leptosols"="#A2A2A2","Haplic Phaeozems"="#D5EADB","Mollic Vertisols"="#A851A2","Haplic Regosols (Eutric)"="#FDDA9C","Haplic Kastanozems"="#D28769","Aric Regosols"="#FDE4B7")
all.cols<-c(cluster.cols,otu.cols,soil.cols)
country.cols<-c("TR"="#226666","ET"="#7A9F35","MR"="#D4EE9F","IN"="#354F00")
country.cols2<-c("TR"="#e41a1c","ET"="#377eb8","MR"="#4daf4a","IN"="#984ea3")
soil.cols<-c("Calcisols"="#FFEF51","Cambisols"="#FDE260","Kastanozems"="#D28769","Leptosols"="#988F98","Luvisols"="#F99491","Phaeozems"="#D5EADB","Regosols"="#FDDA9C","Vertisols"="#A88E99")
soil.cols2<-c("Calcisols"="#e6194b","Cambisols"="#3cb44b","Kastanozems"="#ffe119","Leptosols"="#0082c8","Luvisols"="#f58231","Phaeozems"="#911eb4","Regosols"="#46f0f0","Vertisols"="#fabebe")
soil.cols3<-c("Calcisols"="#1b9e77","Cambisols"="#d95f02","Kastanozems"="#7570b3","Leptosols"="#e7298a","Luvisols"="#66a61e","Phaeozems"="#e6ab02","Regosols"="#a6761d","Vertisols"="#666666")

## unconstrained pcoa
biodiv.pcoa<-pcoa(as.dist(biodiv.dist.tab))
biodiv.pcoa.df1<-data.frame(biodiv.pcoa$vectors[,1:2])

biodiv.pcoa.varexp.1<-biodiv.pcoa$values[1]$Eigenvalues[1]/sum(biodiv.pcoa$values[1]$Eigenvalues)
biodiv.pcoa.varexp.2<-biodiv.pcoa$values[1]$Eigenvalues[2]/sum(biodiv.pcoa$values[1]$Eigenvalues)

# plot unconstrained pcoa
# plot stuff
ppp <- ggplot() + coord_fixed() +
  labs(x="Comp1, Axis1", y="Comp2, Axis2") +
  geom_hline(yintercept=0, col="darkgrey") +
  geom_vline(xintercept=0, col="darkgrey") +
  theme(panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.line = element_line(colour = "black", size = 1, linetype = "solid"))

## pcoa's
myxlab<-paste("PC1, ",round(100*biodiv.pcoa.varexp.1,1),"% Variation Explained",sep="")
myylab<-paste("PC2, ",round(100*biodiv.pcoa.varexp.2,1),"% Variation Explained",sep="")
## pcoa, colored by cluster:
ppp + geom_point(data=biodiv.pcoa.df1,aes(x=Axis.1,y=Axis.2,color=biodiv.squares.old.data$biodiv.cluster)) + xlab(myxlab) + ylab(myylab)+labs(color="Beta diversity\ncluster") +scale_color_manual(values=all.cols)
ggsave("FigS2.grid-squares-betadiv-pcoa.cluster-colored.png")
## pcoa colored by soil-type
ppp + geom_point(data=biodiv.pcoa.df1,aes(x=Axis.1,y=Axis.2,color=biodiv.squares.data$soil.genus)) + xlab(myxlab) + ylab(myylab) + labs(color="Soil genus") + scale_color_manual(values=soil.cols3)
ggsave("FigS2B.grid-squares-betadiv-pcoa.soil-colored.png")

# run constrained ordination analysis and chose model from forward selection

cap.all<-capscale(as.dist(biodiv.dist.tab) ~ .,biodiv.squares.data)
ordistep(cap.all)
capscale(as.dist(biodiv.dist.tab) ~ soil.ph + temp + prec + soil.genus + latt + biodiv.cluster + square.id + country,data=biodiv.squares.data)
summary(capscale(as.dist(biodiv.dist.tab) ~ soil.ph + temp + prec + soil.genus + latt + biodiv.cluster + square.id + country,data=biodiv.squares.data))
anova(cap.all)
cap.all2<-capscale(formula = as.dist(biodiv.dist.tab) ~ soil.ph + temp + prec + soil.genus + latt, data = biodiv.squares.data)
anova(cap.all2)
ordistep(cap.all2)

## actually i guess i should do it this way (based on the examples here: https://rdrr.io/rforge/vegan/man/ordistep.html)

#biodiv.squares.data$biodiv.cluster<-NULL
cap0<-capscale(as.dist(biodiv.dist.tab)~1,data=biodiv.squares.data)
cap1<-capscale(as.dist(biodiv.dist.tab)~.,data=biodiv.squares.data)
step.res<-ordistep(cap0,scope=formula(cap1),direction="forward",perm.max=999)
step.res$anova
#adonis(formula = as.dist(biodiv.dist.tab) ~ latt + temp + soil.genus + prec, data = biodiv.squares.data)

biodiv.squares.data<-read.table("greenlon-meso-biogeo-data/biodiv-0.2deg-squares.all-geo-data.9.29.18.tsv",header=T,row.names=1,sep='\t')
cap0<-capscale(as.dist(biodiv.dist.tab)~1,data=biodiv.squares.data)
cap1<-capscale(as.dist(biodiv.dist.tab)~.,data=biodiv.squares.data)
step.res<-ordistep(cap0,scope=formula(cap1),direction="forward",perm.max=999)
step.res$anova

# generate estimates of percent variation explained based on model chosen from forward selection

#adonis(as.dist(biodiv.dist.tab) ~ temp + prec + soil.genus + latt, data = biodiv.squares.data)
#adonis(as.dist(biodiv.dist.tab) ~ latt + temp + soil.genus + prec, data = biodiv.squares.data)

# generate confidence intervals (sort of..somehow)

#cap.stepped<-capscale(as.dist(biodiv.dist.tab) ~ temp + prec + soil.genus + latt, data = biodiv.squares.data)

#cap.stepped<-capscale(as.dist(biodiv.dist.tab) ~ latt + temp + soil.genus + prec, data = biodiv.squares.data)
cap.stepped<-step.res
perm_anova.stepped<-anova.cca(cap.stepped)
print(perm_anova.stepped)

var_tbl.stepped<-variability_table(cap.stepped)
cap_var.stepped<-cap_var_props(cap.stepped)
ci.stepped<-cca_ci(cap.stepped)

eig.stepped<-cap.stepped$CCA$eig
variance.stepped<-var_tbl.stepped["constrained", "proportion"]
p.val.stepped<-perm_anova.stepped[1,4]
variance.stepped
p.val.stepped
perm_anova.stepped
var_tbl.stepped

# okay, so what I think I need to do is basically run every permutation of
# variance partitioning, i.e. calculating the variance explained etc for
# one variable, with the others partialed out, and then the shared variance
# explained by different combinations...and also calculating all the other
# stuff to report, and then drawing it all together as a venn diagram...
# except I think the values i'll need to fill into the venn diagram will be the
# differences...

# individual variables, without anything partialed out
soil.genus.only.cap<-capscale(as.dist(biodiv.dist.tab) ~ soil.genus, data = biodiv.squares.data)
soil.genus.only.perm_anova<-anova.cca(soil.genus.only.cap)
print(soil.genus.only.perm_anova)
soil.genus.only.var_tbl<-variability_table(soil.genus.only.cap)
soil.genus.only.cap_var<-cap_var_props(soil.genus.only.cap)
soil.genus.only.ci<-cca_ci(soil.genus.only.cap)
soil.genus.only.eig<-soil.genus.only.cap$CCA$eig
soil.genus.only.variance<-soil.genus.only.var_tbl["constrained", "proportion"]
soil.genus.only.p.val<-soil.genus.only.perm_anova[1,4]

soil.ph.only.cap<-capscale(as.dist(biodiv.dist.tab) ~ soil.ph, data = biodiv.squares.data)
soil.ph.only.perm_anova<-anova.cca(soil.ph.only.cap)
print(soil.ph.only.perm_anova)
soil.ph.only.var_tbl<-variability_table(soil.ph.only.cap)
soil.ph.only.cap_var<-cap_var_props(soil.ph.only.cap)
soil.ph.only.ci<-cca_ci(soil.ph.only.cap)
soil.ph.only.eig<-soil.ph.only.cap$CCA$eig
soil.ph.only.variance<-soil.ph.only.var_tbl["constrained", "proportion"]
soil.ph.only.p.val<-soil.ph.only.perm_anova[1,4]

temp.only.cap<-capscale(as.dist(biodiv.dist.tab) ~ temp, data = biodiv.squares.data)
temp.only.perm_anova<-anova.cca(temp.only.cap)
print(temp.only.perm_anova)
temp.only.var_tbl<-variability_table(temp.only.cap)
temp.only.cap_var<-cap_var_props(temp.only.cap)
temp.only.ci<-cca_ci(temp.only.cap)
temp.only.eig<-temp.only.cap$CCA$eig
temp.only.variance<-temp.only.var_tbl["constrained", "proportion"]
temp.only.p.val<-temp.only.perm_anova[1,4]

prec.only.cap<-capscale(as.dist(biodiv.dist.tab) ~ prec, data = biodiv.squares.data)
prec.only.perm_anova<-anova.cca(prec.only.cap)
print(prec.only.perm_anova)
prec.only.var_tbl<-variability_table(prec.only.cap)
prec.only.cap_var<-cap_var_props(prec.only.cap)
prec.only.ci<-cca_ci(prec.only.cap)
prec.only.eig<-prec.only.cap$CCA$eig
prec.only.variance<-prec.only.var_tbl["constrained", "proportion"]
prec.only.p.val<-prec.only.perm_anova[1,4]

lat.only.cap<-capscale(as.dist(biodiv.dist.tab) ~ latt, data = biodiv.squares.data)
lat.only.perm_anova<-anova.cca(lat.only.cap)
print(lat.only.perm_anova)
lat.only.var_tbl<-variability_table(lat.only.cap)
lat.only.cap_var<-cap_var_props(lat.only.cap)
lat.only.ci<-cca_ci(lat.only.cap)
lat.only.eig<-lat.only.cap$CCA$eig
lat.only.variance<-lat.only.var_tbl["constrained", "proportion"]
lat.only.p.val<-lat.only.perm_anova[1,4]

# individual variables, with everything else partialed out
all.factors.df<-data.frame(expl=character(),cond=character(),var.exp=double(),lower.conf=double(),upper.conf=double(),p.val=double(),stringsAsFactors=FALSE)
## latittude
lat.cap<-capscale(as.dist(biodiv.dist.tab) ~ latt + Condition(temp + soil.genus + prec), data = biodiv.squares.data)
lat.perm_anova<-anova.cca(lat.cap)
print(lat.perm_anova)
lat.var_tbl<-variability_table(lat.cap)
lat.cap_var<-cap_var_props(lat.cap)
lat.ci<-cca_ci(lat.cap)
lat.eig<-lat.cap$CCA$eig
lat.variance<-lat.var_tbl["constrained", "proportion"]
lat.p.val<-lat.perm_anova[1,4]
all.factors.df<-rbind(all.factors.df,data.frame(expl="lat",cond="temp, soil type, precip",var.exp=lat.variance,lower.conf=lat.ci[1],upper.conf=lat.ci[2],p.val=lat.p.val))

## soil type
soil.genus.cap<-capscale(as.dist(biodiv.dist.tab) ~ soil.genus + Condition(temp + latt + prec), data = biodiv.squares.data)
soil.genus.perm_anova<-anova.cca(soil.genus.cap)
print(soil.genus.perm_anova)
soil.genus.var_tbl<-variability_table(soil.genus.cap)
soil.genus.cap_var<-cap_var_props(soil.genus.cap)
soil.genus.ci<-cca_ci(soil.genus.cap)
soil.genus.eig<-soil.genus.cap$CCA$eig
soil.genus.variance<-soil.genus.var_tbl["constrained", "proportion"]
soil.genus.p.val<-soil.genus.perm_anova[1,4]
all.factors.df<-rbind(all.factors.df,data.frame(expl="soil type",cond="temp, lat, precip",var.exp=soil.genus.variance,lower.conf=soil.genus.ci[1],upper.conf=soil.genus.ci[2],p.val=soil.genus.p.val))

## temp
temp.cap<-capscale(as.dist(biodiv.dist.tab) ~ temp + Condition(latt + soil.genus + prec), data = biodiv.squares.data)
temp.perm_anova<-anova.cca(temp.cap)
print(temp.perm_anova)
temp.var_tbl<-variability_table(temp.cap)
temp.cap_var<-cap_var_props(temp.cap)
temp.ci<-cca_ci(temp.cap)
temp.eig<-temp.cap$CCA$eig
temp.variance<-temp.var_tbl["constrained", "proportion"]
temp.p.val<-temp.perm_anova[1,4]
all.factors.df<-rbind(all.factors.df,data.frame(expl="temp",cond="lat, soil type, precip",var.exp=temp.variance,lower.conf=temp.ci[1],upper.conf=temp.ci[2],p.val=temp.p.val))

## precip
prec.cap<-capscale(as.dist(biodiv.dist.tab) ~ prec + Condition(temp + soil.genus + latt), data = biodiv.squares.data)
prec.perm_anova<-anova.cca(prec.cap)
print(prec.perm_anova)
prec.var_tbl<-variability_table(prec.cap)
prec.cap_var<-cap_var_props(prec.cap)
prec.ci<-cca_ci(prec.cap)
prec.eig<-prec.cap$CCA$eig
prec.variance<-prec.var_tbl["constrained", "proportion"]
prec.p.val<-prec.perm_anova[1,4]
all.factors.df<-rbind(all.factors.df,data.frame(expl="precip",cond="temp, soil type, lat",var.exp=prec.variance,lower.conf=prec.ci[1],upper.conf=prec.ci[2],p.val=prec.p.val))

# two explanatory variables
## precip and lat
p.l.cap<-capscale(as.dist(biodiv.dist.tab) ~ prec + latt + Condition(temp + soil.genus), data = biodiv.squares.data)
p.l.perm_anova<-anova.cca(p.l.cap)
print(p.l.perm_anova)
p.l.var_tbl<-variability_table(p.l.cap)
p.l.cap_var<-cap_var_props(p.l.cap)
p.l.ci<-cca_ci(p.l.cap)
p.l.eig<-p.l.cap$CCA$eig
p.l.variance<-p.l.var_tbl["constrained", "proportion"]
p.l.p.val<-p.l.perm_anova[1,4]
all.factors.df<-rbind(all.factors.df,data.frame(expl="precip, lat",cond="temp, soil type",var.exp=p.l.variance,lower.conf=p.l.ci[1],upper.conf=p.l.ci[2],p.val=p.l.p.val))

## precip and temp
p.t.cap<-capscale(as.dist(biodiv.dist.tab) ~ prec + temp + Condition(latt + soil.genus), data = biodiv.squares.data)
p.t.perm_anova<-anova.cca(p.t.cap)
print(p.t.perm_anova)
p.t.var_tbl<-variability_table(p.t.cap)
p.t.cap_var<-cap_var_props(p.t.cap)
p.t.ci<-cca_ci(p.t.cap)
p.t.eig<-p.t.cap$CCA$eig
p.t.variance<-p.t.var_tbl["constrained", "proportion"]
p.t.p.val<-p.t.perm_anova[1,4]
all.factors.df<-rbind(all.factors.df,data.frame(expl="precip, temp",cond="lat, soil type",var.exp=p.t.variance,lower.conf=p.t.ci[1],upper.conf=p.t.ci[2],p.val=p.t.p.val))

## precip and soil type
p.s.cap<-capscale(as.dist(biodiv.dist.tab) ~ prec + soil.genus + Condition(temp + latt), data = biodiv.squares.data)
p.s.perm_anova<-anova.cca(p.s.cap)
print(p.s.perm_anova)
p.s.var_tbl<-variability_table(p.s.cap)
p.s.cap_var<-cap_var_props(p.s.cap)
p.s.ci<-cca_ci(p.s.cap)
p.s.eig<-p.s.cap$CCA$eig
p.s.variance<-p.s.var_tbl["constrained", "proportion"]
p.s.p.val<-p.s.perm_anova[1,4]
all.factors.df<-rbind(all.factors.df,data.frame(expl="precip, soil type",cond="temp, lat",var.exp=p.s.variance,lower.conf=p.s.ci[1],upper.conf=p.s.ci[2],p.val=p.s.p.val))

## lat and temp
l.t.cap<-capscale(as.dist(biodiv.dist.tab) ~ latt + temp + Condition(prec + soil.genus), data = biodiv.squares.data)
l.t.perm_anova<-anova.cca(l.t.cap)
print(l.t.perm_anova)
l.t.var_tbl<-variability_table(l.t.cap)
l.t.cap_var<-cap_var_props(l.t.cap)
l.t.ci<-cca_ci(l.t.cap)
l.t.eig<-l.t.cap$CCA$eig
l.t.variance<-l.t.var_tbl["constrained", "proportion"]
l.t.p.val<-l.t.perm_anova[1,4]
all.factors.df<-rbind(all.factors.df,data.frame(expl="lat, temp",cond="prec, soil type",var.exp=l.t.variance,lower.conf=l.t.ci[1],upper.conf=l.t.ci[2],p.val=l.t.p.val))

## lat and soil type
l.s.cap<-capscale(as.dist(biodiv.dist.tab) ~ latt + soil.genus + Condition(temp + prec), data = biodiv.squares.data)
l.s.perm_anova<-anova.cca(l.s.cap)
print(l.s.perm_anova)
l.s.var_tbl<-variability_table(l.s.cap)
l.s.cap_var<-cap_var_props(l.s.cap)
l.s.ci<-cca_ci(l.s.cap)
l.s.eig<-l.s.cap$CCA$eig
l.s.variance<-l.s.var_tbl["constrained", "proportion"]
l.s.p.val<-l.s.perm_anova[1,4]
all.factors.df<-rbind(all.factors.df,data.frame(expl="lat, soil type",cond="temp, precip",var.exp=l.s.variance,lower.conf=l.s.ci[1],upper.conf=l.s.ci[2],p.val=l.s.p.val))

## temp and soil type
t.s.cap<-capscale(as.dist(biodiv.dist.tab) ~ temp + soil.genus + Condition(prec + latt), data = biodiv.squares.data)
t.s.perm_anova<-anova.cca(t.s.cap)
print(t.s.perm_anova)
t.s.var_tbl<-variability_table(t.s.cap)
t.s.cap_var<-cap_var_props(t.s.cap)
t.s.ci<-cca_ci(t.s.cap)
t.s.eig<-t.s.cap$CCA$eig
t.s.variance<-t.s.var_tbl["constrained", "proportion"]
t.s.p.val<-t.s.perm_anova[1,4]
all.factors.df<-rbind(all.factors.df,data.frame(expl="temp, soil type",cond="precip, lat",var.exp=t.s.variance,lower.conf=t.s.ci[1],upper.conf=t.s.ci[2],p.val=t.s.p.val))

# three explanatory varialbes
## precip, latitude, and temperature
p.l.t.cap<-capscale(as.dist(biodiv.dist.tab) ~ prec + latt + temp + Condition(soil.genus), data = biodiv.squares.data)
p.l.t.perm_anova<-anova.cca(p.l.t.cap)
print(p.l.t.perm_anova)
p.l.t.var_tbl<-variability_table(p.l.t.cap)
p.l.t.cap_var<-cap_var_props(p.l.t.cap)
p.l.t.ci<-cca_ci(p.l.t.cap)
p.l.t.eig<-p.l.t.cap$CCA$eig
p.l.t.variance<-p.l.t.var_tbl["constrained", "proportion"]
p.l.t.p.val<-p.l.t.perm_anova[1,4]
all.factors.df<-rbind(all.factors.df,data.frame(expl="precip, lat, temp",cond="soil type",var.exp=p.l.t.variance,lower.conf=p.l.t.ci[1],upper.conf=p.l.t.ci[2],p.val=p.l.t.p.val))

## precip, latitude, and soil type
p.l.s.cap<-capscale(as.dist(biodiv.dist.tab) ~ prec + latt + soil.genus + Condition(temp), data = biodiv.squares.data)
p.l.s.perm_anova<-anova.cca(p.l.s.cap)
print(p.l.s.perm_anova)
p.l.s.var_tbl<-variability_table(p.l.s.cap)
p.l.s.cap_var<-cap_var_props(p.l.s.cap)
p.l.s.ci<-cca_ci(p.l.s.cap)
p.l.s.eig<-p.l.s.cap$CCA$eig
p.l.s.variance<-p.l.s.var_tbl["constrained", "proportion"]
p.l.s.p.val<-p.l.s.perm_anova[1,4]
all.factors.df<-rbind(all.factors.df,data.frame(expl="precip, lat, soil.type",cond="temp",var.exp=p.l.s.variance,lower.conf=p.l.s.ci[1],upper.conf=p.l.s.ci[2],p.val=p.l.s.p.val))

## latitude, temperature, and soil type
l.t.s.cap<-capscale(as.dist(biodiv.dist.tab) ~ latt + temp + soil.genus + Condition(prec), data = biodiv.squares.data)
l.t.s.perm_anova<-anova.cca(l.t.s.cap)
print(l.t.s.perm_anova)
l.t.s.var_tbl<-variability_table(l.t.s.cap)
l.t.s.cap_var<-cap_var_props(l.t.s.cap)
l.t.s.ci<-cca_ci(l.t.s.cap)
l.t.s.eig<-l.t.s.cap$CCA$eig
l.t.s.variance<-l.t.s.var_tbl["constrained", "proportion"]
l.t.s.p.val<-l.t.s.perm_anova[1,4]
all.factors.df<-rbind(all.factors.df,data.frame(expl="lat, temp, soil type",cond="precip",var.exp=l.t.s.variance,lower.conf=l.t.s.ci[1],upper.conf=l.t.s.ci[2],p.val=l.t.s.p.val))

## precip, temperature, and soil genus
p.t.s.cap<-capscale(as.dist(biodiv.dist.tab) ~ prec + temp + soil.genus + Condition(latt), data = biodiv.squares.data)
p.t.s.perm_anova<-anova.cca(p.t.s.cap)
print(p.t.s.perm_anova)
p.t.s.var_tbl<-variability_table(p.t.s.cap)
p.t.s.cap_var<-cap_var_props(p.t.s.cap)
p.t.s.ci<-cca_ci(p.t.s.cap)
p.t.s.eig<-p.t.s.cap$CCA$eig
p.t.s.variance<-p.t.s.var_tbl["constrained", "proportion"]
p.t.s.p.val<-p.t.s.perm_anova[1,4]
all.factors.df<-rbind(all.factors.df,data.frame(expl="precip, temp, soil type",cond="lat",var.exp=p.t.s.variance,lower.conf=p.t.s.ci[1],upper.conf=p.t.s.ci[2],p.val=p.t.s.p.val))

# all explanatory variables.
p.t.s.l.cap<-capscale(as.dist(biodiv.dist.tab) ~ prec + temp + soil.genus + latt, data = biodiv.squares.data)
p.t.s.l.perm_anova<-anova.cca(p.t.s.l.cap)
print(p.t.s.l.perm_anova)
p.t.s.l.var_tbl<-variability_table(p.t.s.l.cap)
p.t.s.l.cap_var<-cap_var_props(p.t.s.l.cap)
p.t.s.l.ci<-cca_ci(p.t.s.l.cap)
p.t.s.l.eig<-p.t.s.l.cap$CCA$eig
p.t.s.l.variance<-p.t.s.l.var_tbl["constrained", "proportion"]
p.t.s.l.p.val<-p.t.s.l.perm_anova[1,4]
all.factors.df<-rbind(all.factors.df,data.frame(expl="precip, temp, soil type, lat",cond="none",var.exp=p.t.s.l.variance,lower.conf=p.t.s.l.ci[1],upper.conf=p.t.s.l.ci[2],p.val=p.t.s.l.p.val))

write.csv(all.factors.df,"dataset.S5.biogeo-variation-partitioning.csv")

cap.soil.summ<-summary(soil.genus.cap)
cap.soil.df1<-data.frame(cap.soil.summ$sites[,1:2])

# interlude to plot the soil type cap
soil.myxlab<-paste("CAP1, ",round(100*soil.genus.cap_var[1],1),"% Variation Explained",sep="")
soil.myylab<-paste("CAP2, ",round(100*soil.genus.cap_var[2],1),"% Variation Explained",sep="")

# soil cap plot colored by biodiv cluster
ppp + geom_point(data=cap.soil.df1,aes(x=CAP1,y=CAP2,color=biodiv.squares.old.data$biodiv.cluster))+scale_color_manual(values=all.cols)+xlab(soil.myxlab) + ylab(soil.myylab)+labs(color="Beta diversity\ncluster") +
  ggtitle(paste("Soil type: ",round(100*soil.genus.variance,1),"% of variance; P < ", format(soil.genus.p.val, digits=2),"; 95% CI = ",  format(soil.genus.ci[1]*100, digits=2), "%, ", format(soil.genus.ci[2]*100, digits=2), "%", sep=""))
ggsave("FigS7A.soil-cap.biodiv-clust-color.png")

# soil cap plot colored by soil type
ppp + geom_point(data=cap.soil.df1,aes(x=CAP1,y=CAP2,color=biodiv.squares.data$soil.genus))+scale_color_manual(values=soil.cols3)+xlab(soil.myxlab) + ylab(soil.myylab)+labs(color="Beta diversity\ncluster") +
  ggtitle(paste("Soil type: ",round(100*soil.genus.variance,1),"% of variance; P < ", format(soil.genus.p.val, digits=2),"; 95% CI = ",  format(soil.genus.ci[1]*100, digits=2), "%, ", format(soil.genus.ci[2]*100, digits=2), "%", sep=""))
ggsave("FigS7B.soil-cap.soil-type-color.png")

temp.myxlab<-paste("CAP1, ",round(100*soil.genus.cap_var[1],1),"% Variation Explained",sep="")
temp.myylab<-paste("CAP2, ",round(100*soil.genus.cap_var[2],1),"% Variation Explained",sep="")

cap.temp.summ<-summary(temp.cap)
cap.temp.df1<-data.frame(cap.temp.summ$sites[,1:2])

# interlude to plot the temp cap
#temp.myxlab<-paste("CAP1, ",round(100*temp.cap_var[1],1),"% Variation Explained",sep="")
#temp.myylab<-paste("MDS1, ",round(100*temp.cap_var[2],1),"% Variation Explained",sep="")

# temp cap plot colored by biodiv cluster
### problem here where the cap results are a bit different here from for the soil type cap, so need to get % var explained from MDS1...
ppp + geom_point(data=cap.temp.df1,aes(x=CAP1,y=MDS1,color=biodiv.squares.old.data$biodiv.cluster))+scale_color_manual(values=all.cols)+xlab("CAP1") + ylab("MDS1")+labs(color="Beta diversity\ncluster") +
  ggtitle(paste("Mean Annual Temperature: ",round(100*temp.variance,1),"% of variance; P < ", format(temp.p.val, digits=2),"; 95% CI = ",  format(temp.ci[1]*100, digits=2), "%, ", format(temp.ci[2]*100, digits=2), "%]", sep=""))
ggsave("FigS.temp-cap.biodiv-clust-color.png")

# temp cap plot colored by soil type
ppp + geom_point(data=cap.temp.df1,aes(x=CAP1,y=MDS1,color=biodiv.squares.data$temp))+xlab("CAP1") + ylab("MDS1")+labs(color="Beta diversity\ncluster") +
  ggtitle(paste("Mean Annual Temperature: ",round(100*temp.variance,1),"% of variance; P < ", format(temp.p.val, digits=2),"; 95% CI = ",  format(temp.ci[1]*100, digits=2), "%, ", format(soil.genus.ci[2]*100, digits=2), "%]", sep=""))
ggsave("FigS.soil-cap.soil-type-color.png")

# draw bar plots
# put this on the end because for some reason i think doing the re-order on
# biodiv.squares.data messes with how the colors match to the points in the pcoa biplots above
# ...should figure out why

biodiv.squares.data<-read.table("greenlon-meso-biogeo-data/biodiv-0.2deg-squares.all-geo-data.9.29.18.tsv",header=T,row.names=1,sep='\t')
biodiv.squares.data$biodiv.cluster<-biodiv.squares.old.data$biodiv.cluster
biodiv.squares.data$square.id<-rownames(biodiv.squares.data)
biodiv.squares.data$country<-substr(biodiv.squares.data$square.id,start=1,stop=2)

grids.counts.melt$Var2<-factor(grids.counts.melt$Var2,levels=biodiv.squares.data$square.id[order(biodiv.squares.data$biodiv.cluster)])
biodiv.squares.data<-biodiv.squares.data[order(biodiv.squares.data$biodiv.cluster,biodiv.squares.data$square.id),]
p.grids.counts<-ggplot(grids.counts.melt,aes(x=factor(Var2),y=count,order=desc(biodiv.cluster))) +
    geom_bar(stat="identity",aes(fill=Var1,order=desc(Var1))) +
    scale_fill_manual(values=clade.cols) +
    ylab("# Nodule genomes assigned to clade")

for (i in 1:length(rownames(biodiv.squares.data))){
    p.grids.counts <- p.grids.counts +
    annotate("rect",xmin=(i-0.5),xmax=(i+0.5),ymin=-4.5,ymax=-3.5,
        fill=cluster.colors[biodiv.squares.data$biodiv.cluster[i]]) +
    annotate("rect",xmin=(i-0.5),xmax=(i+0.5),ymin=-3,ymax=-2,
        fill=country.cols2[biodiv.squares.data$country[i]]) +
    annotate("rect",xmin=(i-0.5),xmax=(i+0.5),ymin=-1.5,ymax=-0.5,
        fill=soil.cols3[biodiv.squares.data$soil.genus[i]])
}

p.grids.counts + theme_classic() +
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank(),axis.line.x=element_blank())

ggsave("grid-squares-barcharts.png")

# similar graph but normalized
p.grids.perc<-ggplot(grids.counts.melt,aes(x=factor(Var2),y=count,order=desc(biodiv.cluster))) +
    geom_bar(position="fill", stat="identity",aes(fill=Var1,order=desc(Var1))) +
    scale_fill_manual(values=clade.cols) +
    ylab("Percent nodule genomes assigned to clade")

for (i in 1:length(rownames(biodiv.squares.data))){
    p.grids.perc <- p.grids.perc +
    annotate("rect",xmin=(i-0.5),xmax=(i+0.5),ymin=-0.45,ymax=-0.35,
        fill=cluster.colors[biodiv.squares.data$biodiv.cluster[i]]) +
    annotate("rect",xmin=(i-0.5),xmax=(i+0.5),ymin=-0.3,ymax=-0.2,
        fill=country.cols2[biodiv.squares.data$country[i]]) +
    annotate("rect",xmin=(i-0.5),xmax=(i+0.5),ymin=-0.15,ymax=-0.05,
        fill=soil.cols3[biodiv.squares.data$soil.genus[i]])
}

p.grids.perc + theme_classic() +
    theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank(),axis.line.x=element_blank())

ggsave("grid-squares-normalized-barcharts.png")
