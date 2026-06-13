# 超市进销存管理系统 (ERP Management System)

ASP.NET Web Forms + PostgreSQL + Entity Framework 6 实现的超市进销存管理系统。

## 技术栈

| 层级 | 技术 |
|---|---|
| 前端 | ASP.NET Web Forms, 自定义 CSS, ECharts 5 |
| 后端 | .NET Framework 4.8.1, C# |
| ORM | Entity Framework 6 + Npgsql |
| 数据库 | PostgreSQL |
| 认证 | Session + Token (30分钟持久登录) |
| 报表 | ECharts (网页) + GDI+ 图表 (Excel导出) |

## 功能模块

### 前台
- 超市介绍页 (Hero + 特色卡片 + 商品浏览 + 购物车结算)
- 无需登录即可浏览商品和加入购物车

### 基础数据
- 商品分类管理 (CRUD)
- 供应商管理 (CRUD + 搜索)
- 客户管理 (CRUD + 搜索 + 会员等级)
- 商品管理 (CRUD + 搜索 + 分类筛选 + 库存预警 + 软删除 + **图片上传**)

### 业务管理
- 购物车 (卡片网格选择商品 + +/-/删除/结算)
- 进货管理 (新建进货单 + 确认入库 + 取消)
- 销售管理 (新建销售单 + 库存扣减 + 会员自动升级)

### 统计报表
- 库存预警列表
- 销售报表 (ECharts: 月度趋势、分类占比、商品排行、客户排行)
- Excel 导出 (含图表图片: 销售明细/月度/商品/客户/分类 5 Sheet)

### 系统管理
- 用户管理 (CRUD + 软删除)
- 三级角色权限 (管理员 / 店长 / 操作员)
- Token 持久登录 (30分钟过期, Cookie+Session+Application 三重存储)

## 项目结构

```
ErpManagement1/
├── App_Code/
│   ├── DAL/                 # ErpDbContext (Entity Framework)
│   ├── Entities/            # 9 个实体类
│   ├── EntitiesMaps/        # Fluent API 映射
│   ├── Helpers/             # 工具类 (Auth, Cart, Sidebar, Token, Hash, Xlsx)
│   └── Services/            # 业务逻辑层 (7 个 Service)
├── Views/
│   ├── Login.aspx           # 登录页
│   ├── Test.aspx            # 数据库 CRUD 测试页
│   ├── Store/               # 前台超市页面
│   │   └── Default.aspx
│   ├── Products/            # 商品管理
│   │   ├── Default.aspx     # 商品列表 + 统计卡片
│   │   └── Edit.aspx        # 新增/编辑商品(含图片上传)
│   ├── Categories/          # 分类管理
│   │   ├── Default.aspx     # 分类列表
│   │   └── Edit.aspx        # 新增/编辑分类
│   ├── Suppliers/           # 供应商管理
│   │   ├── Default.aspx
│   │   └── Edit.aspx
│   ├── Customers/           # 客户管理
│   │   ├── Default.aspx
│   │   └── Edit.aspx
│   ├── Purchases/           # 进货管理
│   │   ├── Default.aspx     # 进货单列表
│   │   ├── Create.aspx      # 新建进货单
│   │   └── Detail.aspx      # 进货单详情
│   ├── Sales/               # 销售管理
│   │   ├── Default.aspx     # 销售单列表
│   │   ├── Create.aspx      # 新建销售单
│   │   └── Detail.aspx      # 销售单详情
│   ├── Reports/             # 统计报表
│   │   └── Default.aspx
│   ├── Stock/               # 库存预警
│   │   └── Default.aspx
│   ├── Users/               # 用户管理
│   │   ├── Default.aspx
│   │   └── Edit.aspx
│   └── Cart/                # 后台购物车
│       └── Default.aspx
├── Content/
│   ├── site.css             # 全局样式
│   └── images/products/     # 商品图片 (SVG)
├── Web.config               # 数据库连接 + UTF-8 配置
├── Global.asax              # Token 过期清理
├── seed_data.sql            # 测试数据 SQL 脚本
├── update_images.sql        # 商品图片路径更新脚本
├── 期末设计.md              # 原设计文档
├── 软件文档.md              # 软件文档
└── 测试数据文档.md           # 测试数据说明
```

## 数据库

9 张表：categories, suppliers, products, customers, purchaseorders, purchaseorderitems, salesorders, salesorderitems, users

products 表含 `imagepath` 字段，支持 jpg/png/gif/svg 格式图片。

所有表含 `createdat` / `updatedat`，users 额外含 `lastloginat`。

## 权限体系

| 角色 | 可访问页面 | 数据可见范围 |
|---|---|---|
| 管理员 | 全部页面 | 含软删除/已禁用数据 |
| 店长 | 全部页面（不可编辑管理员用户） | 仅活跃数据 |
| 操作员 | 仅购物车 | 仅活跃数据 |

## 测试账号

| 用户名 | 密码 | 角色 |
|---|---|---|
| admin | admin123 | 管理员 |
| manager | 123456 | 店长 |
| staff | 123456 | 操作员 |

## 运行

1. 安装 PostgreSQL，创建 `aspnet` 数据库
2. 修改 `Web.config` 中连接字符串
3. 执行 `seed_data.sql` 导入测试数据
4. 执行 `update_images.sql` 更新商品图片路径(如数据库无图片数据)
5. IIS / IIS Express 启动项目
6. 访问 `http://localhost:端口号/` → 进入前台超市页面
7. 点击"登录后台"进入管理后台

## 架构原则

- 数据库纯存储，Service 层承载全部业务逻辑
- 页面层仅调用 Service，不允许直接访问 DAL (DbContext)
- 所有表操作通过 Service 方法完成
