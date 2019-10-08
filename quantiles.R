# DESCRIPTION -------------------------------------------------------------
# This script is designed to create quantile plots for communicating a validity
# to non-technical audiences using bar plots.  The script imports your data
# from Excel, creates quantiles (default = 5) on the predicted score, and plots 
# the mean actual criterion score for each quantile.  It will then save the quantiles
# in a new XLSX file.
#
# The simulated data in this example have a correlation of r = .5 (N = 1000, 
# M = 50, SD = 10)
# -------------------------------------------------------------------------
library(openxlsx)
library(ggplot2)
library(formattable)
library(scales)
library(Cairo)

data = read.xlsx("data.xlsx", sheetName = "Sheet1")
# Example data from the repository
# data <- read.xlsx("https://github.com/AJThurston/quantiles/blob/master/data.xlsx?raw=True")

quants  = 5                               #Number of quantiles
txt.siz = 12                              #Size for all text in the plot
y.ll    = 40                              #Y-axis lower limit          
y.ul    = 60                              #Y-axis upper limit
x.title = "Predicted Criterion Quantiles" #X-axis title
y.title = "Mean Actual Criterion Score"   #Y-axis title

# Calculates quantiles and plot results -----------------------------------
data$quant <- as.numeric(cut(data$pred, quantile(data$pred, probs = seq(0,1,1/quants)), include.lowest=TRUE))

plot1 = ggplot(data) +
  scale_y_continuous(name=y.title, limits = c(y.ll,y.ul), oob = rescale_none) + 
  scale_x_continuous(name=x.title, oob = rescale_none) +
  geom_bar(aes(x = quant, y = actu), 
           position = "dodge", 
           stat = "summary", 
           fun.y = "mean",
           fill = '#336666',
           width = .5) +
  geom_text(aes(x = quant, y = actu, label = paste0(round(..y..,0),"%")), 
            stat = "summary", 
            fun.y = "mean",
            vjust = -1) +
  theme(text = element_text(size = txt.siz),
        panel.background = element_rect(fill = "white", color = "black"),
        panel.grid = element_blank(),
        axis.text.y = element_text(color = 'black'),
        axis.text.x = element_text(color = 'black')
       )

# Write plot and quantile data to working directory -----------------------
ggsave("quantiles.png", 
       plot = plot1, 
       scale = 1, 
       width = 6.5, 
       height = 4, 
       units = "in",
       dpi = 300,
       type = "cairo-png")

write.xlsx(data, "data.quantiles.xlsx")

