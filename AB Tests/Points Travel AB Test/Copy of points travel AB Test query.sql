select          bks.created_at                          as "Create Date"
        ,       date(bks.created_at)                    as "Day"
        ,       bks.id                                  as "Booking ID"
        ,       txn.id                                  as "Transaction ID"
        ,       coalesce(cast(bks.id as varchar(20)),ftm.participant)        
                                                        as "Session ID"
        ,       bsp.base_points                         as "Base Points"
        ,       bns.bonus_points                        as "Bonus Points"
        ,       txn.supplier_currency                   as "Supplier Currency"
        ,       txn.booking_currency                    as "Booking Currency"
        ,       txn.sale_rate_book_curr                 as "Revenue Booking Currency"
        ,       txn.exch_book_usd                       as "Booking to USD Exchange Rate"
        ,       txn.transaction_type                    as "Booking Refund Ind"
        ,       act.created_at                          as "Enrollment Date"
        ,       'n/a'                                   as "Tier"
        ,       usr.marketing_country                   as "Txn Country"
        ,       usr.country                             as "Billing Country"
        ,       act.balance                             as "Balance"
        ,       bks.program_account                     as "Member ID"
        ,       usr.email                               as "Email"
        ,       bks.first_name                          as "First Name"
        ,       bks.last_name                           as "Last Name"
        ,       ftm.variant                             as "Variant"
        ,       bks.flow || '_' || bks.product_type     as "Product"
        ,       'n/a'                                   as "Offer Name"
        ,       'n/a'                                   as "Partner"
        ,       act.preferred                           as "Preferred Account"
        ,       bks.status                              as "Booking Status"
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