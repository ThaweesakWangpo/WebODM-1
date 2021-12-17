library(FIELDimageR)
library(raster)

#Uploading file orthophoto 
image <- stack("odm_orthophoto.tif")
plotRGB(image, r = 1, g = 2, b = 3)

#Cropping image
image.Crop <- fieldCrop(mosaic = image)

#Rotation image
image.Rotated <- fieldRotate(mosaic = image.Crop, theta = 2.3 )

#Removing soil out.
image.RemSoil <- fieldMask(mosaic = image.Rotated, Red = 1, Green = 2, Blue = 3, index = "HUE")


#Define grids of field.
width <- as.integer(readline("How wide is the area? : "))
length <- as.integer(readline("How length is the area? : "))
image.Shape<-fieldShape(mosaic = image.RemSoil,ncols = width, nrows = length)


# Uploading files dtm and dsm.
DTM <- stack("dtm.tif")
DSM <- stack("dsm.tif")

# Cropping the image using the previous shape from image.crop:
DTM.Crop <- fieldCrop(mosaic = DTM,fieldShape = image.Crop)
DSM.Crop <- fieldCrop(mosaic = DSM,fieldShape = image.Crop)

# Canopy Height Model (CHM): Plant Height
DTM.Rotated <- resample(DTM.Crop, DSM.Crop)
CHM <- DSM.Crop-DTM.Rotated

# Rotating the image using the same theta:
CHM.Rotated<-fieldRotate(CHM, theta = 2.3)

# Removing the soil using mask from step 4:
CHM.S <- fieldMask(CHM.Rotated, mask = image.RemSoil$mask)
 
# Extracting the estimate plant height average (EPH):
EPH <- fieldInfo(CHM.S$newMosaic, fieldShape = image.Shape$fieldShape, fun = "mean")
EPH$plotValue

#Writout plant height file
write.csv(EPH$plotValue,file = "PlantHeight.csv",row.names = F)





