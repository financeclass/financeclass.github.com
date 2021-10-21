with aa as(
select *
from xj_ods.ods_loan_account_asset_asset_contract_by_account_time_df   
where 1=1  
and  dt=  DATE_FORMAT(date_sub(current_date(),2),'yyyyMMdd')
) ,bb as(
select *
from xj_ods.ods_loan_account_asset_asset_contract_by_account_time_df   
where 1=1  
and  dt=  DATE_FORMAT(date_sub(current_date(),2),'yyyyMMdd')
and contract_id in (
3430224192199458851
,3429544062519083019
,3430802765096419359
)
),con as (select * from aa  
)

select  
 product_id,term_num
,case 
when datediff(from_unixtime(cast(end_date/1000 as int),'yyyy-MM-dd'),from_unixtime(cast(start_date/1000 as int),'yyyy-MM-dd'))<=30*3 then '3m'
when datediff(from_unixtime(cast(end_date/1000 as int),'yyyy-MM-dd'),from_unixtime(cast(start_date/1000 as int),'yyyy-MM-dd'))<=30*6 then '6m'
when datediff(from_unixtime(cast(end_date/1000 as int),'yyyy-MM-dd'),from_unixtime(cast(start_date/1000 as int),'yyyy-MM-dd'))<=365 then '1y'
when datediff(from_unixtime(cast(end_date/1000 as int),'yyyy-MM-dd'),from_unixtime(cast(start_date/1000 as int),'yyyy-MM-dd'))<=365*2 then '2y'
when datediff(from_unixtime(cast(end_date/1000 as int),'yyyy-MM-dd'),from_unixtime(cast(start_date/1000 as int),'yyyy-MM-dd'))<=365*3 then '3y'
when datediff(from_unixtime(cast(end_date/1000 as int),'yyyy-MM-dd'),from_unixtime(cast(start_date/1000 as int),'yyyy-MM-dd'))<=365*5 then '5y'
else '5yp' end  con_term_cut

,sum(principal)/100 principal

,sum(case when owner=1 then unpaid_principal else 0 end)/100 left

from con

group by  term_num
,product_id
,case 
when datediff(from_unixtime(cast(end_date/1000 as int),'yyyy-MM-dd'),from_unixtime(cast(start_date/1000 as int),'yyyy-MM-dd'))<=30*3 then '3m'
when datediff(from_unixtime(cast(end_date/1000 as int),'yyyy-MM-dd'),from_unixtime(cast(start_date/1000 as int),'yyyy-MM-dd'))<=30*6 then '6m'
when datediff(from_unixtime(cast(end_date/1000 as int),'yyyy-MM-dd'),from_unixtime(cast(start_date/1000 as int),'yyyy-MM-dd'))<=365 then '1y'
when datediff(from_unixtime(cast(end_date/1000 as int),'yyyy-MM-dd'),from_unixtime(cast(start_date/1000 as int),'yyyy-MM-dd'))<=365*2 then '2y'
when datediff(from_unixtime(cast(end_date/1000 as int),'yyyy-MM-dd'),from_unixtime(cast(start_date/1000 as int),'yyyy-MM-dd'))<=365*3 then '3y'
when datediff(from_unixtime(cast(end_date/1000 as int),'yyyy-MM-dd'),from_unixtime(cast(start_date/1000 as int),'yyyy-MM-dd'))<=365*5 then '5y'
else '5yp' end