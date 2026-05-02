# Google Data Analytics Capstone — Case Study
## Step 1: ASK — Business Task Document

**Analyst:** George Robles
**Date:** April 2026
**Course:** Google Data Analytics Professional Certificate

---

## Business Task Statement

As a junior data analyst, I have been tasked with analyzing transactional data from a general online retail store to **understand customer buying behavior**. The goal is to uncover patterns in purchasing habits, identify high-value customer segments, and surface actionable insights that can guide marketing and sales strategy decisions.

---

## Business Question

> **"What patterns exist in customer purchasing behavior, and how can these insights help the business better serve its customers and grow revenue?"**

---

## Supporting Questions

1. Who are the most valuable customers, and what do they buy most?
2. When do customers make purchases — are there seasonal or time-based trends?
3. Which products have the highest demand and which are underperforming?
4. Which countries or regions generate the most revenue?
5. What is the average order value, and how does it vary by customer segment?
6. Are there any patterns in product returns or cancellations?

---

## Stakeholders

| Stakeholder | Role | Interest in Analysis |
|---|---|---|
| Marketing Team | Primary | Identify target customer segments for campaigns |
| Sales Manager | Primary | Understand top products and peak sales periods |
| Executive Leadership | Secondary | High-level revenue trends and growth opportunities |
| Product Team | Secondary | Identify underperforming or frequently returned products |

---

## Dataset Overview

- **Source:** Online Retail II Dataset — UCI Machine Learning Repository / Kaggle
- **Time Period:** December 2009 – December 2011
- **Size:** ~1 million+ transactions
- **Key Fields:** InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country

---

## ROCCC Data Credibility Check

| Criteria | Assessment |
|---|---|
| **Reliable** |  Real transactional data from a UK-based online retailer |
| **Original** | Sourced directly from UCI Machine Learning Repository |
| **Comprehensive** |  Contains customer, product, date, quantity, and price data |
| **Current** |  Data is from 2009–2011; useful for behavioral analysis but not real-time trends |
| **Cited** |  Publicly available and cited academic source |

---

## Known Limitations

- Dataset does not include customer demographics (age, gender, etc.)
- Some CustomerIDs are missing (guest/anonymous purchases)
- Negative quantities represent product returns and must be handled separately
- Data is limited to one retailer and may not generalize to all e-commerce businesses
- Currency is in British Pounds (£); converted to USD using 1.27 exchange rate

---

## Scope & Deliverables

**In scope:**
- Sales trend analysis by time period (monthly, seasonal)
- Customer segmentation by purchase frequency and value
- Product performance analysis (top sellers, returns)
- Geographic revenue breakdown by country

**Out of scope:**
- Real-time or predictive analysis
- Customer demographic profiling
- Social media or marketing channel analysis

**Final Deliverables:**
1. Cleaned dataset with change log (Google Sheets)
2. SQL queries and summary statistics (BigQuery)
3. Python analysis notebook with visualizations (Kaggle)
4. Presentation with findings and recommendations (Google Slides)

---

## Tools to Be Used

| Phase | Tool | Purpose |
|---|---|---|
| Process | Google Sheets | Data cleaning, removing duplicates, formatting |
| Analyze (SQL) | BigQuery (free tier) | Summary stats, trend queries, aggregations |
| Analyze (Python) | Kaggle Notebooks | Deep analysis, charts, visualizations |
| Share | Google Slides | Stakeholder presentation |

---

*This document was prepared as part of the Google Data Analytics Professional Certificate Capstone Project (Case Study).*
