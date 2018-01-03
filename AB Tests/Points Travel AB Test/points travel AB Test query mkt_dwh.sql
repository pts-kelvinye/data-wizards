--select          bks.created_at                          as "Create Date"
--        ,       date(bks.created_at)                    as "Day"
--        ,       bks.id                                  as "Booking ID"
--        ,       txn.id                                  as "Transaction ID"
--        ,       coalesce(cast(bks.id as varchar(20)),ftm.participant)        
--                                                        as "Session ID"
--        ,       bsp.base_points                         as "Base Points"
--        ,       bns.bonus_points                        as "Bonus Points"
--        ,       txn.supplier_currency                   as "Supplier Currency"
--        ,       txn.booking_currency                    as "Booking Currency"
--        ,       txn.sale_rate_book_curr                 as "Revenue Booking Currency"
--        ,       txn.exch_book_usd                       as "Booking to USD Exchange Rate"
--        ,       txn.transaction_type                    as "Booking Refund Ind"
--        ,       act.created_at                          as "Enrollment Date"
--        ,       'n/a'                                   as "Tier"
--        ,       usr.marketing_country                   as "Txn Country"
--        ,       usr.country                             as "Billing Country"
--        ,       act.balance                             as "Balance"
--        ,       bks.program_account                     as "Member ID"
--        ,       usr.email                               as "Email"
--        ,       bks.first_name                          as "First Name"
--        ,       bks.last_name                           as "Last Name"
--        ,       ftm.variant                             as "Variant"
--        ,       bks.flow || '_' || bks.product_type     as "Product"
--        ,       'n/a'                                   as "Offer Name"
--        ,       'n/a'                                   as "Partner"
--        ,       act.preferred                           as "Preferred Account"
--        ,       bks.status                              as "Booking Status"
--from            mm.field_test_memberships       ftm
--left join       mm.bookings                     bks on  ftm.participant = bks.session_id
--left join       mm.transactions                 txn on  bks.id = txn.booking_id
--left join       mm.users                        usr on  usr.id = bks.user_id
--left join       
--        (       select  actn.booking_id
--                ,       actn.points             as base_points
--                from    mm.user_actions         actn
--                where   actn.action_type = 'BOOKING_AWARD'
--        )                                       bsp on  bsp.booking_id = bks.id
--left join       
--        (       select  actn.booking_id
--                ,       actn.points             as bonus_points
--                from    mm.user_actions         actn
--                where   actn.action_type = 'BOOKING_BONUS'
--        )                                       bns on  bns.booking_id = bks.id
--left join       mm.accounts                     act on  act.user_id = usr.id    and 
--                                                        act.deleted_at is null
;

select          ses.created_at                          as "Create Date"
        ,       date(ses.created_at)                    as "Day"
        ,       bks.created_at                          as "Booking Create Date"
        ,       date(bks.created_at)                    as "Booking Day"
        ,       bks.id                                  as "Booking ID"
        ,       txn.id                                  as "Transaction ID"
        ,       ses.session_id                          as "Session ID"
        ,       bsp.base_points                         as "Base Points"
        ,       bns.bonus_points                        as "Bonus Points"
        ,       txn.supplier_currency                   as "Supplier Currency"
        ,       txn.booking_currency                    as "Booking Currency"
        ,       txn.sale_rate_book_curr                 as "Revenue Booking Currency"
        ,       txn.exch_book_usd                       as "Booking to USD Exchange Rate"
        ,       txn.transaction_type                    as "Booking Refund Ind"
        ,       '1900-01-01'/*act.created_at*/          as "Enrollment Date"
        ,       'n/a'                                   as "Tier"
        ,       usr.marketing_country                   as "Txn Country"
        ,       usr.country                             as "Billing Country"
        ,       usr.balance                             as "Balance"
        ,       bks.program_account                     as "Member ID"
        ,       usr.user_email                          as "Email"
        ,       bks.first_name                          as "First Name"
        ,       bks.last_name                           as "Last Name"
        ,       variant                                 as "Variant"
        ,       ses.flow || '_' || 'Hotel'              as "Product"
        ,       'n/a'                                   as "Offer Name"
        ,       'Air Miles'                             as "Partner"
        ,       usr.preferred                           as "Preferred Account"
        ,       bks.status                              as "Booking Status"
from            POINTS_HOUND.point_hound_mktg_hotel_hdr ses
left join       POINTS_HOUND.bookings_am                bks on bks.session_id = ses.session_id
left join       POINTS_HOUND.transactions_am            txn on txn.booking_id = bks.id
left join       POINTS_HOUND.user_account_am            usr on usr.user_id = bks.user_id
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