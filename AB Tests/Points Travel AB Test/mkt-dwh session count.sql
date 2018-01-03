select tenant, variant,
count(distinct(session_id)) 
from POINTS_HOUND.point_hound_mktg_hotel_hdr 
where 
created_at >= '2017-12-01 00:00:00' --and '2017-12-13 23:59:59'
and variant is not null
and flow='earn' 
group by tenant, variant
order by tenant, variant;
