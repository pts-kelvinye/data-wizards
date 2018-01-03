SELECT
    session_id                             ,
    gross_margin_usd                       ,
    earn_base_points                       ,
    earn_bonus_points                      ,
    avg_rate                               ,
    adults                                 ,
    travelers                              ,
    point_hound_mktg_hotel_dtl_old.hotel_id,
    point_hound_mktg_hotel_hdr.search_id   ,
    hotel_facts.star_rating                ,
    hotel_facts.ean_id                     ,
    checkin                                ,
    checkout                               ,
    created_at                             ,
    position                               ,
    flow                                   ,
    point_hound_mktg_hotel_hdr.city        ,
    country                                ,
    ---distance_to_airport_km,
    ----distance_to_airport_miles,
    ----distance_to_city_km,
    ----distance_to_city_miles,
    DATEDIFF(DAY, checkin, checkout)            AS total_nights   ,
    DATEDIFF(DAY, created_at, checkin)          AS days_to_booking,
    (avg_rate*DATEDIFF(DAY, checkin, checkout)) AS total_amt
FROM
    POINTS_HOUND.point_hound_mktg_hotel_dtl_old
LEFT JOIN
    POINTS_HOUND.hotel_facts
 ON
    point_hound_mktg_hotel_dtl_old.hotel_id=hotel_facts.ean_id
JOIN
    POINTS_HOUND.point_hound_mktg_hotel_hdr
 ON
    point_hound_mktg_hotel_dtl_old.search_id = point_hound_mktg_hotel_hdr.search_id
WHERE
    created_at BETWEEN '2017-01-01 00:00:00' AND '2017-06-30 23:59:59'limit 10;