create procedure childcarevolume as

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


exec childcarevolume