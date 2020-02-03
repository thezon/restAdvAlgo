library(httr)
library(foreach)
library(doParallel)
source(file="clientSideAPI.R")
source(file = "agentGeneration.R")

registerDoParallel(cores=4) 

#' RunPopulation 
#'
#' @param users number
#'
#' @return user objects
#' @export 
#' Processes a number of users to call the api subjected 
#' to a call manager
#' @examples
runPopulation <-function(benevolentAgents=5, malevolentAgents=5){
  
  users <- genAgents(benevolentAgents,'b')
  attackers <- genAgents(malevolentAgents,'m')
  
  operatingAgents <- sample(c(users,attackers))
  
  return(runAgentSessions(operatingAgents))
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
runAgentSessions <- function(agents){
  
  threadsNumber <- length(agents) 
  
  agentResults<-foreach(i=1:threadsNumber, .combine='c', .multicombine=TRUE) %dopar% 
  {
    currAgent <- agents[[i]]
    Sys.sleep(currAgent$startDelay)
    
    list(agentCalls(currAgent))
  }
  
  return(agentResults)
}











