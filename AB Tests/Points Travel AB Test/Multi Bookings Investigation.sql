

SELECT          bks.session_id
        ,       count(*)                record_count
        ,       count(distinct bks.id)  booking_count
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
where           UPPER(bks.status) = 'CONFIRMED'                                                        
group by        bks.session_id
having          count(distinct bks.id) > 1;

select          id as booking_id
        ,       checkin
        ,       checkout
        ,       first_name
        ,       bookings.last_name
        ,       session_id
        ,       ip_address
        ,       hotel_id
        ,       bookings.hotel_name
        ,       bookings.itinerary_id
        ,       bookings.confirmation
        ,       bookings.status
        ,       bookings.surcharge_total
        ,       bookings.nightly_rate_total
        ,       bookings.total
        ,       bookings.currency_code
        ,       bookings.created_at
        ,       bookings.updated_at
        ,       bookings.avg_rate
        ,       bookings.user_agent
        ,       bookings.confirmed_total
        ,       bookings.ean_id
        ,       bookings.markup_value
        ,       bookings.supplier_currency_code
        ,       bookings.exch_supp_usd
        ,       bookings.member_validation
        ,       bookings.product_type
        ,       bookings.flow
        ,       bookings.order_confirmation_number
        ,       bookings.variant
from            mm.bookings 
where           bookings.session_id = '1013cbe2-981c-4e8e-8780-e8ebfc4f404d' and bookings.status = 'CONFIRMED';

