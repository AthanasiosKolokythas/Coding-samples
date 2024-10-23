*************** HOMEWORK 4******************************
****Athanasios Kolokythas, Kajsa Roman, Aris Vilorio****



********* IMPORT AND PREPARATION

* We used the data from https://www.macrohistory.net/ 
clear

* Unmark your prefered path

*import excel "/Users/arisvilorio/Documents/BSE/TERM 3/Macro-Finance/JSTdatasetR6.xlsx", sheet("Sheet1") 

*import excel "/Users/kajsaroman/Documents/Skola/BSE/3rd Term/Macro-Finance\JSTdatasetR6.xlsx", sheet("Sheet1") firstrow clear

import excel "C:\Users\nasos\Desktop\MSC ECON BSE\term3\macro-finance\JSTdatasetR6.xlsx", sheet("Sheet1") firstrow clear

keep year country rgdpmad cpi ltrate stir ca gdp tloans crisisJST iy

* Convert the string variable country to a numeric variable
encode country, gen(country_id)

* Set the data as panel data using country_id as the panel variable and year as the time variable
xtset country_id year



*******DEPENDENT Y

gen y_cum_growth_0 = (rgdpmad - rgdpmad[_n-1])/rgdpmad[_n-1] if _n != 1 
gen y_cum_growth_1 = (rgdpmad[_n+1] - rgdpmad[_n-1])/rgdpmad[_n-1] if _n != 1  & _n != 2
gen y_cum_growth_2 = (rgdpmad[_n+2] - rgdpmad[_n-1])/rgdpmad[_n-1] if _n != 1  & _n != 2 & _n != 3

*******CONTROLS

gen y_cum_growth_lag1 = (rgdpmad[_n-1] - rgdpmad[_n-2])/rgdpmad[_n-2] if _n != 1  & _n != 2
gen cpi_growth = (cpi[_n-1] - cpi[_n-2])/cpi[_n-2] if _n != 1  & _n != 2
gen long_term_lag1 = ltrate[_n-1] if _n != 1 
gen short_term_lag1 = stir[_n-1] if _n != 1 
gen ca_gdp = ca[_n-1]/gdp[_n-1] if _n != 1 
gen rcred = tloans/cpi
gen rcred_growth = (rcred[_n-1] - rcred[_n-2])/rcred[_n-1] if _n != 1 & _n != 2
gen gdp_lag = iy[_n-1] if _n != 1

********REGRESSIONS

* Regression 1 h = 0
* crisis -0.041, significant (0.00)
xtreg y_cum_growth_0 crisisJST y_cum_growth_lag1 cpi_growth long_term_lag1 short_term_lag1 ca_gdp rcred_growth gdp_lag, fe

* Regression 2 h = 1
* crisis -0.064, significant (0.00)
xtreg y_cum_growth_1 crisisJST y_cum_growth_lag1 cpi_growth long_term_lag1 short_term_lag1 ca_gdp rcred_growth gdp_lag, fe

* Regression 2 h = 2
* crisis -.068, significant (0.00)
xtreg y_cum_growth_2 crisisJST y_cum_growth_lag1 cpi_growth long_term_lag1 short_term_lag1 ca_gdp rcred_growth gdp_lag, fe


********BONUS QUESTION
* Mean of lagged credit growth
egen mean_rcred = mean(rcred_growth)

* New crisis variable
gen bonus_crisis = crisisJST == 1 & rcred_growth[_n-1] > mean_rcred + 0.02 

* NEW REGRESSIONS

* NEW Regression 1 h = 0
* bonus_crisis -.041, significant (0.00)
xtreg y_cum_growth_0 bonus_crisis y_cum_growth_lag1 cpi_growth long_term_lag1 short_term_lag1 ca_gdp rcred_growth gdp_lag, fe

* NEW Regression 2 h = 1
* crisis -.064, significant (0.00)
xtreg y_cum_growth_1 bonus_crisis y_cum_growth_lag1 cpi_growth long_term_lag1 short_term_lag1 ca_gdp rcred_growth gdp_lag, fe

* NEW Regression 2 h = 2
* crisis -.068, significant (0.00)
xtreg y_cum_growth_2 bonus_crisis y_cum_growth_lag1 cpi_growth long_term_lag1 short_term_lag1 ca_gdp rcred_growth gdp_lag, fe
