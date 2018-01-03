select          txn.transaction_type
        ,       count(*)                record_count
        ,       count(distinct bks.id)  booking_count
        ,       count(distinct txn.id)  txn_count
        ,       count(distinct usr.id)  user_count
        ,       count(distinct act.id)  acct_count
        --select *
from            POINTS_HOUND.bookings_mm        bks
left join       POINTS_HOUND.transactions_mm    txn on bks.id = txn.booking_id
left join       POINTS_HOUND.point_hound_mktg_hotel_hdr
                                                htl on htl.session_id = bks.session_id
left join                                                       
--left join       (
--                select distinct 
--                point_hound_mktg_checkout.booking_id
--                ,       point_hound_mktg_checkout.earn_base_points
--                ,       point_hound_mktg_checkout.earn_bonus_points
--                ,       point_hound_mktg_checkout.room_description 
--                from POINTS_HOUND.point_hound_mktg_checkout
--                )
--                                                ckt on ckt.booking_id = bks.id
inner join      POINTS_HOUND.users              usr on usr.id = bks.user_id
inner join      POINTS_HOUND.accounts           act on act.user_id = usr.id     and
                                                       act.preferred = 'true'
--where           txn.transaction_type = 'booking' and bks.id = 33698                                                      
group by        txn.transaction_type;


/*
- booking_id duplicates a lot in POINTS_HOUND.point_hound_mktg_checkout, e.g. booking_id = 33698
- 
*/


select          txn.transaction_type
        ,       bks.status
        ,       ftm.variant
        ,       count(*)                record_count
        ,       count(distinct bks.session_id)
                                        session_count
        ,       count(distinct bks.id)  booking_count
        ,       count(distinct txn.id)  txn_count
        ,       count(distinct usr.id)  user_count
        ,       count(distinct act.id)  acct_count
from            mm.field_test_memberships       ftm
left join       mm.bookings                     bks on  ftm.participant = bks.session_id
left join       mm.transactions                 txn on  bks.id = txn.booking_id
left join       mm.users                        usr on  usr.id = bks.user_id
left join       
        (       select  actn.booking_id
                ,       actn.points             as base_points
                from    mm.user_actions         actn
                where   actn.action_type = 'BOOKING_AWARD'
        )                                       bsp on  bsp.booking_id = bks.id
left join       
        (       select  actn.booking_id
                ,       actn.points             as bonus_points
                from    mm.user_actions         actn
                where   actn.action_type = 'BOOKING_BONUS'
        )                                       bns on  bns.booking_id = bks.id
left join       mm.accounts                     act on  act.user_id = usr.id    and 
                                                        act.deleted_at is null
group by        txn.transaction_type
        ,       bks.status
        ,       ftm.variant