

#' serviceCallPlanGenerator
#'
#' @param timeFactor dictates how fast experment runs
#'
#' @return List of attributes f0r calls
#' @export
#' currently this is a stub
#' @examples
userServiceCallPlanGenerator<-function(timeFactor=0.2){
  calls <-sample(3,1)
  
  
  startDelay <- sample(10,1) * timeFactor
  callNumber<-calls
  callDelay <- sample(calls) * timeFactor
  endpoint <- rep("mockEndpoint",calls)
  params <-sample(100,calls) # mocking 
  
  return(list(startDelay=startDelay,
              callNumber=callNumber,
              callDelay=callDelay,
              endpoint = endpoint,
              params = params))
}