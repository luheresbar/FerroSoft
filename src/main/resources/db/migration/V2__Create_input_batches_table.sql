-- Input batches (purchases)
CREATE TABLE input_batches (
    id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(id),
    batch_code VARCHAR(50),
    quantity INTEGER NOT NULL,
    purchase_cost DECIMAL(10,2) NOT NULL,
    entry_date DATE NOT NULL,
    available_quantity INTEGER NOT NULL,
    active BOOLEAN DEFAULT true
);