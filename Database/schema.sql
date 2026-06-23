-- ============================================================
-- ERP管理系统 - 数据库表结构 (DDL)
-- PostgreSQL
-- ============================================================

-- ----------------------------
-- 1. 商品分类
-- ----------------------------
CREATE TABLE categories (
	id SERIAL NOT NULL,
	name VARCHAR(100) NOT NULL,
	description TEXT NULL,
	createdat TIMESTAMP DEFAULT NOW() NOT NULL,
	updatedat TIMESTAMP NULL,
	CONSTRAINT categories_name_key UNIQUE (name),
	CONSTRAINT categories_pkey PRIMARY KEY (id)
);

-- ----------------------------
-- 2. 客户
-- ----------------------------
CREATE TABLE customers (
	id SERIAL NOT NULL,
	name VARCHAR(100) NOT NULL,
	phone VARCHAR(30) NULL,
	email VARCHAR(100) NULL,
	address VARCHAR(500) NULL,
	memberlevel VARCHAR(20) DEFAULT '普通' NULL,
	totalspent NUMERIC(12, 2) DEFAULT 0 NULL,
	createdat TIMESTAMP DEFAULT NOW() NOT NULL,
	updatedat TIMESTAMP NULL,
	CONSTRAINT customers_pkey PRIMARY KEY (id)
);

-- ----------------------------
-- 3. 供应商
-- ----------------------------
CREATE TABLE suppliers (
	id SERIAL NOT NULL,
	name VARCHAR(200) NOT NULL,
	contactperson VARCHAR(50) NULL,
	phone VARCHAR(30) NULL,
	email VARCHAR(100) NULL,
	address VARCHAR(500) NULL,
	remark TEXT NULL,
	createdat TIMESTAMP DEFAULT NOW() NOT NULL,
	updatedat TIMESTAMP NULL,
	CONSTRAINT suppliers_pkey PRIMARY KEY (id)
);

-- ----------------------------
-- 4. 用户
-- ----------------------------
CREATE TABLE users (
	id SERIAL NOT NULL,
	username VARCHAR(50) NOT NULL,
	passwordhash VARCHAR(200) NOT NULL,
	displayname VARCHAR(50) NOT NULL,
	role VARCHAR(30) DEFAULT '操作员' NOT NULL,
	isactive BOOL DEFAULT true NOT NULL,
	lastloginat TIMESTAMP NULL,
	createdat TIMESTAMP DEFAULT NOW() NOT NULL,
	updatedat TIMESTAMP NULL,
	CONSTRAINT users_pkey PRIMARY KEY (id),
	CONSTRAINT users_username_key UNIQUE (username)
);

-- ----------------------------
-- 5. 商品
-- ----------------------------
CREATE TABLE products (
	id SERIAL NOT NULL,
	code VARCHAR(50) NOT NULL,
	name VARCHAR(200) NOT NULL,
	categoryid INT4 NOT NULL,
	supplierid INT4 NULL,
	unit VARCHAR(20) DEFAULT '个' NOT NULL,
	purchaseprice NUMERIC(10, 2) DEFAULT 0 NOT NULL,
	sellingprice NUMERIC(10, 2) DEFAULT 0 NOT NULL,
	stockquantity INT4 DEFAULT 0 NOT NULL,
	minstock INT4 DEFAULT 10 NOT NULL,
	imagepath VARCHAR(500) NULL,
	description TEXT NULL,
	isactive BOOL DEFAULT true NOT NULL,
	createdat TIMESTAMP DEFAULT NOW() NOT NULL,
	updatedat TIMESTAMP NULL,
	CONSTRAINT products_code_key UNIQUE (code),
	CONSTRAINT products_pkey PRIMARY KEY (id),
	CONSTRAINT products_categoryid_fkey FOREIGN KEY (categoryid) REFERENCES categories(id),
	CONSTRAINT products_supplierid_fkey FOREIGN KEY (supplierid) REFERENCES suppliers(id)
);
CREATE INDEX idx_products_category ON products USING btree (categoryid);
CREATE INDEX idx_products_code ON products USING btree (code);

-- ----------------------------
-- 6. 进货单
-- ----------------------------
CREATE TABLE purchaseorders (
	id SERIAL NOT NULL,
	orderno VARCHAR(50) NOT NULL,
	supplierid INT4 NOT NULL,
	totalamount NUMERIC(12, 2) DEFAULT 0 NOT NULL,
	status VARCHAR(20) DEFAULT '待入库' NOT NULL,
	remark TEXT NULL,
	createdby INT4 NOT NULL,
	createdat TIMESTAMP DEFAULT NOW() NOT NULL,
	updatedat TIMESTAMP NULL,
	CONSTRAINT purchaseorders_orderno_key UNIQUE (orderno),
	CONSTRAINT purchaseorders_pkey PRIMARY KEY (id),
	CONSTRAINT purchaseorders_supplierid_fkey FOREIGN KEY (supplierid) REFERENCES suppliers(id)
);

-- ----------------------------
-- 7. 销售单
-- ----------------------------
CREATE TABLE salesorders (
	id SERIAL NOT NULL,
	orderno VARCHAR(50) NOT NULL,
	customerid INT4 NULL,
	totalamount NUMERIC(12, 2) DEFAULT 0 NOT NULL,
	discountamount NUMERIC(10, 2) DEFAULT 0 NULL,
	actualamount NUMERIC(12, 2) DEFAULT 0 NOT NULL,
	paymentmethod VARCHAR(30) DEFAULT '现金' NULL,
	status VARCHAR(20) DEFAULT '已完成' NOT NULL,
	remark TEXT NULL,
	createdby INT4 NOT NULL,
	createdat TIMESTAMP DEFAULT NOW() NOT NULL,
	updatedat TIMESTAMP NULL,
	tradeno VARCHAR(64) NULL,
	paytime TIMESTAMP NULL,
	paystatus VARCHAR(20) DEFAULT '未支付' NULL,
	CONSTRAINT salesorders_orderno_key UNIQUE (orderno),
	CONSTRAINT salesorders_pkey PRIMARY KEY (id),
	CONSTRAINT salesorders_customerid_fkey FOREIGN KEY (customerid) REFERENCES customers(id)
);

-- ----------------------------
-- 8. 快递发货
-- ----------------------------
CREATE TABLE shipments (
	id SERIAL NOT NULL,
	salesorderid INT8 NOT NULL,
	trackingnumber VARCHAR(50) NOT NULL,
	carrier VARCHAR(50) NOT NULL,
	recipientname VARCHAR(100) NOT NULL,
	recipientphone VARCHAR(30) NULL,
	recipientaddress VARCHAR(500) NULL,
	shippingfee NUMERIC(10, 2) DEFAULT 0 NOT NULL,
	status VARCHAR(20) DEFAULT '待发货' NOT NULL,
	remark TEXT NULL,
	createdat TIMESTAMP DEFAULT NOW() NOT NULL,
	updatedat TIMESTAMP NULL,
	CONSTRAINT shipments_pkey PRIMARY KEY (id),
	CONSTRAINT shipments_trackingnumber_key UNIQUE (trackingnumber),
	CONSTRAINT shipments_salesorderid_fkey FOREIGN KEY (salesorderid) REFERENCES salesorders(id)
);
CREATE INDEX idx_shipments_salesorderid ON shipments USING btree (salesorderid);
CREATE INDEX idx_shipments_trackingno ON shipments USING btree (trackingnumber);

-- ----------------------------
-- 9. 进货单明细
-- ----------------------------
CREATE TABLE purchaseorderitems (
	id SERIAL NOT NULL,
	purchaseorderid INT4 NOT NULL,
	productid INT4 NOT NULL,
	quantity INT4 NOT NULL,
	unitprice NUMERIC(10, 2) NOT NULL,
	subtotal NUMERIC(12, 2) NOT NULL,
	createdat TIMESTAMP DEFAULT NOW() NOT NULL,
	updatedat TIMESTAMP NULL,
	CONSTRAINT purchaseorderitems_pkey PRIMARY KEY (id),
	CONSTRAINT purchaseorderitems_productid_fkey FOREIGN KEY (productid) REFERENCES products(id),
	CONSTRAINT purchaseorderitems_purchaseorderid_fkey FOREIGN KEY (purchaseorderid) REFERENCES purchaseorders(id) ON DELETE CASCADE
);
CREATE INDEX idx_poi_order ON purchaseorderitems USING btree (purchaseorderid);

-- ----------------------------
-- 10. 销售单明细
-- ----------------------------
CREATE TABLE salesorderitems (
	id SERIAL NOT NULL,
	salesorderid INT4 NOT NULL,
	productid INT4 NOT NULL,
	quantity INT4 NOT NULL,
	unitprice NUMERIC(10, 2) NOT NULL,
	subtotal NUMERIC(12, 2) NOT NULL,
	createdat TIMESTAMP DEFAULT NOW() NOT NULL,
	updatedat TIMESTAMP NULL,
	CONSTRAINT salesorderitems_pkey PRIMARY KEY (id),
	CONSTRAINT salesorderitems_productid_fkey FOREIGN KEY (productid) REFERENCES products(id),
	CONSTRAINT salesorderitems_salesorderid_fkey FOREIGN KEY (salesorderid) REFERENCES salesorders(id) ON DELETE CASCADE
);
CREATE INDEX idx_soi_order ON salesorderitems USING btree (salesorderid);
