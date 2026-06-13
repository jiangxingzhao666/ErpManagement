-- ============================================================
-- 测试数据脚本
-- ============================================================

-- 1. 商品分类
INSERT INTO categories (name, description, createdat) VALUES
('饮料',     '碳酸饮料、果汁、茶饮等',  NOW()),
('零食',     '饼干、薯片、糖果等',      NOW()),
('日用品',   '牙膏、毛巾、洗涤用品等',  NOW()),
('乳制品',   '牛奶、酸奶、奶酪等',      NOW()),
('粮油调味', '米面油盐酱醋等',          NOW());

-- 2. 供应商
INSERT INTO suppliers (name, contactperson, phone, email, address, remark, createdat) VALUES
('可口可乐饮料有限公司', '王经理', '13800001111', 'wj@cocacola.com', '上海市浦东新区', '长期合作供应商', NOW()),
('亿滋食品有限公司',     '李主管', '13800002222', 'lzg@yizi.com',    '北京市朝阳区',   '零食主要供应商', NOW()),
('宝洁日化有限公司',     '赵经理', '13800003333', 'zj@pg.com',       '广州市天河区',   '',             NOW());

-- 3. 商品
INSERT INTO products (code, name, categoryid, supplierid, unit, purchaseprice, sellingprice, stockquantity, minstock, imagepath, description, createdat) VALUES
('SP001', '可口可乐330ml',     1, 1, '罐', 2.20, 3.00,  200, 50, '~/Content/images/products/prod_cocacola.svg', '经典碳酸饮料',     NOW()),
('SP002', '雪碧330ml',         1, 1, '罐', 2.00, 2.80,  150, 40, '~/Content/images/products/prod_sprite.svg',   '柠檬味汽水',       NOW()),
('SP003', '奥利奥饼干97g',     2, 2, '盒', 5.50, 8.50,   80, 20, '~/Content/images/products/prod_oreo.svg',     '巧克力夹心',       NOW()),
('SP004', '乐事薯片75g',       2, 2, '袋', 4.80, 7.50,   60, 15, '~/Content/images/products/prod_lays.svg',     '原味',             NOW()),
('SP005', '佳洁士牙膏120g',    3, 3, '支', 8.00, 12.90,  40, 10, '~/Content/images/products/prod_crest.svg',    '薄荷清新',         NOW()),
('SP006', '伊利纯牛奶250ml',   4, NULL,'盒', 2.80, 4.00, 120, 30, '~/Content/images/products/prod_milk.svg',     '优质乳蛋白',       NOW()),
('SP007', '蒙牛酸奶100g*8',    4, NULL,'排', 9.50, 15.90,  50, 15, '~/Content/images/products/prod_yogurt.svg',   '原味酸奶',         NOW()),
('SP008', '金龙鱼调和油5L',    5, NULL,'桶', 55.00,69.90,  30,  8, '~/Content/images/products/prod_oil.svg',      '1:1:1黄金比例',   NOW()),
('SP009', '海天酱油500ml',     5, NULL,'瓶', 5.00, 8.90,  100, 25, '~/Content/images/products/prod_soysauce.svg', '生抽酱油',         NOW()),
('SP010', '东北大米5kg',       5, NULL,'袋', 25.00,35.00,  45, 10, '~/Content/images/products/prod_rice.svg',     '优质粳米',         NOW());

-- 4. 客户
INSERT INTO customers (name, phone, email, address, memberlevel, totalspent, createdat) VALUES
('张三', '13911110001', 'zhangsan@qq.com', '北京市海淀区中关村', '金卡', 12800, NOW()),
('李四', '13911110002', 'lisi@qq.com',     '上海市徐汇区',       '银卡',  6320, NOW()),
('王五', '13911110003', 'wangwu@qq.com',   '广州市越秀区',       '普通',     0, NOW());

-- 5. 进货单主表
INSERT INTO purchaseorders (orderno, supplierid, totalamount, status, remark, createdby, createdat) VALUES
('JH20250115001', 1, 660, '已入库', '月初补货', 1, '2025-01-15 09:00:00'),
('JH20250120001', 2, 480, '已入库', '零食补货', 1, '2025-01-20 10:00:00'),
('JH20250125001', 3, 800, '待入库', '牙膏补货', 1, '2025-01-25 14:00:00');

-- 5. 进货单明细
INSERT INTO purchaseorderitems (purchaseorderid, productid, quantity, unitprice, subtotal, createdat) VALUES
(1, 1, 100, 2.20, 220, '2025-01-15 09:00:00'),
(1, 2, 100, 2.00, 200, '2025-01-15 09:00:00'),
(1, 3,  40, 5.50, 220, '2025-01-15 09:00:00'),
(2, 4, 100, 4.80, 480, '2025-01-20 10:00:00'),
(3, 5, 100, 8.00, 800, '2025-01-25 14:00:00');

-- 6. 销售单主表
INSERT INTO salesorders (orderno, customerid, totalamount, discountamount, actualamount, paymentmethod, status, createdby, createdat) VALUES
('XS20250118001', 1,    35.80, 3.00, 32.80, '微信',   '已完成', 1, '2025-01-18 16:00:00'),
('XS20250122001', 2,    24.00, 0,    24.00, '现金',   '已完成', 1, '2025-01-22 11:00:00'),
('XS20250126001', NULL, 12.90, 0,    12.90, '支付宝', '已完成', 1, '2025-01-26 15:00:00');

-- 6. 销售单明细
INSERT INTO salesorderitems (salesorderid, productid, quantity, unitprice, subtotal, createdat) VALUES
(1, 1, 5, 3.00, 15.00, '2025-01-18 16:00:00'),
(1, 4, 4, 5.20, 20.80, '2025-01-18 16:00:00'),
(2, 2, 6, 2.80, 16.80, '2025-01-22 11:00:00'),
(2, 3, 1, 7.20,  7.20, '2025-01-22 11:00:00'),
(3, 5, 1, 12.90,12.90, '2025-01-26 15:00:00');

-- 修正库存（销售单扣减）
UPDATE products SET stockquantity = stockquantity - 5 WHERE id = 1;
UPDATE products SET stockquantity = stockquantity - 4 WHERE id = 4;
UPDATE products SET stockquantity = stockquantity - 6 WHERE id = 2;
UPDATE products SET stockquantity = stockquantity - 1 WHERE id = 3;
UPDATE products SET stockquantity = stockquantity - 1 WHERE id = 5;

-- 7. 快递单 (shipments)
INSERT INTO shipments (salesorderid, trackingnumber, carrier, recipientname, recipientphone, recipientaddress, shippingfee, status, remark, createdat) VALUES
(1, 'KD202501180001', '顺丰快递', '张三', '13911110001', '北京市海淀区中关村', 8.00, '已签收', '已于1月20日签收', '2025-01-18 17:00:00'),
(2, 'KD202501220001', '圆通快递', '李四', '13911110002', '上海市徐汇区', 6.00, '运输中', '', '2025-01-22 12:00:00');
