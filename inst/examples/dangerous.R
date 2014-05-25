#! /usr/local/bin/R  

###  An example CGI script in R
###
###  This script processes R input from a form and formats the results
###  for display by the browser.
###
###  Graphs can be included (using the device "webPNG"), provided that
###  "graphDir" and "graphURLroot" have been set below.  These should 
###  point to a directory on which write permission is granted to the
###  web server, and which is "public" for web access.

graphDir <- "/Users/david/Sites/graphs/"
graphURLroot <- "/~david/graphs/"

tag(HTML)
    tag(HEAD)
        tag(TITLE)
            cat("Your results")
        untag(TITLE)
    untag(HEAD)
    
    tag(BODY)
        tag(PRE)

        commands <- parse(text = formData$commands)

        for (i in 1:length(commands)){
            tag(font, color = "red")
                cat(">", deparse(commands[[i]]), "\n")
            untag(font)
            tag(font, color = "blue")
                result <- eval(commands[i])
                if (!is.null(result) && result=="image") cat("\n")
                else if (!is.null(result)) print(result)
            untag(font)}

        untag(PRE)

    br(2)
    cat("Output produced at ", date())
    untag(BODY)
    
untag(HTML)
