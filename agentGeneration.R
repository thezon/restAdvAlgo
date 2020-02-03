source(file = "userActionPlanner.R")
source(file = "attackerActionPlanner.R")

userIDCounter<-0


#' userUniqueID
#'
#' @return returns a unique user id
#' @export
#'
#' @examples
agentUniqueID<-function(){
  userIDCounter <<- userIDCounter + 1
  return(userIDCounter)
}


#' genUser
#'
#' @return returns a user
#' @export
#' user are created with call plan
#' @examples
genAgent<-function(intent){
  
  if(intent=='b')
    serviceCallPlanGenerator<-userServiceCallPlanGenerator
  else 
    serviceCallPlanGenerator<-attackerServiceCallPlanGenerator
  
  user <- append(serviceCallPlanGenerator(),c(id= agentUniqueID(),intent=intent))
  
  return(user)
}

#' Title
#'
#' @param number the number of users to create
#'
#' @return returns list of users
#' @export
#'
#' @examples
genAgents<-function(number,intent){
  userIDCounter <<- 0
  users <- c()
  
  for (i in 1:number) {
    users <- c(users,list(genAgent(intent)))
  } 
  return(users)
}
