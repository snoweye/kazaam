#' print
#' 
#' Print method for a shaq.
#' 
#' @section Communication:
#' The operation is completely local.
#' 
#' @param x,object
#' A shaq.
#' @param ...
#' Ignored
#' 
#' @examples
#' spmd.code = "
#'   library(kazaam)
#'   x = shaq(1, 10, 3)
#'
#'   x # same as print(x) or comm.print(x)
#'
#'   finalize()
#' "
#' 
#' pbdMPI::execmpi(spmd.code=spmd.code, nranks=2)
#' 
#' @name print
#' @rdname print
NULL



print_shaq = function(x)
{
  if (comm.rank() == 0)
  {
    size = comm.size()
    rank = if (size > 1) "ranks" else "rank"
    type = ifelse(is.shaq(x), "shaq", "tshaq")
    
    cat(paste0("# A ", type, ": ", nrow(x), "x", ncol(x), " on ", size, " MPI ", rank, "\n"))
    
    toprow = min(10, nrow.local(x))
    topcol = min(6, ncol.local(x))
    if (toprow == 0 || topcol == 0)
      cat("# [no elements to display]\n")
    else
    {
      submat = DATA(x)[1:toprow, 1:topcol, drop=FALSE]
      print(submat)
      
      if (toprow < nrow(x) || topcol < ncol(x))
        cat("# ...\n\n")
    }
  }
}



#' @rdname print
#' @export
setMethod("print", signature(x="gbd1d"), function(x, ...) print_shaq(x))

#' @rdname print
#' @export
setMethod("show", signature(object="gbd1d"), function(object) print_shaq(object))
