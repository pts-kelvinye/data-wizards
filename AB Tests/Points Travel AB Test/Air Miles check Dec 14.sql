
select          txn.transaction_type
        ,       bks.status
        ,       ftm.variant
        ,       count(*)                record_count
        ,       count(distinct bks.session_id)
                                        session_count
        ,       count(distinct ftm.participant)
                                        real_session_count                                        
        ,       count(distinct bks.id)  booking_count
        ,       count(distinct txn.id)  txn_count
        ,       count(distinct usr.id)  user_count
        ,       count(distinct act.id)  acct_count
from            am.field_test_memberships       ftm
left join       am.bookings                     bks on  ftm.participant = bks.session_id
left join       am.transactions                 txn on  bks.id = txn.booking_id
left join       am.users                        usr on  usr.id = bks.user_id
left join       
        (       select  actn.booking_id
                ,       actn.points             as base_points
                from    am.user_actions         actn
                where   actn.action_type = 'BOOKING_AWARD'
        )                                       bsp on  bsp.booking_id = bks.id
left join       
        (       select  actn.booking_id
                ,       actn.points             as bonus_points
                from    am.user_actions         actn
                where   actn.action_type = 'BOOKING_BONUS'
        )                                       bns on  bns.booking_id = bks.id
left join       am.accounts                     act on  act.user_id = usr.id    and 
                                                        act.deleted_at is null
where           ftm.created_at >= '2017-12-01 00:00:00'                                                        
group by        txn.transaction_type
        ,       bks.status
        ,       ftm.variant