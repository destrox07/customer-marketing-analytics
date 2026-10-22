# 📊 Customer & Marketing Analytics

An end-to-end data analytics project exploring retail customer behavior, revenue performance, and customer segmentation using Python, PostgreSQL, SQL, and Power BI.
<img width="1233" height="735" alt="dashboard" src="https://github.com/user-attachments/assets/d48ba33b-33b6-4fc4-8e02-14720c22a532" />

## 🎯 Project Overview

The goal of this project is to transform retail transaction data into actionable business insights. The analysis focuses on customer purchasing behavior, revenue distribution, and opportunities to improve customer retention.

## 🛠️ Tools & Technologies

- **Python** — Data cleaning and preprocessing
- **PostgreSQL** — Data storage and SQL analysis
- **SQL** — Data aggregation and customer metrics
- **Power BI** — Interactive dashboards and data visualization
- **DAX** — KPI calculations and analytical measures
- **RFM Analysis** — Customer segmentation based on recency, frequency, and monetary value

## 📁 Project Structure

```text
customer-marketing-analytics/
├── README.md
├── sql/
│   └── customer_marketing_analytics.sql
├── powerbi/
│   └── Customer_Marketing_Analytics.pbix
└── screenshots/
    └── dashboard.png
```

*The structure above is a guide. It should reflect the files actually uploaded to the repository.*

## 📈 Dashboard Features

- **Total Customers** — Number of unique customers analyzed.
- **Total Revenue** — Positive sales revenue in the cleaned dataset.
- **Average Customer Spend** — Average monetary value per customer.
- **Average Orders per Customer** — Average number of distinct invoices per customer.
- **Customers by Segment** — Customer distribution across six customer groups.
- **Revenue by Segment** — Revenue contribution of each customer group.
- **Monthly Revenue** — Revenue trends over time.
- **Revenue by Country** — Comparison of revenue across countries.

## 🔍 Key Findings

Based on the current cleaned dataset and customer segmentation:

- **4,338 customers** were identified.
- Approximately **£8.89 million** in positive sales revenue was analyzed.
- The Champions segment accounts for approximately **21.8% of customers** and contributes around **64.5% of revenue**.
- At Risk, Needs Attention, and Hibernating customers represent potential opportunities for targeted retention and re-engagement campaigns.

## 🧹 Data Preparation

The project uses the [UCI Online Retail dataset](https://archive.ics.uci.edu/dataset/352/online+retail).

The cleaned sales analysis excludes cancelled invoices and invalid sales rows, including records with non-positive quantities or unit prices. Customer metrics are calculated from the cleaned transactions.

**Note:** Revenue is not profit. The customer segmentation rules are analytical groupings and should be documented alongside the SQL implementation.

## 💡 Business Recommendations

1. **Retain high-value customers:** Develop loyalty initiatives for Champions and Loyal Customers.
2. **Re-engage inactive customers:** Test targeted campaigns for At Risk and Hibernating customers.
3. **Improve customer retention:** Monitor purchase frequency and time since last purchase.
4. **Optimize marketing:** Compare segment performance and country-level revenue to guide campaign priorities.

## 🚀 Future Improvements

- Customer lifetime value analysis
- Cohort and retention analysis
- Customer churn prediction
- Sales forecasting
- Automated data refresh and reporting

## 👨‍💻 Author

**Raed Hammouda**

Artificial Intelligence and Data Analytics Student  
University of Trieste, Italy

**Areas of interest:** Data Analytics, Business Intelligence, SQL, Python, and Artificial Intelligence.
