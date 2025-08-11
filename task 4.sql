create database task_4
use task_4
select * from data

--1. Simple SELECT + WHERE + ORDER BY
SELECT top 10 InvoiceNo,
       StockCode,
       Description,
       Quantity,
       UnitPrice,
       (Quantity * UnitPrice) AS LineTotal
FROM data
WHERE Quantity > 0
  AND InvoiceNo NOT LIKE 'C%' -- Exclude canceled orders
ORDER BY LineTotal DESC

--GROUP BY + Aggregate
SELECT top 10 Country,
       SUM(Quantity * UnitPrice) AS total_revenue,
       COUNT(DISTINCT InvoiceNo) AS total_orders
FROM data
WHERE Quantity > 0
GROUP BY Country
ORDER BY total_revenue DESC


--3. Average Revenue Per Customer
SELECT AVG(customer_total) AS avg_revenue_per_customer
FROM (
    SELECT CustomerID,
           SUM(Quantity * UnitPrice) AS customer_total
    FROM data
    WHERE Quantity > 0
      AND CustomerID IS NOT NULL
    GROUP BY CustomerID
); 

--4. Subquery Example

SELECT top 20 CustomerID,
       SUM(Quantity * UnitPrice) AS total_spent
FROM data
WHERE Quantity > 0
  AND CustomerID IS NOT NULL
GROUP BY CustomerID
HAVING SUM(Quantity * UnitPrice) > (
    SELECT AVG(customer_total)
    FROM (
        SELECT CustomerID,
               SUM(Quantity * UnitPrice) AS customer_total
        FROM data
        WHERE Quantity > 0
          AND CustomerID IS NOT NULL
        GROUP BY CustomerID
    )
)
ORDER BY total_spent DESC
;


--5. HAVING Example

SELECT top 20 StockCode,
       Description,
       SUM(Quantity) AS units_sold
FROM data
GROUP BY StockCode, Description
HAVING SUM(Quantity) > 200
ORDER BY units_sold DESC
;

--6. View for Analysis

CREATE VIEW customer_revenue AS
SELECT CustomerID,
       SUM(Quantity * UnitPrice) AS total_revenue,
       COUNT(DISTINCT InvoiceNo) AS total_orders,
       AVG(Quantity * UnitPrice) AS avg_order_value
FROM transactions
WHERE Quantity > 0
  AND CustomerID IS NOT NULL
GROUP BY CustomerID;

--7. Index for Optimization
CREATE INDEX idx_customer ON transactions(CustomerID);
CREATE INDEX idx_invoice ON transactions(InvoiceNo);
CREATE INDEX idx_date ON transactions(InvoiceDate);






