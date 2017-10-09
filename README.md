# asylum-project
The political economy of EU asylum policies

The project I'm currently working on with two coauthors aims at examining the impact of elections and parties on first-time asylum applications and asylum decisions. For the project we combine data on origin specific aslyum applications and decisions from Eurostat with data on elections and party positions from ParlGov. Moreover we use several control variables for the origin countries, the destination countries and
also some bilateral controls. 

I've been working on the project for about 6 months now and so far I've been writing all my code in stata and was not using any version control programm. Moreover, after downloading the data I generally edited most excel files manually before reading them into stata. 

For the assigment of the course I automated everything that I was doing maually so far, wrote some R functions to convert csv files from Eurostat to stata .dta files, brought all files in the folder structure of the template and improved the code in the stata do files, by for example adding more loops. Furthermore I started to use Git and Github.

In order to reproduce the data management process you would need to run the R files first and afterwards the master do file in stata. 

If you change the working directory in those two files and add the respective directories for the output data everything should work out. 

The directory structure for the output data looks as follows ./out/data/temp

Most output data files are saved in the temp directory, only the final dataset is saved under ./out/data.


