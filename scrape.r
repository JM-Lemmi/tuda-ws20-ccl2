## Julian Lemmerich
## 25.02.2021
## Scrape Script für 02-25-1078-bs RA-CCL Hausarbeit
## parts taken from Julian Lemmerich 02-25-1076-se CCL I Hausarbeit

# This script has two steps:
# 1. get a list of all the links from presidency.ucsb.edu
# 2. open those links and get the text from them.

library(rvest)
library(tm)

### 1 ###

linklist.short <- c()
linklist.long <- c()

x <- "https://www.presidency.ucsb.edu/advanced-search?field-keywords=&field-keywords2=&field-keywords3=&from%5Bdate%5D=&to%5Bdate%5D=&person2=200301&category2%5B%5D=74&category2%5B%5D=78&category2%5B%5D=73&category2%5B%5D=8&category2%5B%5D=52&category2%5B%5D=46&category2%5B%5D=51&category2%5B%5D=48&category2%5B%5D=54&category2%5B%5D=45&category2%5B%5D=63&category2%5B%5D=65&category2%5B%5D=64&category2%5B%5D=49&category2%5B%5D=68&items_per_page=100&page="
# this url is set up with filters
p <- 30 # url does not include pagenumber, so manually enter here

for (i in 0:p) {                                              # Loop for the number of pages. pages start at 0
  html <- read_html(paste(x,i,sep=""))                               # read html from page, sep is needed, because otherwise a useless space would be there
  element <- html_nodes(html, css = ".views-field-title a")   # Gewuenschte Elemente bestimmen 
  u <- html_attrs(element)                                     # attrs, damit das href element entnommen werden kann
  #die href elemente sind ohne FQDN
  linklist.short <- c(linklist.short, u)
}

#in diesem loop wird die FQDN hinzugef�gt.
for (l in linklist.short) {
  linklist.long <- c(linklist.long, paste("https://www.presidency.ucsb.edu", l, sep=""))
}

### 2 ###

setwd("C:/Users/julian.lemmerich/OneDrive/User Data/Uni/Semester 7/1078-bs RA CCL/Corpus/Corpus_v2")

for (link in linklist.long) {
  
  html <- read_html(link)                                     # HTML-Code einlesen

  ## the text itself
  element <- html_nodes(html, css = ".field-docs-content p")  # Gewuenschte Elemente bestimmen 
  text <- html_text(element)                                  # Text extrahieren

  ## metadata
  # date
  element <- html_nodes(html, css = ".date-display-single")   # Gewuenschte Elemente bestimmen 
  meta.date <- html_text(element)                             # Text extrahieren
  meta.date.split <- strsplit(meta.date, " ")
  if(meta.date.split[[1]][1] == "January") {
    meta.date.month <- "01"
  }
  if(meta.date.split[[1]][1] == "February") {
    meta.date.month <- "02"
  }
  if(meta.date.split[[1]][1] == "March") {
    meta.date.month <- "03"
  }
  if(meta.date.split[[1]][1] == "April") {
    meta.date.month <- "04"
  }
  if(meta.date.split[[1]][1] == "May") {
    meta.date.month <- "05"
  }
  if(meta.date.split[[1]][1] == "June") {
    meta.date.month <- "06"
  }
  if(meta.date.split[[1]][1] == "July") {
    meta.date.month <- "07"
  }
  if(meta.date.split[[1]][1] == "August") {
    meta.date.month <- "08"
  }
  if(meta.date.split[[1]][1] == "September") {
    meta.date.month <- "09"
  }
  if(meta.date.split[[1]][1] == "October") {
    meta.date.month <- "10"
  }
  if(meta.date.split[[1]][1] == "November") {
    meta.date.month <- "11"
  }
  if(meta.date.split[[1]][1] == "December") {
    meta.date.month <- "12"
  }
  filename.date <- paste(meta.date.split[[1]][3],meta.date.month,sub('.$', '', meta.date.split[[1]][2]),sep="-")

  # just some notes zur erklärung
  # here I turn the date around, so it is iso-compliant for the filename. The month name gets replaced by the number. Its not the most elegant, but it works.
  # filename.date combines the split date agian
  # the sub in filename deletes the comma from the day, thats leftover from the split before, und daher das komma drinnen bleibt. .$ matcht ein zeichen von hinten, '' ersetzt druch nix

  # title
  element <- html_nodes(html, css = "h1")                     # Gewuenschte Elemente bestimmen 
  meta.title <- html_text(element)                            # Text extrahieren
  
  # categories
  element <- html_nodes(html, css = ".group-meta a")          # Gewuenschte Elemente bestimmen 
  meta.cat <- html_text(element)                              # Text extrahieren

  filename.title <- strsplit(link,"/")[[1]][5] # here we take the title from the link to make it filename-compatible. The normal titles can include chars that are ungueltig for a filename and thus create an error.

  cat(text,file=paste(filename.date,"_",filename.title,".txt",sep="")) #write all of that to file.
  cat(meta.cat,file=paste(filename.date,"_",filename.title,"_meta.txt",sep=""))
  # TODO xml and metadata in file?

  Sys.sleep(2)                                                # to avoid getting ddos banned by the server
}
