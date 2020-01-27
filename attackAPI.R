library(httr)
library(foreach)

userIDCounter<-0


#' RunPopulation
#'
#' @param users number
#'
#' @return user objects
#' @export 
#' Processes a number of users to call the api subjected 
#' to a call manager
#' @examples
runPopulation <-function(users=5){
  return(
          runUsersSessions(
                genUsers(users)))
}

#' Title
#'
#' @param users list of user objects
#'
#' @return list of user objects with service responses
#' @export
#' This is a mutli threaded process to keep user decoupled
#' and act on call plan independently 
#' @examples
runUsersSessions <- function(users){
  
  threadsNumber <- length(users) 
  userCompletions <- list()

  foreach(i=1:threadsNumber) %dopar% {
    currUser <- users[[i]]
    Sys.sleep(currUser$startDelay)
    
   userCompletions<-append(userCompletions,list(userCalls(currUser)))

  }
  
  return(userCompletions)
}

#' userCalls
#'
#' @param currUser user Object
#'
#' @return user Object with a list of responses
#' @export
#'
#' @examples
userCalls <- function(currUser) {
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
#' @param number the number of users to create
#'
#' @return returns list of users
#' @export
#'
#' @examples
genUsers<-function(number){
  userIDCounter <<- 0
  users <- c()
  
   for (i in 1:number) {
     users <- c(users,list(genUser()))
   } 
  return(users)
}

#' genUser
#'
#' @return returns a user
#' @export
#' user are created with call plan
#' @examples
genUser<-function(){
  user <- append(serviceCallPlanGenerator(),c(id= userUniqueID()))

  return(user)
}

#' userUniqueID
#'
#' @return returns a unique user id
#' @export
#'
#' @examples
userUniqueID<-function(){
  userIDCounter <<- userIDCounter + 1
  return(userIDCounter)
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

  response <- GET("http://localhost:4444/",
                  path=endPointName, 
                   query=list(text=parIn))
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

#' serviceCallPlanGenerator
#'
#' @param timeFactor dictates how fast experment runs
#'
#' @return List of attributes f0r calls
#' @export
#' currently this is a stub
#' @examples
serviceCallPlanGenerator<-function(timeFactor=0.2){
  calls <-sample(3,1)
  
  
  startDelay <- sample(10,1) * timeFactor
  callNumber<-calls
  callDelay <- sample(calls) * timeFactor
  endpoint <- rep("mockEndpoint",calls)
  params <-sample(100,calls) # moching 
  
  return(list(startDelay=startDelay,
              callNumber=callNumber,
              callDelay=callDelay,
              endpoint = endpoint,
              params = params))
}






