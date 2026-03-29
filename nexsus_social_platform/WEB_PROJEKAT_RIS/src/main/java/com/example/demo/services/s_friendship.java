package com.example.demo.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repositories.r_friendship;

import model.Friendship;
import model.User;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class s_friendship {
    
    @Autowired
    private r_friendship r_friendship;
    
    public List<User> get_friends(User user) {
        List<Friendship> friendships = r_friendship.findByIdUser1OrIdUser2(user, user);
        return friendships.stream()
            .map(f -> f.getIdUser1().equals(user) ? f.getIdUser2() : f.getIdUser1())
            .collect(Collectors.toList());
    }
    
    public List<Friendship> get_friendships_as_user1(User user) {
        return r_friendship.findByIdUser1(user);
    }

    public List<Friendship> get_friendships_as_user2(User user) {
        return r_friendship.findByIdUser2(user);
    }
    
    public boolean are_friends(User user1, User user2) {
        return r_friendship.existsByIdUser1AndIdUser2(user1, user2) || 
               r_friendship.existsByIdUser1AndIdUser2(user2, user1);
    }

    public void delete_friendship(Long friendshipId) {
        r_friendship.deleteById(friendshipId);
    }

    public void create_friendship(User user1, User user2) {
        if (!r_friendship.existsByIdUser1AndIdUser2(user1, user2) && 
            !r_friendship.existsByIdUser1AndIdUser2(user2, user1)) {
            Friendship friendship = new Friendship();
            friendship.setIdUser1(user1);
            friendship.setIdUser2(user2);
            r_friendship.save(friendship);
        }
    }
}