package com.Ferro_Soft.infrastructure.persistence.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;

@Getter
@Setter
@ToString
@Entity
@Table(name = "fifo_output_details")
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class FifoOutputDetailEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false)
    private Integer quantity;

    @Column(name = "purchase_cost", nullable = false, precision = 10, scale = 2)
    private BigDecimal purchaseCost;

    // Relación con la tabla input_batches
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "input_batch_id", nullable = false)
    @ToString.Exclude
    private InputBatchEntity inputBatch;

    // Relación con la tabla output_movements
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "output_movement_id", nullable = false)
    @ToString.Exclude
    private OutputMovementEntity outputMovement;
}
