# script to evaluate if the differences in Table V are statistically significant
# the data contains a table with four fields:
# - scmethod (hard, soft)
# - affordance (yes, no)
# - transcriptions (lab, asr)
# - score (either [0,1] or {0,1} depending on scmethod)
mydata <- as.data.frame(read.csv("final_prediction_results.data"))
plot(score~affordance, data=mydata)
plot(score~affordance, data=mydata, subset=scmethod=="soft")
plot(score~affordance, data=mydata, subset=scmethod=="hard")

# first of all it doesn't seem fair to consider the soft and hard scores
# together: the first varies continuously between 0 and 1 and the second
# only assumes the values 0 and 1

# first try an anova with everything
anaff <- aov(score~affordance, data=mydata, subset=scmethod="soft")
plot(anaff)
antran <- aov(score~transcriptions, data=mydata, subset=scmethod="soft")
anova(anaff)
anova(antran)
# but it's not fair to consider each factor per se

# here is the model including both factors but no interaction
an <- aov(score~transcriptions+affordance, data=mydata, subset=scmethod="soft")
anova(an)
TukeyHSD(an)
plot(TukeyHSD(an))

# here is the model with the interaction
ansoft <- aov(score~transcriptions*affordance, data=mydata, subset=scmethod=="soft")
anova(ansoft)
plot(TukeyHSD(ansoft))

# here is the model for the hard score
anhard <- aov(score~transcriptions*affordance, data=mydata, subset=scmethod=="hard")
anova(anhard)

# here is a logistic model for the hard score
g <- glm(score~transcriptions*affordance, family=binomial, data=mydata, subset=scmethod=="hard")
anova(g, test="Chisq")
summary(g)
plot(g)
