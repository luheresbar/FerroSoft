package com.Ferro_Soft.domain.model;

import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Getter
@Setter
@ToString
@EqualsAndHashCode
@AllArgsConstructor
@NoArgsConstructor
public class Product {

    private Integer id;
    private String barcode;
    private String name;
    private String description;
    private BigDecimal salePrice;
    private Boolean active = true;
    private LocalDateTime creationDate = LocalDateTime.now();

}
