#### Pump It Up: Datamining the Water Table

##### Resources
* [DrivenData Competition](https://www.drivendata.org/competitions/7/pump-it-up-data-mining-the-water-table/page/23/)
* [DrivenData Community](https://community.drivendata.org/)
* [Project Board](https://github.com/users/moloscripts/projects/1)
* [Fundamentals of DataViz](https://serialmentor.com/dataviz/directory-of-visualizations.html)
* [DataScience Live Book](https://livebook.datascienceheroes.com/exploratory-data-analysis.html#final-thoughts)
* [Association](https://stackoverflow.com/questions/52554336/plot-the-equivalent-of-correlation-matrix-for-factors-categorical-data-and-mi)

##### Summary Statistics
* subset_training has **59,400** observations and 18 variables
* testing_set has **14,850** observations and 40 variables
* using `Data Explorer` package, `plot_missing(subset_training)` shows that **population (integer)** column is the highest with missing values. 35%. Followed by **construction year** (34.86%) and **scheme management** (6.53%). We need to take to account these columns as when creating the ML Model, rows with missing values are automatically removed. Might affect the model.
* Using `inspectDF` package, `inspect_na(subset_training)` shows the actual count of the missing values in the columns. **Population=21,381**, **construction year=20,709**  
* Variable composition is as follows. Factors are **13**, integer=3, character=2. Done using `inspect_types(subset_training)` found in `inspectDF` package.

##### Variable Composition in the DF
* ![variable composition](/Users/Molo/Dropbox/Projects/Code/Machine-Learning/Pump-it-Up/inspect_vars.png)
* since there are many factors, we'll have to use `forcats` to analyse them and maybe check for high **cardinality** for dimenisionality reduction.

##### Checking the most common value in all the characters and factors
* ![variable composition](/Users/Molo/Dropbox/Projects/Code/Machine-Learning/Pump-it-Up/inspectCat.png)


##### Data Analysis
* Univariate Analysis of single categorical variables. 
* Correspondence analysis of contigency tables.
* Categorical Analysis using forcats

#### Univariate Analysis
still  in `Hmisc` package, `profiling_num(subset_training)` produces a descriptive analysis of all numerical data
Density plot represents shape of the histogram but using a smooth plot.
In the upper '75', most population lies around 5- 10 thousand


#### Categorical Data Analysis
* Lindi, Mtwara, Rukwa and Tabora Have the highest number of non-functional water points. Whereas Iringa, Arusha have the most functional points.
* Most of the extraction type is gravity, followed by tanira..
* Integer data types represent discrete counts whereas numeric represent continous variables.
* Gravity as an extraction type contributes to the highest both functional and non-functionality status.
* Identify Outliers in R Tukey's Method for ID Outliers.

* ![Dendrogram for Clustering](/Users/Molo/Dropbox/Projects/Code/Machine-Learning/Pump-it-Up/dendrogram.png)

Branches of the same height means that  they're similar to each other. Braches with different heights tend to be disimmilar to each other. In this case status group is much similar to the year of construction, followed by region, and the water quality group


##### Simple Correspondece Analysis
* Wind-Powered and Motor Pump are the most non-functional WaterPoints.
* Shallow Wells are the most non-functional

##### Machine Learning


