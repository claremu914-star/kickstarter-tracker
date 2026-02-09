# Kickstarter 电子产品众筹追踪器

## 项目概述
- **项目名称**: Kickstarter 电子产品众筹追踪器
- **目标**: 实时追踪 Kickstarter 平台上电子产品类别的众筹项目数据，包括众筹金额、支持者数量、项目状态等关键指标
- **主要功能**:
  - 📊 实时数据统计（总项目数、总众筹金额、总支持人数、成功率）
  - 🔥 爆款产品排行榜（按月度统计 TOP 10）
  - 📋 完整项目列表（支持筛选、排序、搜索）
  - 📈 月度趋势分析（可视化图表展示历史数据）
  - 🔄 **一键同步真实 Kickstarter 数据**

## 演示地址
- **本地开发**: https://3000-i4svdqn5as8l8nevkukqp-cc2fbc16.sandbox.novita.ai
- **生产环境**: 待部署到 Cloudflare Pages

## 当前已完成功能

### ✅ 后端 API (Hono)
1. **项目数据 API**
   - `GET /api/projects` - 获取所有项目列表
     - 参数：`category`, `state`, `sort`, `order`, `limit`
   - `GET /api/search` - 搜索项目
     - 参数：`q` (搜索关键词), `limit`
   - **`POST /api/sync` - 同步真实 Kickstarter 数据（新增）**
     - 参数：`state`, `pages`

2. **统计数据 API**
   - `GET /api/stats/overview` - 获取整体统计数据
   - `GET /api/hot-products` - 获取爆款产品排行
     - 参数：`year`, `month`, `limit`
   - `GET /api/monthly-stats` - 获取月度统计数据
     - 参数：`year`, `months`

### ✅ 数据同步服务（新增）
- **KickstarterService**: 统一数据获取接口
- **KickstarterUnofficialAPI**: 免费的非官方 API（可能被阻止）
- **KickstarterRapidAPI**: RapidAPI 集成（推荐，需要 API Key）
- **自动数据转换**: 将 Kickstarter 数据格式转换为数据库格式
- **智能更新机制**: 自动识别新项目和已存在项目

### ✅ 前端界面
1. **首页统计卡片**
   - 总项目数、总众筹金额、总支持人数、成功率

2. **数据同步功能（新增）**
   - 🔄 一键同步按钮
   - 同步配置弹窗（选择状态、页数）
   - 实时进度显示
   - 同步结果反馈（成功/失败统计）

3. **三个功能标签页**
   - 🔥 **爆款产品**: 展示按众筹金额排名的 TOP 10 热门产品
   - 📋 **所有项目**: 
     - 卡片式展示所有项目
     - 支持按状态筛选（进行中/成功/失败）
     - 支持按金额/支持人数/时间排序
     - 搜索功能
   - 📈 **趋势分析**: 
     - Chart.js 可视化图表
     - 展示过去 12 个月的众筹趋势

### ✅ 数据存储
- **Cloudflare D1 SQLite 数据库**
  - `projects` - 项目详细信息表
  - `monthly_stats` - 月度统计表
  - `hot_products` - 爆款产品排行表
- **15 条演示数据** 已导入

## 数据架构

### 数据模型

#### Projects (项目表)
```sql
- id: 自增主键
- project_id: Kickstarter 项目 ID（唯一）
- name: 项目名称
- category: 类别（Technology）
- subcategory: 子类别（Wearables, Audio, Camera 等）
- blurb: 项目简介
- goal: 众筹目标金额
- pledged: 已筹集金额
- backers_count: 支持者数量
- currency: 货币类型
- country: 国家
- state: 状态（live/successful/failed）
- created_at: 创建时间
- launched_at: 启动时间
- deadline: 截止时间
- creator_name: 创建者名称
- image_url: 项目图片
- url: 项目链接
- is_hot: 是否热门
- scraped_at: 抓取时间
- updated_at: 更新时间
```

#### Monthly Stats (月度统计表)
```sql
- id: 自增主键
- year: 年份
- month: 月份
- total_projects: 项目总数
- total_pledged: 总众筹金额
- total_backers: 总支持者数
- successful_projects: 成功项目数
- avg_goal: 平均目标金额
- avg_pledged: 平均众筹金额
```

#### Hot Products (爆款产品表)
```sql
- id: 自增主键
- project_id: 项目 ID（外键）
- year: 年份
- month: 月份
- rank: 排名
- pledged: 众筹金额
- backers_count: 支持者数量
```

### 存储服务
- **Cloudflare D1**: SQLite 数据库（用于结构化数据存储）
- **本地开发**: 使用 `--local` 模式，数据存储在 `.wrangler/state/v3/d1`

## 用户使用指南

### 查看数据统计
1. 打开首页，查看顶部的四个统计卡片
2. 数据实时从数据库加载，包括：
   - 总项目数
   - 总众筹金额
   - 总支持人数
   - 项目成功率

### 浏览爆款产品
1. 点击 "爆款产品" 标签页
2. 查看按众筹金额排名的 TOP 10 产品
3. 每个产品显示：
   - 排名徽章
   - 项目图片
   - 项目名称和简介
   - 众筹金额和支持者数量
   - 所属年月

### 搜索和筛选项目
1. 点击 "所有项目" 标签页
2. 使用筛选器：
   - 按状态筛选（所有/进行中/成功/失败）
   - 按排序方式（金额/支持人数/创建时间）
3. 使用搜索框：
   - 输入关键词搜索项目名称、简介或创建者
   - 点击搜索按钮或按 Enter 键

### 查看趋势分析
1. 点击 "趋势分析" 标签页
2. 查看过去 12 个月的数据趋势图表：
   - 绿色线：总众筹金额趋势
   - 蓝色线：项目数量趋势
3. 鼠标悬停查看具体数值

## 技术架构

### 后端技术栈
- **Hono**: 轻量级 Web 框架
- **Cloudflare Workers**: Edge 运行时
- **Cloudflare D1**: 分布式 SQLite 数据库
- **TypeScript**: 类型安全

### 前端技术栈
- **纯 HTML/CSS/JavaScript**: 无框架依赖
- **Tailwind CSS**: 样式框架（CDN）
- **Font Awesome**: 图标库（CDN）
- **Chart.js**: 图表库（CDN）
- **Axios**: HTTP 客户端（CDN）

### 开发工具
- **Vite**: 构建工具
- **Wrangler**: Cloudflare CLI
- **PM2**: 进程管理器
- **Git**: 版本控制

## 本地开发

### 前置要求
- Node.js 18+
- npm 或 yarn

### 安装和运行
```bash
# 克隆项目
git clone <repository-url>
cd webapp

# 安装依赖
npm install

# 初始化数据库
npm run db:migrate:local
npm run db:seed

# 构建项目
npm run build

# 启动开发服务器
pm2 start ecosystem.config.cjs

# 查看日志
pm2 logs kickstarter-tracker --nostream

# 停止服务
pm2 delete kickstarter-tracker
```

### 数据库管理
```bash
# 重置数据库
npm run db:reset

# 执行 SQL 命令
npm run db:console:local -- --command="SELECT * FROM projects LIMIT 5"

# 查看数据库文件
ls -la .wrangler/state/v3/d1/
```

## 部署说明

### Cloudflare Pages 部署
```bash
# 1. 安装 Wrangler CLI（如果未安装）
npm install -g wrangler

# 2. 登录 Cloudflare
wrangler login

# 3. 创建生产数据库
wrangler d1 create kickstarter-db
# 将返回的 database_id 复制到 wrangler.jsonc

# 4. 应用数据库迁移
npm run db:migrate:prod

# 5. 构建项目
npm run build

# 6. 创建 Pages 项目
wrangler pages project create kickstarter-tracker --production-branch main

# 7. 部署到生产环境
npm run deploy:prod
```

### 环境变量配置
生产环境暂无需要配置的环境变量。如需接入真实 Kickstarter API，需要：
```bash
# 添加 API Key
wrangler pages secret put KICKSTARTER_API_KEY --project-name kickstarter-tracker
```

## 未来计划

### ⚠️ 真实数据接入状态

**当前状况**: 
- ✅ 数据同步功能已实现
- ⚠️ Kickstarter 非官方 API 被阻止（403 错误）
- 🔧 需要配置 RapidAPI Key 才能抓取真实数据

**推荐方案**: 使用 RapidAPI（详见 `KICKSTARTER_API_GUIDE.md`）

**配置步骤**:
1. 访问 https://rapidapi.com/UnitedAPI/api/kickstarter2
2. 注册并订阅（有免费配额）
3. 获取 API Key
4. 配置到项目：
   ```bash
   # 本地开发
   echo "RAPIDAPI_KEY=your_key_here" > .dev.vars
   
   # 生产环境
   wrangler pages secret put RAPIDAPI_KEY --project-name kickstarter-tracker
   ```
5. 重启服务并使用"同步数据"功能

**备选方案**: 
- 继续使用演示数据（当前 15 条高质量数据）
- 自建爬虫服务（需要额外开发）

### 待实现功能
1. **数据更新优化**
   - ✅ 手动同步按钮（已实现）
   - ⏳ 定时自动同步（Cloudflare Workers Cron）
   - ⏳ 增量更新策略
   - ⏳ 数据去重和清理

2. **高级功能**
   - 项目详情页
   - 收藏和关注功能
   - 邮件提醒（新爆款、价格变动）
   - 数据导出（CSV/Excel）
   - 多语言支持

3. **数据分析增强**
   - 更多维度的统计图表
   - 成功率预测
   - 类别对比分析
   - 创作者排行榜

### 推荐下一步
1. **配置 RapidAPI**（5分钟）
   - 启用真实数据同步
   - 获取最新的 Kickstarter 项目

2. **优化用户体验**
   - 添加加载动画
   - 实现无限滚动
   - 添加错误提示和重试机制
   - 响应式设计优化

3. **性能优化**
   - 实现数据缓存策略（Cloudflare KV）
   - 图片 CDN 优化
   - 分页加载

4. **部署到生产环境**
   - 部署到 Cloudflare Pages
   - 配置自定义域名
   - 设置监控和告警

## 项目状态
- **开发状态**: ✅ 完成
- **本地测试**: ✅ 通过
- **生产部署**: ⏳ 待部署
- **最后更新**: 2025-02-09

## 联系方式
如需帮助或有建议，请通过项目仓库提交 Issue。
