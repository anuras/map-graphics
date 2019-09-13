#!/usr/bin/env Rscript
cmdArgs = commandArgs(trailingOnly=TRUE)

library(data.table)
library(argparse)

zoom <- function(input_data, zoom_data) {
  
  if(!all(c("city", "zoom") %in% colnames(zoom_data))) {
    stop ("zoom_data needs to contain c(city, zoom) columns")
  }
  op_data <- input_data
  op_data$zoom <- 1.0
  matching <- match(zoom_data$city, op_data$name)
  op_data$shift_right <- 0.0
  op_data$shift_top <- 0.0
  op_data$zoom[matching[!is.na(matching)]] <- zoom_data$zoom[!is.na(matching)]
  op_data$shift_right[matching[!is.na(matching)]] <- zoom_data$shift_right[!is.na(matching)]
  op_data$shift_top[matching[!is.na(matching)]] <- zoom_data$shift_top[!is.na(matching)]
  op_data$center_we <- (op_data$west + op_data$east)/2
  op_data$center_ns <- (op_data$north + op_data$south)/2
  op_data$new_west <- op_data$center_we - ((op_data$east - op_data$west)/2)/op_data$zoom
  op_data$new_east <- op_data$center_we + ((op_data$east - op_data$west)/2)/op_data$zoom
  op_data$new_north <- op_data$center_ns + ((op_data$north - op_data$south)/2)/op_data$zoom
  op_data$new_south <- op_data$center_ns - ((op_data$north - op_data$south)/2)/op_data$zoom
  op_data$shift_right_abs <- op_data$shift_right * (op_data$east - op_data$new_east)
  op_data$shift_top_abs   <- op_data$shift_top * (op_data$north - op_data$new_north)
  op_data$new_west <- op_data$new_west + op_data$shift_right_abs
  op_data$new_east <- op_data$new_east + op_data$shift_right_abs
  op_data$new_north <- op_data$new_north + op_data$shift_top_abs
  op_data$new_south <- op_data$new_south + op_data$shift_top_abs
  
  op_data$west <- op_data$new_west
  op_data$east <- op_data$new_east
  op_data$north <- op_data$new_north
  op_data$south <- op_data$new_south
  op_data[, colnames(input_data), with = FALSE]
}

parser <- ArgumentParser(description='Extract city boundaries')
parser$add_argument('--input', dest='input', type='character', help='Input file')
parser$add_argument("--output", dest='output', type='character', help="Output file")
parser$add_argument("--state", dest='state', type='character', help="State to filter")
parser$add_argument("--top", dest='top', type='integer', help="State to filter")
parser$add_argument("--prefilter", dest='prefilter', type='character', help='Prefilter cities list')

# x <- c("--input", "tempcsvextractdk.tsv", "--output", "dkextr.csv", "--top", "25")
# cmdArgs <- c("--input", "tempcsvextract.tsv", "--output", "/home/arunas/maps/workdir/osmnames/city-boundary-files/us/al/al.tsv", "--top", "25", "--state", "Alabama")

print("Running with inputargs:")
print(cmdArgs)
args <- parser$parse_args(cmdArgs)
args$state <- gsub('[\"]', '', args$state)

data <- fread(args$input)
if (!is.null(args$state) & length(args$state) > 0) {
  data <- subset(data, subset = data$state == args$state)
}
if (!is.null(args$prefilter) & length(args$prefilter) > 0) {
  prefilter <- fread(args$prefilter)
  data <- subset(data, data$name %in% prefilter$Name)
}
# filter_cities <- data[type == "city" && city == name, ]
zoom_cities <- fread("config-files/zoom-cities.csv")
include_cities <- zoom_cities$city
filter_cities <- subset(data, subset = (data$city == data$name | data$name %in% include_cities))
selected_columns <- filter_cities[, c("name", "west", "south", "east", "north"), with = FALSE]
if (!is.null(args$top)) {
  selected_columns <- head(selected_columns, args$top)
}
output <- cbind(row.names(selected_columns), selected_columns)
output <- zoom(output, zoom_cities)
colnames(output)[1] <- ""

write.table(output, file = args$output, sep = ',', row.names = FALSE, col.names = TRUE)
