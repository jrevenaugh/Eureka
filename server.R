library(tidyverse)
server <- function(input, output, session) {

  # Tab Panel 1 ---------------------
  # Render the Airy isotasy graphic
  output$airyplot <- renderPlot({

    # Set constants and perform calculation
    Hw <- 4
    Rw <- 1.04
    if ( input$Alandorsea == 1 ) {
      Hc <- 35
      Hroot <- input$AHelev * input$ARc / ( input$ARm - input$ARc )
    } else {
      Hc <- 7
      if ( input$AHelev < Hw ) {
        Hroot <- input$AHelev * ( input$ARc - Rw ) / ( input$ARm - input$ARc )
      } else {
        Hroot <- ( input$AHelev * input$ARc - Hw * Rw ) / ( input$ARm - input$ARc )
      }
    }

    # Print "Not possible" if balance cannot be achieved.
    if ( Hc + Hroot + input$AHelev < 0 ) {
      ggplot() + annotate( "text", x = 0, y = 0, label = "Not possible" ) +
        theme_void()
    } else {
      # Set up rectangle geoms
      ec.df <- data.frame( xmin = 25, ymin = -( Hroot + Hc ), xmax = 75, ymax = input$AHelev )
      loc.df <- data.frame( xmin = 0, xmax = 25, ymin = -Hc, ymax = 0 )
      roc.df <- data.frame( xmin = 75, xmax = 100, ymin = -Hc, ymax = 0 )
      m.df <- data.frame( xmin = 0, xmax = 100, ymin = min( ec.df$ymin, loc.df$ymin, -50 ) - 5, ymax = 0 )

      # Adjust plot limits for deep root cases
      if ( m.df$ymin < 50 ) {
        ylimits <- c( m.df$ymin, 15 )
      } else {
        ylimits <- c( 50, 15 )
      }

      # Initiate the graphic
      if ( input$Alandorsea == 2 ) {
        w.df <- data.frame( xmin = 0, xmax = 100, ymin = min( 0, input$AHelev ), ymax = Hw )
        g <- ggplot() +
          geom_rect( data = w.df, aes( xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax ), fill = "lightsteelblue" ) +
          annotate( "text", x = 2, y = w.df$ymin + 1, label = "Water", size = 6, hjust = 0, vjust = 0 )
      } else {
        g <- ggplot()
      }

      # Draw basic rect geoms
      g <- g +
        geom_rect( data = m.df, aes( xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax ), fill = "aquamarine4" ) +
        geom_rect( data = loc.df, aes( xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax ), fill = "darkkhaki" ) +
        geom_rect( data = roc.df, aes( xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax ), fill = "darkkhaki" ) +
        geom_rect( data = ec.df, aes( xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax ), fill = "darkkhaki" ) +

        # Label the basic blocks
        annotate( "text", x = 2, y = loc.df$ymin + 1, label = "Crust", size = 6, hjust = 0, vjust = 0 ) +
        annotate( "text", x = 2, y = m.df$ymin + 1, label = "Mantle", size = 6, hjust = 0, vjust = 0 ) +
        annotate( "text", x = 50, y = 0.5 * ( ec.df$ymin + loc.df$ymin ),
                  label = paste( "Root = ", round( Hroot, 2 ), " km" ),
                  vjust = 0.5 ) +

        # Accentuate the moho and edges of terrain block
        annotate( "line", x = c( 0, 100 ), y = rep( loc.df$ymin, 2 ) ) +
        annotate( "line", x = rep( 25, 2 ), y = c( ec.df$ymax, ec.df$ymin ), color = "grey50" ) +
        annotate( "line", x = rep( 75, 2 ), y = c( ec.df$ymax, ec.df$ymin ), color = "grey50" ) +

        labs( x = "", y = "Elevation (km)" ) +
        scale_y_continuous( limits = ylimits, sec.axis = sec_axis( trans = ~-., name = "Depth (km)" ) ) +
        no_x_axis

      print(g)
    }

  }, res = 120 )

  # Pop up help for Airy
  observeEvent( input$airyhelp, {
    showModal( modalDialog(
      title = "Airy Isotasy",
      HTML( paste( "Airy's model of isostasy assumes uniform density in the crust.  To balance mass excesses (mountains) ",
                   "or mass deficits (valleys), crustal thickness is varied, resulting in deep crustal roots under mountains ",
                   "and thinned crust beneath valleys.",
                   tags$br(), tags$br(),
                   "See how crustal thickness varies for mountains and valleys, both on land and on sea. ",
                   "Vary density to determine the sensitivity Airy's model." ) ),
      easyClose = TRUE )
    )
  })

  # Make sure that crustal density is less than mantle density for Airy.
  observe({
    val <- input$ARm
    if ( input$ARc >= val ) updateSliderInput(session, "ARc", value = val - 0.1 )
  })

  # Tab Panel 2 ------------------------------------------------------------
  # Render the Pratt isostasy graphic
  output$prattplot <- renderPlot({

    # Set constants, do calculation
    Hw <- 4
    Rw <- 1.04
    if ( input$Plandorsea == 1 ) {
      Relev <- input$PHc * input$PRc / ( input$PHc + input$PHelev )
    } else {
      Hwe <- min( input$Helev, Hw )
      Relev <- ( input$PHc * input$PRc + Rw * Hwe ) / ( input$PHelev + input$PHc )
    }

    # Set up geoms for basic isostasy units
    ec.df <- data.frame( xmin = 25, ymin = -input$PHc, xmax = 75, ymax = input$PHelev )
    loc.df <- data.frame( xmin = 0, xmax = 25, ymin = -input$PHc, ymax = 0 )
    roc.df <- data.frame( xmin = 75, xmax = 100, ymin = -input$PHc, ymax = 0 )
    m.df <- data.frame( xmin = 0, xmax = 100, ymin = min( -50, -input$PHc - 10 ), ymax = min( 0, input$PHelev ) )

    # Initiate plot.  Two versions, one for land, two for sea
    if ( input$Plandorsea == 2 ) {
      w.df <- data.frame( xmin = 0, xmax = 100, ymin = min( 0, input$PHelev ), ymax = Hw )
      g <- ggplot() +
        geom_rect( data = w.df, aes( xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax ), fill = "lightsteelblue" ) +
        annotate( "text", x = 2, y = 1, label = "Water", size = 6, hjust = 0, vjust = 0 )
    } else {
      g <- ggplot()
    }

    # Add the rectangle geoms
    g <- g +
      geom_rect( data = m.df, aes( xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax ), fill = "aquamarine4" ) +
      geom_rect( data = loc.df, aes( xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax ), fill = "darkkhaki" ) +
      geom_rect( data = roc.df, aes( xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax ), fill = "darkkhaki" ) +
      geom_rect( data = ec.df, aes( xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax ), fill = "darkkhaki" ) +

      # Label blocks
      annotate( "text", x = 2, y = loc.df$ymin + 1, label = "Crust", size = 6, hjust = 0, vjust = 0 ) +
      annotate( "text", x = 2, y = m.df$ymin + 1, label = "Mantle", size = 6, hjust = 0, vjust = 0 ) +
      annotate( "text", x = 50, y = -0.5 * ( input$PHc - input$PHelev ),
                label = paste( "rho == ", round( Relev, 2 ), "~(gm/cm^3)" ),
                vjust = 0.5, parse = TRUE, size = 6 ) +

      # Accentuate the moho and edges of terrain block
      annotate( "line", x = c( 0, 100 ), y = rep( loc.df$ymin, 2 ) ) +
      annotate( "line", x = rep( 25, 2 ), y = c( ec.df$ymax, ec.df$ymin ), color = "grey50" ) +
      annotate( "line", x = rep( 75, 2 ), y = c( ec.df$ymax, ec.df$ymin ), color = "grey50" ) +

      # Axes configuration
      labs( x = "", y = "Elevation (km)" ) +
      scale_y_continuous( sec.axis = sec_axis( trans = ~-., name = "Depth (km)" ) ) +
      no_x_axis

    print(g)

  }, res = 120 )

  # Pop up help for Pratt
  observeEvent( input$pratthelp, {
    showModal( modalDialog(
      title = "Pratt Isotasy",
      HTML( paste( "Pratts's model of isostasy assumes uniform crustal thickness.  To balance mass excesses (mountains) ",
                   "or mass deficits (valleys), crustal density is varied, resulting in low density crust under mountains ",
                   "and high density crust beneath valleys.",
                   tags$br(), tags$br(),
                   "See how density varies for mountains and valleys, both on land and on sea. ",
                   "Vary crustal thickness and nominal density to determine the sensitivity of Pratts's model." ) ),
      easyClose = TRUE )
    )
  })

  # Make sure that crustal thickness is greater than negative topography for Pratt.
  observe({
    val1 <- input$PHc
    val2 <- input$PHelev
    if ( val2 <= -val1 + 1 ) updateSliderInput(session, "PHc", value = -val2 + 1 )
  })

  # Tab Panel 3 ---------------------
  # Render the continental freeboard graphic
  output$freeboardplot <- renderPlot({

    # Perform isostasy calculation
    Rw <- 1.04
    Hroot <- ( input$Hc * input$Rc - input$Ho * input$Ro - input$Hw * Rw ) / input$Rm
    Hfree <- input$Hc - input$Hw - input$Ho - Hroot

    # Did freeboard hit the sweet spot?
    if ( Hfree < 0.70 | Hfree > 1 ) {
      result <- "Failure"
      color <- "darkred"
    } else {
      result <- "Success"
      color <- "darkorange3"
    }

    # Adjust plot vertical limits for rare extreme cases
    if( input$Hw + input$Ho + Hroot >= 50 | input$Hc >= 50 )
      ylimits <- c( 0, 75 )
    else
      ylimits <- c( 0, 60 )

    # Create data.frames to hold isostasy building blocks
    cc.df <- data.frame( xmin = 0, ymin = 0, xmax = 50, ymax = input$Hc )
    oc.df <- data.frame( xmin = 50, xmax = 100, ymin = Hroot, ymax = Hroot + input$Ho )
    w.df <- data.frame( xmin = 50, xmax = 100, ymin = Hroot + input$Ho, ymax = Hroot + input$Ho + input$Hw )
    m.df <- data.frame( xmin = 50, xmax = 100, ymin = 0, ymax = Hroot )

    # Build plot
    g <- ggplot( ) +
      geom_rect( data = cc.df, aes( xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax ), fill = "darkkhaki" ) +
      geom_rect( data = oc.df, aes( xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax ), fill = "grey60" ) +
      geom_rect( data = w.df, aes( xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax ), fill = "lightsteelblue" ) +
      geom_rect( data = m.df, aes( xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax ), fill = "aquamarine4" ) +

      # Label the basic blocks
      annotate( "text", x = 50, y = cc.df$ymax / 2, label = result, size = 28, color = color ) +
      annotate( "text", x = 75, y = 0.5 * ( w.df$ymax + cc.df$ymax ),
                label = paste( "Freeboard = ", round( Hfree, 2 ), " km" ),
                size = 6 ) +
      annotate( "text", x = 25, y = max( c( cc.df$ymax, w.df$ymax ) ) + 5, label = "Continent", size = 10 ) +
      annotate( "text", x = 75, y = max( c( cc.df$ymax, w.df$ymax ) ) + 5, label = "Ocean", size = 10 ) +

      annotate( "text", x = 2, y = cc.df$ymin + 1, label = "Continental Crust", size = 6, hjust = 0, vjust = 0 ) +
      annotate( "text", x = 98, y = cc.df$ymin + 1, label = "Mantle", size = 6, hjust = 1, vjust = 0 ) +
      annotate( "text", x = 98, y = oc.df$ymin + 1, label = "Oceanic Crust", size = 6, hjust = 1, vjust = 0 ) +
      annotate( "text", x = 98, y = w.df$ymin + 1, label = "Water", size = 6, hjust = 1, vjust = 0 ) +

      scale_y_continuous( limits = ylimits ) +

      labs( x = "", y = "Thickness (km)" ) +
      no_x_axis

    print( g )
  }, res = 120 )

  # Pop up help for freeboard
  observeEvent( input$freehelp, {
    showModal( modalDialog(
      title = "Freeboard",
      HTML( paste( "Continental freeboard is the average elevation of the continents above sea level.  ",
                   "It depends on the thickness and density of continental and oceanic crust, ",
                   "the depth of the oceans, and density of the upper mantle.  ",
                   tags$br(), tags$br(),
                   "At present, freeboard is about 850 m.  To get there in this exercise, adjust one parameter at a time ",
                   "to see how it affects the result.  Once you understand that, work on getting a successful ",
                   "model with Earth-like parameters for thickness and density." ) ),
      easyClose = TRUE )
    )
  })
}
