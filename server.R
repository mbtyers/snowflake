
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output) {
  
  snowflake3 <- function(n, nsides=6, angle=60, nbranch=1, lastbranch=(1-1/(nbranch+1)), color=F, rainstart=0, rainend=1, raininvert=F, lwd=F, maxsize=50000, ...) {
    # maxsize <- 50000
    n <- min(n, ceiling(log(maxsize/nsides,base=3*nbranch)))
    plot(NA, xlim=c(-1,1), ylim=c(-1,1), xlab="", ylab="", xaxt='n', yaxt='n', asp=1, ...=...)
    xstart <- rep(0,nsides)
    ystart <- rep(0,nsides)
    firstangle <- 360/nsides*pi/180
    angle <- angle*pi/180
    xend <- sin(firstangle*(1:nsides))
    yend <- cos(firstangle*(1:nsides))
    last_ang <- firstangle*(1:nsides)
    if(color) cols <- rainbow(n, start=rainstart, end=rainend)
    else cols <- rep(1,n)
    if(raininvert) cols <- cols[n:1]
    if(lwd) lwds <- seq(from=n/2,to=1,length.out=n)
    else lwds <- rep(1,n)
    segments(xstart, ystart, xend, yend, col=cols[1], lwd=lwds[1])
    if(n>1) for(i in 2:n) {
      end_l <- (1-lastbranch)^(i-1)
      xstart <- rep(xend,3*nbranch) - rep(1:nbranch,each=length(xend)*3)*rep((1-lastbranch)*(xend-xstart),3*nbranch)
      ystart <- rep(yend,3*nbranch) - rep(1:nbranch,each=length(xend)*3)*rep((1-lastbranch)*(yend-ystart),3*nbranch)
      xend <- xstart + end_l*c(sin(last_ang-angle), sin(last_ang), sin(last_ang+angle))
      yend <- ystart + end_l*c(cos(last_ang-angle), cos(last_ang), cos(last_ang+angle))
      last_ang <- rep(c(last_ang-angle, last_ang, last_ang+angle),nbranch)
      segments(xstart, ystart, xend, yend, col=cols[i], lwd=lwds[i])
    }
  }
  
  bigplottoplot <- function() {
    snowflake3(input$n, input$nsides, input$angle, input$nbranch, input$lastbranch, input$color, input$colramp[1], input$colramp[2], input$raininvert, input$lwd, input$maxsize)
  }

  output$bigPlot <- renderPlot({
    snowflake3(input$n, input$nsides, input$angle, input$nbranch, input$lastbranch, input$color, input$colramp[1], input$colramp[2], input$raininvert, input$lwd, input$maxsize)
  })
  
  output$downloadPlot <- downloadHandler(
    filename = function() {paste0("snowflake_",input$n,"_", input$nsides,"_", input$angle,"_", input$nbranch,"_", 100*input$lastbranch,"_", input$color,"_",input$lwd,".png")},
    content = function(file) {
      png(file,width=1000,height=1000)
      print(bigplottoplot())
      dev.off()
    })
  
  output$galleryPlot <- renderPlot({
    par(mfrow=c(1,4))
    snowflake3(9,6,70,1,.45)
    snowflake3(9,6,37,5,.73)
    snowflake3(9,6,149,5,.72)
    snowflake3(9,12,60,1,.5)
  })
  output$demoPlot <- renderPlot({
    par(mfrow=c(1,4))
    snowflake3(1,6,60,1,.56)
    snowflake3(2,6,60,1,.56)
    snowflake3(3,6,60,1,.56)
    snowflake3(6,6,60,1,.56)
  })

})
