<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="tn.enit.entities.ServiceMedical" %>
<%@ page import="java.util.List" %>

<%
    // Récupération de la liste envoyée par le Contrôleur
    List<ServiceMedical> services = (List<ServiceMedical>) request.getAttribute("listeServices");
    tn.enit.entities.Patient p = (tn.enit.entities.Patient) session.getAttribute("patientConnecte");

%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Nos Soins - Smile Everyday</title>
    <link rel="stylesheet" type="text/css" href="mesStyles.css">
    
    <style>
        /* --- CONFIGURATION HARMONISÉE --- */
        html, body { margin: 0; padding: 0; height: 100%; overflow-x: hidden; font-family: 'Segoe UI', Arial, sans-serif; font-size: 16px; }

        /* FOND ANIMÉ */
        .slideshow {
    position: fixed; 
    width: 100%; 
    height: 100%; 
    top: 0; 
    left: 0;
    z-index: -1; 
    list-style: none; 
    margin: 0; 
    padding: 0;
    background-color: white; /* Fond blanc pour plus de luminosité */
}

.slideshow li {
    width: 100%; 
    height: 100%; 
    position: absolute; 
    top: 0; 
    left: 0;
    background-size: cover; 
    background-position: center;
    opacity: 0; 
    z-index: 0;
    filter: blur(1px); /* Flou très léger pour garder la netteté */
    /* 28s pour 7 images = 4s par image pour un rythme dynamique et fluide */
    animation: imageAnimation 28s linear infinite; 
}

/* Délais précis pour 7 images */
.slideshow li:nth-child(1) { animation-delay: 0s; }
.slideshow li:nth-child(2) { animation-delay: 4s; }
.slideshow li:nth-child(3) { animation-delay: 8s; }
.slideshow li:nth-child(4) { animation-delay: 12s; }
.slideshow li:nth-child(5) { animation-delay: 16s; }
.slideshow li:nth-child(6) { animation-delay: 20s; }
.slideshow li:nth-child(7) { animation-delay: 24s; }

@keyframes imageAnimation { 
    0% { 
        opacity: 0; 
        transform: scale(1.0); 
    }
    /* Apparition fluide vers la clarté totale */
    8% { 
        opacity: 1; /* Photo totalement claire et lumineuse */
    }
    /* Maintien de l'image bien visible */
    14.28% { 
        opacity: 1; 
    }
    /* Transition "Smooth" vers la suivante */
    22% { 
        opacity: 0; 
        transform: scale(1.03); /* Très léger zoom pour la fluidité */
    }
    100% { 
        opacity: 0; 
    }
}
        /* HEADER TRANSPARENT */
        .header { position: fixed; top: 0; left: 0; width: 100%; height: 90px; background: transparent; display: flex; justify-content: center; align-items: center; padding: 0 40px; z-index: 1000; box-sizing: border-box; }
        .logo { position: absolute; left: 40px; font-size: 1.8em; font-weight: bold; color: white; text-transform: uppercase; text-shadow: 2px 2px 4px rgba(0,0,0,0.5); }
        .logo span { color: #2ecc71; }

        /* MENU */
        .nav-links { list-style: none; display: flex; gap: 30px; margin: 0; padding: 0; background: rgba(0,0,0,0.3); padding: 10px 30px; border-radius: 50px; backdrop-filter: blur(5px); }
        .nav-links a { text-decoration: none; color: white; font-weight: 600; font-size: 16px; transition: 0.3s; text-shadow: 1px 1px 2px black; }
        .nav-links a:hover { color: #2ecc71; transform: scale(1.1); }

        /* BOUTON RETOUR */
        .btn-logout-header { position: absolute; right: 40px; background-color: #3498db; color: white; padding: 8px 20px; border-radius: 25px; text-decoration: none; font-weight: bold; font-size: 14px; box-shadow: 0 4px 10px rgba(0,0,0,0.3); transition: 0.3s; }
        .btn-logout-header:hover { background-color: #2980b9; transform: translateY(-2px); }

        /* --- CONTENU --- */
        .container { max-width: 1200px; margin: 140px auto 50px auto; padding: 0 20px; }
        
        .page-title { text-align: center; color: white; text-shadow: 2px 2px 5px rgba(0,0,0,0.5); font-size: 2.5em; margin-bottom: 40px; font-weight: 800; }

        /* GRILLE DE CARTE */
        .grid-services { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 30px; }

        /* CARTE SERVICE EN VERRE */
        .service-card {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(15px);
            border-radius: 20px; padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            border: 1px solid rgba(255,255,255,0.6);
            transition: 0.3s; text-align: center; position: relative; overflow: hidden;
        }
        .service-card:hover { transform: translateY(-10px); box-shadow: 0 20px 40px rgba(0,0,0,0.2); }
        .service-card::top { height: 5px; width: 100%; background: #2ecc71; position: absolute; top: 0; left: 0; }

        .icon-circle { width: 70px; height: 70px; background: #e8f8f5; border-radius: 50%; margin: 0 auto 15px; display: flex; align-items: center; justify-content: center; font-size: 30px; color: #2ecc71; border: 2px solid #2ecc71; }
        
        h3 { color: #2c3e50; margin: 10px 0; font-size: 1.4em; }
        .category { font-size: 0.9em; color: #3498db; font-weight: bold; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 15px; display: block; }
        
        .price-tag { font-size: 1.8em; color: #27ae60; font-weight: bold; display: block; margin: 15px 0; }
        .desc { color: #555; font-size: 0.95em; line-height: 1.5; min-height: 50px; }
        
        .empty-msg { text-align: center; color: white; font-size: 1.5em; background: rgba(0,0,0,0.5); padding: 20px; border-radius: 10px; }

    </style>
</head>
<body>

    <ul class="slideshow">
        <li style="background-image: url('<%= request.getContextPath() %>/images/image2.png');"></li>
        <li style="background-image: url('<%= request.getContextPath() %>/images/image3.png');"></li>
        <li style="background-image: url('<%= request.getContextPath() %>/images/image6.png');"></li>
        <li style="background-image: url('<%= request.getContextPath() %>/images/image11.png');"></li>
        <li style="background-image: url('<%= request.getContextPath() %>/images/image12.png');"></li>
        <li style="background-image: url('<%= request.getContextPath() %>/images/image13.png');"></li>
    </ul>
    <div class="header">
        <div class="logo">Smile <span>Everyday</span></div>
        <ul class="nav-links">
             <li><a href="EspacePatient.jsp">Mon Espace</a></li>
            <li><a href="Controleur?action=voirProfil">⚙️ Mon Profil</a></li>
            
            <li><a href="Controleur?action=voirDossier&idPatient=<%= p.getIdP() %>">📂 Mon Dossier</a></li>
            
            <li><a href="Controleur?action=listerServices">🏥 Voir les Services</a></li>
            <li><a href="rendezvous.jsp">📅 Nouveau RDV</a></li>
            <li><a href="Controleur?action=murPublications" class="active">📰 Actualités</a></li>
        </ul>
        <a href="EspacePatient.jsp" class="btn-logout-header">← Retour</a>
    </div>

    <div class="container">
        <h1 class="page-title">Nos Soins et Tarifs</h1>

        <% if (services == null || services.isEmpty()) { %>
            <div class="empty-msg">Aucun service n'est disponible pour le moment.</div>
        <% } else { %>
            <div class="grid-services">
                <% for (ServiceMedical s : services) { %>
                    <div class="service-card">
                        <div style="height:5px; width:100%; background:#2ecc71; position:absolute; top:0; left:0;"></div>
                        <div class="icon-circle">🦷</div>
                        
                        <span class="category"><%= s.getTypeService() %></span>
                        <h3><%= s.getNomService() %></h3>
                        
                        <div class="desc">
                            <%= (s.getDescriptionService() != null) ? s.getDescriptionService() : "Soins dentaires de qualité." %>
                        </div>

                        <span class="price-tag"><%= s.getTarifService() %> DT</span>
                        
                        <div style="font-size:0.9em; color:#7f8c8d;">
                            Durée estimée : <b><%= s.getNbSeances() %> séance(s)</b>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>

</body>
</html>