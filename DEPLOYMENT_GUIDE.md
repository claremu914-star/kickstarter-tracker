# Kickstarter 追踪器 - 完整部署指南

## 📋 部署前准备清单

在开始部署前，请确保完成以下准备工作：

### ✅ 1. GitHub 配置（必需）
- [ ] 在左侧 **#github** 标签页完成 GitHub 授权
- [ ] 连接你的 GitHub 账号
- [ ] 选择或创建目标仓库

### ✅ 2. Cloudflare 配置（必需）
- [ ] 在左侧 **Deploy** 标签页配置 Cloudflare API Token
- [ ] 注册 Cloudflare 账号：https://dash.cloudflare.com/sign-up
- [ ] 创建 API Token（教程见下文）

### ✅ 3. RapidAPI 配置（可选，用于真实数据）
- [ ] 注册 RapidAPI 账号
- [ ] 订阅 Kickstarter API（免费计划）
- [ ] 获取 API Key
- [ ] 详见：`RAPIDAPI_REGISTRATION_GUIDE.md`

---

## 🔧 Cloudflare API Token 创建教程

### 步骤 1：登录 Cloudflare
访问：https://dash.cloudflare.com/

### 步骤 2：创建 API Token
1. 点击右上角头像
2. 选择 "My Profile"（我的个人资料）
3. 点击左侧 "API Tokens"
4. 点击 "Create Token"（创建令牌）

### 步骤 3：选择模板
选择 **"Edit Cloudflare Workers"** 模板（推荐）

或者选择 **"Create Custom Token"** 并配置以下权限：

**权限配置**：
- Account - Cloudflare Pages - Edit
- Account - D1 - Edit
- Zone - Workers Routes - Edit
- Zone - Workers Scripts - Edit

### 步骤 4：设置资源范围
- **Account Resources**: 选择你的账户
- **Zone Resources**: Include - All zones

### 步骤 5：完成创建
1. 点击 "Continue to summary"
2. 点击 "Create Token"
3. **复制生成的 Token**（只显示一次！）

### 步骤 6：配置到项目
1. 在代码沙盒左侧找到 **Deploy** 标签页
2. 粘贴你的 API Token
3. 点击保存

---

## 🚀 自动化部署流程（推荐）

配置完 GitHub 和 Cloudflare 后，我会自动执行：

### 第一步：推送代码到 GitHub
```bash
# 自动执行
git remote add origin https://github.com/YOUR_USERNAME/kickstarter-tracker.git
git push -f origin main
```

### 第二步：创建 Cloudflare D1 数据库
```bash
# 自动执行
npx wrangler d1 create kickstarter-tracker-db
```

### 第三步：更新配置文件
自动更新 `wrangler.jsonc` 中的 database_id

### 第四步：应用数据库迁移
```bash
# 自动执行（生产环境）
npx wrangler d1 migrations apply kickstarter-tracker-db
```

### 第五步：填充初始数据
```bash
# 自动执行
npx wrangler d1 execute kickstarter-tracker-db --file=./seed.sql
```

### 第六步：构建项目
```bash
# 自动执行
npm run build
```

### 第七步：创建 Cloudflare Pages 项目
```bash
# 自动执行
npx wrangler pages project create kickstarter-tracker \
  --production-branch main
```

### 第八步：部署到生产环境
```bash
# 自动执行
npx wrangler pages deploy dist --project-name kickstarter-tracker
```

### 第九步：配置环境变量（可选）
如果你有 RapidAPI Key：
```bash
# 需要手动执行
npx wrangler pages secret put RAPIDAPI_KEY --project-name kickstarter-tracker
```

---

## 📝 手动部署流程（备选）

如果自动化失败，可以手动执行：

### 1. 安装 Wrangler CLI
```bash
npm install -g wrangler
```

### 2. 登录 Cloudflare
```bash
wrangler login
```

### 3. 创建 D1 数据库
```bash
cd /home/user/webapp
npx wrangler d1 create kickstarter-tracker-db
```

复制输出的 database_id，更新到 `wrangler.jsonc`：
```jsonc
{
  "d1_databases": [
    {
      "binding": "DB",
      "database_name": "kickstarter-tracker-db",
      "database_id": "粘贴你的-database-id-这里"
    }
  ]
}
```

### 4. 应用数据库迁移
```bash
npx wrangler d1 migrations apply kickstarter-tracker-db
```

### 5. 填充初始数据
```bash
npx wrangler d1 execute kickstarter-tracker-db --file=./seed.sql
```

### 6. 构建项目
```bash
npm run build
```

### 7. 创建 Pages 项目
```bash
npx wrangler pages project create kickstarter-tracker --production-branch main
```

### 8. 部署
```bash
npx wrangler pages deploy dist --project-name kickstarter-tracker
```

---

## 🔑 配置 RapidAPI Key（启用真实数据）

部署成功后，如果你已经获取了 RapidAPI Key：

```bash
# 配置到生产环境
npx wrangler pages secret put RAPIDAPI_KEY --project-name kickstarter-tracker

# 系统会提示你输入 Key
# 粘贴你的 RapidAPI Key 并按 Enter
```

验证配置：
```bash
npx wrangler pages secret list --project-name kickstarter-tracker
```

---

## 🌐 访问你的应用

部署成功后，你会得到两个 URL：

### 生产环境 URL
```
https://kickstarter-tracker.pages.dev
```

### 自定义域名（可选）
你可以在 Cloudflare Pages 控制台添加自定义域名：
```bash
npx wrangler pages domain add your-domain.com --project-name kickstarter-tracker
```

---

## ✅ 部署后验证

### 1. 访问应用
打开生产环境 URL，检查页面是否正常加载

### 2. 测试基本功能
- 查看统计数据是否显示
- 浏览爆款产品列表
- 测试筛选和搜索
- 查看趋势图表

### 3. 测试数据同步（如果配置了 RapidAPI）
- 点击顶部"同步数据"按钮
- 选择配置并开始同步
- 检查是否成功抓取真实数据

### 4. 检查数据库
```bash
# 查询生产数据库
npx wrangler d1 execute kickstarter-tracker-db \
  --command="SELECT COUNT(*) as count FROM projects"
```

---

## 🔧 常见问题

### Q1: 部署失败，提示权限错误
**A**: 检查 Cloudflare API Token 权限，确保包含：
- Cloudflare Pages - Edit
- D1 - Edit

### Q2: 数据库连接失败
**A**: 
1. 检查 `wrangler.jsonc` 中的 database_id 是否正确
2. 确保数据库迁移已应用
3. 重新部署项目

### Q3: "同步数据"失败
**A**: 
1. 检查是否配置了 RAPIDAPI_KEY
2. 检查 API Key 是否有效
3. 检查 RapidAPI 配额是否用完

### Q4: 如何更新应用？
**A**: 
```bash
# 修改代码后
git add .
git commit -m "Update features"
git push origin main

# 重新部署
npm run build
npx wrangler pages deploy dist --project-name kickstarter-tracker
```

### Q5: 如何删除项目？
**A**: 
```bash
# 删除 Pages 项目
npx wrangler pages project delete kickstarter-tracker

# 删除 D1 数据库
npx wrangler d1 delete kickstarter-tracker-db
```

---

## 📊 项目状态监控

### Cloudflare Dashboard
访问 https://dash.cloudflare.com/
- 查看 Pages 项目状态
- 查看部署历史
- 查看访问统计
- 查看 D1 数据库状态

### 日志查看
```bash
# 查看最近部署日志
npx wrangler pages deployment list --project-name kickstarter-tracker

# 查看实时日志
npx wrangler pages deployment tail --project-name kickstarter-tracker
```

---

## 🎯 下一步优化

1. **添加自定义域名**
2. **配置 CDN 缓存策略**
3. **设置定时任务自动同步数据**
4. **添加监控和告警**
5. **优化数据库查询性能**

---

## 📞 需要帮助？

- Cloudflare 文档：https://developers.cloudflare.com/pages/
- Wrangler 文档：https://developers.cloudflare.com/workers/wrangler/
- D1 文档：https://developers.cloudflare.com/d1/

---

**准备好了吗？完成上述配置后，我会开始自动部署！** 🚀
