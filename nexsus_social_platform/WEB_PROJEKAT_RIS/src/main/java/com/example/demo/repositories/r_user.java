package com.example.demo.repositories;

import model.User;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface r_user extends JpaRepository<User, Long> {
    List<User> findAll();
    User findByUsername(String username);
    User findByEmail(String email);
}