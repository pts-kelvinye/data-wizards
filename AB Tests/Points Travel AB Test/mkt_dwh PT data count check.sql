select          txn.transaction_type
        ,       bks.status
        ,       ses.variant
        ,       ses.flow
        ,       count(*)                        record_count
        ,       count(distinct ses.session_id)
                                                session_count
        ,       count(distinct bks.id)          booking_count
        ,       count(distinct txn.id)          txn_count
        ,       count(distinct usr.user_id)     user_count
from            POINTS_HOUND.point_hound_mktg_hotel_hdr         ses
left join       POINTS_HOUND.bookings_am                        bks on bks.session_id = ses.session_id
left join       POINTS_HOUND.transactions_am                    txn on txn.booking_id = bks.id
left join       POINTS_HOUND.user_account_am                    usr on usr.user_id = bks.user_id
left join 
        (       select  actn.booking_id
                ,       actn.points             as base_points
                from    POINTS_HOUND.user_actions_am         actn
                where   actn.action_type = 'BOOKING_AWARD'
        )                                       bsp on  bsp.booking_id = bks.id
left join       
        (       select  actn.booking_id
                ,       actn.points             as bonus_points
                from    POINTS_HOUND.user_actions_am         actn
                where   actn.action_type = 'BOOKING_BONUS'
        )                                       bns on  bns.booking_id = bks.id
where           ses.tenant = 'am'
        and     ses.created_at >= '2017-12-01 00:00:00' 
group by        txn.transaction_type
        ,       bks.status
        ,       ses.variant
        ,       ses.flow