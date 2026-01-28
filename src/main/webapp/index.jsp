<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="tn.enit.entities.Patient" %>

<%
    Patient p = (Patient) session.getAttribute("patientConnecte");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Accueil - Smile Everyday</title>
    <link rel="stylesheet" type="text/css" href="mesStyles.css">
    
    <style>
        /* --- 1. CONFIGURATION DE BASE --- */
        html, body {
            margin: 0; padding: 0; height: 100%; overflow-x: hidden;
            font-family: 'Segoe UI', Arial, sans-serif;
        }

        /* --- 2. FOND D'ÉCRAN ANIMÉ --- */
/* --- 2. FOND D'ÉCRAN ANIMÉ (CORRIGÉ POUR 7 IMAGES) --- */
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
        /* --- 3. HEADER TRANSPARENT (STYLE HARMONISÉ) --- */
        .header {
            position: fixed; top: 0; left: 0; width: 100%; height: 90px;
            background: transparent; /* FOND TRANSPARENT */
            display: flex; 
            justify-content: center; /* Centre le menu */
            align-items: center;
            padding: 0 40px;
            z-index: 1000;
            box-sizing: border-box;
        }

        /* Logo Blanc pour le fond sombre */
        .logo { 
            position: absolute; left: 40px;
            font-size: 1.8em; font-weight: bold; color: white; 
            text-transform: uppercase; 
            text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
        }
        .logo span { color: #2ecc71; } /* Vert */

        /* Menu en Pilule sombre */
        .nav-links { 
            list-style: none; display: flex; gap: 30px; margin: 0; padding: 0; 
            background: rgba(0,0,0,0.3); /* Fond sombre transparent */
            padding: 10px 30px; border-radius: 50px; 
            backdrop-filter: blur(5px);
        }
        .nav-links a { 
            text-decoration: none; color: white; font-weight: 600; font-size: 16px; 
            transition: 0.3s; text-shadow: 1px 1px 2px black;
        }
        .nav-links a:hover, .nav-links a.active { color: #2ecc71; transform: scale(1.1); }

        /* Recherche */
        .search-wrapper { position: absolute; right: 40px; }
        .search-box {
            display: flex; align-items: center; 
            border: none; border-radius: 25px; overflow: hidden; 
            background-color: rgba(255,255,255,0.9); /* Blanc semi-transparent */
            padding: 0; box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        }
        .search-box input { border: none; padding: 8px 15px; outline: none; font-size: 14px; width: 180px; background: transparent; }
        .search-btn { border: none; background-color: #2ecc71; color: white; padding: 8px 15px; cursor: pointer; font-weight: bold; height: 100%; }
        .search-btn:hover { background-color: #27ae60; }

        /* --- 4. CONTENU CENTRAL --- */
        .welcome-box {
            background-color: rgba(255, 255, 255, 0.85) !important; 
            backdrop-filter: blur(15px);
            max-width: 700px;
            margin: 200px auto 50px auto; /* Marge augmentée pour l'harmonie */
            padding: 50px;
            border-radius: 20px;
            border: 1px solid rgba(255,255,255,0.6);
            box-shadow: 0 20px 50px rgba(0,0,0,0.3);
            text-align: center;
            animation: slideUp 1s ease-out forwards;
        }
        @keyframes slideUp { from { transform: translateY(80px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }

        .welcome-box h1 { color: #2c3e50; margin-bottom: 10px; font-size: 3em; font-weight: 800; }
        .welcome-box h2 { font-size: 1.4em; color: #7f8c8d; font-weight: normal; margin-bottom: 40px; }
        .welcome-box p { font-size: 1.1em; color: #444; margin-bottom: 30px; line-height: 1.6; }

        /* Boutons principaux */
        .btn-big-green {
            padding: 15px 35px; border: none; border-radius: 50px;
            background: linear-gradient(45deg, #2ecc71, #27ae60);
            color: white; font-size: 18px; font-weight: bold;
            cursor: pointer; transition: 0.3s; text-decoration: none; display: inline-block;
            box-shadow: 0 10px 20px rgba(46, 204, 113, 0.3);
        }
        .btn-big-green:hover { transform: translateY(-3px); box-shadow: 0 15px 25px rgba(46, 204, 113, 0.4); }

        .btn-big-blue {
            padding: 15px 35px; border: none; border-radius: 50px;
            background: linear-gradient(45deg, #3498db, #2980b9);
            color: white; font-size: 18px; font-weight: bold;
            cursor: pointer; transition: 0.3s; text-decoration: none; display: inline-block;
            box-shadow: 0 10px 20px rgba(52, 152, 219, 0.3);
            margin-right: 15px;
        }
        .btn-big-blue:hover { transform: translateY(-3px); box-shadow: 0 15px 25px rgba(52, 152, 219, 0.4); }
        
        .footer-links { margin-top: 40px; padding-top: 20px; border-top: 1px solid rgba(0,0,0,0.1); font-size: 0.9em; color: #666; }
        .footer-links a { color: #34495e; text-decoration: none; margin-left: 5px; font-weight: bold; border-bottom: 1px dashed #999; }
        .footer-links a:hover { color: #2ecc71; border-bottom-color: #2ecc71; }

    </style>
</head>
<body>

    <ul class="slideshow">
        <li style="background-image: url('<%= request.getContextPath() %>/images/image2.png');"></li>
        <li style="background-image: url('<%= request.getContextPath() %>/images/image3.png');"></li>
        <li style="background-image: url('<%= request.getContextPath() %>/images/image5.png');"></li>
        <li style="background-image: url('<%= request.getContextPath() %>/images/image6.png');"></li>
        <li style="background-image: url('<%= request.getContextPath() %>/images/image11.png');"></li>
        <li style="background-image: url('<%= request.getContextPath() %>/images/image12.png');"></li>
        <li style="background-image: url('<%= request.getContextPath() %>/images/image13.png');"></li>
    </ul>

    <div class="header">
        
        <div class="logo">Smile <span>Everyday</span></div> 
        
        <ul class="nav-links">
            <li><a href="index.jsp" class="active">Accueil</a></li>
            <li><a href="connexion.jsp">Connexion</a></li>
            <li><a href="patient.jsp">Fiche Patient</a></li>
            <li><a href="AideSoignant.jsp">Aide-Soignant</a></li>

            <% if (p != null) { %>
                <li><a href="Service.jsp">Services</a></li>
                <li><a href="rendezvous.jsp">Rendez-vous</a></li>
                <li><a href="Publication.jsp">Publications</a></li>
            <% } %>
            <li><a href="connexionDentiste.jsp">Médecin</a></li>
        </ul>
    
        <div class="search-wrapper">
            <div class="search-box">
                <input type="text" placeholder="Rechercher...">
                <button class="search-btn">🔍</button>
            </div>
        </div>
    </div>

    <div class="welcome-box">
        <h1>"Un sourire en un clic"</h1>
        <h2>Simplifiez vos rendez-vous dentaires !</h2>

        <% if (p == null) { %>
            <p>Bienvenue sur notre plateforme moderne de gestion dentaire.<br>Connectez-vous pour gérer vos soins en toute simplicité.</p>

            <div style="margin-top: 30px;">
                <a href="connexion.jsp" class="btn-big-blue">Se Connecter</a>
                <a href="patient.jsp" class="btn-big-green">S'inscrire</a>
            </div>
            
            <div class="footer-links">
                Vous êtes un professionnel de santé ?
                <a href="AideSoignant.jsp">Rejoindre l'équipe (Aide-Soignant)</a>
            </div>

        <% } else { %>
            <h3 style="color: #27ae60; font-size: 1.5em; margin-top:0;">Bonjour, <%= p.getPrenomP() %> !</h3>
            <p>Votre espace personnel est prêt.</p>

            <div style="margin-top: 20px;">
                <a href="rendezvous.jsp" class="btn-big-green">📅 PRENDRE RDV</a>
            </div>
            
            <div style="margin-top: 20px;">
                <a href="EspacePatient.jsp" class="btn-big-blue" style="font-size: 16px; padding: 12px 25px;">
                    👤 Mon Tableau de Bord
                </a>
            </div>

            <br>
            <a href="Controleur?action=deconnexion" style="color: #e74c3c; font-weight: bold; text-decoration:none; font-size: 0.9em; border-bottom: 1px solid #e74c3c;">Se déconnecter</a>
        <% } %>
    </div>

</body>
</html>