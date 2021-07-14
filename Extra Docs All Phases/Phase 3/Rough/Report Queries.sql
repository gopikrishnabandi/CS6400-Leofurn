use [cs6400_Sp21_team052]
go
/*Report 1*/
Select C.Category_Name, Count(Distinct P.PID) as 'Count', Min(P.Retail_Price) as 'Min Retail Price', round(avg(P.Retail_Price),2) as 'Avg Retail Price'	,max(P.Retail_Price) as 'Max Retail Price'
from Category C 
Left Outer Join 
Product P 
on C.PID=P.PID 
group by C.Category_Name 
order by C.Category_Name ASC;


/*Report 2*/
/*if(isnull(S.Quantity),0,S.Quantity)*/


Select P.PID,P.Product_Name,P.Retail_Price,
sum(Sa.Quantity) as 'Total Units',
sum(case when D.Discount_Price is null then Sa.Quantity else 0 end ) as 'Retail Units',
sum(case when D.Discount_Price is null then 0 else Sa.Quantity end) as 'Discount Units',
sum(case when D.PID =Sa.PID and D.Discount_Date=Sa.[Date] then D.Discount_Price else P.Retail_price end *Sa.Quantity)as 'Actual Revenue',
sum(case when D.PID =Sa.PID and D.Discount_Date=Sa.[Date] then P.Retail_price else P.Retail_price end *case when D.PID =Sa.PID and D.Discount_Date=Sa.[Date] then Sa.Quantity*0.75 else Sa.Quantity end)as 'Predicted Revenue',
sum(case when D.PID =Sa.PID and D.Discount_Date=Sa.[Date] then D.Discount_Price else P.Retail_price end *Sa.Quantity)-sum(case when D.PID =Sa.PID and D.Discount_Date=Sa.[Date] then P.Retail_price else P.Retail_price end *case when D.PID =Sa.PID and D.Discount_Date=Sa.[Date] then Sa.Quantity*0.75 else Sa.Quantity end) as 'Difference'
FROM Product P 
join Category C
on C.PID=P.PID
 join
Sale Sa
on P.PID=Sa.PID
join [Date] DT
on Sa.[Date]=DT.[Date]
left outer join Discount D
on Sa.PID=D.PID
and Sa.[Date]=D.Discount_Date
Where C.Category_Name='Couches and Sofas'
group by P.PID,P.Product_Name,P.Retail_Price
having ABS(sum(case when D.PID =Sa.PID and D.Discount_Date=Sa.[Date] then D.Discount_Price else P.Retail_price end *Sa.Quantity)-sum(case when D.PID =Sa.PID and D.Discount_Date=Sa.[Date] then P.Retail_price else P.Retail_price end *case when D.PID =Sa.PID and D.Discount_Date=Sa.[Date] then Sa.Quantity*0.75 else Sa.Quantity end))>'5000' 
order by 'Difference' desc
;

/*Report 3*/
select S.Store_Number,S.Street_Address,S.City_Name,year(Sa.[Date]) as 'Year', 
sum(case when D.PID =Sa.PID and D.Discount_Date=Sa.[Date] then D.Discount_Price else P.Retail_price end*Sa.Quantity) as 'Total Revenue'
from Store S
join City C on 
S.City_Name=C.City_Name
and C.State_Name=S.State_Name
join State st
 on St.State_Name=C.State_Name
and S.State_Name=St.State_Name
join Sale Sa on
S.Store_Number=Sa.Store_number
join [Date] Dt on
Dt.[Date]=Sa.[Date]
join Product P on
Sa.PID=P.PID
left outer join Discount D
on Sa.PID=D.PID
and Sa.[Date]=D.Discount_Date
where St.State_Name='CA' 
group by S.Store_Number,S.Street_Address,S.City_Name,year(Sa.[Date])
order by year(Sa.[Date]) asc,'Total Revenue' desc;


/*Nevada,Wisconsin*/

/*Report 4*/

select distinct year(Sa.[Date]) as 'Year',sum(Sa.Quantity) as 'Total Units',round(cast(sum(Sa.Quantity) as float)/365,2) as 'Avg Units Per Day',
sum(case when month(Sa.[Date])=2 and day(Sa.[Date])=2 then Sa.Quantity Else 0 end) as 'Units Sold on GH Day'
from Sale Sa
join [Date] Dt on
Dt.[Date]=Sa.[Date]
join Product P on
Sa.PID=P.PID
join Category Ca on
P.PID=Ca.PID
where Ca.Category_Name='Outdoor Furniture'
group by year(Sa.[Date]) order by  year(Sa.[Date]) asc;

/*Report 5*/
select C.Category,B.State_Name,C.Number_Of_Units	from 
(
select distinct A.Category as 'Category',
max(Quant) over (partition by A.Category) as 'Number_Of_Units'
from 
(
select Ca.Category_Name as 'Category', St.State_Name as 'State_Nm', sum(Sa.Quantity) as 'Quant'
from Store S
join Sale Sa
on S.Store_Number=Sa.Store_Number
Join City C on
S.City_Name=C.City_Name
and C.State_Name=S.State_Name
join State st
 on St.State_Name=C.State_Name
and S.State_Name=St.State_Name
join Product P on
Sa.PID=P.PID
join Category Ca on
P.PID=Ca.PID
join [Date] Dt on
Dt.[Date]=Sa.[Date]
where year(Sa.[Date])='2001'
and Month(Sa.[Date])='12'
group by Ca.Category_Name,St.State_Name) A 
)C

join (

select Ca.Category_Name as 'Category', St.State_Name as 'State_Name', sum(Sa.Quantity) as 'Quantity'
from Store S
join Sale Sa
on S.Store_Number=Sa.Store_Number
Join City C on
S.City_Name=C.City_Name
and C.State_Name=S.State_Name
join State st
 on St.State_Name=C.State_Name
and S.State_Name=St.State_Name
join Product P on
Sa.PID=P.PID
join Category Ca on
P.PID=Ca.PID
join [Date] Dt on
Dt.[Date]=Sa.[Date]
where year(Sa.[Date])='2001'
and Month(Sa.[Date])='12'
group by Ca.Category_Name,St.State_Name) B
on C.Category=B.Category
and C.Number_Of_Units=B.Quantity order by C.Category;



/*Report 6*/

select distinct year(Sa.[Date]) as 'Year',sum(IIF(C.population<3700000, case when D.Discount_Price is null then P.Retail_Price else D.Discount_Price end *Sa.Quantity , 0 )) as 'Small',
sum(IIF( C.population >=3700000 and C.population<6700000,case when D.Discount_Price is null then P.Retail_Price else D.Discount_Price end *Sa.Quantity,0)) as 'Medium',
sum(IIF( C.population >=6700000 and C.population<9000000,case when D.Discount_Price is null then P.Retail_Price else D.Discount_Price end *Sa.Quantity,0)) as 'Large',
sum(IIF( C.population >=9000000,case when D.Discount_Price is null then P.Retail_Price else D.Discount_Price end *Sa.Quantity,0)) as 'Extra Large'

from Store S
join City C on 
S.City_Name=C.City_Name
and C.State_Name=S.State_Name
join State st
 on St.State_Name=C.State_Name
and S.State_Name=St.State_Name
join Sale Sa on
S.Store_Number=Sa.Store_number
join [Date] Dt on
Dt.[Date]=Sa.[Date]
join Product P on
Sa.PID=P.PID
left outer join Discount D
on Sa.PID=D.PID
and Sa.[Date]=D.Discount_Date
group by year(Sa.[Date])
order by year(Sa.[Date]) asc;

/*Report 7*/


use [cs6400_Sp21_team052]

alter procedure childcarevolume as

declare @sql nvarchar(max)='';
 declare @columns nvarchar(max)='';
 declare @columns_nonnull nvarchar(max)='';
 declare @maxdate date;
 DECLARE @WhereClause VARCHAR(MAX)='';
 SELECT @columns+=quotename(Limit_Mins)+',' from 
(select   DISTINCT (L.Limit_Mins 
    )  as 'Limit_Mins' 
  from
Limit L
 ) AS lIMITS
SET @columns=left(@columns, len(@columns)-1)
print @columns

SELECT @columns_nonnull+='coalesce('+quotename(Limit_Mins)+',0)'+' as ['+ convert(varchar(10),[Limit_Mins])+'],' from 
(select   DISTINCT (L.Limit_Mins 
    )  as 'Limit_Mins' 
  from
Limit L
 ) AS lIMITS
 SET @columns_nonnull=left(@columns_nonnull, len(@columns_nonnull)-1)
 print @columns_nonnull


 set @maxdate=(select max([Date]) from Sale)
print @maxdate

set @WhereClause=@WhereClause+'WHERE Sa.[Date] >= DATEADD(year, -1, DATEFROMPARTS(YEAR('+''''+CONVERT(varchar(25),@maxdate,120)+''''+'), MONTH('+''''+CONVERT(varchar(25),@maxdate,120)+''''+'), 1))
  AND Sa.[Date] < DATEFROMPARTS(YEAR('+''''+CONVERT(varchar(25),@maxdate,120)+''''+'), MONTH('+''''+CONVERT(varchar(25),@maxdate,120)+''''+'), 1)'
  print @Whereclause
 

 SET @sql='select [Month_Name],coalesce([No Childcare],0) as [No Childcare] ,'+@columns_nonnull +' from (
SELECT
     datename(month,Sa.[Date]) AS [Month_Name],
	 year(Sa.[Date]) as Year_I,
	 month(Sa.[Date]) as Month_I,
     convert(varchar(10), case  when S.Childcare_Flag=1 then S.Limit_Mins else 0 end) as [Limit_Mins],
         round(sum(case when S.Childcare_Flag = 1 then case when D.PID =Sa.PID and D.Discount_Date=Sa.[Date] then D.Discount_Price else P.Retail_price end*Sa.Quantity else 0 end),2) as [Amount]
FROM
   Store S 
join Sale Sa on
S.Store_Number=Sa.Store_number
join [Date] Dt on
Dt.[Date]=Sa.[Date]
join Product P on
Sa.PID=P.PID
left outer join Discount D
on Sa.PID=D.PID
and Sa.[Date]=D.Discount_Date
'+@WhereClause+'
 
 
GROUP BY
   datename(month,Sa.[Date]) ,
   year(Sa.[Date]),
    month(Sa.[Date]) ,
   case  when S.Childcare_Flag=1 then S.Limit_Mins else 0 end
   having round(sum(case when S.Childcare_Flag = 1 then case when D.PID =Sa.PID and D.Discount_Date=Sa.[Date] then D.Discount_Price else P.Retail_price end*Sa.Quantity else 0 end),2)<>0
   
      union all
   SELECT
     datename (month,Sa.[Date]) AS [Month_Name],
	 year(Sa.[Date]) as Year_I,
	 month(Sa.[Date]) as Month_I,
     ''No Childcare'' as [Limit_Mins],
     round(sum(case when S.Childcare_Flag = 0 then case when D.PID =Sa.PID and D.Discount_Date=Sa.[Date] then D.Discount_Price else P.Retail_price end*Sa.Quantity else 0 end),2) as [Sales_Amount]
       
FROM
    Store S 
join Sale Sa on
S.Store_Number=Sa.Store_number
join [Date] Dt on
Dt.[Date]=Sa.[Date]
join Product P on
Sa.PID=P.PID
left outer join Discount D
on Sa.PID=D.PID
and Sa.[Date]=D.Discount_Date
'+@WhereClause+'


GROUP BY
   datename(month,Sa.[Date]),
   year(Sa.[Date]),
    month(Sa.[Date]) 
   )A
 
   PIVOT(sum(Amount) for Limit_Mins in ('+@columns+
',[No Childcare]
 ) )as PIVOTTable order by Year_I,Month_I'
  
  print @sql

 

  execute sp_executesql @sql


/*Report 8*/

select C.Category_Name,
case when S.Restaurant_Flag=	1 then 'Restaurant' 
else 'Non-restaurant' end as 'Store Type',
sum(Sa.Quantity) as 'Quantity'
from Store S join Sale Sa
on S.Store_Number=Sa.Store_number
join Product P on 
P.PID=Sa.PID
join Category C
on C.PID=P.PID
group by C.Category_Name,case when S.Restaurant_Flag=	1 then 'Restaurant' 
else 'Non-restaurant' end order by C.Category_Name asc,'Store Type' asc;

/*Report 9*/

select C.[Product ID], C.[Product Name],sum(C.[Sold During Campaign]) AS 'Sold During Campaign',sum(C.[Sold Outside Campaign]) as 'Sold Outside Campaign',sum(C.[Difference]) as 'Difference' from 
(
select *,ROW_NUMBER() over(order by Difference desc) as Rnk from (
select top 10  P.PID as 'Product ID',P.Product_Name as 'Product Name',
sum(case when Ca.[Date] is not null then Sa.Quantity else 0 end) as 'Sold During Campaign',
sum(case when Ca.[Date] is null then Sa.Quantity else 0 end) as 'Sold Outside Campaign',
sum(case when Ca.[Date] is not null then Sa.Quantity else 0 end )-sum(case when Ca.[Date] is null then Sa.Quantity else 0 end) as 'Difference'
from
Sale Sa join Product P on 
P.PID=Sa.PID
left join Campaign Ca
on Ca.[Date]=Sa.[Date]
group by P.PID ,P.Product_Name
order by 'Difference' Desc)A
union all
select *,ROW_NUMBER() over(order by Difference asc)+10 as Rnk from (
select top 10  P.PID as 'Product ID',P.Product_Name as 'Product Name',
sum(case when Ca.[Date] is not null then Sa.Quantity else 0 end) as 'Sold During Campaign',
sum(case when Ca.[Date] is null then Sa.Quantity else 0 end) as 'Sold Outside Campaign',
sum(case when Ca.[Date] is not null then Sa.Quantity else 0 end )-sum(case when Ca.[Date] is null then Sa.Quantity else 0 end) as 'Difference'
from
Sale Sa join Product P on 
P.PID=Sa.PID
left join Campaign Ca
on Ca.[Date]=Sa.[Date]
group by P.PID ,P.Product_Name
order by 'Difference' ASC)B 

)C group by C.[Product ID], C.[Product Name],C.Rnk order by C.Rnk;





-- alterante way
with cte1 as (
select *,ROW_NUMBER() over(order by Difference desc) as Rnk from(
select top(10) P.PID as 'Product ID',P.Product_Name as 'Product Name',
sum(case when Ca.[Date] is not null then Sa.Quantity else 0 end) as 'Sold During Campaign',
sum(case when Ca.[Date] is null then Sa.Quantity else 0 end) as 'Sold Outside Campaign',
sum(case when Ca.[Date] is not null then Sa.Quantity else 0 end )-sum(case when Ca.[Date] is null then Sa.Quantity else 0 end) as 'Difference'
from
Sale Sa join Product P on 
P.PID=Sa.PID
left join Campaign Ca
on Ca.[Date]=Sa.[Date]
group by P.PID,P.Product_Name
order by 'Difference' Desc)A
),
cte2 as (
select *,ROW_NUMBER() over(order by Difference asc)+10 as Rnk
from (
select top 10  P.PID as 'Product ID',P.Product_Name as 'Product Name',
sum(case when Ca.[Date] is not null then Sa.Quantity else 0 end) as 'Sold During Campaign',
sum(case when Ca.[Date] is null then Sa.Quantity else 0 end) as 'Sold Outside Campaign',
sum(case when Ca.[Date] is not null then Sa.Quantity else 0 end )-sum(case when Ca.[Date] is null then Sa.Quantity else 0 end) as 'Difference'
from
Sale Sa join Product P on 
P.PID=Sa.PID
left join Campaign Ca
on Ca.[Date]=Sa.[Date]
group by P.PID,P.Product_Name
order by 'Difference' ASC)B
)
select [Product ID],[Product Name] ,[Sold During Campaign],[Sold Outside Campaign],[DIFFERENCE] from cte1
UNION all
select [Product ID],[Product Name] ,[Sold During Campaign],[Sold Outside Campaign],[DIFFERENCE] from cte2;

