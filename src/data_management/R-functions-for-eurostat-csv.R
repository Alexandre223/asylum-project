# Functions to prepare Eurostat Data

#install.packages("foreign")
library(foreign)

Eurostat_monthly <- function(inpath,
                             name, 
                             outpath,
                             var_keep = c("TIME", "GEO", "CITIZEN", "Value"),
                             begin_year = 1,
                             end_year = 4,
                             begin_month = 6,
                             end_month = 7){
  data <- read.csv(file = inpath, stringsAsFactors = FALSE)
  
  data <- data[,var_keep]
  
  # delete commas as thousand separators
  data$Value <- gsub(",", "", data$Value)
  
  year <- substr(data$TIME, begin_year, end_year)
  month <- substr(data$TIME, begin_month, end_month)
  data<- data.frame(data, year, month, stringsAsFactors = FALSE) 
  
  data$TIME <- NULL
  
  var_name <- c("destination", "origin", name)
  
  colnames(data)[1:3] <- var_name
  
  #destring data
  for (i in 3:ncol(data)){
    data[[i]] <- as.numeric(data[[i]])
  }
  
  #add column with quarters infered from month variable
  data$quarter <- NA
  data$quarter[data$month <=3] <- 1
  data$quarter[data$month >=4 & data$month <=6] <- 2
  data$quarter[data$month >=7 & data$month <=9] <- 3
  data$quarter[data$month >=10] <- 4
  
  write.dta(data, outpath) 
}


Eurostat_quarterly <- function(inpath,
                               name, 
                               outpath,
                               var_keep = c("TIME", "GEO", "CITIZEN", "Value"),
                               begin_year = 1,
                               end_year = 4,
                               pos_quarter= 7){
  data <- read.csv(file = inpath, stringsAsFactors = FALSE)
  
  data <- data[,var_keep]
  
  # delete commas as thousand separators
  data$Value <- gsub(",", "", data$Value)
  
  year <- substr(data$TIME, begin_year, end_year)
  quarter <- substr(data$TIME, pos_quarter, pos_quarter)
  data<- data.frame(data, year, quarter, stringsAsFactors = FALSE) 
  
  data$TIME <- NULL
  
  var_name <- c("destination", "origin", name)
  
  colnames(data)[1:3] <- var_name
  
  #destring data
  for (i in 3:ncol(data)){
    data[[i]] <- as.numeric(data[[i]])
  }

  write.dta(data, outpath) 
}


Eurostat_yearly <- function(inpath,
                            name, 
                            outpath,
                            var_keep = c("TIME", "GEO", "CITIZEN", "Value")){
  data <- read.csv(file = inpath, stringsAsFactors = FALSE)
  
  data <- data[,var_keep]
  
  # delete commas as thousand separators
  data$Value <- gsub(",", "", data$Value)
  
  #destring data
  data$TIME <- as.numeric(data$TIME)
  data$Value <- as.numeric(data$Value)
  
  var_name <- c("year", "destination", "origin", name)
  
  colnames(data) <- var_name
  
  write.dta(data, outpath) 
}
