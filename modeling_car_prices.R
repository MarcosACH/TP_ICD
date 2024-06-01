library(tidyverse)
library(modelr)


load("df_cleaned.RData")




mod1 = lm(df_cleaned, formula = sellingprice  ~ odometer)  # RSE: 7812, MRS: 0.3493
summary(mod1)


mod2 = lm(df_cleaned, formula = sellingprice  ~ odometer + factor(year) - 1)  # RSE: 7526, MRS: 0.7997
summary(mod2)


mod3 = lm(df_cleaned, formula = sellingprice  ~ odometer + factor(year) + transmission - 1)  # RSE: 7526, MRS: 0.7997
summary(mod3)


mod15 = lm(df_cleaned, formula = sellingprice  ~ odometer + factor(year) + body - 1)  # RSE: 6705, MRS: 0.841
summary(mod15)


mod16 = lm(df_cleaned, formula = sellingprice  ~ odometer + factor(year) + make - 1)  # RSE: 6129, MRS: 0.8672
summary(mod16)


mod4 = lm(df_cleaned, formula = sellingprice  ~ odometer + factor(year) + condition - 1)  # RSE: 7239, MRS: 0.8147
summary(mod4)

plot(mod4, which=1)


mod17 = lm(df_cleaned, formula = sellingprice  ~ odometer * condition + factor(year) + make + body - 1)  # RSE: 5159, MRS: 0.909
summary(mod17)

plot(mod17, which=1)


mod18 = lm(df_cleaned, formula = sellingprice  ~ odometer * condition + factor(year) + make + body + transmission - 1)  # RSE: 5159, MRS: 0.909
summary(mod18)


df_cleaned = df_cleaned %>%
  add_predictions(model=mod17) %>%
  add_residuals(model=mod17)



# Agregamos rendimiento de las concesionarias.

df_cleaned = df_cleaned %>%
  group_by(seller) %>%
  mutate(rendimiento = round(sum(sellingprice)) - round(sum(pred))) %>%
  ungroup()



anova(mod15, mod16, mod4, mod17)


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
mod9 = lm(df_cleaned, formula= sellingprice ~ poly(year, 2, raw=TRUE) + condition * odometer + make + model + transmission + state + color + body - 1)
summary(mod9)


mod10 = lm(df_cleaned, formula = sellingprice ~ odometer + factor(year) + condition + sale_day_of_week - 1)  # RSE: 7224, MRS: 0.8154
summary(mod10)
