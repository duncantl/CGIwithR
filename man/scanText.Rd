\name{scanText}
\alias{scanText}
\title{Scan a Character String}
\description{
  Useful for converting data entered via a HTML textarea, for example, 
  into a list or vector for further processing.
}
\usage{
scanText(string, what = character(0), \dots)
}
\arguments{
  \item{string}{A character string, typically numbers or words 
    separated by white space}
  \item{what}{As for \code{scan}.  The type of \code{what} gives the 
    type of data to be read.  If
    \code{what} is a list, it is assumed that the lines of the data
    file are records each containing \code{length(what)} items
    (``fields'').  The supported types are \code{logical}, \code{integer},
    \code{numeric}, \code{complex}, \code{character} and 
    \code{list}: \code{list} values
    should have elements which are one of the first five types
    listed or \code{NULL}.}
  \item{\dots}{Other arguments to be passed to \code{scan}}
}
\value{
  A list or vector.
}
\author{David Firth \email{d.firth@warwick.ac.uk}}
\examples{
scanText("A few short words")
as.numeric(scanText("1 2 3\n89 90"))
scanText("A B C \n 4 5 6", what = list("A", "A", "A", 0, 0, 0))
}
\keyword{interface}
