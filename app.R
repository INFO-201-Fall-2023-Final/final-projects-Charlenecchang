library(dplyr)
library(stringr)
library(ggplot2)
library(shiny)
library(plotly)
library(leaflet)
library(gplots)

source("final_analysis.R") 

analysis_df <- read.csv("Data_Analysis_of_Diseases_by_State.csv")

# Page 1 - Introductory Page: Overview of the project and background information/context the user will need to know about the domain and dataset
page_one <- tabPanel(
  "Intro", # label for the tab in the nav bar
  h1("An analysis of Geographical epidemiology during the COVID-19 epidemic"), 
  p("If we are hit with another pandemic, where will the care be delivered, and where will the beds be? — (Shah, 2023)"),
  p("———— Epidemiology Analysis by INFO 201 BG-7 Charlene Chang and Cristina Villaviciencio ————"),
  p("During the pandemic, the sudden spikes in COVID-19 cases have posed a serious challenge to the U.S. healthcare system. Many patients passed
    away due to delayed medical treatments or lack of available medical supplies. By analyzing the more common comorbidities, our research
    provides a resource that hospitals can refer to when allocating medical supplies and resources."),
  
  p("This project proposal hopes to shed light on how COVID-19 is not only a disease on its own, but it is a disease to other diseases as the virus
    intensifies its effects and symptoms. Readers may find this valuable since this may make them more aware of how the diseases they or other 
    family members may possess can become a serious threat to their lives when viruses like COVID-19 hit, despite not being life-threatening in itself.
    As healthcare workers prioritize patients with comorbidities to receive the virus or have a stricter lockdown, it is important for people with prior
    diseases to prepare for situations such as a pandemic which can make them more frightened by the situation."),
  
  p("With this, we hope to answer the research question – “What are the areas most vulnerable during this time period?” 
    Utilizing three visualized analysis, this project aims to study the association between comorbidity conditions and COVID-19 deaths in the different areas of the 
    United States. Allocating medical resources, facilities, and staff is crucial during any pandemic outbreak. The result of this dataset analysis will point out 
    where more medical resources are needed."),
  
  img(src='Health_care_collapse.png'),
  p("Related Articles: "),
  p("https://time.com/6246045/collapse-us-health-care-system/"),
  p("https://www.cnn.com/2021/09/13/health/rationing-care-hospital-beds-staff-explainer-wellness/index.html")
  )
  
  # Page 2 - Visualization 1
page_two <- tabPanel(
  "Statewise Health Statistics", # label for the tab in the nav bar
  h1("An analysis of Geographical epidemiology during the COVID-19 epidemic | Epidemiological Insights: Statewise Health Statistics (2020-2023)"), 
  selectInput( # Drop down menu here:
    inputId = "state",
    label = "What State's information are you looking for? (Please select one from the Dropdown Menu)",
    choices = analysis_df$State[2:54]
  ),
  # Let's add a table here:
  tableOutput(outputId = "table"), 
  
  h1("A data overview of Health Metrics and Disease Trends: "),
  textOutput(outputId = "info"), #placeholders
  
)

# Page 3 - Visualization 2
page_three <- tabPanel(
  "Amount of deaths based on disease in each state",
  sidebarLayout(
    sidebarPanel(
      textInput("stateInput", "Which state would you like to analyze?", ""),
      actionButton("submitButton", "Submit"),
      br(),
      br(),
      h4("Using a bar graph, we are looking at how many deaths each disease
           (including COVID-19) has caused in a specific state."),
      p("This data highlights the contrast between the death rates of
           each disease to determine the most prominent cause of death in
           each state. Moreover, we are allowed to compare the impact that 
           COVID-19 has on deaths rates as compared to other diseases.")
    ),
    mainPanel(
      plotOutput("barplot", height = 500),
      #plotlyOutput("pieChart")
    )
  )
)

# Page 4 - Visualization 3
page_four <- tabPanel(
  #"Categorizing states by number of deaths",
  #plotlyOutput("pieChart")
  "Statewise Death Counts",
  sidebarLayout(
    sidebarPanel(
      p("This graphical representation is a stacked barplot illustrating each state 
        along the x-axis, with the respective numerical counts of their columns depicted 
        on the y-axis. The purpose of this diagram is to accentuate variations among states 
        within the United States, thereby identifying those with a heightened need for medical
        resources. This dataset serves as a valuable metric for guiding strategic decisions on 
        the optimal allocation of healthcare resources across the nation.")
    ),
    mainPanel(
      plotlyOutput("stacked_barplot"), 
    )
  )
)

# Page 5 - Summary and Main takeaways
page_five <- tabPanel(
  "Summary", # label for the tab in the nav bar
  h1("Summary: An analysis of Geographical epidemiology during the COVID-19 epidemic"), 
  p("This data story hopes to allow people to look at the impact COVID-19 along
    with other diseases has on human lives and the need for accessible health care. 
    With the recent COVID-19 pandemic, many common diseases have been considered 
    comorbidities to COVID-19 which increase the likelihood of getting the disease 
    and needing further health care."),
  p("The two datasets that were sourced from data.gov and was edited and combined to 
    be analyzed to compare the death rates of each disease (along with COVID-19) in 
    each state of the United States."),
  br(),
  p("-------Analysis conducted by Charlene Chang and Cristina Villaviciencio, Group BG-7 ---------"),
  p("Data collected from:"),
  p("https://catalog.data.gov/dataset/weekly-counts-of-deaths-by-state-and-select-causes-2019-2020"),
  p("https://data.cdc.gov/NCHS/Conditions-Contributing-to-COVID-19-Deaths-by-Stat/hk9y-quqm")
)

# Define UI ---
ui <- navbarPage(
  "An analysis of Geographical epidemiology during 2020-2023", # Application title
  page_one, # include the first page content
  page_two,
  page_three,
  page_four, 
  page_five
)


# Server stuff goes here: 
server <- function(input, output){
  output$info <- renderText({
    value <- analysis_df[analysis_df$State == input$state, "All.Cause"]
    paste(input$state, "’s weekly all-cause death total is ", value, ". 
          This generated table presents a comprehensive statistical overview
          of ", input$state, "selected state, offering a detailed insight into key 
          health-related metrics. It encompasses a range of parameters, including 
          but not limited to COVID-19 deaths, the number of mentions, all-cause
          deaths categorized by numerical ranges, and specific diseases such as 
          malignant neoplasms, diabetes mellitus, Alzheimer's disease, and others. 
          The data is organized in a structured format, facilitating a quick and 
          efficient assessment of the state's health profile. Users can leverage 
          this table to discern patterns, assess the severity of diseases, and 
          make informed comparisons with national or regional averages. The table 
          serves as a valuable tool for health analysts, policymakers, and researchers, 
          enabling them to derive meaningful insights into the health dynamics of the chosen state.")
  })
  
  output$table <- renderTable({
    #return (analysis_df)
    # Get the row corresponding to selected text
    state_df <- filter(analysis_df, State == input$state)
    return (state_df)
  })
  
  observeEvent(input$submitButton, {
    state <- input$stateInput
    #result <- source("final_analysis.R", local = TRUE, chdir = TRUE, keep.source = FALSE, echo = FALSE, prompt.echo = FALSE)$value(state)
    
    count_results <- get_number_disease_deaths(state)
    disease_data <- data.frame(
      Diseases = c("COVID-19", "Septicemia", "Diabetes", "Alzheimer", "Influenza/Pneumonia", 
                   "Chronic Respiratory Disease", "Nephritis", "Cerebrovascular"),
      Number_of_deaths = count_results
    )
    
    output$barplot <- renderPlot({
      barplot(disease_data$Number_of_deaths, names.arg = disease_data$Diseases, col = "pink")
    })
  })
  
  #counts <- get_count_per_category(df)
  #category_data <- data.frame(
    #group = c("0 - 100", "100 - 500", "500 - 1000", "1000 - 3000",
              #"3000 - 5000", "5000 - 10000", "greater than 10000"),
    #count_category = counts
  #)
  
  #output$pieChart <- renderPlotly({
    #plot_ly(df, labels = categories, values = counts, type = "pie", textinfo = "percent")
    #ggplot(category_data, aes(x="", y=count_category, fill=group)) +
    #geom_bar(stat="identity", width=1, color="black") +
    #coord_polar("y", start=0) +
    
    #theme_void()
    #plot_ly(category_data, labels = group, values = count_category, type = "pie", textinfo = "percent")
  #})
  
  # Assuming your numerical columns start from the 3rd column
  output$stacked_barplot <- renderPlotly({
    subset_df <- analysis_df[2:54, ]  # Select rows 2 to 54
    
    plot_ly(data = subset_df, x = ~State) %>%
      add_trace(type = 'bar', y = ~COVID.19.Deaths, name = 'COVID.19.Deaths') %>%
      add_trace(type = 'bar', y = ~Malignant.neoplasms..C00.C97., name = 'Malignant.neoplasms..C00.C97.') %>%
      add_trace(type = 'bar', y = ~Diabetes.mellitus..E10.E14., name = 'Diabetes.mellitus..E10.E14.') %>%
      add_trace(type = 'bar', y = ~Alzheimer.disease..G30., name = 'Alzheimer.disease..G30.') %>%
      add_trace(type = 'bar', y = ~Influenza.and.pneumonia..J09.J18., name = 'Influenza.and.pneumonia..J09.J18.') %>%
      add_trace(type = 'bar', y = ~Diseases.of.heart..I00.I09.I11.I13.I20.I51., name = 'Diseases.of.heart..I00.I09.I11.I13.I20.I51.') %>%
      add_trace(type = 'bar', y = ~Cerebrovascular.diseases..I60.I69., name = 'Cerebrovascular.diseases..I60.I69.') %>%
      
      # Add additional traces for other columns as needed
      layout(barmode = 'stack', title = 'Stacked Barplot of State Data',
             yaxis = list(title = 'Total Deaths Count'))  })
}

# Here's what actually makes the shiny app
shinyApp(ui = ui, server = server)