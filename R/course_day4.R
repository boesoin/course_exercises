#### download if necessary and load the libraries:
pacman::p_load(
  rio,         # import/export
  here,        # file locator
  usethis,
  gitcreds,
  tidyverse,  # collection of packages...
  medicaldata,
  cowplot,
  Hmisc,
  #ggpmisc,
  renv, # --> lock file with info on environment
  riskCommunicator, # contains data of the Frammingham-Study,
  TH.data,
  epitools,
  survival
)
######


###### load data:
breastCancer <- TH.data::GBSG2
head(breastCancer)
str(breastCancer)
varnames <- names(breastCancer) # save the varnames as vector
varnames
?GBSG2
# apparently, cens means 0 (no event) 1 (event)
#breastCancer %>%
tabulate(breastCancer$cens)

#### tabulate events by group:
Tab_horTh_recur <-  table(breastCancer$horTh, breastCancer$cens)
Tab_horTh_recur

#### sum of all rows -->
n_byhorTh <- rowSums(Tab_horTh_recur) # this creates a vector of two

p_recur_byhorTh <- Tab_horTh_recur[, "1"] / n_byhorTh
as.matrix(p_recur_byhorTh)

######################### 1.2 Confidence intervals

SE_recur_byhorTh <- sqrt(p_recur_byhorTh * (1 - p_recur_byhorTh) / n_byhorTh)


lowerCI_p_recur_byhorTh <- p_recur_byhorTh - qnorm(0.975) * SE_recur_byhorTh

upperCI_p_recur_byhorTh <- p_recur_byhorTh + qnorm(0.975) * SE_recur_byhorTh

cbind(p_recur_byhorTh, lowerCI_p_recur_byhorTh, upperCI_p_recur_byhorTh)

##################### exercise 3 ##############################################
## Manually ....................................................................


breastCancer$time_years <- breastCancer$time / 365.25

recur_byhorTh <- aggregate(cens ~ horTh, data = breastCancer, FUN = sum)

pYr_byhorTh <- aggregate(time_years ~ horTh, data = breastCancer, FUN = sum)

recur_pYr_byhorTh <- merge(recur_byhorTh, pYr_byhorTh, by = "horTh")

recur_pYr_byhorTh$rate <- recur_pYr_byhorTh$cens / recur_pYr_byhorTh$time_years

SE_logrecurRate <- 1 / sqrt(recur_pYr_byhorTh$cens)

recur_pYr_byhorTh$rate_lowerCI <- exp(
  log(recur_pYr_byhorTh$rate) - 1.96 * SE_logrecurRate)

recur_pYr_byhorTh$rate_upperCI <- exp(
  log(recur_pYr_byhorTh$rate) + 1.96 * SE_logrecurRate)

recur_pYr_byhorTh

## R-functions .................................................................

cipoisson(k = recur_pYr_byhorTh$cens, time = recur_pYr_byhorTh$time_years)

# Manually
recurRateRatio <- recur_pYr_byhorTh$rate[recur_pYr_byhorTh$horTh == "yes"] /
  recur_pYr_byhorTh$rate[recur_pYr_byhorTh$horTh == "no"]

SE_logrecurRateRatio <- sqrt(
  1 / recur_pYr_byhorTh$cens[recur_pYr_byhorTh$horTh == "yes"] +
    1 / recur_pYr_byhorTh$cens[recur_pYr_byhorTh$horTh == "no"])

lowerCI_recurRateRatio <- exp(log(recurRateRatio) - 1.96 * SE_logrecurRateRatio)

upperCI_recurRateRatio <- exp(log(recurRateRatio) + 1.96 * SE_logrecurRateRatio)

cbind(recurRateRatio, lowerCI_recurRateRatio, upperCI_recurRateRatio)

## R-functino
rateratio(x = recur_pYr_byhorTh$cens, y = recur_pYr_byhorTh$time_years)



################################################################################
#################### exercise 4 , survival-rates ###############################
KM_recur_byhorTh <- survfit(Surv(time_years, cens) ~ horTh,
                            data = breastCancer)

summary(KM_recur_byhorTh)

plot(KM_recur_byhorTh, col = c("red", "blue"), xlab = "time (years)",
     ylab = "recurrence-free survival")
legend("topright", lty = c(1, 1), col = c("red", "blue"),
       legend = c("no", "yes"), title = "horTh", cex = 0.8)
#this is apparently ot tidyverse
?plot.survfit



# Plot using ggplot
str(KM_recur_byhorTh)
ggplot(KM_recur_byhorTh, aes(x = time, y = recurrence, color = horTh)) +
  geom_line() +
  xlab("time (years)") +
  ylab("recurrence-free survival") +
  scale_color_manual(values = c("red", "blue")) +
  guides(color = guide_legend(title = "horTh")) +
  theme_minimal()




