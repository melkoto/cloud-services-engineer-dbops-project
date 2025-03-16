-- 1. Нормализация данных о продуктах:
-- Добавляем колонку price в таблицу product, если её ещё нет
ALTER TABLE product
    ADD COLUMN IF NOT EXISTS price DOUBLE PRECISION;

-- Удаляем таблицу product_info, так как теперь вся информация о продукте хранится в product
DROP TABLE IF EXISTS product_info;

-- 2. Нормализация данных о заказах:
-- Добавляем колонку date_created в таблицу orders (для хранения даты заказа)
ALTER TABLE orders
    ADD COLUMN IF NOT EXISTS date_created DATE DEFAULT CURRENT_DATE;

-- Удаляем таблицу orders_date, если она существует
DROP TABLE IF EXISTS orders_date;

-- 3. Обеспечиваем корректные связи между заказами и продуктами:

-- Добавляем внешний ключ для product_id, только если он отсутствует
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'fk_order_product_product'
          AND table_name = 'order_product'
    ) THEN
        ALTER TABLE order_product
            ADD CONSTRAINT fk_order_product_product FOREIGN KEY (product_id)
            REFERENCES product (id);
    END IF;
END
$$;

-- Добавляем внешний ключ для order_id, только если он отсутствует
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'fk_order_product_order'
          AND table_name = 'order_product'
    ) THEN
        ALTER TABLE order_product
            ADD CONSTRAINT fk_order_product_order FOREIGN KEY (order_id)
            REFERENCES orders (id);
    END IF;
END
$$;

