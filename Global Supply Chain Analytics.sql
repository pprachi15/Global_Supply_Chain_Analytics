{\rtf1\ansi\ansicpg1252\cocoartf2822
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 /* creating a small shipments table */\
CREATE TABLE shipments(\
  shipment_id INTEGER,\
  ship_date DATE,\
  delivery_promised DATE,\
  delivery_actual DATE,\
  mode VARCHAR,\
  origin_city VARCHAR,\
  dest_city VARCHAR,\
  weight_kg DECIMAL(18,2),\
  total_cost DECIMAL(18,2),\
  accessorial_cost DECIMAL(18,2),\
  carrier_id INTEGER,\
  carrier_name VARCHAR\
);\
\
/* sample rows */\
INSERT INTO shipments VALUES\
(1,'2025-07-01','2025-07-05','2025-07-04','Truck','Sacramento','Denver',1000,1500,150,101,'Xpress'),\
(2,'2025-07-02','2025-07-07','2025-07-09','Rail','Fresno','Chicago',2200,2100,120,102,'MidRail'),\
(3,'2025-07-03','2025-07-06','2025-07-06','Air','Oakland','Dallas',300,900,60,103,'SkyGo'),\
(4,'2025-07-04','2025-07-10','2025-07-12','Sea','Los Angeles','Honolulu',5000,2500,300,104,'BlueSea'),\
(5,'2025-07-05','2025-07-09','2025-07-08','Truck','Reno','Salt Lake City',1200,1400,90,101,'Xpress'),\
(6,'2025-07-06','2025-07-11','2025-07-11','Rail','Stockton','Houston',1800,1900,110,102,'MidRail'),\
(7,'2025-07-07','2025-07-10','2025-07-09','Air','San Jose','Phoenix',250,800,50,103,'SkyGo'),\
(8,'2025-07-08','2025-07-13','2025-07-16','Sea','Long Beach','Seattle',4200,2300,280,104,'BlueSea'),\
(9,'2025-07-09','2025-07-12','2025-07-12','Truck','Sacramento','Portland',900,1300,70,101,'Xpress'),\
(10,'2025-07-10','2025-07-15','2025-07-15','Rail','Fresno','Kansas City',2000,2050,115,102,'MidRail'),\
(11,'2025-07-11','2025-07-14','2025-07-13','Air','Oakland','Las Vegas',280,820,45,103,'SkyGo'),\
(12,'2025-07-12','2025-07-18','2025-07-20','Sea','Los Angeles','Anchorage',4800,2550,320,104,'BlueSea');\
\
-- Double checking datatset\
SELECT * FROM shipments LIMIT 5;\
\
CREATE TABLE carriers AS\
SELECT DISTINCT carrier_id, carrier_name FROM shipments;\
\
CREATE TABLE lanes AS\
SELECT DISTINCT\
  CONCAT(origin_city,'\uc0\u8594 ',dest_city) AS lane_id,\
  origin_city,\
  dest_city\
FROM shipments;\
\
CREATE TABLE modes AS\
SELECT DISTINCT mode FROM shipments;\
\
-- 1. Cost per kg by mode\
SELECT\
  s.mode,\
  COUNT(*) AS shipments,\
  SUM(s.total_cost) AS spend_usd,\
  SUM(s.total_cost) / NULLIF(SUM(s.weight_kg),0) AS cost_per_kg\
FROM shipments s\
JOIN modes m ON m.mode = s.mode\
GROUP BY s.mode\
ORDER BY cost_per_kg;\
\
-- 2. On time percent by lane\
SELECT\
  l.lane_id,\
  COUNT(*) AS shipments,\
  AVG(CASE WHEN s.delivery_actual <= s.delivery_promised THEN 1.0 ELSE 0.0 END) AS on_time_pct\
FROM shipments s\
JOIN lanes l\
  ON l.origin_city = s.origin_city AND l.dest_city = s.dest_city\
GROUP BY l.lane_id\
ORDER BY on_time_pct DESC;\
\
-- 3. Average lead time in days\
SELECT\
  AVG(date_diff('day', ship_date, delivery_actual)) AS avg_lead_time_days\
FROM shipments;\
\
-- 4. Carrier scorecard \
SELECT\
  c.carrier_name,\
  COUNT(*) AS shipments,\
  SUM(s.total_cost) AS spend_usd,\
  AVG(CASE WHEN s.delivery_actual <= s.delivery_promised THEN 1.0 ELSE 0.0 END) AS on_time_pct\
FROM shipments s\
JOIN carriers c USING (carrier_id)\
GROUP BY c.carrier_name\
ORDER BY spend_usd DESC;\
\
-- 5. Weekly spend trend \
WITH wk AS (\
  SELECT\
    date_trunc('week', ship_date) AS week_start,\
    SUM(total_cost) AS spend_usd\
  FROM shipments\
  GROUP BY 1\
)\
SELECT\
  week_start,\
  spend_usd,\
  spend_usd - LAG(spend_usd) OVER (ORDER BY week_start) AS delta_vs_prev_week\
FROM wk\
ORDER BY week_start;\
\
-- 6. Bonus accessorial share by lane\
SELECT\
  l.lane_id,\
  SUM(s.accessorial_cost) AS accessorial_usd,\
  SUM(s.total_cost) AS total_usd,\
  SUM(s.accessorial_cost) / NULLIF(SUM(s.total_cost),0) AS accessorial_share\
FROM shipments s\
LEFT OUTER JOIN lanes l\
  ON l.origin_city = s.origin_city AND l.dest_city = s.dest_city\
GROUP BY l.lane_id\
ORDER BY accessorial_share DESC;\
\
-- 7. Mode mix: share of shipments and spend\
SELECT\
  s.mode,\
  COUNT(*) AS shipments,\
  COUNT(*) * 1.0 / NULLIF(COUNT(*) OVER (),0) AS shipment_share,\
  SUM(total_cost) AS spend_usd,\
  SUM(total_cost) * 1.0 / NULLIF(SUM(SUM(total_cost)) OVER (),0) AS spend_share\
FROM shipments s\
GROUP BY s.mode\
ORDER BY spend_share DESC;\
\
-- 8. Carrier diversification: share of total spend\
SELECT\
  c.carrier_name,\
  SUM(s.total_cost) AS spend_usd,\
  SUM(s.total_cost) * 1.0 / NULLIF(SUM(SUM(total_cost)) OVER (),0) AS spend_share\
FROM shipments s\
JOIN carriers c USING (carrier_id)\
GROUP BY c.carrier_name\
ORDER BY spend_share DESC;\
\
-- 9. Late shipment buckets (early, on time, late 1-3 days, late >3 days)\
SELECT\
  CASE\
    WHEN delivery_actual < delivery_promised THEN 'Early'\
    WHEN delivery_actual = delivery_promised THEN 'OnTime'\
    WHEN date_diff('day', delivery_promised, delivery_actual) BETWEEN 1 AND 3 THEN 'Late1to3'\
    ELSE 'LateOver3'\
  END AS late_bucket,\
  COUNT(*) AS shipments\
FROM shipments\
GROUP BY 1\
ORDER BY shipments DESC;\
\
\
-- 10. Pareto of lanes by freight spend\
WITH spend AS (\
  SELECT l.lane_id, SUM(s.total_cost) AS lane_spend\
  FROM shipments s\
  JOIN lanes l ON l.origin_city = s.origin_city AND l.dest_city = s.dest_city\
  GROUP BY l.lane_id\
),\
ranked AS (\
  SELECT\
    lane_id,\
    lane_spend,\
    SUM(lane_spend) OVER (ORDER BY lane_spend DESC) AS cum_spend,\
    SUM(lane_spend) OVER () AS total_spend\
  FROM spend\
)\
SELECT\
  lane_id,\
  lane_spend,\
  cum_spend,\
  cum_spend / NULLIF(total_spend,0) AS cum_share\
FROM ranked\
ORDER BY lane_spend DESC;\
\
\
\
\
\
\
\
\
\
\
}