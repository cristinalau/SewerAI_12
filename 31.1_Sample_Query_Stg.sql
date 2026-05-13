SELECT
    c.work_order_uuid,
    c.workorder,
    c.po_number,
    c.upstream_mh,
    c.downstream_mh,
    c.manhole_number,
    c.lateral_segment_reference,
    c.pipe_use,
    c.access_type,
    c.mh_use,
    s.hole_number,
    s.mh_use      AS mh_use1,
    s.access_type AS access_type1
FROM customerdata.stg_sewerai_inspections s
JOIN customerdata.epsewerai_cr_inspect c
  ON c.work_order_uuid = s.project_sid
 AND c.workorder       = s.work_order   
 AND c.po_number       = s.po_number
 AND c.upstream_mh     = s.upstream_mh
 AND c.downstream_mh   = s.downstream_mh;