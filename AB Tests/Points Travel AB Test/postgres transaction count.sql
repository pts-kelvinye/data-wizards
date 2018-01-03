select variant, count(id)
from am.bookings
where status='CONFIRMED' and flow='earn' and created_at between '2017-12-01 00:00:00' and '2017-12-13 23:59:59'
group by variant
order by variant;



