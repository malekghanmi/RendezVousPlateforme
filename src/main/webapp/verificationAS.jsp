<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="tn.enit.entities.Patient" %>
<%
    // Récupération du patient en session pour garder le menu cohérent
    Patient p = (Patient) session.getAttribute("patientConnecte");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Candidature Envoyée - Smile Everyday</title>
    <link rel="stylesheet" type="text/css" href="mesStyles.css">
    <style>
        /* --- 1. FOND D'ÉCRAN ANIMÉ (Identique à AideSoignant.jsp) --- */
        html, body { margin: 0; padding: 0; height: 100%; font-family: 'Segoe UI', Arial, sans-serif; overflow: hidden; }

        .slideshow { position: fixed; width: 100%; height: 100%; top: 0; left: 0; z-index: -1; list-style: none; margin: 0; padding: 0; background: black; }
        .slideshow li { width: 100%; height: 100%; position: absolute; top: 0; left: 0; background-size: cover; background-position: center; opacity: 0; animation: imageAnimation 25s linear infinite; filter: blur(3px); }
        
        .slideshow li:nth-child(1) { animation-delay: 0s; }
        .slideshow li:nth-child(2) { animation-delay: 5s; }
        .slideshow li:nth-child(3) { animation-delay: 10s; }
        .slideshow li:nth-child(4) { animation-delay: 15s; }
        .slideshow li:nth-child(5) { animation-delay: 20s; }

        @keyframes imageAnimation { 
            0% { opacity: 0; transform: scale(1); }
            8% { opacity: 1; }
            20% { opacity: 1; }
            28% { opacity: 0; transform: scale(1.05); }
            100% { opacity: 0; }
        }

        /* --- 2. HEADER (Même entête que vos autres pages) --- */
        .header { position: fixed; top: 0; left: 0; width: 100%; height: 90px; background: transparent; display: flex; justify-content: center; align-items: center; padding: 0 40px; z-index: 1000; box-sizing: border-box; }
        .logo { position: absolute; left: 40px; font-size: 1.8em; font-weight: bold; color: white; text-transform: uppercase; text-shadow: 2px 2px 4px rgba(0,0,0,0.5); text-decoration: none; }
        .logo span { color: #2ecc71; }
        .nav-links { list-style: none; display: flex; gap: 20px; background: rgba(0,0,0,0.3); padding: 10px 25px; border-radius: 50px; backdrop-filter: blur(5px); margin: 0; }
        .nav-links a { text-decoration: none; color: white; font-weight: 600; font-size: 14px; text-shadow: 1px 1px 2px black; transition: 0.3s; }
        .nav-links a:hover { color: #2ecc71; }

        /* --- 3. CARTE DE CONFIRMATION (Style Glass-Card) --- */
        .container { height: 100vh; display: flex; justify-content: center; align-items: center; padding: 20px; }

        .success-card {
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(15px);
            padding: 50px;
            border-radius: 30px;
            text-align: center;
            max-width: 550px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.3);
            border: 1px solid rgba(255,255,255,0.5);
            animation: cardPop 0.7s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }

        @keyframes cardPop {
            from { transform: translateY(30px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        .icon-container {
            width: 70px; height: 70px; background: #2ecc71; color: white; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 35px; margin: 0 auto 25px auto;
            box-shadow: 0 10px 20px rgba(46, 204, 113, 0.3);
        }

        h1 { color: #2c3e50; margin-bottom: 15px; font-size: 1.8em; }
        p { color: #555; font-size: 1.05em; line-height: 1.6; margin-bottom: 10px; }
        .highlight { color: #27ae60; font-weight: bold; }

        .btn-home {
            display: inline-block; margin-top: 25px; padding: 12px 40px;
            background: linear-gradient(45deg, #2ecc71, #27ae60);
            color: white; text-decoration: none; border-radius: 50px;
            font-weight: bold; transition: 0.3s; box-shadow: 0 5px 15px rgba(46, 204, 113, 0.2);
        }
        .btn-home:hover { transform: scale(1.05); background: linear-gradient(45deg, #27ae60, #1e8449); }
    </style>
</head>
<body>

    <ul class="slideshow">
        <li style="background-image: url('<%= request.getContextPath() %>/images/image1.png');"></li>
        <li style="background-image: url('<%= request.getContextPath() %>/images/image7.png');"></li>
        <li style="background-image: url('<%= request.getContextPath() %>/images/image8.png');"></li>
        <li style="background-image: url('<%= request.getContextPath() %>/images/image9.png');"></li>
        <li style="background-image: url('<%= request.getContextPath() %>/images/image10.png');"></li>
    </ul>

    <div class="header">
        <a href="index.jsp" class="logo">Smile <span>Everyday</span></a> 
        <ul class="nav-links">
            <li><a href="index.jsp">Accueil</a></li>
            <li><a href="connexion.jsp">Connexion</a></li>
            <li><a href="patient.jsp">Fiche Patient</a></li>
            <li><a href="AideSoignant.jsp">Aide-Soignant</a></li>
            <% if (p != null) { %>
                <li><a href="Service.jsp">Services</a></li>
                <li><a href="rendezvous.jsp">Rendez-vous</a></li>
            <% } %>
            <li><a href="connexionDentiste.jsp">Médecin</a></li> 
        </ul>
    </div>

    <div class="container">
        <div class="success-card">
            <div class="icon-container">✓</div>
            <h1>Inscription Validée !</h1>
            <p>Votre candidature a bien été transmise à notre équipe médicale.</p>
            <p>Nous allons examiner votre dossier et nous vous répondrons directement par <span class="highlight">E-mail</span> très prochainement.</p>
            
            <a href="index.jsp" class="btn-home">Retour à l'Accueil</a>
        </div>
    </div>

</body>
</html>