library(shiny)
library(dplyr)
library(DT)
library(kableExtra)
library(rsconnect)
library(ggplot2)
library(ggridges)

opts <- list(
  language = list(url = "//cdn.datatables.net/plug-ins/1.10.19/i18n/English.json"),
  pageLength = 30,
  searchHighlight = TRUE,
  orderClasses = TRUE,
  columnDefs = list(list(
    targets = c(1, 6), searchable = FALSE
  ))
)

data_e = read.csv("datasets\\employment_data1.csv")
head(data_e)
data_g = read.csv("datasets\\graduate_data1.csv")
head(data_g)
unique(data_g[c("course")])


server <- function(input,output) {
  
  output$rankingtable <- renderPrint({
    data_e %>%
      filter(year == input$checkyear) %>%
      group_by(university) %>%
      select(university,
             employment_rate_overall,
             gross_monthly_median) %>%
      summarise_all(funs(mean)) %>%
      mutate_if(is.numeric, round, 0) %>%
      arrange(desc(employment_rate_overall)) %>%
      kable(
        "html",
        col.names = c(
          "University",
          "Employment Rate Overall (Avg %)",
          "Gross Monthly Median Income (Avg)"
        )
      ) %>%
      kable_styling(c("striped", "hover"), full_width = T)
  })
  
  
  output$pieplot <- renderPlot( {
    data_g %>%
      filter(year == input$checkyear) %>%
      group_by(course) %>%
      tally(graduates) %>%
      ggplot(aes(x = "", y = n, fill = course)) +
      geom_bar(
        stat = "identity",
        width = 1,
        color = "black",
        size = 1
      ) +
      theme_void() +
      theme(legend.position = "right",
            plot.title = element_text(hjust = 0.5, size = 14)) +
      coord_polar("y", start = 0) +
      labs(title = "Courses by number of graduates")
  })
  
  yearGroup <- reactive({
    input$actionDT
    isolate(return(data_e[data_e$year %in% input$checkyear2, ]))
  })
  
  
  filtered_DT <- reactive({
    input$actionDT
    isolate({
      minIncome <- input$salaryslider[1]
      maxIncome <- input$salaryslider[2]
      minEmploy <- input$employrateslider[1]
      maxEmploy <- input$employrateslider[2]
    })
    
    yearGroup() %>%
      filter(basic_monthly_median > minIncome,
             basic_monthly_median < maxIncome) %>%
      filter(employment_rate_ft_perm > minEmploy,
             employment_rate_ft_perm < maxEmploy) %>%
      select(1, 2, 3, 4, 6, 8)
  })
  
  # render DT:
  
  output$myTable <- renderDataTable({
    filtered_DT() %>%
      datatable(
        .,
        rownames = FALSE,
        class = "table",
        options = list(pageLength = 10, scrollX = T),
        colnames = c(
          "Year",
          "University",
          "School",
          "Degree",
          "Fulltime Employment Rate",
          "Basic Monthly Salary(Median)"
        )
      )
    
  })
  
  data_box1 <- reactive({
    return(data_e[data_e$university %in% input$checkgroupbox1,])
  })
  
  output$boxplot <- renderPlot(
    ggplot(data = data_box1(),
           aes(y = university, x = basic_monthly_median, fill = university)) +
      geom_boxplot() + theme(legend.position = "none")
  )
  
  data_box2 <- reactive({
    return(data_e[data_e$university %in% input$checkgroupbox2,])
  })
  
  output$ridgelineplot <- renderPlot(
    ggplot(data = data_box2(),
           aes(y = university, x = employment_rate_overall, fill = university)) +
      geom_density_ridges() + theme(legend.position = "none")
  )
  
  cleveland_data <- data_e %>%
    group_by(school) %>%
    summarise(employment = mean(employment_rate_overall))
  head(cleveland_data)
  unique(cleveland_data[1])
  cleveland_data = cleveland_data[1:10,]
  
  data_box3 <- reactive({
    return(cleveland_data[cleveland_data$school %in% input$checkgroupbox3,])
  })
  
  output$clevelandplot <- renderPlot(
    ggplot(data_box3(), 
           aes(x=employment, 
               y=reorder(school, employment))) +
      geom_point(color="blue", 
                 size = 2) +
      geom_segment(aes(x = 40, 
                       xend = employment, 
                       y = reorder(school, employment), 
                       yend = reorder(school, employment)),
                   color = "lightgrey") +
      labs (x = "Employment",
            y = "")
    +
      theme_minimal() + 
      theme(panel.grid.major = element_blank(),
            panel.grid.minor = element_blank())
  )
  
  
 }
  
