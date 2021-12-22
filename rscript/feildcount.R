library(FIELDimageR)
library(raster)

#Uploading file orthophoto 
image <- stack("odm_orthophoto.tif")
plotRGB(image, r = 1, g = 2, b = 3)

#Removing soil out.
image.RemSoil <- fieldMask(mosaic = image, Red = 1, Green = 2, Blue = 3, index = "HUE")

#Define grids of field.
column <- as.integer(readline("How many number of column? : "))
row <- as.integer(readline("How many number of Row? : "))
image.Shape<-fieldShape(mosaic = image.RemSoil,ncols = column, nrows = row)

#Counting sugarcane
EX1.SC<-fieldCount(mosaic = image.RemSoil$mask, fieldShape = image.Shape$fieldShape, cex=0.4, col="red",minSize = 10, na.rm = TRUE)
EX1.SC$fieldCount