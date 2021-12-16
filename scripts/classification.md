##### Classification using Decision Trees
Classification will be done using the `rpart` package. Stands for Recursive Partitioning. The syntax for creating a model is as follows:

* `m <- rpart(predictor ~ input1 + input2, data = data, method='class')`

The model for creating the functionality predictor is 

* `model <- rpart(functionality~., data = subset_training[1:14],method="class",control = rpart.control(cp = 0))`.


* functionality - Target variable
* . - means select all the variables in the data frame
* subset_training[1:14] - specifies the dataframe
* method="class" - for classification. "anova" is for regression.
* cp(complexity factor) - (optional) - `rpart.control(cp=0)` it controls the tree growth. It's used to control the size of the decision tree. To select the optimal size of the tree.

After creating a model,  you predict the class values. the syntax for predicton is 
`predict(model, test_data, type="class")`
