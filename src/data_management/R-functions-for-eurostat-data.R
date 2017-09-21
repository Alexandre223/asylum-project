# create functions for converting asylum data files from Eurostat
# into nicely formated  stata files


# INSTALL NECESSARY PACKAGES

#install.packages("data.table")
library("data.table")
#install.packages("taRifx")
library("taRifx")
#install.packages("foreign")
library(foreign)
#install.packages("XLConnect")
library("XLConnect")
#install.packages("reshape")
library("reshape")
#install.packages("reshape2")
library("reshape2")


#DEFINE FUNCTIONS

# read_origin = function that extracts the country of origin from the Excel Sheet downloaded from Eurostat and converts it into a vector that can be matched to the data table

read_origin <- function(workbook, # name of workbook
                        sheet, # number of sheet in the excel file
                        origin_row, # row number of origin country cell in excel
                        origin_col, # column number of origin country cell in excel
                        row_number = 29 # number of rows that the vector should have                                            = number of destination countries
                        ){
  source_country <- readWorksheet(workbook, sheet = sheet, 
                                  startRow = origin_row, endRow = origin_row,
                                  startCol = origin_col, endCol = origin_col,
                                  header = FALSE)

  origin <- data.frame(matrix(NA, nrow = row_number, ncol = 1))

  for (i in 1:nrow(origin)){
  origin[i, 1] <- source_country[1,1]  
  }

  colnames(origin) <- "origin"
  
  return(origin)
}



# read_data = function that makes use of the read_origin function to convert the data of a single excel sheet from Eurostat into a R data frame
read_data <- function(workbook, 
                      sheet, 
                      start_table, 
                      end_table, 
                      origin_row, 
                      origin_col){
  # read table
  data <- readWorksheet(workbook, sheet = sheet, 
                        startRow = start_table, endRow = end_table,
                        header=TRUE)
  colnames(data)[1] <- "destination"
  
  # read origin country
  origin <- read_origin(workbook, 
                        sheet = sheet, 
                        origin_row = origin_row, 
                        origin_col = origin_col)
  # combine to one table
  final <- as.data.table(cbind(origin, data))
}




# Eurostat_convert = function that reads the excel files from Eurostat and converts it to a R data frame called final

Eurostat_convert <- function (inpath,
                              start_table,
                              end_table, 
                              origin_row, 
                              origin_col) {
  
  # read excel file into workbook and count number of sheets
  excel <- loadWorkbook(inpath)
  numberofsheets <- length(getSheets(excel))
  
  # step 1, extract data from sheet 1 and convert it into a data table
    final <- read_data(excel,
                       sheet = 1, 
                       start_table = start_table,
                       end_table = end_table, 
                       origin_row = origin_row, 
                       origin_col = origin_col)

    # step 2: loop over the rest of the sheets and append them to the table of sheet 1
  for (x in 2:numberofsheets){
    temp <- read_data(excel,
                       sheet = x, 
                       start_table = start_table,
                       end_table = end_table, 
                       origin_row = origin_row, 
                       origin_col = origin_col)

    final <- rbind(final, temp)
  }
    
  return(final)
}



# edit_monthly = function that reshapes and edits monthly Eurostat data
edit_monthly <- function(source,
                         var_name, 
                         begin_year = 2,
                         end_year = 5, 
                         begin_month = 7, 
                         end_month = 8 ){
  
  #recode missing variables to NA
  missing <- source == ":"
  source[missing] <- NA
  
  #destring variables
  for (i in 3:ncol(source)){
    source[[i]] <- as.numeric(source[[i]])
  }
  
  #reshape data to long
  final_long <- melt(source, id=c("origin", "destination"))
  colnames(final_long)[4] <- var_name
  
  #split variable to get year and month
  year <- substr(final_long$variable, begin_year, end_year)
  month <- substr(final_long$variable, begin_month, end_month)
  final_long <- data.frame(final_long, year, month, stringsAsFactors = FALSE) 
  
  #delete variable from reshape
  final_long$variable <- NULL
  
   #destring month and year
  final_long$year <- as.numeric(final_long$year)
  final_long$month <- as.numeric(final_long$month)
  
  #add column with quarters infered from month variable
  #add column with quarters infered from month variable
  final_long$quarter <- NA
  final_long$quarter[final_long$month <=3] <- 1
  final_long$quarter[final_long$month >=4 & final_long$month <=6] <- 2
  final_long$quarter[final_long$month >=7 & final_long$month <=9] <- 3
  final_long$quarter[final_long$month >=10] <- 4

  return(final_long)
}


Eurostat_monthly <- function(inpath,
                             var_name,
                             outpath,
                             start_table = 13,
                             end_table = 42, 
                             origin_row= 7, 
                             origin_col = 2, 
                             begin_year = 2,
                             end_year = 5, 
                             begin_month = 7,
                             end_month = 8){
  
  data_converted <- Eurostat_convert(inpath = inpath, 
                                     start_table = start_table,
                                     end_table = end_table, 
                                     origin_row = origin_row,
                                     origin_col = origin_col)
  
  final <- edit_monthly(source = data_converted, 
                        var_name = var_name, 
                        begin_year = begin_year,
                        end_year = end_year, 
                        begin_month = begin_month, 
                        end_month = end_month)
  
  write.dta(final, outpath) 
  
}



#test calling the function

Eurostat_monthly(inpath = "C:/Users/Martina/Dropbox/src/original_data/asylum-data/firsttimeapp08-16.xls", 
                 var_name = "firsttimeapp", 
                 outpath = "C:/Users/Martina/Dropbox/src/original_data/asylum-data/firsttimeapp08-16.dta" )