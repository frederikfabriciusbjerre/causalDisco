#' @title The FCI algorithm for causal discovery
#'
#' @description
#' Run the FCI algorithm for causal discovery using one of several engines.
#'
#' @param engine Character; which engine to use. Must be one of:
#'   \describe{
#'     \item{\code{"tetrad"}}{Tetrad Java library.}
#'     \item{\code{"pcalg"}}{\pkg{pcalg} R package.}
#'     \item{\code{"bnlearn"}}{\pkg{bnlearn} R package.}
#'   }
#' @param test Character; name of the conditional‐independence test.
#' @param alpha Numeric; significance level for the CI tests.
#' @param ... Additional arguments passed to the chosen engine (e.g. test or algorithm parameters).
#'
#' @return
#' A function of class \code{"fci"} that takes a single argument \code{data}
#' (a data frame) and returns an igraph_party object.
#'
#' @export
fci <- function(
    engine = c("tetrad", "pcalg", "bnlearn"),
    test,
    alpha = 0.05,
    ...) {
  engine <- match.arg(engine)
  args <- rlang::list2(...)

  builder <- function(knowledge = NULL) {
    runner <- switch(engine,
      tetrad  = rlang::exec(fci_tetrad_runner, test, alpha, !!!args),
      pcalg   = rlang::exec(fci_pcalg_runner, test, alpha, !!!args),
      bnlearn = rlang::exec(fci_bnlearn_runner, test, alpha, !!!args)
    )
    if (!is.null(knowledge)) {
      runner$set_knowledge(knowledge)
    }
    runner
  }
  disco_method(builder, "fci")
}
# Set available engines
attr(fci, "engines") <- c("tetrad", "pcalg")

fci_tetrad_runner <- function(test, alpha, ...) {
  search <- TetradSearch$new()
  args <- list(...)
  args_to_pass <- check_args_and_distribute_args(search, args, "tetrad", "fci", test = test)
  if (length(args_to_pass$test_args) != 0) {
    search$set_test(test, alpha, args_to_pass$test_args)
  } else {
    search$set_test(test, alpha)
  }
  if (length(args_to_pass$alg_args) != 0) {
    search$set_alg("fci", args_to_pass$alg_args)
  } else {
    search$set_alg("fci")
  }

  runner <- list(
    set_knowledge = function(knowledge) {
      search$set_knowledge(knowledge)
    },
    run = function(data) {
      search$run_search(data)
    }
  )
  runner
}

fci_pcalg_runner <- function(test, alpha, ..., directed_as_undirected_knowledge = FALSE) {
  args <- list(...)
  search <- pcalgSearch$new()
  args_to_pass <- check_args_and_distribute_args(search, args, "pcalg", "fci", test = test)
  search$set_params(args_to_pass$alg_args)
  search$set_test(test, alpha)
  search$set_alg("fci")

  runner <- list(
    set_knowledge = function(knowledge) {
      search$set_knowledge(knowledge,
        directed_as_undirected = directed_as_undirected_knowledge
      )
    },
    run = function(data) {
      search$run_search(data)
    }
  )
  runner
}

fci_bnlearn_runner <- function(test, alpha, ...) {
  stop("Not implemented yet.")
}
