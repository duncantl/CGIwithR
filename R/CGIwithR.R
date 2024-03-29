CGIparse <- function(string, collapse = TRUE,
                      boundary = getMultiPartBoundary())
{
    if(length(boundary)) 
       return(parseMultiPartFormData(boundary, string, splitLines = TRUE))
      
    the.split.string <- lapply(strsplit(string, "&"), 
                             function(string)strsplit(string, "="))[[1]]
    arglist <- lapply(the.split.string, function(pair) pair[2])
    names(arglist) <- sapply(the.split.string, function(pair) pair[1])
    ans <- lapply(arglist, hexDecode)

    if(collapse) {
      ids = names(ans)[duplicated(names(ans))]
            
      for(i in unique(ids)) {
         first <- match(i, names(ans))
         j = which(names(ans) == i)
         ans[[first]] = unlist(ans[j])
         ans = ans[- j[-1] ]
      }
    }

    ans
}
      
hexDecode <- function(string){
    string <- gsub("\\+", " ", string)
    string <- gsub("%09", "\t", string)
    string <- gsub("%0D%0A", "\n", string)
    string <- gsub("%0D|%0A", "\n", string)
    pieces <- strsplit(string, "%")[[1]]
    dehex <- function(string){
              hex <- substr(string, 1, 2)
              paste(ascii[hex], substring(string, 3), sep = "")
              }
    pieces <- c(pieces[1], sapply(pieces[-1], dehex))
    paste(pieces, collapse = "")
}


HTMLheader <-
function(title = character(0), css = character(0))
{
    cat("<!doctype html public \"-//W3C/DTD HTML 4.0/EN\">\n")
    lf(2)

    cat("<HTML>\n<HEAD>\n")
    if(length(title))
        cat("<title>", paste(title, collapse = " "), "</title>\n", sep = "")

    if(length(css)) {
        cssNames = names(css)
        sapply(seq(along = css),
               function(i) {
                       cat('<LINK rel="StyleSheet" HREF="', css[i], '"',
                           ifelse(length(cssNames) && cssNames[i] != "", paste(' MEDIA="', cssNames[i], '" ', sep = ""), ""),
                           'TYPE="text/css">\n', sep = "")
               })
    }

    
    cat("</HEAD>\n\n<BODY>\n")
}

HTMLfooter =
  #
  # Output the closing </BODY></HTML>
  #
function()
{
  cat("</BODY></HTML>\n")
}


br <- function(n = 1){
    cat(paste(rep("<BR>", n), collapse = ""), "\n")
    }

tag <- function(tagname, ...) 
{
    if (getOption("useUnquotedTagnames")) {
        result <- as.character(substitute(tagname))
    }
    dots <- list(...)
    if (length(dots) > 0) {
        dotnames <- names(dots)
        dots <- paste(dotnames, paste(dots, "\"", sep = ""),
                      sep = "=\"")
        dots <- paste(dots, collapse = " ")
        result <- paste(result, dots, sep = " ")
    }
    cat(paste("<", result, ">", sep = ""))
}
  
untag <- function(tagname){
    if (getOption("useUnquotedTagnames")) 
        tagname <- as.character(substitute(tagname))
    cat("</", tagname, ">", sep = "")
}
  
lf <- function(n = 1) cat(paste(rep("\n", n), sep = ""))

comments <- function(text) cat("<!--", text, "-->")

mailto <- function(text, address){
    cat("<a href=\"mailto:", address, "\">", text, "</a>", sep="")
}
    
linkto <- function(text, URL){
    cat("<A href=\"", URL, "\">", text, "</A>", sep = "")
}

 
webPNG <- function(file, ..., graphDir){
    if (missing(graphDir)) {
      if(!exists("graphDir", envir = globalenv(), inherits = TRUE)) {
        cat("Error in webPNG(): graphDir not set\n\n")
        q("no") ##  abort if graphDir not specified
      }
      graphDir = get("graphDir", envir = globalenv(), inherits = TRUE)
    }

    if (!file.exists(graphDir)) {
        cat("Error in webPNG():", graphDir, "does not exist\n\n")
        q("no") ##  abort if specified graphDir does not exist
    }
    n <- nchar(graphDir)
    separator <- if (substr(graphDir, n, n) == "/") "" else "/"

    if(require(GDD, quietly = TRUE)) {
       GDD(file = paste(graphDir, file, sep = separator), ...)
    } else
       bitmap(file = paste(graphDir, file, sep = separator), ...)
    invisible(NULL)
}

    
img <- function (src, ..., graphURLroot = "") 
{
    result <- src
    if(missing(graphURLroot)) {
       if (exists("graphURLroot", envir = globalenv(), inherits = TRUE))
         graphURLroot = get("graphURLroot", envir = globalenv(), inherits = TRUE)
       else
         graphURLroot = ""
    }
    result <- paste(graphURLroot, src, sep = "")
    result <- paste("<IMG SRC=\"", result,
                    "?nocache=", sample(9999, 1), "\"",
                    sep = "")
    dots <- list(...)
    if (length(dots) > 0) {
        dotnames <- names(dots)
        dots <- paste(dotnames, paste(dots, "\"", sep = ""),
                      sep = "=\"")
        dots <- paste(dots, collapse = " ")
        result <- paste(result, " ", dots, ">", sep = "")
    } else result <- paste(result, ">", sep = "")
    cat(result)
    invisible(result)
}

"ascii" <-
  structure(c(
 "","\001","\002","\003","\004","\005","\006","\007", # 000-007
 "\010","\011","\012","\013","\014","\015","\016","\017", # 010-017
 "\020","\021","\022","\023","\024","\025","\026","\027", # 020-027
 "\030","\031","\032","\033","\034","\035","\036","\037", # 030-037
 "\040","\041","\042","\043","\044","\045","\046","\047", # 040-047
 "\050","\051","\052","\053","\054","\055","\056","\057", # 050-057
 "\060","\061","\062","\063","\064","\065","\066","\067", # 060-067
 "\070","\071","\072","\073","\074","\075","\076","\077", # 070-077
 "\100","\101","\102","\103","\104","\105","\106","\107", # 100-107
 "\110","\111","\112","\113","\114","\115","\116","\117", # 110-117
 "\120","\121","\122","\123","\124","\125","\126","\127", # 120-127
 "\130","\131","\132","\133","\134","\135","\136","\137", # 130-137
 "\140","\141","\142","\143","\144","\145","\146","\147", # 140-147
 "\150","\151","\152","\153","\154","\155","\156","\157", # 150-157
 "\160","\161","\162","\163","\164","\165","\166","\167", # 160-167
 "\170","\171","\172","\173","\174","\175","\176","\177", # 170-177
 "\200","\201","\202","\203","\204","\205","\206","\207", # 200-207
 "\210","\211","\212","\213","\214","\215","\216","\217", # 210-217
 "\220","\221","\222","\223","\224","\225","\226","\227", # 220-227
 "\230","\231","\232","\233","\234","\235","\236","\237", # 230-237
 "\240","\241","\242","\243","\244","\245","\246","\247", # 240-247
 "\250","\251","\252","\253","\254","\255","\256","\257", # 250-257
 "\260","\261","\262","\263","\264","\265","\266","\267", # 260-267
 "\270","\271","\272","\273","\274","\275","\276","\277", # 270-277
 "\300","\301","\302","\303","\304","\305","\306","\307", # 300-307
 "\310","\311","\312","\313","\314","\315","\316","\317", # 310-317
 "\320","\321","\322","\323","\324","\325","\326","\327", # 320-327
 "\330","\331","\332","\333","\334","\335","\336","\337", # 330-337
 "\340","\341","\342","\343","\344","\345","\346","\347", # 340-347
 "\350","\351","\352","\353","\354","\355","\356","\357", # 350-357
 "\360","\361","\362","\363","\364","\365","\366","\367", # 360-367
 "\370","\371","\372","\373","\374","\375","\376","\377" # 370-377
),
  .Names = c(
  "00", "01", "02", "03", "04", "05", "06", "07",
  "08", "09", "0A", "0B", "0C", "0D", "0E", "0F",
  "10", "11", "12", "13", "14", "15", "16", "17",
  "18", "19", "1A", "1B", "1C", "1D", "1E", "1F",
  "20", "21", "22", "23", "24", "25", "26", "27",
  "28", "29", "2A", "2B", "2C", "2D", "2E", "2F",
  "30", "31", "32", "33", "34", "35", "36", "37",
  "38", "39", "3A", "3B", "3C", "3D", "3E", "3F",
  "40", "41", "42", "43", "44", "45", "46", "47",
  "48", "49", "4A", "4B", "4C", "4D", "4E", "4F",
  "50", "51", "52", "53", "54", "55", "56", "57",
  "58", "59", "5A", "5B", "5C", "5D", "5E", "5F",
  "60", "61", "62", "63", "64", "65", "66", "67",
  "68", "69", "6A", "6B", "6C", "6D", "6E", "6F",
  "70", "71", "72", "73", "74", "75", "76", "77",
  "78", "79", "7A", "7B", "7C", "7D", "7E", "7F",
  "80", "81", "82", "83", "84", "85", "86", "87",
  "88", "89", "8A", "8B", "8C", "8D", "8E", "8F",
  "90", "91", "92", "93", "94", "95", "96", "97",
  "98", "99", "9A", "9B", "9C", "9D", "9E", "9F",
  "A0", "A1", "A2", "A3", "A4", "A5", "A6", "A7",
  "A8", "A9", "AA", "AB", "AC", "AD", "AE", "AF",
  "B0", "B1", "B2", "B3", "B4", "B5", "B6", "B7",
  "B8", "B9", "BA", "BB", "BC", "BD", "BE", "BF",
  "C0", "C1", "C2", "C3", "C4", "C5", "C6", "C7",
  "C8", "C9", "CA", "CB", "CC", "CD", "CE", "CF",
  "D0", "D1", "D2", "D3", "D4", "D5", "D6", "D7",
  "D8", "D9", "DA", "DB", "DC", "DD", "DE", "DF",
  "E0", "E1", "E2", "E3", "E4", "E5", "E6", "E7",
  "E8", "E9", "EA", "EB", "EC", "ED", "EE", "EF",
  "F0", "F1", "F2", "F3", "F4", "F5", "F6", "F7",
  "F8", "F9", "FA", "FB", "FC", "FD", "FE", "FF"
  )
  )


scanText <- function(string, what = character(0), ...){
    tc <- textConnection(string)
    result <- scan(tc, what = what, quiet = TRUE, ...)
    close(tc)
    return(result)}
    
indentPrint <- function(object, indent = 4, ...){
    tc <- textConnection("zz", "w", local = TRUE)
    sink(tc)
    try(print(object, ...))
    sink()
    close(tc)
    indent <- paste(rep(" ", indent), sep = "", collapse = "")
    cat(paste(indent, zz, sep = ""), sep = "\n")}
    
.onLoad <- .First.lib <- function(lib, pkg){
    options(useUnquotedTagnames = TRUE)
    formData <<- Sys.getenv("FORM_DATA")
    if (formData == "") {  ## probably uncgi has been used
        Env <- Sys.getenv()
        Names <- names(Env)
        if(any(grepl("^WWW_", Names))) {
            formData <<- as.list(Env[grep("^WWW\\_", Names)])
            names(formData) <<- gsub("^WWW\\_", "", names(formData))
        } else {
            formData <- readStdInput()
            formData <<- CGIparse(formData)
        }
    }   
    else formData <<- CGIparse(formData)
}

readStdInput =
function()
{
  f = file("stdin")
  open(f)
  on.exit(close(f))
  paste(readLines(f), collapse = "\n")
}
