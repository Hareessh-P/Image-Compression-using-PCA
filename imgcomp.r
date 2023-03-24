# Load libraries
library(tidyverse)
library(jpeg)
library(factoextra)
library(knitr)
#read img
image <- readJPEG("C:\\Users\\Akhilesh\\Downloads\\tiger.jpg")
# Structure
str(image)
# Structure
dim(image)
# RGB color matrices
rimage <- image[,,1]
gimage <- image[,,2]
bimage <- image[,,3]
# PCA for each color scheme
pcar <- prcomp(rimage, center=FALSE)
pcag <- prcomp(gimage, center=FALSE)
pcab <- prcomp(bimage, center=FALSE)

# PCA objects into a list
pcaimage <- list(pcar, pcag, pcab)
# Data frame for easier plotting
df <- data.frame(scheme=rep(c("R", "G", "B"), each=nrow(image)),index=rep(1:nrow(image), 3),var=c(pcar$sdev^2,pcag$sdev^2,pcab$sdev^2))

# Reorder of factors
df$scheme <- factor(df$scheme, levels(df$scheme)[c(3,2,1)])

# Scree plot 
df %>% group_by(scheme) %>%mutate(propvar=100*var/sum(var)) %>% ungroup() %>% ggplot(aes(x=index, y=propvar, fill=scheme)) + geom_bar(stat="identity") + geom_line() + labs(title="Scree plot", x="Principal Component", y="% of Variance") + scale_x_continuous(limits=c(0, 20)) + facet_wrap(~scheme) + theme_bw() + theme(legend.title=element_blank(),legend.position="bottom") 

