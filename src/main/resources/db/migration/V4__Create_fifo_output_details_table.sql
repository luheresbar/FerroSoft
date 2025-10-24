-- FIFO output details
CREATE TABLE fifo_output_details (
    id SERIAL PRIMARY KEY,
    output_movement_id INTEGER REFERENCES output_movements(id),
    input_batch_id INTEGER REFERENCES input_batches(id),
    quantity INTEGER NOT NULL,
    purchase_cost DECIMAL(10,2) NOT NULL
);