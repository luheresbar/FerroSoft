-- View for current inventory
CREATE VIEW current_inventory_view AS
SELECT
    p.id as product_id,
    p.barcode,
    p.name,
    p.sale_price,
    COALESCE(SUM(ib.available_quantity), 0) as total_quantity,
    COALESCE(SUM(ib.available_quantity * ib.purchase_cost), 0) as inventory_value
FROM products p
LEFT JOIN input_batches ib ON p.id = ib.product_id AND ib.active = true AND ib.available_quantity > 0
WHERE p.active = true
GROUP BY p.id, p.barcode, p.name, p.sale_price;