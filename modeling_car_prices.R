library(tidyverse)
library(modelr)


load("df_cleaned.RData")




mod1 = lm(df_cleaned, formula = sellingprice  ~ odometer)  # RSE: 7812, MRS: 0.3493
summary(mod1)


mod2 = lm(df_cleaned, formula = sellingprice  ~ odometer + factor(year))  # RSE: 7526, MRS: 0.396
summary(mod2)


mod3 = lm(df_cleaned, formula = sellingprice  ~ odometer + factor(year) + transmission)  # RSE: 7526, MRS: 0.3961
summary(mod3)


mod4 = lm(df_cleaned, formula = sellingprice  ~ odometer + factor(year) + condition - 1)  # RSE: 7239, MRS: 0.8147
summary(mod4)


mod5 = lm(df_cleaned, formula = sellingprice  ~ odometer + factor(year) + poly(condition, 2, raw=TRUE) - 1)  # RSE: 7226, MRS: 0.8153
summary(mod5)


mod6 = lm(df_cleaned, formula = sellingprice  ~ odometer + factor(year) * poly(condition, 2, raw=TRUE) - 1)  # RSE: 7208, MRS: 0.8163
summary(mod6)


mod7 = lm(df_cleaned, formula = sellingprice  ~ odometer + factor(year) * poly(condition, 2, raw=TRUE) + make - 1)  # RSE: 5880, MRS: 0.8777
summary(mod7)


# Modelo muy pesado
mod8 = lm(df_cleaned, formula = sellingprice  ~ odometer + factor(year) * poly(condition, 2, raw=TRUE) + make + model - 1)
summary(mod8)


# Modelo muy pesado
mod9 = lm(df_cleaned, formula= sellingprice ~ poly(year, 2, raw=TRUE) + condition * odometer + make + model + transmission + state + color + body)
summary(mod9)


mod10 = lm(df_cleaned, formula = sellingprice ~ odometer + factor(year) + condition + sale_day_of_week - 1)  # RSE: 7224, MRS: 0.8154
summary(mod10)
