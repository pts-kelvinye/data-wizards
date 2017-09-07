WITH
    MV AS
    (
SELECT DISTINCT
            MV_ID                  ,
            MV.CREATE_EST_DT       ,
            MV.MEMBER_BALANCE_NUM  ,
            SES.STOREFRONT_BRAND   ,
            O1.OFFER_STATUS_CD     ,
            O1.PRIORITY_IND        ,
            SES.CONFIGURATION_ID   ,
            SBD.BUCKET_RATIO       ,
            O1.PARENT_OFFER        ,
            O1.OFFER_NM            ,
            O1.OFFER_TYPE_NM       ,
            MEM.PARTNER_MEMBER_ID  ,
            MEM.EMAIL              ,
            MEM.FIRST_NM           ,
            MEM.LAST_NM            ,
            MEM.LP_ID              ,
            MEM.PARTNER_NM         ,
            MEM.ACCOUNT_CREATION_DT,
            MEM.MEMBERSHIP_LEVEL   ,
            MEM.COUNTRY_CD
       FROM
            MART.MEMBER_VALIDATION_FACT_VW MV
       JOIN
            MART.MEMBER_DIM_VW MEM
         ON
            MV.MEMBER_KEY = MEM.MEMBER_KEY
       JOIN
            MART.OFFER_SET_FACT_VW O
         ON
            MV.MV_ID = O.USER_MV_ID
       JOIN
            MART.OFFER_DIM_VW O1
         ON
            O.OFFER_KEY = O1.OFFER_KEY
       JOIN
            MART.SESSION_INFO_DIM_VW SES
         ON
            O.SESSION_INFO_KEY = SES.SESSION_INFO_KEY
  LEFT JOIN
            MART.SESSION_BUCKET_DIM_VW SBD
         ON
            SES.CONFIGURATION_ID = SBD.BUCKET_CONFIGURATION_ID
      WHERE
            OFFER_STATUS_CD = 'LIVE'
        AND MV.CREATE_EST_DT BETWEEN TIMESTAMPADD(m,-3,CURRENT_TIMESTAMP) AND CURRENT_TIMESTAMP
        AND UPPER( NVL( EMAIL, 'NULL' ) ) NOT LIKE '%POINTS.COM'
        AND UPPER( NVL( FIRST_NM, 'FIRST' ) )   != 'TEST'
        AND UPPER( NVL( LAST_NM, 'LAST' ) )     != 'TEST'
            --        AND PARTNER_NM                           = 'UNITED AIRLINES'
    )
    ,
    REFUNDS AS
    (
     SELECT
            PAY.REMIT_TOTAL_PAYMENT_AMT,
            POST.ORDER_KEY             ,
            CREDIT_POSTING_BASE_AMT    ,
            CREDIT_POSTING_BONUS_AMT   ,
            PAY.PRESENTMENT_CURRENCY_CD,
            PAY.REMITTANCE_CURRENCY_CD ,
            POST.SALE_REFUND_IND
       FROM
            MART.POSTING_FACT_VW POST
       JOIN
            MART.PAYMENT_WITH_FX_FACT_VW PAY
         ON
            POST.ORDER_KEY       = PAY.ORDER_KEY
        AND POST.SALE_REFUND_IND = PAY.SALE_REFUND_IND
      WHERE
            POST.SALE_REFUND_IND = 'REFUND'
        AND PAY.SALE_REFUND_IND  = 'REFUND'
        AND PAY.PAYMENT_CREATE_EST_DT BETWEEN TIMESTAMPADD(m,-3,CURRENT_TIMESTAMP) AND
            CURRENT_TIMESTAMP
    )
    ,
    ORDERS AS
    (
     SELECT
            O.ORDER_KEY                ,
            O.USER_MV_ID               ,
            PAY.PRESENTMENT_CURRENCY_CD,
            PAY.REMITTANCE_CURRENCY_CD ,
            CASE
                WHEN RE.ORDER_KEY IS NULL
                THEN POST.SALE_REFUND_IND
                ELSE RE.SALE_REFUND_IND
            END SALE_REFUND_IND,
            POST.CREDIT_POSTING_BASE_AMT +
            CASE
                WHEN RE.ORDER_KEY IS NOT NULL
                THEN POST.CREDIT_POSTING_BONUS_AMT + RE.CREDIT_POSTING_BONUS_AMT +
                    RE.CREDIT_POSTING_BASE_AMT
                ELSE 0
            END CREDIT_POSTING_BASE_AMT,
            PAY.REMIT_TOTAL_PAYMENT_AMT +
            CASE
                WHEN RE.ORDER_KEY IS NOT NULL
                THEN RE.REMIT_TOTAL_PAYMENT_AMT
                ELSE 0
            END TOTAL_PAYMENT_AMT
       FROM
            MART.ORDER_TRANSACTION_FACT_VW O
       JOIN
            MART.OFFER_DIM_VW OFFER
         ON
            O.CHOSEN_OFFER_KEY = OFFER.OFFER_KEY
       JOIN
            MART.POSTING_FACT_VW POST
         ON
            O.ORDER_KEY          = POST.ORDER_KEY
        AND POST.SALE_REFUND_IND = O.SALE_REFUND_IND
       JOIN
            MART.PAYMENT_WITH_FX_FACT_VW PAY
         ON
            O.ORDER_KEY = PAY.ORDER_KEY
  LEFT JOIN
            REFUNDS RE
         ON
            O.ORDER_KEY = RE.ORDER_KEY
      WHERE
            O.ORDER_STATUS         = 'COMPLETE'
        AND UPPER( O.SANDBOX_IND ) = 'FALSE'
        AND POST.SALE_REFUND_IND   = 'SALE'
        AND PAY.PAYMENT_STATUS_CD  = 'SUCCESS'
        AND PAY.PAYMENT_TYPE_CD    = 'CAPTURE'
        AND OFFER.OFFER_TYPE_NM IN ( 'BUY'    ,
                                    'GIFT'    ,
                                    'TRANSFER',
                                    'REINSTATE' )
        AND PAY.PAYMENT_CREATE_EST_DT BETWEEN TIMESTAMPADD(m,-3,CURRENT_TIMESTAMP) AND
            CURRENT_TIMESTAMP
    )
    ,
    MV_ORDER AS
    (
     SELECT
            MV.CREATE_EST_DT              ,
            MV.PARTNER_MEMBER_ID          ,
            MV.EMAIL                      ,
            MV.FIRST_NM                   ,
            MV.LAST_NM                    ,
            MV.OFFER_STATUS_CD            ,
            MV.MEMBER_BALANCE_NUM         ,
            MV.ACCOUNT_CREATION_DT        ,
            MV.MV_ID                      ,
            MV.MEMBERSHIP_LEVEL           ,
            MV.COUNTRY_CD                 ,
            MV.PARTNER_NM                 ,
            MV.PARENT_OFFER  MV_OFFER_ID  ,
            MV.OFFER_TYPE_NM MV_OFFER_TYPE,
            MV.OFFER_NM                   ,
            MV.STOREFRONT_BRAND           ,
            MV.CONFIGURATION_ID           ,
            MV.BUCKET_RATIO               ,
            ORD.ORDER_KEY                 ,
            ORD.CREDIT_POSTING_BASE_AMT   ,
            ORD.TOTAL_PAYMENT_AMT         ,
            ORD.SALE_REFUND_IND ,
            ORD.PRESENTMENT_CURRENCY_CD,
            ORD.REMITTANCE_CURRENCY_CD
       FROM
            MV
  LEFT JOIN
            ORDERS ORD
         ON
            MV.MV_ID = ORD.USER_MV_ID
    )
SELECT
    CREATE_EST_DT                    AS 'Create Date'    ,
    DATE_TRUNC('DAY', CREATE_EST_DT) AS 'DAY'            ,
    MV_ID                            AS 'Session Id'     ,
    CAST(ORDER_KEY AS VARCHAR)       AS 'Transaction Id' ,
    CREDIT_POSTING_BASE_AMT          AS Points           ,
    TOTAL_PAYMENT_AMT                AS Revenue          ,
    SALE_REFUND_IND                  AS 'Sale Refund Ind',
    ACCOUNT_CREATION_DT              AS 'Enrollment Date',
    MEMBERSHIP_LEVEL                 AS Tier             ,
    COUNTRY_CD                       AS Country          ,
    MEMBER_BALANCE_NUM               AS Balance          ,
    UPPER(PARTNER_MEMBER_ID)         AS 'Member Id'      ,
    EMAIL                                                ,
    FIRST_NM                                             ,
    LAST_NM                                              ,
    MV_OFFER_ID   AS 'Parent Offer'                        ,
    MV_OFFER_TYPE AS Product                               ,
    OFFER_NM                                               ,
    STOREFRONT_BRAND AS 'Storefront Brand'                 ,
    CONFIGURATION_ID                                       ,
    BUCKET_RATIO                                           ,
    PARTNER_NM AS Partner                                  ,
    'BGT3'     AS Source
FROM
    MV_ORDER
WHERE
    CREATE_EST_DT BETWEEN TIMESTAMPADD(m,-3,CURRENT_TIMESTAMP) AND CURRENT_TIMESTAMP
AND UPPER( NVL( EMAIL, 'NULL' ) ) NOT LIKE '%POINTS.COM'
AND UPPER( NVL( FIRST_NM, 'FIRST' ) )   != 'TEST'
AND UPPER( NVL( LAST_NM, 'LAST' ) )     != 'TEST'