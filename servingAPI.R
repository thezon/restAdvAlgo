library(plumber)
library(logging)

basicConfig()

intelligentSecurity <- function (...){
  logdebug(paste("hit: ",...))
}


#* @apiTitle Simple API

#* Echo provided text
#* @param text The text to be echoed in the response
#* @get /mockEndpoint
function(text = "No Parameter") {
  intelligentSecurity(text)
  
  list(
    message_echo = paste("The text is:", text)
  )
}


#* @apiTitle Simple API

#* Echo provided text
#* @param text The text to be echoed in the response
#* @get /home
function() {
  intelligentSecurity(text)
  
  list(
    message_echo = paste("Welcome to the landing page")
  )
}



# how to run ~ https://www.rplumber.io/
#plumb("servingAPI.R")$run(port = 4444)

