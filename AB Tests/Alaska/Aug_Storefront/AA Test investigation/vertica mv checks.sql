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
--
        SELECT O1.OFFER_TYPE_NM,SES.CONFIGURATION_ID,COUNT(DISTINCT MV_ID) AS 'Session Count',COUNT(DISTINCT MEM.PARTNER_MEMBER_ID) AS 'Member Count'
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
               LEFT JOIN
                    MART.SESSION_INFO_DIM_VW SES
                 ON
                    O.SESSION_INFO_KEY = SES.SESSION_INFO_KEY
        --  LEFT JOIN
        --            MART.SESSION_BUCKET_DIM_VW SBD
        --         ON
        --            SES.CONFIGURATION_ID = SBD.BUCKET_CONFIGURATION_ID
              WHERE
                    OFFER_STATUS_CD = 'LIVE'
                AND MV.CREATE_EST_DT BETWEEN '2017-09-19 10:50:01' AND '10-11-2017 15:09:00'
                AND UPPER( NVL( EMAIL, 'NULL' ) ) NOT LIKE '%POINTS.COM'
                AND UPPER( NVL( FIRST_NM, 'FIRST' ) )   != 'TEST'
                AND UPPER( NVL( LAST_NM, 'LAST' ) )     != 'TEST'
                AND O1.LP_ID = '1040270f-8e34-4ed2-890d-b1f0d9af58a1' --Alaska LP_ID
        --        AND SES.CONFIGURATION_ID IS NULL
                
        --AND     UPPER(O1.PARENT_OFFER) IN ('1956894A-105B-4B15-865E-0F73A6F604FF','B53C9DD0-3CB8-47BD-ADD0-5C66A68D2D42')
        GROUP BY O1.OFFER_TYPE_NM,SES.CONFIGURATION_ID