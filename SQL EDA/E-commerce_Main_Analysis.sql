--------------- Find out Max Payment from Customer ----------------------
SELECT max(P.["payment_value"]) as "Max Sale"
FROM olist_order_payments_dataset P;



--------------- Total Revenue for Each customer Id ----------------------
SELECT po.["product_category_name"], ROUND(SUM(op.["payment_value"]),0) AS total_revenue
INTO payment_value_by_category
FROM olist_order_items_dataset oi
JOIN 
	olist_order_payments_dataset op
ON 
	oi.["order_id"] = op.["order_id"]
JOIN
	olist_products_dataset po
ON
	oi.["product_id"] = po.["product_id"]
GROUP BY po.["product_category_name"]
ORDER BY total_revenue DESC;




--------------- Find the top-selling products by quantity -----------------
SELECT p.["product_category_name"], COUNT(oi.["product_id"]) AS total_quantity_sold
INTO Product_category 
FROM olist_products_dataset p
JOIN olist_order_items_dataset oi 
ON p.["product_id"] = oi.["product_id"]
GROUP BY p.["product_category_name"]
ORDER BY total_quantity_sold DESC;





---------- Calculate the average payment value per payment type ---------------
SELECT op.["payment_type"], ROUND(SUM(["payment_value"]),0) AS average_payment_value
FROM olist_order_payments_dataset op
GROUP BY ["payment_type"]
ORDER BY average_payment_value DESC;





---------- Identify customers with the highest number of orders ------------
SELECT c.["customer_id"], COUNT(o.order_id) AS order_count
FROM olist_customers_dataset c
JOIN olist_orders_dataset o 
ON c.["customer_id"] = o.customer_id
GROUP BY c.["customer_id"]
ORDER BY order_count DESC;




-------- Calculate the Average Shipping Cost and Average Price per product category -----------
SELECT p.["product_category_name"], ROUND(AVG(oi.["freight_value"]),0) AS avg_shipping_cost, ROUND(AVG(oi.["price"]),0) AS avg_price
INTO dbo.avg_shipping_costs_price
FROM olist_products_dataset p
JOIN olist_order_items_dataset oi 
ON p.["product_id"] = oi.["product_id"]
GROUP BY p.["product_category_name"]
ORDER BY avg_price DESC;




-------- Calculate the Average Shipping Cost and Average Price per product category -----------
SELECT AVG(DATEDIFF(day, o.order_approved_at, o.order_estimated_delivery_date)) AS average_shipping_duration
FROM olist_orders_dataset o
WHERE o.order_delivered_carrier_date IS NOT NULL 
	AND o.order_delivered_customer_date IS NOT NULL;




-------- Calculate the order status by amount of orders -----------
SELECT ord.order_status, COUNT(ord.order_id) AS total_amount_orders,
       ROUND((COUNT(ord.order_id) * 100.0 / SUM(COUNT(ord.order_id)) OVER ()),3) AS percentage
FROM olist_orders_dataset ord
GROUP BY ord.order_status
ORDER BY total_amount_orders DESC;




---------------------------------------------------------------------
SELECT D.["order_id"], OP.["product_category_name"], D.["price"], D.["freight_value"], P.["payment_value"]
FROM olist_order_items_dataset D

JOIN olist_order_payments_dataset P
ON D.["order_id"] = P.["order_id"]

JOIN olist_products_dataset OP
ON D.["product_id"] = OP.["product_id"]

GROUP BY D.["order_id"], OP.["product_category_name"], D.["price"], D.["freight_value"], P.["payment_value"]
ORDER BY ["payment_value"] DESC;




-------------Find top 5 customers with highest payment Value -------------------------
SELECT TOP 5 c.["customer_id"], c.["customer_city"], c.["customer_state"], ROUND(SUM(op.["payment_value"]),2) AS total_payment_value
FROM olist_customers_dataset c

JOIN olist_orders_dataset o 
ON c.["customer_id"] = o.customer_id

JOIN olist_order_payments_dataset op 
ON o.order_id = op.["order_id"]

GROUP BY c.["customer_id"], c.["customer_city"], c.["customer_state"]
ORDER BY total_payment_value DESC;



------------- Analyze order count trends over time -------------------------
SELECT DATEPART(YEAR, order_approved_at) AS year, DATEPART(MONTH, order_approved_at) AS month, COUNT(*) AS order_count
INTO product_sold_by_months
FROM olist_orders_dataset
GROUP BY DATEPART(YEAR, order_approved_at), DATEPART(MONTH, order_approved_at)
ORDER BY year, month;

