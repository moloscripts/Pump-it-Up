# year: 2019
# author: Molo Muli
# contact: molo.andrew@gmail.com
# title: Prediciting Faultiness of Water Pumps in Tanzania. A competition hosted by DrivenData.org.
# More info on this competition can be found here https://www.drivendata.org/competitions/7/pump-it-up-data-mining-the-water-table/page/23/.

# libraries

library(tidyverse)
library(DataExplorer)
library(skimr)
library(funModeling)
library(inspectdf)
library(corrplot)
library(forcats)
library(lubridate)
library(dlookr)
library(lsr)
library(ca)
library(FactoMineR)
library(ClustOfVar)
library(nnet)9
library(boot)
library(car)
options(scipen=999)

# training, testing and status_group data.
training_set <- read.csv("data/training_set_values.csv" , stringsAsFactors = F, na.strings=c(""," ","NA"))
ity_status_id <- read.csv("data/id_ity_status_training.csv", na.strings=c(""," ","NA"))
testing_set <- read.csv("data/testing_set.csv", stringsAsFactors = F, na.strings=c(""," ","NA"))

# dimensions of the data
dim(training_set)
dim(ity_status_id)
dim(testing_set)

# Double check if there're any duplicates in the unique id values
duplicated(training_set$id)
duplicated(ity_status_id$id)
n_occur_training <- data.frame(table(training_set$id))
n_occur_ity_id <- data.frame(table(training_set$id))

# Merge training data functionality status id dataframes
training <- merge(training_set, functionality_status_id, by.x = "id", by.y = "id", all.x =TRUE)
su
# check for missing values in the target column, after merging.
sum(is.na(training$status_group)) 

# summary stats
glimpse(training)
summary(training)

skim(training)
training %>%
  dplyr::group_by(status_group) %>%
  skim()
plot_str(training)

### Data Munging
nums <- unlist(lapply(training, is.numeric))
numeric_df <- training[ ,nums] 
training[training == 0] <- NA
training %>%
  filter(construction_year > 2010) %>%
  ggplot(aes(construction_year)) + geom_histogram()

# check for missing values in training set
sapply(training, function(x) sum(is.na(x)))
plot_missing(training)  # Scheme Name contains the most missing values

# Subsetting both training and testing data
subset_training <- training %>%
  select(basin,region,population, construction_year, scheme_management, permit, public_meeting, 
         extraction_type_class,management_group,payment_type, quality_group,waterpoint_type_group,source_type, source_class, waterpoint_type_group,status_group) %>%
  na.omit()

# Convert some columns to factors
to_factor <- c("region", "basin","extraction_type_class", "management_group", "payment_type", "quality_group", "scheme_management", "permit",
               "public_meeting","waterpoint_type_group", "source_type", "source_class", "waterpoint_type_group","status_group")
for(col in to_factor){
  subset_training[[col]] <- as.factor(as.character(subset_training[[col]]))
}

# Testing Subset
subset_testing <- testing_set %>%
  select(basin,region,population, construction_year, scheme_management, permit, public_meeting, 
         extraction_type_class,management_group,payment_type, quality_group,waterpoint_type_group,source_type, source_class, waterpoint_type_group) %>%
  na.omit()
# subset_testing$construction_year <- as.factor(as.numeric(subset_testing$construction_year))


# Inspect DF
str(subset_training)
skim(subset_training)
plot_missing(subset_training) # shows the % of N/A's
inspect_na(subset_training, show_plot = T) # shows the count of N/A's
inspect_cat(subset_training) %>%
  show_plot()

df_status(subset_training) # summary of the dataset using funModeling
diagnose_outlier(subset_training) # Outlier information of Numeric Variables

inspect_types(TzWaterPoints) %>%
  show_plot()

### Exploratory Data ANALYSIS
profiling_num(subset_training)

# Multiple Correspondence Analysis
mca <- MCA(st_factor, graph = F)
summary(mca)
plot(mca, invisible = c("ind"), habillage = "quali")
st_subset <- st_factor %>% 
  select(- c(scheme_management, basin, management_group, permit))
mca_II <- MCA(st_subset, graph = F)   
plot(mca_II, invisible = c("ind"), habillage = "quali")

st_test <- st_factor %>% 
  select(status_group,construction_year,quality_group) 
mca <- MCA(st_test,graph = F)
plot(mca, invisible = c("ind"), habillage = "quali")

sourcetype <- table(subset_training$source_type, subset_training$status_group)
plot(ca(sourcetype))
extraction_type <- table(subset_training$extraction_type_class, subset_training$status_group)
plot(ca(extraction_type))


# Select only Factors/Categorical Variables & plot dendrogram
factors <- unlist(lapply(subset_training, is.factor))
st_factor <- subset_training[ ,factors] 
str(st_factor)
factor_tree <- hclustvar(X.quali = st_factor)
plot(factor_tree)

str(subset_training)

# Histogram of the Distribution of the Construction Year
ggplot(subset_training, aes(construction_year)) + geom_density(alpha=0.2, fill="#FF6666")

ggplot(subset_training, aes(status_group,construction_year)) + 
  geom_boxplot(notch = TRUE, notchwidth = 0.5, outlier.color = "red", show.legend = TRUE) + geom_text(stat = "identity")

# Functionality Status per region
f_status <- table(subset_training$region, subset_training$status_group)
ggplot(subset_training, aes(region, fill=status_group)) + 
  geom_bar(position = "fill") + ylab("proportion") + coord_flip() +
  geom_text(stat = 'count', hjust = 0, position = position_fill(0.5), aes(x = region, label = stat(count))) +
  scale_fill_manual(values = c("green","yellow","red")) 

# chi-square test on two variables
chisq.test(subset_training$region, subset_training$status_group, correct = F)
cramersV(subset_training$region, subset_training$status_group)
plot(ca(f_status))

set.seed(1234)







