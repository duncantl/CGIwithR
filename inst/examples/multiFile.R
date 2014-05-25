
cat("This is multiFile.R\n")

print(system.file(package = "CGIwithR"))
print(packageDescription("CGIwithR")[["Version"]])
cat("<br/>")

save(formData, file = "/tmp/foo.rda")
cat(Sys.getenv("FORM_DATA"), file= "/tmp/FORM")
cat(Sys.getenv("CONTENT_TYPE"), file= "/tmp/CONTENT")

cat("<br/>")
print(length(formData))
cat("<br/>")
print(names(formData))
cat("<br/>")
cat("<PRE>\n")
print(sapply(formData, class))
cat("</PRE>\n")
cat("<br/>")
print(formData)




cat("<br/>")
print(class(formData))
print(typeof(formData))
cat("<br/>")
print(ls())
cat("<br/>")
#print(typeof(formData[["dataFile"]]))

print(length(formData[["dataFile"]]))


#save(list = "formData", file = "/tmp/foo.rda")
#print(str(formData))
#print(names(formData$dataFile))
#print(names(formData$dataFile$fields))



#save(formData, "foo.rda")
#print(names(formData$dataFile))

#print(str(formData))
