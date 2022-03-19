# FoundationsOfCSS_Group_4
Statistics about the influence of Elon Musk’s tweets on market prices for Tesla Inc.’ stocks and Bitcoin
## About
This project was developed by Tobias Bergsmann, Laura Gröttrup, Martina Leber and Florian Thaler as part of the course "Foundation of Computational Social System" at the TU / Uni Graz.
## Quickstart
The project consists of two parts: The code for the automated analysis and the resources. 
The required data sets are already stored in this project, allowing the program to be executed nearly directly.

In order to see the analysis and the results of the analysis with the data we have provided, the dependencies must first be installed and loaded into R via the main.R script. 
If the environment variables are not already there, the two steps of data acquisition and data processing have to be executed with following lines in main.R: 
source("scripts\data_retrival.R")
source("scripts\data_processing.R")
If you are working on a Windows, you have to replace all '\' in the path names with '//'. This must also be done in the data_retrival.R and data_processing.R scripts!

After this every single analysis step can be found and executed in markdowns/data_analysis.Rmd with explanation.
