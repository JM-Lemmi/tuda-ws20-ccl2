testpost <- html %>% 
  html_nodes("#contentmiddle>:not(#commentblock)") %>% 
  html_text %>%
  as.character %>%
  toString


xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "field-docs-content", " " ))]//p'

//*[not(ancestor::em or name()="em"))]/text()