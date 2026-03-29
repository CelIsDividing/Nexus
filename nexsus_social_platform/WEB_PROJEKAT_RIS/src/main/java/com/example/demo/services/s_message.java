package com.example.demo.services;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repositories.r_message;

import model.Message;
import model.User;

import java.sql.Timestamp;
import java.util.List;

@Service
public class s_message {
    
    @Autowired
    private r_message r_message;
    
    @Autowired
    private s_friendship s_friendship;
    
    public List<Message> get_messages_by_receiver(User user) {
        return r_message.findByIdUser2(user);
    }
    
    public List<Message> get_conversation(User user1, User user2) {
    	return r_message.findConversationBetweenUsers(user1, user2);
    }
    
    public List<Message> get_messages_by_sender(User user) {
        return r_message.findByIdUser1(user);
    }

    public void delete_message(Long messageId) {
        r_message.deleteById(messageId);
    }
    
    public Message send_message(User sender, User receiver, String content) {
        if (!s_friendship.are_friends(sender, receiver)) {
            throw new RuntimeException("Can only message friends");
        }
        
        Message message = new Message();
        message.setIdUser1(sender);
        message.setIdUser2(receiver);
        message.setContent(content);
        message.setSentAt(new Timestamp(System.currentTimeMillis()));
        
        return r_message.save(message);
    }
}