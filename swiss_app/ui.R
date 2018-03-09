library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Swiss Fertility and Socioeconomic Indicators (1888) Data"),
  p("Standardized fertility measure and socio-economic indicators for each of 47 French-speaking provinces of Switzerland at about 1888."),
  p("Includes a data frame with 47 observations on 6 variables, each of which is in percent, i.e., in [0, 100]."),
  
  tabsetPanel(type = "tabs",
              tabPanel("Viewing the Data", br(),
                       h3("Here we can explore the data and see how the data is distributed and related:"),
                       sidebarLayout(
                         sidebarPanel(

                           selectInput("selectx", h3("Select x-variable"),
                                       choices = list("Agriculture" = 1, "Examination" = 2,
                                                      "Education" = 3, "Catholic" = 4, "Infant.Mortality" = 5)),
                           selectInput("selecty", h3("Select y-variable"),
                                       choices = list("Fertility" = 0, "Agriculture" = 1, "Examination" = 2,
                                                      "Education" = 3, "Catholic" = 4, "Infant.Mortality" = 5)),
                           radioButtons("radio", h3("Select fit method"),
                                        choices = list("Loess" = 1, "GLM" = 2)),
                           submitButton("Submit")
                         ),
                         mainPanel(plotOutput("distPlot"))
                       )
                       
              ),
              tabPanel("Fitting a Model", br(),
                       h3("Here we are fitting a predictive model for Fertility using the selected features:"),
                       sidebarLayout(
                         sidebarPanel(
                           sliderInput("testsize",
                                       "Percentage of data set aside for testing/holdout:",
                                       min = 1,
                                       max = 50,
                                       value = 30),
                           checkboxGroupInput("checkGroup",
                                       h3("Features to Include"),
                                       choices = list("Agriculture" = "Agriculture",
                                                      "Examination" = "Examination",
                                                      "Education" = "Education",
                                                      "Catholic" = "Catholic",
                                                      "Infant Mortality" = "Infant.Mortality"),
                                       selected = "Agriculture"),
                           radioButtons("radio1", h3("Select fit method"),
                                        choices = list("GLM" = 1, "KNN" = 2, "RF" = 3)),
                           submitButton("Fit Model")
                         ),
                         mainPanel(h4("Plot of predicted vs. actual values for Fertility in test set"),
                                   p("The Mean Squared Error is reported in red on the plot"),
                                   plotOutput("residPlot"))
                         
                       )
              )
  )

  

))
