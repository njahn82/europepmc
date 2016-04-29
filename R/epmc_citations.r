#' Get citations for a given publication
#'
#' The function finds works citing a publication. It retrieves counts and
#' some metadata.
#'
#' @inheritParams epmc_refs
#'
#' @return List of 2, citation count and metadata of citing documents
#'   (data.frame)
#' @export
#'
#' @examples
#' \dontrun{
#' epmc_citations("PMC3166943", data_src = "pmc")
#' epmc_citations("9338777")
#' }
epmc_citations <- function(ext_id = NULL, data_src = "med", limit = 25,
                           verbose = TRUE) {
  if (is.null(ext_id))
    stop("Please provide a publication id")
  if (!tolower(data_src) %in% supported_data_src)
    stop(paste0("Data source '", data_src, "' not supported. Try one of the
                following sources: ", paste0(supported_data_src, collapse =", ")
    ))
  # build request
  req_method <- "citations"
  path = paste(rest_path(), data_src, ext_id, req_method,
               "json", sep ="/")
  doc <- rebi_GET(path = path)
  hit_count <- doc$hitCount
  if(hit_count == 0)
    stop("No citing documents found")
  paths <- make_path(hit_count = hit_count, limit = limit, ext_id = ext_id,
                     data_src = data_src, req_method = req_method)
  out <- lapply(paths, function(x) {
    if(verbose == TRUE)
      message(paste0(hit_count, " records found. Returning ",
                     ifelse(hit_count <= limit, hit_count, limit)))
    doc <- rebi_GET(path = x)
    plyr::ldply(doc$citationList, data.frame, stringsAsFactors = FALSE, .id = NULL)
  })
  #combine all into one
  result <- jsonlite::rbind.pages(out)
  # return
  list(hit_count = hit_count, data = result)
}
