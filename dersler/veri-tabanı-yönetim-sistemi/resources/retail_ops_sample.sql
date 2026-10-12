-- Retail Operations Sample Database
-- Scenario: E-commerce order, stock, payment and shipment operations

DROP DATABASE IF EXISTS retail_ops;
CREATE DATABASE retail_ops
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE retail_ops;

-- =========================
-- 1) MASTER TABLES
-- =========================

CREATE TABLE customer (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  customer_code VARCHAR(20) NOT NULL,
  full_name VARCHAR(120) NOT NULL,
  email VARCHAR(120) NOT NULL,
  city VARCHAR(80) NOT NULL,
  segment ENUM('individual','corporate') NOT NULL DEFAULT 'individual',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_customer_code (customer_code),
  UNIQUE KEY uq_customer_email (email),
  KEY idx_customer_city (city)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

CREATE TABLE supplier (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  supplier_code VARCHAR(20) NOT NULL,
  name VARCHAR(120) NOT NULL,
  contact_email VARCHAR(120) NOT NULL,
  city VARCHAR(80) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_supplier_code (supplier_code),
  UNIQUE KEY uq_supplier_email (contact_email)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

CREATE TABLE category (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_category_name (name)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

CREATE TABLE product (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  sku VARCHAR(30) NOT NULL,
  name VARCHAR(140) NOT NULL,
  category_id INT UNSIGNED NOT NULL,
  supplier_id INT UNSIGNED NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  cost_price DECIMAL(10,2) NOT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_product_sku (sku),
  KEY idx_product_category (category_id),
  KEY idx_product_supplier (supplier_id),
  CONSTRAINT fk_product_category
    FOREIGN KEY (category_id) REFERENCES category(id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_product_supplier
    FOREIGN KEY (supplier_id) REFERENCES supplier(id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

CREATE TABLE warehouse (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  code VARCHAR(20) NOT NULL,
  name VARCHAR(120) NOT NULL,
  city VARCHAR(80) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_warehouse_code (code)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

CREATE TABLE inventory (
  product_id INT UNSIGNED NOT NULL,
  warehouse_id INT UNSIGNED NOT NULL,
  stock_qty INT NOT NULL DEFAULT 0,
  reorder_level INT NOT NULL DEFAULT 10,
  PRIMARY KEY (product_id, warehouse_id),
  KEY idx_inventory_warehouse (warehouse_id),
  CONSTRAINT fk_inventory_product
    FOREIGN KEY (product_id) REFERENCES product(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_inventory_warehouse
    FOREIGN KEY (warehouse_id) REFERENCES warehouse(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

-- =========================
-- 2) OPERATIONAL TABLES
-- =========================

CREATE TABLE sales_order (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  order_no VARCHAR(30) NOT NULL,
  customer_id INT UNSIGNED NOT NULL,
  order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status ENUM('new','approved','shipped','delivered','cancelled') NOT NULL DEFAULT 'new',
  total_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  UNIQUE KEY uq_order_no (order_no),
  KEY idx_order_customer (customer_id),
  KEY idx_order_date (order_date),
  CONSTRAINT fk_order_customer
    FOREIGN KEY (customer_id) REFERENCES customer(id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

CREATE TABLE sales_order_item (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  order_id INT UNSIGNED NOT NULL,
  product_id INT UNSIGNED NOT NULL,
  quantity INT NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  discount_pct DECIMAL(5,2) NOT NULL DEFAULT 0,
  line_total DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (id),
  KEY idx_order_item_order (order_id),
  KEY idx_order_item_product (product_id),
  CONSTRAINT fk_order_item_order
    FOREIGN KEY (order_id) REFERENCES sales_order(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_order_item_product
    FOREIGN KEY (product_id) REFERENCES product(id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

CREATE TABLE payment (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  order_id INT UNSIGNED NOT NULL,
  paid_at DATETIME NULL,
  amount DECIMAL(12,2) NOT NULL,
  method ENUM('card','transfer','cash_on_delivery') NOT NULL,
  status ENUM('pending','paid','failed','refunded') NOT NULL DEFAULT 'pending',
  PRIMARY KEY (id),
  KEY idx_payment_order (order_id),
  KEY idx_payment_status (status),
  CONSTRAINT fk_payment_order
    FOREIGN KEY (order_id) REFERENCES sales_order(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

CREATE TABLE shipment (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  order_id INT UNSIGNED NOT NULL,
  warehouse_id INT UNSIGNED NOT NULL,
  shipped_at DATETIME NULL,
  delivered_at DATETIME NULL,
  status ENUM('preparing','in_transit','delivered','returned') NOT NULL DEFAULT 'preparing',
  tracking_no VARCHAR(40) NULL,
  shipping_cost DECIMAL(10,2) NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  UNIQUE KEY uq_tracking_no (tracking_no),
  KEY idx_shipment_order (order_id),
  KEY idx_shipment_warehouse (warehouse_id),
  CONSTRAINT fk_shipment_order
    FOREIGN KEY (order_id) REFERENCES sales_order(id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_shipment_warehouse
    FOREIGN KEY (warehouse_id) REFERENCES warehouse(id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

-- =========================
-- 3) SEED DATA
-- =========================

INSERT INTO customer (customer_code, full_name, email, city, segment) VALUES
  ('C0001', 'Ali Yilmaz', 'ali.yilmaz@mail.com', 'Istanbul', 'individual'),
  ('C0002', 'Ayse Demir', 'ayse.demir@mail.com', 'Ankara', 'individual'),
  ('C0003', 'Mavi Market A.S.', 'satin.alma@mavimarket.com', 'Izmir', 'corporate'),
  ('C0004', 'Deniz Acar', 'deniz.acar@mail.com', 'Bursa', 'individual'),
  ('C0005', 'Teknova Ltd.', 'procurement@teknova.com', 'Istanbul', 'corporate'),
  ('C0006', 'Zeynep Yildiz', 'zeynep.yildiz@mail.com', 'Antalya', 'individual'),
  ('C0007', 'Onur Koc', 'onur.koc@mail.com', 'Adana', 'individual'),
  ('C0008', 'Ece Inan', 'ece.inan@mail.com', 'Istanbul', 'individual');

INSERT INTO supplier (supplier_code, name, contact_email, city) VALUES
  ('S001', 'Anka Elektronik', 'sales@anka.com', 'Istanbul'),
  ('S002', 'Nova Tedarik', 'info@novatedarik.com', 'Ankara'),
  ('S003', 'Ege Dagitim', 'contact@egedagitim.com', 'Izmir');

INSERT INTO category (name) VALUES
  ('Laptop'),
  ('Telefon'),
  ('Aksesuar'),
  ('Ag Cihazlari');

INSERT INTO product (sku, name, category_id, supplier_id, unit_price, cost_price, is_active) VALUES
  ('LP-001', 'ApexBook 14', 1, 1, 28999.00, 24000.00, 1),
  ('LP-002', 'ApexBook 16 Pro', 1, 1, 42999.00, 36500.00, 1),
  ('PH-001', 'NovaPhone X', 2, 2, 21999.00, 18000.00, 1),
  ('PH-002', 'NovaPhone Lite', 2, 2, 14999.00, 12000.00, 1),
  ('AC-001', 'Kablosuz Mouse M20', 3, 3, 699.00, 420.00, 1),
  ('AC-002', 'Mekanik Klavye K80', 3, 3, 1899.00, 1100.00, 1),
  ('NW-001', 'Router AX3000', 4, 1, 3499.00, 2500.00, 1),
  ('NW-002', 'Switch 16 Port', 4, 2, 2799.00, 2000.00, 1),
  ('AC-003', 'Type-C Sarj Adaptoru', 3, 2, 499.00, 250.00, 1),
  ('AC-004', 'Laptop Cantasi 15"', 3, 3, 899.00, 520.00, 1);

INSERT INTO warehouse (code, name, city) VALUES
  ('W-IST', 'Istanbul Ana Depo', 'Istanbul'),
  ('W-ANK', 'Ankara Transfer Depo', 'Ankara'),
  ('W-IZM', 'Izmir Bolge Depo', 'Izmir');

INSERT INTO inventory (product_id, warehouse_id, stock_qty, reorder_level) VALUES
  (1, 1, 25, 8), (1, 2, 8, 5), (1, 3, 6, 4),
  (2, 1, 12, 6), (2, 2, 4, 3), (2, 3, 3, 2),
  (3, 1, 30, 10), (3, 2, 10, 6), (3, 3, 12, 6),
  (4, 1, 22, 8), (4, 2, 9, 5), (4, 3, 7, 4),
  (5, 1, 80, 20), (5, 2, 25, 10), (5, 3, 20, 10),
  (6, 1, 35, 12), (6, 2, 10, 6), (6, 3, 8, 5),
  (7, 1, 18, 7), (7, 2, 7, 4), (7, 3, 5, 3),
  (8, 1, 14, 6), (8, 2, 6, 3), (8, 3, 5, 3),
  (9, 1, 60, 15), (9, 2, 22, 10), (9, 3, 18, 8),
  (10, 1, 40, 12), (10, 2, 14, 6), (10, 3, 11, 5);

INSERT INTO sales_order (order_no, customer_id, order_date, status, total_amount) VALUES
  ('SO-2025-0001', 1, '2025-01-05 10:15:00', 'delivered', 23498.00),
  ('SO-2025-0002', 2, '2025-01-06 14:20:00', 'delivered', 699.00),
  ('SO-2025-0003', 3, '2025-01-07 09:30:00', 'shipped', 85997.00),
  ('SO-2025-0004', 4, '2025-01-09 19:05:00', 'approved', 14999.00),
  ('SO-2025-0005', 5, '2025-01-10 11:40:00', 'new', 5398.00),
  ('SO-2025-0006', 6, '2025-01-12 16:00:00', 'cancelled', 499.00),
  ('SO-2025-0007', 8, '2025-01-13 13:10:00', 'delivered', 43898.00);

INSERT INTO sales_order_item (order_id, product_id, quantity, unit_price, discount_pct, line_total) VALUES
  (1, 3, 1, 21999.00, 0, 21999.00),
  (1, 5, 1, 699.00, 0, 699.00),
  (1, 9, 2, 400.00, 0, 800.00),
  (2, 5, 1, 699.00, 0, 699.00),
  (3, 2, 2, 42999.00, 0, 85998.00),
  (4, 4, 1, 14999.00, 0, 14999.00),
  (5, 7, 1, 3499.00, 0, 3499.00),
  (5, 10, 2, 949.50, 0, 1899.00),
  (6, 9, 1, 499.00, 0, 499.00),
  (7, 1, 1, 28999.00, 0, 28999.00),
  (7, 6, 1, 1899.00, 0, 1899.00),
  (7, 8, 1, 2799.00, 0, 2799.00),
  (7, 5, 1, 699.00, 0, 699.00),
  (7, 10, 1, 899.00, 0, 899.00);

INSERT INTO payment (order_id, paid_at, amount, method, status) VALUES
  (1, '2025-01-05 10:20:00', 23498.00, 'card', 'paid'),
  (2, '2025-01-06 14:25:00', 699.00, 'card', 'paid'),
  (3, '2025-01-07 10:00:00', 85997.00, 'transfer', 'paid'),
  (4, NULL, 14999.00, 'card', 'pending'),
  (5, NULL, 5398.00, 'transfer', 'pending'),
  (6, '2025-01-12 16:10:00', 499.00, 'card', 'refunded'),
  (7, '2025-01-13 13:15:00', 43898.00, 'card', 'paid');

INSERT INTO shipment (order_id, warehouse_id, shipped_at, delivered_at, status, tracking_no, shipping_cost) VALUES
  (1, 1, '2025-01-05 18:00:00', '2025-01-06 16:30:00', 'delivered', 'TRK10001', 120.00),
  (2, 1, '2025-01-06 19:00:00', '2025-01-07 12:10:00', 'delivered', 'TRK10002', 45.00),
  (3, 1, '2025-01-07 20:15:00', NULL, 'in_transit', 'TRK10003', 300.00),
  (4, 2, NULL, NULL, 'preparing', NULL, 95.00),
  (5, 3, NULL, NULL, 'preparing', NULL, 80.00),
  (7, 1, '2025-01-13 20:00:00', '2025-01-14 18:00:00', 'delivered', 'TRK10007', 150.00);
