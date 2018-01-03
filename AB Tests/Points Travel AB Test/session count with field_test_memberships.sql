select          'am'                                                    tenant
        ,       field_test_memberships.variant
        ,       count(distinct field_test_memberships.participant)      count
from            am.field_test_memberships
where           field_test_memberships.created_at >= '2017-12-01 00:00:00'
group by        field_test_memberships.variant

Union 

select          'an'                                                    tenant
        ,       field_test_memberships.variant
        ,       count(distinct field_test_memberships.participant) count 
from            an.field_test_memberships
where           field_test_memberships.created_at >= '2017-12-01 00:00:00'
group by        field_test_memberships.variant


Union 

select          'fb'                                                    tenant
        ,       field_test_memberships.variant
        ,       count(distinct field_test_memberships.participant) count 
from            fb.field_test_memberships
where           field_test_memberships.created_at >= '2017-12-01 00:00:00'
group by        field_test_memberships.variant


Union 

select          'mm'                                                    tenant
        ,       field_test_memberships.variant
        ,       count(distinct field_test_memberships.participant) count 
from            mm.field_test_memberships
where           field_test_memberships.created_at >= '2017-12-01 00:00:00'
group by        field_test_memberships.variant


Union 

select          'ph'                                                    tenant
        ,       field_test_memberships.variant
        ,       count(distinct field_test_memberships.participant) count 
from            ph.field_test_memberships
where           field_test_memberships.created_at >= '2017-12-01 00:00:00'
group by        field_test_memberships.variant;