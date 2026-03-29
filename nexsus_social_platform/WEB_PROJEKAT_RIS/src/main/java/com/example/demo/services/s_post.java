package com.example.demo.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repositories.r_post;

import model.Post;
import model.User;

import java.sql.Timestamp;
import java.util.List;

@Service
public class s_post {
    
    @Autowired
    private r_post r_post;
    
    public List<Post> find_by_user(Long userId) {
        return r_post.findByIdUser_IdOrderByCreatedAtDesc(userId);
    }
    
    public void delete(Long id) {
        r_post.deleteById(id);
    }
    
    public List<Post> find_by_user(User user) {
        return r_post.findByIdUser(user);
    }

    public Post find_by_id(Long id) {
        return r_post.findById(id).orElse(null);
    }
    
    public Post save(Post post) {
        if (post.getCreatedAt() == null) {
            post.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        }
        return r_post.save(post);
    }

    public List<Post> find_all() {
        return r_post.findAllByOrderByCreatedAtDesc();
    }

    public void delete_post(Long postId) {
        r_post.deleteById(postId);
    }
}