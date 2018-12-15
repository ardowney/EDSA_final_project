rm(list=ls())

#runs bash script to manipulate instrument data
x <- "bash cut_loop.sh"
system (x, intern =TRUE)

#needed packages 
library(tidyverse)
library(tidyr)
library(readxl)

#loading files
files <- list.files("./particle_analyzer_data_edited")

#loading in sample name lists that will be referenced
list_of_data <- "dataframe_list.txt"
replication <- "replication_list.txt"
samples <- "sample_list.txt"

#removing duplicates from list 
replication_list <- unique(scan(replication, character()))

#creating a list of text files in order to load them 
dataframe_list <- scan(list_of_data, character())

#creating a list of sample names
sample_list <- scan(samples, character())

#created a vector with desired bins; *THIS MAY BE ADJUSTED*
bins_vector <- c("0.00049-0.00024", "0.00098-0.00049", "0.002-0.00098", "0.0039-0.002", "0.0078-0.0039", "0.0156-0.0078",  "0.031-0.0156", "0.0625-0.031")
bins <- data.frame(row.names = bins_vector)

#looping through the dataframe list; 
#*CHANGING BIN DIVISIONS MUST ALSO CHANGE SUMS IN THIS LOOP*
for (xfile_name in files) {
   x_data <- read.delim(paste0("particle_analyzer_data_edited/", xfile_name))
    assign(xfile_name, c(sum(x_data[1:3,2]), sum(x_data[4:11,2]), sum(x_data[12:18,2]),  sum(x_data[19:26,2]), sum(x_data[27:33,2]), sum(x_data[34:40,2]), sum(x_data[41:48,2]), sum(x_data[49:56,2])))
      bins <- cbind(bins, get(xfile_name))
}
colnames(bins) <- dataframe_list

#creating empty dataframe for data to be filled
averaged_data <- data.frame(row.names = bins_vector)

#averages the 9 replications done for each sample
n <- 1:ncol(bins)
unused_df <- matrix(c(n, rep(NA, 9 - ncol(bins)%%9)), byrow=TRUE, ncol=9)
unused_df <- data.frame(t(na.omit(unused_df)))
averaged_data <- do.call(cbind, lapply(unused_df, function(i) rowMeans(bins[, i])))
colnames(averaged_data) <- replication_list

#converting volume % to a decimal form 
averaged_data <- averaged_data[,]/100

# loading in hand data to be added to the created "averaged_data"
hand_data_file <- "hand_sieved_data_modified.xlsx"
hand_data <- read_xlsx(hand_data_file)

#creating a dataframe with just the sand and silt fraction
to_bin <- hand_data[ hand_data$`Particle Size` %in% "<0.0625" ,]

#summing the replicate samples
unique_hand_data <- aggregate(to_bin$`sed (g)`, by=list("sample name"=to_bin$`sample name`), FUN=sum)
#tidying up the dataframe
colnames(unique_hand_data)[colnames(unique_hand_data)=="x"] <- "<0.0625_weight"
rownames(unique_hand_data) <- unique_hand_data$`sample name`

#creating a vector of <0.0625 mass from the hand sieved data
particle_weight <- unique_hand_data[rownames(unique_hand_data)==colnames(averaged_data),2]

#multiplying the averaged data by the <0.0625 weight
averaged_data<- t(apply(averaged_data, 1, "*", particle_weight))
#creats a vector of the hand sieved fraction
hand_categories <- c("0.125-0.0625", "0.250-0.125", "0.5-0.250", "1-0.5", "2-1", ">2")

#removing <0.0624 rows from the hand data
hand_data <- hand_data[!(hand_data$`Particle Size`=="<0.0625"),]

#isolating each size fraction into its own dataframe
"above_2" <- hand_data[hand_data$`Particle Size` %in% ">2",7]
"2-1" <- hand_data[hand_data$`Particle Size` %in% c("2-1","1-2"),7]
"1-0.5" <- hand_data[hand_data$`Particle Size` %in% c("1-0.5","0.5-1","0.500-1"),7]
"0.5-0.250" <- hand_data[hand_data$`Particle Size` %in% c("0.5-0.25","0.250-0.5", "0.25- 0.5"),7]
"0.250-0.125" <- hand_data[hand_data$`Particle Size` %in% c("0.125-0.250","0.125-0.25"),7]
"0.125-0.0625" <- hand_data[hand_data$`Particle Size` %in% c("0.625-0.125","0.0625- 0.125"),7]
#adding sample names to the >2 dataframe
rownames(above_2) <- replication_list

#combining all the isolated dataframes
hand_data_to_average_data <- cbind(`0.125-0.0625`,`0.250-0.125`,`0.5-0.250`, `1-0.5`, `2-1`, `above_2`)
rownames(hand_data_to_average_data) <- replication_list
colnames(hand_data_to_average_data) <- hand_categories
hand_data_to_average_data <- as.data.frame(t(hand_data_to_average_data))

#adds hand sieved data to the particle analyzer data
averaged_data <- rbind(averaged_data, hand_data_to_average_data)

#divding the columns by the inital mass to get a mass percent
total_volume <- colSums(averaged_data)
averaged_data<- t(apply(averaged_data, 1, "/", total_volume))

#decimal percent to whole percent
averaged_data <- averaged_data*100

#averages the 3 replications done for each sample
n <- 1:ncol(averaged_data)
unused_df <- matrix(c(n, rep(NA, 3 - ncol(averaged_data)%%3)), byrow=TRUE, ncol=3)
unused_df <- data.frame(t(na.omit(unused_df)))
averaged_data <- do.call(cbind, lapply(unused_df, function(i) rowMeans(averaged_data[, i])))
colnames(averaged_data) <- sample_list

#adding size bins as a row in the data frame 
particle_bins <- rownames(averaged_data)
averaged_data <- as.data.frame(cbind(particle_bins, averaged_data))

#turning the averaged data into a long format 
averaged_data$particle_bins <- factor(averaged_data$particle_bins, levels = particle_bins [1:14])
averaged_data_long <- gather(averaged_data, sample, mass_percent, "CRWD1":"TAL5", factor_key=TRUE)
mass_percent <- as.numeric(averaged_data_long$mass_percent) #converting the mass column to a numeric object
averaged_data_long <- averaged_data_long [,-ncol(averaged_data_long)]
averaged_data_long <- as.data.frame(cbind(averaged_data_long, mass_percent))


#plotting packages
library(ggplot2)
library(scales)
library(colorspace)
theme_set(theme_classic())

#plotting the data as a cumulative percent
colors <- rainbow_hcl(14, start = 200, end = 0)
dens <- density(averaged_data_long[averaged_data_long$sample %in% "DLBK3", 3])
ggplot(averaged_data_long, aes(x = sample, y = mass_percent ,fill = particle_bins)) + 
  geom_bar(position = "fill", stat = "identity") + 
  scale_fill_viridis(discrete=TRUE, option = "viridis", direction = -1)

#to just plot 1 sample; *REPLACE SAMPLE NAME FIRST*
ggplot(subset(averaged_data_long, sample %in% "CRWD1"), aes(x=particle_bins, y=mass_percent)) + 
  geom_bar(stat="identity") +
  stat_summary(fun.y=max, colour="#FF6666", geom="smooth", aes(group = 1)) 





                 

