These matlab scripts are used to load raw extracted shell features, then processed for classification.

loadOnColor.m is aimed to load raw color feature of shell, then processed to 12 elements delegating final color feature of shell.
loadOnShape.m is applied to load shape feature of shell image
loadOnTexture.m is used to load raw texture feature of shell.
makeshell.m uses PCA to reduce raw texture feature dimension, then combine three features together.
Shell_KNN.m and Shell_Forest.m are used to do shell classification, and showing the effectiveness of three features in this shell dataset. 
