SELECT          
                CASE upper(SES.CONFIGURATION_ID)
                        WHEN 'SOW-5962-INLINE-2' THEN 'Test'
                        WHEN 'PC-27960-RAPID-REWARDS-CONTROL' THEN 'Control' 
                        ELSE 'Error'
                END                             AS Test_Control
        ,       MEM.COUNTRY_CD                  AS Member_CountryCode
        ,       MEM.PARTNER_NM
        ,       O1.OFFER_TYPE_NM
        ,       DATE_TRUNC('DAY', MV.CREATE_EST_DT)          AS Create_Date
--        ,       MV.MV_ID
        ,       COUNT(*)                        AS Record_Count
        ,       COUNT(DISTINCT MV_ID)           AS MV_Count
        ,       COUNT(DISTINCT SES.SESSION_ID)  AS Session_Count
        ,       COUNT(DISTINCT MV.MEMBER_KEY)   AS Visitor_Count
        ,       SUM(CASE UPPER(ORD.SALE_REFUND_IND) WHEN 'SALE' THEN 1 WHEN 'REFUND' THEN -1 ELSE 0 END)
                                                AS Transaction_Count                                           
       FROM
            MART.MEMBER_VALIDATION_FACT_VW      MV
       JOIN
            MART.MEMBER_DIM_VW                  MEM
         ON
            MV.MEMBER_KEY = MEM.MEMBER_KEY
       JOIN
            (SELECT DISTINCT 
            OFFER_SET_FACT_VW.OFFER_KEY
            ,   OFFER_SET_FACT_VW.USER_MV_ID
            ,   OFFER_SET_FACT_VW.SESSION_INFO_KEY
            FROM MART.OFFER_SET_FACT_VW
            )                                   O
         ON
            MV.MV_ID = O.USER_MV_ID
       JOIN
            MART.OFFER_DIM_VW                   O1
         ON
            O.OFFER_KEY = O1.OFFER_KEY
       JOIN
            MART.SESSION_INFO_DIM_VW            SES
         ON
            O.SESSION_INFO_KEY = SES.SESSION_INFO_KEY
        LEFT JOIN 
                MART.ORDER_TRANSACTION_FACT_VW  ORD
                ON
                ORD.USER_MV_ID = MV.MV_ID
--        LEFT JOIN 
--                MART.REVENUE_COST_FACT_VW       REV
--                ON
--                REV.ORDER_KEY = ORD.ORDER_KEY   AND 
--                REV.SALE_REFUND_IND = ORD.SALE_REFUND_IND                            
      WHERE
            UPPER( NVL( EMAIL, 'NULL' ) ) NOT LIKE '%POINTS.COM'
        AND UPPER( NVL( FIRST_NM, 'FIRST' ) )   != 'TEST'
        AND UPPER( NVL( LAST_NM, 'LAST' ) )     != 'TEST'
        AND UPPER(SES.CONFIGURATION_ID) IN ('SOW-5962-INLINE-2','PC-27960-RAPID-REWARDS-CONTROL')
        and MV.CREATE_EST_DT >= 'Nov 1, 2017'
--        and mv_id = '2daac8ac-f47c-4cc2-aa82-70738cb76c61'
GROUP BY    
        SES.CONFIGURATION_ID
        ,       MEM.COUNTRY_CD
        ,       MEM.PARTNER_NM
        ,       O1.OFFER_TYPE_NM
        ,       DATE_TRUNC('DAY', MV.CREATE_EST_DT)