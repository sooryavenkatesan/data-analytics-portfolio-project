select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;

1.what is the total amount spent by each customer ?

select a.userid,sum(b.price) from sales a inner join product b on a.product_id = b.product_id group by a.userid;


2.how many days has each customer visited zomoto?

select userid,count(distinct created_date) from sales group by userid;

3.what was the first product purchased by each customer ?

select userid,CREATED_DATE,PRODUCT_ID,rank()over(partition by userid order by CREATED_DATE ASC)from sales;

4.what wss the most purchased item in the menu and how many times was it purchased by the customers ?


select   product_id,count(product_id)as most from sales group by product_id order by product_id DESC;

5.which item was the most popular for the customer?

select userid,rank() over(partition by cnt order by userid)as count from  
(select userid,count(product_id)as cnt from sales 
group by userid,product_id
order by userid);

6.which item was purcahsed first by the customer after they became a member?

select * from sales;
select * from goldusers_signup;

select c.*,rank() over(PARTITION by userid order by created_date)rnk from
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join goldusers_signup b on a.userid=b.userid and created_date<gold_signup_date) c ;


7.which item was purchased just before the customer becomes a member ?

select c.*,rank() over(PARTITION by userid order by created_date)rnk from
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join goldusers_signup b on a.userid=b.userid and created_date>gold_signup_date) c ;

8.what is the total order and amount spent by each customer before they become a member ?

select userid,count(created_date),sum(price) from
(select c.*,price from
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join goldusers_signup b on a.userid=b.userid and created_date<gold_signup_date) c inner join product d on c.product_id=d.product_id )e group by userid;


9.calculate  points collected by each customer?
p1 5rs = 1 point
p2 10rs = 2 point
p3 5rs = 1 point 

select * from sales;
select * from product;

select f.userid,sum(total_points) FROM
(select e.*,amount/points as total_points from
(select d.*,case when product_id = 1 then 5 when product_id = 2 then 1 when product_id = 3 then 5 else 0 end as points from
(select c.userid,c.product_id,sum(price)as amount from
(select a.*,b.price from sales a inner join product b on a.product_id=b.product_id)c group by userid,product_id)d)e)f group  by userid;

10.Calculate the most ponits collected by product?

select * from
(select g.*,rank() over(order by total_points_earned DESC ) as rank from
(select f.product_id,sum(total_points) as total_points_earned FROM
(select e.*,amount/points as total_points from
(select d.*,case when product_id = 1 then 5 when product_id = 2 then 1 when product_id = 3 then 5 else 0 end as points from
(select c.userid,c.product_id,sum(price)as amount from
(select a.*,b.price from sales a inner join product b on a.product_id=b.product_id)c group by userid,product_id)d)e)f group  by product_id)g)where rank=1;


11.what was their points earned in first year after became gold membership?

1zp= 2rs
0.5zp = 1 rs

select c.*,d.price*0.5 as total_points_earned from
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join goldusers_signup b on a.userid=b.userid where a.created_date>=b.gold_signup_date and a.created_date<=add_months(b.gold_signup_date,12))C  inner join product d on c.product_id=d.product_id;

12.rank all the transaction of the customer ?

select * from sales;


select userid,created_date,product_id,rank() over(partition by userid order by product_id) as rank from sales;

13. rank all the transaction for each member for gold member and for for non gold member mark as na ?

select * from sales;

SELECT e.*, 
       CASE WHEN rank = 0 THEN 'na' ELSE TO_CHAR(rank) END AS ranks 
FROM (
    SELECT c.*, 
           RANK() OVER (PARTITION BY userid ORDER BY gold_signup_date DESC) AS rank 
    FROM (
        SELECT a.userid, a.created_date, a.product_id, b.gold_signup_date 
        FROM sales a 
        LEFT JOIN goldusers_signup b ON a.userid = b.userid AND a.created_date < b.gold_signup_date
    ) c
) e;


