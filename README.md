# 0701_Political Affiliation: Understanding Independent Voters 
## Stage 1: To what degree are simple demographics enough to predict political party affiliation?  Examination using Multinomial Logistic Regression.  
`This project explores political party affiliation based on various demographic and socioeconomic factors.  The pipeline includes data ingestion, cleaning, and multiple predictive modeling approaches in R, SQL, EXCEL and WEKA.  As per my perpetual problem, I am redoing the original analysis a good bit and entering it as I go.. i.e. the documentation is not finished yet! This README includes the following information to recreate each part of the analysis.  Any suggestions, comments, discussions, or critiques are welcome! ` 

## OVERVIEW ##
This study stems from the desire to better understand how Democrat, Independent, and Republican voters differ in both their socioeconomic circumstances and their views/beliefs.  
- In STAGE 1, I use Multinomial Logistic Regression to look determine the utility of using sociodemographic variables for predicting political party affiliation.
- In STAGE 2, k-NN and Random Forest analyses are used to examine if independent voters are closer to democrats or republicans on several beliefs.
- In STAGE 3, cluster analysis was used to see how clustering groups voters and if there are insights that can be gained. 


## DATA DESCRIPTION  ##
The Pulse of the Nation dataset from September, October, and November 2017 captures monthly public opinion on politics and social issues among nationally sampled U.S. adults, collected as part of a year‑long polling project funded by Cards Against Humanity. Across these three months, respondents report demographic information such as age, income, education, and political party affiliation, along with their views on Donald Trump’s job performance and broader scientific, social, and cultural topics. The data are individual‑level, with each row representing a survey respondent and each column representing a specific question or characteristic, allowing for rich multivariate analysis of political attitudes over time.

Beyond core political questions, the surveys in these months mix serious and lighthearted items, including beliefs about climate change, perceptions of scientists’ honesty, attitudes toward vaccines, expectations about job automation, pop‑culture preferences (such as number of Transformers movies watched), and beliefs in ghosts. This blend of variables makes the dataset especially useful for exploring how demographic traits and unconventional attitudes relate to political affiliation and presidential approval across the early Trump administration, while also enabling comparison of response patterns from September through November 2017 to study short‑term shifts in public sentiment.  

### The RAW datafiles for September, October & November 2017 are provided below. ###
- [September 2017 data](data/201709-CAH_PulseOfTheNation.csv)
- [October 2017 data](data/201710-CAH_PulseOfTheNation.csv)
- [November 2017 data](data/201711-CAH_PulseOfTheNation.csv)

Demographic questionaire items are similar for each month of the study, however social questionaire items differ from month to month.  A full list of the three questionaire items is provided here: -[Pulse of the Nation Questionaire Items](/Questionaire_PulseOfNation_all.docx).  For Further Information regarding the Pulse Of The Nation study at [PulseOfTheNation.com](https://thepulseofthenation.com/) 

## STAGE 1: DATA CLEANING / PREPROCESSING ##
The first step to this analysis was create a dataframe containing only variables common to all three datasets: AGE, INCOME, EDUCATIONAL LEVEL, RACE, SEX, and POLITICAL PARTY AFFILIATION.  I used EXCEL to first omit the variables which were not required for the analysis, and then join all of the observations into one large dataframe totaling n = 1615 instances.  Unfortunately the INCOME attribute contained 344 missing cases.  Using WEKA, I imputed missing values using the k-NN Imputation Filte - [INFO: k-NN Imputation Filter description](/INFO_WEKA_Imputation_Filter.docx)  

The second step to this analysis was to identify outliers.  WEKA was used to identify and remove outliers using the Interquartile Range filter, and RemoveValues filter respectively. Eighty-two instances were removed, leaving n = 1517 instances for analysis. The .csv for this dataframe is provided here: - [Stage 1: Logistic Regression Data](/logistic_5_nooutliers.csv).  At this point that dataframe was imported into MySQL Workbench and the variables were recoded into more general categories. The results are shown in the DESCRIPTIVE UNIVARIATE ANALYSIS below. 


## STAGE 1a: DESCRIPTIVE UNIVARIATE ANALYSIS ##
Logistic regression makes no assumptions regarding normality for its independent variables.  Nontheless, the distributions are provided here to help better understand the data.  In the event that error estimate appear inflated, we can come back and transform them and compare the AIC measures of the raw & tranformed variables after conducting the logistic regression. To create the following charts, utilize the attached file - [Descriptive Univariate Analysis R-script](/descriptives_allVariables_logisticRegression.R)

<table align="center">
<tr>
<td align="center">
  <b>Income: Raw</b><br>
  <img src="https://github.com/user-attachments/assets/80f04b29-afe4-4d51-894b-8ce96ad1a48d" 
       alt="Income Raw"
       style="border: 3px solid #333; border-radius: 8px; padding: 4px;" 
       width="350" height="438" />
</td>
<td align="center">
  <b>Age: Raw</b><br>
  <img src="https://github.com/user-attachments/assets/a929d327-ef0e-46d7-b6c5-672048261f3e"
       alt="Age Raw" 
       style="border: 3px solid #333; border-radius: 8px; padding: 4px;" 
       width="350" height="438" />
</td>
</tr>
</table>


The categorical variables below were each collapsed, and the tables below show the frequencies PRIOR & AFTER Ccollapse.  The coding to collapse categories was completed in SQLWorkbench using data in the file, - [Election_Logistic_recode](/Election_Logistic_recode.sql), and saved as the file, -[Election_Research_2](/Election_Research_2.csv) ZZ.  The visualization was conducted in RStudio using the file -   
 [Descriptive Univariate Analysis R-script](/descriptives_allVariables_logisticRegression.R) _NOTE:_ to use this file to create the visualizations of PRE and AFTER frequecies you must alter the 'df <-data.file() in LINE 3 by replacing the dataset _Logistic_5_nooutliers_ with the dataset _Election_Research_2_. 
## _PRIOR TO COLLAPSING CATEGORIES_
### RAW FREQUENCIES of Gender, Educational Level, Race and Political Affiliation
<table align="center" style="width:100%; border-spacing: 20px;"> <!-- creates & center table -->
<tr> <!-- defines 1 table row -->
<td align="center" valign="top" style="padding: 10px;"> <!-- table data cell -->
<img width="281" height="241" alt="Gender" src="https://github.com/user-attachments/assets/e682a6ee-33dd-4844-bf5b-43bd5fde486d" />
</td>
<td align="center" valign="top" style="padding: 10px;">
<img width="282" height="503" alt="Age" src="https://github.com/user-attachments/assets/719dcef8-f46d-4881-ad76-28d534e9f5a6" />
</td>
<td align="center" valign="top" style="padding: 10px;">
<img width="292" height="310" alt="Education" src="https://github.com/user-attachments/assets/4e0f6f27-49c2-4a09-93b9-bbcfbdc35bb0" />
</td>
<td align="center" valign="top" style="padding: 10px;">
<img width="298" height="483" alt="Political Affiliation" src="https://github.com/user-attachments/assets/5c0d1ced-764a-4427-8446-d69305bac19b" />
</td>
</tr>
</table>
</div>

## _AFTER COLLAPSING CATEGORIES_
### RECODED VARIABLES: Gender, Educational Level, Race and Political Affiliation
NOTES - {Gender: Male = 0, Female = 1}, {Education Level: Other type of Training = 1, < High School Degree = 2, High School Degree = 3, Some College = 4, College Degree = 5, Graduate Degree = 6}
<table align="center" style="width:100%; border-spacing: 20px;"> <!-- creates & center table -->
<tr> <!-- defines 1 table row -->
<td align="center" valign="top" style="padding: 10px;"> <!-- table data cell -->
<img width="281" height="241" alt="Gender" src="https://github.com/user-attachments/assets/877b69e8-99b8-406d-9083-bf96394b3a7c" />
</td>
<td align="center" valign="top" style="padding: 10px;">
<img width="282" height="503" alt="Age" src="https://github.com/user-attachments/assets/1b669f25-b688-476c-bd21-ab5a00ecaf7d" />
</td>
<td align="center" valign="top" style="padding: 10px;">
<img width="292" height="310" alt="Education" src="https://github.com/user-attachments/assets/63e666e4-db99-4c4f-85c8-51adfbca5dbd" />
</td>
<td align="center" valign="top" style="padding: 10px;">
<img width="298" height="483" alt="Political Affiliation" src="https://github.com/user-attachments/assets/2967f49c-692e-4d6e-9281-56ed1456ec61" />
</td>
</tr>
</table>
</div>

<p align="center" style="bold">
  THE FOLLOWING CHARTS show the bar charts for the final collapsed data (Gender, Age, Education, & Political Party)
  (Click the chart to enlarge)
</p>

<table align="center" style="width:100%; border-spacing: 20px;">
<tr>
<td align="center"><img src="https://github.com/user-attachments/assets/07d05357-ff05-4479-9c1d-6ffc12a96dee" width="22%" alt="image 1"/></td>
<td align="center"><img src="https://github.com/user-attachments/assets/1a28e10d-5034-4519-bb53-98041c82e2cb" width="22%" alt="image 2"/></td>
<td align="center"><img src="https://github.com/user-attachments/assets/68104276-f200-4585-a4d3-5b6f9fe8db52" width="22%" alt="image 3"/></td>
<td align="center"><img src="https://github.com/user-attachments/assets/f8730847-c6bc-4e53-9a9f-50251b2211f0" width="22%" alt="image 4"/></td>
</tr>
</table>

## STAGE 1b: METHODS: MULTINOMIAL LOGISTIC REGRESSION ##
The dataset -[Election_Research_2](/Election_Research_2.csv)  was imported and inspected to confirm structure and content. Required R packages (`caret`, `nnet`, and `dplyr`) were loaded to support data preparation and modeling. Variables were formatted as categorical or ordered factors (_Party, Gender, Race, EdLevel_), and incomplete rows were removed to prepare the modeling dataset.

The data was split into 70% training and 30% testing subsets using stratified random sampling with the `createDataPartition()` function to maintain the class distribution of the outcome variable. A 10‑fold cross‑validation procedure was defined using `trainControl()`, and a multinomial logistic regression model was trained with the `train()` function from the `caret` package. The model predicted party affiliation (Party) based on _Income, Age, Gender, Race, and EdLevel_.  R script for this analysis is found in - [R-Script Multinomial Logistic Regression](/code.r.multinomial.R)

<div align="center">
<div style="border: 1px solid #ddd; border-radius: 8px; padding: 20px; background: #f9f9f9; max-width: 600px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">

**Party Distribution Across Train and Test Sets**

| Party | Train Set Proportion | Test Set Proportion | Difference |
|:------|:--------------------:|:-------------------:|:----------:|
| Democrat | 34.03% | 33.93% | +0.10% |
| Republican | 27.35% | 27.51% | −0.16% |
| Independent | 38.62% | 38.56% | +0.06% |

*Note: Proportions rounded to 2 decimal places. Differences calculated as Train − Test.*

</div>
</div>

Model performance was reviewed through cross‑validation results and subsequently tested on the held‑out dataset. Evaluation included the use of `confusionMatrix()` for classification accuracy and extraction of model coefficients via `summary()` and `coef()` for interpretation.

## STAGE 1c:  MODEL RESULTS AND INTERPRETATION
### Model Accuracy
The multinomial logistic regression model demonstrated modest predictive performance across 10-fold cross-validation and the held-out test set. The optimal model (with decay = 0.1) achieved a cross-validated accuracy of 44.2% (Kappa = 0.134), which improved slightly to 42.4% on the test data (95% CI: 37.5%–47.5%). While this accuracy exceeds the no-information rate of 38.6% (the proportion of the majority class, Independents), the difference is only marginally significant (P-value = 0.066). The low Kappa statistic (0.103 on test data) indicates that the model’s agreement with actual party labels is only slightly better than chance, suggesting limited discriminative power overall.

### Confusion Matrix Interpretation
The confusion matrix reveals substantial class imbalance in predictive success. The model performs best at identifying Independents, with a sensitivity (recall) of 60.7%, meaning it correctly captures most Independent voters, though its precision for this class is low (40.4%) due to many false positives. In contrast, the model struggles markedly with Republicans, correctly identifying only 15.9% of them (sensitivity), despite a high specificity of 89.0%. Democrats fall in between, with a sensitivity of 43.2% and the highest precision of any class (49.1%). The balanced accuracy scores (ranging from 0.52 to 0.60) confirm that the model’s ability to distinguish each party from the others is only moderately better than random guessing, with particularly poor performance on the Republican class.

### Coefficients Interpretation
The coefficient table shows how each predictor influences the log-odds of being Republican or Independent relative to the baseline category (Democrat), with Gender coded as 0 = Male and 1 = Female. Race emerges as the strongest predictor: White voters have substantially higher log-odds of being Republican versus Democrat (coefficient = 1.65), while Black and Latino voters have lower log-odds (−0.77 and −0.48, respectively). For Independents, Black voters also show reduced odds relative to Democrats (−0.88), while those of “Other” race show increased odds (1.13). Gender is negatively associated with both Republican (−0.74) and Independent (−0.79) affiliation; since Female = 1, this indicates that women have lower odds of identifying as Republican or Independent compared to men, meaning men are more likely to affiliate with these parties relative to Democrats. Income and Age have coefficients near zero, indicating negligible influence on party affiliation in this model. Education level (orthogonal polynomial contrasts) shows mixed, small-magnitude effects, with no clear monotonic trend across educational attainment.

<div align="center">

## Model Performance on Test Data

<table style="border-collapse: separate; border-spacing: 10px; width: 100%; max-width: 1200px;">
<tr>

<!-- Box 1: Confusion Matrix -->
<td style="border: 1px solid #ddd; border-radius: 8px; padding: 15px; background: #ffffff; box-shadow: 0 2px 4px rgba(0,0,0,0.1); vertical-align: top; min-width: 300px;">

### 📊 Confusion Matrix

| Prediction ↓ / Reference → | Democrat | Republican | Independent |
|:---------------------------|---------:|-----------:|------------:|
| **Democrat** | 57 | 21 | 38 |
| **Republican** | 10 | 17 | 21 |
| **Independent** | 65 | 69 | 91 |

</td>

<!-- Box 2: Overall Statistics -->
<td style="border: 1px solid #ddd; border-radius: 8px; padding: 15px; background: #ffffff; box-shadow: 0 2px 4px rgba(0,0,0,0.1); vertical-align: top; min-width: 280px;">

### 📈 Overall Statistics

| Metric | Value |
|:-------|------:|
| **Accuracy** | 42.42% |
| 95% CI | (37.45%, 47.50%) |
| No Information Rate | 38.56% |
| P-Value (Acc > NIR) | 0.0661 |
| **Kappa** | 0.1028 |
| McNemar's Test P-Value | 5.64×10⁻⁸ |

</td>

</tr>
<tr>

<!-- Box 3: Statistics by Class -->
<td style="border: 1px solid #ddd; border-radius: 8px; padding: 15px; background: #ffffff; box-shadow: 0 2px 4px rgba(0,0,0,0.1); vertical-align: top;" colspan="2">

### 🎯 Statistics by Class

| Metric | Democrat | Republican | Independent |
|:-------|---------:|-----------:|------------:|
| Sensitivity | 0.4318 | 0.1589 | 0.6067 |
| Specificity | 0.7704 | 0.8901 | 0.4393 |
| Pos Pred Value | 0.4914 | 0.3542 | 0.4044 |
| Neg Pred Value | 0.7253 | 0.7361 | 0.6402 |
| Prevalence | 0.3393 | 0.2751 | 0.3856 |
| Detection Rate | 0.1465 | 0.0437 | 0.2339 |
| Detection Prevalence | 0.2982 | 0.1234 | 0.5784 |
| **Balanced Accuracy** | **0.6011** | **0.5245** | **0.5230** |

</td>

</tr>
<tr>

<!-- Box 4: Test Accuracy Highlight -->
<td style="border: 2px solid #4CAF50; border-radius: 8px; padding: 15px; background: #e8f5e9; box-shadow: 0 2px 4px rgba(0,0,0,0.1); vertical-align: top;" colspan="2">

### ✅ Test Accuracy

<div align="center">

# **42.42%**

*Accuracy on held-out test set (165 / 389 correct)*

</div>

</td>

</tr>
</table>

</div>

##  STAGE 1: SUMMARY - Overall Predictive Strength
In summary, the model exhibits weak to moderate predictive ability. While it performs slightly better than a naive baseline that always predicts the majority class, its overall accuracy (~42–44%) and low Kappa (~0.10–0.13) indicate limited practical utility for reliably classifying individual party affiliation. The model’s strength lies primarily in identifying Independent voters, but it fails to adequately capture Republican affiliation and produces considerable misclassification across all classes. These results suggest that the included demographic and socioeconomic predictors alone are insufficient to strongly determine party affiliation, and that additional variables (e.g., political ideology, geographic region, or issue positions) would likely be needed to substantially improve predictive performance.
