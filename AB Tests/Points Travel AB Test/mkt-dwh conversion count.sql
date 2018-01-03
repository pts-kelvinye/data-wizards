----- bookings
select          ses.variant
        ,       count(distinct bks.id)  as Bookings_Count
--      select ses.created_at, bks.created_at      
from            POINTS_HOUND.point_hound_mktg_hotel_hdr ses
inner join      POINTS_HOUND.bookings_am                bks on bks.session_id = ses.session_id  and 
                                                               ses.session_id <> 'undefined'
where           bks.status = 'CONFIRMED' 
        and     ses.flow = 'earn'
--        and     ses.created_at >= '2017-12-01 00:00:00'
--        and     bks.created_at < '2017-12-01 00:00:00'
        and     ses.session_id = 'fd9825b2-24bb-4617-a090-9a8f6d8c0ba2'
group by        ses.variant
order by        ses.variant

;


select * from POINTS_HOUND.point_hound_mktg_hotel_hdr where point_hound_mktg_hotel_hdr.session_id = 'fd9825b2-24bb-4617-a090-9a8f6d8c0ba2';