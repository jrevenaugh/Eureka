require(tidyverse)

# Establish default ggplot2 theme element and suppress warnings
theme_set(theme_bw())
no_x_axis <- theme(axis.line.x = element_blank(),
                  axis.text.x = element_blank(),
                  axis.title.x = element_blank(),
                  axis.ticks.x = element_blank())
options(warn=-1)
