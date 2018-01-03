select          txn.transaction_type
        ,       count(*)                record_count
        ,       count(distinct bks.id)  booking_count
        ,       count(distinct txn.id)  txn_count
        ,       count(distinct usr.id)  user_count
        ,       count(distinct act.id)  acct_count
        --select *
from            mm.bookings             bks
left join       mm.transactions         txn on bks.id = txn.booking_id                                              
--left join       (
--                select distinct 
--                point_hound_mktg_checkout.booking_id
--                ,       point_hound_mktg_checkout.earn_base_points
--                ,       point_hound_mktg_checkout.earn_bonus_points
--                ,       point_hound_mktg_checkout.room_description 
--                from POINTS_HOUND.point_hound_mktg_checkout
--                )
--                                                ckt on ckt.booking_id = bks.id
inner join      mm.users                usr on usr.id = bks.user_id
inner join      mm.accounts             act on act.user_id = usr.id     and
                                               act.preferred = 'true'
--where           txn.transaction_type = 'booking' and bks.id = 33698                                                      
group by        txn.transaction_type;

/*
- booking_id duplicates a lot in POINTS_HOUND.point_hound_mktg_checkout, e.g. booking_id = 33698
- 
*/


select          bks.created_at          as 'Create Date'
        ,       date(bks.created_at)    as 'Day'
        ,       bks.id                  as 'Booking ID'
        ,       txn.id                  as 'Transaction ID'
        ,                               as 'Base Points'
        ,       as 'Bonus Points'
        ,       txn.supplier_currency   as 'Remittance Currency'
        ,       as 'Revenue'
        ,       txn.transaction_type    as 'Booking Refund Ind'
        ,       act.created_at          as 'Enrollment Date'
        ,       as 'Tier'
        ,       usr.marketing_country   as 'Txn Country'
        ,       usr.country             as 'Billing Country'
        ,       act.balance             as 'Balance'
        ,       bks.program_account     as 'Member ID'
        ,       usr.email               as 'Email'
        ,       bks.first_name          as 'First Name'
        ,       bks.last_name           as 'Last Name'
        ,       txn.
from            POINTS_HOUND.bookings_mm        bks
left join       POINTS_HOUND.transactions_mm    txn on bks.id = txn.booking_id
inner join      POINTS_HOUND.users              usr on usr.id = bks.user_id
inner join      POINTS_HOUND.accounts           act on act.user_id = usr.id     and
                                                       act.preferred = 'true'