-- 1. Нормализация данных о продуктах:
-- Добавляем колонку price в таблицу product
ALTER TABLE product
    ADD COLUMN IF NOT EXISTS price DOUBLE PRECISION;

-- Удаляем таблицу product_info, так как теперь вся информация о продукте хранится в product
DROP TABLE IF EXISTS product_info;

-- 2. Нормализация данных о заказах:
-- Добавляем колонку date_created в таблицу orders (для хранения даты заказа)
ALTER TABLE orders
    ADD COLUMN IF NOT EXISTS date_created DATE DEFAULT CURRENT_DATE;

-- Если была таблица orders_date с датой заказа, данные можно перенести, а затем удалить её:
DROP TABLE IF EXISTS orders_date;

-- 3. Обеспечиваем корректные связи между заказами и продуктами:
ALTER TABLE order_product
    ADD CONSTRAINT fk_order_product_product
        FOREIGN KEY (product_id)
            REFERENCES product (id);

ALTER TABLE order_product
    ADD CONSTRAINT fk_order_product_order
        FOREIGN KEY (order_id)
            REFERENCES orders (id);
