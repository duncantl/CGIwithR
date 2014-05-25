splitDataString =
  #  Split the given line by sep[1] and then each of those elements by sep[2].
  #  and use the names of the name = value pairs generated from sep[2]
  #  as the names for the resulting list.
  #  e.g.  'form-data; name="dataFile"; filename="bootData"'
  # 
function(txt, sep = c("; ", "="))
{
  els = strsplit(txt, sep[1])[[1]]

  if(length(sep) > 1) {
    els = sapply(els, strsplit, sep[2])
    tmp = sapply(els, function(x) x[1])
    els = lapply(els, function(x) if(length(x) == 1) x[1] else x[-1])
    names(els) = tmp
  }

  els
}

getMultiPartBoundary =
  #
  # Determines whether the request is a multipart/form-data
  # and if so, extracts the boundary that identifies the different
  # segments of the request.
  # This returns either the boundary or a zero-length character vector.
  # If an actual string is returned, then the contents of the request
  # were retrieved from the standard input. This is important if
  # we use R directly rather than via cgi.R.
function(type = Sys.getenv("CONTENT_TYPE"), method = Sys.getenv("REQUEST_METHOD"))
{  
   if(method == "POST") {
       if(type != "") {
          els = strsplit(type, "; ")[[1]]
          idx = match("multipart/form-data", els)
          if(!is.na(idx)) {
             els = sapply(els[-idx], strsplit, "=")
             tmp = sapply(els, function(x) x[1])
             els = sapply(els, function(x) x[-1])
             names(els) = tmp

             if("boundary" %in% names(els))
               return(els["boundary"])
          }
       }
    }

    return(character(0))
}

parseMultiPartFormData =
  #
  # This is used when we have a form with enctype (encoding type)
  # of multipart/form-data.
  # This is quite similarl to attachments in a mail message.
  # Each "element" is identified by a pair of --boundary lines
  # (and the last one with a --boundary--)
  # Each element is of the formi.e. 
  #   field: text
  #   field: text
  #   <blank line>
  #   body....

  #
  #  This returns an object of class "MultiPartFormData"
  #  which is a list of the processed elements indexed by their
  #  name.   Each element typically has a Content-Disposition field
  #  and within this there is a name="text" string. We use that for the
  #  name of the element in the R.
  #
  #
  # XXX
function(boundary, content = readLines(stdin()), collapseBody = "\n",
          splitLines = FALSE)
{
    # If the content was not specified, read it from the standard input.
    # This would be used if we were calling R directly rather than indirectly
    # via R.cgi.  This may happen soon.
    # If the cotent is specified ans so is sep, then we need to break
    # the string into a vector of lines. So we split first by new line
    # and then by control-feed.  The reason for doing this in two steps
    # is that the contents of a file may be embedded within the input and
    # separated by \n rather than \r\n. So not all lines are identified by the
    # \r\n, only those created by the form mechanism.
  if(!missing(content) && splitLines) {
       # Read the lines from standard input
     content = strsplit(content, "\n")[[1]]
     content = gsub("\r$", "", content)    
  }

    # Find the locations of the boundary lines, i.e. --boundary
    # Won't match the last one since that is --boundary--, but we don't need that one.
  starts = grep(paste("^--", boundary, "$", sep = ""), content)

    # Loop over each of the positions of the start of a block in the form
    # and process the lines within that block.
 vals = lapply(seq(along = starts),
         function(i) {
              # Get the lines of the block.
            txt = content[seq(starts[i], ifelse(!is.na(starts[i+1]), starts[i+1], length(content)) - 1)]

              # Find the first blank line which separates the header from the body of the block.
            b = match("", txt)
              #
            body = txt[-(1:(b))]
            if(!is.na(collapseBody))
              body = paste(body, collapse = collapseBody)
              
            header = txt[2:(b-1)]
         
             # Break each line of the header by the :,
             # e.g. Content-Type: value...
            els = strsplit(header, ": ")
            fieldNames = sapply(els, function(x) x[1])
            fields = lapply(els, function(x) {
                                    splitDataString(paste(x[-1], collapse = ": "))
                                  })
         
            
            names(fields) = fieldNames
            ans = list(fields = fields, body = body)
            
            if(!is.null(disp <- fields[["Content-Disposition"]])  && "filename" %in% names(disp))
              class(ans) = "FileUploadContent"

            ans
  })

    # Now put the names of the actual data elements of the form onto the R form
    # object itself.
  names(vals)  = stripQuotes(sapply(vals, function(x) x$fields[["Content-Disposition"]]["name"]))

   # Handle duplicated name elements by combining them into a vector for that name.
  w = duplicated(names(vals))
  isFileUpload = sapply(vals, function(x) any("filename" == names(x$fields[["Content-Disposition"]])))
  w = w & !isFileUpload
  
  if(any(w)) {
    sapply(which(w),
            function(i) {
               first = match(names(vals)[i], names(vals))
               vals[[first]][["body"]] <<- c(vals[[first]]$body, vals[[i]]$body)
             })
    vals = vals[!w]
  }

  class(vals) <- "MultiPartFormData"
  vals
}

"$.MultiPartFormData" <-
  # Method to access the body associated with the given Content-Disposition: name="name" value
  # in the form.
function(x, name)
{

  i = (name == names(x))
  if(!any(i))
     return(NULL)
  if(sum(i) > 1) {
    return(sapply(x[i], function(x) x$body))
  }
   # just a single entry. 
  el = x[[name]]
  el$body
}



stripQuotes =
  #
  # Remove leading and trailing quotes.
  # This is used in dealing with the name="value" pairs in the
  # multipart/form-data fields, e.g. the Content-Disposition: field.
function(txt) {
  gsub('^"(.*)"$', "\\1", txt)
}
