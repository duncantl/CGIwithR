#
# This is a trivial example of how one can specify a 
# Content-type other than text/html for the returned
# "page".  The Content-type: header must be the very
# first text returned by our script so that R.cgi
# will know not to add its own Content-type header.
#
# The example shows how we can return a dataset
# without any markup so that it can be read via
# functions such as read.table() without any HTML.


cat("Content-type: text/plain\n\n")

data(mtcars)
print(mtcars)
