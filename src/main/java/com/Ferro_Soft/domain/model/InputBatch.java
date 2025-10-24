package com.Ferro_Soft.domain.model;

import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@ToString
@EqualsAndHashCode
@AllArgsConstructor
@NoArgsConstructor
public class InputBatch {

    private Integer id;
    private String batchCode;
    private Integer quantity;
    private BigDecimal purchaseCost;
    private LocalDate entryDate;
    private Integer availableQuantity;
    private Boolean active = true;
}
