package com.xdevelopers.spring_todo.dto;

import com.xdevelopers.spring_todo.model.User;
import com.xdevelopers.spring_todo.model.enums.UserRole;

import lombok.Getter;

@Getter
public class UserResponse {
    private Long id;
    private String name;
    private String email;
    private UserRole role;

    public UserResponse(User user){
        this.id = user.getId();
        this.name = user.getName();
        this.email = user.getEmail();
        this.role = user.getRole();
    }
}
