<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="tn.enit.entities.Patient" %>

<%
    // Récupération du patient en session pour le menu dynamique
    Patient p = (Patient) session.getAttribute("patientConnecte");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Inscription Aide-Soignant - Smile Everyday</title>
    <link rel="stylesheet" type="text/css" href="mesStyles.css">
    
    <style>
        /* --- CONFIGURATION EXISTANTE --- */
        html, body { margin: 0; padding: 0; height: 100%; overflow-x: hidden; font-family: 'Segoe UI', Arial, sans-serif; }
        .slideshow { position: fixed; width: 100%; height: 100%; top: 0; left: 0; z-index: -1; list-style: none; margin: 0; padding: 0; }
        .slideshow li { width: 100%; height: 100%; position: absolute; top: 0; left: 0; background-size: cover; background-position: center; opacity: 0; z-index: 0; filter: blur(2px); transform: scale(1.02); animation: imageAnimation 18s linear infinite; }
        @keyframes imageAnimation { 0% { opacity: 0; transform: scale(1.02); } 10% { opacity: 1; } 33% { opacity: 1; } 43% { opacity: 0; transform: scale(1.1); } 100% { opacity: 0; } }

        /* --- HEADER HARMONISÉ AVEC INDEX.JSP --- */
        .header { position: fixed; top: 0; left: 0; width: 100%; height: 90px; background: transparent; display: flex; justify-content: center; align-items: center; padding: 0 40px; z-index: 1000; box-sizing: border-box; }
        .logo { position: absolute; left: 40px; font-size: 1.8em; font-weight: bold; color: white; text-transform: uppercase; text-shadow: 2px 2px 4px rgba(0,0,0,0.5); }
        .logo span { color: #2ecc71; }
        .nav-links { list-style: none; display: flex; gap: 20px; margin: 0; padding: 0; background: rgba(0,0,0,0.3); padding: 10px 25px; border-radius: 50px; backdrop-filter: blur(5px); }
        .nav-links a { text-decoration: none; color: white; font-weight: 600; font-size: 14px; transition: 0.3s; text-shadow: 1px 1px 2px black; }
        .nav-links a:hover, .nav-links a.active { color: #2ecc71; }

        /* --- FORMULAIRE ET CARTES --- */
        h1 { text-align: center; margin-top: 130px; margin-bottom: 10px; font-size: 2.2em; color: white; text-shadow: 2px 2px 5px black; }
        .glass-card { background-color: rgba(255, 255, 255, 0.85) !important; backdrop-filter: blur(15px); border: 1px solid rgba(255,255,255,0.6); box-shadow: 0 20px 50px rgba(0,0,0,0.3); border-radius: 20px; max-width: 700px; margin: 0 auto 50px auto; padding: 40px; }
        label { font-weight: bold; color: #444; display:block; margin-top:15px; margin-bottom: 5px; }
        input, select, textarea { width: 100%; padding: 12px; border-radius: 8px; border: 1px solid #ccc; box-sizing: border-box; font-size: 14px; }

        /* --- MOT DE PASSE --- */
        .password-container { position: relative; display: flex; align-items: center; }
        .toggle-password { position: absolute; right: 15px; cursor: pointer; color: #777; font-size: 0.8em; user-select: none; font-weight: bold; background: #eee; padding: 4px 8px; border-radius: 4px; }
        .toggle-password:hover { background: #2ecc71; color: white; }

        .btn-submit { width: 100%; padding: 14px; color: white; border: none; border-radius: 50px; cursor: pointer; background: linear-gradient(45deg, #3498db, #2980b9); font-size: 16px; font-weight: bold; margin-top: 30px; transition: 0.3s; }
        .btn-submit:hover { transform: scale(1.02); background: linear-gradient(45deg, #2ecc71, #27ae60); }
        .error-message { color: #c0392b; background: #fadbd8; padding: 12px; border-radius: 8px; margin-bottom: 20px; display: none; text-align: center; border: 1px solid #e6b0aa; font-weight: 600; }
        .required-star { color: #e74c3c; margin-left: 3px; }
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
        <div class="logo">Smile <span>Everyday</span></div> 
        <ul class="nav-links">
            <li><a href="index.jsp">Accueil</a></li>
            <li><a href="connexion.jsp">Connexion</a></li>
            <li><a href="patient.jsp">Fiche Patient</a></li>
            <li><a href="AideSoignant.jsp" class="active">Aide-Soignant</a></li>

            <% if (p != null) { %>
                <li><a href="Service.jsp">Services</a></li>
                <li><a href="rendezvous.jsp">Rendez-vous</a></li>
                <li><a href="Publication.jsp">Publications</a></li>
            <% } %>
            <li><a href="connexionDentiste.jsp">Médecin</a></li> 
        </ul>
    </div>

    <h1>Inscription Aide-Soignant</h1>
    <p style="text-align: center; color: white; text-shadow: 1px 1px 3px black;">Rejoignez notre équipe médicale</p>

    <div class="glass-card">
        <div id="errorMessage" class="error-message"></div>

        <form id="aideSoignantForm" action="${pageContext.request.contextPath}/Controleur" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
            <input type="hidden" name="action" value="inscriptionAideSoignant">
            
            <label>Nom <span class="required-star">*</span></label>
            <input type="text" id="nom" name="nom" required>
            
            <label>Prénom <span class="required-star">*</span></label>
            <input type="text" id="prenom" name="prenom" required>
            
            <label>Email (Gmail uniquement) <span class="required-star">*</span></label>
            <input type="email" id="email" name="email" required placeholder="votre.nom@gmail.com">
            
            <label>Mot de passe <span class="required-star">*</span></label>
            <div class="password-container">
                <input type="password" id="mdp" name="mdp" required placeholder="8 caractères min, 1 chiffre, 1 spécial">
                <span class="toggle-password" onclick="togglePasswordVisibility()">VOIR</span>
            </div>
            
            <label>Téléphone <span class="required-star">*</span></label>
            <input type="tel" id="tel" name="tel" required placeholder="8 chiffres">
            
            <label>Photo de profil</label>
            <input type="file" name="photo" accept="image/*">

            <label>Curriculum Vitae (CV) <span class="required-star">*</span></label>
            <input type="file" id="cv" name="cv" accept=".pdf,.doc,.docx" required>

            <label>Date de naissance <span class="required-star">*</span></label>
            <input type="date" id="dateN" name="dateN" required>
            
            <label>Diplôme <span class="required-star">*</span></label>
            <select id="diplome" name="diplome" required>
                <option value="" disabled selected>-- Sélectionnez votre diplôme --</option>
                <option value="Aide-soignant(e) Diplômé(e)">Aide-soignant(e) Diplômé(e)</option>
                <option value="Assistant(e) Dentaire">Assistant(e) Dentaire</option>
                <option value="CAP Petite Enfance">CAP Petite Enfance</option>
            </select>
            
            <label>Sexe <span class="required-star">*</span></label>
            <div style="display: flex; gap: 20px; padding: 10px 0;">
                <label style="width: auto; cursor: pointer;"><input type="radio" name="sexe" value="Homme" required style="width: auto;"> Homme</label>
                <label style="width: auto; cursor: pointer;"><input type="radio" name="sexe" value="Femme" style="width: auto;"> Femme</label>
            </div>
            
            <label>Adresse</label>
            <textarea id="adresse" name="adresse" rows="2" placeholder="Votre adresse complète"></textarea>
            
            <button type="submit" class="btn-submit">Envoyer ma candidature</button>
        </form>
    </div>

    <script>
        function togglePasswordVisibility() {
            const mdpInput = document.getElementById('mdp');
            const toggleBtn = document.querySelector('.toggle-password');
            if (mdpInput.type === 'password') {
                mdpInput.type = 'text';
                toggleBtn.textContent = 'CACHER';
            } else {
                mdpInput.type = 'password';
                toggleBtn.textContent = 'VOIR';
            }
        }

        function validateForm() {
            const mdp = document.getElementById('mdp').value;
            const email = document.getElementById('email').value;
            const tel = document.getElementById('tel').value;
            const cv = document.getElementById('cv').files[0];
            const errorDiv = document.getElementById('errorMessage');
            
            errorDiv.style.display = 'none';
            errorDiv.innerHTML = '';

            if (!/^[0-9]{8}$/.test(tel)) {
                errorDiv.innerHTML = '❌ Le téléphone doit contenir exactement 8 chiffres.';
                errorDiv.style.display = 'block';
                window.scrollTo(0, 0);
                return false;
            }

            if (!email.toLowerCase().endsWith("@gmail.com")) {
                errorDiv.innerHTML = '❌ Seules les adresses @gmail.com sont acceptées.';
                errorDiv.style.display = 'block';
                window.scrollTo(0, 0);
                return false;
            }

            const mdpRegex = /^(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$/;
            if (!mdpRegex.test(mdp)) {
                errorDiv.innerHTML = '❌ Mot de passe : 8 caractères minimum, un chiffre et un symbole.';
                errorDiv.style.display = 'block';
                window.scrollTo(0, 0);
                return false;
            }

            if (cv && cv.size > 5 * 1024 * 1024) {
                errorDiv.innerHTML = '❌ Le CV ne doit pas dépasser 5 Mo.';
                errorDiv.style.display = 'block';
                window.scrollTo(0, 0);
                return false;
            }

            return true;
        }
    </script>
</body>
</html>