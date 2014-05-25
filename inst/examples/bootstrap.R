 # Make certain the result doesn't print.
invisible(capture.output({library(utils); library(R2HTML)}))

verbose = FALSE

if(verbose) {

 print(class(formData))
 print(names(formData))
 print(formData)

 for(i in names(formData))
    cat(i, ":", formData[[i]], is.na(formData[[i]]), "<br/>\n")

 cat("Working directory:",  getwd(), "\n")

 showEnvironmentVariables()
}


 # Get the statistic function either as the name of a function or an inline function definition.
 # Be wary of the latter!!!!!

if(is.null(formData$statistic)) {
 cat("No statistic selected")
 q()
}

if(exists(formData$statistic, mode = "function")) {
  T = get(formData$statistic, mode = "function")
} else {
  T = eval(parse(text = formData$statistic))
  if(!is.function(T)) {
     print("Error in HTML form. Statistic must be a function name or function definition")
     q()
  }
}

# Read the data.
dataNotFromFile = is.null(formData$dataFile) || formData$dataFile == "" || formData$dataFile == "NA" || is.na(formData$dataFile)

values = scan(textConnection(ifelse(dataNotFromFile, formData$values, formData$dataFile)))


n = length(values)
tstar = sapply(1:as.integer(formData$NumRep),
                  function(i)
                     T(values[sample(n, replace = TRUE)]))


# Get the multiple entries for output.
output = formData$output

if("summary" %in%  output)
  HTML(summary(tstar), file = stdout())


# Can specify graphDir and graphURLroot locally  for the calls.
webPNG("boot.jpg", type = "jpeg", graphDir = "../htdocs/tmp/")
hist(tstar, prob = TRUE, main = paste("Bootstrap for", formData$statistic))
img("boot.jpg", graphURLroot = "/tmp/")

# or set them globally.
graphDir = "../htdocs/tmp/"
graphURLroot = "/tmp/"

cat("And a second plot<br/>")
webPNG("boot1.jpg", type = "jpeg")
hist(tstar, prob = TRUE, main = paste("Bootstrap for", formData$statistic))
img("boot1.jpg")

# And a third plot that overrides these
webPNG("boot.jpg", type = "jpeg", graphDir = "../htdocs/tmp1/")
hist(tstar^2, prob = TRUE, main = paste("Bootstrap for square of ", formData$statistic))
img("boot.jpg", graphURLroot = "/tmp1/")


# Note that this is the manual version that is relative to the Web servers /
#cat('<img src="/tmp/boot.jpg"><br/>') 

