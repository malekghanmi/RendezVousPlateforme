<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="tn.enit.entities.Patient" %>
<%@ page import="tn.enit.entities.Publication" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    Patient p = (Patient) session.getAttribute("patientConnecte");
    if (p == null) {
        response.sendRedirect("connexion.jsp");
        return;
    }

    List<Publication> lesPubs = (List<Publication>) request.getAttribute("lesPubs");
    if (lesPubs == null) lesPubs = new ArrayList<>();

    SimpleDateFormat sdf = new SimpleDateFormat("dd MMMM yyyy");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Fil d'Actualités - Smile Everyday</title>
    <style>
        /* --- CONFIGURATION DE BASE --- */
        html, body { margin: 0; padding: 0; height: 100%; overflow-x: hidden; font-family: 'Segoe UI', Arial, sans-serif; font-size: 16px; }

        /* --- FOND D'ÉCRAN ANIMÉ (Identique aux autres pages) --- */
        .slideshow {
            position: fixed; width: 100%; height: 100%; top: 0; left: 0; z-index: -1; 
            list-style: none; margin: 0; padding: 0; background-color: white;
        }
        .slideshow li {
            width: 100%; height: 100%; position: absolute; top: 0; left: 0;
            background-size: cover; background-position: center; opacity: 0; 
            filter: blur(1px); animation: imageAnimation 28s linear infinite; 
        }
        .slideshow li:nth-child(1) { animation-delay: 0s; background-image: url('<%= request.getContextPath() %>/images/image2.png'); }
        .slideshow li:nth-child(2) { animation-delay: 4s; background-image: url('<%= request.getContextPath() %>/images/image3.png'); }
        .slideshow li:nth-child(3) { animation-delay: 8s; background-image: url('<%= request.getContextPath() %>/images/image6.png'); }
        .slideshow li:nth-child(4) { animation-delay: 12s; background-image: url('<%= request.getContextPath() %>/images/image11.png'); }
        .slideshow li:nth-child(5) { animation-delay: 16s; background-image: url('<%= request.getContextPath() %>/images/image12.png'); }
        .slideshow li:nth-child(6) { animation-delay: 20s; background-image: url('<%= request.getContextPath() %>/images/image13.png'); }

        @keyframes imageAnimation { 
            0% { opacity: 0; transform: scale(1.0); }
            8% { opacity: 1; }
            14.28% { opacity: 1; }
            22% { opacity: 0; transform: scale(1.03); }
            100% { opacity: 0; }
        }

        /* --- HEADER TRANSPARENT STYLE MÉDECIN --- */
        .header {
            position: fixed; top: 0; left: 0; width: 100%; height: 90px;
            background: transparent; display: flex; justify-content: center; align-items: center;
            padding: 0 40px; z-index: 1000; box-sizing: border-box;
        }
        .logo { position: absolute; left: 40px; font-size: 1.8em; font-weight: bold; color: white; text-transform: uppercase; text-shadow: 2px 2px 4px rgba(0,0,0,0.5); }
        .logo span { color: #2ecc71; }

        .nav-links { 
            list-style: none; display: flex; gap: 30px; margin: 0; padding: 0; 
            background: rgba(0,0,0,0.3); padding: 10px 30px; border-radius: 50px; 
            backdrop-filter: blur(5px);
        }
        .nav-links a { text-decoration: none; color: white; font-weight: 600; font-size: 16px; transition: 0.3s; text-shadow: 1px 1px 2px black; }
        .nav-links a:hover, .nav-links a.active { color: #2ecc71; transform: scale(1.1); }

        .logout-btn { position: absolute; right: 40px; background-color: #e74c3c; color: white; padding: 8px 20px; border-radius: 25px; text-decoration: none; font-weight: bold; font-size: 14px; box-shadow: 0 4px 10px rgba(0,0,0,0.3); }

        /* --- CONTENEUR --- */
        .feed-container { max-width: 800px; margin: 120px auto 50px auto; padding: 0 20px; }

        /* --- CARTE PUBLICATION (GLASS CARD) --- */
        .post-card {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            margin-bottom: 40px;
            overflow: hidden;
            border: 1px solid rgba(255,255,255,0.7);
            animation: slideUp 0.6s ease-out;
        }
        @keyframes slideUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }

        .post-header { padding: 20px; display: flex; align-items: center; border-bottom: 1px solid rgba(0,0,0,0.05); }
        .post-avatar { width: 45px; height: 45px; background: linear-gradient(45deg, #2ecc71, #27ae60); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold; margin-right: 15px; font-size: 22px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        
        .post-info h4 { margin: 0; color: #2c3e50; font-size: 17px; font-weight: 700; }
        .post-info span { font-size: 13px; color: #7f8c8d; }

        .post-content { padding: 25px; color: #2c3e50; }
        .post-title-big { font-size: 1.6em; font-weight: 800; margin-bottom: 15px; display: block; color: #2c3e50; border-left: 5px solid #2ecc71; padding-left: 15px; }
        .post-text { font-size: 16px; line-height: 1.6; color: #34495e; }

        .post-image-container { width: 100%; border-top: 1px solid rgba(0,0,0,0.05); background: #f9f9f9; }
        .post-image { width: 100%; display: block; max-height: 500px; object-fit: contain; background: #000; }

        h2.main-title { text-align: center; color: white; font-size: 2.2em; margin-bottom: 40px; text-shadow: 2px 2px 8px rgba(0,0,0,0.5); text-transform: uppercase; letter-spacing: 2px; }

    </style>
</head>
<body>

    <ul class="slideshow">
        <li></li><li></li><li></li><li></li><li></li><li></li>
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
        <a href="${pageContext.request.contextPath}/Controleur?action=deconnexion" class="logout-btn">Déconnexion</a>
    </div>

    <div class="feed-container">
        
        <h2 class="main-title">📰 Fil d'Actualités</h2>

        <% if (lesPubs.isEmpty()) { %>
            <div class="post-card" style="padding: 50px; text-align: center;">
                <h3 style="color: #7f8c8d;">Aucune actualité n'est disponible pour le moment.</h3>
            </div>
        <% } else { 
            for (Publication pub : lesPubs) { %>
            
            <div class="post-card">
                <div class="post-header">
                    <div class="post-avatar">S</div>
                    <div class="post-info">
                        <h4>Cabinet Smile Everyday</h4>
                        <span>📅 <%= (pub.getDatePub() != null) ? sdf.format(pub.getDatePub()) : "Date inconnue" %></span>
                    </div>
                </div>

                <div class="post-content">
                    <span class="post-title-big"><%= pub.getTitre() %></span>
                    <div class="post-text"><%= pub.getContenu() %></div>
                </div>

                <% if (pub.getImage() != null && !pub.getImage().isEmpty()) { %>
                    <div class="post-image-container">
                        <img src="Controleur?action=afficherImage&image=<%= pub.getImage() %>" class="post-image" alt="Image publication">
                    </div>
                <% } %>
            </div>

        <% } } %>

    </div>

</body>
</html>