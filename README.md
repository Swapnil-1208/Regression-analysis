# Regression analysis

Immobilienscout24 (immoscout24.de) is one of the three biggest real estate web-portals in Germany. On its website you may find listings of rental properties and homes for sale. The given data set (ImmoDataNRW.csv) contains 12 118 rental offers for properties located in the province of North Rhine-Westphalia as of February 20, 2020. The data are available on (kaggle.com) for educational/research purposes only.

The data set contains the following 16 variables:<br />
  • ID - identification number <br />
  • newlyConst - whether the property is newly constructed (in 2019 or in 2020)<br />
  • balcony - whether the property has a balcony<br />
  • totalRent - total rent (usually a sum of base rent, service charges and heating costs)<br />
  • yearConstructed - construction year<br />
  • noParkSpaces - number of parking spaces provided with the property<br />
  • hasKitchen - whether the property includes a kitchen or not<br />
  • livingSpace - property size in square meters<br />
  • lift - whether the property has a lift<br />
  • typeOfFlat - type of the property<br />
  • floor - the floor the property is in<br />
  • garden - whether the property has a garden<br />
  • regio2 - city/municipality where the property is located<br />
  • condition - condition of the property<br />
  • lastRefurbished - year of last renovation<br />
  • EnergyEfficiencyClass - energy efficiency class of the building<br />
  
# Tasks 1: Data preparation

  1. Select only observations for the city of Dortmund. Remove the variable that has the highest number of missing observations (NA). After it, remove all rows that contain at least one NA. Do not remove rows that contain “NO_INFORMATION”.<br />
  2. Compute the rental price per square meter (sqmPrice). This will be the dependent variable for the regression analysis.<br />
  3. Group the values of the variable typeOfFlat into the following categories:<br />
      i) “apartment”<br />
      ii) “luxurious_artistic_other”: comprising the values “loft”, “maisonette”, “penthouse”, “terraced_flat” and “other”<br />
      iii) “r_ground_floor”: comprising the values “ground_floor” and “raised_ground_floor””<br />
      iv) “roof_half_basement ”: comprising the values “roof_storey” and “half_basement”<br />

# Tasks 2: Linear regression

  1. Find the “best” predictors for sqmPrice using Best Subset Selection. Use the Akaike Information Criterion (AIC) and the Bayesian Information Criterion (BIC) as the selection criteria. Compare the included variables of the two models.<br />
  2. Estimate the “best” linear model for sqmPrice using the AIC from 1. Interpret the coefficients of the model and their statistical significance, provide confidence intervals for the regression parameters and evaluate the goodness of fit.<br />
