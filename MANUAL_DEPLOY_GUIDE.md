# 🎯 Kickstarter 追踪器 - 最简单部署方式（无需 API Token）

## 方法概述

我们将通过 **GitHub + Cloudflare Pages 自动部署** 的方式来部署，完全不需要配置 API Token！

---

## 📋 部署步骤（总共5步，约15分钟）

### 第一步：准备代码文件

你的所有代码已经准备好了，在这个目录：
```
/home/user/webapp/
```

你需要下载项目备份：
- **下载链接**：https://www.genspark.ai/api/files/s/rrUT0C2N
- 点击链接下载 `kickstarter-tracker-ready-to-deploy.tar.gz`
- 保存到你的电脑

---

### 第二步：解压项目文件

**Windows 用户**：
1. 找到下载的 `.tar.gz` 文件
2. 右键 → 解压（可能需要安装 7-Zip 或 WinRAR）
3. 解压后得到 `webapp` 文件夹

**Mac 用户**：
1. 双击 `.tar.gz` 文件自动解压

---

### 第三步：推送到 GitHub

#### 3.1 在 GitHub 创建新仓库

1. 访问：https://github.com/new
2. **仓库名称**：`kickstarter-tracker`
3. **可见性**：Public（公开）或 Private（私有）都可以
4. **不要**勾选 "Add a README file"
5. 点击 **"Create repository"**

#### 3.2 上传代码到 GitHub

有两种方式上传代码：

**方式 A：通过 GitHub 网页上传（最简单）** ⭐

1. 在刚创建的仓库页面，点击 **"uploading an existing file"**
2. 将解压后的 `webapp` 文件夹里的**所有文件**拖拽到网页
3. 等待上传完成
4. 在底部填写提交信息：`Initial commit`
5. 点击 **"Commit changes"**

**方式 B：使用 Git 命令行（如果你会用）**

如果你电脑上已经安装了 Git：
```bash
cd webapp  # 进入解压后的项目目录
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/你的用户名/kickstarter-tracker.git
git push -u origin main
```

---

### 第四步：连接 Cloudflare Pages

#### 4.1 登录 Cloudflare

访问：https://dash.cloudflare.com/
（如果还没注册，先注册一个免费账号）

#### 4.2 创建 Pages 项目

1. 在左侧菜单找到 **"Workers & Pages"**
2. 点击 **"Create application"** 或 **"创建应用程序"**
3. 选择 **"Pages"** 标签
4. 点击 **"Connect to Git"** 或 **"连接到 Git"**

#### 4.3 连接 GitHub

1. 选择 **"GitHub"**
2. 点击 **"Connect GitHub"** 授权 Cloudflare 访问
3. 在弹出窗口中选择你刚创建的仓库 `kickstarter-tracker`
4. 点击 **"Begin setup"** 或 **"开始设置"**

#### 4.4 配置构建设置

在构建设置页面，填写以下信息：

**项目名称**：
```
kickstarter-tracker
```

**生产分支**：
```
main
```

**构建命令**：
```
npm run build
```

**构建输出目录**：
```
dist
```

**环境变量**：
- 暂时不需要添加

然后点击 **"Save and Deploy"** 或 **"保存并部署"**

---

### 第五步：创建和配置 D1 数据库

部署成功后，需要配置数据库：

#### 5.1 创建 D1 数据库

1. 在 Cloudflare 控制台左侧，找到 **"Workers & Pages"**
2. 点击你的 `kickstarter-tracker` 项目
3. 点击顶部的 **"Settings"** 标签
4. 在左侧找到 **"Bindings"**（绑定）
5. 向下滚动找到 **"D1 Database Bindings"**
6. 点击 **"Add binding"** 或 **"添加绑定"**

#### 5.2 绑定数据库

**变量名称**：
```
DB
```

**D1 数据库**：
- 点击下拉菜单
- 选择 **"Create a new database"** 或 **"创建新数据库"**

**数据库名称**：
```
kickstarter-tracker-db
```

点击 **"Create"** 创建数据库

然后点击 **"Save"** 保存绑定

#### 5.3 应用数据库迁移

这一步需要在浏览器的 Cloudflare 控制台完成：

1. 在左侧菜单找到 **"D1"** 或 **"D1 SQL Database"**
2. 点击你刚创建的 `kickstarter-tracker-db`
3. 点击 **"Console"** 标签
4. 在 SQL 编辑器中，复制粘贴以下内容：

```sql
-- 创建 projects 表
CREATE TABLE IF NOT EXISTS projects (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  project_id TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  category TEXT NOT NULL,
  subcategory TEXT,
  blurb TEXT,
  goal REAL NOT NULL,
  pledged REAL NOT NULL,
  backers_count INTEGER DEFAULT 0,
  currency TEXT DEFAULT 'USD',
  country TEXT,
  state TEXT NOT NULL,
  created_at INTEGER NOT NULL,
  launched_at INTEGER,
  deadline INTEGER,
  state_changed_at INTEGER,
  creator_name TEXT,
  image_url TEXT,
  url TEXT,
  is_hot BOOLEAN DEFAULT 0,
  scraped_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);

-- 创建 monthly_stats 表
CREATE TABLE IF NOT EXISTS monthly_stats (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  year INTEGER NOT NULL,
  month INTEGER NOT NULL,
  total_projects INTEGER DEFAULT 0,
  total_pledged REAL DEFAULT 0,
  total_backers INTEGER DEFAULT 0,
  successful_projects INTEGER DEFAULT 0,
  avg_goal REAL DEFAULT 0,
  avg_pledged REAL DEFAULT 0,
  created_at INTEGER NOT NULL,
  UNIQUE(year, month)
);

-- 创建 hot_products 表
CREATE TABLE IF NOT EXISTS hot_products (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  project_id TEXT NOT NULL,
  year INTEGER NOT NULL,
  month INTEGER NOT NULL,
  rank INTEGER NOT NULL,
  pledged REAL NOT NULL,
  backers_count INTEGER NOT NULL,
  created_at INTEGER NOT NULL,
  UNIQUE(project_id, year, month)
);

-- 创建索引
CREATE INDEX IF NOT EXISTS idx_projects_category ON projects(category);
CREATE INDEX IF NOT EXISTS idx_projects_state ON projects(state);
CREATE INDEX IF NOT EXISTS idx_projects_pledged ON projects(pledged DESC);
CREATE INDEX IF NOT EXISTS idx_projects_backers ON projects(backers_count DESC);
CREATE INDEX IF NOT EXISTS idx_projects_scraped_at ON projects(scraped_at DESC);
CREATE INDEX IF NOT EXISTS idx_projects_is_hot ON projects(is_hot);
CREATE INDEX IF NOT EXISTS idx_monthly_stats_year_month ON monthly_stats(year, month);
CREATE INDEX IF NOT EXISTS idx_hot_products_year_month ON hot_products(year, month);
```

5. 点击 **"Execute"** 或 **"执行"**

#### 5.4 填充演示数据

继续在同一个 Console 中，清空之前的 SQL，然后复制粘贴以下演示数据：

（由于数据较多，我会分成几部分）

**第一部分 - 插入项目数据**：
```sql
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
```

点击 **"Execute"**

**第二部分 - 月度统计数据**：
```sql
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
```

点击 **"Execute"**

**第三部分 - 热门产品排行**：
```sql
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
```

点击 **"Execute"**

---

### 第六步：重新部署

数据库配置完成后，需要重新部署应用：

1. 回到 **Workers & Pages** → `kickstarter-tracker`
2. 点击 **"Deployments"** 标签
3. 找到最新的部署，点击右侧的 **"︙"** 菜单
4. 选择 **"Retry deployment"** 或 **"Redeploy"**

或者更简单：
1. 在你的 GitHub 仓库中，随便编辑一个文件（比如 README.md）
2. 提交更改
3. Cloudflare 会自动重新部署

---

## 🎉 完成！

部署成功后，你会得到一个 URL：
```
https://kickstarter-tracker.pages.dev
```

访问这个 URL 就能看到你的应用了！

---

## 🔑 可选：配置 RapidAPI Key（启用真实数据）

如果你想启用真实 Kickstarter 数据同步：

1. 在 Cloudflare 控制台，进入你的项目
2. 点击 **"Settings"** → **"Environment variables"**
3. 点击 **"Add variable"**
4. **变量名**：`RAPIDAPI_KEY`
5. **值**：粘贴你的 RapidAPI Key
6. **环境**：选择 Production
7. 点击 **"Save"**
8. 重新部署应用

---

## ❓ 常见问题

**Q: 部署失败了怎么办？**
A: 在 Cloudflare 控制台查看部署日志，通常错误信息会很清楚。

**Q: 数据库绑定后应用还是报错？**
A: 需要重新部署一次应用，让绑定生效。

**Q: 如何查看应用日志？**
A: 在项目页面的 "Logs" 标签查看实时日志。

**Q: 可以使用自定义域名吗？**
A: 可以！在 "Custom domains" 设置中添加你的域名。

---

**这是最简单的部署方式，完全不需要命令行和 API Token！** 🎉
