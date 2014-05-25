#!C:/Perl/bin/perl.exe

###  A shell script to make CGI scripting possible in R.  Part of the
###  "CGIwithR" package for R.
###
###  Author: David Firth, University of Warwick 
###  (d.firth@warwick.ac.uk)
###
###  Rewritten in perl for win32 compatibility by Eric Kort
###  (eric.kort@vai.org)
###
###  Terms of use: GPL version 2 or later.  See "COPYING" in the
###  R distribution.
###
###  NO WARRANTY GIVEN, AND NO LIABILITY ACCEPTED FOR LOSS CAUSED BY
###  USE OF THIS PROGRAM
###
###
###  INSTALLING IT:
###
###  This file, and the one-line ".Rprofile" file included with the
###  package, must be placed together in a "cgi-bin" directory.  Both 
###  files should be readable (and this file executable) by the web 
###  server.
###
###
###  CONFIGURING IT:
###    
###  First locate R on the local system (typically the answer 
###  to "which R").  Individual R scripts may request execution by a  
###  different, elsewhere-installed version of R; the R specified 
###  here is the default.


$R_DEFAULT="/usr/bin/R";
$CGI_PATH="c:/usr/Apache2/cgi-bin";

$R_PROFILE =$CGI_PATH . ".Rprofile";
$ENV{'R_PROFILE'} = $R_PROFILE;

###  Graphs can be included in the output provided that ghostscript
###  is available.  Locate the local ghostscript program if available: 

$R_GSCMD="/usr/bin/gs";
$ENV{'R_GSCMD'} = $R_GSCMD;

###  This line allows the imposition of a length limit on the data
###  entered on an HTML form for processing by an R script.  
###  Setting MAX_DATA_LENGTH=1000, for example, aborts  
###  execution if the data length exceeds 1000 characters.  Or
###  use MAX_DATA_LENGTH=NONE to impose no limit here.

$MAX_DATA_LENGTH=10000;

###  No further configuration is needed.  
###
###  It is assumed that the CGIwithR package is installed in the  
###  standard library of the R installation.
###
###  See the documentation included with the CGIwithR package for 
###  more details, examples of use, etc.

###################################################################
###################################################################

###  The script proper begins here.
###

print "Content-type: text/html\n";
print "Cache-Control: no-cache\n";
print "Pragma: no-cache\n";
print "Expires: 0\n\n";

if ($ENV{'REQUEST_METHOD'} eq 'GET')
{
   $FORM_DATA=$ENV{'QUERY_STRING'};
   $length = length($FORM_DATA);
}
else
{
   $length = $ENV{'CONTENT_LENGTH'};
   read(STDIN, $FORM_DATA, $length);
}

if ($length > $MAX_DATA_LENGTH)
{
  print "Error: too much data";
  exit;
} else {
  $ENV{'FORM_DATA'} = $FORM_DATA;
}

###  call R to execute the script and send back the results:
$script =  $ENV{PATH_INFO};
$script =~ s/[\/\\]//;
$out = $script . time() . rand(1000) . ".r.out";

system("R --no-restore --no-save --slave --quiet < $script > $out");

open IN, $out;
while (<IN>)
{
  print $_;
}
close(IN);
exit;
