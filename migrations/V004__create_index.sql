-- Удаляем индекс, если он существует
DROP INDEX IF EXISTS order_product_order_id_idx;
DROP INDEX IF EXISTS orders_status_date_idx;

-- Индекс для ускорения JOIN между order_product и orders по полю order_id
CREATE INDEX order_product_order_id_idx ON order_product(order_id);

-- Композитный индекс для ускорения фильтрации и группировки в таблице orders
CREATE INDEX orders_status_date_idx ON orders(status, date_created);
