package com.example.demo.controllers;

import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperPrint;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.demo.services.s_report;

import jakarta.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/reports")//sve mape će imati prefiks "/messages"
public class c_report {
    
	//autowired se samo koristi da ne bih morao praviti konstruktor, već automatski instanciram Bean-ove
    @Autowired
    private s_report s_report;

    //metod služi za preuzimanje jasper reporta
    @GetMapping("/users")
    public void generateInventoryReport(HttpServletResponse response) throws Exception {
        JasperPrint jasperPrint = s_report.generate_inventory_report();
        response.setContentType("application/pdf");
        JasperExportManager.exportReportToPdfStream(jasperPrint, response.getOutputStream());
    }
}