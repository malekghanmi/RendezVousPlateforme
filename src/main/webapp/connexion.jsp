<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="tn.enit.entities.Patient" %>

<%
    Patient p = (Patient) session.getAttribute("patientConnecte");
    if (p != null) {
        response.sendRedirect("EspacePatient.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Connexion - Smile Everyday</title>
    <link rel="stylesheet" type="text/css" href="mesStyles.css">
    
    <style>
        /* --- 1. CONFIGURATION DE BASE --- */
        html, body {
            margin: 0; padding: 0; height: 100%; overflow-x: hidden;
            font-family: 'Segoe UI', Arial, sans-serif;
        }

        /* --- 2. FOND D'ÉCRAN ANIMÉ --- */
        .slideshow {
            position: fixed; width: 100%; height: 100%; top: 0; left: 0;
            z-index: -1; list-style: none; margin: 0; padding: 0;
        }
        .slideshow li {
            width: 100%; height: 100%; position: absolute; top: 0; left: 0;
            background-size: cover; background-position: center;
            opacity: 0; z-index: 0;
            filter: blur(2px); transform: scale(1.02);
            animation: imageAnimation 18s linear infinite; 
        }
        @keyframes imageAnimation { 
            0% { opacity: 0; transform: scale(1.02); } 10% { opacity: 1; } 33% { opacity: 1; } 43% { opacity: 0; transform: scale(1.1); } 100% { opacity: 0; } 
        }

        /* --- 3. HEADER TRANSPARENT (STYLE INDEX) --- */
        .header {
            position: fixed; top: 0; left: 0; width: 100%; height: 90px;
            background: transparent;
            display: flex; justify-content: center; align-items: center;
            padding: 0 40px; z-index: 1000; box-sizing: border-box;
        }

        .logo { 
            position: absolute; left: 40px;
            font-size: 1.8em; font-weight: bold; color: white; 
            text-transform: uppercase; text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
        }
        .logo span { color: #2ecc71; }

        .nav-links { 
            list-style: none; display: flex; gap: 30px; margin: 0; padding: 0; 
            background: rgba(0,0,0,0.3); padding: 10px 30px; border-radius: 50px; 
            backdrop-filter: blur(5px);
        }
        .nav-links a { 
            text-decoration: none; color: white; font-weight: 600; font-size: 16px; 
            transition: 0.3s; text-shadow: 1px 1px 2px black;
        }
        .nav-links a:hover, .nav-links a.active { color: #2ecc71; transform: scale(1.1); }

        .search-wrapper { position: absolute; right: 40px; }
        .search-box {
            display: flex; align-items: center; border: none; border-radius: 25px; 
            overflow: hidden; background-color: rgba(255,255,255,0.9);
            padding: 0; box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        }
        .search-box input { border: none; padding: 8px 15px; outline: none; font-size: 14px; width: 180px; background: transparent; }
        .search-btn { border: none; background-color: #2ecc71; color: white; padding: 8px 15px; cursor: pointer; font-weight: bold; height: 100%; }
        .search-btn:hover { background-color: #27ae60; }

        /* --- 4. GLASS CARD (Formulaire) --- */
        .login-card {
            background-color: rgba(255, 255, 255, 0.85) !important; 
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255,255,255,0.6);
            box-shadow: 0 20px 50px rgba(0,0,0,0.3);
            border-radius: 20px;
            max-width: 450px; margin: 180px auto 50px auto; 
            padding: 40px;
            animation: slideUp 0.8s ease-out forwards;
            text-align: center;
        }
        @keyframes slideUp { from { transform: translateY(50px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }

        h1 { margin-top: 0; color: #2c3e50; font-size: 2.2em; margin-bottom: 30px; font-weight: bold; }

        .input-group { margin-bottom: 15px; text-align: left; }
        label { display: block; font-weight: bold; color: #444; margin-bottom: 5px; font-size: 0.95em; }
        
        input[type="text"], input[type="password"] { 
            width: 100%; padding: 12px; border-radius: 8px; border: 1px solid #ccc; 
            box-sizing: border-box; font-size: 14px; background-color: #fff; 
        }
        input:focus { border-color: #2ecc71; outline: none; box-shadow: 0 0 8px rgba(46, 204, 113, 0.3); }

        .row-links { display: flex; justify-content: space-between; margin-bottom: 25px; font-size: 0.9em; }
        .row-links a { text-decoration: none; color: #3498db; font-weight: bold; }
        .row-links a:hover { text-decoration: underline; }

        .btn-row { display: flex; gap: 10px; margin-bottom: 25px; }
        .btn-green { flex: 1; padding: 12px; background: linear-gradient(45deg, #2ecc71, #27ae60); color: white; border: none; border-radius: 50px; cursor: pointer; font-weight: bold; font-size: 16px; transition: 0.3s; }
        .btn-green:hover { transform: scale(1.05); }
        .btn-grey { flex: 1; padding: 12px; background: transparent; color: #555; border: 1px solid #999; border-radius: 50px; cursor: pointer; font-weight: bold; font-size: 16px; transition: 0.3s; }
        .btn-grey:hover { background: #ecf0f1; }

        .bottom-text { font-size: 1em; color: #333; margin-top: 10px; border-top: 1px solid rgba(0,0,0,0.1); padding-top: 15px; }
        .bottom-links a { text-decoration: none; color: #333; font-weight: bold; margin: 0 5px; }
        .bottom-links a:hover { color: #2ecc71; text-decoration: underline; }

        .error-msg { color: #c0392b; background: #fadbd8; padding: 12px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #e6b0aa; font-weight: bold; font-size: 0.9em; }

    </style>
</head>
<body>

    <ul class="slideshow">
        <li style="background-image: url('<%= request.getContextPath() %>/images/image2.png'); animation-delay: 0s;"></li>
        <li style="background-image: url('<%= request.getContextPath() %>/images/image3.png'); animation-delay: 4s;"></li>
        <li style="background-image: url('<%= request.getContextPath() %>/images/image6.png'); animation-delay: 8s;"></li>
        <li style="background-image: url('<%= request.getContextPath() %>/images/image11.png'); animation-delay: 12s;"></li>
        <li style="background-image: url('<%= request.getContextPath() %>/images/image12.png'); animation-delay: 16s;"></li>
        <li style="background-image: url('<%= request.getContextPath() %>/images/image13.png'); animation-delay: 20s;"></li>
    </ul>

    <div class="header">
        <div class="logo">Smile <span>Everyday</span></div> 
        
        <ul class="nav-links">
            <li><a href="index.jsp">Accueil</a></li>
            <li><a href="connexion.jsp" class="active">Connexion</a></li>
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

    <div class="login-card">
        <h1>Connexion</h1>

        <% if (request.getParameter("error") != null) { %>
            <div class="error-msg">⚠️ Email ou mot de passe incorrect</div>
        <% } %>

        <form action="${pageContext.request.contextPath}/Controleur" method="post">
            <input type="hidden" name="action" value="connexion">

            <div class="input-group">
                <label>Email</label>
                <input type="text" name="email" placeholder="Ex: jean@email.com" required>
            </div>

            <div class="input-group">
                <label>Mot de passe</label>
                <input type="password" name="mdp" placeholder="Votre mot de passe" required>
            </div>

            <div class="row-links">
                <a href="rendezvous.jsp">Prendre rendez-vous</a>
                <a href="#">Mot de passe oublié ?</a>
            </div>

            <div class="btn-row">
                <button type="submit" class="btn-green">Se Connecter</button>
                <button type="button" class="btn-grey" onclick="window.location.href='index.jsp'">Annuler</button>
            </div>

            <div class="bottom-text">
                <span style="color: #2ecc71; font-weight: bold;">Pas encore de compte ?</span><br>
                <span class="bottom-links">
                    <a href="patient.jsp">S'inscrire (Patient)</a> | 
                    <a href="AideSoignant.jsp">Aide-Soignant</a>
                </span>
            </div>

        </form>
    </div>

</body>
</html>