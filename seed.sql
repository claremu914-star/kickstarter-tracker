-- Sample Kickstarter projects data (Electronics category)
INSERT OR IGNORE INTO projects (project_id, name, category, subcategory, blurb, goal, pledged, backers_count, currency, country, state, created_at, launched_at, deadline, creator_name, image_url, url, is_hot, scraped_at, updated_at) VALUES 
  ('ks001', 'Smart Watch Pro X', 'Technology', 'Wearables', 'Next-gen smartwatch with 7-day battery life', 50000, 285000, 3420, 'USD', 'US', 'successful', 1704067200, 1706745600, 1709337600, 'TechInnovate Inc', 'https://picsum.photos/seed/watch/400/300', 'https://kickstarter.com/projects/watch-pro-x', 1, 1709337600, 1709337600),
  ('ks002', 'Wireless Earbuds Ultra', 'Technology', 'Audio', 'Premium wireless earbuds with active noise cancellation', 30000, 412000, 5830, 'USD', 'US', 'successful', 1701475200, 1704153600, 1706745600, 'SoundTech Labs', 'https://picsum.photos/seed/earbuds/400/300', 'https://kickstarter.com/projects/earbuds-ultra', 1, 1706745600, 1706745600),
  ('ks003', 'Portable Power Station 2000W', 'Technology', 'Energy', 'High-capacity portable power for outdoor adventures', 100000, 1250000, 8950, 'USD', 'US', 'successful', 1698883200, 1701561600, 1704153600, 'PowerFlow Systems', 'https://picsum.photos/seed/power/400/300', 'https://kickstarter.com/projects/power-station', 1, 1704153600, 1704153600),
  ('ks004', '4K Action Camera Mini', 'Technology', 'Camera', 'Smallest 4K action camera with gimbal stabilization', 25000, 180000, 2890, 'USD', 'US', 'successful', 1696291200, 1698969600, 1701561600, 'CamTech Pro', 'https://picsum.photos/seed/camera/400/300', 'https://kickstarter.com/projects/action-camera', 1, 1701561600, 1701561600),
  ('ks005', 'Smart Home Hub V3', 'Technology', 'Home Automation', 'Universal smart home controller with AI assistant', 40000, 320000, 4120, 'USD', 'US', 'successful', 1709424000, 1712102400, 1714694400, 'HomeAI Tech', 'https://picsum.photos/seed/smarthome/400/300', 'https://kickstarter.com/projects/smart-hub-v3', 1, 1714694400, 1714694400),
  ('ks006', 'Mechanical Keyboard RGB Pro', 'Technology', 'Accessories', 'Customizable mechanical keyboard with hot-swap switches', 20000, 195000, 3250, 'USD', 'US', 'successful', 1706832000, 1709510400, 1712102400, 'KeyMaster Co', 'https://picsum.photos/seed/keyboard/400/300', 'https://kickstarter.com/projects/keyboard-rgb', 1, 1712102400, 1712102400),
  ('ks007', 'Drone X1 with 8K Camera', 'Technology', 'Drones', 'Professional drone with 8K video and 45min flight time', 150000, 980000, 4560, 'USD', 'US', 'successful', 1704153600, 1706832000, 1709424000, 'SkyVision Drones', 'https://picsum.photos/seed/drone/400/300', 'https://kickstarter.com/projects/drone-x1', 1, 1709424000, 1709424000),
  ('ks008', 'E-Ink Monitor 32"', 'Technology', 'Displays', 'Eye-friendly E-Ink monitor for productivity', 80000, 520000, 2890, 'USD', 'US', 'successful', 1712016000, 1714694400, 1717286400, 'DisplayTech Inc', 'https://picsum.photos/seed/monitor/400/300', 'https://kickstarter.com/projects/eink-monitor', 1, 1717286400, 1717286400),
  ('ks009', 'AI Translator Earpiece', 'Technology', 'Wearables', 'Real-time translation in 40+ languages', 35000, 275000, 4680, 'USD', 'US', 'successful', 1714608000, 1717286400, 1719878400, 'LinguaTech AI', 'https://picsum.photos/seed/translator/400/300', 'https://kickstarter.com/projects/ai-translator', 1, 1719878400, 1719878400),
  ('ks010', 'Solar Backpack 50W', 'Technology', 'Energy', 'Backpack with integrated solar panels and USB charging', 15000, 125000, 2340, 'USD', 'US', 'successful', 1717200000, 1719878400, 1722470400, 'EcoCharge Ltd', 'https://picsum.photos/seed/backpack/400/300', 'https://kickstarter.com/projects/solar-backpack', 1, 1722470400, 1722470400),
  ('ks011', 'Wireless Charging Pad 3-in-1', 'Technology', 'Accessories', 'Charge phone, watch, and earbuds simultaneously', 10000, 85000, 1890, 'USD', 'US', 'successful', 1719792000, 1722470400, 1725062400, 'ChargeTech Pro', 'https://picsum.photos/seed/charger/400/300', 'https://kickstarter.com/projects/charging-pad', 0, 1725062400, 1725062400),
  ('ks012', 'VR Headset Standalone', 'Technology', 'VR/AR', 'Lightweight VR headset with 4K per eye resolution', 200000, 1850000, 12340, 'USD', 'US', 'successful', 1722384000, 1725062400, 1727654400, 'VisionVR Systems', 'https://picsum.photos/seed/vr/400/300', 'https://kickstarter.com/projects/vr-headset', 1, 1727654400, 1727654400),
  ('ks013', 'Smart Ring Fitness Tracker', 'Technology', 'Wearables', 'Ultra-thin smart ring with health monitoring', 25000, 340000, 6780, 'USD', 'US', 'live', 1735689600, 1738368000, 1740960000, 'RingFit Tech', 'https://picsum.photos/seed/ring/400/300', 'https://kickstarter.com/projects/smart-ring', 0, 1738368000, 1738368000),
  ('ks014', 'Portable SSD 4TB USB4', 'Technology', 'Storage', 'Ultra-fast portable SSD with 4TB capacity', 30000, 245000, 3890, 'USD', 'US', 'live', 1733011200, 1735689600, 1738281600, 'StoragePro Inc', 'https://picsum.photos/seed/ssd/400/300', 'https://kickstarter.com/projects/portable-ssd', 0, 1735689600, 1735689600),
  ('ks015', 'Mini Projector 4K HDR', 'Technology', 'Displays', 'Pocket-sized 4K projector with 500 lumens', 45000, 390000, 5230, 'USD', 'US', 'live', 1730332800, 1733011200, 1735603200, 'ProjectTech Co', 'https://picsum.photos/seed/projector/400/300', 'https://kickstarter.com/projects/mini-projector', 0, 1733011200, 1733011200);

-- Monthly statistics
INSERT OR IGNORE INTO monthly_stats (year, month, total_projects, total_pledged, total_backers, successful_projects, avg_goal, avg_pledged, created_at) VALUES 
  (2024, 1, 125, 5420000, 45230, 98, 42500, 55000, 1704067200),
  (2024, 2, 142, 6230000, 52340, 112, 38900, 58200, 1706745600),
  (2024, 3, 158, 7125000, 61250, 124, 45200, 62500, 1709424000),
  (2024, 4, 167, 7890000, 68940, 131, 47800, 66300, 1712102400),
  (2024, 5, 173, 8340000, 73250, 138, 48500, 69200, 1714780800),
  (2024, 6, 181, 8920000, 78560, 145, 49200, 72400, 1717459200),
  (2024, 7, 195, 9560000, 84230, 156, 50100, 75800, 1720137600),
  (2024, 8, 203, 10125000, 89670, 163, 51200, 78900, 1722816000),
  (2024, 9, 218, 10890000, 96340, 175, 52300, 82100, 1725494400),
  (2024, 10, 225, 11450000, 101250, 182, 53100, 85200, 1728172800),
  (2024, 11, 234, 12120000, 107890, 189, 54200, 88500, 1730851200),
  (2024, 12, 245, 12850000, 114230, 198, 55300, 91800, 1733529600),
  (2025, 1, 156, 8420000, 75680, 125, 48900, 72300, 1736208000);

-- Hot products ranking
INSERT OR IGNORE INTO hot_products (project_id, year, month, rank, pledged, backers_count, created_at) VALUES 
  ('ks012', 2024, 9, 1, 1850000, 12340, 1727654400),
  ('ks003', 2024, 1, 1, 1250000, 8950, 1704153600),
  ('ks007', 2024, 2, 1, 980000, 4560, 1709424000),
  ('ks008', 2024, 6, 1, 520000, 2890, 1717286400),
  ('ks002', 2024, 1, 2, 412000, 5830, 1706745600),
  ('ks015', 2024, 12, 2, 390000, 5230, 1733011200),
  ('ks013', 2025, 1, 1, 340000, 6780, 1738368000),
  ('ks005', 2024, 4, 2, 320000, 4120, 1714694400),
  ('ks001', 2024, 3, 2, 285000, 3420, 1709337600),
  ('ks009', 2024, 7, 2, 275000, 4680, 1719878400);
