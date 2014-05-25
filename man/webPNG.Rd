\name{webPNG}
\alias{webPNG}
\title{A Wrapper for the `bitmap' Graphics Device}
\description{
  \code{webPNG} sets up a bitmap graphics device for graphs drawn within
  a CGI script.  
}
\usage{
webPNG(file, ..., graphDir)
}
\arguments{
  \item{file}{A filename, as a character string}
  \item{\dots}{Any other arguments to \code{bitmap}}
  \item{graphDir}{the name of the directory in which to create the 
    image file. If this is missing, the global variable
    of the same name is used. This argument therefore allows one
    to use a value specific to an individual call.  See
    \code{\link{img}} also.
  }
}
\details{
  Before \code{webPNG} is called, the variable 
  \code{graphDir} must be a character string giving the location
  where graphics files will be written by R and found by the web server.
  The directory specified in \code{graphDir} must be writeable and 
  readable by the web server in order to work.  For example, if 
  \code{graphDir} is \code{"/users/david/public_html/graphs/"} (note
  the trailing \code{/}!), and if \code{file} is \code{"mygraph.png"}, 
  the next graph will be written to 
  \code{"/users/david/public_html/graphs/mygraph.png"}, provided that
  \code{/users/david/public_html/graphs} has suitable permissions.
}
\value{
  None (\code{invisible(NULL)})
}
\author{David Firth \email{d.firth@warwick.ac.uk}}

\seealso{\code{\link{img}}}

\examples{
\dontrun{
  graphDir <- "/users/david/public_html/graphs/"
  webPNG("mygraph.png")
  ## then do whatever plotting is required...


  # Or, creating a JPEG image and specifying the output directory
  # in the call rather than via the global variable.
  webPNG("mygraph.png", type = "jpeg", graphDir = "/users/david/public_html/graphs/")
  }
}
\keyword{interface}
\keyword{device}
