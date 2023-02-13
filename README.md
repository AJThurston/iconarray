Quantiles
================
AJ Thurston

## Introduction

Showing results by quantile groups is a useful tool for communicating
validity in terms of a correlation coefficient to non-technical
audiences. This basic script will create quantiles based on the
predicted criterion score and plot the mean actual criterion scores from
each quantile. It includes the option to can export the quantile
assignment back to a CSV file.

## Setup and Libraries

``` r
library(summarytools)
library(formattable)
library(tidyverse)
library(ggplot2)
library(scales)
library(Cairo)
```

## Data Import

In this example, these simulated data have a correlation of r = .5
between predicted and actual criterion scores (N = 1000, M = 50, SD =
10). First, let’s import the example data and quickly orient ourselves
to it. There are three variables in the file:

1.  id: This is just an identifier or a unique participant ID
2.  actu: this is the acutal criterion score (e.g., actual job
    performance)
3.  pred: this is the predicted criterion score (e.g., predicted job
    perfromance from an employment
test)

<!-- end list -->

``` r
# df <- read.csv("https://raw.githubusercontent.com/AJThurston/quantiles/master/quantiles.csv")
df <- read.csv("quantiles.csv")
head(df)
```

    ##   id actu pred
    ## 1  1   47   44
    ## 2  2   60   64
    ## 3  3   46   46
    ## 4  4   58   60
    ## 5  5   44   50
    ## 6  6   65   60

``` r
df %>%
  select(actu,pred) %>%
  descr(.)
```

    ## Descriptive Statistics  
    ## df  
    ## N: 1000  
    ## 
    ##                        actu      pred
    ## ----------------- --------- ---------
    ##              Mean     49.98     49.91
    ##           Std.Dev      9.57     10.18
    ##               Min     14.00     19.00
    ##                Q1     44.00     43.00
    ##            Median     51.00     50.00
    ##                Q3     56.00     57.00
    ##               Max     85.00     83.00
    ##               MAD     10.38     10.38
    ##               IQR     12.00     14.00
    ##                CV      0.19      0.20
    ##          Skewness     -0.13      0.00
    ##       SE.Skewness      0.08      0.08
    ##          Kurtosis      0.32      0.04
    ##           N.Valid   1000.00   1000.00
    ##         Pct.Valid    100.00    100.00

## Parameters

Next, we’ll need to set some parameters for the analysis and the
graphics of the plot itself. The first parameter is simply how many
quantiles we want to display, we could include only four (i.e.,
quartiles), this example uses five, but I would recommend probably no
more than 10 (i.e., deciles).

Additionally, you’ll need to include the text size for the plot, the
upper and lower limits for the y-axis, and the axis titles. For the
limits, I typically recommend using the actual criterion mean minus two
SD for your lower limit and two SD above the mean for the upper limit.
Some could argue it should be 0 to 100 if that is the range of possible
scores. I would argue my limits cover over 95% of the possible scores.
Whatever limits you choose, ensure you have some justification.

``` r
quants  <-  5                              #Number of quantiles
txt.siz <- 12                              #Size for all text in the plot
y.ll    <- 30                              #Y-axis lower limit          
y.ul    <- 70                              #Y-axis upper limit
x.title <- "Predicted Criterion Quantiles" #X-axis title
y.title <- "Mean Actual Criterion Score"   #Y-axis title
```

## Calculating quantiles

Based on the number of quantiles indicated in the parameter above, now
we actually need to calculate the thresholds between each of the
quantiles then assign each predicted score to a quantile group. The
first bit of code here calculates the quantiles with the `quantile`
function, then the code below takes the predicted values, compares them
to the quantiles, and stores the quantile assignment as a new vairable
using the `cut` function. Finally, the average actual criterion score
for each quantile group is shown.

``` r
quantiles <- quantile(df$pred, probs = seq(0,1,1/quants))
quantiles
```

    ##   0%  20%  40%  60%  80% 100% 
    ## 19.0 41.0 47.6 52.0 59.0 83.0

``` r
df$quant <- df$pred %>%
  cut(., breaks = quantiles, include.lowest=TRUE) %>%
  as.numeric()

head(df)
```

    ##   id actu pred quant
    ## 1  1   47   44     2
    ## 2  2   60   64     5
    ## 3  3   46   46     2
    ## 4  4   58   60     5
    ## 5  5   44   50     3
    ## 6  6   65   60     5

``` r
df %>%
  group_by(quant) %>%
  summarize(m = mean(actu))
```

    ## # A tibble: 5 x 2
    ##   quant     m
    ##   <dbl> <dbl>
    ## 1     1  42.8
    ## 2     2  48.2
    ## 3     3  50.1
    ## 4     4  52.0
    ## 5     5  57.8

In many cases it is easier to simply take these values and display them
in, for example, a PowerPoint plot.

## Plotting Quantile Results

``` r
p <- ggplot(df)
p <- p + scale_y_continuous(name=y.title, limits = c(y.ll,y.ul), oob = rescale_none)
p <- p + scale_x_continuous(name=x.title, oob = rescale_none)
p <- p + geom_bar(aes(x = quant, y = actu), 
                  position = "dodge", 
                  stat = "summary", 
                  fun = "mean",
                  fill = '#336666',
                  width = .5)
p <- p + geom_text(aes(x = quant, y = actu, label = paste0(round(..y..,0),"%")), 
                   stat = "summary", 
                   fun = "mean",
                   vjust = -1)
p <- p + theme(text = element_text(size = txt.siz),
               panel.background = element_rect(fill = "white", color = "black"),
               panel.grid = element_blank(),
               axis.text.y = element_text(color = 'black'),
               axis.text.x = element_text(color = 'black'))
p
```

![](quantiles_files/figure-gfm/plot-1.png)<!-- -->

``` r
ggsave("quantiles.png", 
       plot = p, 
       scale = 1, 
       width = 6.5, 
       height = 4, 
       units = "in",
       dpi = 300,
       type = "cairo-png")

write.csv(data, "quantiles.appended.csv")
```
