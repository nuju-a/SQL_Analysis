SHOW  DATABASES;
-- task1
SELECT 
    name,
    city
FROM
    foodhub.customers
;
SELECT 
    name,
    cuisine
FROM
    foodhub.restaurants
;
-- task2
SELECT
-- using upper function to give a consistent name case in uppercase
    upper(name) AS Customer_name,
-- using trim and lower function to trim whitespaces and return trimed
-- city in lower case.
    LOWER(TRIM(city)) AS City,
-- using concat function to join together the above with a space format between them
CONCAT(
    UPPER(name),
    ' - ',
    LOWER(TRIM(city))
) AS Customer_label 
FROM
    foodhub.customers
;

SELECT cuisine,
       SUBSTRING_INDEX(cuisine, ' ', 1) AS first_word
FROM foodhub.restaurants;

-- TASK3
SELECT
    fo.customer_id,
    fo.restaurant_id,
    fo.order_date,
    fr.name,
    -- using cast inside this concat block is important because values must be in text form to fit the
    -- contact syntax data type requirement whuch is string otherwise an error code occurs
    CONCAT(
    'Order #',
    CAST(order_id AS CHAR),
    ': ',
     item_name,
     ' x',
    CAST(quantity AS CHAR),
    ' @ ',
    CAST(price AS CHAR),
    ' USD'
) AS order_summary 
FROM
    foodhub.orders AS fo
INNER JOIN
    foodhub.restaurants AS fr
ON
    fo.restaurant_id = fr.restaurant_id
;
-- if i try to concat int or decimal without converting to char it eturn error code 1583
-- an incorrect parameter error

-- task4
SELECT
    order_id,
    order_date,
    YEAR(order_date) AS Year,
    MONTH(order_date) AS Month,
    DAY(order_date) AS day,
    -- using the datediff function to calculate the differnce btw now date and last
    -- order date
    DATEDIFF(NOW(),order_date) AS 'Days Ago',
    -- the date__add function adds 3days interval to order date to establish a delvery date
    DATE_ADD(order_date, INTERVAL 3 DAY) AS 'Est. delivery'
FROM
    foodhub.orders
    -- filtering to the first 2week in a month my initail try used a between resulting
    -- in a hardcode that would have failed if other months exist.
WHERE
    DAY(order_date) <= 15
;

-- using the year(order date) is a simplified systems approach and that hard codeed and 
-- is unlikely to return an error but using a substring may if filtering isnt done well
