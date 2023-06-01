#Setting the working directory
setwd("/Users/Odogwu/Desktop/STA PROGRAMMING/STA ASIGNMENT/sliced data")
num1<- read.csv("sliced1.csv", header = TRUE)
#adding days and time
# repeat the day of the week for 54 rows
days <- rep(c("Wednesday"), length.out = 54)
num1$day <- days
# generating a sequence of times for 54 rows,
num1$time <- rep("10:08:00", nrow(num1))
#switching the columns
num1 <- num1[, c(ncol(num1) - 1, ncol(num1), 1:(ncol(num1) - 2))]
#View(num1)
#saving the data
write.csv(num1, file = paste('/Users/Odogwu/Desktop/STA PROGRAMMING/STA ASIGNMENT/new sliced', "/sliced27.csv", sep = ""), row.names = FALSE)

#Binding the data together
setwd("/Users/Odogwu/Desktop/STA PROGRAMMING/STA ASIGNMENT/new sliced") # getting a list of the CSV files in the folder
file_list <- list.files(pattern = "*.csv")
# initializing an empty data frame to store the combined data
# Create an empty data frame to store the combined data
combined_data <- data.frame()

# Iterate over the file list
for (file in file_list) {
  file_path <- paste(getwd(), "/", file, sep = "")
  
  # Check if the file exists before reading
  if (file.exists(file_path)) {
    temp_data <- read.csv(file_path, header = TRUE)
    
    # Append the temporary data to the combined data frame
    combined_data <- rbind(combined_data, temp_data)
    
    # Print a message to indicate successful reading
    cat("File", file, "read and appended.\n")
  } else {
    # Print an error message if the file does not exist
    cat("File", file, "does not exist.\n")
  }
}

# viewing the combined data 
View(combined_data)
#FILLING ROWS WITH MISSING DATA library(dplyr)
# mean imputation using dplyr 
library(dplyr)
Traffic_data <- combined_data %>%
mutate(across(everything(), ~ifelse(is.na(.), mean(., na.rm = TRUE), .))) #Dimension of preprocessed data
dim(Traffic_data)
#Verifying there is no missing data
is.na(Traffic_data)
#saving the processed data
write.csv(Traffic_data, file = paste('/Users/Odogwu/Desktop/STA PROGRAMMING/STA ASIGNMENT/new sliced', "/Traffic_data.csv", sep = ""), row.names = FALSE)



                                      #NORTH BOUND


#STSRATIFY SAMPLING
setwd("/Users/Odogwu/Desktop/STA PROGRAMMING/STA ASIGNMENT/new sliced")
Traffic_data2<- read.csv("Traffic_data.csv", header = TRUE)
#Creating a new column that specifies the geographical location of each observation based on the junctionName column
Traffic_data2$Sections <- ifelse(Traffic_data2$junctionName %in% c("J1", "J2", "J3", "J4", "J5", "J6", "J7", "J8", "J9"), "SECTION A",
                                 ifelse(Traffic_data2$junctionName %in% c("J10", "J11", "J12", "J13", "J14", "J15", "J16", "J17", "J32"), "SECTION B", "SECTION C"))
#install.packages("rsample")
library(rsample)
# Defining the strata based on sections and days of the week

strata <- interaction(Traffic_data2$Sections, Traffic_data2$day) # Stratify the data using the defined strata
stratified_data <- Traffic_data2 %>%
  group_by(Sections) %>%
  slice_sample(n = 100, replace = TRUE) %>% ungroup()

#Renaming average speed column
stratified_data <- stratified_data %>% rename(NB_speed = primaryDownstreamJunctionSection.avgSpeed)

#checking for missing data
missing_both <- subset(stratified_data, !complete.cases(stratified_data[c("Sections", "day")]))
nrow(missing_both)

#SUMMARY MEAN SPEED BY Sections & day
traffic_summary5 <- stratified_data %>%
  group_by(Sections, day) %>%
  summarise(mean_speed = mean(NB_speed, na.rm = TRUE)) 
View(traffic_summary5)

#SUMMARY MEAN SPEED BY Sections, day & Time 
traffic_summary6 <- stratified_data %>%
group_by(Sections, day, time) %>%
  summarise(mean_speedn = mean(NB_speed, na.rm = TRUE))
View(traffic_summary6)

# Calculating the mean, median, mode, and standard deviation of speed for each Sections 
summary_stats <- aggregate(NB_speed ~ Sections + day, stratified_data, function(x)
c(mean = mean(x), median = median(x), mode = names(sort(table(x), decreasing = TRUE)[1]), sd = sd(x)))
View(summary_stats)

#Highest speed by day and Sections
highest_speed <- traffic_summary6 %>%
  group_by(Sections, day) %>%
  summarise(max_speed = max(mean_speedn),
            max_speed_day = day[which.max(mean_speedn)]) %>%
  arrange(desc(max_speed))
View(highest_speed)

#MIN SPEED
#Highest speed by day and Sections 
lowest_speed <- traffic_summary6 %>%
group_by(Sections, day, time) %>% summarise(min_speed = min(mean_speedn),
                                            min_speed_day = day[which.min(mean_speedn)]) %>% arrange(desc(min_speed))
View(lowest_speed)

#SUMMARY HIGHEST SPEED BY Sections, day & Time 
Highest_speed_Time <- stratified_data %>%
group_by(Sections, day, time) %>%
  summarise(max_speed = max(NB_speed, na.rm = TRUE)) %>% group_by(Sections, day) %>%
  slice(which.max(max_speed)) %>%
  select(Sections, day, time, max_speed)
View(Highest_speed_Time)

#CONGESTION
library(dplyr)

# Creating a new column for congestion level 
Traffic_data3 <- stratified_data %>%
mutate(congestion_level = case_when( NB_speed < 20 ~ "high",
                                     NB_speed < 50 ~ "medium",
                                     
                                     TRUE ~ "low" ))
View(Traffic_data3)

#Boxplot
library(ggplot2)
ggplot(Traffic_data3, aes(x = Sections, y = NB_speed, color = congestion_level)) +
  geom_boxplot() +
  labs(x = "Congestion Level", y = "Average Speed", color = "Sections") + ggtitle("Distribution of Northbound average speed by congestion level and Sections")

# creating a line plot
traffic_summary6$time <- as.POSIXct(traffic_summary6$time, format = "%H:%M:%S")
ggplot(data = traffic_summary6, aes(x = time, y = mean_speedn, group = Sections, color = Sections)) +
  geom_line() +
  labs(title = "NorthBound Average Speed by Time and Sections", x = "Time", y = "Average Speed") + theme_minimal()

#heat maps
library(reshape2)
# Calculate mean speed by Sections and time
traffic_summary9 <- aggregate(NB_speed ~ Sections + day, Traffic_data3, mean)
# Reshape data into wide format
traffic_summary_wide <- dcast(traffic_summary9, Sections ~ day, value.var = "NB_speed") # Plot heatmap
ggplot(melt(traffic_summary_wide), aes(x = variable, y = Sections, fill = value)) +
  geom_tile() +
  scale_fill_gradient(low = "#FF0000", high = "#00FF00") +
  labs(x = "Days of the week", y = "Sections", title = "NorthBound Mean Speed by Sections and Day") + theme_minimal()





                                    #SOUTH BOUND


#Renaming SB average speed column
stratified_data2 <- stratified_data %>% rename(SB_speed = secondaryDownstreamJunctionSection.avgSpeed)
View(stratified_data2)

#checking for missing data
missing_both <- subset(stratified_data2, !complete.cases(stratified_data2[c("Sections", "day")])) 
nrow(missing_both)

#SUMMARY MEAN SPEED BY Sections & day
SB_mean <- stratified_data2 %>%
  group_by(Sections, day) %>%
  summarise(mean_speed2 = mean(SB_speed, na.rm = TRUE)) 
View(SB_mean)

#SUMMARY MEAN SPEED BY Sections, day & Time 
SB_time_sum <- stratified_data2 %>%
group_by(Sections, day, time) %>%
  summarise(mean_speed2 = mean(SB_speed, na.rm = TRUE))
View(SB_time_sum)

# Calculating the mean, median, mode, and standard deviation of speed for each Sections 
SB_summary_stats <- aggregate(SB_speed ~ Sections + day, stratified_data2, function(x)
c(mean = mean(x), median = median(x), mode = names(sort(table(x), decreasing = TRUE)[1]), sd = sd(x)))
View(SB_summary_stats)

#Highest speed by day and Sections 
SB_highest_speed <- SB_time_sum %>%
group_by(Sections, day) %>% summarise(max_speed = max(mean_speed2),
                                      max_speed_day = day[which.max(mean_speed2)]) %>% arrange(desc(max_speed))
View(SB_highest_speed)

#MIN SPEED
sb_lowest_speed <- SB_time_sum %>%
group_by(Sections, day, time) %>% summarise(min_speed = min(mean_speed2),
                                            min_speed_day = day[which.min(mean_speed2)]) %>% arrange(desc(min_speed))
View(sb_lowest_speed)

#SUMMARY HIGHEST SPEED BY Sections, day & Time 
Highest_speed_Time <- stratified_data %>%
group_by(Sections, day, time) %>%
  summarise(max_speed = max(NB_speed, na.rm = TRUE)) %>% group_by(Sections, day) %>%
  slice(which.max(max_speed)) %>%
  select(Sections, day, time, max_speed)
View(Highest_speed_Time)

#CONGESTION
# Creating a new column for congestion level 
Sb_congestion <- stratified_data2 %>%
mutate(congestion_level = case_when( SB_speed < 20 ~ "high",
                                     SB_speed < 50 ~ "medium",
                                     TRUE ~ "low"
))
View(Sb_congestion)

# creating a line plot
SB_time_sum$time <- as.POSIXct(SB_time_sum$time, format = "%H:%M:%S")
ggplot(data = SB_time_sum, aes(x = time, y = mean_speed2, group = Sections, color = Sections)) +
  geom_line() +
  
  labs(title = "SouthBound Average Speed by Time and Sections", x = "Time", y = "Average Speed") +
  theme_minimal()

#heat maps for SB
# Calculating mean speed by Sections and time
SB_heat <- aggregate(NB_speed ~ Sections + day, Traffic_data3, mean)

# Reshaping the data into wide format
SB_summary_wide <- dcast(SB_mean, Sections ~ day, value.var = "mean_speed2") # Plot heatmap
ggplot(melt(SB_summary_wide), aes(x = variable, y = Sections, fill = value)) +
  geom_tile() +
  scale_fill_gradient(low = "#FF0000", high = "#00FF00") +
  labs(x = "Days of the week", y = "Sections", title = "Southbound Mean Speed by Sections and Day") + theme_minimal()
