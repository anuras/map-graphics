library(data.table)

trim <- function (x) gsub("^\\s+|\\s+$", "", x)
# canada <- fread("downloads/census/canada/98-400-X2016001_English_CSV_data.csv")
# canada <- subset(canada, canada$`DIM: Age (in single years) and average age (127)` == "Total - Age")
# threshold <- 10000
# filter_canada_cities <- canada[`Dim: Sex (3): Member ID: [1]: Total - Sex` > threshold, ]
# canada <- fread("downloads/census/canada/population2016.csv")
# write.csv(canada, "downloads/census/canada/population2011.csv")
canada1 <- fread("census/canada/98-310-XWE2011002-301.CSV")
colnames(canada1) <- c("geocode","name","geotype","firstnationsett2011","pop2011","pop2006","2006 adjusted population flag","Incompletely enumerated Indian reserves and Indian settlements, 2006","Population, % change","Total private dwellings, 2011","Private dwellings occupied by usual residents, 2011","Land area in square kilometres, 2011","Population density per square kilometre, 2011","National population rank, 2011","Provincial/territorial population rank, 2011")
canada1 <- canada1[, c("name", "pop2011")]
getnames <- strsplit(canada1$name, "(", fixed = TRUE)
placename <- sapply(getnames, function(x) trim(x[1]))
provname <- sapply(getnames, function(x) { gsub(")", "", x[length(x)], fixed = TRUE) })
canada1$name <- placename
canada1$state <- provname

province_codes <- c("nl", "pe", "ns", "nb", "qb", "on", "mb", "sk", "ab", "bc", "yt", "nt", "nu")
names(province_codes) <- c("N.L.", "P.E.I.", "N.S.", "N.B.", "Que.", "Ont.", "Man.", "Sask.", "Alta.", "B.C.", "Y.T.", "N.W.T.", "Nvt.")
threshold <- 10000
canada1 <- canada1[pop2011 > threshold, ]

canada1$state_code <- ""
prov_match <- match(canada1$state, names(province_codes))
canada1$state_code[!is.na(prov_match)] <- province_codes[prov_match[!is.na(prov_match)]]
counties <- grep("County", canada1$`Geographic name`)
canada1 <- canada1[!counties,]

canada2 <- fread("census/canada/pop2016wiki.csv")
canada2 <- canada2[pop2016 > threshold, ]

province_names <- c("Quebec","Ontario","British Columbia","Alberta", "Saskatchewan","Manitoba",
                    "Nova Scotia","New Brunswick","Nunavut","Newfoundland and Labrador","Yukon", "Prince Edward Island","Northwest Territories") 
names(province_names) <- c("qb", "on", "bc", "ab", "sk", "mb", "ns", "nb", "nu", "nl", "yt", "pe", "nt")

data <- fread("../temp/tempcsvextract_ca.tsv")
valid_coordinates <- (data$west < data$east) & (data$south < data$north)
data <- data[valid_coordinates, ]

output_dir <- "../osmnames/city-boundary-files/ca/"
limit_cities <- 100

for (state_code in names(province_names)) {
  state_name <- province_names[state_code]
  state_data <- subset(data, subset = data$state == state_name)
  
  prefilter_names <- c(canada1$name[canada1$state_code == state_code],
                       canada2$name[canada2$province == state_code])
  altname <- sapply(state_data$alternative_names, function(x) {
      split <- strsplit(x, ",", fixed = TRUE)
      found <- any(split[[1]] %in% prefilter_names)
      found
  })
  realname <- state_data$name %in% prefilter_names
  namefound <- realname | altname
  names(namefound) <- NULL
  state_data <- subset(state_data, namefound)
  filter_cities <- subset(state_data, !duplicated(state_data$name))
  # filter_cities <- filter_cities[filter_cities$city != "", ]
  
  selected_columns <- filter_cities[, c("name", "west", "south", "east", "north"), with = FALSE]
  selected_columns <- head(selected_columns, limit_cities)
  output <- cbind(row.names(selected_columns), selected_columns)
  colnames(output)[1] <- ""
  output_dir_name <- paste0(output_dir, state_code, "/")
  dir.create(output_dir_name, showWarnings = TRUE)
  output_file_name <- paste0(output_dir_name, state_code, ".tsv")
  write.table(output, file = output_file_name, sep = ',', row.names = FALSE, col.names = TRUE)
}

