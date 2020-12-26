# tools for working with mongolite NB on macosx must specify localhost explicitly
# as 127.0.0.1

#' check for accessible local mongodb
#' @import mongolite
#' @param url character(1) defining mongodb server
#' @return logical(1)
#' @examples
#' if (interactive()) verifyRunningMongodb()
#' @export
verifyRunningMongodb = function(url = "mongodb://127.0.0.1") {
    requireNamespace("mongolite")
    ans = try(mongo(url = url))
    class(ans)[1] == "mongo"  # will return FALSE if try results in try-error
}

#' check for existence of 'mongo' command, for db.getCollectionNames etc.
#' @param cmd character(1) either 'mongo' or 'mongoimport'
#' @note we use mongoimport command to import tsv files; mongolite import 'method' not immediately useful for this
#' @return logical(1)
#' @examples
#' if (interactive()) verifyHasMongoCmd()
#' @export
verifyHasMongoCmd = function(cmd = "mongo") {
    mcmd = try(system2(cmd, args = "--help", stdout = TRUE, stderr = TRUE))
    if (inherits(mcmd, "try-error")) message("install mongodb on your system to use this function")
    !inherits(mcmd, "try-error")
}

#' utility to prune away header lines on mongodb command line query
#' @param x character() vector
#' @param tag character(1) token to be found up to and including which we discard results from mongo shell
#' @return character vector
#' @export
prune_to_server_line = function(x, tag="MongoDB server") {
  ind = grep(tag, x)
  if (length(ind)>0) return(x[-seq_len(ind[1])])
  x
}

#' list all collections in a database, using command-line interface
#' @param url character(1) mongodb URL
#' @param db character(1) mongodb database name
#' @param lisproc a function that processes the reply to 'mongo ... --eval 'db.getCollectionNames()' to extract JSON, defaults to a function that
#' removes all (header) records up to the one containing 'MongoDB server'
#' @return vector of strings
#' @examples
#' if (verifyRunningMongodb()) listAllCollections()
#' @export
listAllCollections = function(url = "mongodb://127.0.0.1:27017",
   db = "txregnet",
   lisproc=prune_to_server_line) {
    url = gsub("test", db, url)
    #dbref = sprintf("%s/%s", url, db)
    lis = system2("mongo", c(paste(url, "/", db, sep=""), "--eval", 
        r"{"printjson(db.getCollectionNames())"}"),
       stdout=TRUE)
    if (!is.null(lisproc)) lis = lisproc(lis)
    rjson::fromJSON(paste(lis, collapse = ""))
}

