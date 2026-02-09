# Kickstarter 真实数据接入指南

## 🚨 重要说明

Kickstarter **没有官方的公开 API**。目前有以下几种方案获取真实数据：

## 方案对比

| 方案 | 费用 | 稳定性 | 数据质量 | 推荐度 |
|------|------|--------|----------|--------|
| **非官方 JSON API** | 免费 | ⭐⭐ 不稳定 | ⭐⭐⭐⭐⭐ 完整 | ⭐⭐ |
| **RapidAPI** | 付费 | ⭐⭐⭐⭐⭐ 稳定 | ⭐⭐⭐⭐ 较完整 | ⭐⭐⭐⭐⭐ |
| **自建爬虫** | 免费/成本 | ⭐⭐⭐ 中等 | ⭐⭐⭐⭐⭐ 完整 | ⭐⭐⭐ |

---

## 方案 1: 非官方 JSON API（已实现）

### 工作原理
Kickstarter 内部使用一些 JSON 端点来加载数据，我们可以直接访问这些端点。

### 优点
- ✅ 完全免费
- ✅ 数据完整且实时
- ✅ 已集成到应用中

### 缺点
- ❌ **非官方接口，可能随时失效**
- ❌ **容易被 Kickstarter 封禁（403 错误）**
- ❌ 可能违反 Kickstarter 服务条款
- ❌ 需要处理反爬虫机制

### 当前状态
⚠️ **测试显示该方案被 Kickstarter 阻止（403 错误）**

由于 Kickstarter 检测到自动化请求，直接访问会被阻止。在生产环境中，这个方案**不推荐使用**。

### 可能的解决方法
1. 使用代理服务器轮换 IP
2. 添加更多真实的浏览器请求头
3. 限制请求频率
4. **不推荐**：可能违反服务条款

---

## 方案 2: RapidAPI Kickstarter API（推荐）⭐

### 服务信息
- **网站**: https://rapidapi.com/UnitedAPI/api/kickstarter2
- **价格**: 有免费配额，付费计划从 $0-$15/月
- **稳定性**: ⭐⭐⭐⭐⭐

### 配置步骤

#### 1. 注册 RapidAPI 账号
访问 https://rapidapi.com/ 并注册账号

#### 2. 订阅 Kickstarter API
访问 https://rapidapi.com/UnitedAPI/api/kickstarter2 并选择订阅计划：
- **Basic**: 免费（100次请求/月）
- **Pro**: $5/月（1000次请求/月）
- **Ultra**: $15/月（10000次请求/月）

#### 3. 获取 API Key
订阅后，在 API 页面找到你的 `X-RapidAPI-Key`

#### 4. 配置到项目

**本地开发环境：**
```bash
# 创建 .dev.vars 文件
cd /home/user/webapp
cat > .dev.vars << 'EOF'
RAPIDAPI_KEY=your_rapidapi_key_here
EOF
```

**生产环境（Cloudflare Pages）：**
```bash
# 使用 wrangler 添加 secret
wrangler pages secret put RAPIDAPI_KEY --project-name kickstarter-tracker
# 输入你的 API Key
```

#### 5. 更新 wrangler.jsonc
确保 `wrangler.jsonc` 中包含环境变量绑定：
```jsonc
{
  "name": "kickstarter-tracker",
  "vars": {
    "RAPIDAPI_KEY": ""  // 本地开发时可留空，使用 .dev.vars
  }
}
```

#### 6. 重启服务
```bash
npm run build
pm2 restart kickstarter-tracker
```

#### 7. 测试数据同步
访问应用，点击"同步数据"按钮，应该可以成功抓取真实数据。

### API 功能
- ✅ 搜索项目
- ✅ 获取项目详情
- ✅ 过滤分类和状态
- ✅ 稳定可靠

---

## 方案 3: 自建爬虫服务

### 架构
```
Cloudflare Workers (前端 + API)
    ↓ (调用)
外部爬虫服务 (Heroku/Railway/Render)
    ↓ (抓取)
Kickstarter 网站
```

### 实现步骤

#### 1. 创建独立的爬虫服务
使用 Python + Scrapy 或 Node.js + Puppeteer

**示例（Python + FastAPI）：**
```python
from fastapi import FastAPI
from bs4 import BeautifulSoup
import requests

app = FastAPI()

@app.get("/scrape/electronics")
async def scrape_electronics():
    url = "https://www.kickstarter.com/discover/advanced?category_id=16&sort=magic"
    response = requests.get(url, headers={
        'User-Agent': 'Mozilla/5.0...'
    })
    soup = BeautifulSoup(response.content, 'html.parser')
    # 解析项目数据...
    return {"projects": [...]}
```

#### 2. 部署到外部平台
- **Heroku**: https://heroku.com
- **Railway**: https://railway.app
- **Render**: https://render.com
- **Fly.io**: https://fly.io

#### 3. 在 Cloudflare Workers 中调用
```typescript
// 在 src/index.tsx 中
app.post('/api/sync', async (c) => {
  const response = await fetch('https://your-scraper.herokuapp.com/scrape/electronics')
  const data = await response.json()
  // 存储到 D1 数据库...
})
```

### 优点
- ✅ 完全可控
- ✅ 可以获取完整数据
- ✅ 可以定制化处理

### 缺点
- ❌ 需要额外部署和维护
- ❌ 可能需要处理验证码
- ❌ 需要定期更新解析规则
- ❌ 可能违反服务条款

---

## 推荐方案总结

### 🏆 最佳方案：RapidAPI（方案 2）
- **适合**: 生产环境、需要稳定服务
- **成本**: $5-15/月
- **工作量**: 5分钟配置
- **稳定性**: ⭐⭐⭐⭐⭐

### 🎯 临时方案：演示数据（当前）
- **适合**: 开发测试、演示展示
- **成本**: 免费
- **工作量**: 已完成
- **稳定性**: ⭐⭐⭐⭐⭐

### ⚡ 进阶方案：自建爬虫（方案 3）
- **适合**: 有技术能力、需要深度定制
- **成本**: 服务器成本
- **工作量**: 1-2天开发
- **稳定性**: ⭐⭐⭐

---

## 当前应用状态

✅ **已实现功能**：
- 数据同步按钮和 UI
- 支持非官方 API（当前被阻止）
- 支持 RapidAPI（需要配置 Key）
- 演示数据完整可用

⚠️ **待配置**：
- RapidAPI Key（推荐）
- 或自建爬虫服务

## 快速开始

### 选项 A: 使用 RapidAPI（推荐）
1. 注册 RapidAPI 账号
2. 订阅 Kickstarter API
3. 配置 API Key 到 `.dev.vars`
4. 重启服务并测试同步

### 选项 B: 继续使用演示数据
- 当前应用已包含 15 条高质量演示数据
- 功能完整，可以直接演示和测试
- 适合原型展示和功能验证

## 技术支持

如遇问题，请检查：
1. API Key 是否正确配置
2. 网络连接是否正常
3. RapidAPI 配额是否充足
4. 查看浏览器控制台错误日志

---

**最后更新**: 2025-02-09
