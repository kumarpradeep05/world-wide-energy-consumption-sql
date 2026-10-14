# world-wide-energy-consumption-sql
SQL project analyzing global energy consumption, production, emissions, GDP, and population using MySQL, with JOINs, CTEs, subqueries, aggregate functions, and window functions to identify trends and insights.

# 🌍 World Wide Energy Consumption Analysis Using SQL

## 📌 Project Overview

This project analyzes global energy consumption, energy production, carbon emissions, GDP, and population across different countries and years using **MySQL**.

The objective is to transform raw datasets into meaningful insights by identifying trends, comparing countries, and studying the relationships between energy usage, economic growth, and environmental impact.

## 🎯 Project Objectives

- Analyze country-wise energy consumption and production.
- Identify countries with the highest GDP and emissions.
- Examine global emission trends over time.
- Calculate per-capita energy consumption and emissions.
- Analyze emission-to-GDP and consumption-to-GDP ratios.
- Study the relationship between population, economic growth, and energy usage.

## 🗂️ Dataset Description

The project uses six related datasets, based on the EIA source described in the project brief.

| Table | Description |
|---|---|
| `country_3` | Country reference data |
| `consum_3` | Energy consumption |
| `production_3` | Energy production |
| `emission_3` | Emissions by energy type and year |
| `gdp_3` | GDP by country and year |
| `population_3` | Population by country and year |

## 🛠️ Tools & Technologies

- **Database:** MySQL
- **Query Language:** SQL
- **Concepts:** JOINs, GROUP BY, aggregate functions, subqueries, CTEs, and window functions
- **Analysis Techniques:** Trend analysis, ranking, year-over-year comparisons, and per-capita calculations

## 🔍 Key Analysis Performed

1. Total emissions by country for the latest available year.
2. Top five countries by GDP.
3. Energy production versus consumption comparisons.
4. Emissions by energy type.
5. Global emissions trends over time.
6. GDP and population trend analysis.
7. Per-capita emissions and consumption calculations.
8. Emission-to-GDP and consumption-to-GDP ratios.
9. Year-over-year changes using the `LAG()` window function.
10. Global emission contribution by country.

## 💡 Key Learnings

- Practiced writing SQL queries to analyze multiple related datasets.
- Improved understanding of relational databases and JOIN operations.
- Used CTEs and window functions for time-series analysis.
- Learned to calculate ratios and per-capita metrics.
- Developed analytical thinking to interpret energy and environmental data.

## 📁 Project Structure

```text
world-wide-energy-consumption-sql/
│
├── README.md
├── energy_analysis.sql
└── Energy_Consumption_Analysis.pdf
```

## 🚀 How to Run the Project

1. Install MySQL Server and MySQL Workbench.
2. Create the database using the provided SQL script.
3. Import the six CSV datasets into the corresponding tables.
4. Open `energy_analysis.sql` in MySQL Workbench.
5. Execute the queries to explore energy, economic, and environmental trends.

## 📈 Project Outcome

This project demonstrates practical SQL skills in data exploration, multi-table analysis, aggregation, and time-series comparisons. It provides a structured approach to understanding global energy patterns and their relationship with economic and environmental indicators.

## 👨‍💻 Author

**Kumar Pradeep**

B.Tech – Computer Science and Engineering

GitHub: [kumarpradeep05](https://github.com/kumarpradeep05)

LinkedIn: [Connect with me](https://www.linkedin.com/in/kumar-pradeep-emmadisetty-6921543a7/)

---

⭐ If you find this project useful, feel free to explore the repository!

