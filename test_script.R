#loading excel files
files <- list.files("./particle_analyzer_data_edited")
list_of_data <- "dataframe_list.txt"
dataframe_list <- scan(list_of_data, character())
bins_vector <- c("0.00049-0.00024", "0.00098-0.00049", "0.002-0.00098", "0.0039-0.002", "0.0078-0.0039", "0.0156-0.0078",  "0.031-0.0156", "0.0625-0.031")
bins <- data.frame(row.names = bins_vector)

for (xfile_name in files) {
    x_data <- read.delim(paste0("particle_analyzer_data_edited/", xfile_name))
assign(xfile_name, c(sum(x_data[1:3,2]), sum(x_data[4:11,2]), sum(x_data[12:18,2]),  sum(x_data[19:26,2]), sum(x_data[27:33,2]), sum(x_data[34:40,2]), sum(x_data[41:48,2]), sum(x_data[49:56,2])))
bins <- cbind(bins, get(xfile_name))
}

colnames(bins) <- dataframe_list
