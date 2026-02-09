#!/bin/bash

# Kickstarter Tracker - 快速部署脚本
# 此脚本会引导你完成部署的每一步

set -e

echo "============================================"
echo "   Kickstarter 追踪器 - 快速部署向导"
echo "============================================"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 检查函数
check_command() {
    if command -v $1 &> /dev/null; then
        echo -e "${GREEN}✓${NC} $1 已安装"
        return 0
    else
        echo -e "${RED}✗${NC} $1 未安装"
        return 1
    fi
}

# 步骤 1: 检查依赖
echo -e "${BLUE}步骤 1/8:${NC} 检查依赖..."
check_command "node" || { echo "请先安装 Node.js"; exit 1; }
check_command "npm" || { echo "请先安装 npm"; exit 1; }
check_command "git" || { echo "请先安装 git"; exit 1; }

# 检查 wrangler
if ! check_command "wrangler"; then
    echo -e "${YELLOW}正在安装 wrangler...${NC}"
    npm install -g wrangler
fi

echo ""

# 步骤 2: Wrangler 登录
echo -e "${BLUE}步骤 2/8:${NC} 登录 Cloudflare"
echo "这会打开浏览器，请完成登录..."
wrangler login

echo ""

# 步骤 3: 创建 D1 数据库
echo -e "${BLUE}步骤 3/8:${NC} 创建 D1 数据库"
echo "正在创建数据库 kickstarter-tracker-db..."

DB_OUTPUT=$(wrangler d1 create kickstarter-tracker-db 2>&1)
echo "$DB_OUTPUT"

# 提取 database_id
DB_ID=$(echo "$DB_OUTPUT" | grep -oP 'database_id = "\K[^"]+')

if [ -z "$DB_ID" ]; then
    echo -e "${RED}错误：无法创建数据库${NC}"
    echo "可能数据库已存在，继续下一步..."
else
    echo -e "${GREEN}✓${NC} 数据库创建成功！"
    echo "Database ID: $DB_ID"
    
    # 更新 wrangler.jsonc
    echo "正在更新 wrangler.jsonc..."
    sed -i "s/\"database_id\": \".*\"/\"database_id\": \"$DB_ID\"/" wrangler.jsonc
    echo -e "${GREEN}✓${NC} 配置文件已更新"
fi

echo ""

# 步骤 4: 应用数据库迁移
echo -e "${BLUE}步骤 4/8:${NC} 应用数据库迁移"
wrangler d1 migrations apply kickstarter-tracker-db

echo ""

# 步骤 5: 填充初始数据
echo -e "${BLUE}步骤 5/8:${NC} 填充初始数据"
wrangler d1 execute kickstarter-tracker-db --file=./seed.sql

echo ""

# 步骤 6: 构建项目
echo -e "${BLUE}步骤 6/8:${NC} 构建项目"
npm run build

echo ""

# 步骤 7: 创建 Pages 项目
echo -e "${BLUE}步骤 7/8:${NC} 创建 Cloudflare Pages 项目"
wrangler pages project create kickstarter-tracker --production-branch main || true

echo ""

# 步骤 8: 部署
echo -e "${BLUE}步骤 8/8:${NC} 部署到 Cloudflare Pages"
DEPLOY_OUTPUT=$(wrangler pages deploy dist --project-name kickstarter-tracker)
echo "$DEPLOY_OUTPUT"

# 提取部署 URL
DEPLOY_URL=$(echo "$DEPLOY_OUTPUT" | grep -oP 'https://[a-zA-Z0-9\-\.]+\.pages\.dev' | head -1)

echo ""
echo "============================================"
echo -e "${GREEN}   🎉 部署成功！${NC}"
echo "============================================"
echo ""
echo -e "生产环境 URL: ${BLUE}$DEPLOY_URL${NC}"
echo ""
echo "接下来的步骤："
echo ""
echo "1. 📱 访问你的应用："
echo "   $DEPLOY_URL"
echo ""
echo "2. 🔑 配置 RapidAPI Key（可选，用于真实数据）："
echo "   wrangler pages secret put RAPIDAPI_KEY --project-name kickstarter-tracker"
echo ""
echo "3. 📊 查看数据库："
echo "   wrangler d1 execute kickstarter-tracker-db --command=\"SELECT COUNT(*) FROM projects\""
echo ""
echo "4. 📝 查看部署历史："
echo "   wrangler pages deployment list --project-name kickstarter-tracker"
echo ""
echo "5. 🔄 更新应用："
echo "   npm run build && wrangler pages deploy dist --project-name kickstarter-tracker"
echo ""
echo "============================================"
echo ""

# 询问是否配置 RapidAPI Key
echo -e "${YELLOW}提示：${NC}如果你已经有 RapidAPI Key，现在可以配置"
read -p "是否现在配置 RapidAPI Key？(y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    wrangler pages secret put RAPIDAPI_KEY --project-name kickstarter-tracker
    echo -e "${GREEN}✓${NC} RapidAPI Key 配置完成！"
    echo "现在你可以使用'同步数据'功能抓取真实的 Kickstarter 数据"
else
    echo "你可以稍后使用以下命令配置："
    echo "wrangler pages secret put RAPIDAPI_KEY --project-name kickstarter-tracker"
fi

echo ""
echo -e "${GREEN}全部完成！享受你的 Kickstarter 追踪器吧！${NC} 🚀"
