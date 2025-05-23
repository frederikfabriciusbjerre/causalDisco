% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/knowledge.R
\name{.parse_tier}
\alias{.parse_tier}
\title{Resolve a tier specification to an index or (new) label}
\usage{
.parse_tier(.kn, tier)
}
\arguments{
\item{.kn}{A \code{knowledge} object.}

\item{tier}{A symbol, character string, or single positive integer.}
}
\value{
A named list with components
\itemize{
\item \code{idx}   \code{integer(1)} — resolved tier index (or \code{NA} if the label is new)
\item \code{label} \code{character(1)}|\code{NULL} — the label if one was supplied
}
}
\description{
Turns the user-supplied \code{tier} argument of \strong{\code{add_to_tier()}} into a
deterministic result:
\itemize{
\item \strong{Numeric literal} (\code{1}, \code{3L}): returns that number.
\item \strong{Existing label}  (\code{Monday}): returns its mapped index.
\item \strong{Brand-new label} (any other symbol/character) ->  marks it for creation
by returning \code{NA} together with the textual label.
}
}
\keyword{internal}
