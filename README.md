# Script steps
The script does the following steps (broken up by comments)
1) Loads packages
2) Loads data files
3) Sets the variable names in the testing and training files using the features file
4) Adds subject ID and activity type columns to respective data sets
5) Removes duplicate columns (was giving me an error when trying to combine data sets)
6) combines the data using rbind (didn't use merge, since the variables were all the same?)
7) pulls out just mean and std (with subject ID and activity type) and rebinds just those columns
8) cleans up the variable names
9) goes through the data frame by subject ID, then by activity type, and averages the variables, then adds the averages to a new data ame (summaryset)
10) converts activity type as numeric to text from the activity labels file
11) writes the resulting data frame to a .txt file
