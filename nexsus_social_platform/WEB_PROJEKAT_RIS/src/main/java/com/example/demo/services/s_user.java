package com.example.demo.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repositories.r_user;

import model.User;

@Service
public class s_user {
    
    @Autowired
    private r_user r_user;
    
    public User save(User user) {
        return r_user.save(user);
    }
    
    public List<User> find_all() {
        return r_user.findAll();
    }
    
    public void delete_user(Long userId) {
        r_user.deleteById(userId);
    }
    
    public User find_by_id(Long id) {
        return r_user.findById(id).orElse(null);
    }
    
    public User find_by_username(String username) {
        return r_user.findByUsername(username);
    }
}