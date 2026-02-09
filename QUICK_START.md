# 🚀 快速开始指南

欢迎使用 **Kickstarter 电子产品众筹追踪器**！

## 📦 项目已准备就绪

所有代码已经开发完成并提交到 Git。你现在可以：
1. ✅ 部署演示版本（使用 15 条演示数据）
2. ✅ 配置 RapidAPI 启用真实数据（可选）

---

## 🎯 两种部署方式

### 方式 A: 一键自动部署（推荐）⭐

**前提条件**：
1. 在 Cloudflare 注册账号：https://dash.cloudflare.com/sign-up
2. 创建并配置 API Token（详见下文）

**执行命令**：
```bash
cd /home/user/webapp
./deploy.sh
```

脚本会自动完成：
- ✅ 登录 Cloudflare
- ✅ 创建 D1 数据库
- ✅ 应用数据库迁移
- ✅ 填充演示数据
- ✅ 构建项目
- ✅ 创建 Pages 项目
- ✅ 部署到生产环境
- ✅ 提供部署 URL

**预计时间**：5-10 分钟

---

### 方式 B: 通过界面配置（简单）

**步骤**：
1. 点击左侧 **Deploy** 标签页
2. 配置 Cloudflare API Token
3. 我会自动执行部署流程

---

## 🔑 Cloudflare API Token 快速创建

### 方法 1: 使用模板（最快）
1. 访问：https://dash.cloudflare.com/profile/api-tokens
2. 点击 "Create Token"
3. 选择 **"Edit Cloudflare Workers"** 模板
4. 点击 "Continue to summary"
5. 点击 "Create Token"
6. **复制 Token**

### 方法 2: 自定义权限
如果模板不适用，创建自定义 Token 并设置：

**权限**：
- Account - Cloudflare Pages - Edit
- Account - D1 - Edit  
- Zone - Workers Routes - Edit

**Zone Resources**: Include - All zones

---

## 📱 部署后访问

部署成功后，你会得到一个 URL：
```
https://kickstarter-tracker.pages.dev
```

或者类似的随机 URL。你可以立即访问和使用！

---

## 🔄 启用真实数据（可选）

如果你想要抓取真实的 Kickstarter 数据：

### 步骤 1: 注册 RapidAPI
详细教程：查看 `RAPIDAPI_REGISTRATION_GUIDE.md`

**快速步骤**：
1. 访问：https://rapidapi.com/
2. 注册账号（支持 Google/GitHub 登录）
3. 订阅：https://rapidapi.com/UnitedAPI/api/kickstarter2
4. 选择 **Basic 免费计划**（100次/月）
5. 复制你的 API Key

### 步骤 2: 配置到生产环境
```bash
npx wrangler pages secret put RAPIDAPI_KEY --project-name kickstarter-tracker
# 粘贴你的 API Key 并按 Enter
```

### 步骤 3: 测试数据同步
1. 访问你的应用
2. 点击顶部"同步数据"按钮
3. 选择配置并开始同步
4. 享受真实的 Kickstarter 数据！

---

## 📚 完整文档

- `README.md` - 项目概述和功能说明
- `DEPLOYMENT_GUIDE.md` - 详细部署指南
- `RAPIDAPI_REGISTRATION_GUIDE.md` - RapidAPI 注册教程
- `KICKSTARTER_API_GUIDE.md` - API 接入方案对比

---

## ⚡ 快速命令参考

### 本地开发
```bash
npm run build              # 构建项目
pm2 start ecosystem.config.cjs  # 启动本地服务
curl http://localhost:3000/api/stats/overview  # 测试 API
```

### 数据库操作
```bash
npm run db:migrate:local   # 应用本地迁移
npm run db:seed           # 填充演示数据
npm run db:reset          # 重置数据库
```

### 生产部署
```bash
./deploy.sh               # 一键部署（推荐）
npm run deploy:prod       # 手动部署
```

### Cloudflare 管理
```bash
wrangler pages deployment list --project-name kickstarter-tracker  # 查看部署历史
wrangler d1 execute kickstarter-tracker-db --command="SELECT * FROM projects LIMIT 5"  # 查询数据库
wrangler pages secret list --project-name kickstarter-tracker  # 查看环境变量
```

---

## ❓ 常见问题

### Q: 必须配置 RapidAPI 吗？
**A**: 不是必须的。应用包含 15 条高质量演示数据，功能完全可用。RapidAPI 只在你需要真实数据时才配置。

### Q: 部署需要信用卡吗？
**A**: Cloudflare Pages 免费计划不需要信用卡。RapidAPI Basic 计划也是免费的。

### Q: 如何更新应用？
**A**: 修改代码后执行：
```bash
git add . && git commit -m "Update"
npm run build
npx wrangler pages deploy dist --project-name kickstarter-tracker
```

### Q: 部署失败怎么办？
**A**: 
1. 检查 Cloudflare API Token 权限
2. 确保已登录：`wrangler whoami`
3. 查看错误日志
4. 参考 `DEPLOYMENT_GUIDE.md` 故障排除部分

### Q: 如何查看应用日志？
**A**: 
```bash
wrangler pages deployment tail --project-name kickstarter-tracker
```

---

## 🎯 现在就开始！

### 选项 1: 如果你已有 Cloudflare 账号
```bash
cd /home/user/webapp
./deploy.sh
```

### 选项 2: 如果你还没有 Cloudflare 账号
1. 访问：https://dash.cloudflare.com/sign-up
2. 注册账号（免费）
3. 创建 API Token
4. 返回执行 `./deploy.sh`

### 选项 3: 通过界面配置
- 点击左侧 **Deploy** 标签页
- 按照提示配置

---

## 💡 提示

- 部署到 Cloudflare Pages 是**完全免费**的
- 演示数据已经很完整，可以直接演示
- RapidAPI 有免费配额，无需付费
- 随时可以添加真实数据功能

---

## 🌟 项目特色

✅ 完全无服务器架构  
✅ 全球 CDN 加速  
✅ 自动 HTTPS  
✅ 免费托管  
✅ 演示数据内置  
✅ 真实数据可选  
✅ 响应式设计  
✅ 实时数据同步  

---

**准备好了吗？开始部署你的 Kickstarter 追踪器！** 🚀

有任何问题随时告诉我！
