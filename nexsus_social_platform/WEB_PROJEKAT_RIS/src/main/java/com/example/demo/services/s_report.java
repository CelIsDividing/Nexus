package com.example.demo.services;

import com.example.demo.repositories.r_user;

import model.User;
import net.sf.jasperreports.engine.*;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.HashMap;
import java.util.List;

@Service
public class s_report {

    @Autowired
    private r_user r_user;

    public JasperPrint generate_inventory_report() throws JRException {
        List<User> users = r_user.findAll();
        JRBeanCollectionDataSource dataSource = new JRBeanCollectionDataSource(users);
        
        JasperReport report = JasperCompileManager.compileReport(
            getClass().getResourceAsStream("/jasperreports/report.jrxml")
        );
        
        return JasperFillManager.fillReport(report, new HashMap<>(), dataSource);
    }
}