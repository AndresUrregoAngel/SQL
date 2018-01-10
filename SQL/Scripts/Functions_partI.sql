create table #sales  -- temporal table , that exist only in memory whereas I'm runnig this query
(
id_number varchar(20),
Sales_Amount varchar(30)
)


--Inserting values in the temporal table

insert into #Sales
VALUES ('1','US $ 1000')
insert into #Sales
VALUES ('2','US $ 1200')
insert into #Sales
VALUES ('12','US $ 1400')
insert into #Sales
VALUES ('15','US $ 24000')
insert into #Sales
VALUES ('3','US $ 5000')
insert into #Sales
VALUES ('23','CAD $ 6000')
insert into #Sales
VALUES ('4','CAD $ 5500')
insert into #Sales
VALUES ('25','CAD $ 600')
insert into #Sales
VALUES ('30','CAD $ 1000')
insert into #Sales
VALUES ('31','CAD $ 9000')


/* I query the table expecting get as outcome everything 
order by id number but as the number is an string (varchar)
SQL is not able to sorted as I need*/

select * from #Sales
order by 1 ASC

/* Now I apply my first cast on id column to get the suitable
sort by id*/

select cast(id_number as int) as id,Sales_Amount from #Sales
order by 1 ASC

/* Now let's see the cas in the column Sales Amount , it's
impossible to apply a sum function in a string column, but we
could apply a substring function to clean it and and then add
a secondary function cast to get numbers, finally a third function to
apply the required sum*/

--quick explanation
-- the varchar field was declared with a lenght of 30
-- the symbol $ and the currency description take from position 1 to 6 in the string

select sum(cast(substring(Sales_Amount,6,30) as int)) as total from #sales


/* this third example introduce you a new useful and powerful function 
called CASE. I want to know the sales per currency but I need to get firstly 
the currency and then the amount belonging to each currency instead substring
I will use LEFT pretty similar to SUBSTRING, Then a function called replace
to avoid the symbol. Then I reuse my previous query to clean the amount $
*/

/*I will create a temporary view with this query already formatted as I need before apply the 
function CASE*/ 

---- To run this last queries always run it fro the 'WITH brief'

WITH brief
AS (
SELECT
REPLACE(LEFT(Sales_Amount,4) ,'$','') AS currency, -- get just the currency name
cast(substring(Sales_Amount,6,30) as int) as amount -- get the amount per currency
FROM 
#Sales )

-- Now I want to get just the sum for US but instead a where filter I use CASE

SELECT
currency, -- I get the currency
SUM(CASE WHEN currency = 'US' THEN amount ELSE 0 END) -- I just sum if it's US
FROM brief
GROUP BY currency




---Finally I delet my temporal table
drop table #Sales
