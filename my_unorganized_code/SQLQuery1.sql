WITH cts_totalsale AS
(
    SELECT
        customerid,
        SUM(sales) AS totalsales
    FROM orders
    GROUP BY customerid
),

cts_lastorderdate AS
(
    SELECT
        customerid,
        MAX(orderdate) AS lastorderdate
    FROM orders
    GROUP BY customerid
),

cts_rank AS
(
    SELECT
        customerid,
        RANK() OVER (ORDER BY totalsales DESC) AS customer_rank
    FROM cts_totalsale
)

SELECT
    c.customerid,
    c.firstname,
    ts.totalsales,
    ld.lastorderdate,
    r.customer_rank
FROM customers c
LEFT JOIN cts_totalsale ts
    ON c.customerid = ts.customerid
LEFT JOIN cts_lastorderdate ld
    ON c.customerid = ld.customerid
LEFT JOIN cts_rank r
    ON c.customerid = r.customerid;