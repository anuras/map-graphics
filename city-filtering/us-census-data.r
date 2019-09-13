library(data.table)

trim <- function (x) gsub("^\\s+|\\s+$", "", x)

cities <- fread("census/us/sub-est2017_all.csv")
threshold <- 100000
filter_cities <- cities[POPESTIMATE2017 > threshold, ]
cbsa <- fread("census/us/cbsa-est2017-alldata.csv")
mta <- cbsa[LSAD == "Metropolitan Statistical Area", ]
# mta$state <- sapply(strsplit(mta$NAME, ",", fixed = TRUE), function(x) trim(x[length(x)]))

data <- fread("../temp/tempcsvextract_us.tsv")
valid_coordinates <- (data$west < data$east) & (data$south < data$north)
data <- data[valid_coordinates, ]

areas <- strsplit(mta$NAME, ",", fixed = TRUE)
mtanames <- sapply(areas, function(x) x[1])
mta$mtaname <- mtanames

mtas <- sapply(mta$NAME, function(x) {
  names <- strsplit(x, ",", fixed = TRUE)
  states <- strsplit(trim(names[[1]][length(names[[1]])]), split = "-", fixed = TRUE)[[1]]
  areas <- names[[1]][1]
  mtanames <- unique(unlist(strsplit(areas[[1]], split = "-", fixed = TRUE)))
  lapply(states, function(st) { lapply(mtanames, function(nm) c(nm, st)) })
})
mtadf <- data.frame(matrix(unlist(mtas), ncol = 2, byrow=T))
mtadf$X1 <- as.character(mtadf$X1)
mtadf$X2 <- as.character(mtadf$X2)

usdatastates <- c("Alabama","Alaska","Arizona","Arkansas","California","Colorado",
            "Connecticut","Delaware","District of Columbia","Florida","Georgia",
            "Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky",
            "Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota",
            "Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire",
            "New Jersey","New Mexico","New York","North Carolina","North Dakota",
            "Ohio","Oklahoma","Oregon","Pennsylvania","Puerto Rico","Rhode Island",
            "South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont",
            "Virginia","Washington","West Virginia","Wisconsin","Wyoming")
usdatastcodes <- c("AL", "AK","AZ","AR","CA","CO",
                   "CT","DE","DC", "FL", "GA",
                   "HI", "ID", "IL", "IN", "IA", "KS", "KY",
                   "LA", "ME", "MD", "MA", "MI", "MN", 
                   "MS", "MO",  "MT", "NE", "NV", "NH",
                   "NJ", "NM", "NY", "NC", "ND",
                   "OH", "OK", "OR", "PA", "PR", "RI", 
                   "SC", "SD",  "TN", "TX", "UT", "VT", 
                   "VA", "WA", "WV", "WI", "WY")
usdatastcodes <- tolower(usdatastcodes)
names(usdatastates) <- usdatastcodes


output_dir <- "../osmnames/city-boundary-files/us/"
limit_cities <- 100

for (state_code in names(usdatastates)) {
  state_name <- usdatastates[state_code]
  state_data <- subset(data, subset = data$state == state_name)
  filtered_mtas <- mtadf$X1[mtadf$X2 == toupper(state_code)]
  
  altname <- sapply(state_data$alternative_names, function(x) {
    split <- strsplit(x, ",", fixed = TRUE)
    found <- any(split[[1]] %in% filtered_mtas)
    found
  })
  realname <- state_data$name %in% filtered_mtas
  namefound <- realname | altname
  names(namefound) <- NULL
  state_data <- subset(state_data, namefound)
  filter_cities <- subset(state_data, !duplicated(state_data$name))
  
  selected_columns <- filter_cities[, c("name", "west", "south", "east", "north"), with = FALSE]
  selected_columns <- head(selected_columns, limit_cities)
  output <- cbind(row.names(selected_columns), selected_columns)
  colnames(output)[1] <- ""
  output_dir_name <- paste0(output_dir, state_code, "/")
  dir.create(output_dir_name, showWarnings = TRUE)
  output_file_name <- paste0(output_dir_name, state_code, ".tsv")
  write.table(output, file = output_file_name, sep = ',', row.names = FALSE, col.names = TRUE)
}

zoomformat <- data.table(city = mtanames,zoom = 1.0, shift_right = 0.0, shift_top = 0.0)
write.table(zoomformat, "config-files/zoom-cities.csv", row.names = FALSE, sep = ",", quote = FALSE, append = TRUE, col.names = FALSE)

