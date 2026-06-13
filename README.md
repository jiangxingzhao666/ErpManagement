# 超市进销存管理系统 (ERP Management System)

ASP.NET Web Forms + PostgreSQL + Entity Framework 6 实现的超市进销存管理系统。

## 技术栈

| 层级 | 技术 |
|---|---|
| 前端 | ASP.NET Web Forms, Bootstrap CSS, ECharts 5 |
| 后端 | .NET Framework 4.8.1, C# |
| ORM | Entity Framework 6 + Npgsql |
| 数据库 | PostgreSQL |
| 认证 | Session + Token (30分钟持久登录) |
| 报表 | ECharts (网页) + GDI+ 图表 (Excel导出) |

## 功能模块

### 基础数据
- 商品分类管理 (CRUD)
- 供应商管理 (CRUD + 搜索)
- 客户管理 (CRUD + 搜索 + 会员等级)
- 商品管理 (CRUD + 搜索 + 分类筛选 + 库存预警 + 软删除)

### 业务管理
- 购物车 (后端 GridView 渲染, +/-/删除/结算)
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
│   ├── Default.aspx         # 首页 (商品列表 + 统计卡片)
│   ├── Cart.aspx            # 购物车 (后端渲染)
│   ├── Login.aspx           # 登录页
│   ├── Categories.aspx      # 分类管理
│   ├── Suppliers.aspx       # 供应商管理
│   ├── Customers.aspx       # 客户管理
│   ├── Products.aspx        # 商品管理 (含编辑/删除)
│   ├── Purchases.aspx       # 进货管理
│   ├── Sales.aspx           # 销售管理
│   ├── StockAlert.aspx      # 库存预警
│   ├── Reports.aspx         # ECharts 报表 + Excel 导出
│   ├── Users.aspx           # 用户管理
│   └── Test.aspx            # 数据库 CRUD 测试页
├── Content/
│   ├── site.css             # 全局样式
│   └── ...
├── Web.config               # 数据库连接 + UTF-8 配置
├── Global.asax              # Token 过期清理
├── 期末设计.md              # 原设计文档
├── 软件文档.md              # 软件文档
├── 测试数据文档.md           # 测试数据说明
└── seed_data.sql            # 测试数据 SQL 脚本
```

## 数据库

9 张表：categories, suppliers, products, customers, purchaseorders, purchaseorderitems, salesorders, salesorderitems, users

所有表含 `createdat` / `updatedat`，users 额外含 `lastloginat`。

## 权限体系

| 角色 | 可访问页面 | 数据可见范围 |
|---|---|---|
| 管理员 | 全部页面 | 含软删除/已禁用数据 |
| 店长 | 除用户管理外全部 | 仅活跃数据，只能添加操作员 |
| 操作员 | 商品列表 + 购物车 | 仅活跃数据 |

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
4. IIS / IIS Express 启动项目
5. 访问 `http://localhost:端口号/`

## 架构原则

- 数据库纯存储，Service 层承载全部业务逻辑
- 页面层仅调用 Service，不允许直接访问 DAL (DbContext)
- 所有表操作通过 Service 方法完成
