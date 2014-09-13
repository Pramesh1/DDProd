---
title: "Untitled"
author: "P.Rogbeer"
date: "Saturday, September 13, 2014"
output: html_document
---



my `ui.R`filr


```r
library(shiny)
library(xtable)
clist<- c("Norway","Australia","Switzerland","Netherlands","United States","Germany","New Zealand","Canada","Singapore","Denmark","Ireland","Sweden","Iceland","United Kingdom","Hong Kong, China (SAR)","Korea (Republic of)",
"Japan","Liechtenstein","Israel","France","Austria","Belgium","Luxembourg","Finland","Slovenia","Italy","Spain","Czech Republic","Greece","Brunei Darussalam","Qatar","Cyprus","Estonia","Saudi Arabia","Lithuania","Poland","Andorra","Slovakia","Malta","United Arab Emirates","Chile","Portugal","Hungary","Bahrain",
"Cuba","Kuwait","Croatia","Latvia","Argentina","Uruguay","Bahamas","Montenegro","Belarus","Romania","Libya","Oman","Russian Federation","Bulgaria","Barbados","Palau","Antigua and Barbuda","Malaysia","Mauritius","Trinidad and Tobago","Lebanon","Panama","Venezuela (Bolivarian Republic of)","Costa Rica","Turkey","Kazakhstan","Mexico","Seychelles","Saint Kitts and Nevis","Sri Lanka","Iran (Islamic Republic of)",
"Azerbaijan","Jordan","Serbia","Brazil","Georgia","Grenada","Peru","Ukraine","Belize","The former Yugoslav Republic of Macedonia",
"Bosnia and Herzegovina","Armenia","Fiji","Thailand","Tunisia","China","Saint Vincent and the Grenadines",
"Algeria","Dominica","Albania","Jamaica","Saint Lucia","Colombia","Ecuador","Suriname","Tonga",
"Dominican Republic","Maldives","Mongolia","Turkmenistan","Samoa","Palestine, State of","Indonesia",
"Botswana","Egypt","Paraguay","Gabon","Bolivia (Plurinational State of)","Moldova (Republic of)","El Salvador",
"Uzbekistan","Philippines","South Africa","Syrian Arab Republic","Iraq","Guyana","Viet Nam","Cape Verde",
"Micronesia (Federated States of)","Guatemala","Kyrgyzstan","Namibia","Timor-Leste","Honduras","Morocco",
"Vanuatu","Nicaragua","Kiribati","Tajikistan","India","Bhutan","Cambodia","Ghana","Lao People's Democratic Republic",
"Congo","Zambia","Bangladesh","Sao Tome and Principe","Equatorial Guinea","Nepal","Pakistan","Kenya",
"Swaziland","Angola","Myanmar","Rwanda","Cameroon","Nigeria","Yemen","Madagascar","Zimbabwe","Papua New Guinea",
"Solomon Islands","Comoros","Tanzania (United Republic of)","Mauritania","Lesotho","Senegal","Uganda",
"Benin","Sudan","Togo","Haiti","Afghanistan","Djibouti","C™te d'Ivoire","Gambia","Ethiopia","Malawi",
"Liberia","Mali","Guinea-Bissau","Mozambique","Guinea","Burundi","Burkina Faso","Eritrea","Sierra Leone",
"Chad","Central African Republic","Congo (Democratic Republic of the)","Niger")

shinyUI(pageWithSidebar( 
        
        headerPanel("Thinking of moving abroad then..  let's see if you'll be betterr off ..."),          
        sidebarPanel(h4("Information"), 
                     p("The UNDP compiles , on a yearly basis, a global index known as the Human Development Index, 
                        (the higher the better) whereby each country is rated and given a ranking.
                        This simulation uses several of the indicators from the vaailable dataset 
                       to predict how your quality of life could change if you emigrated to somewhere else. The data ,
                       used for this application was downloaded from http://hdr.undp.org/en/data.,
                       The data was then sampled and cleaned, with limited number of variables retained for this simulation."),              
                     h4("Instructions"),
                     p("To use this application, fill in your (1) gender (male/female), (2)current locatrion , (3) where
                your intend to relocation"), 
                     h4("Go!"),
                     selectizeInput("countryNow", label="Where are you you currently living ?",selected = "Mauritius",choices=clist),
                     selectizeInput("countryFuture", label="Where do you plan to Relocate ?",selected = "Germany",choices=clist),
                     selectizeInput("gender", label="Input your gender",selected = "Male",choices=c("Male","Female")),
                     submitButton("Submit")                      
        ), 
        
        mainPanel(                    
                h4('What you should expect'),
                p("To avoid information overload, this simulation is limited to 6 indicators but can be modified to include others."),
 #               tableOutput("hdi"),
                verbatimTextOutput("ocountryn"),
                verbatimTextOutput("ocountryf"),
                verbatimTextOutput("ogender"),
                h5('The below table give you the % change to expect,compared to your current situation'),
                p("Results = (Index Country of Origin - Index Country of Destination)%" ), 
                h5('All values in percentage (%)'),
                tableOutput("ohdi2"),
 plotOutput("myPlot"),                
 includeHTML("legend.html")
                
                
        )
) 
)


ummary(cars)
```

my `server.R`file



```r
library(shiny)
library(xtable)
# Load data ----
mdata<-read.csv("ddprod-pr.csv", header=TRUE)
mdata[,1]<-as.character(mdata[,1])  # preprocess data

hdi <- function(countryNow, countryFuture, gender) { 
        
        my.now<-mdata[grep(countryNow,mdata$country),]
        my.fut<-mdata[grep(countryFuture,mdata$country),]
        country.n<-my.now[,1]
        country.f<-my.fut[,1]
        
        m<-c(2,3,5,6,8,10,11,12,13,14,15,16)   # remove country name
        f<-c(2,3,4,6,7,9,11,12,13,14,15,16)
        
        if(gender=="Male"){                      
                data.now<-my.now[,m] 
                data.fut<-my.fut[,m] 
                
        } else {
                data.now<-my.now[,f]
                data.fut<-my.fut[,f] 
        }
        
        names(data.now)[3] <- "hdi"
        names(data.fut)[3] <- "hdi"
        names(data.now)[5] <- "le"
        names(data.fut)[5] <- "le"
        names(data.now)[6] <- "gni"
        names(data.fut)[6] <- "gni"
        
        data.result<-data.now-data.fut
        data.result$hdi.gii<-data.result$hdi.gii*-1
        data.result$hdi<-data.result$hdi*-1
        data.result$taxes<-data.result$taxes*-1
        data.result$cpi<-data.result$cpi*-1
        
        give.result<-data.result
        yy<-(data.result/data.now)*100
        data.result[,1:6]<-yy[,1:6] # convert all to percentages
        data.result[,8]<-yy[,8]
        data.result<-round(data.result,1)
        
        for (i in 1:12)
        {
                if (give.result[i]<0) {give.result[i] = "Worse"}
                else{give.result[i] ="BETTER!"}
        }            
        
        
        youresult<-rbind(data.result,give.result)      
        
        
        if (countryNow==countryFuture) {
                ymessage <- "Sorry , You do not seem to be relocation outside of your current country"
        } else {
                ymessage <- "Here is what awaits you: "
        } 
        
        
        
        return(youresult)
}


shinyServer( 
        
        function(input, output) { 
                output$ocountryn <- renderPrint({input$countryNow})
                output$ocountryf <- renderPrint({input$countryFuture})
                output$ogender <- renderPrint({input$gender}) 
                output$myPlot <- renderPlot({barplot(as.matrix(youresult[1,]),ylab="% Change",xlab="Indicators")})
                output$ohdi1 <- renderPrint({hdi(input$countryNow, input$countryFuture, input$gender)}[24])
                output$ohdi2<-renderTable({hdi(input$countryNow, input$countryFuture, input$gender)})
                output$myPlot <- renderPlot({barplot(as.matrix({hdi(input$countryNow, input$countryFuture, input$gender)}[1,]),ylab="% Change",xlab="Indicators")})
                
        } 
) 
```

