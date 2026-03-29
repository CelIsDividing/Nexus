package com.example.demo.controllers;

import model.User;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.services.s_friend_request;
import com.example.demo.services.s_friendship;
import com.example.demo.services.s_user;

@Controller
@RequestMapping("/friends") //sve mape će imati prefiks "/friends"
public class c_friend {
    
	//autowired se samo koristi da ne bih morao praviti konstruktor, već automatski instanciram Bean-ove
    @Autowired
    private s_friend_request s_friend_request;
    
    @Autowired
    private s_user s_user;

    @Autowired
    private s_friendship s_friendship;
    
    //metod otvara stranicu friends iz foldera "friends"
    @GetMapping
    public String friendsPage(Authentication auth, Model model) {
    	//proverava da li je korisnik USER ili ADMIN
    	User user = getCurrentUser(auth);
        
    	//dobavlja sve userove (koji je definisan u redu iznad) podatke iz baze i setuje 
    	//ih u model atribute (zahteve, prijateljstva, ostale korisnike)
    	model.addAttribute("user", user);
        model.addAttribute("pendingRequests", s_friend_request.get_pending_requests(user));
        model.addAttribute("friends", s_friendship.get_friends(user));
        model.addAttribute("allUsers", s_user.find_all().stream()
            .filter(u -> u.getId() != user.getId())
            .toList());
        
        return "friends/friends";
    }
    
    // Dobavalja informacije o trenutno ulogovanom korisniku (ime, id, poruke, prijatelje, postove, da li je USER ili ADMIN)
    private User getCurrentUser(Authentication auth) {
        if (auth == null || !auth.isAuthenticated()) {
            return null;
        }
        String username = auth.getName();
        return s_user.find_by_username(username);
    }

    //metod se izvrši kada kliknemo na dugme "Send friend request" na friends stranici
    @PostMapping("/request/send")
    public String sendFriendRequest(@RequestParam Long receiverId, Authentication auth,
            RedirectAttributes redirectAttributes) {
    	User sender = getCurrentUser(auth);
        
    	//šalje poziv za prijateljstvo
        User receiver = s_user.find_by_id(receiverId);
        if (receiver != null) {
            s_friend_request.send_request(sender, receiver);
        }
        
        //ako korisnik kom je poslato više ne postoji, refrešaj stranicu i baci grešku
        if (receiver == null) {
            redirectAttributes.addFlashAttribute("error", "User not found");
            return "redirect:/friends"; //redirect:/ vraća mapu, a ne .jsp stranicu
        }
        
        s_friend_request.send_request(sender, receiver);
        redirectAttributes.addFlashAttribute("success", "Friend request sent successfully");
                
        return "redirect:/friends"; //redirect:/ vraća mapu, a ne .jsp stranicu
    }
    
    //metod se pokreće kada prihvatimo nečiji poziv za prijateljstvo
    @PostMapping("/request/accept/{id}")
    public String acceptFriendRequest(@PathVariable Long id, Authentication auth) {
    	User user = getCurrentUser(auth);
        
        s_friend_request.accept_request(id);
        return "redirect:/friends";
    }
    
  //metod se pokreće kada odbijemo nečiji poziv za prijateljstvo
    @PostMapping("/request/reject/{id}")
    public String rejectFriendRequest(@PathVariable Long id, Authentication auth) {
    	User user = getCurrentUser(auth);
        
        s_friend_request.reject_request(id);
        return "redirect:/friends";
    }
}