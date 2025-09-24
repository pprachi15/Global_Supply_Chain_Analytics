# 📦 Global Supply Chain Analytics

## 🔎 Project Overview
This project simulates a **Logistics Analyst workflow** using SQL.  
A synthetic shipments dataset was created and analyzed to calculate **key supply chain KPIs**.  

The SQL queries demonstrate:
- **Joins, CTEs, window functions, and CASE logic**  
- **Logistics KPIs** like cost per kilogram, on-time performance, carrier diversification, and lane spend analysis  


## 🚚 Dataset
The dataset is **synthetic**, modeled after real shipment records:  
- `shipment_id`, `ship_date`, `delivery_promised`, `delivery_actual`  
- `mode` (Truck, Rail, Air, Sea)  
- `origin_city`, `dest_city`  
- `weight_kg`, `total_cost`, `accessorial_cost`  
- `carrier_id`, `carrier_name`  


## 📊 Key SQL KPIs
1. Cost per kilogram by mode  
2. On-time delivery percent by lane  
3. Average lead time (days)  
4. Carrier scorecard (spend vs. on-time %)  
5. Weekly spend trend (with week-over-week delta)  
6. Accessorial cost share by lane  
7. Mode mix (shipment vs. spend share)  
8. Carrier diversification (share of wallet)  
9. Late shipment buckets (early, on time, 1–3 days late, >3 days late)  
10. Pareto analysis of lanes by freight spend  

---

## ⚡ Next Steps
- Scale dataset with open freight/shipping data (Kaggle, US DOT)  
- Build Tableau/Power BI dashboards using exported CSVs  
- Add forecasting SQL for shipment volumes and spend trends  

---
  


<img width="842" height="451" alt="image" src="https://github.com/user-attachments/assets/e195e2e6-6303-4147-b1dd-1fce2039c0da" />
<img width="853" height="684" alt="image" src="https://github.com/user-attachments/assets/66d062a0-1ccc-4932-a4e7-a938e91c4fef" />
<img width="697" height="269" alt="image" src="https://github.com/user-attachments/assets/546d3ea5-af48-46c7-accf-6784dc276ab2" />
<img width="822" height="426" alt="image" src="https://github.com/user-attachments/assets/0adde39a-09c5-42a1-b1d4-6e328eaf3592" />
<img width="862" height="496" alt="image" src="https://github.com/user-attachments/assets/c2143d43-4b7f-4c56-beb8-ecab0c646abd" />
<img width="846" height="564" alt="image" src="https://github.com/user-attachments/assets/5b83dccc-32f5-4375-a387-4546b86c2100" />
<img width="875" height="462" alt="image" src="https://github.com/user-attachments/assets/26b9ee01-7eee-4a62-99d2-aae444ab0ec3" />
<img width="866" height="408" alt="image" src="https://github.com/user-attachments/assets/96272f19-7ce5-4a1f-813f-0667e86a5d9a" />
<img width="806" height="442" alt="image" src="https://github.com/user-attachments/assets/85cc6fbb-f455-48ee-a152-5f5d037bfbf3" />
<img width="867" height="720" alt="image" src="https://github.com/user-attachments/assets/66b5a543-cf3c-4057-bf27-34ee552cc2cc" />









