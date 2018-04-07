#install.packages( "rjson" )
#install.packages( "dplyr" )
#install.packages( "tseries" )
#install.packages( "forecast" )
#install.packages( "cvTools" )

library(rjson)
library(dplyr)
library(ggcorrplot)
library(tseries)
library(forecast)
library(cvTools)

#---------------------------------------------------------------------------
# time_series -> time series analysis
#
# arguments: df -> data frame
#--------------------------------------------------------------------------
time_series <- function( df ){
  
  #groups values by date
  dfSeries <- group_by( df , DIA ) %>% summarise( TOTAL = sum(TOTAL) )
  
  #create time-series object
  series <- ts( dfSeries$TOTAL , class="ts" )
  
  #plot time series 
  ts.plot( series )
  
  #hypothesis test
  adf.test( series )
  
  #autocorrelation and partial autocorrelation analysis
  par( mfrow=c(1,2) )
  acf( series )
  pacf( series )

  #auto-regressive model
  modelo <- arima( series , order = c(3,0,0), fixed = c(0,0,NA,NA), method = c("ML"))  
  
  #statistical test
  coeficientes <- modelo$coef
  se <- round(sqrt(diag(modelo$var.coef)), digits= 4)
  estatistica <- coeficientes/se
  
  #residual analysis
  par(mfrow=c(1,2))
  acf(residuals(modelo))
  pacf(residuals(modelo))
  
  #forecast for the next week
  fcast <- forecast(modelo, 6)
  summary( fcast )
  fcastWeek <- sum( fcast$mean )
  
  return( fcastWeek )
}

#---------------------------------------------------------------------------
# linear_regression -> linear regression analysis
#
# arguments: df -> data frame
#--------------------------------------------------------------------------
linear_regression <- function( df ){
  
  #remove outliers from data frame
  df <- clean_data( df )
  
  #correlation analysis between the products and the total value
  correlation_analysis( df )
  
  #create linear model
  model <- lm( df$TOTAL ~ df$BUFFET+df$REFRIGERANTE+df$AGUA+df$CERVEJA+df$SUCO , df )
  
  #statistical analysis
  summary( model )
  
  #create 10 folders for cross validation
  folds <- cvFolds( nrow( df ) , K = 10 , type = "random" )
  
  #Root Mean Square Error
  rmse <- 0
  
  #cross validation
  for(i in 1:folds$K ){
    
    #test set
    test <- df[folds$subsets[which(folds$which == i)],] 
    
    #training set
    train <- df[folds$subsets[which(folds$which != i)],] 
    
    #training
    model <- lm( TOTAL ~ BUFFET+REFRIGERANTE+AGUA+CERVEJA+SUCO , data=train )
    
    #predict test set
    predict <- predict(  model , test[,-c(1)] )
    
    #measures of the predict accuracy
    ac <- accuracy( predict , test$TOTAL )
    
    #Root Mean Square Error
    rmse <- rmse + ac[1,2]
    
  }
  
  #mean rmse
  rmse <- rmse/folds$K 
  
  #return rmse
  return( rmse )
}

#---------------------------------------------------------------------------
# correlation_analysis -> correlation analysis between the products and the total value
#
# arguments: df -> data frame
#--------------------------------------------------------------------------
correlation_analysis <- function( df ){
  
  #remove day
  dfCor <- df[,-c(2)] 

  #correlation matrix: products and total value
  corMat <- cor( dfCor )
  
  #plot correlation matrix
  ggcorrplot( corMat , hc.order = TRUE , outline.col = "white" )
  
}

#---------------------------------------------------------------------------
# convert_df -> remove outliers from data frame
#
# arguments: df -> data frame
#
# Return: clean data frame
#--------------------------------------------------------------------------
clean_data <- function( df ){
  
  #analysis of statistical measures
  summary( df )
  
  #analysis of outliers
  boxplot( df$TOTAL )
  
  #Get outliers
  stats <- boxplot.stats( df$TOTAL , coef = 1.5 )
  
  #analysis of statistical measures
  stats$stats
  
  #remove outliers
  df <- df[ !( df$TOTAL %in% stats$out ) , ]
  
  #analysis of outliers
  boxplot( df$TOTAL )
  
  #return clean data frame
  return( df )
  
}

#---------------------------------------------------------------------------
# convert_df -> converts data frame to new format
#
# arguments: df -> data frame
#
# Return: converted data frame
#--------------------------------------------------------------------------
convert_df <- function( df ){
  
  #get list of products to create the columns of the data frame
  vProd0 <- unique( df$dets.prod.xProd )
  vProd1 <- unique( df$dets.prod.xProd.1 ) 
  vProd2 <- unique( df$dets.prod.xProd.2 )
  vProd4 <- unique( df$dets.prod.xProd.4 )
  vProd3 <- unique( df$dets.prod.xProd.3 )
  vProd5 <- unique( df$dets.prod.xProd.5 )
  vProd6 <- unique( df$dets.prod.xProd.6 )
  vProd7 <- unique( df$dets.prod.xProd.7 )
  vProd8 <- unique( df$dets.prod.xProd.8 )
  vProd9 <- unique( df$dets.prod.xProd.9 )
  
  vProd <- c( vProd0 , vProd1 , vProd2 , vProd3 , vProd4 , vProd5 , vProd6 , vProd7 , vProd8 , vProd9 )
  vProd <- unique( vProd )
  vProd <- vProd[ -c( 5 , 9 , 21 , 22 , 26 ) ]
  
  vColumns <- c( "TOTAL" , "DIA" )
  
  for( p in vProd ){
    vColumns <- c( vColumns , p )
  }
  
  #create new data frame
  dfNew <- data.frame( matrix( 0 , ncol = length( vColumns ) , nrow = nrow( df ) ) )
  
  colnames( dfNew ) <- vColumns
  
  #converts data
  for( x in 1:nrow( df ) ){
    
    dfNew[x,"TOTAL"]    <- df[x,"valorTotal"]
    dfNew[x,"DIA"]      <- as.numeric( substr( df[x,"ide..date"] , 9 , 10 ) )

    for( y in 0:9 ){
      
      if( y == 0 ){
        cFieldProd  <- "dets.prod.xProd"
        cFieldQuant <- "dets.prod.qCom"
      }
      else{
        cFieldProd  <- paste( "dets.prod.xProd" , as.character( y ) , sep = "." )
        cFieldValue <- paste( "dets.prod.vProd" , as.character( y ) , sep = "." )
        cFieldQuant <- paste( "dets.prod.qCom"  , as.character( y ) , sep = "." )
      }
      
      if( !is.null( df[x,cFieldProd] ) ){ 
        
        if( !is.na( df[x,cFieldProd] ) ){
          
          cQProduct <- as.character( df[x,cFieldProd] ) 
          
          if( ( df[x,cFieldProd] == "CERVEJA LATA" ) | ( x == 820 & y == 9 ) ){
            dfNew[x,"CERVEJA"] <- dfNew[x,"CERVEJA"] + df[x,cFieldQuant]
          }
          else if( df[x,cFieldProd] == "LIMONADA" ){
            dfNew[x,"SUCO"] <- dfNew[x,"SUCO"] + df[x,cFieldQuant]
          } 
          else if( df[x,cFieldProd] == "BULE CHA" ){
            dfNew[x,"CHA"] <- dfNew[x,"CHA"] + df[x,cFieldQuant]
          }
          else if( cQProduct %in% colnames( dfNew ) ){
            dfNew[x,cQProduct] <- dfNew[x,cQProduct] + df[x,cFieldQuant]
          }
        }
      }
    } 
  }
  
  #return new data frame
  return( dfNew )
}

#---------------------------------------------------------------------------
# import_df -> import date frame from a json file
#
# Return: data frame
#--------------------------------------------------------------------------
import_df <- function( ){
  
  #open json file
  json_data <- fromJSON( paste( readLines( file.choose( ) ) , collapse = "" ) )
  
  #create data frame
  df<- data.frame( )
  
  #import data from jsom file to data frame
  for( i in 1:length( json_data ) ){
    df <- bind_rows( df , as.data.frame( json_data[[i]] ) )
  }
  
  #return data frame
  return( df )
}

#---------------------------------------------------------------------------
# main -> main function
#--------------------------------------------------------------------------
main <- function( ){
  
  #import data frame from a json file
  df <- import_df( )  
  
  #converts data frame to new format used in the analysis
  df <- convert_df( df )
  
  #creates and validates prediction model of how much a customer will spend
  rmse <- linear_regression( df )
  
  #sales forecast for the next week
  fcast <- time_series( df )
  
}
 