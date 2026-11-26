USE northwind;
SHOW TABLES;

SELECT
    c.CustomerID,
    o.OrderID,
    RANK() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC) AS order_alfki
FROM
   northwind.customers AS c
INNER JOIN
    northwind.orders AS o
ON
    c.CustomerID = o.CustomerID
WHERE c.CustomerID = 'ALFKI'
;

SELECT 
    OrderID, 
    OrderDate,
    RANK() OVER (ORDER BY OrderDate DESC) AS Order_rank
FROM 
    Orders 
WHERE 
    CustomerID = 'ALFKI'
;
SELECT * FROM northwind.products;

SELECT
    OrderID,
    Quantity,
    SUM(Quantity) OVER (ORDER BY OrderID) AS running_total
FROM northwind.orderdetails
;
SELECT
    CustomerID,
    OrderDate,
    LAG(OrderDate) OVER (PARTITION BY CustomerID) AS previous_date,
    abs((OrderDate) - (LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate)
    )) AS date_difference
FROM
    northwind.orders
;

SELECT 
    CustomerID, 
    OrderDate, 
    LAG(OrderDate, 1) OVER 
        (PARTITION BY CustomerID 
        ORDER BY OrderDate) AS PrevOrderDate, 
    TIMESTAMPDIFF(
        DAY,
        LAG(OrderDate, 1) OVER (PARTITION BY CustomerID ORDER BY OrderDate),
        OrderDate
    ) AS DateDiff
FROM 
    Orders;


SELECT 
    OrderID, 
    ProductID, 
    Quantity,
    AVG(Quantity) OVER (
        PARTITION BY ProductID 
        ORDER BY OrderID 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS MovingAvgQuantity
FROM 
    OrderDetails
ORDER BY 
    ProductID, 
    OrderID;
SELECT 
    CustomerID, 
    OrderDate, 
    LAG(OrderDate, 1) OVER 
        (PARTITION BY CustomerID 
        ORDER BY OrderDate) AS PrevOrderDate, 
    TIMESTAMPDIFF(
        DAY,
        LAG(OrderDate, 1) OVER (PARTITION BY CustomerID ORDER BY OrderDate),
        OrderDate
    ) AS DateDiff
FROM 
    Orders;
    
    USE retailedge;

SELECT
    p.category,
    o.order_id ,
    o.customer_id,
    o.unit_price*o.quantity AS total_order_value,
    ROW_NUMBER()OVER (PARTITION BY p.category 
    ORDER BY o.unit_price*o.quantity DESC)  AS row_num
FROM
    retailedge.orders AS o
INNER JOIN
    retailedge.products as p
ON
    o.product_id = p.product_id
;

SELECT
    customer_id,
    SUM(quantity*unit_price) AS total_spend,
    RANK() OVER (ORDER BY SUM(quantity*unit_price) DESC )AS rank_ascending
FROM
    retailedge.orders
GROUP BY
    customer_id
ORDER BY
    rank_ascending ASC
;


SELECT
    order_id,
    order_date,
    quantity*unit_price AS order_value,
    LAG(quantity*unit_price,1) OVER (
    ORDER BY order_date ASC) AS previous_order_value,
    -- calculating rate of change percentage between current and previous_order_value
    ROUND(
        (
            (quantity * unit_price - LAG(quantity * unit_price, 1) OVER (ORDER BY order_date ASC))
            / LAG(quantity * unit_price, 1) OVER (ORDER BY order_date ASC)
        ) * 100,
        2
    ) AS rate_of_change
FROM
    retailedge.orders
;
USE united_nations;
SELECT
    DISTINCT Country_name,
    length(Country_name) AS lenght,
    position('(' IN Country_name) AS pos_count,
    rtrim(LEFT(Country_name,position('(' IN Country_name)-1)) AS extract,
    length(rtrim(LEFT(Country_name,position('(' IN Country_name)-1))) AS new_lenght
FROM
    united_nations.access_to_basic_services
WHERE
    Country_name LIKE '%(%)%'
;

SELECT
    Country_name,
    Time_period,
    Est_population_in_millions,
concat(
    SUBSTRING(IFNULL (UPPER(Country_name),'Unknown'),1,5),
    SUBSTRING(IFNULL(Time_period,'Unknown'),1,5),
    SUBSTRING(IFNULL(Est_population_in_millions,'Unknown'),-7)
    )
    AS Country_id
    FROM
        united_nations.access_to_basic_services
;
