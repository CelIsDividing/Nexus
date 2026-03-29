package com.example.demo.controllers;

import model.User;
import model.FriendRequest;
import model.Friendship;
import model.Message;
import model.Post;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.services.s_user;
import com.example.demo.services.s_friend_request;
import com.example.demo.services.s_friendship;
import com.example.demo.services.s_message;
import com.example.demo.services.s_post;

import java.util.List;


@Controller
@RequestMapping("/admin") //sve mape će imati prefiks "/admin"
public class c_admin {
    
	//autowired se samo koristi da ne bih morao praviti konstruktor, već automatski instanciram Bean-ove
    @Autowired
    private s_user s_user;
    
    @Autowired
    private s_message s_message;
    
    @Autowired
    private s_post s_post;

    @Autowired
    private s_friend_request s_friend_request;
    
    @Autowired
    private s_friendship s_friendship;
    
  //metod vraća .jsp stranicu users.jsp iz foldera admin
    @GetMapping("/users")
    public String adminUsersPage(Authentication auth, Model model) {
        User currentUser = getCurrentUser(auth);
        
        
        //dobavlja sve usere iz baze i setuje ih u model atribute
        List<User> allUsers = s_user.find_all();
        model.addAttribute("user", currentUser);
        model.addAttribute("users", allUsers);
        model.addAttribute("currentUser", currentUser);
        
        return "admin/users"; 
    }

    // Dobavalja informacije o trenutno ulogovanom korisniku (ime, id, poruke, prijatelje, postove, da li je USER ili ADMIN)
    private User getCurrentUser(Authentication auth) {
        if (auth == null || !auth.isAuthenticated()) {
            return null;
        }
        String username = auth.getName();
        return s_user.find_by_username(username);
    }
    
    //kada kliknemo dugme obriši na admin stranici, pokrenuće se ovaj metod
    @PostMapping("/users/delete/{userId}")
    public String deleteUser(@PathVariable Long userId, 
                           Authentication auth,
                           RedirectAttributes redirectAttributes) {
        User currentUser = getCurrentUser(auth);
        
        
        
        // Sprečava admina da obriše samog sebe
        if (currentUser.getId() == userId) {
            redirectAttributes.addFlashAttribute("error", "You cannot delete your own account!");
            return "redirect:/admin/users";
        }
        
        try {
            User userToDelete = s_user.find_by_id(userId);
            if (userToDelete != null) {
                // Briše sve veze korisnika pre nego što obriše samog korisnika (metod definisan ispod ovog metoda)
                deleteUserRelationships(userToDelete);
                
                // Briše korisnika
                s_user.delete_user(userId);
                
                redirectAttributes.addFlashAttribute("success", 
                    "User '" + userToDelete.getUsername() + "' has been deleted successfully!");
            } else {
                redirectAttributes.addFlashAttribute("error", "User not found!");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", 
                "Error deleting user: " + e.getMessage());
            e.printStackTrace(); // Log the error for debugging
        }
        
        return "redirect:/admin/users";
    }
    
    /**
     * Briše sve veze korisnika pre nego što obriše samog korisnika
     */
    private void deleteUserRelationships(User user) {
        Long userId = user.getId();
        
        // 1. Delete friend requests where user is sender (idUser1)
        List<FriendRequest> sentRequests = s_friend_request.get_sent_requests(user);
        for (FriendRequest request : sentRequests) {
            s_friend_request.delete_request(request.getId());
        }
        
        // 2. Delete friend requests where user is receiver (idUser2)
        List<FriendRequest> receivedRequests = s_friend_request.get_received_requests(user);
        for (FriendRequest request : receivedRequests) {
            s_friend_request.delete_request(request.getId());
        }
        
        // 3. Delete friendships where user is user1
        List<Friendship> friendshipsAsUser1 = s_friendship.get_friendships_as_user1(user);
        for (Friendship friendship : friendshipsAsUser1) {
            s_friendship.delete_friendship(friendship.getId());
        }
        
        // 4. Delete friendships where user is user2
        List<Friendship> friendshipsAsUser2 = s_friendship.get_friendships_as_user2(user);
        for (Friendship friendship : friendshipsAsUser2) {
            s_friendship.delete_friendship(friendship.getId());
        }
        
        // 5. Delete messages where user is sender (idUser1)
        List<Message> sentMessages = s_message.get_messages_by_sender(user);
        for (Message message : sentMessages) {
            s_message.delete_message(message.getId());
        }
        
        // 6. Delete messages where user is receiver (idUser2)
        List<Message> receivedMessages = s_message.get_messages_by_receiver(user);
        for (Message message : receivedMessages) {
            s_message.delete_message(message.getId());
        }
        
        // 7. Delete user's posts
        List<Post> userPosts = s_post.find_by_user(user);
        for (Post post : userPosts) {
            s_post.delete_post(post.getId());
        }
    }
}