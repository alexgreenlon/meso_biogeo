library(RCurl)
library(rgdal)
library(GSIF)
library(raster)
library(plotKML)
library(XML)
library(lattice)
library(aqp)

gdal_translate = "gdal_translate"
gdalwarp = "gdalwarp"
gdalinfo = "gdalinfo"

sg.ftp <- "ftp://ftp.soilgrids.org/data/recent/"
filenames = getURL(sg.ftp, ftp.use.epsv = TRUE, dirlistonly = TRUE)
filenames = strsplit(filenames, "\r*\n")[[1]]

TAX.name<-filenames[grep(filenames,pattern=glob2rx("TAXOUSDA_250m.tif$"))]
#wcs = "http://webservices.isric.org/geoserver/wcs?"
wcs = "http://data.isric.org/geoserver/sg250m/wms?"
l1 <- newXMLNode("WCS_GDAL")
l1.s <- newXMLNode("ServiceURL", wcs, parent=l1)
#l1.l <- newXMLNode("CoverageName", "TAXOUSDA_250m", parent=l1)
l1.l <- newXMLNode("CoveragexName", "TAXOUSDA_250m", parent=l1)
l1
xml.out="data/soil/isric/TAXOUSDA_250m.xml"
saveXML(l1,file=xml.out)
system(paste(gdalinfo,xml.out))

#ethiopia.base.meso<-world.base + coord_fixed(xlim=c(36.9,39.9),ylim=c(8.3,14.3))
et.bbox<-as.matrix(data.frame(min=c(36.9,8.3),max=c(39.9,14.3),row.names=c("x","y")))
te=as.vector(et.bbox)
bb <- matrix(nrow=2, c(-180,-56.0008104,179.9999424,83.9991672))
o.x = 172800 + round(172800*(te[1]-bb[1,2])/(bb[1,2]-bb[1,1]))
o.y = round(67200*(bb[2,2]-te[4])/(bb[2,2]-bb[2,1]))
d.y = round(67200*(te[4]-te[2])/(bb[2,2]-bb[2,1]))
d.x = round(172800*(te[3]-te[1])/(bb[1,2]-bb[1,1]))
o.x; o.y; d.x; d.y

system(paste0(gdal_translate, ' ', xml.out, ' data/soil/isric/ethiopia.TAXOUSDA_250m.tif -tr ', 1/120, ' ', 1/120, ' -co \"COMPRESS=DEFLATE\" -srcwin ', paste(c(o.x, o.y, d.x, d.y), collapse=" ")))

in.bbox<-as.matrix(data.frame(min=c(74.5,15.5),max=c(86.1,31.1),row.names=c("x","y")))
te=as.vector(in.bbox)
bb <- matrix(nrow=2, c(-180,-56.0008104,179.9999424,83.9991672))
o.x = 172800 + round(172800*(te[1]-bb[1,2])/(bb[1,2]-bb[1,1]))
o.y = round(67200*(bb[2,2]-te[4])/(bb[2,2]-bb[2,1]))
d.y = round(67200*(te[4]-te[2])/(bb[2,2]-bb[2,1]))
d.x = round(172800*(te[3]-te[1])/(bb[1,2]-bb[1,1]))
o.x; o.y; d.x; d.y

system(paste0(gdal_translate, ' ', xml.out, ' data/soil/isric/india.TAXOUSDA_250m.tif -tr ', 1/120, ' ', 1/120, ' -co \"COMPRESS=DEFLATE\" -srcwin ', paste(c(o.x, o.y, d.x, d.y), collapse=" ")))

tr.bbox<-as.matrix(data.frame(min=c(37.7,37.3),max=c(42.7,38.5),row.names=c("x","y")))
te=as.vector(tr.bbox)
bb <- matrix(nrow=2, c(-180,-56.0008104,179.9999424,83.9991672))
o.x = 172800 + round(172800*(te[1]-bb[1,2])/(bb[1,2]-bb[1,1]))
o.y = round(67200*(bb[2,2]-te[4])/(bb[2,2]-bb[2,1]))
d.y = round(67200*(te[4]-te[2])/(bb[2,2]-bb[2,1]))
d.x = round(172800*(te[3]-te[1])/(bb[1,2]-bb[1,1]))
o.x; o.y; d.x; d.y

system(paste0(gdal_translate, ' ', xml.out, ' data/soil/isric/turkey.TAXOUSDA_250m.tif -tr ', 1/120, ' ', 1/120, ' -co \"COMPRESS=DEFLATE\" -srcwin ', paste(c(o.x, o.y, d.x, d.y), collapse=" ")))

ma.bbox<-as.matrix(data.frame(min=c(-4.3,33.3),max=c(-6.9,34.5),row.names=c("x","y")))
te=as.vector(ma.bbox)
bb <- matrix(nrow=2, c(-180,-56.0008104,179.9999424,83.9991672))
o.x = 172800 + round(172800*(te[1]-bb[1,2])/(bb[1,2]-bb[1,1]))
o.y = round(67200*(bb[2,2]-te[4])/(bb[2,2]-bb[2,1]))
d.y = round(67200*(te[4]-te[2])/(bb[2,2]-bb[2,1]))
d.x = round(172800*(te[3]-te[1])/(bb[1,2]-bb[1,1]))
o.x; o.y; d.x; d.y

system(paste0(gdal_translate, ' ', xml.out, ' data/soil/isric/morocco.TAXOUSDA_250m.tif -tr ', 1/120, ' ', 1/120, ' -co \"COMPRESS=DEFLATE\" -srcwin ', paste(c(o.x, o.y, d.x, d.y), collapse=" ")))