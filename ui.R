#Libraries
library(shiny)
library(shinydashboard)
library(dplyr)
library(colorRamps)

# This is for the UI Page.
data <- read_excel("unemployment_world.xlsx")

shinyUI(
  dashboardPage(title = "Australia Towards Stress Sustainability", skin = "yellow",
  # This is the title of the project
    dashboardHeader(title = "STRESS ANALYSIS",titleWidth = "26%"),
  #This is for the the side bar.
    dashboardSidebar(
      sidebarMenu(
        #These are the tabs necessary for the project
      menuItem("Motivation",tabName = "motivation",badgeLabel = "About",badgeColor = "red",icon = icon("adn")),
      menuItem("Unemployment Analysis",icon = icon("suitcase")),
        menuSubItem("Australia",tabName = "australia-states"),
        menuSubItem("Australia's proximity-countries",tabName = "Australia_unemp_world"),
      menuItem("Crime Analysis",icon = icon("balance-scale")),
        menuSubItem("Australia",tabName = "crime_australia_sun"),
        menuSubItem("Australia-Detailed",tabName = "crime_australia"),
        menuSubItem("Australia's proximity-countries",tabName = "crime_world")

    ),collapsed = TRUE ),# so that the dashboard can be collapsed
  #The body of the dashboard 
  dashboardBody(
    tags$head(tags$style(HTML('
      .main-header .logo {
        font-family: "Georgia", Times, "Times New Roman", serif;
        font-weight: bold;
        font-color: black;
        font-size: 20px;
      }
    '))),
    tabItems(
      #Circle packing graph 
      tabItem(tabName ="crime_australia",
              fluidRow(
                
                box(title = "Levels of Crimes in Australia on Specific Year",status="warning",solidHeader = FALSE,circlepackeROutput("circlepack_crime",width = "70%", height="450px"),width = 50,height = 500,collapsible = TRUE),
                box(title= "Control for Year",status="warning",solidHeader = TRUE,
                    #inputs for the users
                    selectInput("year_circle","Year",
                                c( "2009",
                                   "2010",
                                   "2011",
                                   "2012",
                                   "2013",
                                   "2014",
                                   "2015",
                                   "2016",
                                   "2017")
                    )),
                #Info box
                box(title = "Circlepacke Graph",status="info",solidHeader = TRUE,
                    p("Each level of the crimes can be clicked and found out in the  graph, the first level is for the states of the crimes, second level is for the  crime division and third level is for the crime subdivision.
"))
              )),
      #Treemap 
      tabItem(tabName = "Australia_unemp_world",
        fluidRow(
          #This are the area where the plot appears
          box(title = "The proximity level of each Country with Australia",status="warning",solidHeader = FALSE,d3tree2Output("Treemap_unemp",width = "95%", height="500px"),width = 8, height="590px"),
          box(title= "Control for Year",status="warning",solidHeader = TRUE,width = 4,height = 40,
              selectInput("year","Year",
                          c( "2009",
                             "2010",
                             "2011",
                             "2012",
                             "2013",
                             "2014",
                             "2015",
                             "2016",
                             "2017",
                             "2018")
              )),
          #Info box
          box(title = "Treemap",status="info",solidHeader = TRUE,
              p("The categories are color coded using Spectral palette where the middle category is AU Proximity(red), Less than AU(Light red), More than AU(orange), Worse than AU(light Orange)."),
              p("Single click-Countries belonging to the category"),
              p("Second Click-Unemployment Rate for each country"))
          
        )),
      tabItem(tabName = "australia-states",
          #Bar graph
          fluidPage(
            box(title="Current Unemployment Status of Australian States",solidHeader=FALSE,status="warning",plotlyOutput("bar_graph_crime")),
            box(title= "Control for Year",status="warning",solidHeader = TRUE,
                selectInput("year_bar","Year",
                            c( "2014",
                               "2018",
                               "2019")
                )),
            box(title = "Bar Graph",status="info",solidHeader = TRUE,
               p("The current status of Australia with respect to  unemployment rate only for three years. The Bar graph is set to descending order as the state with the worst unemployment rate would be the first graph.From this the best and worst state of unemployment rate an be understood."))
          )),
      tabItem(tabName = "motivation", 
              #About
              fluidPage(
                #imageOutput("australia_flag"),
                #box(
                h1("Australia's Stance Towards Stress Sustainability"),
                p("A country’s peace and position can be determined by few factors which helps in the prediction of its sustainability in this world. The stressful countries are those that fail to provide its citizens with enough amenities and protection. The stress can come in different forms ranging from insufficient supplies to armed conflicts. The severity of the stress upon people can be high even in advanced economies.Here, the stress level of few countries in comparison with Australia can be visualised. The propitious sign of an emerging economy strives to bring down the most stressful factors like unemployment and homicide level to its minimal. Due to the country’s instability, the mental stress of its people elevates leading to unwanted armed and unarmed conflicts. Through this project, Unemployment and Homicide datas of Australia and few other countries are explored as these are the two factors often substantiate and portrays the persona of a developed country."),
                img(src="australia_flag_map.jpg",width = 150, height = 100, position = "right"),
                h2("Why Australia?"),
                p("This confusing era makes us question our survival in any country. The impending threat in all countries poses a huge problem but the Australian government and the genuine spirit of the citizens keeps the wheel of peace rotating without any hiccups.The purview of the economic stature of Australia conveys a strong message worldwide that their perseverance and resilience helped to achieve their goal in reducing unemployment and a strong judiciary system to elevate their current position and impetus enough to be proud Australians and immigrants."),
                box(title="Unemployment Analysis",status ="danger", solidHeader = TRUE,
                    h3("SubTab1-Australia"),
                    "The Bar graph to show the current statsu of all the states in Australia",
                    h3("SubTab2-Australia's proximity-countries"),
                    "The Treemap to show the countries that comes under the differnt hierarchies in relation with Australia's Rate"),
                box(title="Crime Analysis",status ="danger", solidHeader = TRUE,
                    h3("SubTab1-Australia "),
                    "The Sunburst graph to show the  distribution percentage of crime divisions in Australia for each year",
                    h3("SubTab2-Detailed Australia"),
                    "The Circle Packing Graph to show the status, divions and subdivisions of crime for each year of Australia",
                    h3("SubTab3-Australia's proximity-countries"),
                    "The StreamGraph to show differnt countries's crime Rate "
                    )
              
              )
        
      ),
      tabItem(tabName ="crime_australia_sun",
              #Sunbusrt
              fluidRow(
              box(title = "Yearly Percentage of Crime Levels in Australia",status="warning",solidHeader = TRUE,sunburstOutput("sunburst_crime",width = "50%", height="400px"),width = "10%", height="700px",collapsible = TRUE )
      )),
      
      tabItem(tabName ="crime_world",
              #Streamgraph
              fluidRow(
                box(title = "Crime rate of the countries much worse than Australia",status="warning",solidHeader = TRUE,streamgraphOutput("streamgraph_crime",width = "100%", height="600px"),width = "100%", height="800px")
              ))
      
    )
    
    )
 )
)



