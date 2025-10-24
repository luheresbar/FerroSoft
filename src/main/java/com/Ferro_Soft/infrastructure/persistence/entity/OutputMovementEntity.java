package com.Ferro_Soft.infrastructure.persistence.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@ToString
@Entity
@Table(name = "output_movements")
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class OutputMovementEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false)
    private Integer quantity;

    @Column(name = "sale_price", nullable = false, precision = 10, scale = 2)
    private BigDecimal salePrice;

    @Column(name = "output_date", nullable = false)
    private LocalDate outputDate;

    @Column(name = "movement_type", length = 20)
    private String movementType = "SALE"; // valor por defecto

    // Relación con la tabla products
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    @ToString.Exclude
    private ProductEntity product;
}
