#!/usr/bin/env Rscript
cmdArgs = commandArgs(trailingOnly=TRUE)

library(data.table)
library(argparse)

parser <- ArgumentParser(description='Extract city boundaries')
parser$add_argument('--input', dest='input', type='character', help='Input file')
parser$add_argument("--output", dest='output', type='character', help="Output path")
parser$add_argument("--country_code", dest='ccode', type='character', help="Country code")
parser$add_argument("--reference", dest='reference', type='character', help="State reference file")
parser$add_argument("--top", dest='top', type='integer', help="State to filter")
parser$add_argument("--prefilter", dest='prefilter', type='character', help='Prefilter cities list')

# cmdArgs <- c("--input", "temp/tempcsvextract_us.tsv", "--output", "/home/arunas/maps/workdir/osmnames/city-boundary-files/us/", "--top", "250", "--reference", "config-files/reference-all-states.csv", "--country_code", "us", "--prefilter", "osmnames/filtered-cities/us/us.csv")

print("Running with inputargs:")
print(cmdArgs)
args <- parser$parse_args(cmdArgs)

data <- fread(args$input)
valid_coordinates <- (data$west < data$east) & (data$south < data$north)
data <- data[valid_coordinates, ]


reference <- subset(fread(args$reference), country_code == args$ccode)
# zoom_cities <- fread("config-files/zoom-cities.csv")
# include_cities <- zoom_cities$city
if (!is.null(args$prefilter) & length(args$prefilter) > 0) {
  prefilter <- fread(args$prefilter)
}

for (state_code in reference$state_code) {
  state_name <- reference$state_name[reference$state_code == state_code]
  state_data <- subset(data, subset = data$state == state_name)
  if (!is.null(args$prefilter) & length(args$prefilter) > 0) {
    state_data <- subset(state_data, state_data$name %in% prefilter$Name)
  }
  filter_cities <- state_data
  # filter_cities1 <- subset(state_data, subset = (state_data$name %in% include_cities))
  # filter_cities2 <- subset(state_data, subset = (state_data$city == state_data$name & !(state_data$name %in% include_cities)))
  # filter_cities <- rbind(filter_cities1, filter_cities2)
  # filter_cities <- subset(filter_cities, filter_cities$name == filter_cities$city)
  filter_cities <- subset(filter_cities, !duplicated(filter_cities$name))
  
  selected_columns <- filter_cities[, c("name", "west", "south", "east", "north"), with = FALSE]
  selected_columns <- head(selected_columns, args$top)
  output <- cbind(row.names(selected_columns), selected_columns)
  colnames(output)[1] <- ""
  output_dir_name <- paste0(args$output, state_code, "/")
  dir.create(output_dir_name, showWarnings = TRUE)
  output_file_name <- paste0(output_dir_name, state_code, ".tsv")
  write.table(output, file = output_file_name, sep = ',', row.names = FALSE, col.names = TRUE)
}
