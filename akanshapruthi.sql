#-- Solution to Question 7
#-- Write a query to display carton id, (len*width*height) as carton_vol and identify the optimum carton (carton with the least volume whose volume is greater than the total volume of all items (len * width * height * product_quantity)) for a given order whose order id is 10006, Assume all items of an order are packed into one single carton (box).

select C.carton_id as 'Carton_ID',
	   (C.len*C.width*C.height) as 'Carton_Volume'
from orders.carton C
where (C.len*C.width*C.height) >= (
select sum(P.len*P.WIDTH*P.HEIGHT*OI.PRODUCT_QUANTITY) AS VOL 
 FROM
ORDERS.ORDER_ITEMS OI
INNER JOIN ORDERS.PRODUCT P ON OI.PRODUCT_ID = P.PRODUCT_ID 
WHERE OI.ORDER_ID =10006)
ORDER BY (C.LEN*C.WIDTH*C.HEIGHT) ASC
LIMIT 1; 


#-- Solution to Question 8
#-- Write a query to display details (customer id,customer fullname,order id,product quantity) of customers who bought more than ten (i.e. total order qty) products per shipped order.

select OC.customer_id as 'Customer ID',
	   concat(OC.customer_fname,'',OC.customer_lname) as 'Customer Full Name',
        OH.order_id as 'Order ID',
        sum(OI.product_quantity) as 'Total_Product_Quantity'
from online_customer OC
	inner join order_header OH on 
    OH.customer_id = OC.Customer_id
    inner join order_items OI on
    OI.order_id = OH.order_id
where OH.order_status ='Shipped' group by OH.order_id
having Total_Product_Quantity > 10 
order by OC.customer_id;
   
 
 #-- Solution to Question 9
 #-- Write a query to display the order_id, customer id and cutomer full name of customers along with (product_quantity) as total quantity of products shipped for order ids > 10060. (6 ROWS) 
        
select OH.order_id as 'Order ID',
		OC.customer_id as 'Customer ID',
        concat(OC.customer_fname,'',OC.customer_lname) as 'Customer_Full_Name',
        sum(OI.product_quantity) as 'Total_Product_Quantity'
from online_customer OC
	inner join order_header OH on
    OH.CUSTOMER_ID = OC.CUSTOMER_ID
    inner join order_items OI on
    OI.order_id = OH.order_id
where OH.ORDER_STATUS = 'Shipped' and OH.ORDER_ID > 10060
group by OH.ORDER_ID order by Customer_Full_Name;


#-- Solution to Question 10
#-- Write a query to display product class description ,total quantity (sum(product_quantity),Total value (product_quantity * product price) and show which class of products have been shipped highest(Quantity) to countries outside India other than USA? Also show the total value of those items. (1 ROWS)

select PC.product_class_desc as 'Product Description',
		PC.product_class_code as 'Product Code',
	   sum(OI.product_quantity) as 'Total_Quantity',
       sum(OI.product_quantity*P.product_price) as 'Total_value'
from order_items OI
	inner join order_header OH on
    OH.ORDER_ID = OI.ORDER_ID
    inner join online_customer OC on
    OC.CUSTOMER_ID = OH.CUSTOMER_ID
    inner join product P on
    P.PRODUCT_ID = OI.PRODUCT_ID
    inner join product_class PC on
    PC.PRODUCT_CLASS_CODE = P.PRODUCT_CLASS_CODE
    inner join address A on
    A.ADDRESS_ID = OC.ADDRESS_ID
where OH.ORDER_STATUS='Shipped' and A.COUNTRY not in ('India','USA')
group by PC.PRODUCT_CLASS_CODE, PC.PRODUCT_CLASS_DESC
order by Total_Quantity desc 
limit 1;

#--- THE END ---
        

