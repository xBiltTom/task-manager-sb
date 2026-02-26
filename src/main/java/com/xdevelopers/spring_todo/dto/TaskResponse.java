package com.xdevelopers.spring_todo.dto;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Set;
import java.util.stream.Collector;
import java.util.stream.Collectors;

import com.xdevelopers.spring_todo.model.Task;
import com.xdevelopers.spring_todo.model.enums.TaskPriority;
import com.xdevelopers.spring_todo.model.enums.TaskStatus;

import lombok.Getter;

@Getter
public class TaskResponse {
    private Long id;
    private String title;
    private String description;
    private TaskStatus status;
    private TaskPriority priority;
    private LocalDate dueDate;
    private Long projectId;
    private UserResponse createdBy;
    private Set<UserResponse> assignees;
    private LocalDateTime createdAt;

    public TaskResponse(Task task){
        this.id = task.getId();
        this.title = task.getTitle();
        this.description = task.getDescription();
        this.status = task.getStatus();
        this.priority = task.getPriority();
        this.dueDate = task.getDueDate();
        this.projectId = task.getProject().getId();
        this.createdBy = new UserResponse(task.getCreatedBy());
        this.assignees = task.getAssignees().stream()
            .map(UserResponse::new)
            .collect(Collectors.toSet());
    }

}
