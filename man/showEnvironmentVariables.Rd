\name{showEnvironmentVariables}
\alias{showEnvironmentVariables}
\alias{writeRequestInfo}

\title{Utility functions for adding information about the request itself.}
\description{
  These two functions provide facilities for adding information to the
  output about the
  request and the environment variables for the call.
  \code{writeRequestInfo} displays information about this
  package (name and version) and the query string for the
  query/request.
}
\usage{
showEnvironmentVariables(env = Sys.getenv())
writeRequestInfo(env = c("PATH_INFO", "HTTP_HOST", "HTTP_USER_AGENT",
                         "HTTP_REFERER", "REMOTE_ADDR"),
                 size = -1)
}

\arguments{
  \item{env}{either a character vector with names which are assumed to
    be the evironment variable name - value pairs,
    or alternatively, a character vector of environment variable
    names which are then queried to find the current values.
    For \code{writeRequestInfo}, to turn off the output of the
    environment variables, specify a value of \code{FALSE}.
  }
  \item{size}{an integer value which is used as the value for the
    attribute size in the HTML element font to specify how
    large the text should be for the content in this section.}
}
\value{
  Both functions return the value of
  \code{env}, after any expansion to compute the
  values of the environment variables.
  In the case of \code{writeRequestInfo}, if \code{env} is
  \code{FALSE}, this is the value returned.}

\references{}

\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}

\seealso{
 \code{\link{img}},  \code{\link{tag}}, etc.
}
\examples{
   # The default behaviour
 writeRequestInfo()

  # Show only FORM_DATA
 writeRequestInfo("FORM_DATA")

  # named character vector of variable name=value pairs
 writeRequestInfo(c("myValue" = "foo"))

  # Don't show any environment variables.
 writeRequestInfo(character(0))
}
\keyword{interface}
\keyword{programming}
