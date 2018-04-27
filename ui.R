# Eureka shiny UI definition.

ui <- shinyUI(navbarPage("Eureka",
                         theme = shinytheme("united"),

                         # Airy Isostasy tab panel -----------------------------
                         tabPanel("Airy Isotasy",
                                  titlePanel("Mountain Roots"),
                                  column(3, wellPanel(
                                    style = "background-color: #fbfbfb;",
                                    sliderInput( inputId = "AHelev",
                                                 label = "Elevation (km)",
                                                 min = -10,
                                                 max = 10,
                                                 step = 0.25,
                                                 value = 1 ),

                                    sliderInput( inputId = "ARc",
                                                 label = HTML( paste( "Crustal Density (gm/cm", tags$sup(3), ")", sep = "") ),
                                                 min = 2,
                                                 max = 4,
                                                 step = 0.01,
                                                 value = 2.7 ),

                                    sliderInput( inputId = "ARm",
                                                 label = HTML( paste( "Mantle Density (gm/cm", tags$sup(3), ")", sep = "") ),
                                                 min = 2.5,
                                                 max = 4.5,
                                                 step = 0.01,
                                                 value = 3.3 ),

                                    radioButtons( inputId = "Alandorsea",
                                                  label = "Land or Sea?",
                                                  choices = c( "Land" = 1,
                                                               "Sea" = 2 ),
                                                  selected = 1 ),

                                    hr(),
                                    actionButton( "airyhelp", "Help" )
                                  )),
                                  column(8,
                                         plotOutput("airyplot", height = 500 )
                                  )
                         ),

                         # Pratt Isostasy tab panel ----------------------------
                         tabPanel("Pratt Isostasy",
                                  titlePanel("Changing Density"),
                                  column(3, wellPanel(
                                    style = "background-color: #fbfbfb;",
                                    sliderInput( inputId = "PHelev",
                                                 label = "Elevation (km)",
                                                 min = -10,
                                                 max = 10,
                                                 step = 0.25,
                                                 value = 1 ),

                                    sliderInput( inputId = "PHc",
                                                 label = "Crustal Thickness (km)",
                                                 min = 5,
                                                 max = 60,
                                                 step = 0.5,
                                                 value = 30 ),

                                    sliderInput( inputId = "PRc",
                                                 label = HTML( paste( "Crustal Density (gm/cm", tags$sup(3), ")", sep = "") ),
                                                 min = 2,
                                                 max = 4,
                                                 step = 0.01,
                                                 value = 2.7 ),

                                    radioButtons( inputId = "Plandorsea",
                                                  label = "Land or Sea?",
                                                  choices = c( "Land" = 1,
                                                               "Sea" = 2 ),
                                                  selected = 1 ),

                                    hr(),
                                    actionButton( "pratthelp", "Help" )
                                  )),
                                  column(8,
                                         plotOutput("prattplot", height = 500 )
                                  )
                         ),

                         # Freeboard tab panel ---------------------------------
                         tabPanel("Freeboard",
                                  titlePanel("Finding the Balance"),
                                  column(4, wellPanel(
                                    style = "background-color: #fbfbfb;",
                                    h4( "Continental Crust" ),
                                    fluidRow(
                                      column(6,
                                             sliderInput( inputId = "Hc",
                                                          label = "Thickness (km)",
                                                          min = 10,
                                                          max = 60,
                                                          step = 0.5,
                                                          value = 30 )
                                      ),

                                      column(6,
                                             sliderInput( inputId = "Rc",
                                                          label = HTML( paste( "Density (gm/cm", tags$sup(3), ")", sep = "") ),
                                                          min = 2,
                                                          max = 4,
                                                          step = 0.01,
                                                          value = 2.5 )
                                      )
                                    ),

                                    hr(),
                                    h4( "Oceanic Crust"),
                                    fluidRow(
                                      column( 6,
                                              sliderInput( inputId = "Ho",
                                                           label = "Thickness (km)",
                                                           min = 1,
                                                           max = 20,
                                                           step = 0.5,
                                                           value = 10 )
                                      ),

                                      column( 6,
                                              sliderInput( inputId = "Ro",
                                                           label = HTML( paste( "Density (gm/cm", tags$sup(3), ")", sep = "") ),
                                                           min = 2,
                                                           max = 4,
                                                           step = 0.01,
                                                           value = 2.5 )
                                      )
                                    ),
                                    hr(),
                                    h4( "Seawater and Mantle" ),
                                    fluidRow(
                                      column(6,
                                             sliderInput( inputId = "Hw",
                                                          label = "Ocean Depth (km)",
                                                          min = 1,
                                                          max = 10,
                                                          step = 0.1,
                                                          value = 5 )
                                      ),
                                      column( 6,
                                              sliderInput( inputId = "Rm",
                                                           label = HTML( paste( "Mantle Density (gm/cm", tags$sup(3), ")", sep = "") ),
                                                           min = 2,
                                                           max = 4,
                                                           step = 0.01,
                                                           value = 3.5 )
                                      )
                                    ),
                                    hr(),
                                    actionButton( "freehelp", "Help" )
                                  )),
                                  column(8,
                                         plotOutput("freeboardplot", height = 600 )
                                  )
                         ),

                         # Contact/Code information tab panel ------------------
                         tabPanel("More Information",   # Contact Information.
                                  "Any questions or comments can be sent to:", br(),
                                  "Justin Revenaugh:", br(),
                                  "University of Minnesota", br(),
                                  "Earth Sciences", br(),
                                  "Minneapolis, MN 55455 USA", br(),
                                  a("justinr@umn.edu", href="mailto:justinr@umn.edu"), br(),
                                  a("See the code", href="https://github.com/jrevenaugh/Eureka"), br()
                         )
)
)
