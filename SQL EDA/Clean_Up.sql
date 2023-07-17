/****** Script for SelectTopNRows command from SSMS  ******/
UPDATE olist_orders_dataset
SET order_estimated_delivery_date = CONVERT(DATE, order_estimated_delivery_date);

UPDATE olist_orders_dataset
SET order_approved_at = CONVERT(DATE, order_approved_at);

UPDATE olist_orders_dataset
SET order_delivered_carrier_date = CONVERT(DATE, order_delivered_carrier_date);

UPDATE olist_orders_dataset
SET order_delivered_customer_date = CONVERT(DATE, order_delivered_customer_date);

Select *
FROM  olist_geolocation_dataset

UPDATE olist_geolocation_dataset
SET ["geolocation_zip_code_prefix"] = REPLACE(["geolocation_zip_code_prefix"], '"', '')
WHERE ["geolocation_zip_code_prefix"] LIKE '%"%"%';


UPDATE olist_customers_dataset
SET ["customer_zip_code_prefix"] = REPLACE(["customer_zip_code_prefix"], '"', '')
WHERE ["customer_zip_code_prefix"] LIKE '%"%"%';



----------------Order Items Table-----------------------
SELECT *
FROM olist_order_items_dataset;


UPDATE olist_order_items_dataset
SET ["shipping_limit_date"] = CONVERT(DATE, ["shipping_limit_date"]);


UPDATE olist_order_items_dataset
SET """price""" = """price""" * 0.21;

UPDATE olist_order_items_dataset
SET """freight_value""" = """freight_value""" * 0.21;



------------------------Order Payment Table------------------
SELECT *
FROM olist_order_payments_dataset;


UPDATE olist_order_payments_dataset
SET ["payment_value"] = ["payment_value"] * 0.21;

UPDATE olist_order_payments_dataset
SET ["payment_value"] = ROUND(["payment_value"], 2);



------------------------Order Products Table------------------
SELECT *
FROM olist_products_dataset;


------------------------Order Sellers Table------------------
SELECT *
FROM olist_sellers_dataset;

UPDATE olist_sellers_dataset
SET ["seller_zip_code_prefix"] = REPLACE(["seller_zip_code_prefix"], '"', '')
WHERE ["seller_zip_code_prefix"] LIKE '%"%"%';

ALTER TABLE olist_sellers_dataset
ALTER COLUMN ["seller_zip_code_prefix"] INT;


------------------------Order product category Table------------------
SELECT *
FROM olist_products_dataset;

SELECT *
FROM product_category_name_translation;


-- Update Translation to English (Map from other Table)--
UPDATE olist_products_dataset 
SET ["product_category_name"] = T.product_category_name_english
FROM olist_products_dataset
JOIN product_category_name_translation T 
ON olist_products_dataset.["product_category_name"] = T.product_category_name;

SELECT *
FROM olist_products_dataset;
