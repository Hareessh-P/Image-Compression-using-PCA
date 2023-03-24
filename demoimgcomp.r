# Load libraries
library(tidyverse)
library(jpeg)
library(factoextra)
library(knitr)
# Data points
x <- c(2.5, 0.5, 2.2, 1.9, 3.1, 2.3, 2, 1, 1.5, 1.1)
y <- c(2.4, 0.7, 2.9, 2.2, 3, 2.7, 1.6, 1.1, 1.6, 0.9)

# Data frame
data <- data.frame(x, y)

# Scatter plot
data %>%
  ggplot(aes(x,y)) +
  geom_point(size=2, shape=3, color="blue") +
  theme_bw() +
  labs(title="Original data points")
# Structure
str(data)
# Summary
summary(data)
# First rows 
head(data)
# Last rows 
tail(data)
# Eigenvectors and eigenvalues calculation
eigen <- eigen(data.frame(c(0.616555556, 0.615444444), c(0.615444444, 0.716555556)))

# Eigenvectors
eigen$vectors
# Eigenvalues
eigen$values
# Points with the mean substracted 
xMeanSubstracted <- x - mean(x)
yMeanSubstracted <- y - mean(y)
data2 <- data.frame(xMeanSubstracted, xMeanSubstracted)

# Eigenvectors functions  
fun.1 <- function(x) (0.7351787/0.6778734)*x
fun.2 <- function(x) (0.6778734/-0.7351787)*x


# Scatter plot with the eigenvectors overlayed
data2 %>%
  ggplot(aes(xMeanSubstracted, yMeanSubstracted)) +
  geom_point(size=2, shape=3, color="blue") +
  stat_function(fun=fun.1, linetype="dashed") +
  stat_function(fun=fun.2, linetype="dashed") +
  theme_bw() +
  xlim(-1.5, 1.5) +
  labs(title="Mean adjusted data with eigenvectors overlayed",
       x="x", y="y") +
  annotate("text", x=c(-1.1, 0.9), y=c(1.5, 1.5), 
           label=c("Second Component", "First Component"))
# Principal Component Analysis
pca <- prcomp(data, center=TRUE)

# We can visualize the eigenvectors with the function fviz_eig() 
# Documentation: https://www.rdocumentation.org/packages/factoextra/versions/1.0.5/topics/eigenvalue
# Unfortunately, I get an error when I execute this function on Kaggle
# fviz_eig(pca)

# Cumulative proportion
summary(pca)


# Data expressed in terms of our 2 eigenvectors
dataNewAxes <- as.data.frame(t(t(eigen$vectors) %*% rbind(x - mean(x), y - mean(y))))
names(dataNewAxes) <- c("x", "y")

# New data set 
dataNewAxes


# Visualization
dataNewAxes %>%
  ggplot(aes(x, y)) +
  geom_point(size=2, shape=3, color="blue") +
  theme_bw() +
  labs(title="Data expressed in terms of our 2 eigenvectors",
       x="First Component", y="Second Component") 


# Reconstructed data using only the first principal component 
as.data.frame(t(t(pca$x[, 1] %*% t(pca$rotation[, 1])) + pca$center)) %>%
  ggplot(aes(x, y)) +
  geom_point(size=2, shape=3, color="blue") +
  theme_bw() +
  labs(title="Original data restored using only a single eigenvector")
