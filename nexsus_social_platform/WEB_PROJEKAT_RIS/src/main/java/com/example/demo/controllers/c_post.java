package com.example.demo.controllers;

import model.Post;
import model.User;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.services.s_post;
import com.example.demo.services.s_user;

@Controller
public class c_post {
    
	//autowired se samo koristi da ne bih morao praviti konstruktor, već automatski instanciram Bean-ove
	
    @Autowired
    private s_post s_post;
    
    @Autowired
    private s_user s_user;
    
    //otvara stranicu za kreiranje novog posta
    @GetMapping("/posts/new")
    public String newPostForm(Authentication auth, Model model) {
        // Get current user from Spring Security
        User user = getCurrentUser(auth);
        if (user == null) {
            return "redirect:/login";
        }

        model.addAttribute("post", new Post());
        model.addAttribute("user", user);
        return "posts/post-form";
    }

    //prikazuje stranicu koja izlistava sve postove na ekran
    @GetMapping("/posts")
    public String listPosts(Authentication auth, Model model) {
        // Get current user from Spring Security
        User user = getCurrentUser(auth);
        if (user == null) {
            return "redirect:/login";
        }
        
        //izlistava postove
        model.addAttribute("posts", s_post.find_all());
        model.addAttribute("user", user);
        return "posts";
    }
    
    //izlistava samo postove trenutno ulogovanog korisnika na stranici my-posts iz foldera posts
    @GetMapping("/posts/my")
    public String myPosts(Authentication auth, Model model) {
        // Get current user from Spring Security
        User user = getCurrentUser(auth);
        if (user == null) {
            return "redirect:/login";
        }
        
      //izlistava postove
        model.addAttribute("posts", s_post.find_by_user(user.getId()));
        model.addAttribute("user", user);
        return "posts/my-posts";
    }
    
    //isto funkcioniše kao i newPostForm metod koji je gore definisan, samo se ovaj poziva kad kliknemo na edit post
    @GetMapping("/posts/edit/{id}")
    public String editPostForm(@PathVariable Long id, Authentication auth, Model model) {
    	User user = getCurrentUser(auth);
        if (user == null) {
            return "redirect:/login";
        }
        
        Post post = s_post.find_by_id(id);
        if (post == null || post.getIdUser().getId() != user.getId()) { // Use != for primitive long
            return "redirect:/posts/my";
        }
        
        model.addAttribute("post", post);
        model.addAttribute("user", user);
        return "posts/post-form";
    }
    
    //pokreće se kad kliknemo na dugme "Kreiraj" na stranici za pravljenje novog posta
    @PostMapping("/posts/save")
    public String savePost(@ModelAttribute Post post, Authentication auth, RedirectAttributes redirectAttributes) {
        // Get current user from Spring Security
    	User user = getCurrentUser(auth);
        if (user == null) {
            return "redirect:/login";
        }
        
        try {
            
            
            post.setIdUser(user);
            Post savedPost = s_post.save(post);
            
            
            if (post.getId() == 0) { // Use == for primitive long comparison
                redirectAttributes.addFlashAttribute("success", "Post created successfully!");
            } else {
                redirectAttributes.addFlashAttribute("success", "Post updated successfully!");
            }
            
            return "redirect:/posts/my";
        } catch (Exception e) {
            System.out.println("ERROR saving post: " + e.getMessage());
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Error saving post: " + e.getMessage());
            return "redirect:/posts/my";
        }
    }
    
    //pokreće se kad kliknemo na "delete post"
    @GetMapping("/posts/delete/{id}")
    public String deletePost(@PathVariable Long id, Authentication auth) {
        // Get current user from Spring Security
        User user = getCurrentUser(auth);
        if (user == null) {
            return "redirect:/login";
        }
        
        //pronalazi u bazi post koji hoćemo da obrišemo
        Post post = s_post.find_by_id(id);
        if (post != null && post.getIdUser().getId() == user.getId()) { // ako postoji obriši ga
            s_post.delete(id);
        }
        
        return "redirect:/posts/my"; //refrešaj stranicu na kojoj se trenutno nalazimo
    }
    
    // Dobavalja informacije o trenutno ulogovanom korisniku (ime, id, poruke, prijatelje, postove, da li je USER ili ADMIN)    
    private User getCurrentUser(Authentication auth) {
        if (auth == null || !auth.isAuthenticated()) {
            return null;
        }
        String username = auth.getName();
        return s_user.find_by_username(username);
    }
}