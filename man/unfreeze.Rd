% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/knowledge.R
\name{unfreeze}
\alias{unfreeze}
\title{Unfreeze a \code{knowledge} object.}
\usage{
unfreeze(.kn)
}
\arguments{
\item{.kn}{A \code{knowledge} object.}
}
\value{
The same \code{knowledge} object with the \code{frozen} attribute set to \code{FALSE}.
}
\description{
This allows you to add new variables to the \code{knowledge} object,
even though it was frozen earlier by adding a data frame to the knowledge
constructor \code{knowledge()}.
}
