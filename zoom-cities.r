#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

library(data.table)

data <- fread(args[1])
zoom <- as.numeric(args[2])
data$center_we <- (data$west + data$east)/2
data$center_ns <- (data$north + data$south)/2
data$new_west <- data$center_we - ((data$east - data$west)/2)/zoom
data$new_east <- data$center_we + ((data$east - data$west)/2)/zoom
data$new_north <- data$center_ns + ((data$north - data$south)/2)/zoom
data$new_south <- data$center_ns - ((data$north - data$south)/2)/zoom

data <- data[, c("V1", "name", "new_west", "new_south", "new_east", "new_north")]
colnames(data) <- c("", "name", "west", "south", "east", "north")

write.csv(data, args[3])
