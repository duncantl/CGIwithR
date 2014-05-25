#! /usr/local/bin/R

tag(HTML)
    tag(HEAD)
        tag(TITLE)
            cat("An example R.cgi output page")
        untag(TITLE)
    untag(HEAD)
    comments("Some comments to be ignored by the web browser")

    lf(2)

    tag(BODY, bgcolor = "yellow")
        lf(2)
        tag(h3)
            cat("A large heading")
        untag(h3)

        lf(2)

        tag(p)
            cat("Your words in italics:")
            tag(i)
                cat(formData$words)
            untag(i)
        untag(p)

        lf(2)

        tag(p)
            cat("Your numbers:")
            tag(pre)
                numbers <- as.numeric(scanText(formData$numbers))
                print(numbers)
            untag(pre)
        untag(p)

        lf(2)

        cat("Here is a graph:") ; br()
        graphDir <- "/Users/david/Sites/graphs/"
        graphURLroot <- "/~david/graphs/"
        webPNG("temp.png")
        plot(numbers)
        img(src = "temp.png") ; br(2)

        lf(2)

        cat("The author is ")
        mailto("David Firth", "david.firth@nuffield.ox.ac.uk")
        cat(" and here is his ")
        linkto("website.", "http://www.stats.ox.ac.uk/~firth/") ; br()

        lf()

        tag(p)
            cat("Output produced at ", date())
        untag(p)

        lf()

    untag(BODY)

    lf()

untag(HTML)

lf()
    
