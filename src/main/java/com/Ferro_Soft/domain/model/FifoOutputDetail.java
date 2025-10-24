package com.Ferro_Soft.domain.model;

import lombok.*;

import java.math.BigDecimal;

@Getter
@Setter
@ToString
@EqualsAndHashCode
@AllArgsConstructor
@NoArgsConstructor
public class FifoOutputDetail {

    private Integer id;
    private Integer quantity;
    private BigDecimal purchaseCost;

}
