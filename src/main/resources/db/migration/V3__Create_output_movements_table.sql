-- Output movements (sales)
CREATE TABLE output_movements (
    id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(id),
    quantity INTEGER NOT NULL,
    sale_price DECIMAL(10,2) NOT NULL,
    output_date DATE NOT NULL,
    movement_type VARCHAR(20) DEFAULT 'SALE'
);