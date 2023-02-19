# https://rud.is/rpubs/building-pictograms.html

library(ggplot2)
# devtools::install_github("hrbrmstr/waffle")
library(waffle)
library(hrbrthemes)
library(extrafont)

extrafont::loadfonts(quiet = TRUE)

fa_grep("male")

tbl <- tibble(
  prepost = factor(c(rep("Pre-training", 2), rep("Post-training", 2)), levels=c('Pre-training', 'Post-training')),
  outcome = factor(c("pass","fail","pass","fail")),
  values = c(28, 72, 58, 42)
) 
p <- ggplot(tbl, aes(label = outcome, values = values))
p <- p + geom_pictogram(n_rows = 10, aes(color = outcome), flip = TRUE)
p <- p + facet_wrap(~prepost, nrow = 1, strip.position = "bottom")
p <- p + scale_color_manual(
  name = NULL,
  values = c("#a40000", "#c68958"),
  labels = c("Fail", "Pass")
)
p <- p + scale_label_pictogram(
  name = NULL,
  values = c("male", "male"),
  labels = c("Fail", "Pass")
)
p <- p + coord_equal()
# p <- p + theme_ipsum_rc(grid="")
# p <- p + theme_enhance_waffle()
p <- p + theme(legend.key.height = unit(2.25, "line"))
p <- p + theme(legend.text = element_text(size = 10, hjust = 0, vjust = 0.75))
p



library(tidyverse)

# devtools::install_github("liamgilbey/ggwaffle")
library(ggplot2)
library(waffle)
library(ggwaffle)
library(ggimage)
library(Cairo)
# install.packages("rsvg")
library(rsvg)

# https://fontawesome.com/v5/cheatsheet
# https://rforbiochemists.blogspot.com/2019/04/an-icon-plot-inspired-by-bacon-and-new.html

setwd("C:/Users/AJ Thurston/Documents/GitHub/iconarray")

df <- read.csv("iconarray.csv")

# waffle_data <- waffle_iron(df_waf, aes_d(group = pass)) 
# waffle_data$image = sample(img, size=150, replace = TRUE)
# head(iris)
# 

# PAY ATTTENTION TO THIS ONE -----

df_waf <- read.csv("df_waf.csv")

df_waf$prepost <- factor(df_waf$prepost, levels = c("pre","post"))
df_waf$pass <- factor(df_waf$pass, levels = c("fail","pass"))
df_waf$image <- "images/person-rounded.svg"

p <- ggplot(df_waf %>% filter(prepost == "pre"), 
            aes(x = row, y = col, color = pass)) 
p <- p + scale_color_manual(values=c("gray","#336666"))
p <- p + scale_y_continuous(expand = c(.1,.1))
p <- p + facet_wrap(~prepost, nrow = 1, strip.position = "left")
# p <- p + coord_equal()
p <- p + labs(color='Passed test') 
p <- p + theme(panel.background = element_rect(color = "gray", fill = "white"),
               panel.grid = element_blank(),
               axis.text = element_blank(),
               axis.ticks = element_blank(),
               axis.title = element_blank()
               )
p <- p + geom_point()
# p <- p + geom_image(aes(image=image), size = .1, by = "height")
p
ggsave("iconarray.png", 
       plot = p, 
       scale = 1, 
       width = 6.5, 
       height = 2, 
       units = "in",
       dpi = 300,
       type = "cairo-png")

# -----

ggplot(df_waf, aes(x = row, y = col, color = pass)) + geom_image(aes(image=image))


p1 <- ggplot(df_waf, aes(row, col, color = pass)) + 
  geom_icon(aes(image=icon), size = 0.1) +
  # scale_color_manual(values=c("black", "grey")) +
  theme_waffle()  +
  theme(legend.position = "none") +
  labs(x = "", y = "", title = "")
p1

# Personograph -------
library(personograph)
pre <- list(failed=0.73, passed=0.27)


svg("iconarray_pre.svg",
    width = 4, 
    height = 8)

personograph(pre,  
             colors=list(failed = "gray", passed="#336666"),
             draw.legend = FALSE, 
             dimensions=c(10,10))
# trace(personograph, edit = T)


dev.off()


post <- list(failed=0.42, passed=0.58)


svg("iconarray_post.svg",
    width = 4, 
    height = 8)

personograph(post,  
             colors=list(failed = "gray", passed="#336666"),
             draw.legend = FALSE, 
             dimensions=c(10,10))
# trace(personograph, edit = T)


dev.off()

library(extrafont)
# https://fontawesome.com/download
# for web, get the TFF files

# font_import()
fonts()[grep("Awesome", fonts())]
loadfonts(device = "win")



help(waffle)
waffle(c(50, 30, 15, 5), 
       rows = 5, 
       use_glyph = "calculator", 
       glyph_size = 6)
# https://nsaunders.wordpress.com/2017/09/08/infographic-style-charts-using-the-r-waffle-package/
# https://fontawesome.com/download