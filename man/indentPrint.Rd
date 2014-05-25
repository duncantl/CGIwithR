\name{indentPrint}
\alias{indentPrint}
\title{Print an Object with Indentation}
\description{
  Allows the printed representation of an R object to be indented by
  a specified number of spaces.
}
\usage{
indentPrint(object, indent=4, ...)
}
\arguments{
  \item{object}{An R object}
  \item{indent}{The number of spaces to indent; default 4}
  \item{\dots}{Other arguments to be passed to \code{print}}
}
\value{
  \code{invisible(object)}
}
\author{David Firth \email{d.firth@warwick.ac.uk}}
\examples{
indentPrint(1:4,indent=10)
}
\keyword{interface}
