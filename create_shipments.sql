-- ============================================================
-- 快递表 DDL + 初始数据
-- 在 PostgreSQL 中执行此脚本
-- ============================================================

-- 1. 创建表
CREATE TABLE IF NOT EXISTS shipments (
    id               SERIAL PRIMARY KEY,
    salesorderid     BIGINT        NOT NULL REFERENCES salesorders(id),
    trackingnumber   VARCHAR(50)   NOT NULL UNIQUE,
    carrier          VARCHAR(50)   NOT NULL,
    recipientname    VARCHAR(100)  NOT NULL,
    recipientphone   VARCHAR(30),
    recipientaddress VARCHAR(500),
    shippingfee      NUMERIC(10,2) NOT NULL DEFAULT 0,
    status           VARCHAR(20)   NOT NULL DEFAULT '待发货',
    remark           TEXT,
    createdat        TIMESTAMP     NOT NULL DEFAULT NOW(),
    updatedat        TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_shipments_salesorderid ON shipments(salesorderid);
CREATE INDEX IF NOT EXISTS idx_shipments_trackingno ON shipments(trackingnumber);

-- 2. 插入初始数据（为已有的销售单创建快递记录）
INSERT INTO shipments (salesorderid, trackingnumber, carrier, recipientname, recipientphone, recipientaddress, shippingfee, status, remark, createdat)
SELECT so.id,
       'KD' || TO_CHAR(so.createdat, 'YYYYMMDD') || LPAD(ROW_NUMBER() OVER (ORDER BY so.id)::TEXT, 4, '0'),
       CASE WHEN so.id = 1 THEN '顺丰快递' ELSE '圆通快递' END,
       COALESCE(c.name, '散客'),
       COALESCE(c.phone, ''),
       COALESCE(c.address, ''),
       CASE WHEN so.id = 1 THEN 8.00 ELSE 6.00 END,
       CASE WHEN so.id = 1 THEN '已签收' ELSE '运输中' END,
       CASE WHEN so.id = 1 THEN '已于1月20日签收' ELSE '' END,
       NOW()
FROM salesorders so
LEFT JOIN customers c ON so.customerid = c.id
WHERE so.status = '已完成'
  AND NOT EXISTS (SELECT 1 FROM shipments WHERE salesorderid = so.id);

-- 3. 重置自增序列（防止主键冲突）
SELECT setval('shipments_id_seq', COALESCE((SELECT MAX(id) FROM shipments), 0));
