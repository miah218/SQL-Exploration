/*a SQL query to calculate the total sales of furniture products,
grouped by each quarter of the year, and order the results chronologically */

SELECT CONCAT('Q',DATEPART(QUARTER, o.ORDER_DATE),'-',CAST(YEAR(o.ORDER_DATE) AS VARCHAR)) AS Quarter_Year, ROUND(SUM(o.SALES),2) AS Total_Sales
FROM ORDERS o
LEFT JOIN PRODUCT p
ON o.PRODUCT_ID = p.ID
WHERE o.PRODUCT_ID LIKE 'FUR%'
GROUP BY YEAR(o.ORDER_DATE),DATEPART(QUARTER,o.ORDER_DATE)
ORDER BY YEAR(o.ORDER_DATE),DATEPART(QUARTER,o.ORDER_DATE);


/* analyse the impact of different discount levels on sales performance across product categories, 
specifically looking at the number of orders and total profit generated for each discount classification

Discount level condition:
No Discount = 0
0 < Low Discount < 0.2
0.2 < Medium Discount < 0.5
High Discount > 0.5 */

SELECT p.CATEGORY, COUNT(o.ORDER_ID) AS Total_Orders, ROUND(SUM(o.PROFIT),2) AS Total_Profit,
CASE WHEN o.DISCOUNT = 0 THEN 'No Discount'
WHEN o.DISCOUNT BETWEEN 0 AND 0.2 THEN 'Low Discount'
WHEN o.DISCOUNT BETWEEN 0.2 AND 0.5 THEN 'Medium Discount'
WHEN o.DISCOUNT > 0.5 THEN 'High Discount'
END AS Discount_classification
FROM ORDERS o
LEFT JOIN PRODUCT p
ON o.PRODUCT_ID = p.ID
GROUP BY p.CATEGORY, 
CASE WHEN o.DISCOUNT = 0 THEN 'No Discount'
WHEN o.DISCOUNT BETWEEN 0 AND 0.2 THEN 'Low Discount'
WHEN o.DISCOUNT BETWEEN 0.2 AND 0.5 THEN 'Medium Discount'
WHEN o.DISCOUNT > 0.5 THEN 'High Discount'
END
Order BY p.CATEGORY;

/* determine the top-performing product categories within each customer segment based on sales and profit, 
focusing on those categories that rank within the top two for profitability */

WITH RankedCategories AS (
SELECT 
c.SEGMENT, p.CATEGORY, ROUND(SUM(o.SALES),2) AS Total_Sales, ROUND(SUM(o.PROFIT),2) AS Total_Profit,
RANK() OVER(PARTITION BY c.SEGMENT ORDER BY ROUND(SUM(o.PROFIT),2) DESC) AS Profit_Rank,
RANK() OVER(PARTITION BY c.SEGMENT ORDER BY ROUND(SUM(o.SALES),2) DESC) AS Sales_Rank
FROM CUSTOMER c
RIGHT JOIN ORDERS o
ON c.ID = o.CUSTOMER_ID
LEFT JOIN PRODUCT p
ON o.PRODUCT_ID = p.ID
GROUP BY c.SEGMENT, p.CATEGORY
)
SELECT SEGMENT, CATEGORY, Total_Sales, Total_Profit, Sales_Rank,Profit_Rank 
FROM RankedCategories
WHERE Profit_Rank <=2
Order BY Total_Profit DESC, Total_Sales DESC; 

/*create a report that displays each employee's performance across different product categories, 
showing not only the total profit per category but also what percentage of 
their total profit each category represents, with the results ordered by the 
percentage in descending order for each employee
*/

WITH TotalProfit_CTE AS (
SELECT e.ID_EMPLOYEE, ROUND(SUM(o.PROFIT),2) AS Total_Profit
FROM ORDERS o
LEFT JOIN EMPLOYEES e
ON o.ID_EMPLOYEE = e.ID_EMPLOYEE
GROUP BY e.ID_EMPLOYEE
)
SELECT 
e.ID_EMPLOYEE, p.CATEGORY, ROUND(SUM(o.PROFIT),2) AS Total_Profit, 100* ROUND(SUM(o.PROFIT) / tp.Total_Profit,4) As Profit_Percentage
FROM EMPLOYEES e
RIGHT JOIN ORDERS o
ON e.ID_EMPLOYEE = o.ID_EMPLOYEE
LEFT JOIN PRODUCT p
ON o.PRODUCT_ID = p.ID
JOIN TotalProfit_CTE tp
ON e.ID_EMPLOYEE = tp.ID_EMPLOYEE
GROUP BY p.CATEGORY,e.ID_EMPLOYEE, tp.Total_Profit
ORDER BY e.ID_EMPLOYEE;


/*
evelop a user-defined function in SQL Server 
to calculate the profitability ratio for each product category an employee has sold, 
and then apply this function to generate a report that 
ranks each employee's product categories by their profitability ratio?
*/

CREATE FUNCTION dbo.CalculateProfitabilityRatio
(@EmployeeID INT,@ProductCategory NVARCHAR(100)
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
DECLARE @TotalSales DECIMAL(18, 2)
DECLARE @TotalProfit DECIMAL(18, 2)
DECLARE @ProfitabilityRatio DECIMAL(10, 2)
SELECT @TotalSales = SUM(o.SALES),@TotalProfit = SUM(o.PROFIT)
FROM ORDERS o
JOIN PRODUCT p ON o.PRODUCT_ID = p.ID
WHERE o.ID_EMPLOYEE = @EmployeeID 
AND p.CATEGORY = @ProductCategory;
IF @TotalSales = 0
SET @ProfitabilityRatio = 0
ELSE
SET @ProfitabilityRatio = (@TotalProfit / @TotalSales) 
RETURN @ProfitabilityRatio
END


SELECT e.ID_EMPLOYEE, p.CATEGORY, dbo.CalculateProfitabilityRatio(e.ID_EMPLOYEE,p.CATEGORY) AS Profitability_ratio
FROM EMPLOYEES e
RIGHT JOIN ORDERS o
ON e.ID_EMPLOYEE = o.ID_EMPLOYEE
LEFT JOIN PRODUCT p
ON o.PRODUCT_ID = p.ID
GROUP BY p.CATEGORY,e.ID_EMPLOYEE
ORDER BY e.ID_EMPLOYEE;

