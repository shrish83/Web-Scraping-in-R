###We will scrape the Amazon website for the 
###price comparison of a product called 
###“One Plus 6”, a mobile phone.
### URL for "One Plus 6" :
###https://www.amazon.in/OnePlus-Mirror-Black-64GB-Memory/dp/B0756Z43QS?tag=googinhydr18418-21&tag=googinkenshoo-21&ascsubtag=aee9a916-6acd-4409-92ca-3bdbeb549f80

##Step 1: Loading the packages required as shown below:
#install.packages("rvest")  ##also installs 'selectr' package

library(xml2)
library(rvest)
library(stringr)


##Step 2: Reading the HTML content from Amazon
#Specifying the url for desired website to be scrapped
url<- "https://www.amazon.in/OnePlus-Mirror-Black-64GB-Memory/dp/B0756Z43QS?tag=googinhydr18418-21&tag=googinkenshoo-21&ascsubtag=aee9a916-6acd-4409-92ca-3bdbeb549f80"

#Reading the html content from Amazon
webpage <- read_html(url)


###Step 3: Scrape product details from Amazon
# we will extract the following information from the website:
#Title: The title of the product.
#Price: The price of the product.
#Description: The description of the product.
#Rating: The user rating of the product.
#Size: The size of the product.
#Color: The color of the product.

##Now, we will make use of HTML tags, 
##like the title of the product and price, 
##for extracting data using Inspect Element.

##In order to find out the class of the HTML tag, use the following steps:
##=> go to chrome browser => go to this URL => right click => inspect element
##Based on CSS selectors such as class and id,
##we will scrape the data from the HTML. 
##To find the CSS class for the product title,
##we need to right-click on title and select 
##“Inspect” or “Inspect Element”.

#scrape title of the product
title_html<- html_nodes(webpage,"h1#title")
title <- html_text(title_html)
head(title)

##The next step would be to remove spaces and 
##new line with the help of the str_replace_all() 
##function in the stringr library.
# remove all space and new lines
title<-str_replace_all(title,"[\r\n]"," ")


##Price of the product:
# scrape the price of the product
price_html <- html_nodes(webpage, "span#priceblock_ourprice")
price <- html_text(price_html)                           
head(price)  
##characters (empty) hence "price not available or not given as the product is currently unavailable" 


##Product description:
# scrape product description
desc_html <- html_nodes(webpage, "div#productDescription")
desc <- html_text(desc_html)
desc <- str_trim(str_replace_all(desc, "[\r\n\t]" , ""))
head(desc)


##Rating of the product:
# scrape product rating 
rate_html <- html_nodes(webpage, "span#acrPopover")
rate <- html_text(rate_html)
# remove spaces and newlines and tabs 
rate <- str_trim(str_replace_all(rate, "[\r\n]" , ""))
# print rating of the product
head(rate)


##Size of the product:
# Scrape size of the product
size_html <- html_nodes(webpage, "div#variation_size_name")
size_html <- html_nodes(size_html, "span.selection")
size <- html_text(size_html)
# remove tab from text
size <- str_trim(size)
# Print product size
head(size)


##Color of the product:
# Scrape product color
color_html <- html_nodes(webpage, "div#variation_color_name")
color_html <- html_nodes(color_html, "span.selection")
color <- html_text(color_html)
# remove tabs from text
color <- str_trim(color)
# print product color
head(color)


###Step 4: We have successfully extracted 
###data from all the fields which can be used
###to compare the product information from 
###another site.
#Combining all the lists to form a data frame
product_data <- data.frame(Title = title, Price = 0,Description = desc, Rating = rate, Size = size, Color = color)
#Structure of the data frame
str(product_data)
#Let’s compile and combine them to work out a dataframe and inspect its structure.

###Step 5: Store data in JSON format:
# Include ‘jsonlite’ library to convert in JSON form.
library(jsonlite)
# convert dataframe into JSON format
json_data <- toJSON(product_data)
# print output
cat(json_data)
##included jsonlite library for using the toJSON() function to convert the dataframe object into JSON form.
