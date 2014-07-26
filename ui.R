
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(
      titlePanel("Art App"),
      
      sidebarLayout(
            sidebarPanel(
                  dateRangeInput("date", "choose a date range",
                                 start = "2011-01-01", end = "2014-7-30",
                                 format = "yyyy-mm-dd"),
                  
                  selectInput("parameters",
                              label="choose a type",
                              choices=dfg$CAT,
                              selected=NULL),
                  
                  conditionalPanel(
                        condition = "input.parameters == 'University classes'",
                        checkboxGroupInput("check", "CRN", choices = levels(dfg$CAT)
                        )),
                  conditionalPanel(
                        condition="input.parameters == 'Meeting (M) (Museum Related)'",
                        checkboxGroupInput("checkcheck", "SubCatagories",
                                           choices = list("docent" = "Docent"))
                  ),
                  conditionalPanel(
                        condition="input.parameters == 'Non Museum Meeting (NM)'",
                        checkboxGroupInput("checkcheckcheck", "SubCatagories",
                                           choices = list("PAS",
                                                          "University Communication and Marketing"))
                  ),
                  conditionalPanel(
                        condition="input.parameters == 'Non Museum related programs (NMP)'",
                        checkboxGroupInput("checkcheckcheck", "SubCatagories",
                                           choices = list("ILR", "Tai Chi"))
                  )
            ),
            mainPanel(
                  
                  tabsetPanel(
                        tabPanel("Plot", plotOutput("plot1")),
                        tabPanel("Summary", verbatimTextOutput("summary")),
                        tabPanel("Classes Table", dataTableOutput("table")),
                        tabPanel("Type Table", dataTableOutput("tableType")),
                        tabPanel("Walkin Table", dataTableOutput("tableWalkin")),
                        tabPanel("Sum", verbatimTextOutput("sumNumbers"))
                        
                  ))
      )
))