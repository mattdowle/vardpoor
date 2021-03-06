\name{linrmir}

\alias{linrmir}

\title{Linearization of the relative median income ratio}

\description{
Estimates the relative median income ratio (defined as the ratio of the median equivalised disposable income of people aged above age  to the median equivalised disposable income of those aged below 65) and computes linearized variable for variance estimation.
}


\usage{
linrmir(Y, id = NULL, age,
  weight = NULL,
  sort = NULL,
  Dom = NULL,
  period = NULL,
  dataset = NULL,
  order_quant = 50L,
  var_name = "lin_rmir",
  checking = TRUE)
}


\arguments{
\item{Y}{Study variable (for example equalized disposable income). One dimensional object convertible to one-column \code{data.table} or variable name as character, column number.}

\item{id}{Optional variable for unit ID codes. One dimensional object convertible to one-column \code{data.table} or variable name as character, column number.}

\item{weight}{Optional weight variable. One dimensional object convertible to one-column \code{data.table} or variable name as character, column number.}

\item{age}{Age variable. One dimensional object convertible to one-column \code{data.table} or variable name as character, column number.}

\item{sort}{Optional variable to be used as tie-breaker for sorting. One dimensional object convertible to one-column \code{data.table} or variable name as character, column number.}

\item{Dom}{Optional variables used to define population domains. If supplied, linearization of at-risk-of-poverty threshold is done for each domain. An object convertible to \code{data.table} or variable names as character vector, column numbers as numeric vector.}

\item{period}{Optional variable for survey period. If supplied, linearization of at-risk-of-poverty threshold is done for each survey period. Object convertible to \code{data.table} or variable names as character, column numbers as numeric vector.}

\item{dataset}{Optional survey data object convertible to \code{data.table}.}
 
\item{order_quant}{A numeric value in range \eqn{\left[ 0,100 \right]}{[0,100]} for \eqn{\alpha} in the formula for at-risk-of-poverty threshold computation:
\deqn{\frac{p}{100} \cdot Z_{\frac{\alpha}{100}}.}{Z(\alpha/100).}
For example, to compute the relative median income ratio to some percentage of median income, \eqn{\alpha} should be set equal to 50.}

\item{var_name}{A character specifying the name of the linearized variable.}

\item{checking}{Optional variable if this variable is TRUE, then function checks data preparation errors, otherwise not checked. This variable by default is TRUE.}

}


\details{The implementation strictly follows the Eurostat definition.}


\value{
A list with four objects are returned:
    
\item{value}{A \code{data.table} containing the estimated relative median income ratio.}
  
\item{lin}{A \code{data.table} containing the linearized variables of the relative median income ratio.}

}


\references{
Working group on Statistics on Income and Living Conditions (2015) Task 5 - Improvement and optimization of calculation of net change. \emph{LC- 139/15/EN}, Eurostat. \cr
  
Jean-Claude Deville (1999). Variance estimation for complex statistics and estimators: linearization and residual techniques. Survey Methodology, 25, 193-203, URL \url{http://www.statcan.gc.ca/pub/12-001-x/1999002/article/4882-eng.pdf}. \cr
}

\seealso{
\code{\link{varpoord}} , \code{\link{vardcrospoor}}, \code{\link{vardchangespoor}}}


\examples{
data(eusilc)

dati <- data.table(IDd = paste0("V", 1 : nrow(eusilc)), eusilc)

# Full population
d <- linrmir(Y = "eqIncome", id = "IDd",  age = "age",
             weight = "rb050", Dom = NULL,  
             dataset = dati, order_quant = 50L)
d$value

\dontrun{
# By domains
dd <- linrmir(Y = "eqIncome", id = "IDd", age = "age",
              weight = "rb050", Dom = "db040",
              dataset = dati, order_quant = 50L)
dd}
}


\keyword{Linearization}
