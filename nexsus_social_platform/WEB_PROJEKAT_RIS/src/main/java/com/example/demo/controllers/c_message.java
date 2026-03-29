package com.example.demo.controllers;

import jakarta.servlet.http.HttpSession;
import model.Message;
import model.User;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.example.demo.services.s_friendship;
import com.example.demo.services.s_message;
import com.example.demo.services.s_user;

import java.util.List;

@Controller
@RequestMapping("/messages") //sve mape će imati prefiks "/messages"
public class c_message {
    
	//autowired se samo koristi da ne bih morao praviti konstruktor, već automatski instanciram Bean-ove
	
    @Autowired
    private s_friendship s_friendship;

    @Autowired
    private s_message s_message;
    
    @Autowired
    private s_user s_user;
    
    //prikazuje .jsp stranicu sa porukama
    @GetMapping
    public String messagesPage(Authentication auth, Model model) {
    	User user = getCurrentUser(auth);
        
    	model.addAttribute("user", user);
        model.addAttribute("friends", s_friendship.get_friends(user));
        return "friends/messages";
    }
    
    // Dobavalja informacije o trenutno ulogovanom korisniku (ime, id, poruke, prijatelje, postove, da li je USER ili ADMIN)
    private User getCurrentUser(Authentication auth) {
        if (auth == null || !auth.isAuthenticated()) {
            return null;
        }
        String username = auth.getName();
        return s_user.find_by_username(username);
    }

    //prikazuje stranicu četa sa korisnikom čiji je id {friendId}
    @GetMapping("/conversation/{friendId}")
    public String conversation(@PathVariable Long friendId, Authentication auth, Model model) {
    	User user = getCurrentUser(auth);
        
    	//ako prijatelj više ne postoji ili više nije prijatelj sa trenutnim korisnikom, refrešaj stranicu
        User friend = s_user.find_by_id(friendId);
        if (friend == null || !s_friendship.are_friends(user, friend)) {
            return "redirect:/messages";
        }
        
        //izlistava sve poruke na ekran
        List<Message> conversation = s_message.get_conversation(user, friend);
        model.addAttribute("user", user);
        model.addAttribute("conversation", conversation);
        model.addAttribute("friend", friend);
        model.addAttribute("friends", s_friendship.get_friends(user));
        
        return "friends/conversation";
    }
    
    //šalje poruku prijatelju kada kliknemo na dugme send
    @PostMapping("/send")
    public String sendMessage(@RequestParam Long receiverId, 
                             @RequestParam String content, 
                             Authentication auth) {
    	User sender = getCurrentUser(auth);
        
    	//provera da li prijatelj i da li poruka nije prazna
        User receiver = s_user.find_by_id(receiverId);
        if (receiver != null && !content.trim().isEmpty()) {
            s_message.send_message(sender, receiver, content.trim());
        }
        
        return "redirect:/messages/conversation/" + receiverId;
    }
}