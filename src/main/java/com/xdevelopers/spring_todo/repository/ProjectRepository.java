package com.xdevelopers.spring_todo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.xdevelopers.spring_todo.model.Project;

@Repository
public interface ProjectRepository extends JpaRepository<Project,Long>{
    List<Project> findByOwnerId(Long ownerId);
    List<Project> findByMembersId(Long userId);
}
