# FerroSoft Project

Metodología Devoluciones:
Excelente, vas muy bien 👏
Ya tienes una base sólida con tablas bien estructuradas y las operaciones FIFO correctamente modeladas.
Ahora veamos **cómo gestionar la devolución de 15 unidades de la venta del 5 de mayo (170 unidades)** bajo **FIFO** sin romper la trazabilidad del inventario.

---

## 🎯 Objetivo

Registrar una **devolución parcial de venta** en tu sistema, de modo que:

1. Se refleje como un movimiento **de tipo “RETURN”** (no “SALE”).
2. Las unidades devueltas **vuelvan al inventario con su costo original** (FIFO).
3. Se actualice la cantidad disponible en los **lotes de entrada afectados**.

---

## 🧩 Paso 1. Registrar el movimiento de devolución

Agregamos un nuevo registro en `output_movements`, pero con un tipo diferente:

> `"RETURN"` (para que el sistema sepa que es una entrada inversa).

```sql
WITH devolucion AS (
    INSERT INTO output_movements (product_id, quantity, sale_price, output_date, movement_type)
    VALUES (1, 15, 16570.00, '2024-05-10', 'RETURN')
    RETURNING id
)
```

> 🔹 *El precio de venta puede ser el mismo del movimiento original, solo para referencia contable.*

---

## 🧩 Paso 2. Identificar de qué lotes proviene la venta original (FIFO)

En la venta del **5 de mayo (movimiento_3)** las unidades salieron de:

| Lote           | Cantidad usada | Costo unitario |
| -------------- | -------------- | -------------- |
| COMPRA-FEB-001 | 50             | $12,950        |
| COMPRA-ABR-001 | 120            | $14,230        |

En FIFO, las **últimas unidades vendidas son las primeras que se devuelven**,
así que las 15 devueltas **provienen del lote “COMPRA-ABR-001” ($14,230)**.

---

## 🧩 Paso 3. Registrar el detalle FIFO inverso

Creamos un registro en `fifo_output_details` indicando el lote al que regresan las unidades.

```sql
WITH devolucion AS (
    INSERT INTO output_movements (product_id, quantity, sale_price, output_date, movement_type)
    VALUES (1, 15, 16570.00, '2024-05-10', 'RETURN')
    RETURNING id
)
INSERT INTO fifo_output_details (output_movement_id, input_batch_id, quantity, purchase_cost)
SELECT d.id, ib.id, 15, ib.purchase_cost
FROM devolucion d
JOIN input_batches ib ON ib.batch_code = 'COMPRA-ABR-001';
```

---

## 🧩 Paso 4. Actualizar el lote afectado (se devuelven unidades al inventario)

```sql
UPDATE input_batches
SET available_quantity = available_quantity + 15
WHERE batch_code = 'COMPRA-ABR-001';
```

---

## 🧾 Resultado final

| Lote           | Cantidad disponible antes | + Devolución | Nueva cantidad disponible |
| -------------- | ------------------------- | ------------ | ------------------------- |
| COMPRA-ABR-001 | 480                       | +15          | **495**                   |

---

## 🧠 En resumen

**Lógica FIFO para devoluciones en código:**

1. Registrar un nuevo movimiento con `movement_type = 'RETURN'`.
2. Identificar los lotes usados en la venta original (`fifo_output_details`).
3. Determinar desde cuál lote proviene la devolución (último en FIFO).
4. Insertar un nuevo detalle FIFO con la cantidad devuelta y su costo.
5. Actualizar el stock (`available_quantity`) del lote correspondiente.

---

## 💡 (Opcional) En el backend Java

Podrías implementar un método de servicio como este:

```java
@Transactional
public void processReturn(Long productId, int quantityReturned, LocalDate returnDate) {
    // 1. Crear movimiento tipo RETURN
    OutputMovement returnMovement = new OutputMovement();
    returnMovement.setProductId(productId);
    returnMovement.setQuantity(quantityReturned);
    returnMovement.setOutputDate(returnDate);
    returnMovement.setMovementType("RETURN");
    outputMovementRepository.save(returnMovement);

    // 2. Buscar el último lote usado (según la venta anterior)
    InputBatch batch = inputBatchRepository.findLastUsedBatchByProduct(productId);

    // 3. Crear detalle FIFO
    FifoOutputDetail detail = new FifoOutputDetail();
    detail.setOutputMovementId(returnMovement.getId());
    detail.setInputBatchId(batch.getId());
    detail.setQuantity(quantityReturned);
    detail.setPurchaseCost(batch.getPurchaseCost());
    fifoDetailRepository.save(detail);

    // 4. Devolver unidades al inventario
    batch.setAvailableQuantity(batch.getAvailableQuantity() + quantityReturned);
    inputBatchRepository.save(batch);
}
```

> Este método sigue exactamente la misma lógica que el SQL:
> devolver las unidades al lote más reciente utilizado en la venta.

---

¿Quieres que te deje también la versión completa de las **consultas SQL** y el **código Java en clase de servicio y repositorio JPA** para registrar tanto las ventas FIFO como las devoluciones (retornos)?
Así tendrías el flujo completo automatizado.

