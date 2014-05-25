##  A CGI script written in R, to process data entered on the 
##  "QV Calculator" input form at http://www.stats.ox.ac.uk/qvcalc/

nlevels <- as.numeric(formData$levels)
data <- as.numeric(scanText(formData$data))
type <- formData$datachoice
varname <- formData[["variable-name"]]

if (length(data) != nlevels * (1 + nlevels)/2) 
       stop("matrix contents do not match number of levels<BR>")

invisible(require(qvcalc, quietly=TRUE, warn.conflicts = FALSE))

if (type == "VCL") {
        covmat <- matrix(0, nlevels, nlevels)
        for (i in 1:nlevels){
            for (j in 1:i){
                covmat[i,j] <- data[i*(i-1)/2 + j]}}
        covmat <- covmat + t(covmat) - diag(diag(covmat))}
if (type == "CORR") {
        sterrs <- data[1:nlevels]
        corrs <- data[-(1:nlevels)]
        cormat <- matrix(1,nlevels,nlevels)
        for (i in 2:nlevels){
            for (j in 1:i-1){
                cormat[i,j] <- corrs[(i-1)*(i-2)/2 + j]
                cormat[j,i] <- cormat[i,j]}}
        covmat <- cormat * outer(sterrs, sterrs)}
if (varname=="NA") varname <- "level"
rownames(covmat) <- paste(varname, 1:nlevels)
colnames(covmat) <- rownames(covmat)
qv <- qvcalc(covmat)
minErrSimple <- round(100*min(qv$relerrs), 1)
maxErrSimple <- round(100*max(qv$relerrs), 1)
errors <- worstErrors(qv)
minErrOverall<-round(100*errors[1], 1)
maxErrOverall<-round(100*errors[2], 1)

##  That's all the calculation done.
##  Now output the results in HTML to the webserver:

HTMLheader()
tag(html)
    tag(title)
        cat("QV calculator: results")
    untag(title)
tag(body)
    tag(h2)
        tag(i)
            tag(font, COLOR = "#F63F1B")
                cat("QV Calculator")
            tag(hr)
            untag(font)
        untag(i)
        lf(2)
        tag(b)
            cat("Output")
        untag(b)
    untag(h2)

    tag(b)
        cat("Variable name: ")
    untag(b)
    cat(formData[["variable-name"]])
    br()
    lf()
    tag(b)
        cat("Description of model: ")
    untag(b)
    cat(formData[["model-name"]])
    lf(2)

    tag(h3)
        cat("Quasi-variance summary")
    untag(h3)
    lf(2)

    cat("Covariance matrix:")
    br()
    lf()
    tag(pre)
    lf()
        indentPrint(covmat, indent = 6, digits = 3)
    untag(pre)
    br()
    lf()

    cat("Quasi-variances and quasi-SEs computed from the above matrix:")
    br()
    tag(pre)
    lf()
        indentPrint(qv$qvframe, indent = 6, digits = 3)
    untag(pre)
    br(2)

    cat(paste(
    "For the standard error of a simple contrast, i.e., of a difference\n",
    "between two levels, the error incurred by the quasi-variance\n",
    "approximation is between ", sep = ""))
    cat(minErrSimple)
    cat("% and ")
    cat(maxErrSimple)
    cat("%")
    br(2)
    lf(2)

    cat("In the set of <i>all</i> possible contrasts the approximation error is between ")
    cat(minErrOverall)
    cat("% and ")
    cat(maxErrOverall)
    cat("%")
    br(2)
    lf(2)

    tag(hr)
    tag(i)
        tag(font, COLOR = "#F63F1B")
                cat("QV Calculator")
        untag(font)
    untag(i)
    br(2)
    lf(2)

    cat("&#169; David Firth, 1998, 2002. This software carries",
    "ABSOLUTELY NO WARRANTY: feel free to use it, but use it at your own risk!")
    br(2)
    lf(2)

    cat("Output produced at ", date())

untag(body)
untag(html)
