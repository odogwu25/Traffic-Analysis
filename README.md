# TRAFFIC ANALYSIS ALONG M1

This report aims to investigate the speed on the M1 highway. The report will cover the data gathered, sampling strategy, and statistical analysis. All analysis and visualisation were done using R programming language.

### DATA COLLECTION AND PREPROCESSING
Data on the M1's average speed was gathered from www.trafficengland.com, Traffic England's official website. The data was collected over three weeks, from March 3 to April 19, 2023. The data was collected randomly by taking snapshots from the traffic website and converting them to csv. The information gathered includes the time and day the data was recorded, the average speed of the traffic in miles per hour (mph), the junction names, Direction descriptions, Downstream/Upstream links and speed limits on various roads.

The data, consisting of 1512 entries and 330 columns, was prepared for analysis by selecting the relevant columns needed for the analysis and then replacing null values on some rows using the mean imputation to avoid data loss. This reduced the dimension of the new data frame to 1458 entries and 27 columns.

## SAMPLING STRATEGY
Stratified Random Sampling was the preferred sampling technique. When a population exhibits heterogeneity that can be classified using further details, a probability sampling design known as stratified random sampling is more appropriate because it involves stratifying the population to improve estimation precision. The primary benefit of stratified sampling is its capacity to deliver more accurate results than other sampling techniques, even with smaller sample sizes, by segmenting a vast population into many subgroups or strata that align with our demands.

The M1 motorway was split into three strata in this study based on geographical location: south (J1-J9), central (J10-J32), and north (J33-J48). A random sample of 100 observations was collected from each stratum. As a result, the total sample size was 300 observations. This sample represented an even distribution of distinction features in the 27 columns of the data frame name “Stratified_data”. A new column was added during the stratification process to distinguish the geographical regions based on the junctions, and these regions were tagged South, Central and North.

## ANALYSIS OF FINDINGS
The analysis will be based on getting insight into the geographical locations with the highest average speed and congestion levels for days of the week and time of the day. The data frame below shows the sample average speed level summary statistics on geographical location and day. This analysis will be done by independently investigating each stratum and comparing them afterwards to find the days and times that will be the fastest travel on the M1 road.

![](https://github.com/odogwu25/Traffic-Analysis/blob/main/images/summary%20stat.png)


# A. Northbound (NB):
The data frame  below shows the summary statistics of the speed level on the M1 Northbound (NB) which was partitioned into Section A, B and C. The descriptive statistics are the mean, median, mode and standard deviation.

![](https://github.com/odogwu25/Traffic-Analysis/blob/main/images/NB%20dataframe.png)

**Section A (J1 – J9):** The best days to travel between J1 and J9 are Saturdays (65.0 mph), Mondays (63.5 mph), and Wednesdays (62.8 mph). The frequency of these average speeds on these days is shown by the modes of 70, 63.3, and 56.5, respectively. The speed levels are relatively near to the average, which suggests little variance in speed levels on these days, with standard deviations of 8.3, 4.9, and 4.3, respectively. Therefore, the management can be confident that there won't be any surprises regarding traffic flow these days.

**Section B (J10 – 32):** The top three average speeds between J10 and J32 along NB are on Saturdays (63.9 mph), Tuesdays (62.1 mph), and Fridays (61.7 mph). The 66.1, 70, and 62.6 modes show how frequently these average speeds are reached. As evidenced by their relative standard deviations of 4.4, 6.2, and 3.1, the diversity in speed levels is spread throughout the average in a slightly varied range.

**Section C (J33 – 48):** In section C (between J33 and J48), the average speed is highest on Saturdays (67.04 mph), Tuesdays (65.7 mph), and Mondays (65.1 mph). The mode of 70, 70 and 70 represents how frequently these averages occur on these days, respectively. With a standard deviation of 3.6, 4.4 and 5.9, respectively, it indicates the speed levels are very close to the average, which shows little variation in speed levels on these days. So, the management can be certain that there will be no surprises as regards the traffic flow in the NB direction on Saturdays, Tuesdays, and Mondays.

# B. Southbound(SB):
![](https://github.com/odogwu25/Traffic-Analysis/blob/main/images/Southbound%20dataframe.png)

**Section A (J1 – J9):** Tuesdays, Saturdays, and Thursdays are the fastest days to travel between J1 and J9 via SB (62.9 mph, 62.3 mph, and 62.2 mph, respectively). The modes of 62.9, 70, and 58.8, respectively, show the frequency of these average speeds on these days. The speed levels are reasonably close to the average, with standard deviations of 3.8, 8.4, and 4.5, respectively, indicating little variation in speed levels on these days. As a result, the management may be sure that the traffic flow on certain days won't be a surprise.

**Section B (J10 – 32):** The top three average mph between J10 and J32 are 65.3 mph on Saturdays, 62.0 mph on Fridays, and 60.4 mph on Mondays. The 64.7, 57.8, and 57.9 modes illustrate how frequently these average speeds are attained. The diversity in speed levels is distributed throughout the average in a significantly different range, as shown by their respective relative standard deviations of 4.9, 2.5, and 5.9.

**Section C (J33 – 48):** The average speed is highest on Saturdays (65.4 mph), Tuesdays (65.3 mph), and Wednesdays (63.8 mph) in section C (between J33 and J48). The frequency of these averages on these days is shown by the modes of 70, 70, and 60.2. The speed levels are quite near to the average, which implies little variance in speed levels on these days, with standard deviations of 6.0, 3.7, and 3.5, respectively. Therefore, the management can be confident that there won't be any surprises about the traffic flow in the SB direction on Saturdays, Tuesdays, and Wednesdays.


# Comparing Congestion level Between the Southbound and Northbound
The box plots below show the congestion level based on different sections in northbound and Southbound. The red, blue, and green colours represent high, medium, and low levels.

![](https://github.com/odogwu25/Traffic-Analysis/blob/main/images/NB%20boxplot.png)

![](https://github.com/odogwu25/Traffic-Analysis/blob/main/images/SB%20boxplot.png)
Congestion levels in SB section J10 – J32 seem higher than anywhere else. NB sections have low congestion levels in all sections, with J1 - J10 having the highest average speeds on both bounds.

# How Does Time Affect the Average Speed?
The line graphs below show the relationship between time intervals and average speed for both NB and SB. Average speed in the NB sections reduces at 12:00 and 13:00 between J1 and J9 but remains steady at other times. Congestion is predicted in the SB sections between J1 and J9 at 4:00 and 15:00.
