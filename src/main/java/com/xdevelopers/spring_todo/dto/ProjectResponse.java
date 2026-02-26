package com.xdevelopers.spring_todo.dto;

import java.time.LocalDateTime;
import java.util.Set;
import java.util.stream.Collectors;

import com.xdevelopers.spring_todo.model.Project;

import lombok.Getter;

@Getter
public class ProjectResponse {
    private Long id;
    private String name;
    private String description;
    private UserResponse owner;
    private Set<UserResponse> members;
    private LocalDateTime createdAt;

    public ProjectResponse(Project project){
        this.id = project.getId();
        this.name = project.getName();
        this.description = project.getDescription();
        this.members = project.getMembers().stream()
            .map(UserResponse::new)
            .collect(Collectors.toSet());
        this.createdAt = project.getCreatedAt();
    }
}
