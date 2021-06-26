library(shinyWidgets)
library(shiny)
library(shinythemes)
library(DT)
library(rsconnect)

data_e <- read.csv("datasets\\employment_data1.csv")
head(data_e)
str(data_e)

data_g <- read.csv(("datasets\\graduate_data1.csv"))
head(data_g)



ui <- fluidPage(
  tabsetPanel(
    type="tabs",
    tabPanel(
      "Summary",
  sidebarLayout(
    sidebarPanel(
      selectInput("checkyear","Select Year",unique(data_e[c("year")]),selected="2018")
      ),
    mainPanel(
      tabsetPanel(
        type = "tabs",
        tabPanel("Ranking",tableOutput("rankingtable")),
        tabPanel("No of Graduates", plotOutput("pieplot"))
      ),
        tags$br(),
        tags$br()
    )
),
tags$hr(),

sidebarLayout(
  sidebarPanel(
    selectInput("checkyear2","Select Year",choices=data_e$year,selected="2018",multiple = TRUE),
    sliderInput("employrateslider","Employment Rate Range",min=66,max=100,value=c(66,100)),
    sliderInput("salaryslider","Salary Range",min=1750,max=5450,value=c(1750,5450)),
    actionButton("actionDT", "Filter", class = "btn btn-primary"),
  ),
  mainPanel(
    h3("Browse All"),
    tags$br(),
    dataTableOutput("myTable"),
    tags$br(),
    tags$br(),
  )
),
tags$hr(),
),
tabPanel(
  "Visual Comparison",
  sidebarLayout(
    sidebarPanel(
      h3("Box Plot"),
      tags$br(),
      checkboxGroupInput(
        "checkgroupbox1",
        label = "Select University",
        choices = list(
          "Nanyang Technological University" = "Nanyang Technological University", 
          "National University of Singapore" = "National University of Singapore",
          "Singapore Institute of Technology" = "Singapore Institute of Technology",
          "Singapore University of Social Sciences" = "Singapore University of Social Sciences",
          "Singapore University of Technology and Design" = "Singapore University of Technology and Design",
          "Singapore Management University" = "Singapore Management University"
        ),
        selected = list(
          "Nanyang Technological University" = "Nanyang Technological University", 
          "National University of Singapore" = "National University of Singapore",
          "Singapore Institute of Technology" = "Singapore Institute of Technology",
          "Singapore University of Social Sciences" = "Singapore University of Social Sciences",
          "Singapore University of Technology and Design" = "Singapore University of Technology and Design",
          "Singapore Management University" = "Singapore Management University"
        )
      ),
      tags$hr()
    ),
    
    mainPanel(
      h3("Median Income Comparison (aggregate)"),
      tags$br(),
      plotOutput("boxplot"),
      tags$br(),
      tags$br(),
      tags$br(),
    )
  ),
  tags$hr(),
  
  sidebarLayout(
    sidebarPanel(
      h3("Ridgeline Plot"),
      tags$br(),
      checkboxGroupInput(
        "checkgroupbox2",
        label = "Select University",
        choices = list(
          "Nanyang Technological University" = "Nanyang Technological University", 
          "National University of Singapore" = "National University of Singapore",
          "Singapore Institute of Technology" = "Singapore Institute of Technology",
          "Singapore University of Social Sciences" = "Singapore University of Social Sciences",
          "Singapore University of Technology and Design" = "Singapore University of Technology and Design",
          "Singapore Management University" = "Singapore Management University"
        ),
        selected = list(
          "Nanyang Technological University" = "Nanyang Technological University", 
          "National University of Singapore" = "National University of Singapore",
          "Singapore Institute of Technology" = "Singapore Institute of Technology",
          "Singapore University of Social Sciences" = "Singapore University of Social Sciences",
          "Singapore University of Technology and Design" = "Singapore University of Technology and Design",
          "Singapore Management University" = "Singapore Management University"
        )
      ),
      tags$hr()
    ),
    
    mainPanel(
      h3("Employment Rate Comparison (University)"),
      tags$br(),
      plotOutput("ridgelineplot"),
      tags$br(),
      tags$br(),
      tags$br(),
    )
  ),
  tags$hr(),
  
  
  sidebarLayout(
    sidebarPanel(
      h3("Cleveland Plot"),
      tags$br(),
      checkboxGroupInput(
        "checkgroupbox3",
        label = "Select school",
        choices = list(
          "College of Engineering" = "College of Engineering",                       
          "College of Humanities, Arts & Social Sciences" = "College of Humanities, Arts & Social Sciences", 
          "College of Sciences" = "College of Sciences",                          
          "DigiPen Institute of Technology" = "DigiPen Institute of Technology",               
          "Engineering Product Development" = "Engineering Product Development",               
          "Engineering Systems and Design" = "Engineering Systems and Design",                
          "Faculty of Arts & Social Sciences" = "Faculty of Arts & Social Sciences",             
          "Faculty of Dentistry" =  "Faculty of Dentistry",                        
          "Faculty of Engineering" = "Faculty of Engineering",                       
          "Faculty of Law" = "Faculty of Law"
        ),
        selected = list(
          "College of Engineering" = "College of Engineering",                       
          "College of Humanities, Arts & Social Sciences" = "College of Humanities, Arts & Social Sciences", 
          "College of Sciences" = "College of Sciences",                          
          "DigiPen Institute of Technology" = "DigiPen Institute of Technology",               
          "Engineering Product Development" = "Engineering Product Development",               
          "Engineering Systems and Design" = "Engineering Systems and Design",                
          "Faculty of Arts & Social Sciences" = "Faculty of Arts & Social Sciences",             
          "Faculty of Dentistry" =  "Faculty of Dentistry",                        
          "Faculty of Engineering" = "Faculty of Engineering",                       
          "Faculty of Law" = "Faculty of Law"
        )
      ),
      tags$hr()
    ),
    
    mainPanel(
      h3("Employment Rate Comparison (School)"),
      tags$br(),
      plotOutput("clevelandplot"),
      tags$br(),
      tags$br(),
      tags$br(),
    )
  ),
  tags$hr(),
  
  
)
)
)
