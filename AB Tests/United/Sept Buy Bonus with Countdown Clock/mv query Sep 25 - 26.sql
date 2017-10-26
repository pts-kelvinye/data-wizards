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

SELECT COUNT(MV_ID),O1.PARENT_OFFER            
       FROM
            MART.MEMBER_VALIDATION_FACT_VW MV
--       JOIN
--            MART.MEMBER_DIM_VW MEM
--         ON
--            MV.MEMBER_KEY = MEM.MEMBER_KEY
       JOIN
            MART.OFFER_SET_FACT_VW O
         ON
            MV.MV_ID = O.USER_MV_ID
       JOIN
            MART.OFFER_DIM_VW O1
         ON
            O.OFFER_KEY = O1.OFFER_KEY
--       JOIN
--            MART.SESSION_INFO_DIM_VW SES
--         ON
--            O.SESSION_INFO_KEY = SES.SESSION_INFO_KEY
--  LEFT JOIN
--            MART.SESSION_BUCKET_DIM_VW SBD
--         ON
--            SES.CONFIGURATION_ID = SBD.BUCKET_CONFIGURATION_ID
      WHERE
            OFFER_STATUS_CD = 'LIVE'
        AND MV.CREATE_EST_DT BETWEEN '2017-09-25 00:00:01' AND '2017-09-26 23:59:59'
--        AND UPPER( NVL( EMAIL, 'NULL' ) ) NOT LIKE '%POINTS.COM'
--        AND UPPER( NVL( FIRST_NM, 'FIRST' ) )   != 'TEST'
--        AND UPPER( NVL( LAST_NM, 'LAST' ) )     != 'TEST'
        
AND     UPPER(O1.PARENT_OFFER) IN ('1956894A-105B-4B15-865E-0F73A6F604FF','B53C9DD0-3CB8-47BD-ADD0-5C66A68D2D42')
GROUP BY O1.PARENT_OFFER