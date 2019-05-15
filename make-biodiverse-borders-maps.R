library(ggplot2)
library(maps)
library(maptools)
library(mapdata)
library(sp)
library(raster)
library(rgdal)

cluster.levels<-c("A1","A2","A4","B1","B4","B5","B6","A3","B2","B3")
cluster.colors<-c("#a6cee3","#1f78b4","#33a02c","#fb9a99","#ff7f00","#cab2d6","#6a3d9a","#b2df8a","#e31a1c","#fdbf6f")

clade.levels<-c("1","2","3","4","5","6","7","8")
clade.colors<-c("#403075","#AA9739","#6F256F","#91A437","#29506D","#2D882D","#AA3939","#AA7939")

otu.levels<-c("1A","1B","1C","1D","1E","2A","2B","2C","2D","3A","4A","4B","5A","5B","5C","6A","7A","7B","7D","8A")
otu.colors<-c("#13073A","#261758","#403075","#615192","#887CAF","#806D15","#AA9739","#D4C26A","#FFF0AA","#6F256F","#6A7B15","#91A437","#123652","#29506D","#496D89","#2D882D","#801515","#AA3939","#D46A6A","#AA7939")

cluster.cols<-c("A1"="#a6cee3","A2"="#1f78b4","A4"="#33a02c","B1"="#fb9a99","B4"="#ff7f00","B5"="#cab2d6","B6"="#6a3d9a","A3"="#b2df8a","B2"="#e31a1c","B3"="#fdbf6f")
otu.cols<-c("1A"="#13073A","1B"="#261758","1C"="#403075","1D"="#615192","1E"="#887CAF","2A"="#806D15","2B"="#AA9739","2C"="#D4C26A","2D"="#FFF0AA","3A"="#6F256F","4A"="#6A7B15","4B"="#91A437","5A"="#123652","5B"="#29506D","5C"="#496D89","6A"="#2D882D","7A"="#801515","7B"="#AA3939","7D"="#D46A6A","8A"="#AA7939")

all.cols<-c(cluster.cols,otu.cols)

soil.cols<-c("Calcisols"="#1b9e77","Cambisols"="#d95f02","Kastanozems"="#7570b3","Leptosols"="#e7298a","Luvisols"="#66a61e","Phaeozems"="#e6ab02","Regosols"="#a6761d","Vertisols"="#666666")
all.cols.2<-c(cluster.cols,soil.cols)

worldmap<-map_data("world")
world.base<-ggplot(data=worldmap,mapping=aes(x=long,y=lat,group=group))+coord_fixed()+geom_polygon(color="black",fill="gray") + ylab("Latitude") + xlab("Longitude")
world.base.meso<-world.base + coord_fixed(xlim=c(-13,92),ylim=c(4,41))

ethiopia.sldf<-SpatialLinesDataFrame(SpatialLines(list(Lines(list(Line(
    rbind(c(36.9,8.3),c(36.9,14.3),c(39.9,14.3),c(39.9,8.3),c(36.9,8.3)))),
    ID="MR.bbox")),proj4string=CRS("+proj=longlat +datum=WGS84 +no_defs")),
    data.frame(id="MR.bbox",row.names="MR.bbox"))
ethiopia.gg.df<-do.call(rbind,lapply(ethiopia.sldf$id,function(x)data.frame(id=x,coordinates(ethiopia.sldf[ethiopia.sldf$id==x,]))))

india.sldf<-SpatialLinesDataFrame(SpatialLines(list(Lines(list(Line(
    rbind(c(74.5,15.9),c(74.5,31.1),c(86.1,31.1),c(86.1,15.9),c(74.5,15.9)))),
    ID="MR.bbox")),proj4string=CRS("+proj=longlat +datum=WGS84 +no_defs")),
    data.frame(id="MR.bbox",row.names="MR.bbox"))
india.gg.df<-do.call(rbind,lapply(india.sldf$id,function(x)data.frame(id=x,coordinates(india.sldf[india.sldf$id==x,]))))

morocco.sldf<-SpatialLinesDataFrame(SpatialLines(list(Lines(list(Line(
    rbind(c(-4.3,33.3),c(-4.3,35.5),c(-6.9,35.5),c(-6.9,33.3),c(-4.3,33.3)))),
    ID="MR.bbox")),proj4string=CRS("+proj=longlat +datum=WGS84 +no_defs")),
    data.frame(id="MR.bbox",row.names="MR.bbox"))
morocco.gg.df<-do.call(rbind,lapply(morocco.sldf$id,function(x)data.frame(id=x,coordinates(morocco.sldf[morocco.sldf$id==x,]))))

turkey.sldf<-SpatialLinesDataFrame(SpatialLines(list(Lines(list(Line(
    rbind(c(37.7,37.3),c(37.7,38.5),c(42.7,38.5),c(42.7,37.3),c(37.7,37.3)))),
    ID="MR.bbox")),proj4string=CRS("+proj=longlat +datum=WGS84 +no_defs")),
    data.frame(id="MR.bbox",row.names="MR.bbox"))
turkey.gg.df<-do.call(rbind,lapply(turkey.sldf$id,function(x)data.frame(id=x,coordinates(turkey.sldf[turkey.sldf$id==x,]))))

  world.base.meso +
      geom_path(data=ethiopia.gg.df,aes(x=X1,y=X2),inherit.aes=F,size=1.5,color="#377eb8") +
      geom_path(data=india.gg.df,aes(x=X1,y=X2),inherit.aes=F,size=1.5,color="#984ea3") +
      geom_path(data=morocco.gg.df,aes(x=X1,y=X2),inherit.aes=F,size=1.5,color="#4daf4a") +
      geom_path(data=turkey.gg.df,aes(x=X1,y=X2),inherit.aes=F,size=1.5,color="#e41a1c") +
      theme_update(panel.border = element_rect(colour = "#000000", fill=NA, size=2)) +
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank())#, axis.line = element_line(colour = "black"))


ggsave("F2A.world-panel.png",dpi=300)

# load data for region-specific maps
noddata<-read.csv("all-rhizobiales-nodules.lat-lon.host-and-country.no-dups.ani-otus.csv",header=T,row.names=1)
more.noddata<-read.table("all-rhizobiales-nods.all-info.8.23.18.tsv",header=T,row.names=1,sep="\t")
more.noddata$soil.taxnwrb.group.genus<-sapply(strsplit(as.vector(more.noddata$soil.taxnwrb.group),split=" "), `[`, 2)

nod.biodiverse.grids<-read.csv("0.2-deg-cells.10-clusters.csv",header=T,row.names=1)
nod.biodiverse.grids$id=rownames(nod.biodiverse.grids)

# draw ethiopia map
ethiopia.base.meso<-world.base + coord_fixed(xlim=c(36.9,39.9),ylim=c(8.3,14.3))

ethiopia.nod<-subset(subset(noddata,country=="Ethiopia"))
ethiopia.nod.xy<-ethiopia.nod[,c(4,3)]
ethiopia.nod.spdf<-SpatialPoints(coords=ethiopia.nod.xy,proj4string=CRS("+proj=longlat +datum=WGS84 +no_defs"))
ethiopia.nod.spdf2<-data.frame(ethiopia.nod.spdf)
ethiopia.nod.spdf2<-cbind(ethiopia.nod.spdf2,ethiopia.nod$ANI.otu)

ethiopia.nod.grids<-subset(nod.biodiverse.grids,country=="ET")
ethiopia.lines=SpatialLines(lapply(rownames(ethiopia.nod.grids),l=0.1,function(i,l){
Lines(list(Line(rbind(c(ethiopia.nod.grids[i,]$Axis_0-l,ethiopia.nod.grids[i,]$Axis_1-l),
c(ethiopia.nod.grids[i,]$Axis_0-l,ethiopia.nod.grids[i,]$Axis_1+l),
c(ethiopia.nod.grids[i,]$Axis_0+l,ethiopia.nod.grids[i,]$Axis_1+l),
c(ethiopia.nod.grids[i,]$Axis_0+l,ethiopia.nod.grids[i,]$Axis_1-l),
c(ethiopia.nod.grids[i,]$Axis_0-l,ethiopia.nod.grids[i,]$Axis_1-l)))),ID=rownames(ethiopia.nod.grids[i,]))
}),proj4string=CRS("+proj=longlat +datum=WGS84 +no_defs"))

ethiopia.lines.df<-SpatialLinesDataFrame(ethiopia.lines,data.frame(id=rownames(ethiopia.nod.grids),row.names=rownames(ethiopia.nod.grids)))
ethiopia.gg.df <- do.call(rbind,lapply(ethiopia.lines.df$id,function(x)data.frame(id=x,coordinates(ethiopia.lines.df[ethiopia.lines.df$id==x,]))))
ethiopia.gg.df<-merge(ethiopia.gg.df,ethiopia.nod.grids[,c("cluster.name","id")])

ethiopia.base.meso.all <- ethiopia.base.meso +
    geom_path(data=ethiopia.gg.df,aes(x=X1,y=X2,group=id,color=cluster.name),size=1) +
    geom_point(data=ethiopia.nod.spdf2,aes(x=lon,y=lat,color=ethiopia.nod$ANI.otu),position = position_jitter(w=0.05,h=0.05),size=1,inherit.aes=F) +
    scale_color_manual(values=all.cols) +
    theme_update(panel.border = element_rect(colour = "#377eb8", fill=NA, size=2)) +
#    theme_update(panel.border = element_rect(colour = "#7A9F35", fill=NA, size=2)) +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
      panel.background = element_blank())

ethiopia.base.meso.all

ggsave("F2A.ethiopia-panel.png")

# draw india map
india.base.meso<-world.base + coord_fixed(xlim=c(74.5,86.1),ylim=c(15.9,31.1))

india.nod<-subset(subset(noddata,country=="India"))
india.nod.xy<-india.nod[,c(4,3)]
india.nod.spdf<-SpatialPoints(coords=india.nod.xy,proj4string=CRS("+proj=longlat +datum=WGS84 +no_defs"))
india.nod.spdf2<-data.frame(india.nod.spdf)
india.nod.spdf2<-cbind(india.nod.spdf2,india.nod$ANI.otu)

india.nod.grids<-subset(nod.biodiverse.grids,country=="IN")
india.lines=SpatialLines(lapply(rownames(india.nod.grids),l=0.1,function(i,l){
Lines(list(Line(rbind(c(india.nod.grids[i,]$Axis_0-l,india.nod.grids[i,]$Axis_1-l),
c(india.nod.grids[i,]$Axis_0-l,india.nod.grids[i,]$Axis_1+l),
c(india.nod.grids[i,]$Axis_0+l,india.nod.grids[i,]$Axis_1+l),
c(india.nod.grids[i,]$Axis_0+l,india.nod.grids[i,]$Axis_1-l),
c(india.nod.grids[i,]$Axis_0-l,india.nod.grids[i,]$Axis_1-l)))),ID=rownames(india.nod.grids[i,]))
}),proj4string=CRS("+proj=longlat +datum=WGS84 +no_defs"))

india.lines.df<-SpatialLinesDataFrame(india.lines,data.frame(id=rownames(india.nod.grids),row.names=rownames(india.nod.grids)))
india.gg.df <- do.call(rbind,lapply(india.lines.df$id,function(x)data.frame(id=x,coordinates(india.lines.df[india.lines.df$id==x,]))))
india.gg.df<-merge(india.gg.df,india.nod.grids[,c("cluster.name","id")])

india.base.meso.all <- india.base.meso +
    geom_path(data=india.gg.df,aes(x=X1,y=X2,group=id,color=cluster.name),size=1) +
    geom_point(data=india.nod.spdf2,aes(x=lon,y=lat,color=india.nod$ANI.otu),position = position_jitter(w=0.05,h=0.05),size=0.1,inherit.aes=F) +
    scale_color_manual(values=all.cols) +
    theme_update(panel.border = element_rect(colour = "#984ea3", fill=NA, size=2)) +
#    theme_update(panel.border = element_rect(colour = "#354F00", fill=NA, size=2)) +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
      panel.background = element_blank())

india.base.meso.all

ggsave("F2A.india-panel.png")

# draw morocco map
morocco.base.meso<-world.base + coord_fixed(xlim=c(-4.3,-6.9),ylim=c(33.3,34.5))

morocco.nod<-subset(subset(noddata,country=="Morocco"))
morocco.nod.xy<-morocco.nod[,c(4,3)]
morocco.nod.spdf<-SpatialPoints(coords=morocco.nod.xy,proj4string=CRS("+proj=longlat +datum=WGS84 +no_defs"))
morocco.nod.spdf2<-data.frame(morocco.nod.spdf)
morocco.nod.spdf2<-cbind(morocco.nod.spdf2,morocco.nod$ANI.otu)

morocco.nod.grids<-subset(nod.biodiverse.grids,country=="MA")
morocco.lines=SpatialLines(lapply(rownames(morocco.nod.grids),l=0.1,function(i,l){
Lines(list(Line(rbind(c(morocco.nod.grids[i,]$Axis_0-l,morocco.nod.grids[i,]$Axis_1-l),
c(morocco.nod.grids[i,]$Axis_0-l,morocco.nod.grids[i,]$Axis_1+l),
c(morocco.nod.grids[i,]$Axis_0+l,morocco.nod.grids[i,]$Axis_1+l),
c(morocco.nod.grids[i,]$Axis_0+l,morocco.nod.grids[i,]$Axis_1-l),
c(morocco.nod.grids[i,]$Axis_0-l,morocco.nod.grids[i,]$Axis_1-l)))),ID=rownames(morocco.nod.grids[i,]))
}),proj4string=CRS("+proj=longlat +datum=WGS84 +no_defs"))

morocco.lines.df<-SpatialLinesDataFrame(morocco.lines,data.frame(id=rownames(morocco.nod.grids),row.names=rownames(morocco.nod.grids)))
morocco.gg.df <- do.call(rbind,lapply(morocco.lines.df$id,function(x)data.frame(id=x,coordinates(morocco.lines.df[morocco.lines.df$id==x,]))))
morocco.gg.df<-merge(morocco.gg.df,morocco.nod.grids[,c("cluster.name","id")])

morocco.base.meso.all <- morocco.base.meso +
    geom_path(data=morocco.gg.df,aes(x=X1,y=X2,group=id,color=cluster.name),size=1) +
    geom_point(data=morocco.nod.spdf2,aes(x=lon,y=lat,color=morocco.nod$ANI.otu),position = position_jitter(w=0.05,h=0.05),size=1,inherit.aes=F) +
    scale_color_manual(values=all.cols) +
    theme_update(panel.border = element_rect(colour = "#4daf4a", fill=NA, size=2)) +
#    theme_update(panel.border = element_rect(colour = "#D4EE9F", fill=NA, size=2)) +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
      panel.background = element_blank())

morocco.base.meso.all

ggsave("F2A.morocco-panel.png")

# draw turkey map
turkey.base.meso<-world.base + coord_fixed(xlim=c(37.7,42.7),ylim=c(37.3,38.5))

turkey.nod<-subset(subset(noddata,country=="Turkey"))
turkey.nod.xy<-turkey.nod[,c(4,3)]
turkey.nod.spdf<-SpatialPoints(coords=turkey.nod.xy,proj4string=CRS("+proj=longlat +datum=WGS84 +no_defs"))
turkey.nod.spdf2<-data.frame(turkey.nod.spdf)
turkey.nod.spdf2<-cbind(turkey.nod.spdf2,turkey.nod$ANI.otu)

turkey.nod.grids<-subset(nod.biodiverse.grids,country=="TR")
turkey.lines=SpatialLines(lapply(rownames(turkey.nod.grids),l=0.1,function(i,l){
Lines(list(Line(rbind(c(turkey.nod.grids[i,]$Axis_0-l,turkey.nod.grids[i,]$Axis_1-l),
c(turkey.nod.grids[i,]$Axis_0-l,turkey.nod.grids[i,]$Axis_1+l),
c(turkey.nod.grids[i,]$Axis_0+l,turkey.nod.grids[i,]$Axis_1+l),
c(turkey.nod.grids[i,]$Axis_0+l,turkey.nod.grids[i,]$Axis_1-l),
c(turkey.nod.grids[i,]$Axis_0-l,turkey.nod.grids[i,]$Axis_1-l)))),ID=rownames(turkey.nod.grids[i,]))
}),proj4string=CRS("+proj=longlat +datum=WGS84 +no_defs"))

turkey.lines.df<-SpatialLinesDataFrame(turkey.lines,data.frame(id=rownames(turkey.nod.grids),row.names=rownames(turkey.nod.grids)))
turkey.gg.df <- do.call(rbind,lapply(turkey.lines.df$id,function(x)data.frame(id=x,coordinates(turkey.lines.df[turkey.lines.df$id==x,]))))
turkey.gg.df<-merge(turkey.gg.df,turkey.nod.grids[,c("cluster.name","id")])

turkey.base.meso.all <- turkey.base.meso +
    geom_path(data=turkey.gg.df,aes(x=X1,y=X2,group=id,color=cluster.name),size=1) +
    geom_point(data=turkey.nod.spdf2,aes(x=lon,y=lat,color=turkey.nod$ANI.otu),position = position_jitter(w=0.05,h=0.05),size=1,inherit.aes=F) +
    scale_color_manual(values=all.cols) +
    theme_update(panel.border = element_rect(colour = "#e41a1c", fill=NA, size=2)) +
#    theme_update(panel.border = element_rect(colour = "#226666", fill=NA, size=2)) +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
      panel.background = element_blank())

turkey.base.meso.all

ggsave("F2A.turkey-panel.png")

# draw ethiopia map with points colored by soil type:
ethiopia.nod.soil<-subset(subset(more.noddata,country=="ET"))
ethiopia.nod.xy.soil<-ethiopia.nod.soil[,c(7,6)]
ethiopia.nod.spdf.soil<-SpatialPoints(coords=ethiopia.nod.xy.soil,proj4string=CRS("+proj=longlat +datum=WGS84 +no_defs"))
ethiopia.nod.spdf2.soil<-data.frame(ethiopia.nod.spdf.soil)
ethiopia.nod.spdf2.soil<-cbind(ethiopia.nod.spdf2.soil,ethiopia.nod.soil$soil.taxnwrb.group.genus)

ethiopia.base.meso.all.soil <- ethiopia.base.meso +
    geom_path(data=ethiopia.gg.df,aes(x=X1,y=X2,group=id,color=cluster.name),size=1) +
    geom_point(data=ethiopia.nod.spdf2.soil,aes(x=lon,y=lat,color=ethiopia.nod.soil$soil.taxnwrb.group.genus),position = position_jitter(w=0.05,h=0.05),size=1,inherit.aes=F) +
    scale_color_manual(values=all.cols.2) +
    theme_update(panel.border = element_rect(colour = "#377eb8", fill=NA, size=2)) +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
      panel.background = element_blank())

ethiopia.base.meso.all.soil

ggsave("FigS7.ethiopia-panel-soils-points.png")

# draw india map with points colored by soil type:
india.nod.soil<-subset(subset(more.noddata,country=="IN"))
india.nod.xy.soil<-india.nod.soil[,c(7,6)]
india.nod.spdf.soil<-SpatialPoints(coords=india.nod.xy.soil,proj4string=CRS("+proj=longlat +datum=WGS84 +no_defs"))
india.nod.spdf2.soil<-data.frame(india.nod.spdf.soil)
india.nod.spdf2.soil<-cbind(india.nod.spdf2.soil,india.nod.soil$soil.taxnwrb.group.genus)

india.base.meso.all.soil <- india.base.meso +
    geom_path(data=india.gg.df,aes(x=X1,y=X2,group=id,color=cluster.name),size=1) +
    geom_point(data=india.nod.spdf2.soil,aes(x=lon,y=lat,color=india.nod.soil$soil.taxnwrb.group.genus),position = position_jitter(w=0.05,h=0.05),size=0.5,inherit.aes=F) +
    scale_color_manual(values=all.cols.2) +
    theme_update(panel.border = element_rect(colour = "#984ea3", fill=NA, size=2)) +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
      panel.background = element_blank())

india.base.meso.all.soil

ggsave("FigS7.india-panel-soils-points.png")

# draw morocco map with points colored by soil type:
morocco.nod.soil<-subset(subset(more.noddata,country=="MR"))
morocco.nod.xy.soil<-morocco.nod.soil[,c(7,6)]
morocco.nod.spdf.soil<-SpatialPoints(coords=morocco.nod.xy.soil,proj4string=CRS("+proj=longlat +datum=WGS84 +no_defs"))
morocco.nod.spdf2.soil<-data.frame(morocco.nod.spdf.soil)
morocco.nod.spdf2.soil<-cbind(morocco.nod.spdf2.soil,morocco.nod.soil$soil.taxnwrb.group.genus)

morocco.base.meso.all.soil <- morocco.base.meso +
    geom_path(data=morocco.gg.df,aes(x=X1,y=X2,group=id,color=cluster.name),size=1) +
    geom_point(data=morocco.nod.spdf2.soil,aes(x=lon,y=lat,color=morocco.nod.soil$soil.taxnwrb.group.genus),position = position_jitter(w=0.05,h=0.05),size=1,inherit.aes=F) +
    scale_color_manual(values=all.cols.2) +
    theme_update(panel.border = element_rect(colour = "#4daf4a", fill=NA, size=2)) +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
      panel.background = element_blank())

morocco.base.meso.all.soil

ggsave("FigS7.morocco-panel-soils-points.png")

# draw turkey map with points colored by soil type:
turkey.nod.soil<-subset(subset(more.noddata,country=="TU"))
turkey.nod.xy.soil<-turkey.nod.soil[,c(7,6)]
turkey.nod.spdf.soil<-SpatialPoints(coords=turkey.nod.xy.soil,proj4string=CRS("+proj=longlat +datum=WGS84 +no_defs"))
turkey.nod.spdf2.soil<-data.frame(turkey.nod.spdf.soil)
turkey.nod.spdf2.soil<-cbind(turkey.nod.spdf2.soil,turkey.nod.soil$soil.taxnwrb.group.genus)

turkey.base.meso.all.soil <- turkey.base.meso +
    geom_path(data=turkey.gg.df,aes(x=X1,y=X2,group=id,color=cluster.name),size=1) +
    geom_point(data=turkey.nod.spdf2.soil,aes(x=lon,y=lat,color=turkey.nod.soil$soil.taxnwrb.group.genus),position = position_jitter(w=0.05,h=0.05),size=1,inherit.aes=F) +
    scale_color_manual(values=all.cols.2) +
    theme_update(panel.border = element_rect(colour = "#e41a1c", fill=NA, size=2)) +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
      panel.background = element_blank())

turkey.base.meso.all.soil

ggsave("FigS7.turkey-panel-soils-points.png")
