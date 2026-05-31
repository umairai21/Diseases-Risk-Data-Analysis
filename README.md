# Global Cardiometabolic Risk Dashboard (1980–2014)

><img width="1139" height="653" alt="image" src="https://github.com/user-attachments/assets/59fa5270-ee21-487a-ae34-81d7ef54c85e" />



---

## Project Overview

This project is an end-to-end data analytics solution tracking the **35-year longitudinal trajectory** of four major non-communicable diseases (NCDs) across **200 nations**. It analyzes the shifting global burden of Obesity, Diabetes, Blood Pressure, and Cholesterol, highlighting the stark divergence in global health outcomes.

The project demonstrates full-stack data analyst capabilities — starting from raw CSV ingestion and relational database architecture in PostgreSQL, moving through complex SQL transformations and EDA, and culminating in an interactive executive dashboard built in Power BI.

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| Backend | PostgreSQL, pgAdmin 4 |
| Frontend | Power BI Desktop |
| Languages | SQL (DDL, DML, CTEs, Window Functions, Aggregations) |

---

## The Dataset

The raw data consists of four distinct datasets (~42,000+ rows total) detailing the prevalence of specific cardiometabolic risk factors segmented by **Country**, **Year**, and **Sex**.

| File | Coverage |
|------|----------|
| `blood_pressure.csv` | 1975–2015 |
| `obesity.csv` | 1975–2016 |
| `diabetes.csv` | 1980–2014 |
| `cholesterol.csv` | 1980–2018 |

---

## Methodology & Data Architecture

A core challenge of this project was resolving the **chronological disparities** between the four datasets to create a statistically valid, unified analysis. Instead of relying on frontend tools for data transformations, the entire data pipeline was architected in PostgreSQL.

### Pipeline Stages

1. **Raw Ingestion** — Data was loaded into four distinct relational tables.
2. **Exploratory Data Analysis (EDA)** — Profiling queries revealed mismatched start and end years across the datasets.
3. **View Materialization (`master_health_data`)** — A master SQL View was created using strict `INNER JOIN` logic on `country`, `sex`, and `year`. This deliberately stripped away non-overlapping years, establishing a perfectly clean **Maximum Common Overlap (1980–2014)**. This prevented NULL-value corruption in downstream correlation analysis and combined risk scoring.

---

## Key Insights & SQL Analysis

The PostgreSQL backend was used to answer critical public health questions before visualizing the data, including:

- Calculating the **total absolute percentage point growth** in specific risk factors by country over the 35-year window.
- Categorizing demographic groups into **High, Medium, and Low-Risk** buckets based on dynamic thresholds.
- Identifying **anomalies** where historical global averages were aggressively outpaced by specific regional spikes.

The full suite of analysis queries — including Common Table Expressions (CTEs) and subqueries — can be found in [`analysis_queries.sql`](./analysis_queries.sql).

---

## Dashboard Features (Power BI)

The Power BI dashboard connects directly to the PostgreSQL `master_health_data` view (DirectQuery/Import), ensuring no raw data manipulation occurs in the frontend.

| Feature | Description |
|---------|-------------|
| **Dynamic Slicing** | Page-level interactive filters for Year, Sex, and Country |
| **Scorecard KPIs** | Top-level dynamic cards tracking absolute global averages for immediate context |
| **Longitudinal Tracking** | Multi-line trend analysis mapping the aggressive rise of obesity against the gradual decline of hypertension |
| **Correlation Mapping** | Scatter plot visualizations proving the mathematical relationship between rising BMI and diabetes prevalence |

---

## How to Run This Project

### Prerequisites

- [PostgreSQL](https://www.postgresql.org/download/) + pgAdmin 4 (or any SQL client)
- [Power BI Desktop](https://powerbi.microsoft.com/desktop/)

### Setup Steps

1. **Clone this repository**
   ```bash
   git clone https://github.com/your-username/your-repo-name.git
   cd your-repo-name
   ```

2. **Create the database**

   Open pgAdmin (or your preferred SQL client) and create a new database named `global_health_ncd`.

3. **Run the schema setup script**

   Execute `schema_setup.sql` to create the raw tables and ingest the CSV data.
   ```sql
   -- Run in pgAdmin or psql
   \i schema_setup.sql
   ```

4. **Generate the master view**

   Execute `create_master_view.sql` to build the unified `master_health_data` view.
   ```sql
   \i create_master_view.sql
   ```

5. **Open the Power BI dashboard**

   Open `Global_Health_Dashboard.pbix` in Power BI Desktop.

   > **Note:** You may need to update the **Data Source settings** to point to your local PostgreSQL instance (`localhost`, port `5432`, database `global_health_ncd`).

---

## Repository Structure

```
.
├── data/
│   ├── blood_pressure.csv
│   ├── obesity.csv
│   ├── diabetes.csv
│   └── cholesterol.csv
├── sql/
│   ├── schema_setup.sql
│   ├── create_master_view.sql
│   └── analysis_queries.sql
├── Global_Health_Dashboard.pbix
└── README.md
```

---

## License

This project is licensed under the [MIT License](./LICENSE).
