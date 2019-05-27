require(raster)
require(sp)

nodway<-read.csv("doc/all-genomes.all-info.only-w-lon-lat.4.23.18.csv",header=T,row.names=2,sep='\t')

r <- getData('worldclim',var='bio',res=2.5)
r <- r[[c(1,12)]]
names(r) <- c("Temp","Prec")

coords<-data.frame(x=nodway$lon,y=nodway$lat)
rownames(coords)<-rownames(nodway)
points<-SpatialPoints(coords,proj4string=r@crs)

values<-extract(r,points)
df<-cbind.data.frame(coordinates(points),values)

nodway$Temp<-df$Temp
nodway$Prec<-df$Prec

write.csv(nodway,"doc/all-genomes.all-info.only-w-lon-lat.bioclim.9.27.18.csv")