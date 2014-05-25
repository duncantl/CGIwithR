cat(Sys.getenv("FORM_DATA"), file= "/tmp/FORM")

trim =
function(x)
   gsub('(^"|"$)', '', x)

bodies = formData$dataFiles
sep = formData$separator

cat("Separator:", sep, "<br/>")
cat("Names of variables: ", paste(names(formData), collapse = "; "), "<br/>")
if(FALSE) {
  cat("<PRE>\n")
  print(formData)
  cat("</PRE>\n")
}

cat("<H1>Summaries</H1>")

files = formData[ names(formData) == "dataFiles"]
filenames = sapply(files, function(x) x$fields[["Content-Disposition"]][["filename"]])


invisible(mapply(function(x, fname) {
           con = textConnection(x)
           d = read.table(con, sep = sep, header = TRUE)
           cat("<b>", trim(fname), "</b>\n")
           cat("<PRE>\n")
           print(summary(d))
           cat("</PRE>\n")           
         }, bodies, filenames))
