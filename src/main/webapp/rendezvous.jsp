<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="tn.enit.entities.Patient" %>

<%
    // 1. SÉCURITÉ : Bloquer l'accès si non connecté
    Patient p = (Patient) session.getAttribute("patientConnecte");
    if (p == null) {
        response.sendRedirect("connexion.jsp?error=need_login");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Prendre Rendez-vous - Smile Everyday</title>
    <link rel="stylesheet" type="text/css" href="mesStyles.css">
    
    <style>
        /* --- 1. CONFIGURATION DE BASE --- */
        html, body { margin: 0; padding: 0; height: 100%; overflow-x: hidden; font-family: 'Segoe UI', Arial, sans-serif; }

        /* --- 2. FOND D'ÉCRAN ANIMÉ --- */
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
        /* --- 3. HEADER TRANSPARENT HARMONISÉ --- */
        .header {
            position: fixed; top: 0; left: 0; width: 100%; height: 90px;
            background: transparent;
            display: flex; justify-content: center; align-items: center;
            padding: 0 40px; z-index: 1000; box-sizing: border-box;
        }

        .logo { position: absolute; left: 40px; font-size: 1.8em; font-weight: bold; color: white; text-transform: uppercase; text-shadow: 2px 2px 4px rgba(0,0,0,0.5); }
        .logo span { color: #2ecc71; }

        /* MENU CENTRÉ */
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

        /* BOUTON RETOUR */
        .btn-logout-header { position: absolute; right: 40px; background-color: #3498db; color: white; padding: 8px 20px; border-radius: 25px; text-decoration: none; font-weight: bold; font-size: 14px; box-shadow: 0 4px 10px rgba(0,0,0,0.3); transition: 0.3s; }
        .btn-logout-header:hover { background-color: #2980b9; transform: translateY(-2px); }

        /* --- 4. CONTENU --- */
        h1 {
            text-align: center; margin-top: 130px; margin-bottom: 20px;
            font-size: 2.2em; font-weight: bold; color: white; 
            text-shadow: 2px 2px 5px black; line-height: 1.3;
        }

        /* --- 5. GLASS CARD (Formulaire) --- */
        .glass-card {
            background-color: rgba(255, 255, 255, 0.85) !important; 
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255,255,255,0.6);
            box-shadow: 0 20px 50px rgba(0,0,0,0.3);
            border-radius: 20px;
            max-width: 650px; margin: 0 auto 50px auto; padding: 40px;
            animation: slideUp 0.8s ease-out forwards;
        }
        @keyframes slideUp { from { transform: translateY(50px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }

        label { font-weight: bold; color: #444; display:block; margin-top:15px; margin-bottom: 5px; }
        
        input[type="text"], input[type="date"], input[type="time"], select, textarea { 
            width: 100%; padding: 12px; border-radius: 8px; border: 1px solid #ccc; 
            transition: 0.3s; box-sizing: border-box; font-size: 14px; background-color: #fff;
        }
        input:focus, select:focus, textarea:focus { border-color: #2ecc71; outline: none; box-shadow: 0 0 8px rgba(46, 204, 113, 0.3); }

        /* Radio Buttons */
        .radio-group { display: flex; gap: 30px; margin-bottom: 15px; background: rgba(255,255,255,0.5); padding: 10px; border-radius: 8px; border: 1px solid #ccc; }
        .radio-item { display: flex; align-items: center; gap: 5px; cursor: pointer; }
        input[type="radio"] { width: auto; margin: 0; transform: scale(1.2); cursor: pointer; }

        .btn-row { display: flex; gap: 15px; margin-top: 25px; }
        
        .btn-save { flex: 1; padding: 12px; color: white; border: none; border-radius: 50px; cursor: pointer; background: linear-gradient(45deg, #3498db, #2980b9); font-size: 16px; font-weight: bold; transition: 0.3s; }
        .btn-save:hover { transform: scale(1.05); background: linear-gradient(45deg, #2ecc71, #27ae60); }

        .btn-cancel { flex: 1; padding: 12px; color: #555; border: 1px solid #999; border-radius: 50px; cursor: pointer; background-color: transparent; font-size: 16px; font-weight: bold; transition: 0.3s; }
        .btn-cancel:hover { background-color: #ecf0f1; }
        
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
            <li><a href="rendezvous.jsp" class="active">📅 Nouveau RDV</a></li>
            <li><a href="Controleur?action=murPublications">📰 Actualités</a></li>
        </ul>
    </div>

    <h1>Un sourire éclatant commence ici :<br>Prenez rendez-vous facilement</h1>

    <div class="glass-card">
        
        <form action="${pageContext.request.contextPath}/Controleur" method="post">
            <input type="hidden" name="action" value="ajoutRDV">

            <label>Première visite ?</label>
            <div class="radio-group">
                <label class="radio-item"><input type="radio" name="premiereVisite" value="Oui" checked> Oui</label>
                <label class="radio-item"><input type="radio" name="premiereVisite" value="Non"> Non</label>
            </div>

            <label>Date de réservation</label>
            <input type="date" name="dateRDV" required>

            <label>Heure</label>
            <input type="time" name="heureRDV" required>

            <label>Type de soin</label>
            <select name="categorieService" required>
                <option disabled selected>-- Choisir une catégorie --</option>
                <option>Dentisterie générale</option>
                <option>Diagnostic et soins courants</option>
                <option>Parodontologie</option>
                <option>Radiologie et imagerie dentaire</option>
                <option>Chirurgie dentaire</option>
                <option>Dents de sagesse</option>
                <option>Actes chirurgicaux</option>
                <option>Endodontie</option>
                <option>Esthétique dentaire</option>
                <option>Implantologie</option>
            </select>

            <label>Motif de la visite</label>
            <input type="text" name="defaut" placeholder="Ex: Douleur, Contrôle...">

            <label>Détails supplémentaires</label>
            <textarea name="details" rows="3" placeholder="Saisir les détails..."></textarea>

            <div class="btn-row">
                <button type="submit" class="btn-save">Confirmer le Rendez-vous</button>
                <button type="button" class="btn-cancel" onclick="window.location.href='EspacePatient.jsp'">Annuler</button>
            </div>

        </form>
    </div>

</body>
</html>