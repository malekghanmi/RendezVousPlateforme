<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="tn.enit.entities.Patient" %>

<%
    Patient p = (Patient) session.getAttribute("patientConnecte");
    // Récupération du message d'erreur envoyé par le Contrôleur
    String errorMsg = (String) request.getAttribute("erreur");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Inscription Patient - Smile Everyday</title>
    <link rel="stylesheet" type="text/css" href="mesStyles.css">
    
    <style>
        /* --- STYLE HARMONISÉ --- */
        html, body { margin: 0; padding: 0; height: 100%; overflow-x: hidden; font-family: 'Segoe UI', Arial, sans-serif; }

        /* FOND ANIMÉ */
        .slideshow { position: fixed; width: 100%; height: 100%; top: 0; left: 0; z-index: -1; list-style: none; margin: 0; padding: 0; background-color: white; }
        .slideshow li { width: 100%; height: 100%; position: absolute; top: 0; left: 0; background-size: cover; background-position: center; opacity: 0; z-index: 0; filter: blur(1px); animation: imageAnimation 28s linear infinite; }
        .slideshow li:nth-child(1) { animation-delay: 0s; }
        .slideshow li:nth-child(2) { animation-delay: 4s; }
        .slideshow li:nth-child(3) { animation-delay: 8s; }
        .slideshow li:nth-child(4) { animation-delay: 12s; }
        .slideshow li:nth-child(5) { animation-delay: 16s; }
        .slideshow li:nth-child(6) { animation-delay: 20s; }
        .slideshow li:nth-child(7) { animation-delay: 24s; }

        @keyframes imageAnimation { 
            0% { opacity: 0; transform: scale(1.0); }
            8% { opacity: 1; }
            14.28% { opacity: 1; }
            22% { opacity: 0; transform: scale(1.03); }
            100% { opacity: 0; }
        }

        /* HEADER */
        .header { position: fixed; top: 0; left: 0; width: 100%; height: 90px; background: transparent; display: flex; justify-content: center; align-items: center; padding: 0 40px; z-index: 1000; box-sizing: border-box; }
        .logo { position: absolute; left: 40px; font-size: 1.8em; font-weight: bold; color: white; text-transform: uppercase; text-shadow: 2px 2px 4px rgba(0,0,0,0.5); }
        .logo span { color: #2ecc71; }

        .nav-links { list-style: none; display: flex; gap: 30px; margin: 0; padding: 0; background: rgba(0,0,0,0.3); padding: 10px 30px; border-radius: 50px; backdrop-filter: blur(5px); }
        .nav-links a { text-decoration: none; color: white; font-weight: 600; font-size: 16px; transition: 0.3s; text-shadow: 1px 1px 2px black; }
        .nav-links a:hover, .nav-links a.active { color: #2ecc71; transform: scale(1.1); }

        /* GLASS CARD */
        h1 { text-align: center; margin-top: 130px; margin-bottom: 20px; font-size: 2.2em; font-weight: bold; color: white; text-shadow: 2px 2px 5px black; }
        .glass-card { background-color: rgba(255, 255, 255, 0.85) !important; backdrop-filter: blur(15px); border: 1px solid rgba(255,255,255,0.6); box-shadow: 0 20px 50px rgba(0,0,0,0.3); border-radius: 20px; max-width: 600px; margin: 0 auto 50px auto; padding: 40px; }

        /* ALERT ERROR */
        .error-banner { background-color: #f8d7da; color: #721c24; padding: 12px; border-radius: 8px; border: 1px solid #f5c6cb; margin-bottom: 20px; text-align: center; font-weight: bold; }

        label { font-weight: bold; color: #444; display:block; margin-top:15px; margin-bottom: 5px; }
        input, select { width: 100%; padding: 12px; border-radius: 8px; border: 1px solid #ccc; box-sizing: border-box; font-size: 14px; background-color: #fff; }
        input:focus { border-color: #2ecc71; outline: none; box-shadow: 0 0 8px rgba(46, 204, 113, 0.3); }

        .btn-save { width: 100%; padding: 14px; color: white; border: none; border-radius: 50px; cursor: pointer; background: linear-gradient(45deg, #2ecc71, #27ae60); font-size: 16px; font-weight: bold; margin-top: 25px; transition: 0.3s; }
        .btn-save:hover { transform: scale(1.02); }
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
             <li><a href="index.jsp">Accueil</a></li>
            <li><a href="connexion.jsp">Connexion</a></li>
            <li><a href="patient.jsp" class="active">Fiche Patient</a></li>
            <li><a href="AideSoignant.jsp">Aide-Soignant</a></li>
        </ul>
    </div>

    <h1>Créer un compte<br>et Prenez rendez-vous en ligne</h1>

    <div class="glass-card">
        
        <%-- Affichage de l'erreur si elle existe --%>
        <% if (errorMsg != null) { %>
            <div class="error-banner"><%= errorMsg %></div>
        <% } %>
        
        <form action="${pageContext.request.contextPath}/Controleur" method="post">
            <input type="hidden" name="action" value="inscriptionPatient">
            
            <div style="display: flex; gap: 15px;">
                <div style="flex: 1;">
                    <label>Nom</label>
                    <input type="text" name="nom" required>
                </div>
                <div style="flex: 1;">
                    <label>Prénom</label>
                    <input type="text" name="prenom" required>
                </div>
            </div>

            <label>Sexe</label>
            <select name="sexe" required>
                <option value="Homme">Homme</option>
                <option value="Femme">Femme</option>
            </select>
            
            <label>Date de naissance</label>
            <input type="date" name="dateN" required>

            <%-- RESTRICTION TÉLÉPHONE : 8 CHIFFRES --%>
            <label>Téléphone (8 chiffres)</label>
            <input type="text" name="tel" required pattern="[0-9]{8}" title="Le numéro doit contenir exactement 8 chiffres" placeholder="Ex: 22111333">
            
            <label>Email</label>
            <input type="email" name="email" required placeholder="exemple@email.com">
            
            <%-- RESTRICTION MOT DE PASSE : MIN 8 CARACTÈRES --%>
            <label>Mot de passe (8 caractères min.)</label>
            <input type="password" name="mdp" required minlength="8" placeholder="********">

            <label>Groupe Sanguin</label>
            <select name="groupe">
                <option value="A+">A+</option><option value="O+">O+</option>
                </select>
            
            <label>Recouvrement</label>
            <select name="recouvrement">
                <option value="Santé publique">Santé publique</option>
                <option value="Remboursement">Remboursement</option>
            </select>
            
            <button type="submit" class="btn-save">Enregistrer</button>
            <div style="text-align:center; margin-top:15px;">
                Déjà inscrit ? <a href="connexion.jsp" style="color:#27ae60; font-weight:bold;">Se connecter</a>
            </div>
        </form>
    </div>

</body>
</html>