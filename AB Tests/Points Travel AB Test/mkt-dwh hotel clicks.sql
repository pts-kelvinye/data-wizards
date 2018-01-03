--- total hotel clicks by variant
select tenant, variant,
count(distinct(b.session_id)) 
from POINTS_HOUND.point_hound_mktg_hotel_hdr a
inner join POINTS_HOUND.point_hound_mktg_room_hdr b on a.session_id = b.session_id 
where 
a.created_at between '2017-12-01 00:00:00' and '2017-12-13 23:59:59'
and variant is not null
and flow='earn' 
group by tenant, variant
order by tenant, variant;