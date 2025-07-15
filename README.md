# 📊 Advanced Sales Data Exploration with SQL

## 🧭 Project Overview

This project focuses on advanced SQL querying to uncover key insights from sales, product, customer, and employee data. 

The project aims to answer strategic business questions by writing clean, modular SQL scripts and implementing a User-Defined Function (UDF) to calculate a profitability metric.

## 🎯 Key Objectives

1. Analyse quarterly sales performance for furniture products.

2. Evaluate the effect of discounts on profitability.

3. Identify top-performing categories within each customer segment.

4. Assess employee-level performance across product categories.

5. Build and apply a UDF for profitability ratio computation per employee and category.

## 🗂️ Datasets Used

ORDERS – Sales transactions with profit, sales, product ID, employee, and discount info.

PRODUCT – Product details, including category and ID.

CUSTOMER – Customer segments and metadata.

EMPLOYEES – Employee details.

### 1️⃣ Quarterly Sales of Furniture Products

- Objective: Calculate the total sales of furniture products, grouped by each calendar quarter and ordered chronologically.

- Approach:

Filtered products with IDs starting with 'FUR%'.

Extracted quarter and year from ORDER_DATE.

Aggregated total sales.

Sorted chronologically.

- Insight: Helped visualise seasonal trends in furniture sales to support inventory and marketing strategy.

### 2️⃣ Impact of Discount Levels on Sales & Profit

- Objective: Group sales by discount levels and evaluate order count and total profit per product category.

- Discount Classification Logic:

No Discount: = 0

Low Discount: > 0 and < 0.2

Medium Discount: ≥ 0.2 and < 0.5

High Discount: > 0.5

- Insight: Highlighted discount tiers that positively or negatively impacted profitability across categories.

### 3️⃣ Top Product Categories by Customer Segment

- Objective: Rank product categories by profit and sales for each customer segment, and filter for top 2 in profit.

- Insight: Enabled tailored marketing and product focus for each customer segment.

### 4️⃣ Employee Performance Across Product Categories

- Objective: Show each employee’s total profit by category and what percentage of their overall profit each category represents.

- Insight: Identified employee specialisations or dependencies on certain product lines.

### 5️⃣ Profitability Ratio Function (UDF)

Objective: Develop a user-defined function that calculates the profitability ratio per employee and product category.

## 🧠 Key Skills Demonstrated

Window functions (RANK() OVER)

Aggregations & groupings

Conditional logic with CASE

Common Table Expressions (CTEs)

User-Defined Functions (SQL Server)

Advanced joins for multi-table analysis

## 🧰 Tools Used
SQL Server Management Studio (SSMS)

Excel (data source)

