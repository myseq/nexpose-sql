# SQL scripts for Nexpose Enterprise (InsightVM)
Each of the SQL script contains the inline comments.

### default_credential.sql
To list any vulnerability that relates to default credential found by Nexpose. It includes the vulnerability title, last_assessed, port/protocol, proof, hostname and sites.

### duplicate_host.sql
To list all the assets with duplicate hostname. 

### duplicate_ip.sql
To list all the assets with duplicate IP address.

### http_admin.sql
To list all the http/https services information (banner/issuer/subject/validation). This can be used for threat intel to discover all the firewall/vpn/load-balancer management interfaces that facing external (Internet) network.

### vuln_stat50.sql
To list the newly added (last 50 days) vulnerability checks in Nexpose. This can be used for threat intel to highlight the latest critical/high severity vulnerabilities (Default Account/IAVM/Rapid7 Critical/Remote Execution) found within Nexpose including how many assets are affected. It is sorted by CVSS score (decending order) and affected asset count (decending order).  

### test.sql

