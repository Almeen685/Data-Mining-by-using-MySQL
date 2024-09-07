create schema Retail_shop;
use Retail_shop;
select * from online_retail; 
##2:distribution of order value accross all customer in data set
select customerID,sum(Quantity * Unitprice)as Ordervalue 
from online_retail
group by customerID;
select case when OrderValue < 50 then 'Low Spender'
when OrderValue between 50 and 200 then 'Medium Spender'
else'High Spender' end as SpendingCategory,
count(CustomerID) as NumberofCustomers
from (select CustomerID,
sum(Quantity*UnitPrice)as OrderValue
from online_retail
group by CustomerID)  as subquery
group by SpendingCategory;

-- 3: unique products customer purchased
select CustomerID,count(distinct StockCode) as UniqueProductPurchased
from online_retail
group by CustomerID;
-- 4:which cutomer have only single purchase from the company
select CustomerID,count(distinct InvoiceNo) as NumberofPurchases
from online_retail
group by CustomerID
having  NumberofPurchases = 1;



select p1.StockCode as Product1,
p2.StockCode as Product2,
count(*) as TimePurchasedTogether
from online_retail p1
join online_retail p2 on p1.InvoiceNo = p2.InvoiceNo and p1.StockCode < p2.StockCode
group by p1.StockCode, p2.StockCode
order by TimePurchasedTogether desc;

-- ADVANCED QUERIES
select CustomerID,count(distinct InvoiceNo) as PurchaseFrequency
from online_retail
group by CustomerID;

select CustomerID,PurchaseFrequency,
case
when PurchaseFrequency <=2 then 'Low Frequency'
when PurchaseFrequency between 3 and 5 then 'Medium Frequency'
else 'High Frequency' end  as FrequencySegment
from (select CustomerID,count(distinct InvoiceNo)
as PurchaseFrequency
from online_retail
group  by CustomerID) as FrequencyTable;


-- calculate the average order value for each country
select Country, avg(ordervalue) as AverageOrderValue 
from (select InvoiceNo, Country,sum(Quantity * UnitPrice) as OrderValue
from online_retail
group by InvoiceNo,Country) as OrderValues
group by Country
order by AverageOrderValue desc;

-- identify customers who haven't made a purchase in specific period

with LastPurchase as ( select CustomerID, max(InvoiceDate) as LastPurchaseDate
from online_retail
group by CustomerID)
select CustomerID,LastPurchaseDate
from LastPurchase
where LastPurchaseDate<'2024-03-01';
----- product affinity analysis
select StockCode,
count(*) as PurchaseCount
from online_retail
group by StockCode
order by PurchaseCount desc
limit 10;


-- monthly sales
select year(InVoiceDate) as year,
month(InVoiceDate) as month,
sum(Quantity * UnitPrice) as MonthlySales
from online_retail
group by year(InvoiceDate),month(InvoiceDate)
order by year,month;

-- quaterly sales 
select year(InVoiceDate) as year,
quarter(InVoiceDate) as quarter,
sum(Quantity * UnitPrice) as QuaterlySaes
from online_retail
group by year(InVoiceDate),quarter(InVoiceDate)
order by year, quarter;

