
WITH filtered_dr AS (
    SELECT DISTINCT e.uuid AS dr_uuid
    FROM mnt.workordertask a
    JOIN mnt.workorders wo ON wo.workordersoi = a.workorder_oi
    JOIN mnt.asset s ON s.assetoi = a.asset_oi
    JOIN customerdata.epdrfacworkhistory e ON e.wotask_oi = a.workordertaskoi
    WHERE wo.site_oi = 58
      AND a.workclassifi_oi IN (
          209,211,215,266,442,462,
          183,196,207,256,263
      )
      AND NVL(UPPER(TRIM(a.wostatus)), ' ') NOT IN (70,7,8,100)
      AND s.assetnumber NOT LIKE '%DR%'
      AND s.assetnumber NOT LIKE '%SE%'
      AND s.assetnumber NOT LIKE '%SW%'
      AND s.assetnumber NOT LIKE '%-%'
      AND s.assetnumber NOT LIKE '%.%'
      AND s.assetnumber NOT IN ('IBS01','OPS','1')
      AND (
            s.assetnumber <> '1195290'
         OR (s.assetnumber = '1195290'
             AND a.createdate_dttm >= DATE '2025-01-01')
          )
),
rows_20_1 AS (
    SELECT DISTINCT
        LOWER(
          REGEXP_REPLACE(
            REGEXP_REPLACE(NVL(v.dr_uuid, ''), '[^0-9A-Fa-f]', ''),
            '(^[0-9A-Fa-f]{8})([0-9A-Fa-f]{4})([0-9A-Fa-f]{4})([0-9A-Fa-f]{4})([0-9A-Fa-f]{12}$)',
            '\1-\2-\3-\4-\5'
          )
        ) AS inspectionid
    FROM filtered_dr d
    JOIN customerdata.sewerai_inspections_v v
      ON v.dr_uuid = d.dr_uuid
)
SELECT * 
FROM rows_20_1 r
LEFT JOIN customerdata.stg_sewerai_inspections s
  ON s.video_sid = r.inspectionid
WHERE s.video_sid IS NULL;
