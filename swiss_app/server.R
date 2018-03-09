library(shiny)
library(ggplot2)
library(caret)
library(randomForest)
data(swiss)

shinyServer(function(input, output) {

     
  output$distPlot <- renderPlot({
    
    if (input$selectx == 1) {
      x <- swiss$Agriculture
      xlab <- 'Agriculture'}
    if (input$selectx == 2) {
      x <- swiss$Examination
      xlab <- 'Examination'}
    if (input$selectx == 3) {
      x <- swiss$Education
      xlab <- 'Education'}
    if (input$selectx == 4){
      x <- swiss$Catholic
      xlab <- 'Catholic'}
    if (input$selectx == 5) {
      x <- swiss$Infant.Mortality
      xlab <- 'Infant Mortality'}

    
    if (input$selecty == 0) {
      y <- swiss$Fertility
      ylab <- 'Fertility'}    
    if (input$selecty == 1) {
      y <- swiss$Agriculture
      ylab <- 'Agriculture'}
    if (input$selecty == 2) {
      y <- swiss$Examination
      ylab <- 'Examination'}
    if (input$selecty == 3) {
      y <- swiss$Education
      ylab <- 'Education'}
    if (input$selecty == 4){
      y <- swiss$Catholic
      ylab <- 'Catholic'}
    if (input$selecty == 5) {
      y <- swiss$Infant.Mortality
      ylab <- 'Infant Mortality'}
    
    mod_lm <- lm(y~x)
    
    p <- qplot(x,y,xlab=xlab,ylab=ylab,main = "Scatterplot and Fit for all columns in Swiss Dataset")
    if (input$radio == 1){
      p <- p + geom_smooth(method = "loess")
    }
    if (input$radio == 2){
      p <- p + geom_smooth(method = "glm")
    }
    p
  })
  output$features <- renderText(input$checkGroup)
  #model <- reactive({
  output$residPlot <- renderPlot({
    cols <- input$checkGroup
    x <- swiss[,c("Fertility", cols)]
    mod_lm <- lm(Fertility ~ ., data = x)
    set.seed(39592)
    trainsize <- (100-input$testsize)/100
    fold <- createDataPartition(x$Fertility, p=trainsize, list = F)
    train <- x[fold,]
    test <- x[-fold,]
    mod_glm <- train(Fertility~.,data = train,method='glm')
    mod_knn <- train(Fertility~.,data = train,method='knn')
    mod_rf <- train(Fertility~.,data = train,method='rf')
    
    pred_glm <- predict(mod_glm, newdata=test)
    pred_knn <- predict(mod_knn, newdata=test)
    pred_rf <- predict(mod_rf, newdata=test)
    
    r2_glm <- (sum((pred_glm-test$Fertility)^2))/length(test)
    r2_glm <- paste0('MSE = ',r2_glm)
    r2_knn <- (sum((pred_knn-test$Fertility)^2))/length(test)
    r2_knn <- paste0('MSE = ',r2_knn)
    r2_rf <- (sum((pred_rf-test$Fertility)^2))/length(test)
    r2_rf <- paste0('MSE = ',r2_rf)
    
    if(input$radio1==1){
      p <- qplot(test$Fertility,pred_glm)
      p <- p + annotate("text", label = r2_glm, x = 75, y = 80, size = 6, colour = "red")
    }
    if(input$radio1==2){
      p <- qplot(test$Fertility,pred_knn)
      p <- p + annotate("text", label = r2_knn, x = 75, y = 80, size = 6, colour = "red")
    }
    if(input$radio1==3){
      p <- qplot(test$Fertility,pred_rf)
      p <- p + annotate("text", label = r2_rf, x = 75, y = 80, size = 6, colour = "red")
    }
    p <- p + geom_smooth(method = loess)

    p
  })
  output$names <- renderText({
    if(is.null(model())){
      "No Model Found"
    } else {
      #summary(model())$r.squared
      #model()
    }
  })
})
