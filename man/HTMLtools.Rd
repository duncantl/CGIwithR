\name{HTMLtools}

\title{Utility Functions for Writing in HTML}

\alias{CGIwithR}
\alias{HTMLheader}
\alias{HTMLfooter}
\alias{tag}
\alias{untag}
\alias{comments}
\alias{br}
\alias{linkto}
\alias{mailto}
\alias{img}
\alias{lf}

\description{
  These functions provide shorthand ways of sending simple
  HTML constructions to standard output.
  }

\usage{
HTMLheader(title = character(0), css = character(0))
tag(tagname, ...)
untag(tagname)
comments(text)
br(n = 1)
linkto(text, URL)
mailto(text, address)
img(src, ..., graphURLroot)
lf(n = 1)
}
\arguments{
  \item{tagname}{an HTML tag identifier, such as \code{PRE}, 
     \code{BODY}, \code{B}, etc.  If 
     \code{getOption("useUnquotedTagnames")}
     is \code{TRUE} (the default, which can be unset by
     \code{options(useUnquotedTagnames = FALSE)}), 
     tag names do not need to be
     quoted, for example \code{tag(PRE)} can be used in place
     of \code{tag("PRE")}.  Otherwise \code{tagname}
     should be a character string.}
  \item{\dots}{HTML qualifier(s) such as \code{color="red"}}
  \item{text}{a character string}
  \item{URL}{the target URL for an HTML anchor}
  \item{address}{the email address in a \code{mailto:} construction}
  \item{n}{an integer number of linefeeds  or <BR>s to insert 
           in the output}
  \item{src}{a character string, the URL for the image}
  \item{graphURLroot}{a character string giving the name of the
    directory in the Web site to in which the image file is located.
    This is not the actual directory in the file system, but rather
    the name of the directory as seen by a Web client.}
  \item{title}{a character vector whose contents are collapsed into a
    single string (separated by spaces) and inserted into an HTML
     title}
  \item{css}{a character vector giving the file names or URIs of the Cascading Style
    Sheet files to load for the HTML document.
    For each element, a
    \code{<LINK rel="stylesheet" type="text/css" HREF=...>}
    is inserted into the HEAD element of the HTML document.
    For elements that have a name, the name is treated as the
    value of the MEDIA attribute and added to the LINK element.
  }  
}
\value{
 None (\code{invisible(NULL)}), except for \code{img} which returns 
 \code{invisible("image")}
}
\details{
  These functions are all shorthand wrappers for commonly-used HTML
  constructions.  Each simply outputs a piece of HTML code.  Any of
  these can be done manually instead (using \code{cat}, for example)
  if something nonstandard is required.
  
  \code{HTMLheader()} writes out the DOCTYPE, HTML, HEAD and start of
  the BODY element in the document. If \code{title} or \code{css}
  are specified in the call, then the corresponding elements are added
  to the HEAD element.

  \code{HTMLfooter} closes the BODY and HTML tags at the end of the document.
  
  \code{tag} and \code{untag} supply field signifiers such as 
  \code{<BODY>} and \code{</BODY>}.
  
  \code{comments} puts text inside the HTML comment markers 
  \code{<!--} and \code{-->}.
  
  \code{br} outputs a \code{<BR>} (or more than one if \code{n} is 
          greater than 1).
  
  \code{lf(n)} inserts \code{n} linefeeds into the output.
  
  \code{linkto, mailto, img} provide the standard HTML anchor, email
  and image insertion.  For \code{img}, note that the source URL
  \code{src} is defined relative to \code{graphURLroot} if that
  is defined.  For example, if \code{graphURLroot} is
  \code{"/home/david/graphs/"}
  then \code{img("mypic.png")} will output 
  \code{<IMG SRC="/home/david/graphs/mypic.png">}.  (Actually, a
  random query string is added to the URL by \code{img}
  to ensure that browsers do not display old, cached
  versions of graphs.)
}  
  

\author{David Firth \email{d.firth@warwick.ac.uk}}

\examples{

useUnquotedTagnames <- TRUE

testpage<-function(){
    tag(HTML)
        tag(HEAD)
            tag(TITLE)
                cat("An example HTML page")
            untag(TITLE)
        untag(HEAD)
        lf()
        comments("Some comments to be ignored by the web browser")
        lf(2)
        tag(BODY, bgcolor = "yellow")
        lf(2)
        tag(h1)
            cat("A large heading")
        untag(h1)
        lf(2)
        tag(p)
            cat("A table of results:")
            tag(pre)
                lf()
                indentPrint(data.frame(Est = c(1.23,3.45),
                                       StErr = c(0.86,0.78),
                                       row.names = c("b0","b1")))
                lf()
            untag(pre)
        untag(p)
        lf(2)
        cat("Here is a graph:") ; br()
        img(src="http://www.stats.ox.ac.uk/~firth/CGIwithR/test.png") ; br(2)
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
    }
    
# sink("temp.html")
testpage()

## The output if pasted into a file should be viewable by
## a web browser.  Or if the \code{sink("temp.html")} was done, 
## just view temp.html in the web browser.
    
}
\keyword{interface}
