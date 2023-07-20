# HLA Subtype Graph
# Wan Qian Siew
# 07/17/2023

# Load the required libraries
library(tidyverse); packageVersion("tidyverse")   # version 2.0.0
library(tools); packageVersion("tools")   # version 4.3.0
library(ggpubr); packageVersion("ggpubr")   # version 0.6.0
library(gridExtra);packageVersion("gridExtra")   # version 2.3
library(ggplot2); packageVersion("ggplot2")   # version 3.4.2

#### Filter Predictions in HC (Keep DRB1) ####

# Set the working directory to the specified directory
setwd("/Users/wanqian/argonFiles/HLA_HC_CSV")

# Get the list of CSV files in the directory
csv_files <- list.files(pattern = "\\.csv$")

# Loop through each CSV file
for (csv_file in csv_files) {
  # Read the CSV file as text
  file_lines <- readLines(csv_file)
  
  # Check if the last line is incomplete
  if (!grepl("\n$", file_lines[length(file_lines)])) {
    # Append an empty line at the end of the file
    file_lines <- c(file_lines, "")
  }
  
  # Find the line numbers of HLA-DRB1 and HLA-DRB2 in the first column
  line_hla_drb1 <- grep("^HLA-DRB1", file_lines)
  line_hla_drb2 <- grep("^HLA-DRB2", file_lines)
  
  # Check if the patterns are found
  if (length(line_hla_drb1) > 0 && length(line_hla_drb2) > 0) {
    # Remove all lines above HLA-DRB1
    modified_lines <- file_lines[line_hla_drb1[1]:length(file_lines)]
    
    # Find the line numbers of HLA-DRB2 in the modified lines
    line_hla_drb2_modified <- grep("^HLA-DRB2", modified_lines)
    
    # Check if HLA-DRB2 is found in the modified lines
    if (length(line_hla_drb2_modified) > 0) {
      # Remove all lines starting from HLA-DRB2
      modified_lines <- modified_lines[1:(line_hla_drb2_modified[1] - 1)]
    }
    
    # Construct the output file path with the modified file name
    file_name <- tools::file_path_sans_ext(csv_file)
    output_file <- paste0(file_name, "_modified.csv")
    
    # Write the modified lines to the output file
    writeLines(modified_lines, con = output_file)
    
    # Read the modified CSV file
    modified_file <- read.csv(output_file, header = FALSE, col.names = c("HLA DR type", "Score", "E-value", "Confidence Value"), fill = TRUE)
    
    # Write the modified data back to the CSV file
    write.csv(modified_file, file = output_file, row.names = FALSE)
  } else {
    # Patterns not found, display a message or handle the error
    print(paste("Patterns not found in", csv_file))
  }
}

#### HC Box Plot (All Predictions in modified CSV Files) ####

# Set the working directory to the specified directory
setwd("/Users/wanqian/argonFiles/HLA_HC_CSV")
directory <- "/Users/wanqian/argonFiles/HLA_HC_CSV"

# Get the list of modified CSV files in the directory
csv_files <- list.files(directory, pattern = "modified.csv$", full.names = TRUE)

# Create an empty data frame to store the combined data
HC_data <- data.frame()

# Loop through each modified CSV file
for (csv_file in csv_files) {
  # Read the modified CSV file
  data <- read.csv(csv_file)
  
  # Filter out rows with NA values in the Score column
  data <- data[!is.na(data$Score), ]
  
  # Append the data to the combined_data data frame
  HC_data <- rbind(HC_data, data)
}

# Ensure column names are correct
colnames(HC_data) <- c("HLA.DR.type", "Score", "E.value", "Confidence.Value")

# Create a grouped boxplot using ggboxplot from ggpubr
HC_boxPlot <- ggboxplot(HC_data, x = "HLA.DR.type", y = "Score", fill = "HLA.DR.type",
                        color = "indianred1", palette = "Set1")+
 labs(title = "HC DRB1")

print(HC_boxPlot)

#### Filter Predictions in MS (Keep DRB1) ####

# Moving on the MS patient CSV Files
 # Set the working directory to the specified directory
 setwd("/Users/wanqian/argonFiles/HLA_MS_CSV")
 
 # Get the list of CSV files in the directory
 csv_files <- list.files(pattern = "\\.csv$")
 
 # Loop through each CSV file
 for (csv_file in csv_files) {
   # Read the CSV file as text
   file_lines <- readLines(csv_file)
   
   # Check if the last line is incomplete
   if (!grepl("\n$", file_lines[length(file_lines)])) {
     # Append an empty line at the end of the file
     file_lines <- c(file_lines, "")
   }
   
   # Find the line numbers of HLA-DRB1 and HLA-DRB2 in the first column
   line_hla_drb1 <- grep("^HLA-DRB1", file_lines)
   line_hla_drb2 <- grep("^HLA-DRB2", file_lines)
   
   # Check if the patterns are found
   if (length(line_hla_drb1) > 0 && length(line_hla_drb2) > 0) {
     # Remove all lines above HLA-DRB1
     modified_lines <- file_lines[line_hla_drb1[1]:length(file_lines)]
     
     # Find the line numbers of HLA-DRB2 in the modified lines
     line_hla_drb2_modified <- grep("^HLA-DRB2", modified_lines)
     
     # Check if HLA-DRB2 is found in the modified lines
     if (length(line_hla_drb2_modified) > 0) {
       # Remove all lines starting from HLA-DRB2
       modified_lines <- modified_lines[1:(line_hla_drb2_modified[1] - 1)]
     }
     
     # Construct the output file path with the modified file name
     file_name <- tools::file_path_sans_ext(csv_file)
     output_file <- paste0(file_name, "_modified.csv")
     
     # Write the modified lines to the output file
     writeLines(modified_lines, con = output_file)
     
     # Read the modified CSV file
     modified_file <- read.csv(output_file, header = FALSE, col.names = c("HLA DR type", "Score", "E-value", "Confidence Value"), fill = TRUE)
     
     # Write the modified data back to the CSV file
     write.csv(modified_file, file = output_file, row.names = FALSE)
   } else {
     # Patterns not found, display a message or handle the error
     print(paste("Patterns not found in", csv_file))
   }
 }
 
 #### MS Box Plot (All Predictions in modified CSV File) ####
 
 # Set the working directory to the specified directory
 setwd("/Users/wanqian/argonFiles/HLA_MS_CSV")
 directory <- "/Users/wanqian/argonFiles/HLA_MS_CSV"
 
 # Get the list of modified CSV files in the directory
 csv_files <- list.files(directory, pattern = "modified.csv$", full.names = TRUE)
 
 # Create an empty data frame to store the combined data
 MS_data <- data.frame()
 
 # Loop through each modified CSV file
 for (csv_file in csv_files) {
   # Read the modified CSV file
   data <- read.csv(csv_file)
   
   # Filter out rows with NA values in the Score column
   data <- data[!is.na(data$Score), ]
   
   # Append the data to the combined_data data frame
   MS_data <- rbind(MS_data, data)
 }
 
 # Ensure column names are correct
 colnames(MS_data) <- c("HLA.DR.type", "Score", "E.value", "Confidence.Value")
 

 #### Combining both MS and HC Box Plot ####
 
 # Create a grouped boxplot using ggboxplot from ggpubr
 MS_boxPlot <- ggboxplot(MS_data, x = "HLA.DR.type", y = "Score", fill = "HLA.DR.type",
                         color = "lightskyblue", palette = "Set2")+
   labs(title = "MS DRB1")

 print(MS_boxPlot)
 #Combine both MS and HC plot together

 # Create a new column "Group" to differentiate HC and MS
 HC_data$Group <- "HC"
 MS_data$Group <- "MS"
 
 # Combine HC and MS data into a single data frame
 combined_data <- rbind(HC_data, MS_data)
 
 # Create a grouped boxplot using ggboxplot from ggpubr
 ggboxplot(combined_data, x = "Group", y = "Score", fill = "HLA.DR.type")+
   labs(title = "Combined Boxplot: HC vs MS", x = "Group", y = "Score") +
   scale_fill_manual(values = c("#E4F1EE", "#D9EDF8", "#DEDAF4", "indianred1", 
                                "lightskyblue", "darkblue", "purple")) +
   theme_minimal()

 
# Code below is for combining all DRB1*15 variants, and calculating the p-value [no longer need them]
 
#  # Combine DR1*15
#  HC_data$HLA.DR.type <- gsub("DRB1\\*15:.*", "DRB1*15", HC_data$HLA.DR.type)
#  MS_data$HLA.DR.type <- gsub("DRB1\\*15:.*", "DRB1*15", MS_data$HLA.DR.type)
#  # Find the common variables present in both HC and MS
#   common_variables <- intersect(unique(HC_data$HLA.DR.type), unique(MS_data$HLA.DR.type))
#  
# # Perform t-tests for each variable in MS and HC
#   t_test_results <- lapply(common_variables, function(var) {
#     hc_scores <- HC_data[HC_data$HLA.DR.type == var, "Score"]
#     ms_scores <- MS_data[MS_data$HLA.DR.type == var, "Score"]
#  
#     t_test_result <- t.test(hc_scores, ms_scores)
#  
#     if (t_test_result$p.value < 0.001) {
#       significant <- TRUE
#     } else {
#       significant <- FALSE
#     }
#  
#     data.frame(HLA.DR.type = var, significant = significant)
#   })
#  
#   # Add fill variable to differentiate between MS and HC
#   MS_data$Group <- "MS"
#   HC_data$Group <- "HC"
#  
#   # Combine MS and HC data
#   combined_data <- rbind(MS_data, HC_data)
#   
#   # Install and load the plotrix package
#   install.packages("plotrix")
#   library(plotrix)
#   
#   # Create a combined box plot with separate sections for MS and HC
#   combined_plot <- ggboxplot(combined_data, x = "HLA.DR.type", y = "Score",
#                              fill = "Group", add = "strip", add.params = list(color = "black", size = 2)) +
#     labs(title = "Combined Box Plot") +
#     theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
#     guides(fill = guide_legend(title = "Data"))
#   
#   # Add asterisks to the significant box plots
#   for (i in 1:length(common_variables)) {
#     if (t_test_results[[i]]$significant) {
#       combined_plot <- combined_plot + annotate("text", x = i, y = max(combined_data$Score) * 1.1, label = "*", vjust = -0.5, size = 4)
#     }
#   }
# 
#   # Create the combined plot with y-axis break and gap
#   combined_plot <- ggplot(data = combined_data, aes(x = HLA.DR.type, y = Score, fill = Group)) +
#     geom_boxplot(color = "black", width = 0.6) +
#     scale_y_continuous(breaks = c(1, 1000, 10000, 50000),
#                        #labels = function(x) ifelse(x == 1000, "////", format(x, big.mark = ",")),
#                        limits = c(1, 50000)) +
#     coord_cartesian(clip = "off", ylim = c(1, 50000)) +
#     theme_minimal() +  # Adjust the theme as desired
#     theme(axis.text.x = element_text(angle = 45, hjust = 1),
#           plot.margin = margin(20, 20, 20, 20))  # Adjust plot margins as desired
#   
#   
#   # Display the combined plot
#   print(combined_plot)
#   ggsave("Combine_bar_plot.png", plot = combined_plot, width = 8, height = 6, dpi = 300)
  
#### Filtering out the top two predictions for each sample file ####
  
  # Set the directory path where the modified CSV files are located [HC]
  directory <- "/Users/wanqian/argonFiles/HLA_HC_CSV"
  
  # Set the output directory
  output_directory <- "/Users/wanqian/argonFiles"
  
  # Get the list of file names in the directory
  files <- list.files(directory, pattern = "modified.csv$", full.names = TRUE)
  
  # Initialize an empty data frame to store the output
  output_data <- data.frame(Sample = character(),
                            Pred_1 = character(),
                            Pred_2 = character(),
                            stringsAsFactors = FALSE)
  
  # Loop through the files and extract the required data
  for (file in files) {
    # Read the CSV file
    data <- read.csv(file, stringsAsFactors = FALSE)
    
    # Extract the file name without the "modified" suffix
    file_name <- gsub("_modified.csv", "", basename(file))
    
    # Find the rows containing "Prediction #1" and "Prediction #2"
    pred_1_row <- grep("Prediction #1", data$HLA.DR.type)
    pred_2_row <- grep("Prediction #2", data$HLA.DR.type)
    
    # Extract the predictions
    pred_1 <- ifelse(length(pred_1_row) > 0, sub("Prediction #1 - ", "", 
                                                 data$HLA.DR.type[pred_1_row + 1]), NA)
    pred_2 <- ifelse(length(pred_2_row) > 0, sub("Prediction #2 - ", "", 
                                                 data$HLA.DR.type[pred_2_row + 1]), NA)
    
    # Create a data frame for the current file
    file_data <- data.frame(Sample = file_name,
                            Pred_1 = pred_1,
                            Pred_2 = pred_2,
                            stringsAsFactors = FALSE)
    
    # Append the file data to the output data frame
    output_data <- rbind(output_data, file_data)
  }
  
  # Set the output file path
  output_file <- file.path(output_directory, "HC_prediction_output.csv")
  
  # Save the extracted data to the output file
  write.csv(output_data, output_file, row.names = FALSE)

  

  # Set the directory path where the modified CSV files are located [MS]
  directory <- "/Users/wanqian/argonFiles/HLA_MS_CSV"
  
  # Set the output directory
  output_directory <- "/Users/wanqian/argonFiles"
  
  # Get the list of file names in the directory
  files <- list.files(directory, pattern = "_modified.csv$", full.names = TRUE)
  
  # Loop through the files and extract the required data
  for (file in files) {
    # Read the CSV file
    data <- read.csv(file, stringsAsFactors = FALSE)
    
    # Extract the file name without the "modified" suffix
    file_name <- gsub("_modified.csv", "", basename(file))
    
    # Find the rows containing "Prediction #1" and "Prediction #2"
    pred_1_row <- grep("Prediction #1", data$HLA.DR.type)
    pred_2_row <- grep("Prediction #2", data$HLA.DR.type)
    
    # Extract the predictions
    pred_1 <- ifelse(length(pred_1_row) > 0, sub("Prediction #1 - ", "", 
                                                 data$HLA.DR.type[pred_1_row + 1]), NA)
    pred_2 <- ifelse(length(pred_2_row) > 0, sub("Prediction #2 - ", "", 
                                                 data$HLA.DR.type[pred_2_row + 1]), NA)
    
    # Create a data frame for the current file
    file_data <- data.frame(Sample = file_name,
                            Pred_1 = pred_1,
                            Pred_2 = pred_2,
                            stringsAsFactors = FALSE)
    
    # Append the file data to the output data frame
    output_data <- rbind(output_data, file_data)
  }
  
  # Set the output file path
  output_file <- file.path(output_directory, "MS_prediction_output.csv")
  
  # Save the extracted data to the output file
  write.csv(output_data, output_file, row.names = FALSE)
  
  
  
  # Code below is commented out because it is just a code to plot a specific sample file
  

  # #Set directory to the directory [HC-10]
  # setwd("/Users/wanqian/argonFiles/HLA_HC_CSV/")
  # # Read the CSV file directly
  # csv_file <- "HC-10.csv"
  # data <- read.csv(csv_file, stringsAsFactors = FALSE, row.names = NULL)
  # 
  # #Read CSV file as text
  # file_lines <- readLines(csv_file)
  # 
  # # Find the line number of "HLA-DPA1" in the first column
  # line_hla_dpa1 <- grep("^HLA-DPA1", file_lines)
  # 
  # # Check if "HLA-DPA1" is found
  # if (length(line_hla_dpa1) > 0) {
  #   # Subset the data up to the row before "HLA-DPA1"
  #   modified_lines <- file_lines[line_hla_dpa1[1]:length(file_lines)]
  # }
  # # Construct the output file path with the modified file name
  # file_name <- tools::file_path_sans_ext(csv_file)
  # output_file <- paste0(file_name, "_full_prediction_modified.csv")
  #     
  # # Write the modified lines to the output file
  # writeLines(modified_lines, con = output_file)
  #     
  # # Read the modified CSV file
  # modified_file <- read.csv(output_file, header = FALSE, col.names = c("HLA DR type", "Score", "E-value", "Confidence Value"), fill = TRUE)
  #     
  # # Remove rows with NA values
  # modified_file <- modified_file[complete.cases(modified_file), ]
  # 
  # # Plot the bar chart
  # bar_plot <- ggplot(modified_file, aes(x = `HLA.DR.type`, y = Score)) +
  #   geom_bar(stat = "identity", fill = "indianred1") +
  #   labs(title = "HC-10", x = "HLA Type", y = "Score") +
  #   theme(axis.text.x = element_text(angle = 45, hjust = 1))
  # 
  # bar_plot
  # # Save the plot as an image file
  # ggsave("HC-10_bar_plot.png", plot = bar_plot, width = 8, height = 6, dpi = 300)
  # 
  #   
  # #Set directory to the directory [MS-119]
  # setwd("/Users/wanqian/argonFiles/HLA_MS_CSV/")
  # # Read the CSV file directly
  # csv_file <- "MS-119.csv"
  # data <- read.csv(csv_file, stringsAsFactors = FALSE, row.names = NULL)
  # 
  # #Read CSV file as text
  # file_lines <- readLines(csv_file)
  # 
  # # Find the line number of "HLA-DPA1" in the first column
  # line_hla_dpa1 <- grep("^HLA-DPA1", file_lines)
  # 
  # # Check if "HLA-DPA1" is found
  # if (length(line_hla_dpa1) > 0) {
  #   # Subset the data up to the row before "HLA-DPA1"
  #   modified_lines <- file_lines[line_hla_dpa1[1]:length(file_lines)]
  # }
  # # Construct the output file path with the modified file name
  # file_name <- tools::file_path_sans_ext(csv_file)
  # output_file <- paste0(file_name, "_full_prediction_modified.csv")
  # 
  # # Write the modified lines to the output file
  # writeLines(modified_lines, con = output_file)
  # 
  # # Read the modified CSV file
  # modified_file <- read.csv(output_file, header = FALSE, col.names = c("HLA DR type", "Score", "E-value", "Confidence Value"), fill = TRUE)
  # 
  # # Remove rows with NA values
  # modified_file <- modified_file[complete.cases(modified_file), ]
  # 
  # # Plot the bar chart
  # bar_plot <- ggplot(modified_file, aes(x = `HLA.DR.type`, y = Score)) +
  #   geom_bar(stat = "identity", fill = "darkblue") +
  #   labs(title = "MS-119", x = "HLA Type", y = "Score") +
  #   theme(axis.text.x = element_text(angle = 45, hjust = 1))
  # 
  # bar_plot
  # # Save the plot as an image file
  # ggsave("MS-119_bar_plot.png", plot = bar_plot, width = 8, height = 6, dpi = 300)

  
  
  #### Add a column to the file to check if it is DR2+ or not ####
  
  # The code below is similar to filtering top 2 predictions, you can just modify the filtering prediction code to add a column 
  
  # Set the working directory to the specified directory
  setwd("/Users/wanqian/argonFiles")
  
  # Read the CSV file
  csv_file <- "HC_prediction_output.csv"  # Replace with the actual file name
  data <- read.csv(csv_file, stringsAsFactors = FALSE)
  
  # Function to check if a value contains "DRB1*15"
  contains_DRB1_15 <- function(value) {
    grepl("DRB1\\*15", value)
  }
  
  # Add a new column to indicate if "DRB1*15" is present in pred_1 and pred_2 for HC
  hc_data$DRB1_15 <- ifelse(contains_DRB1_15(hc_data$Pred_1) | contains_DRB1_15(hc_data$Pred_2), "Yes", "No")
  
  # Count the total number of "Yes" for HC
  hc_count <- sum(hc_data$DRB1_15 == "Yes")
  
  # Create a new row with the count of "yes"
  count_row <- c("Total Count", NA, NA, hc_count)
  
  modified_data <- rbind(modified_data, count_row)
  
  # Save the modified data to a new CSV file
  output_file <- "HC_modified_data.csv"  # Replace with the desired output file name
  write.csv(formatted_data, file = output_file, row.names = FALSE)
  
  # Print the modified data
  print(formatted_data)
  
  
  # Set the working directory to the specified directory
  setwd("/Users/wanqian/argonFiles")
  
  # Read the CSV file
  csv_file <- "MS_prediction_output.csv"  # Replace with the actual file name
  data <- read.csv(csv_file, stringsAsFactors = FALSE)
  
  # Function to check if a value contains "DRB1*15"
  contains_DRB1_15 <- function(value) {
    grepl("DRB1\\*15", value)
  }
  
  # Add a new column to indicate if "DRB1*15" is present in pred_1 and pred_2 for MS
  ms_data$DRB1_15 <- ifelse(contains_DRB1_15(ms_data$Pred_1) | contains_DRB1_15(ms_data$Pred_2), "Yes", "No")
  
  # Count the total number of "Yes" for HC
  ms_count <- sum(ms_data$DRB1_15 == "Yes")
  
  # Create a new row with the count of "yes"
  count_row_1 <- c("Total Count", NA, NA, ms_count)
  
  modified_data <- rbind(modified_data, count_row_1)

  # Save the modified data to a new CSV file
  output_file <- "MS_modified_data.csv"  # Replace with the desired output file name
  write.csv(formatted_data_MS, file = output_file, row.names = FALSE)
  
  # Print the modified data
  print(formatted_data_MS)

  
 
  
  #### Combined bar chart for HC and MS [x-axis: HLA DR types, y-axis: numbr of individuals have the variants] ####
  
  # Set the directory containing the modified CSV files
  directory <- "/Users/wanqian/argonFiles/HLA_HC_CSV"
  directory1 <-"/Users/wanqian/argonFiles/HLA_MS_CSV"
  # Get the list of modified HC and MS CSV files in the directory
  hc_files <- list.files(directory, pattern = "HC.*_modified.csv$", full.names = TRUE)
  ms_files <- list.files(directory1, pattern = "MS.*_modified.csv$", full.names = TRUE)
  
  # Function to process the modified files
  process_files <- function(files) {
    # Create an empty list to store the counts for each variable
    variable_counts <- list()
    
    # Loop through the files
    for (file in files) {
      # Read the modified CSV file
      modified_file <- read.csv(file, stringsAsFactors = FALSE)
      
      # Remove rows with NA values
      modified_file <- modified_file[complete.cases(modified_file), ]
      
      # Get the unique variables in the modified file
      unique_variables <- unique(modified_file$`HLA.DR.type`)
      
      # Update the counts for each variable
      for (variable in unique_variables) {
        if (variable %in% names(variable_counts)) {
          variable_counts[[variable]] <- variable_counts[[variable]] + 1
        } else {
          variable_counts[[variable]] <- 1
        }
      }
    }
    
    # Convert the variable counts to a data frame
    counts_df <- data.frame(Variable = names(variable_counts), Count = unlist(variable_counts))
    
    # Return the counts data frame
    return(counts_df)
  }
  
  # Process HC and MS files separately
  hc_counts <- process_files(hc_files)
  ms_counts <- process_files(ms_files)
  
  # Combine HC and MS counts data frames
  combined_counts <- rbind(hc_counts, ms_counts)
  combined_counts$File_Type <- rep(c("HC", "MS"), c(nrow(hc_counts), nrow(ms_counts)))
  
  # Plot the bar chart with side-by-side bars
  bar_plot <- ggplot(combined_counts, aes(x = Variable, y = Count, fill = File_Type)) +
    geom_bar(stat = "identity", position = "dodge") +
    labs(title = "Count of Variables in HC and MS", x = "Variable", y = "Count") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  bar_plot