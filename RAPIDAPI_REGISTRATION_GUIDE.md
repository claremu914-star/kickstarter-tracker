# RapidAPI 注册和 Kickstarter API 订阅指南

## 📝 完整注册流程（5-10分钟）

### 第一步：注册 RapidAPI 账号

1. **打开浏览器访问**：
   ```
   https://rapidapi.com/
   ```

2. **点击右上角 "Sign Up"（注册）按钮**

3. **选择注册方式（任选其一）**：
   - 🔷 **Google 账号登录**（推荐，最快）
   - 🔷 **GitHub 账号登录**（推荐）
   - 📧 **邮箱注册**：
     - 输入邮箱地址
     - 设置密码
     - 填写用户名

4. **验证邮箱**（如果使用邮箱注册）：
   - 检查邮箱收件箱
   - 点击验证链接
   - 返回 RapidAPI 网站

---

### 第二步：订阅 Kickstarter API

1. **访问 Kickstarter API 页面**：
   ```
   https://rapidapi.com/UnitedAPI/api/kickstarter2
   ```

2. **浏览 API 信息**：
   - 查看 API 功能描述
   - 了解端点和参数
   - 查看代码示例

3. **选择订阅计划**：
   
   点击页面右侧的 **"Subscribe to Test"** 或 **"Pricing"** 按钮
   
   **计划对比**：
   
   | 计划 | 价格 | 请求次数/月 | 推荐场景 |
   |------|------|------------|----------|
   | **Basic** | **免费** ✅ | 100次 | 测试、演示、低频使用 |
   | Pro | $5/月 | 1,000次 | 小规模生产环境 |
   | Ultra | $15/月 | 10,000次 | 大规模生产环境 |
   | Mega | $25/月 | 50,000次 | 企业级使用 |

4. **订阅 Basic 计划**（推荐）：
   - 点击 **"Subscribe"** 按钮（在 Basic 计划下）
   - 确认订阅（免费，无需支付信息）
   - 等待几秒钟完成订阅

---

### 第三步：获取 API Key

1. **订阅成功后，页面会自动跳转到 API 端点页面**

2. **找到 API Key**：
   - 在页面中间偏上位置
   - 有一个 **"Code Snippets"** 部分
   - 选择任意编程语言（如 JavaScript - Fetch）
   - 在代码示例中找到这一行：
     ```javascript
     'X-RapidAPI-Key': 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
     ```

3. **复制 API Key**：
   - 点击 Key 右侧的复制按钮 📋
   - 或者手动选中并复制整个 Key 字符串
   - **Key 通常是 50 个字符左右的长字符串**

4. **保存 API Key**：
   - 暂时保存到记事本或安全的地方
   - **不要分享给他人**
   - 稍后你需要提供给我配置

---

### 第四步：测试 API（可选）

在 RapidAPI 页面可以直接测试：

1. **选择一个端点**（如 "Search Projects"）
2. **填写必需参数**（如 query: "electronics"）
3. **点击 "Test Endpoint" 按钮**
4. **查看返回结果**

如果返回数据正常，说明 API Key 可用！

---

## 🎯 完成后的下一步

### 将 API Key 提供给我

获取 API Key 后，有两种方式：

**方式 1：直接告诉我**
```
我的 RapidAPI Key 是: [你的Key]
```

**方式 2：我来设置配置命令**
你只需要在终端执行我提供的命令即可

---

## ❓ 常见问题

### Q1: 注册需要信用卡吗？
**A**: Basic 免费计划**不需要**信用卡，直接订阅即可。

### Q2: 100次请求够用吗？
**A**: 
- 每次同步约消耗 1-3 次请求（取决于页数）
- 每天同步 1 次 = 约 30-90 次/月
- **足够测试和演示使用**
- 如需更多，可升级到 Pro 计划

### Q3: 如何查看剩余请求次数？
**A**: 
- 登录 RapidAPI
- 进入 Dashboard
- 查看 "My Subscriptions"
- 可以看到已使用和剩余次数

### Q4: API Key 在哪里查看？
**A**: 
- 访问 https://rapidapi.com/UnitedAPI/api/kickstarter2
- 页面中间的 "Code Snippets" 部分
- 或者访问 https://rapidapi.com/developer/security
- 在 "Application Keys" 中查看

### Q5: 不小心泄露了 API Key 怎么办？
**A**: 
- 访问 https://rapidapi.com/developer/security
- 删除旧的 Key
- 创建新的 Key
- 更新到项目配置中

---

## 📱 移动端注册

如果你使用手机：
1. 用手机浏览器访问 RapidAPI
2. 步骤与电脑端相同
3. 建议使用 Google/GitHub 登录（更方便）

---

## 🔒 安全提示

1. ✅ **不要将 API Key 提交到 Git**
2. ✅ **不要在公开场合分享 Key**
3. ✅ **定期检查使用情况**
4. ✅ **如有异常立即重置 Key**

---

## 💡 推荐做法

1. **立即注册并获取 Basic 免费计划**
2. **测试几次数据同步**
3. **观察数据质量和请求消耗**
4. **根据实际需求决定是否升级**

---

## ⏱️ 预计时间

- 注册账号：2-3 分钟
- 订阅 API：1 分钟
- 获取 Key：30 秒
- **总计：约 5 分钟**

---

## 📞 获取帮助

如果遇到问题：
1. 查看 RapidAPI 帮助中心：https://docs.rapidapi.com/
2. 联系 RapidAPI 支持
3. 或者告诉我具体问题，我来协助解决

---

**现在你可以开始注册了！我同时会开始部署演示版本。** 🚀
