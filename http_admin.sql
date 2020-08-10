WITH
  dp AS (SELECT protocol_id, name FROM dim_protocol),
  ds AS (SELECT service_id, name FROM dim_service),
  dvs AS (SELECT status_id, description FROM dim_vulnerability_status),
  Asset_Services AS (
    SELECT asset_id, service_id, port, json_object_agg(name, replace(value::text, '"', '')) as cert
      FROM dim_asset_service_configuration
      WHERE lower(name) like 'ssl.cert.%' OR lower(name) like 'http.%'
      GROUP BY 1, 2, 3
)
SELECT DISTINCT favi.asset_id, da.ip_address, da.host_name, dos.description,
    favi.port, dp.name, ds.name,
    ac.cert->>'http.banner' AS "Banner",
    ac.cert->>'http.banner.server' AS "Server",
    ac.cert->>'ssl.cert.issuer.dn' AS "Issuer",
    ac.cert->>'ssl.cert.subject.dn' AS "Subject",
    ac.cert->>'ssl.cert.subject.alt.name-count' AS "Alt-Names",
    ac.cert->>'ssl.cert.not.valid.before' AS "Invalid Before",
    ac.cert->>'ssl.cert.not.valid.after' AS "Invalid After",
    (CAST(ac.cert->>'ssl.cert.not.valid.after' AS DATE) - CURRENT_DATE) AS "Expires In (days)",
    to_char(da.last_assessed_for_vulnerabilities, 'YYYY-MM-DD HH:MM') AS "Last_Assess", da.sites
FROM fact_asset_vulnerability_instance favi
  JOIN dim_vulnerability dv USING (vulnerability_id)
  JOIN dim_asset da USING (asset_id)
  JOIN dim_operating_system dos USING (operating_system_id)
  JOIN dp USING (protocol_id)
  JOIN ds USING (service_id)
  JOIN dvs USING (status_id)
  JOIN Asset_Services ac USING (asset_id, service_id, port)
ORDER BY ip_address, sites

