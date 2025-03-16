-- 1. Вставляем данные в таблицу product (фиксированные записи)
INSERT INTO product (id, name, picture_url, price)
VALUES
    (1, 'Сливочная', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/6.jpg', 320.00),
    (2, 'Особая', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/5.jpg', 179.00),
    (3, 'Молочная', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/4.jpg', 225.00),
    (4, 'Нюренбергская', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/3.jpg', 315.00),
    (5, 'Мюнхенская', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/2.jpg', 330.00),
    (6, 'Русская', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/1.jpg', 189.00);
ON CONFLICT (id) DO NOTHING;

-- 2. Вставляем данные в таблицу orders
-- Генерируем 100000 заказов, где:
-- - статус выбирается по остатку от деления (pending, shipped, cancelled)
-- - дата заказа — текущая дата минус остаток от деления на 30 (то есть в пределах последних 30 дней)
INSERT INTO orders (id, status, date_created)
SELECT
    i,
    (array['pending','shipped','cancelled'])[(i % 3) + 1],
  CURRENT_DATE - (i % 30)
FROM generate_series(1, 100000) s(i);

-- 3. Вставляем данные в таблицу order_product
-- Для каждого заказа назначаем:
-- - количество от 1 до 50 (остаток от деления на 50 плюс 1)
-- - связываем с продуктами: (остаток от деления на 6 плюс 1, т.к. продуктов 6)
INSERT INTO order_product (quantity, order_id, product_id)
SELECT
    (i % 50) + 1,
    i,
    (i % 6) + 1
FROM generate_series(1, 100000) s(i);
