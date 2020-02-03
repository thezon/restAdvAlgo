port <- 4444
url<-"http://localhost:"
urlFormatType <- "path"


#' userCalls
#'
#' @param currUser user Object
#'
#' @return user Object with a list of responses
#' @export
#'
#' @examples
agentCalls <- function(currUser) {
  userResponses <- list()
  
  for (j in 1:currUser$callNumber) {
    userCallResp <- restCall(currUser$params[j], currUser$endpoint[j])
    userResponses <- append(userResponses, list(userCallResp))
    Sys.sleep(currUser$callDelay[j])
  }
  currUser$response <- userResponses
  return(currUser)
}

#' Title
#'
#' @param parIn value as parameter ***note this will change
#' @param endPointName end point to call
#'
#' @return response object from the endpoint
#' @export
#'
#' @examples
restCall <- function(parIn,endPointName){
  
  if(urlFormatType=="standard"){
    response <- GET(paste(url,port,"/",sep = ""),
                    path=endPointName, 
                    query=list(text=parIn))
  }
  else if(urlFormatType=="path"){
    
    if(length(parIn)>1)
      print("warning: in url creation mutliple params not configured")
    
    response <- GET(url = paste(url,port,"/",endPointName,"/",parIn, sep = ""))
    }else{
    print("failure on url format type. truncating params")
    response <- GET(url = paste(url,port,"/",endPointName,"/"))
  }
    
  
  return(response)
}


  
  

#' Title
#'
#' @param response response object to extract content ** this wil change
#'
#' @return text
#' @export
#'
#' @examples
restCallAnalysis <-function(response){
  tryCatch(
    lapply(response,FUN = httr::content),
    error = function(e) {print(e)}
  )
}