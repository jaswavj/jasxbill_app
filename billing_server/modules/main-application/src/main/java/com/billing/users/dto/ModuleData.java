package com.billing.users.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
public class ModuleData {
    private Long id;
    private String name;
    @JsonProperty("isGroup")
    private Integer isGroup;
    @JsonProperty("groupId")
    private Integer groupId;
}
