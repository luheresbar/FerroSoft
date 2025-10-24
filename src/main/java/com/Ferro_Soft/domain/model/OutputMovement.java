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
public class OutputMovement {

    private Integer id;
    private Integer quantity;
    private BigDecimal salePrice;
    private LocalDate outputDate;
    private String movementType = "SALE";

}
