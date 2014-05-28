\name{incPercentile}

\alias{incPercentile}

\title{Estimation of weighted percentiles}

\description{
The function computes the estimates of weighted percentiles.
}

\usage{
incPercentile(inc, weights = NULL, sort = NULL,
  Dom = NULL, k = c(20, 80), dataset = NULL, na.rm = FALSE)
}

\arguments{
  
  \item{inc}{Study variable (for example equivalized disposable income). One dimentional object convertable to one-column \code{data.frame} or variable name as character, column number or logical vector with only one \code{TRUE} value (length of the vector has to be the same as the column count of \code{dataset}).}
  
  \item{weights}{Optional weight variable. One dimentional object convertable to one-column \code{data.frame} or variable name as character, column number or logical vector with only one \code{TRUE} value (length of the vector has to be the same as the column count of \code{dataset}).}
  
  \item{sort}{Optional variable to be used as tie-breaker for sorting. One dimentional object convertable to one-column \code{data.frame} or variable name as character, column number or logical vector with only one \code{TRUE} value (length of the vector has to be the same as the column count of \code{dataset}).}
  
  \item{Dom}{Optional variables used to define population domains. If supplied, the estimates of percentiles are computed for each domain. An object convertable to \code{data.frame} or variable names as character vector, column numbers or logical vector (length of the vector has to be the same as the column count of \code{dataset}).}
  
  \item{k}{A vector of integers between 0 and 100 specifying the percentiles to be computed (0 gives the minimum, 100 gives the maximum).}
  
  \item{dataset}{Optional survey data object convertable to \code{data.frame}.}

  \item{na.rm}{A logical value indicating whether missing values in study variable should be removed.}
}

\value{
A numeric vector (if \code{Dom} is \code{NULL}) or a data.frame (if \code{Dom} is not \code{NULL}) containing the estimates of weighted income percentiles specified by \code{k}.
}

\references{
Working group on Statistics on Income and Living Conditions (2004) Common cross-sectional EU indicators based on EU-SILC; the gender pay gap. \emph{EU-SILC 131-rev/04}, Eurostat.
}

\examples{
data(eusilc)
incPercentile("eqIncome", weights = "rb050",
  Dom = "db040", data = eusilc)
}

\seealso{
\code{\link{linarpt}}, \code{\link{linarpr}}, \code{\link{linqsr}}
}

\keyword{Linearization}