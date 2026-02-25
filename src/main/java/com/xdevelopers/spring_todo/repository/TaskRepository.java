package com.xdevelopers.spring_todo.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.xdevelopers.spring_todo.model.Task;
import com.xdevelopers.spring_todo.model.enums.TaskStatus;

@Repository
public interface TaskRepository extends JpaRepository<Task,Long>{
    List<Task> findByProjectId(Long projectId);
    List<Task> findByProjectIdAndStatus(Long projectId, TaskStatus status);
    List<Task> findByAssigneesId(Long userId);
    List<Task> findByCreatedById(Long userId);
}
