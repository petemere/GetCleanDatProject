# GetCleanDatProject
Class project for Getting and Cleaning Data

The run_analysis.R script found in this repo processed the data from the Human Activity 
Recognition Using Smartphones Dataset (v1.0) to return the average variable reading 
for all calculated mean and standard deviation variables per subject for each activity.

The code is split into six main sections:

A. Loading libraries and setting the file names and data.
B. Merging the test and train data into one set.
C. Extracting only the relevant variables (i.e. the calculated means and standard deviations).
D. Changing the activity IDs for their names.
E. Summarising the data via mean() for each variable per subject and activity.
F. Formatting the data into a wide format and writing it to a file, tidyData.txt.

A. Loading libraries and setting the file names and data.
=========================================================
The test and train data are merged with the activity and subject ID data immediately in order
to avoid any unintentional re-ordering of the data before merging.

B. Merging the test and train data into one set.
=========================================================
A simple rbind() operaiton.

C. Extracting only the relevant variables (i.e. the calculated means and standard deviations).
=========================================================
Naming the variables at this step allows simple extraction of the relevant ones via regular
expression.  The data.table provides an excellent %like% comparison facility for this.

D. Changing the activity IDs for their names.
=========================================================
Nested data.table function allows the IDs to be matched to their names in another table.  The
activity IDs no longer provide useful information, so they are removed.

E. Summarising the data via mean() for each variable per subject and activity.
=========================================================
data.table provides the ability to summarise data in multiple variables in one command via the
.SD reference.  This, along with the by = feature to find the mean of all variables per 
subject and activity.

F. Formatting the data into a wide format and writing it to a file, tidyData.txt.
=========================================================
The data.table resulting from the step above is in long (melted) format.  The wide format
is preferable in this data summary because each average of a variable is a different measurement.
