
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library("shiny")
library("ggplot2")
library("quantmod")

### user notes
## what i would change -> make each Type(other, art explorer ...etc) each its own dataset then that was you can subset it better.
## i do not have the time of the sanity to do this right now


shinyServer(function(input, output) {
      
      #KCL you use dfg in some places and finalartdata in others but never create finalartdata!!!
      # I took this part out and moved to global.R so both ui.R and server.R can use it
#       dfg <- read.csv("./data/dfgdata.csv", header = TRUE)
#       finalartdata <-dfg
      ####   the rows that contain the "types" can be reformatted so it just subsets based the on type so it can react to when more data is put in 
      ####   ex: "Type3" = finalartdata[354:505,] could just be "Type3" = finalartdata[finalartdata$Type == "Meeting (M) (Museum Related)",] 
      
      #KCL this is a very bad idea if you ever want to load a new data set
      datasetInput <- reactive({
            #KCL limit based on input parameter
            data<-dfg[dfg$CAT==input$parameters,]
            #KCL convert date to Date class so you can subset with it
            data$Date<-as.Date(data$Date,format="%m/%d/%Y",origin='1970-01-01')
            #KCL Filter dataframe on dates, should update when ever date changes
            dataFiltered<-data[data$Date>=input$date[1] & data$Date<=input$date[2],]
            dataFiltered
            })
      
#       #KCL I dont understand what you are trying to do with this, I just commented it out to get everything running 
#      variables <- reactive({
#             
#             ###for everything but university classes
#             Date <- finalartdata[finalartdata$Date == datasetInput, ] 
#             Head.Count <- data.frame(finalartdata[finalartdata$Head.Count == datasetInput, ],
#                                      by(start = input$date[1], end = input$date[2]))
#             
#             CRN <- dfg[dfg$dffff == input$check, ]
#             Docent <- finalartdata[finalartdata$Class == input$checkcheck, ]
#             
#             ###variable for university classes, used a different dataframe for them
#             Date.date <- seq(as.Date(dfg[dfg$Date.date == input$check, ], by="month"))
#             Head.Count.count <- dfg[dfg$Head.Count.count == input$check, ]
#             CRN <- dfg[dfg$dffff == input$check, ]
#             
#             
#             ## do a seperate dataframe for walkindata as well so you can set the fill to the columns such as number of children, number of adults, etc etc
#             
#             
#      })
      
      output$plot1 <- renderPlot({
            
            # get data whenever input$parameters change
            data<-datasetInput()
                        
            pp <- ggplot(data, aes(x=Date, y=headCount,fill=CAT))+
                  geom_bar(stat="identity", position="dodge") +
                  geom_text(aes(label=headCount), vjust=1.5, colour="white",
                             position=position_dodge(.9), size=3)
            print(pp)
#KCL I disabled these for now but you can see how I did the plot above
            
#             if(input$parameters == "Type3")
#             {
#                   
#                   qq <- ggplot(dataFiltered, aes(x=Date, y=Head.Count)) +
#                         geom_bar(stat="identity", position="dodge", fill="lightblue", colour="black") +
#                         geom_text(aes(label=Head.Count), vjust=1.5, colour="white", size=5)
#                   print(qq) 
#             } 
#             
#             if(input$parameters == "Type1")
#             {
#                   tt <- ggplot(dataFiltered, aes(x=Date, y=Head.Count)) +
#                         geom_bar(stat="identity", position="dodge") +
#                         geom_text(aes(label=Head.Count), vjust=1.5, colour="white", size=5)
#                   print(tt) 
#             } 
#             
#             if(input$parameters == "Type4")
#             {
#                   mm <- ggplot(dataFiltered, aes(x=Date, y=Head.Count)) +
#                         geom_bar(stat="identity", position="dodge") +
#                         geom_text(aes(label=Head.Count), vjust=1.5, colour="white", size=5)
#                   print(mm) 
#             } 
#             
#             if(input$parameters == "Type5")
#             {
#                   ss <- ggplot(dataFiltered, aes(x=Date, y=Head.Count)) +
#                         geom_bar(stat="identity", position="dodge") +
#                         geom_text(aes(label=Head.Count), vjust=1.5, colour="white", size=5)
#                   print(ss) 
#             } 
#             
#             if(input$parameters == "Type6")
#             {
#                   yy <- ggplot(finalartdata[640:777,], aes(x=Date, y=Head.Count)) +
#                         geom_bar(stat="identity", position="dodge") +
#                         geom_text(aes(label=Head.Count), vjust=1.5, colour="white", size=5)
#                   print(yy) 
#             } 
#             
#             if(input$parameters == "Type7")
#             {
#                   bb <- ggplot(finalartdata[778:853,], aes(x=Date, y=Head.Count))
#                   + geom_bar(stat="identity", position="dodge") +
#                         geom_text(aes(label=Head.Count), vjust=1.5, colour="white", size=5)
#                   print(bb) 
#             } 
      })
      
      output$summary <- renderPrint({
            data<-datasetInput()
            summary(data[data$CAT == input$check, ])
      })
      
      output$table <- renderDataTable({
            data<-datasetInput()
            data.frame(x=data[data$CAT == input$check, ])
      })
      
      output$tableType <- renderDataTable({
            data<-datasetInput()
            data.frame(x=data)
      })
      
      output$sumNumbers <- renderPrint({ 
            data<-datasetInput()
            cat(noquote("total attendance: \n"))
            aggregate(headCount ~ Type, data=data, FUN=sum)
            
      })
      
})