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