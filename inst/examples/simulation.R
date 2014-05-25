# Load a general R function for performing the simulation.
source("simulate.S")


# Check the user has specified a valid value for statistic.
if(!("statistic" %in% names(formData)) || formData$statistic == "") {
  cat("You have not specified the statistic. Go back and select one and resubmit")
  q()
}

# Interpret the inputs from the form and generate the simulated distribution.
# Note that we have to coerce the strings to numbers. 
# The function simulate() handles the statistic and name of the distribution to resolve 
# the relevant functions. This makes that function more reusable and simplifies the code
# in this script.

ans = simulate(as.integer(formData$n), as.integer(formData$NumRep),  formData$statistic, formData$distribution)

# There may be multiple entries in the formData named "output". So to get them all, we
# find all entries with that name.

# To write HTML, make certain to remember to do this inside calls to cat() or print().
# This is R, so we cannot just put them into the text of the script.
cat("<h2>Sample distribution of", formData$statistic, " for n =", formData$n, "from ", formData$distribution, "</h2>")

# If the word summary was submitted as part of the output, use R2HTML to produce a
# table of the 6 number summary.

if("summary" %in% formData$output) {
   invisible(capture.output(library(R2HTML)))
   HTML(summary(ans), file = stdout())
}


# And if the user checked the histogram box, create a histogram and overlay it with a
# density plot.
if("histogram" %in% formData$output) {
 webPNG("hist.png", type = "jpeg", graphDir = "../htdocs/tmp/") 
 dens = density(ans)
 hist(ans, prob = TRUE, ylim = c(0, max(dens$y)), main = "Density of sample values")
 points(dens, col = "red")
 img(src = "hist.png", graphURLroot = "/tmp/")
}

# Finally, just for completeness and reproducability, we write down the
# details of the request that was used to generate this page.
#if(as.logical(formData$showAttribution))
 writeRequestInfo()
