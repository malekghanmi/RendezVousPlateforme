<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="tn.enit.entities.Patient" %>

<%
    Patient p = (Patient) request.getAttribute("patient");
    if (p == null) {
        // Fallback si accès direct
        p = (Patient) session.getAttribute("patientConnecte");
    }
    if (p == null) { response.sendRedirect("connexion.jsp"); return; }
    
    String success = request.getParameter("success");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Mon Profil - Smile Everyday</title>
    <link rel="stylesheet" type="text/css" href="mesStyles.css">
    <style>
        /* BASE DESIGN */
        html, body { margin: 0; padding: 0; height: 100%; overflow-x: hidden; font-family: 'Segoe UI', Arial, sans-serif; }
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
        /* HEADER */
        .header { position: fixed; top: 0; left: 0; width: 100%; height: 90px; background: transparent; display: flex; justify-content: center; align-items: center; padding: 0 40px; z-index: 1000; box-sizing: border-box; }
        .logo { position: absolute; left: 40px; font-size: 1.8em; font-weight: bold; color: white; text-transform: uppercase; text-shadow: 2px 2px 4px rgba(0,0,0,0.5); }
        .logo span { color: #2ecc71; }
        .nav-links { list-style: none; display: flex; gap: 20px; margin: 0; padding: 0; background: rgba(0,0,0,0.3); padding: 10px 30px; border-radius: 50px; backdrop-filter: blur(5px); }
        .nav-links a { text-decoration: none; color: white; font-weight: 600; font-size: 15px; transition: 0.3s; text-shadow: 1px 1px 2px black; }
        .nav-links a:hover { color: #2ecc71; transform: scale(1.1); }
        .logout-btn { position: absolute; right: 40px; background-color: #e74c3c; color: white; padding: 8px 20px; border-radius: 25px; text-decoration: none; font-weight: bold; font-size: 14px; }

        /* CONTAINER PROFIL */
        .container { max-width: 900px; margin: 120px auto 50px auto; padding: 0 20px; display: grid; grid-template-columns: 1fr 2fr; gap: 30px; }

        .glass-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(15px);
            padding: 30px; border-radius: 20px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.1); 
            border: 1px solid rgba(255,255,255,0.7);
        }

        /* COLONNE GAUCHE (PHOTO) */
        .profile-pic-container { text-align: center; }
        .profile-img { width: 150px; height: 150px; border-radius: 50%; object-fit: cover; border: 5px solid #2ecc71; box-shadow: 0 5px 15px rgba(0,0,0,0.2); margin-bottom: 20px; }
        .user-name { font-size: 1.5em; font-weight: bold; color: #2c3e50; margin: 0; }
        .user-role { color: #7f8c8d; font-size: 0.9em; text-transform: uppercase; letter-spacing: 1px; margin-top: 5px; }

        /* COLONNE DROITE (FORM) */
        h2 { color: #2c3e50; border-bottom: 2px solid #eee; padding-bottom: 10px; margin-top: 0; }
        label { font-weight: bold; color: #555; display: block; margin-top: 15px; margin-bottom: 5px; font-size: 0.9em; }
        input[type="text"], input[type="email"], input[type="password"], input[type="file"] { 
            width: 100%; padding: 12px; border-radius: 8px; border: 1px solid #ccc; 
            box-sizing: border-box; font-size: 14px; background: #f9f9f9; 
        }
        input:focus { border-color: #2ecc71; outline: none; background: white; }

        .btn-save { width: 100%; padding: 12px; background: #2ecc71; color: white; border: none; border-radius: 50px; cursor: pointer; font-weight: bold; font-size: 16px; margin-top: 25px; transition: 0.3s; }
        .btn-save:hover { background: #27ae60; transform: scale(1.02); }

        .alert-success { background: #d4edda; color: #155724; padding: 15px; border-radius: 8px; margin-bottom: 20px; text-align: center; border: 1px solid #c3e6cb; }
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
            <li><a href="EspacePatient.jsp">Tableau de Bord</a></li>
            
            
            <li><a href="Controleur?action=voirProfil" style="color: #2ecc71;">⚙️ Mon Profil</a></li>
            
            <li><a href="Controleur?action=voirDossier&idPatient=<%= p.getIdP() %>">📂 Mon Dossier</a></li>
            
            <li><a href="Controleur?action=listerServices">🏥 Voir les Services</a></li>
            <li><a href="rendezvous.jsp">📅 Nouveau RDV</a></li>
            <li><a href="Controleur?action=murPublications">📰 Actualités</a></li>
        </ul>
        <a href="${pageContext.request.contextPath}/Controleur?action=deconnexion" class="logout-btn">Déconnexion</a>
    </div>

    <div class="container">

        <div class="glass-card profile-pic-container">
            <% if (p.getPhoto() != null && !p.getPhoto().isEmpty()) { %>
                <img src="Controleur?action=afficherImage&image=<%= p.getPhoto() %>" class="profile-img" alt="Photo de profil">
            <% } else { %>
                <div class="profile-img" style="background: #eee; display: flex; align-items: center; justify-content: center; font-size: 60px; color: #ccc;">👤</div>
            <% } %>
            
            <h1 class="user-name"><%= p.getNomP().toUpperCase() %> <%= p.getPrenomP() %></h1>
            <div class="user-role">Patient</div>
            <p style="margin-top: 20px; font-size: 0.9em; color: #555;">Inscrit depuis le <%= p.getDateNP() %></p>
        </div>

        <div class="glass-card">
            <h2>✏️ Modifier mes informations</h2>

            <% if ("1".equals(success)) { %>
                <div class="alert-success">✅ Vos modifications ont été enregistrées avec succès !</div>
            <% } %>

            <form action="${pageContext.request.contextPath}/Controleur" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="updateProfil">

                <label>Changer la photo de profil</label>
                <input type="file" name="photo" accept="image/*">

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                    <div>
                        <label>Email</label>
                        <input type="email" name="email" value="<%= p.getEmailP() %>" required>
                    </div>
                    <div>
                        <label>Téléphone</label>
                        <input type="text" name="tel" value="<%= (p.getTelP()!=null)?p.getTelP():"" %>">
                    </div>
                </div>

                <label>Adresse complète</label>
                <input type="text" name="adresse" value="<%= (p.getAdresseP()!=null)?p.getAdresseP():"" %>">

                <label>Nouveau Mot de passe (Laisser vide pour ne pas changer)</label>
                <input type="password" name="mdp" value="<%= p.getMdpP() %>" required>

                <button type="submit" class="btn-save">Enregistrer les modifications</button>
            </form>
        </div>

    </div>

</body>
</html>