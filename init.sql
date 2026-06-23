-- public.categories 定义

-- Drop table

-- DROP TABLE public.categories;

CREATE TABLE public.categories (
	id serial4 NOT NULL,
	"name" varchar(100) NOT NULL,
	description text NULL,
	createdat timestamp DEFAULT now() NOT NULL,
	updatedat timestamp NULL,
	CONSTRAINT categories_name_key UNIQUE (name),
	CONSTRAINT categories_pkey PRIMARY KEY (id)
);


-- public.customers 定义

-- Drop table

-- DROP TABLE public.customers;

CREATE TABLE public.customers (
	id serial4 NOT NULL,
	"name" varchar(100) NOT NULL,
	phone varchar(30) NULL,
	email varchar(100) NULL,
	address varchar(500) NULL,
	memberlevel varchar(20) DEFAULT '普通'::character varying NULL,
	totalspent numeric(12, 2) DEFAULT 0 NULL,
	createdat timestamp DEFAULT now() NOT NULL,
	updatedat timestamp NULL,
	CONSTRAINT customers_pkey PRIMARY KEY (id)
);


-- public.suppliers 定义

-- Drop table

-- DROP TABLE public.suppliers;

CREATE TABLE public.suppliers (
	id serial4 NOT NULL,
	"name" varchar(200) NOT NULL,
	contactperson varchar(50) NULL,
	phone varchar(30) NULL,
	email varchar(100) NULL,
	address varchar(500) NULL,
	remark text NULL,
	createdat timestamp DEFAULT now() NOT NULL,
	updatedat timestamp NULL,
	CONSTRAINT suppliers_pkey PRIMARY KEY (id)
);


-- public.users 定义

-- Drop table

-- DROP TABLE public.users;

CREATE TABLE public.users (
	id serial4 NOT NULL,
	username varchar(50) NOT NULL,
	passwordhash varchar(200) NOT NULL,
	displayname varchar(50) NOT NULL,
	"role" varchar(30) DEFAULT '操作员'::character varying NOT NULL,
	isactive bool DEFAULT true NOT NULL,
	lastloginat timestamp NULL,
	createdat timestamp DEFAULT now() NOT NULL,
	updatedat timestamp NULL,
	CONSTRAINT users_pkey PRIMARY KEY (id),
	CONSTRAINT users_username_key UNIQUE (username)
);


-- public.products 定义

-- Drop table

-- DROP TABLE public.products;

CREATE TABLE public.products (
	id serial4 NOT NULL,
	code varchar(50) NOT NULL,
	"name" varchar(200) NOT NULL,
	categoryid int4 NOT NULL,
	supplierid int4 NULL,
	unit varchar(20) DEFAULT '个'::character varying NOT NULL,
	purchaseprice numeric(10, 2) DEFAULT 0 NOT NULL,
	sellingprice numeric(10, 2) DEFAULT 0 NOT NULL,
	stockquantity int4 DEFAULT 0 NOT NULL,
	minstock int4 DEFAULT 10 NOT NULL,
	imagepath varchar(500) NULL,
	description text NULL,
	isactive bool DEFAULT true NOT NULL,
	createdat timestamp DEFAULT now() NOT NULL,
	updatedat timestamp NULL,
	CONSTRAINT products_code_key UNIQUE (code),
	CONSTRAINT products_pkey PRIMARY KEY (id),
	CONSTRAINT products_categoryid_fkey FOREIGN KEY (categoryid) REFERENCES public.categories(id),
	CONSTRAINT products_supplierid_fkey FOREIGN KEY (supplierid) REFERENCES public.suppliers(id)
);
CREATE INDEX idx_products_category ON public.products USING btree (categoryid);
CREATE INDEX idx_products_code ON public.products USING btree (code);


-- public.purchaseorders 定义

-- Drop table

-- DROP TABLE public.purchaseorders;

CREATE TABLE public.purchaseorders (
	id serial4 NOT NULL,
	orderno varchar(50) NOT NULL,
	supplierid int4 NOT NULL,
	totalamount numeric(12, 2) DEFAULT 0 NOT NULL,
	status varchar(20) DEFAULT '待入库'::character varying NOT NULL,
	remark text NULL,
	createdby int4 NOT NULL,
	createdat timestamp DEFAULT now() NOT NULL,
	updatedat timestamp NULL,
	CONSTRAINT purchaseorders_orderno_key UNIQUE (orderno),
	CONSTRAINT purchaseorders_pkey PRIMARY KEY (id),
	CONSTRAINT purchaseorders_supplierid_fkey FOREIGN KEY (supplierid) REFERENCES public.suppliers(id)
);


-- public.salesorders 定义

-- Drop table

-- DROP TABLE public.salesorders;

CREATE TABLE public.salesorders (
	id serial4 NOT NULL,
	orderno varchar(50) NOT NULL,
	customerid int4 NULL,
	totalamount numeric(12, 2) DEFAULT 0 NOT NULL,
	discountamount numeric(10, 2) DEFAULT 0 NULL,
	actualamount numeric(12, 2) DEFAULT 0 NOT NULL,
	paymentmethod varchar(30) DEFAULT '现金'::character varying NULL,
	status varchar(20) DEFAULT '已完成'::character varying NOT NULL,
	remark text NULL,
	createdby int4 NOT NULL,
	createdat timestamp DEFAULT now() NOT NULL,
	updatedat timestamp NULL,
	tradeno varchar(64) NULL,
	paytime timestamp NULL,
	paystatus varchar(20) DEFAULT '未支付'::character varying NULL,
	CONSTRAINT salesorders_orderno_key UNIQUE (orderno),
	CONSTRAINT salesorders_pkey PRIMARY KEY (id),
	CONSTRAINT salesorders_customerid_fkey FOREIGN KEY (customerid) REFERENCES public.customers(id)
);


-- public.shipments 定义

-- Drop table

-- DROP TABLE public.shipments;

CREATE TABLE public.shipments (
	id serial4 NOT NULL,
	salesorderid int8 NOT NULL,
	trackingnumber varchar(50) NOT NULL,
	carrier varchar(50) NOT NULL,
	recipientname varchar(100) NOT NULL,
	recipientphone varchar(30) NULL,
	recipientaddress varchar(500) NULL,
	shippingfee numeric(10, 2) DEFAULT 0 NOT NULL,
	status varchar(20) DEFAULT '待发货'::character varying NOT NULL,
	remark text NULL,
	createdat timestamp DEFAULT now() NOT NULL,
	updatedat timestamp NULL,
	CONSTRAINT shipments_pkey PRIMARY KEY (id),
	CONSTRAINT shipments_trackingnumber_key UNIQUE (trackingnumber),
	CONSTRAINT shipments_salesorderid_fkey FOREIGN KEY (salesorderid) REFERENCES public.salesorders(id)
);
CREATE INDEX idx_shipments_salesorderid ON public.shipments USING btree (salesorderid);
CREATE INDEX idx_shipments_trackingno ON public.shipments USING btree (trackingnumber);


-- public.purchaseorderitems 定义

-- Drop table

-- DROP TABLE public.purchaseorderitems;

CREATE TABLE public.purchaseorderitems (
	id serial4 NOT NULL,
	purchaseorderid int4 NOT NULL,
	productid int4 NOT NULL,
	quantity int4 NOT NULL,
	unitprice numeric(10, 2) NOT NULL,
	subtotal numeric(12, 2) NOT NULL,
	createdat timestamp DEFAULT now() NOT NULL,
	updatedat timestamp NULL,
	CONSTRAINT purchaseorderitems_pkey PRIMARY KEY (id),
	CONSTRAINT purchaseorderitems_productid_fkey FOREIGN KEY (productid) REFERENCES public.products(id),
	CONSTRAINT purchaseorderitems_purchaseorderid_fkey FOREIGN KEY (purchaseorderid) REFERENCES public.purchaseorders(id) ON DELETE CASCADE
);
CREATE INDEX idx_poi_order ON public.purchaseorderitems USING btree (purchaseorderid);


-- public.salesorderitems 定义

-- Drop table

-- DROP TABLE public.salesorderitems;

CREATE TABLE public.salesorderitems (
	id serial4 NOT NULL,
	salesorderid int4 NOT NULL,
	productid int4 NOT NULL,
	quantity int4 NOT NULL,
	unitprice numeric(10, 2) NOT NULL,
	subtotal numeric(12, 2) NOT NULL,
	createdat timestamp DEFAULT now() NOT NULL,
	updatedat timestamp NULL,
	CONSTRAINT salesorderitems_pkey PRIMARY KEY (id),
	CONSTRAINT salesorderitems_productid_fkey FOREIGN KEY (productid) REFERENCES public.products(id),
	CONSTRAINT salesorderitems_salesorderid_fkey FOREIGN KEY (salesorderid) REFERENCES public.salesorders(id) ON DELETE CASCADE
);
CREATE INDEX idx_soi_order ON public.salesorderitems USING btree (salesorderid);