# EDSA_final_project
#Project proposal

Objective:
The objective of this project is to create a code to combine two data sets and manipulate the resulting data into a form that can be used in R in order to graph the data. The data should be formatted in a way that multiple graphing techniques can be created quickly and efficiently. This data is particle size data from sand sizes down to clay. Sand size grains were sieved by hand, while the clay and silt sizes were analyzed on Beckman Coulter single wavelength LS13-320 particle size analyzer. The hand sieved data and the particle analyzer data must be combined in such a way that each sample must have particle size data from sand to clay in a single column represented as a mass percent.

Data source:
This data was collected by two previous master students under Dr. Vesper. The sediment is from a variety of caves from West Virginia and the surrounding states. Files are in the git repo

Implementation:
I will start by changing file names to something more descriptive and consistent as the files names make no sense as they are. Each sample collected on the particle analyzer has its own excel file with size fractions represented as a percent. The first step is to change the file format of these .xls files into a csv and with a more organized format, getting rid of the fractions in which no data exists. This process will be done in bash using a loop. Once every file is clean and organized, I will be able to add the hand sieved data to the csv file. The hand sieved data is stored in a single excel file. I must extract the data for a desired sample out of the excel file and combine it with the data in the newly formatted csv file for that same sample. This will be done using a loop as well. The hand sieved data was calculated out of a mass percent the total percent of the clay and silt fractions were calculated by weighing the bottom fraction from the sieving process. The bottom clay and silt fraction is what was ran on the particle analyzer. Therefore, the percent fractions from the particle analyzer data are representing the percent contribution of each clay and silt size fraction of the whole clay and silt fraction from the hand sieved data as illustrated below.
Example Sample_1
Hand sieve data:					Particle analyzed data:
2mm-1mm 		        5%	  62.5 um-31.25 um 		  10% of 35%
1mm-0.5mm		        10%	  31.25 um-15.625 um		20% of 35%
0.5-0.0625mm        50%	  15.625um-7.8125 um		70% of 35%
clay+silt fraction 	35%		and so on….
This math must be done in the newly formatted csv file using a loop in R. Each sample was split and analyzed in three replications for the hand sieving process. The samples were then split again three times on the particle analyzer. A single sample has three replications for the hand sieving data and nine replications for the particle analyzer. This is illustrated below.
For sample_1:
hand sieve data:		particle analyzer data
sample_1_R1					sample_1_R1_01
sample_1_R2					sample_1_R1_02
sample_1_R3					sample_1_R1_03
                    sample_1_R2_01
                    sample_1_R2_02
                    sample_1_R2_03
                    sample_1_R3_01
                    sample_1_R3_02
                    sample_1_R3_03

The particle analyzer data will be averaged for each R 1, 2, and 3 sample and sent to a separate csv file. The averaged particle analyzer data is what is to be combined with the hand sieved replications in a single csv file for each sample. Once the file manipulation is done R will be used in order to graph the data in various ways.

Expected products:
Three csv files for R1, R2, and R3 of each sample with the particle analyzer data averaged. A single csv file for every sample containing the three replications. Graphs illustrating the standard deviations of the data, as well as % contribution of each fraction for every sample and an average particle size for all of the samples.

Questions:
What is the best way to change file formats quickly?
Is a csv the best file format for this project?
Some loops will need to be performed in R and some will be performed in bash. Is this ok?
