# Impose personal bias on graphics and warnings
theme_set(theme_bw())
options(warn=-1)
no_x_axis <- theme( axis.line.x = element_blank(),
                    axis.text.x = element_blank(),
                    axis.title.x = element_blank(),
                    axis.ticks.x = element_blank() )
