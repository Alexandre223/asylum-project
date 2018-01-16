** =========================================== **
** MASTER FILE ANALYSIS FOR PAPER AND APPENDIX **
** =========================================== **

clear 
set more off, permanently
cd F:/research/asylum-project


* SUMMARY STATISTICS *
do ./src/analysis/final_analysis_for_paper/summary_statistics.do


* FINAL ANALYSIS FOR PAPER *
do ./src/analysis/final_analysis_for_paper/analysis_for_paper.do


* APPLICATION ROBUSTNESS FOR APPENDIX *
do ./src/analysis/final_analysis_for_paper/app_analysis_for_appendix.do


* DECISION ROBUSTNESS FOR APPENDIX *
do ./src/analysis/final_analysis_for_paper/dec_analysis_for_appendix.do
