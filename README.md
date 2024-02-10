# TRAFFIC ANALYSIS ALONG M1

This report aims to investigate the speed on the M1 highway. The report will cover the data gathered, sampling strategy, and statistical analysis. All analysis and visualisation were done using R programming language.

# DATA COLLECTION AND PREPROCESSING
Data on the M1's average speed was gathered from www.trafficengland.com, Traffic England's official website. The data was collected over three weeks, from March 3 to April 19, 2023. The data was collected randomly by taking snapshots from the traffic website and converting them to csv. The information gathered includes the time and day the data was recorded, the average speed of the traffic in miles per hour (mph), the junction names, Direction descriptions, Downstream/Upstream links and speed limits on various roads.

The data, consisting of 1512 entries and 330 columns, was prepared for analysis by selecting the relevant columns needed for the analysis and then replacing null values on some rows using the mean imputation to avoid data loss. This reduced the dimension of the new data frame to 1458 entries and 27 columns.

# SAMPLING STRATEGY
Stratified Random Sampling was the preferred sampling technique. When a population exhibits heterogeneity that can be classified using further details, a probability sampling design known as stratified random sampling is more appropriate because it involves stratifying the population to improve estimation precision. The primary benefit of stratified sampling is its capacity to deliver more accurate results than other sampling techniques, even with smaller sample sizes, by segmenting a vast population into many subgroups or strata that align with our demands.

The M1 motorway was split into three strata in this study based on geographical location: south (J1-J9), central (J10-J32), and north (J33-J48). A random sample of 100 observations was collected from each stratum. As a result, the total sample size was 300 observations. This sample represented an even distribution of distinction features in the 27 columns of the data frame name “Stratified_data”. A new column was added during the stratification process to distinguish the geographical regions based on the junctions, and these regions were tagged South, Central and North.

# ANALYSIS OF FINDINGS
The analysis will be based on getting insight into the geographical locations with the highest average speed and congestion levels for days of the week and time of the day. The data frame below shows the sample average speed level summary statistics on geographical location and day. This analysis will be done by independently investigating each stratum and comparing them afterwards to find the days and times that will be the fastest travel on the M1 road.

![](https://github.com/odogwu25/Traffic-Analysis/blob/main/images/summary%20stat.png)




