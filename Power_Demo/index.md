---
title       : Sample Size Calculator
subtitle    : A demonstration of statistical power in hypothesis testing
author      : Julian Hatwell
job         : Analyst
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : [mathjax]     # {mathjax, quiz, bootstrap}
mode        : standalone    # {draft, selfcontained}
knit        : slidify::knit2slides
--- 

## Motivation

#### General

Sample size has a dramatic effect on an experiment's sensitivity to the effect size being measured. A researcher may need to detect a specific effect size that might be rather small. Therefore a quick and easy way to calculate a sample size that will validate the experiment's results is called for.

An alternative case is that many experiments come with associated costs and researchers are often keen to optimise the minimum acceptable sample size to run to ensure a valid and worthwhile experiment at the lowest cost.

#### Personal

During my statistics class, the concept that I really struggled with was Power. I was looking for an opportunity to revise and review. I wanted to see if I could get a better grasp of this topic. I thought other learners might have faced the same challenges. I decided to create this tool to visualise Power and how it is used to select sample sizes for experiments.

---
 
## Theory

The significance level e.g. 0.05, is used to reject the Null in a hypothesis test. Test statistics at $1-\alpha$ (the 95th percentile for a one sided test) are considered far enough from $\mu_0$.

However, this doesn't say anything specific about the extent of the difference of our observed mean from the Null. 

Power is useful in giving confidence that our observed result supports a specified value of $\mu_a$ as the true mean. 

Assuming we are also able to reject the Null hypothesis, we satisfy a Power of e.g. 0.8 if our result that is greater than the 20th percentile around $\mu_a$ 

Such a result could be expected four out of every five times the experiment is repeated (80% of the time) if our alternative hypothesis is true. 

---

## The Sample Size Calculator Shiny App

The app can be found [here](https://julianhatwell.shinyapps.io/SampleSizeCalculator/). It implements the following features:

* focus on the most common use of Power - to determine how large a sample size needs to be for an experiment to be able to detect a specified effect size.

* provides options to enter all the necessary input parameters

* returns a result showing what sample size is required 

* also returns $Z_{crit}$ the critical Z-statistic required to reject the Null and accept the alternative hypothesis

* shows a dynamic graphic to help visualise the calculation so students and learners can better understand the concept

---

## The Sample Size Calculator Shiny App 2

Behind the scenes it's running the pwr package, for example:


```r
library(pwr); inDelta <- 0.5; inSig.level <- 0.05; inPower <- 0.8; inAlt <- "greater"
# return the sample size for each group, then plot (plot code echo = FALSE)
(n <- pwr.t.test(d = inDelta, sig = inSig.level, p = inPower, alt = inAlt)$n/2)
```

```
## [1] 25.0754
```

<img src="assets/fig/unnamed-chunk-2-1.png" title="plot of chunk unnamed-chunk-2" alt="plot of chunk unnamed-chunk-2" style="display: block; margin: auto;" />
