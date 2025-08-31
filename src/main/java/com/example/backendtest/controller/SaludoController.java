package com.example.backendtest.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class SaludoController {

    @GetMapping("/saludo")
    public String mostrarSaludo() {
        return "¡Hola! Bienvenido a la aplicación Spring Boot. Este es un saludo desde el controlador SaludoController.";
    }
    
    @GetMapping("/saludo/personalizado")
    public String saludoPersonalizado() {
        return "Aupa!!¡Saludos desde el endpoint personalizado! La aplicación está funcionando perfectamente.";
    }
} 