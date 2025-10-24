-- SCRIPTS CORREGIDOS

-- 1. Insertar producto
INSERT INTO products (barcode, name, description, sale_price, active) 
VALUES ('SMARTWATCH-001', 'Smart Watch Pro', 'Reloj inteligente de última generación', 15000.00, true);

-- 2. Insertar compras/inventario inicial
INSERT INTO input_batches (product_id, batch_code, quantity, purchase_cost, entry_date, available_quantity) VALUES
(1, 'INICIAL-001', 500, 14600.00, '2024-01-01', 500),
(1, 'COMPRA-FEB-001', 400, 12950.00, '2024-02-16', 400),
(1, 'COMPRA-ABR-001', 600, 14230.00, '2024-04-03', 600),
(1, 'COMPRA-ABR-002', 350, 15650.00, '2024-04-19', 350);

-- 3. Venta 2 de marzo (600 unidades)
WITH movimiento_1 AS (
    INSERT INTO output_movements (product_id, quantity, sale_price, output_date) 
    VALUES (1, 600, 15000.00, '2024-03-02')
    RETURNING id
)
INSERT INTO fifo_output_details (output_movement_id, input_batch_id, quantity, purchase_cost)
SELECT m.id, ib.id, 
       CASE 
           WHEN ib.batch_code = 'INICIAL-001' THEN 500
           WHEN ib.batch_code = 'COMPRA-FEB-001' THEN 100
       END,
       ib.purchase_cost
FROM movimiento_1 m, input_batches ib
WHERE ib.batch_code IN ('INICIAL-001', 'COMPRA-FEB-001');

UPDATE input_batches SET available_quantity = 0 WHERE batch_code = 'INICIAL-001';
UPDATE input_batches SET available_quantity = 300 WHERE batch_code = 'COMPRA-FEB-001';

-- 4. Venta 23 de marzo (250 unidades)
WITH movimiento_2 AS (
    INSERT INTO output_movements (product_id, quantity, sale_price, output_date) 
    VALUES (1, 250, 16450.00, '2024-03-23')
    RETURNING id
)
INSERT INTO fifo_output_details (output_movement_id, input_batch_id, quantity, purchase_cost)
SELECT m.id, ib.id, 250, ib.purchase_cost
FROM movimiento_2 m, input_batches ib
WHERE ib.batch_code = 'COMPRA-FEB-001';

UPDATE input_batches SET available_quantity = 50 WHERE batch_code = 'COMPRA-FEB-001';

-- 5. Venta 5 de mayo (170 unidades)
WITH movimiento_3 AS (
    INSERT INTO output_movements (product_id, quantity, sale_price, output_date) 
    VALUES (1, 170, 16570.00, '2024-05-05')
    RETURNING id
)
INSERT INTO fifo_output_details (output_movement_id, input_batch_id, quantity, purchase_cost)
SELECT m.id, ib.id, 
       CASE 
           WHEN ib.batch_code = 'COMPRA-FEB-001' THEN 50
           WHEN ib.batch_code = 'COMPRA-ABR-001' THEN 120
       END,
       ib.purchase_cost
FROM movimiento_3 m, input_batches ib
WHERE ib.batch_code IN ('COMPRA-FEB-001', 'COMPRA-ABR-001');

UPDATE input_batches SET available_quantity = 0 WHERE batch_code = 'COMPRA-FEB-001';
UPDATE input_batches SET available_quantity = 480 WHERE batch_code = 'COMPRA-ABR-001';