#!/bin/bash

# ===========================================
# Kickstarter 追踪器 - 简易部署脚本
# 使用你的 API Token 自动部署
# ===========================================

echo "🚀 开始部署 Kickstarter 追踪器..."
echo ""

# 设置你的 API Token
export CLOUDFLARE_API_TOKEN="9AjogS1ztPYUh4Gydlg7BdLOsR1mFEHAt5ryu56"

# 验证 Token 是否有效
echo "📋 步骤 1/7: 验证 Cloudflare 连接..."
npx wrangler whoami

if [ $? -ne 0 ]; then
    echo "❌ Token 验证失败，请检查 Token 是否正确"
    exit 1
fi

echo "✅ Token 验证成功！"
echo ""

# 创建 D1 数据库
echo "📋 步骤 2/7: 创建 D1 数据库..."
DB_OUTPUT=$(npx wrangler d1 create kickstarter-tracker-db 2>&1)
echo "$DB_OUTPUT"

# 提取 database_id
DB_ID=$(echo "$DB_OUTPUT" | grep -oP 'database_id = "\K[^"]+' | head -1)

if [ ! -z "$DB_ID" ]; then
    echo "✅ 数据库创建成功！Database ID: $DB_ID"
    
    # 更新配置文件
    echo "正在更新配置文件..."
    sed -i "s/\"database_id\": \".*\"/\"database_id\": \"$DB_ID\"/" wrangler.jsonc
else
    echo "⚠️  数据库可能已存在，继续部署..."
fi

echo ""

# 应用数据库迁移
echo "📋 步骤 3/7: 应用数据库迁移..."
npx wrangler d1 migrations apply kickstarter-tracker-db --remote

echo ""

# 填充初始数据
echo "📋 步骤 4/7: 填充演示数据..."
npx wrangler d1 execute kickstarter-tracker-db --remote --file=./seed.sql

echo ""

# 构建项目
echo "📋 步骤 5/7: 构建项目..."
npm run build

echo ""

# 创建 Pages 项目
echo "📋 步骤 6/7: 创建 Cloudflare Pages 项目..."
npx wrangler pages project create kickstarter-tracker --production-branch main 2>/dev/null || echo "项目可能已存在，继续..."

echo ""

# 部署
echo "📋 步骤 7/7: 部署到 Cloudflare Pages..."
DEPLOY_OUTPUT=$(npx wrangler pages deploy dist --project-name kickstarter-tracker 2>&1)
echo "$DEPLOY_OUTPUT"

# 提取部署 URL
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
echo "📝 接下来可以做的："
echo "1. 访问你的应用查看效果"
echo "2. 配置 RapidAPI Key 启用真实数据："
echo "   npx wrangler pages secret put RAPIDAPI_KEY --project-name kickstarter-tracker"
echo ""
echo "=========================================="
