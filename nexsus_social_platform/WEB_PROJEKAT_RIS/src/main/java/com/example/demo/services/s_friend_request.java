package com.example.demo.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repositories.r_friend_request;

import model.FriendRequest;
import model.User;

import java.sql.Timestamp;
import java.util.List;

@Service
public class s_friend_request {
    
    @Autowired
    private r_friend_request r_friend_request;
    
    @Autowired
    private s_friendship s_friendship;
    
    public List<FriendRequest> get_pending_requests(User receiver) {
        return r_friend_request.findByIdUser2AndStatus(receiver, "PENDING");
    }

    public List<FriendRequest> get_sent_requests(User user) {
        return r_friend_request.findByIdUser1(user);
    }

    public List<FriendRequest> get_received_requests(User user) {
        return r_friend_request.findByIdUser2(user);
    }
    
    public void reject_request(Long requestId) {
        FriendRequest request = r_friend_request.findById(requestId).orElse(null);
        if (request != null) {
            request.setStatus("REJECTED");
            r_friend_request.save(request);
        }
    }
    
    public FriendRequest find_by_id(Long id) {
        return r_friend_request.findById(id).orElse(null);
    }
    

    public void delete_request(Long requestId) {
        r_friend_request.deleteById(requestId);
    }

    public FriendRequest send_request(User sender, User receiver) {
        FriendRequest existing = r_friend_request.findByIdUser1AndIdUser2(sender, receiver);
        if (existing != null) {
            return existing;
        }
        
        FriendRequest request = new FriendRequest();
        request.setIdUser1(sender);
        request.setIdUser2(receiver);
        request.setStatus("PENDING");
        request.setSentAt(new Timestamp(System.currentTimeMillis()));
        
        return r_friend_request.save(request);
    }
    
    public void accept_request(Long requestId) {
        FriendRequest request = r_friend_request.findById(requestId).orElse(null);
        if (request != null) {
            request.setStatus("ACCEPTED");
            r_friend_request.save(request);
            s_friendship.create_friendship(request.getIdUser1(), request.getIdUser2());
        }
    }
}