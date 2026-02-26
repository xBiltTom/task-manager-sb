package com.xdevelopers.spring_todo.dto;

import java.time.LocalDate;
import java.util.Set;

import com.xdevelopers.spring_todo.model.enums.TaskPriority;
import com.xdevelopers.spring_todo.model.enums.TaskStatus;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class TaskRequest {
    @NotBlank(message = "El título es obligatorio")
    @Size(max = 200, message = "El título no debe tener mas de 200 caracteres")
    private String title;

    private String description;
    private TaskStatus status = TaskStatus.TODO;
    private TaskPriority priority = TaskPriority.MEDIUM;
    private LocalDate dueDate;

    @NotNull(message = "El proyecto es obligatorio")
    private Long projectId;

    private Set<Long> assigneeIds; //Ids de usuarios asignados

}
