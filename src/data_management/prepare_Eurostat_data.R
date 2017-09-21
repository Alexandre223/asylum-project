# Convent Eurostat asylum data into stata dta files making use of the created functions

setwd("F:/research/asylum-project")
source("./src/data_management/R-functions-for-eurostat-csv.R")


###############################
# Application data up to 2007 #
###############################

# First-time asylum applications monthly 2002 - 2007
Eurostat_monthly(inpath = "./src/original_data/asylum_data/first-time-applications-02-07-m.csv",
                 name = "firsttimeapp", 
                 outpath = "./bld/out/data/first-time-applications-02-07-m.dta")

# Total asylum applications yearly 1995 - 2007
Eurostat_yearly(inpath = "./src/original_data/asylum_data/applications-95-07-y.csv",
                name = "applications", 
                outpath = "./bld/out/data/temp/applications-95-07-y.dta")


################################
# Application data 2008 - 2016 #
################################

# First-time asylum applications monthly 2008 - 2016
Eurostat_monthly(inpath = "./src/original_data/asylum_data/first-time-applications-08-16-m.csv",
                 name = "firsttimeapp", 
                 outpath = "./bld/out/data/temp/first-time-applications-08-16-m.dta")

# First-time asylum applications yearly 2008 - 2016
Eurostat_yearly(inpath = "./src/original_data/asylum_data/first-time-applications-08-16-y.csv",
                name = "firsttimeapp", 
                outpath = "./bld/out/data/temp/first-time-applications-08-16-y.dta")

# Total asylum applications monthly 2008 - 2016
Eurostat_monthly(inpath = "./src/original_data/asylum_data/applications-08-16-m.csv",
                 name = "applications", 
                 outpath = "./bld/out/data/temp/applications-08-16-m.dta")

# Total asylum applications yearly 2008 - 2016
Eurostat_yearly(inpath = "./src/original_data/asylum_data/applications-08-16-y.csv",
                name = "applications", 
                outpath = "./bld/out/data/temp/applications-08-16-y.dta")


#############################
# Decision data 2002 - 2007 #
#############################

# Total decisions monthly 2002 - 2007
Eurostat_monthly(inpath = "./src/original_data/asylum_data/total-decisions-02-07-m.csv",
                 name = "totaldecisions", 
                 outpath = "./bld/out/data/temp/total-decisions-02-07-m.dta")

# Total positive decisions monthly 2002 - 2007
Eurostat_monthly(inpath = "./src/original_data/asylum_data/total-positive-02-07-m.csv",
                 name = "totalpositive", 
                 outpath = "./bld/out/data/temp/total-positive-02-07-m.dta")

# Refugee status decisions monthly 2002 - 2007
Eurostat_monthly(inpath = "./src/original_data/asylum_data/refugee-status-02-07-m.csv",
                 name = "refugeestatus", 
                 outpath = "./bld/out/data/temp/refugee-status-02-07-m.dta")

# Rejected decisions monthly 2002 - 2007
Eurostat_monthly(inpath = "./src/original_data/asylum_data/rejected-02-07-m.csv",
                 name = "rejected", 
                 outpath = "./bld/out/data/temp/other-rejected-02-07-m.dta")

# Other positive decisions monthly 2002 - 2007
Eurostat_monthly(inpath = "./src/original_data/asylum_data/other-positive-02-07-m.csv",
                 name = "otherpositive", 
                 outpath = "./bld/out/data/temp/other-positive-02-07-m.dta")

# Other non-status decisions monthly 2002 - 2007
Eurostat_monthly(inpath = "./src/original_data/asylum_data/other-non-status-02-07-m.csv",
                 name = "othernonstatus", 
                 outpath = "./bld/out/data/temp/other-non-status-02-07-m.dta")

# Humanitarian status decisions monthly 2002 - 2007
Eurostat_monthly(inpath = "./src/original_data/asylum_data/humanitarian-status-02-07-m.csv",
                 name = "humanitarian", 
                 outpath = "./bld/out/data/temp/other-humanitarian-status-02-07-m.dta")




#############################
# Decision data 2008 - 2016 #
#############################

# Total decisions quarterly 2008 - 2016
Eurostat_quarterly(inpath = "./src/original_data/asylum_data/total-decisions-08-16-q.csv",
                   name = "totaldecisions", 
                   outpath = "./bld/out/data/temp/total-decisions-08-16-q.dta")

# Total positive decisions quarterly 2008 - 2016
Eurostat_quarterly(inpath = "./src/original_data/asylum_data/total-positive-08-16-q.csv",
                   name = "totalpositive", 
                   outpath = "./bld/out/data/temp/total-positive-08-16-q.dta")

# Refugee status decisions quarterly 2008 - 2016
Eurostat_quarterly(inpath = "./src/original_data/asylum_data/refugee-status-08-16-q.csv",
                   name = "refugeestatus", 
                   outpath = "./bld/out/data/temp/refugee-status-08-16-q.dta")

# Rejected decisions quarterly 2008 - 2016
Eurostat_quarterly(inpath = "./src/original_data/asylum_data/rejected-08-16-q.csv",
                   name = "rejected", 
                   outpath = "./bld/out/data/temp/rejected-08-16-q.dta")

# Humanitarian status decisions quarterly 2008 - 2016
Eurostat_quarterly(inpath = "./src/original_data/asylum_data/humanitarian-status-08-16-q.csv",
                   name = "humanitarian", 
                   outpath = "./bld/out/data/temp/humanitarian-status-08-16-q.dta")

# Temporary protection decisions quarterly 2008 - 2016
Eurostat_quarterly(inpath = "./src/original_data/asylum_data/temporary-protection-08-16-q.csv",
                   name = "temporary", 
                   outpath = "./bld/out/data/temp/temporary-protection-08-16-q.dta")

# Subsidiary protection decisions quarterly 2008 - 2016
Eurostat_quarterly(inpath = "./src/original_data/asylum_data/subsidiary-protection-08-16-q.csv",
                   name = "subsidiary", 
                   outpath = "./bld/out/data/temp/subsidiary-protection-08-16-q.dta")