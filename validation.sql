select *
from wdpa_wdoecm_poly_feb023
limit 10

-- ## Checks on WDPA_PIDs ##

-- WDPA_PIDs with count of duplicate records
select wdpa_pid, count(*) as dups
from wdpa_wdoecm_poly_feb023
group by wdpa_pid
having count(*) > 1

-- WDPA_PIDs with REP_AREA < 0.0001 Km2
select wdpa_pid, rep_area
from wdpa_wdoecm_poly_feb023
where rep_area < 0.0001

-- WDPA_PIDs with REP_AREA > 500,000 Km2
select wdpa_pid, rep_area
from wdpa_wdoecm_poly_feb023
where rep_area > 500000

-- REP_M_AREA is 0 Km2 but MARINE has been provided
-- i.e. reported marine area is 0 Km2 but provider indicates
-- that the PA contains marine area
select wdpa_pid
from wdpa_wdoecm_poly_feb023
where rep_m_area = 0 and not marine::integer = 0

-- REP_M_AREA is larger than REP_AREA
-- i.e. reported marine area is greater than the reported
-- PA total area
select wdpa_pid
from wdpa_wdoecm_poly_feb023
where rep_m_area > rep_area
order by wdpa_pid

-- NO_TK_AREA is larger than REP_M_AREA
-- NO_TAKE applies only to marine area hence REP_M_AREA here
select wdpa_pid
from wdpa_wdoecm_poly_feb023
where no_tk_area > rep_m_area

-- Entire marine area specified as no-take but reported marine and
-- no-take areas differ
select wdpa_pid
from wdpa_wdoecm_poly_feb023
where no_take = 'All' and not rep_m_area = no_tk_area

-- If a site is not Ramsar or WH then int_crit should be 'Not Applicable'
select wdpa_pid
from wdpa_wdoecm_poly_feb023
where not desig_eng in ('Ramsar Site, Wetland of International Importance',
						'World Heritage Site (natural or mixed)')
and not int_crit = 'Not Applicable'

-- IUCN category and designation check
select wdpa_pid
from wdpa_wdoecm_poly_feb023
where not iucn_cat in ('Ia',
					   'Ib',
					   'II',
					   'III',
					   'IV',
					   'V',
					   'VI',
					   'Not Reported',
					   'Not Assigned')
and not desig_eng in ('UNESCO-MAB Biosphere Reserve',
                      'World Heritage Site (natural or mixed)')
					  
-- ## Checks on WDPAIDs ##
-- These checks consider all parts of a WDPAID i.e. all component
-- WDPA_PIDs. All WDPA_PIDs which fail the check are returned.

-- Check for inconsistent names for the same wdpaid
with t1 as
(select wdpaid, count(distinct name) as names
from wdpa_wdoecm_poly_feb023
group by wdpaid
having count(distinct name) > 1)
select wdpa_pid
from wdpa_wdoecm_poly_feb023
where wdpaid in (select wdpaid from t1)
order by wdpa_pid

-- Check for inconsistent orig_names for the same wdpaid
with t1 as (
select wdpaid, count(distinct orig_name)
from wdpa_wdoecm_poly_feb023
group by wdpaid
having count(distinct orig_name) > 1
)
select wdpa_pid
from wdpa_wdoecm_poly_feb023
where wdpaid in (select wdpaid from t1)
order by wdpa_pid

-- Check for inconsistent designations for the same wdpaid
with t1 as (
select wdpaid, count(distinct desig)
from wdpa_wdoecm_poly_feb023
group by wdpaid
having count(distinct desig) > 1
)
select wdpa_pid
from wdpa_wdoecm_poly_feb023
where wdpaid in (select wdpaid from t1)
order by wdpa_pid

-- Check for inconsistent english designations for the same wdpaid
with t1 as (
select wdpaid, count(distinct desig_eng)
from wdpa_wdoecm_poly_feb023
group by wdpaid
having count(distinct desig_eng) > 1
)
select wdpa_pid
from wdpa_wdoecm_poly_feb023
where wdpaid in (select wdpaid from t1)
order by wdpa_pid

-- Check for inconsistent designation types for the same wdpaid
with t1 as (
select wdpaid, count(distinct desig_type)
from wdpa_wdoecm_poly_feb023
group by wdpaid
having count(distinct desig_type) > 1
)
select wdpa_pid
from wdpa_wdoecm_poly_feb023
where wdpaid in (select wdpaid from t1)
order by wdpa_pid

-- Check for inconsistent international criteria for the same wdpaid
with t1 as (
select wdpaid, count(distinct int_crit)
from wdpa_wdoecm_poly_feb023
group by wdpaid
having count(distinct int_crit) > 1
)
select wdpa_pid
from wdpa_wdoecm_poly_feb023
where wdpaid in (select wdpaid from t1)
order by wdpa_pid

-- Check for inconsistent no-take for the same wdpaid
with t1 as (
select wdpaid, count(distinct no_take)
from wdpa_wdoecm_poly_feb023
group by wdpaid
having count(distinct no_take) > 1
)
select wdpa_pid, no_take
from wdpa_wdoecm_poly_feb023
where wdpaid in (select wdpaid from t1)
order by wdpa_pid, no_take

-- Check for inconsistent status for the same wdpaid
with t1 as (
select wdpaid, count(distinct status)
from wdpa_wdoecm_poly_feb023
group by wdpaid
having count(distinct status) > 1
)
select wdpa_pid, status
from wdpa_wdoecm_poly_feb023
where wdpaid in (select wdpaid from t1)
order by wdpa_pid, status

-- Check for inconsistent status_yr for the same wdpaid
with t1 as (
select wdpaid, count(distinct status_yr)
from wdpa_wdoecm_poly_feb023
group by wdpaid
having count(distinct status_yr) > 1
)
select wdpaid, wdpa_pid, status_yr
from wdpa_wdoecm_poly_feb023
where wdpaid in (select wdpaid from t1)
order by wdpaid, wdpa_pid, status_yr

-- Check for inconsistent gov_type for the same wdpaid
with t1 as (
select wdpaid, count(distinct gov_type)
from wdpa_wdoecm_poly_feb023
group by wdpaid
having count(distinct gov_type) > 1
)
select wdpaid, wdpa_pid, gov_type
from wdpa_wdoecm_poly_feb023
where wdpaid in (select wdpaid from t1)
order by wdpaid, wdpa_pid, gov_type

-- Check for inconsistent own_type for the same wdpaid
with t1 as (
select wdpaid, count(distinct own_type)
from wdpa_wdoecm_poly_feb023
group by wdpaid
having count(distinct own_type) > 1
)
select wdpaid, wdpa_pid, own_type
from wdpa_wdoecm_poly_feb023
where wdpaid in (select wdpaid from t1)
order by wdpaid, wdpa_pid, own_type

-- Check for inconsistent mang_auth for the same wdpaid
with t1 as (
select wdpaid, count(distinct mang_auth)
from wdpa_wdoecm_poly_feb023
group by wdpaid
having count(distinct mang_auth) > 1
)
select wdpaid, wdpa_pid, mang_auth
from wdpa_wdoecm_poly_feb023
where wdpaid in (select wdpaid from t1)
order by wdpaid, wdpa_pid, mang_auth

-- Check for inconsistent mang_plan for the same wdpaid
with t1 as (
select wdpaid, count(distinct mang_plan)
from wdpa_wdoecm_poly_feb023
group by wdpaid
having count(distinct mang_plan) > 1
)
select wdpaid, wdpa_pid, mang_plan
from wdpa_wdoecm_poly_feb023
where wdpaid in (select wdpaid from t1)
order by wdpaid, wdpa_pid, mang_plan

-- Check for inconsistent verifier for the same wdpaid
with t1 as (
select wdpaid, count(distinct verif)
from wdpa_wdoecm_poly_feb023
group by wdpaid
having count(distinct verif) > 1
)
select wdpaid, wdpa_pid, verif
from wdpa_wdoecm_poly_feb023
where wdpaid in (select wdpaid from t1)
order by wdpaid, wdpa_pid, verif

-- Check for inconsistent metadataid for the same wdpaid
with t1 as (
select wdpaid, count(distinct metadataid)
from wdpa_wdoecm_poly_feb023
group by wdpaid
having count(distinct metadataid) > 1
)
select wdpaid, wdpa_pid, metadataid
from wdpa_wdoecm_poly_feb023
where wdpaid in (select wdpaid from t1)
order by wdpaid, wdpa_pid, metadataid

-- Check for inconsistent sub-national code for the same wdpaid
with t1 as (
select wdpaid, count(distinct sub_loc)
from wdpa_wdoecm_poly_feb023
group by wdpaid
having count(distinct sub_loc) > 1
)
select wdpaid, wdpa_pid, sub_loc
from wdpa_wdoecm_poly_feb023
where wdpaid in (select wdpaid from t1)
order by wdpaid, wdpa_pid, sub_loc

-- Check for inconsistent parent ISO code for the same wdpaid
with t1 as (
select wdpaid, count(distinct parent_iso3)
from wdpa_wdoecm_poly_feb023
group by wdpaid
having count(distinct parent_iso3) > 1
)
select wdpaid, wdpa_pid, parent_iso3
from wdpa_wdoecm_poly_feb023
where wdpaid in (select wdpaid from t1)
order by wdpaid, wdpa_pid, parent_iso3

-- Check for inconsistent ISO code for the same wdpaid
with t1 as (
select wdpaid, count(distinct iso3)
from wdpa_wdoecm_poly_feb023
group by wdpaid
having count(distinct iso3) > 1
)
select wdpaid, wdpa_pid, iso3
from wdpa_wdoecm_poly_feb023
where wdpaid in (select wdpaid from t1)
order by wdpaid, wdpa_pid, iso3

-- ## More per-parcel checks

-- Check PA_DEF = '1'
-- i.e. PA definition meets the IUCN and/or the CBD definitions of a
-- Protected Area
select wdpaid, wdpa_pid, pa_def
from wdpa_wdoecm_poly_feb023
where not pa_def::varchar = '1' 
order by wdpaid, wdpa_pid, pa_def;

-- Check international designation type is correctly assigned
-- If desig_eng is not one of the accepted values then desig_type
-- must not be 'International'.
select wdpaid, wdpa_pid, desig_eng, desig_type
from wdpa_wdoecm_poly_feb023
where not desig_eng in ('Ramsar Site, Wetland of International Importance',
						'UNESCO-MAB Biosphere Reserve',
						'World Heritage Site (natural or mixed)')
and desig_type = 'International'
order by wdpaid, wdpa_pid, desig_eng, desig_type;

-- Check international designation type is correctly assigned
-- If desig_type is not 'International' then desig_eng must not
-- be 'Ramsar...' etc'.
select wdpaid, wdpa_pid, desig_eng, desig_type
from wdpa_wdoecm_poly_feb023
where not desig_type = 'International'
and desig_eng in ('Ramsar Site, Wetland of International Importance',
						'UNESCO-MAB Biosphere Reserve',
						'World Heritage Site (natural or mixed)')
order by wdpaid, wdpa_pid, desig_eng, desig_type;

-- Check designation against regional designation type
-- If desig_eng is not one of the accepted regional values then desig_type
-- must not be 'Regional'.
select wdpaid, wdpa_pid, desig_eng, desig_type
from wdpa_wdoecm_poly_feb023
where not desig_eng in ('Baltic Sea Protected Area (HELCOM)',
                            'Specially Protected Area (Cartagena Convention)',
                            'Marine Protected Area (CCAMLR)',
                            'Marine Protected Area (OSPAR)',
                            'Site of Community Importance (Habitats Directive)',
                            'Special Protection Area (Birds Directive)',
                            'Specially Protected Areas of Mediterranean Importance (Barcelona Convention)')
and desig_type = 'Regional'
order by wdpaid, wdpa_pid, desig_eng, desig_type;

-- Check designation against regional designation type
-- If desig_type is not 'Regional' desig_eng must not be
-- one of the accepted regional values
select wdpaid, wdpa_pid, desig_eng, desig_type
from wdpa_wdoecm_poly_feb023
where not desig_type = 'Regional'
and desig_eng in ('Baltic Sea Protected Area (HELCOM)',
                            'Specially Protected Area (Cartagena Convention)',
                            'Marine Protected Area (CCAMLR)',
                            'Marine Protected Area (OSPAR)',
                            'Site of Community Importance (Habitats Directive)',
                            'Special Protection Area (Birds Directive)',
                            'Specially Protected Areas of Mediterranean Importance (Barcelona Convention)')
order by wdpaid, wdpa_pid, desig_eng, desig_type;

-- Check for valid International Criteria
-- If desig_eng is Ramsar or World Heritage, int_crit must be
-- of the form (i)(ii) etc or Not Reported.
select wdpaid, wdpa_pid, int_crit, desig_eng
from wdpa_wdoecm_poly_feb023
where not int_crit similar to '(\([ivx]{1,4}\)){1,10}'
and not int_crit = 'Not Reported'
and desig_eng in ('Ramsar Site, Wetland of International Importance',
				  'World Heritage Site (natural or mixed)')
				  
-- Check for invalid designation type
select wdpaid, wdpa_pid, desig_type
from wdpa_wdoecm_poly_feb023
where not desig_type in ('National','Regional','International','Not Applicable');

-- Check for invalid IUCN category type
select wdpaid, wdpa_pid, iucn_cat
from wdpa_wdoecm_poly_feb023
where not iucn_cat in ('Ia', 'Ib', 'II', 'III', 'IV', 'V', 'VI',
					   'Not Reported', 'Not Applicable', 'Not Assigned');

-- invalid_iucn_cat_unesco_whs
-- Check for invalid IUCN_CAT - UNESCO-MAB and World Heritage Sites
-- If desig_eng is UNESCO-MAB Biosphere Reserve or World Heritage Site (natural or mixed)
-- IUCN_CAT must be of the form Not Applicable.
-- 0 Jan, 0 Feb
select wdpaid, wdpa_pid, iucn_cat, desig_eng
from wdpa_wdoecm_poly_feb023
where desig_eng in ('UNESCO-MAB Biosphere Reserve', 'World Heritage Site (natural or mixed)')
and not iucn_cat = 'Not Applicable';


-- invalid_marine
-- MARINE must be '0', '1' or '2'
-- 0 Jan, 0 Feb
select wdpaid, wdpa_pid, marine
from wdpa_wdoecm_poly_feb023
where not marine in ('0', '1', '2');

-- invalid_no_take_marine0
-- Invalid NO_TAKE & MARINE = 0
-- if MARINE = 0 then NO_TAKE must be 'Not Applicable'
-- 516 Jan, 523 Feb
select wdpaid, wdpa_pid, no_take, marine
from wdpa_wdoecm_poly_feb023
where marine = '0'
and not no_take = 'Not Applicable';

-- invalid_no_take_marine12
-- Invalid NO_TAKE & MARINE = [1,2]
-- NO_TAKE is not in ['All', 'Part', 'None', 'Not Reported'] while MARINE = [1, 2]
-- 0 Jan, 0 Feb
select wdpaid, wdpa_pid, no_take, marine
from wdpa_wdoecm_poly_feb023
where marine in ('1', '2')
and not no_take in ('All', 'Part', 'None', 'Not Reported');

-- invalid_no_tk_area_marine0
-- Invalid NO_TK_AREA & MARINE = 0
-- NO_TK_AREA is unequal to 0 while MARINE = 0
-- 28 Jan, 28 Feb
select wdpaid, wdpa_pid, no_tk_area, marine
from wdpa_wdoecm_poly_feb023
where marine = '0'
and not no_tk_area = 0;

-- invalid_no_tk_area_no_take
-- NO_TK_AREA is unequal to 0 while NO_TAKE = 'Not Applicable'
-- 0 Jan, 0 Feb
select wdpaid, wdpa_pid, no_tk_area, no_take
from wdpa_wdoecm_poly_feb023
where no_take = 'Not Applicable'
and not no_tk_area = 0;

-- invalid_status
-- STATUS is unequal to any of the following allowed values:
-- ["Proposed", "Designated", "Established"] for all sites except 2 DESIG_ENG designations (WH & Barcelona convention)
-- 34 Jan, 34 Feb
select wdpaid, wdpa_pid, status, desig_eng
from wdpa_wdoecm_poly_feb023
where not status in ('Proposed', 'Designated', 'Established')
and not desig_eng in ('World Heritage Site (natural or mixed)',
'Specially Protected Areas of Mediterranean Importance (Barcelona Convention)');

-- invalid_status_WH
-- STATUS is unequal to any of the following allowed values:
-- ["Proposed", "Inscribed"] and DESIG_ENG is unequal to 'World Heritage Site (natural or mixed)'
-- CHECK!!! i don't think the code comment matches the query, comment seems to require an and not on last line
select wdpaid, wdpa_pid, status, desig_eng
from wdpa_wdoecm_poly_feb023
where not status in ('Proposed', 'Inscribed')
and desig_eng = 'World Heritage Site (natural or mixed)';

-- invalid_status_Barca
-- STATUS is unequal to any of the following allowed values:
-- ["Proposed", "Established", "Adopted"] and DESIG_ENG is unequal to 'Specially Protected Areas of Mediterranean Importance (Barcelona Convention)'
-- CHECK!!! i don't think the code comment matches the query, comment seems to require an and not on last line
select wdpaid, wdpa_pid, status, desig_eng
from wdpa_wdoecm_poly_feb023
where not status in ('Proposed', 'Adopted')
and desig_eng = 'Specially Protected Areas of Mediterranean Importance (Barcelona Convention)';

-- invalid_status_yr
-- STATUS_YR is unequal to 0 or any year between 1750 and the current year
-- CHECK!!! Jan 273263, Feb 0 - think it's ok though, validation looks broken becuase ~all are failing in current checks, none failing in this one
select wdpaid, wdpa_pid, status_yr
from wdpa_wdoecm_poly_feb023
where not status_yr = 0
and not status_yr between 1750 and extract(year from now());

-- invalid_gov_type
-- GOV_TYPE is invalid
-- Jan 0, Feb 2
select wdpaid, wdpa_pid, gov_type
from wdpa_wdoecm_poly_feb023
where not gov_type in (
  'Federal or national ministry or agency',
  'Sub-national ministry or agency',
  'Government-delegated management',
  'Transboundary governance',
  'Collaborative governance',
  'Joint governance',
  'Individual landowners',
  'Non-profit organisations',
  'For-profit organisations',
  'Indigenous peoples',
  'Local communities',
  'Not Reported'
);

-- invalid_own_type
-- OWN_TYPE is invalid
-- Jan 0, Feb 0
select wdpaid, wdpa_pid, own_type
from wdpa_wdoecm_poly_feb023
where not own_type in (
  'State',
  'Communal',
  'Individual landowners',
  'For-profit organisations',
  'Non-profit organisations',
  'Joint ownership',
  'Multiple ownership',
  'Contested',
  'Not Reported'
);

-- invalid_verif
-- VERIF is invalid
-- Jan 0, Feb 0
select wdpaid, wdpa_pid, verif
from wdpa_wdoecm_poly_feb023
where not verif in (
  'State Verified',
  'Expert Verified',
  'Not Reported'
);

-- invalid_status_desig_type
-- STATUS is unequal to 'Established', while DESIG_TYPE = 'Not Applicable'
-- Jan 0, Feb 0
select wdpaid, wdpa_pid, status, desig_type
from wdpa_wdoecm_poly_feb023
where not status = 'Established'
and desig_type = 'Not Applicable';


-- TODO: tidy up with function

-- forbidden_character_name
-- NAME contains forbidden characters
-- Jan 985, Feb 985
select wdpaid, wdpa_pid, name
from wdpa_wdoecm_poly_feb023
where name ~ '[<>\?\*\r\n]';

-- forbidden_character_orig_name
-- Jan 998, Feb 998
select wdpaid, wdpa_pid, orig_name
from wdpa_wdoecm_poly_feb023
where orig_name ~ '[<>\?\*\r\n]';

-- forbidden_character_desig
-- Jan 0, Feb 0
select wdpaid, wdpa_pid, desig
from wdpa_wdoecm_poly_feb023
where desig ~ '[<>\?\*\r\n]';

-- forbidden_character_desig_eng
-- Jan 0, Feb 0
select wdpaid, wdpa_pid, desig_eng
from wdpa_wdoecm_poly_feb023
where desig_eng ~ '[<>\?\*\r\n]';

-- forbidden_character_mang_auth
-- Jan 4146, Feb 4147
select wdpaid, wdpa_pid, mang_auth
from wdpa_wdoecm_poly_feb023
where mang_auth ~ '[<>\?\*\r\n]';

-- forbidden_character_mang_plan
-- Jan 1701, Feb 1749
select wdpaid, wdpa_pid, mang_plan
from wdpa_wdoecm_poly_feb023
where mang_plan ~ '[<>\?\*\r\n]';

-- forbidden_character_sub_loc
-- Jan 1701, Feb 1749
select wdpaid, wdpa_pid, sub_loc
from wdpa_wdoecm_poly_feb023
where sub_loc ~ '[<>\?\*\r\n]';

-- area_invalid_gis_area
-- check for invalid GIS_AREA <= 0.0001 km² (100 m²)
-- Jan: - , Feb: 758
select wdpaid, wdpa_pid, gis_area
from wdpa_wdoecm_poly_feb023
where gis_area < 0.0001;
​
-- area_invalid_no_tk_area_gis_m_area
-- check if NO_TK_AREA is larger than REP_M_AREA
-- Jan: - , Feb: 532
select wdpaid, wdpa_pid, no_tk_area, gis_m_area
from wdpa_wdoecm_poly_feb023
where no_tk_area > gis_m_area;
​
-- area_invalid_gis_m_area_gis_area
-- check if GIS_M_AREA is larger than GIS_AREA
-- Jan: - , Feb: 358
select wdpaid, wdpa_pid, gis_m_area, gis_area
from wdpa_wdoecm_poly_feb023
where gis_m_area  > gis_area;
​
-- area_invalid_gis_m_area_marine12
-- check if GIS_M_AREA is smaller than or equal to 0 while MARINE = 1 or 2
-- Jan: -, Feb: 0
select wdpaid, wdpa_pid, gis_m_area, marine
from wdpa_wdoecm_poly_feb023
where gis_m_area  <= 0 and marine in ('1','2');
​
-- area_invalid_marine
-- check if MARINE is set properly
-- 0 if GIS_M_AREA/GIS_AREA <= 0.1
-- 1 if 0.1 < GIS_M_AREA/GIS_AREA < 0.9
-- 2 if GIS_M_AREA/GIS_AREA >= 0.9
-- Jan: - , Feb: 0
select wdpaid, wdpa_pid, gis_m_area, gis_area, marine
from wdpa_wdoecm_poly_feb023
where (gis_m_area/gis_area <= 0.1 and marine != '0')
or (gis_m_area/gis_area > 0.1 and gis_m_area/gis_area < 0.9 and marine != '1')
or (gis_m_area/gis_area >= 0.9 and marine != '2');
​
-- ivd_nan_present_gis_area
-- check if GIS_AREA is nan
-- Jan: 0, Feb: 0
select wdpaid, wdpa_pid
from wdpa_wdoecm_poly_feb023
where gis_area = float8 'NaN';
​
-- ivd_nan_present_gis_m_area
-- check if GIS_M_AREA is nan
-- Jan: 0, Feb: 0
select wdpaid, wdpa_pid
from wdpa_wdoecm_poly_feb023
where gis_m_area  = float8 'NaN';
​
-- ivd_nan_present_no_tk_area
-- check if NO_TK_AREA is nan
-- Jan: 0, Feb: 0
select wdpaid, wdpa_pid
from wdpa_wdoecm_poly_feb023
where no_tk_area = float8 'NaN';
​
-- ivd_nan_present_rep_area
-- check if REP_AREA is nan
-- Jan: 0, Feb: 0
select wdpaid, wdpa_pid
from wdpa_wdoecm_poly_feb023
where rep_area  = float8 'NaN';
​
-- ivd_nan_present_rep_m_area
-- check if REP_M_AREA is nan
-- Jan: 0, Feb: 0
select wdpaid, wdpa_pid
from wdpa_wdoecm_poly_feb023
where rep_m_area  = float8 'NaN';
​
-- ivd_nan_present_name
-- check if NAME is nan
-- Jan: 0, Feb: 0
select wdpaid, wdpa_pid
from wdpa_wdoecm_poly_feb023
where name = varchar 'NaN';
​
-- ivd_nan_present_orig_name
-- check if ORIG_NAME is nan
-- Jan: 0, Feb: 0
select wdpaid, wdpa_pid
from wdpa_wdoecm_poly_feb023
where orig_name = varchar 'NaN';
​
-- ivd_nan_present_desig
-- check if DESIG is nan
-- Jan: 0, Feb: 0
select wdpaid, wdpa_pid
from wdpa_wdoecm_poly_feb023
where desig = varchar 'NaN';
​
-- ivd_nan_present_desig_eng
-- check if DESIG_ENG is nan
-- Jan: 0, Feb: 0
select wdpaid, wdpa_pid
from wdpa_wdoecm_poly_feb023
where desig_eng = varchar 'NaN';
​
-- ivd_nan_present_mang_auth
-- check if MANG_AUTH is nan
-- Jan: 0, Feb: 0
select wdpaid, wdpa_pid
from wdpa_wdoecm_poly_feb023
where mang_auth = varchar 'NaN';
​
-- ivd_nan_present_mang_plan
-- check if MANG_PLAN is nan
-- Jan: 0, Feb: 0
select wdpaid, wdpa_pid
from wdpa_wdoecm_poly_feb023
where mang_plan = varchar 'NaN';
​
-- ivd_nan_present_sub_loc
-- check if SUB_LOC is nan
-- Jan: 0, Feb: 0
select wdpaid, wdpa_pid
from wdpa_wdoecm_poly_feb023
where sub_loc = varchar 'NaN';
​
-- ivd_nan_present_int_crit
-- check if INT_CRIT is nan,
-- Jan: 0, Feb: 0
select wdpaid, wdpa_pid
from wdpa_wdoecm_poly_feb023
where int_crit = varchar 'NaN';