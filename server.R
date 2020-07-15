#Libraries
library(shiny)
library(shinydashboard)
library(readxl)
library(d3treeR)
library(tidyverse)
library(tidyr)
library(plotly)
library(circlepackeR)
library(data.tree)
library(reshape2)
library(streamgraph)
library(treemap)
library(sunburstR)
library(d3r)

#All the input files
#Unemployment dataset of the world
data <- read_excel("unemployment_world.xlsx")
#Crime dataset for Australia for circlepack graph
data_circ_crime <- read_excel("hom_crime_aust_2.xlsx")
data_circ_crime
colnames(data_circ_crime) <- c( "year","status", "division", "subdivision","incidents")
#Crime dataset for sunburst graph
data_sun <- read_excel("homi_crime_sun.xlsx")
colnames(data_sun) <- c("year","status", "division","size")
# Reformat data for the sunburstR package
data_sun<-data_sun %>%
  group_by(year,status,division) %>%
  summarise(size=sum(size))

#Crime dataset for streamgraph
data_st <- read_excel("homicide_stream.xlsx")
data_st
colnames(data_st) <- c( "Country"," Code", "2009", "2010","2011","2012","2013","2014","2015","2016","2017","2018")
data_st
data_stream_crime<-gather(data_st,"Year","HR",`2009`:`2018`)
data_stream_crime
data_stream_crime <- data_stream_crime %>%
  group_by("Year", "Country")
data_st1 <- read_excel("selfmade_unemp.xlsx")
data_st1
#Server side 
shinyServer(function(input,output){
  #Bar graph
  output$bar_graph_crime<-renderPlotly({
    string_year_bar<-toString(input$year_bar)
    data_st1<-data_st1 %>%
      filter(year %in% c(string_year_bar))
    data_st1$states <- factor(data_st1$states, levels = unique(data_st1$states)[order(data_st1$unemp_rate, decreasing = TRUE)])
    
    p <- plot_ly(data_st1, x = ~states, y = ~unemp_rate, type = 'bar', color = I("black")) %>%
      layout(
             xaxis = list(title = "STATES"),
             yaxis = list(title = "UNEMPLOYMENT RATE"))
    
    p
    
  })
  #Streamgraph
  output$streamgraph_crime<-renderStreamgraph({
    data_stream_crime %>%
      streamgraph("Country", "HR","Year", offset="zero",interpolate = "linear",width = "250%", height="400px") %>%
      sg_legend(show=TRUE, label="Country: ")  %>%
      sg_axis_x(1, "Year", "%Y")
  })
  #Sunburst
  output$sunburst_crime<-renderSunburst({
    tree <- d3_nest(data_sun, value_cols = "size")
    tree
    p<-sunburst(tree,legend=TRUE)
    p
    
  })
  #Circlepacking
  output$circlepack_crime<-renderCirclepackeR({
    string_year<-toString(input$year_circle)
    data_circ_crime<-data_circ_crime %>%
      filter(year %in% c(string_year))
    
    # Change the format. This use the data.tree library. This library needs a column that looks like root/group/subgroup/..., so I build it
    data_circ_crime$pathString <- paste("homicide", data_circ_crime$year,data_circ_crime$status, data_circ_crime$division, data_circ_crime$subdivision, sep = "/")
    data_circ_crime$pathString
    homi <- as.Node(data_circ_crime)
    
    circlepackeR(homi, size = "incidents",color_min = "hsl(56,80%,80%)", color_max = "hsl(341,30%,40%)",width = 800, height = 700)
    
  
    
  })
  #Treemap
  output$Treemap_unemp <- renderD3tree2({
    stringconv<-toString(input$year)
    group_name<-paste(stringconv,"_group",sep="")
    print(group_name)
    group_color<-paste(group_name,"_color",sep="")
    p<-treemap(data,

                 # data
                 print(group_color),
                 index=c(group_name, "Country Name",stringconv),
                 print(stringconv),
                 vSize=stringconv,
                 type="index",

                 # Main
                 title="Unemployment rate of all Country with respect to Australia",
                 palette="Spectral",
                 algorithm = "pivotSize",
                 sortID = "-size",
  
                 fontsize.title=12,

                 # Borders:
                 border.col=c("black", "grey", "grey"),
                 border.lwds=c(1,0.5,0.1),

                 # Labels
                 fontsize.labels=c(1.3, .4, 0.3),
                 fontcolor.labels=c("white", "white", "black"),
                 fontface.labels=1,
                 bg.labels=c("transparent"),
                 align.labels=list( c("center", "center"), c("center", "center"), c("center", "center")),
                 overlap.labels=0.5,
                 
                 inflate.labels=T
                 )
    d3tree2(p ,rootname = "Unemployment Rate" ) #d3 function for treemap
    
    
  })
})











