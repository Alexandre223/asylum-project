** =========================================== **
** MASTER FILE ANALYSIS FOR PAPER AND APPENDIX **
** =========================================== **

clear 
set more off, permanently
cd F:/research/asylum-project

* DESCRIPTIVES
do ./src/analysis/descriptives.do

* APPLICATION ANALYSIS
do ./src/analysis/application_analysis.do


* DECISION ANALYSIS
do ./src/analysis/decision_analysis.do
