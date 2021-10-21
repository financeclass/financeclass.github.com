with aa as(
select *
from xj_ods.ods_loan_account_asset_asset_contract_by_account_time_df   
where 1=1  
and  dt=DATE_FORMAT(date_sub(current_date(),2),'yyyyMMdd')
),
con as (select * from aa  
)
,cc as(
select *,row_number() OVER (PARTITION BY contract_id,term_no  ORDER BY create_time desc ) rank
from xj_ods.ods_loan_account_asset_asset_term_info_by_account_time_df   
where 1=1  
and  dt=DATE_FORMAT(date_sub(current_date(),2),'yyyyMMdd')
),
term as (select * from cc  
where rank=1)



select 
    DATE_FORMAT(date_sub(current_date(),1),'yyyyMMdd') datadate
    ,product_id,repayment_mode
    ,case when  overday>3 then 4 when overday>0 then 3 else 1 end term_status
    ,case 
    when overday=0 then 0
    when overday<=1 then 1
    when overday<=7 then 2
    when overday<=14 then 8
    when overday<=21 then 15
    when overday<=30 then 22
    when overday<=60 then 31
    when overday<=120 then 61 
    when overday<=180 then 121
    else 9999  end datediff_box
    ,max(overday)max_overday
    ,min(overday)min_overday
    ,max(contract_id)contract_id
    ,count(1)counts
    ,sum(allleft)all_left 
    ,sum(case when overday>0   then allleft else 0 end)con_due_left
    ,sum(bad_left)term_due_left
    ,sum(case when overday>0 and bad_left=0 then allleft else bad_left end)first_left
    ,sum(effective_interest)effective_interest
from 
(

  select term.contract_id id,max(repayment_mode)repayment_mode
      ,max(term.product_id)product_id,max(term.contract_id)contract_id
      ,sum(term.principal)-sum(paid_principal) allleft
      ,sum(case when term.overdue_days>0 then  term.principal - paid_principal
      else 0 end )bad_left
      ,max(term.overdue_days)overday
      ,sum(term.effective_interest)effective_interest   
  from term
  left join  con 
      on term.contract_id=con.contract_id
  where  1=1 and con.owner=1 and term_status in (1,3,4)
  group by term.contract_id
) aa
where 1=1 
group by DATE_FORMAT(date_sub(current_date(),1),'yyyyMMdd')
 ,product_id,repayment_mode
 ,case when  overday>3 then 4 when overday>0 then 3 else 1 end
,case 
when overday=0 then 0
when overday<=1 then 1
when overday<=7 then 2
when overday<=14 then 8
when overday<=21 then 15
when overday<=30 then 22
when overday<=60 then 31
when overday<=120 then 61
when overday<=180 then 121
else 9999 end  
limit 44444
