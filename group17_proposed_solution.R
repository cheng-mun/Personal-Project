# Finalized Shiny App for Wilko Business Analysis Dashboard
# Includes 7 Visual Tabs Based on .qmd Analysis with Figure Labels

library(shiny)
library(ggplot2)
library(dplyr)
library(readr)
library(tidyr)

# Load dataset
wilko <- read_csv("wilko_dataset.csv")

# UI
ui <- fluidPage(
  titlePanel("Wilko Retail Performance Dashboard (2017–2023)"),
  sidebarLayout(
    sidebarPanel(
      helpText("Explore Wilko's performance across key operational dimensions through interactive visualizations.")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Figure 4: Rent vs Sales (Scatter)", plotOutput("fig4")),
        tabPanel("Figure 5: Rent vs Sales", plotOutput("fig5")),
        tabPanel("Figure 6: Inventory Efficiency", plotOutput("fig6")),
        tabPanel("Figure 7: Forecast vs Actual", plotOutput("forecast_accuracy")),
        tabPanel("Figure 8: Price Gap vs Sales", plotOutput("price_gap_vs_sales")),
        tabPanel("Figure 9: Promotion Effectiveness", plotOutput("promo_effectiveness"))
      )
    )
  )
)

# Server
server <- function(input, output) {

    # Figure 4: Scatter Plot of Rent Index vs Units Sold
 output$fig4 <- renderPlot({
    ggplot(wilko, aes(x = retail_rent_index, y = units_sold)) +
        geom_point(alpha = 0.4, color = "darkblue") +
        geom_smooth(method = "lm", se = FALSE, color = "red") +
        labs(
        title = "Figure 4: High Rent Locations vs Units Sold",
        x = "Retail Rent Index",
        y = "Units Sold"
        ) +
        theme_minimal()
    })


  # Figure 5: Rent vs Units Sold
  output$fig5 <- renderPlot({
    rent_sales <- wilko %>%
      group_by(year) %>%
      summarise(avg_rent = mean(retail_rent_index), avg_units = mean(units_sold))
    ggplot(rent_sales, aes(x = year)) +
      geom_line(aes(y = avg_rent, color = "Rent Index"), size = 1.2) +
      geom_line(aes(y = avg_units, color = "Units Sold"), size = 1.2) +
      scale_color_manual(values = c("Rent Index" = "red", "Units Sold" = "blue")) +
      labs(title = "Figure 5: Rent Index vs Units Sold", x = "Year", y = "Average Value", color = "Legend") +
      theme_minimal()
  })

  # Figure 6: Inventory Efficiency
  output$fig6 <- renderPlot({
    inventory_eff <- wilko %>%
      group_by(category) %>%
      summarise(ratio = mean(inventory_level) / (mean(units_sold) + 1))
    ggplot(inventory_eff, aes(x = reorder(category, ratio), y = ratio)) +
      geom_col(fill = "orange") +
      coord_flip() +
      labs(title = "Figure 6: Inventory-to-Sales Ratio by Category", x = "Category", y = "Inventory / Units Sold") +
      theme_minimal()
  })
  
  # Figure 7: Forecast vs Actual
  output$forecast_accuracy <- renderPlot({
    forecast_data <- wilko %>%
      group_by(category) %>%
      summarise(avg_forecast = mean(demand_forecast), avg_actual = mean(units_sold)) %>%
      pivot_longer(cols = c(avg_forecast, avg_actual), names_to = "type", values_to = "value")
    ggplot(forecast_data, aes(x = reorder(category, -value), y = value, fill = type)) +
      geom_col(position = "dodge") +
      scale_fill_manual(values = c("avg_forecast" = "blue", "avg_actual" = "red"), labels = c("Forecast", "Actual")) +
      labs(title = "Figure 7: Forecast vs Actual Sales by Category", x = "Category", y = "Avg Units", fill = "Legend") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
  
  # Figure 8: Price Gap vs Sales
  output$price_gap_vs_sales <- renderPlot({
    comp_df <- wilko %>%
      group_by(category) %>%
      summarise(avg_price_diff = mean(price - competitor_pricing), avg_units_sold = mean(units_sold))
    ggplot(comp_df, aes(x = reorder(category, -avg_units_sold))) +
      geom_col(aes(y = avg_units_sold), fill = "skyblue", width = 0.6) +
      geom_line(aes(y = avg_price_diff * 100, group = 1), color = "red", linewidth = 1) +
      geom_point(aes(y = avg_price_diff * 100), color = "red", size = 2) +
      scale_y_continuous(name = "Avg Units Sold", sec.axis = sec_axis(~ . / 100, name = "Avg Price Diff (£)")) +
      labs(title = "Figure 8: Units Sold vs Price Difference by Category", x = "Category") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })

  # Figure 9: Promotion Effectiveness
  output$promo_effectiveness <- renderPlot({
    promo_plot <- wilko %>%
      mutate(period = ifelse(year < 2020, "Pre-2020", "Post-2020"), promo_flag = ifelse(holiday_promotion == 1, "Promotion", "No Promotion")) %>%
      group_by(period, promo_flag) %>%
      summarise(avg_units = mean(units_sold))
    ggplot(promo_plot, aes(x = period, y = avg_units, fill = promo_flag)) +
      geom_col(position = "dodge") +
      labs(title = "Figure 9: Units Sold by Period & Promotion Status", x = "Period", y = "Avg Units Sold", fill = "Promotion") +
      theme_minimal()
  })




}

# Launch App
shinyApp(ui = ui, server = server)
