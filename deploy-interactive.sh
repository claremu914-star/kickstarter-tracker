#!/bin/bash

# ===========================================
# Kickstarter 追踪器 - 交互式部署脚本
# 使用 wrangler login 自动登录
# ===========================================

echo "🚀 开始部署 Kickstarter 追踪器..."
echo ""
echo "⚠️  注意：这个脚本需要 Cloudflare API Token"
echo ""
echo "由于 wrangler login 需要浏览器交互，我们改用 API Token 方式"
echo ""
echo "请按照以下步骤操作："
echo ""
echo "1. 确保你的 API Token 是有效的"
echo "2. Token 格式应该类似: xxxx-xxxxxxxxxxxxxxxxxxxxxxx"
echo "3. 如果 Token 无效，请重新创建"
echo ""

# 检查 Token 是否配置
if [ -z "$CLOUDFLARE_API_TOKEN" ]; then
    echo "❌ 错误：CLOUDFLARE_API_TOKEN 环境变量未设置"
    echo ""
    echo "请执行以下命令设置 Token："
    echo "export CLOUDFLARE_API_TOKEN='你的Token'"
    echo ""
    exit 1
fi

echo "✅ 检测到 API Token"
echo ""

# 验证 Token
echo "📋 步骤 1/7: 验证 Cloudflare 连接..."
WHOAMI_OUTPUT=$(npx wrangler whoami 2>&1)

if echo "$WHOAMI_OUTPUT" | grep -q "ERROR"; then
    echo "❌ Token 验证失败"
    echo "$WHOAMI_OUTPUT"
    echo ""
    echo "可能的原因："
    echo "1. Token 格式不正确"
    echo "2. Token 权限不足"
    echo "3. Token 已过期"
    echo ""
    echo "建议解决方案："
    echo "1. 访问 https://dash.cloudflare.com/profile/api-tokens"
    echo "2. 重新创建 Token"
    echo "3. 确保包含以下权限："
    echo "   - Account - Cloudflare Pages - Edit"
    echo "   - Account - D1 - Edit"
    echo ""
    exit 1
fi

echo "$WHOAMI_OUTPUT"
echo "✅ Token 验证成功！"
echo ""

# 继续部署流程...
echo "📋 步骤 2/7: 创建 D1 数据库..."
DB_OUTPUT=$(npx wrangler d1 create kickstarter-tracker-db 2>&1)
echo "$DB_OUTPUT"

DB_ID=$(echo "$DB_OUTPUT" | grep -oP 'database_id = "\K[^"]+' | head -1)

if [ ! -z "$DB_ID" ]; then
    echo "✅ 数据库创建成功！Database ID: $DB_ID"
    sed -i "s/\"database_id\": \".*\"/\"database_id\": \"$DB_ID\"/" wrangler.jsonc
else
    echo "⚠️  数据库可能已存在，继续部署..."
fi

echo ""
echo "📋 步骤 3/7: 应用数据库迁移..."
npx wrangler d1 migrations apply kickstarter-tracker-db --remote

echo ""
echo "📋 步骤 4/7: 填充演示数据..."
npx wrangler d1 execute kickstarter-tracker-db --remote --file=./seed.sql

echo ""
echo "📋 步骤 5/7: 构建项目..."
npm run build

echo ""
echo "📋 步骤 6/7: 创建 Cloudflare Pages 项目..."
npx wrangler pages project create kickstarter-tracker --production-branch main 2>/dev/null || echo "项目可能已存在，继续..."

echo ""
echo "📋 步骤 7/7: 部署到 Cloudflare Pages..."
DEPLOY_OUTPUT=$(npx wrangler pages deploy dist --project-name kickstarter-tracker 2>&1)
echo "$DEPLOY_OUTPUT"

DEPLOY_URL=$(echo "$DEPLOY_OUTPUT" | grep -oP 'https://[a-zA-Z0-9\-\.]+\.pages\.dev' | head -1)

echo ""
echo "=========================================="
echo "🎉 部署完成！"
echo "=========================================="
echo ""

if [ ! -z "$DEPLOY_URL" ]; then
    echo "🌐 你的应用已上线："
    echo "   $DEPLOY_URL"
else
    echo "🌐 请查看上方输出中的部署 URL"
fi

echo ""
echo "=========================================="
