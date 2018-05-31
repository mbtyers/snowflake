
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Snowflake Builder v.1.0"),
  h4("Matt Tyers"),
  h3("How the algorithm works..."),
  h5(" - Start with a number of line segments (say, 6) connected at a single point, and radiating in all directions"),
  h5(" - At some fractional distance on each segment, add a branch to either side at some given angle"),
  h5(" - Repeat the previous step n times, with the segments in each iteration branching off from the segments that were the branches in the last iteration."),
  plotOutput("demoPlot",width=700,height=200),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      h3("Snowflake parameters..."),
      sliderInput("n",
                  "Number of iterations:",
                  min = 1,
                  max = 12,
                  step=1,
                  value = 2),
      sliderInput("nsides",
                  "Number of sides:",
                  min = 1,
                  max = 12,
                  step=1,
                  value = 6),
      sliderInput("angle",
                  "Branch angle (degrees):",
                  min = 1,
                  max = 179,
                  step=1,
                  value = 60),
      sliderInput("nbranch",
                  "Number of branches:",
                  min = 1,
                  max = 5,
                  step=1,
                  value = 1),
      sliderInput("lastbranch",
                  "Last branch location:",
                  min = 0.01,
                  max = .99,
                  step=.01,
                  value = .55),
      h3("Graphical parameters..."),
      checkboxInput("color","Draw in color",value=FALSE),
      sliderInput("colramp",
                  "Piece of the rainbow",
                  min = 0,
                  max = 1,
                  value = c(0,1)),
      checkboxInput("raininvert","Invert colors",value=FALSE),
      checkboxInput("lwd","Weight line thickness",value=FALSE),
      h3("Performance parameter..."),
      h6("This increases the built-in limit on how many iterations can be performed.  Setting this to a larger number will allow more complex shapes, but may result in slow calculations."),
      numericInput("maxsize",
                   "Max allowable vector",value = 50000),
      
      downloadButton('downloadPlot', 'Download image...')
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("bigPlot",width=800,height=800)
    )
  ),
  plotOutput("galleryPlot",width=1200,height=400)
))
