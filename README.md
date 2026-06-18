# 超市进销存管理系统 (ERP Management System)

ASP.NET Web Forms + PostgreSQL + Entity Framework 6 实现的超市进销存管理系统。

## 技术栈

| 层级 | 技术 |
|---|---|
| 前端 | ASP.NET Web Forms, 自定义 CSS (CSS Variables + BEM), ECharts 5 |
| 后端 | .NET Framework 4.8.1, C# |
| ORM | Entity Framework 6 + Npgsql |
| 数据库 | PostgreSQL 9.x+ |
| 认证 | Session + Token (30分钟持久登录, SHA256加盐哈希) |
| 报表 | ECharts (网页) + GDI+ 图表 (Excel 导出, 5 Sheet) |

## 功能模块

### 前台
- 超市品牌介绍 (Hero + 特色卡片 + 服务亮点)
- 商品浏览 (卡片网格 + 搜索 + 25 种 SVG 商品图片)
- 购物车结算 (无需登录, Session 存储)
- 匿名快递填写 (无需登录的 Public 表单)

### 基础数据
- 商品分类管理 (CRUD)
- 供应商管理 (CRUD + 搜索)
- 客户管理 (CRUD + 搜索 + 会员等级 + 累计消费)
- 商品管理 (CRUD + 搜索 + 分类筛选 + 图片上传 SVG/JPG/PNG/GIF + 库存预警 + 软删除)

### 业务管理
- 购物车 (卡片网格选择 + 客户/支付方式/优惠 + 结算生成销售单)
- 进货管理 (新建进货单 + 动态商品行 + 确认入库 + 取消 → 库存增加)
- 销售管理 (新建销售单 + 库存自动扣减 + 客户累计消费更新 + 会员自动升级)
- 快递管理 (自动生成 KD 单号 + 7 家快递公司 + 待发货→运输中→已签收 状态流转)

### 统计报表
- 库存预警列表 (库存 ≤ 最低库存)
- 销售报表 (ECharts: 月度趋势 / 分类占比 / 商品排行 / 客户排行)
- Excel 导出 (含 GDI+ 图表图片: 销售明细 / 月度 / 商品 / 客户 / 分类 共 5 Sheet)

### 系统管理
- 用户管理 (CRUD + 软删除 + 店长权限限制)
- 三级角色权限 (管理员 / 店长 / 操作员)
- Token 持久登录 (30分钟过期, Cookie+Session+Application 三重存储)

## 项目结构

```
ErpManagement1/
├── App_Code/
│   ├── DAL/                    # ErpDbContext (10 个 DbSet)
│   ├── Entities/               # 10 个实体类
│   ├── EntitiesMaps/           # 10 个 Fluent API 映射配置
│   ├── Helpers/                # 6 个工具类 (Auth/Cart/Sidebar/Token/Hash/Xlsx)
│   └── Services/               # 8 个业务逻辑 Service
├── Views/                      # 21 个页面, 按功能分 12 个子目录
│   ├── Login.aspx              # 登录 (支持 ReturnUrl)
│   ├── Store/Default.aspx      # 前台超市页面 (无需登录)
│   ├── Products/               # 商品 (Default + Edit)
│   ├── Categories/             # 分类 (Default + Edit)
│   ├── Suppliers/              # 供应商 (Default + Edit)
│   ├── Customers/              # 客户 (Default + Edit)
│   ├── Cart/Default.aspx       # 后台购物车
│   ├── Purchases/              # 进货 (Default + Create + Detail)
│   ├── Sales/                  # 销售 (Default + Create + Detail)
│   ├── Shipments/              # 快递 (Default + Edit + Public)
│   ├── Stock/Default.aspx      # 库存预警
│   ├── Reports/Default.aspx    # 统计报表
│   └── Users/                  # 用户 (Default + Edit)
├── Content/
│   ├── site.css                # 全局样式 (CSS Variables, 357行)
│   └── images/products/        # 25 个 SVG 商品图片
├── Web.config                  # PostgreSQL 连接 + UTF-8 配置
├── Global.asax                 # Token 过期清理 (每10请求)
├── Default.aspx                # 根入口 → 前台页面
├── seed_data.sql               # 种子数据 (7段)
├── update_images.sql           # SP001-SP010 图片更新
├── update_images2.sql          # SP011-SP025 图片更新
├── create_shipments.sql        # 快递表 DDL + 数据
├── 网站设计说明书.md             # 设计说明书 v3.0
├── 软件文档.md                  # 软件文档
└── 测试数据文档.md               # 测试数据说明
```

## 数据库 (10 张表)

| 表 | 说明 | 种子数据 |
|---|---|:---:|
| categories | 商品分类 | 5 |
| suppliers | 供应商 | 3 |
| products | 商品 (含 imagepath 图片) | 10+15 |
| customers | 客户 (含 memberLevel) | 3 |
| purchaseorders | 进货单主表 (JH 单号) | 3 |
| purchaseorderitems | 进货单明细 | 5 |
| salesorders | 销售单主表 (XS 单号) | 3 |
| salesorderitems | 销售单明细 | 5 |
| users | 系统用户 | 3 |
| shipments | 快递单 (KD 单号) | 0-2 |

## 权限体系

| 角色 | 可访问页面 | 数据可见范围 |
|---|---|---|
| 管理员 | 全部 21 个页面 | 含软删除/已禁用数据 |
| 店长 | 全部页面（不可编辑管理员，仅可创建操作员） | 仅活跃数据 |
| 操作员 | 仅购物车 + 快递页面 | 仅活跃数据 |
| 未登录 | Store 前台 + Login + 快递 Public | - |

## 测试账号

| 用户名 | 密码 | 角色 |
|---|---|---|
| admin | admin123 | 管理员 |
| manager | 123456 | 店长 |
| staff | 123456 | 操作员 |

## 运行

1. 安装 PostgreSQL，创建 `aspnet` 数据库
2. 修改 `Web.config` 连接字符串
3. 执行 `seed_data.sql` 导入测试数据
4. 执行 `create_shipments.sql` 创建快递表
5. 按需执行 `update_images.sql` / `update_images2.sql`
6. IIS / IIS Express 启动 → `http://localhost/`

## 架构原则

- 数据库纯存储，Service 层承载全部业务逻辑
- 页面层仅调用 Service，禁止直接访问 DAL
- 所有表操作通过 Service 方法完成
