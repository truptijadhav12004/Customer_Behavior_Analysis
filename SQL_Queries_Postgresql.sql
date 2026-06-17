 Q1)  what is  the total revenue genarated by male vs female customers?
      select gender, SUM(purchase_amount) as revenue
      from customer
      group by gender

 Q2) which customers used discount but still spent more than the average purchase amount?
    select customer_id, purchase_amount
    from customer
    where discount_applied = 'Yes' and purchase >= (select AVG(purchase_amount) from customer)

Q3)  which are the top 5 product with the highest average  review rating?
    select item_purchased, ROUND(AVG(review_rating::numeric),2) as "Average Product Rating"
    from customer 
    group by item_purchased
   order by avg(review_rating)desc
   limit 5;

Q4) compare the average purchase amount between standard and express shipping
 select shipping_type,
ROUND(AVG(purchase_amount),2)
from customer
where shipping_type in('Standard','Express')
group by shipping_type;

Q5) Do subscribed customer spend more? Compare average spend and total revenue between subscribers and non-subscribers
select subscription_status,
COUNT(customer_id) as total_customers,
ROUND(AVG(purchase_amount),2) as avg_spend,
ROUND(SUM(purchase_amount),2) as total_revenue
from customer
group by subscription_status
order by total_revenue, avg_spend desc;

Q6) which 5 product have highest percentage of purchase with discount applied?
select item_purchased,
ROUND(100 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) /COUNT(*) * 100,2) as discount_rate
from customer
group by item_purchased
order by discount_rate desc
limit 5;

Q7) Segment customer into New, Returning, and Loyal based on their total number of previous purchases, and show the count of each Segment
with customer_type as(
select customer_id, previous_purchases,
CASE
   WHEN previous_purchases = 1 THEN 'New'
   WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
   ELSE 'Loyal'
   END AS customer_segment
from customer
)

select customer_segment, count(*) as "Number of Customers"
from customer_type
group by customer_segment;

Q8) what are the top 3 most purchased product within each category?
   with item_counts as (
  select category,
  item_purchased,
COUNT(customer_id) as total_orders,
ROW_NUMBER() over (partition by category order by count(customer_id) DESC) as item_rank
from customer
group by category, item_purchased
)
select item_rank, category, item_purchased, total_orders
from item_counts
 Where item_rank <=3;     

Q9) are customers who are repeat buyers (more than 5 previous purchases) also likely to subscriber?
select subscription_status, 
count(customer_id) as repeat_buyers
from customer
where previous_purchases > 5
group by subscription_status;

Q10) what is the revenue contribution of each group?
select age_group,
SUM(purchase_amount)as total_revenue
from customer
group by age_group
order by total_revenue desc;


