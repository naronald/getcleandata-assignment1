# README: Getting and Cleaning Data assignment, May 2014
N.A. Ronald


This document describes the process undertaken for cleaning the UCI HAR dataset
as described in the project specification.

## Getting data

The following tables were imported:
* features.txt
* Y_test.txt, X_test.txt, subject_test.txt
* Y_train.txt, X_train.txt, subject_train.txt

The single column in *_subject.txt was renamed "Subject".
The single column in Y_*.txt was renamed "ActivityID".
The columns in X_*.txt were renamed using the values in features.txt.

The *_test.txt tables were combined as subject_*.txt, y_*.txt, and x_*.txt using
cbind.

The new test and train tables were combined using rbind.

## Extracting only mean/stdev measurements

This was taken to mean only variables containing the word "mean()" or "std()";
note that "meanFreq()" was not included. 

## Naming activities in dataset

Using the values in activity_labels.txt, a new column ActivityDescription was
created based on the activities in the column "ActivityID". The values in
activity_labels.txt had underscores removed and were converted to all lower
case, and were then converted to a factor. ActivityID was then deleted from the
dataset. The set of activity names is now:

* laying 
* sitting 
* standing 
* walking 
* walkingdownstairs 
* walkingupstairs

## Appropriate labels for activity names

This was difficult to define. While I can see that variable names should be all
lower case and not contain any punctuation, I would find that particularly
difficult to read (especially as a programmer used to bumpy caps or underscores).

In the end, I removed all brackets and replaced all dashes with fullstops. This
at least separates between mean/std and X/Y/Z and makes it easy to see which
variables relate to the same sensor.

I also replaced the following:
* variables beginning with an 'f' -> "Frequency"
* variables beginning with an 't' -> "Time"
* "Mag" -> "Magnitude"
* "Acc" -> "Acceleration"
* "mean" -> "Mean"
* "std" -> "StdDev"

Codebook.md lists the variables in the dataset.

## Second tidy dataset

This was created using aggregate, taking the mean of each column for each
activity and subject.
