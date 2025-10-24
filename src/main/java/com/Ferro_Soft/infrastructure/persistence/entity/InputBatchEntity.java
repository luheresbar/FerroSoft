package com.Ferro_Soft.infrastructure.persistence.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@ToString
@Entity
@Table(name = "input_batches")
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class InputBatchEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "batch_code", length = 50)
    private String batchCode;

    @Column(nullable = false)
    private Integer quantity;

    @Column(name = "purchase_cost", nullable = false, precision = 10, scale = 2)
    private BigDecimal purchaseCost;

    @Column(name = "entry_date", nullable = false)
    private LocalDate entryDate;

    @Column(name = "available_quantity", nullable = false)
    private Integer availableQuantity;

    @Column(nullable = false)
    private Boolean active = true;

    // Relación con la tabla products
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    @ToString.Exclude // Evita ciclos recursivos en toString()
    private ProductEntity product;
}
