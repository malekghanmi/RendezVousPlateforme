<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Rendez-vous Confirmé - Smile Everyday</title>
    <link rel="stylesheet" type="text/css" href="mesStyles.css">
    
    <style>
        /* --- 1. CONFIGURATION DE BASE --- */
        html, body {
            margin: 0; padding: 0; height: 100%; overflow-x: hidden;
            font-family: 'Segoe UI', Arial, sans-serif;
        }

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

        /* --- 3. HEADER TRANSPARENT (HARMONISÉ) --- */
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

        /* --- 4. GLASS CARD (Succès) --- */
        .glass-card {
            background-color: rgba(255, 255, 255, 0.85) !important; 
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255,255,255,0.6);
            box-shadow: 0 20px 50px rgba(0,0,0,0.3);
            border-radius: 20px;
            max-width: 600px; margin: 200px auto 50px auto; 
            padding: 50px; text-align: center;
            animation: popIn 0.8s cubic-bezier(0.68, -0.55, 0.265, 1.55);
        }
        @keyframes popIn { 0% { transform: scale(0.8); opacity: 0; } 100% { transform: scale(1); opacity: 1; } }

        .success-icon { font-size: 80px; margin-bottom: 20px; display: block; animation: bounce 2s infinite; }
        @keyframes bounce { 0%, 20%, 50%, 80%, 100% {transform: translateY(0);} 40% {transform: translateY(-20px);} 60% {transform: translateY(-10px);} }

        h1 { margin: 0; color: #2c3e50; font-size: 2.5em; font-weight: bold; margin-bottom: 20px; }
        .message-box { font-size: 1.2em; color: #555; line-height: 1.6; margin-bottom: 40px; }

        .btn-row { display: flex; gap: 20px; justify-content: center; }
        
        .btn-primary { 
            padding: 12px 30px; background: linear-gradient(45deg, #2ecc71, #27ae60); color: white; border: none; border-radius: 50px; cursor: pointer; font-weight: bold; font-size: 16px; transition: 0.3s;
        }
        .btn-primary:hover { transform: scale(1.05); }

        .btn-outline { 
            padding: 12px 30px; background: transparent; color: #555; border: 2px solid #999; border-radius: 50px; cursor: pointer; font-weight: bold; font-size: 16px; transition: 0.3s;
        }
        .btn-outline:hover { border-color: #27ae60; color: #27ae60; background: rgba(46, 204, 113, 0.1); }

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
            <li><a href="Controleur?action=listerServices">🏥 Voir les Services</a></li>
            <li><a href="rendezvous.jsp" class="active">📅 Nouveau RDV</a></li>
        </ul>
        <a href="EspacePatient.jsp" class="btn-logout-header">← Retour</a>
    </div>

    <div class="glass-card">
        <div class="success-icon">✔</div> 
        <h1 style="color: #27ae60;">Rendez-vous Confirmé !</h1>

        <div class="message-box">
            Votre demande de rendez-vous a bien été enregistrée.<br>
            Notre équipe vous attend avec le sourire.
        </div>

        <div class="btn-row">
            <button onclick="window.location.href='EspacePatient.jsp'" class="btn-primary">Retour à mon Espace</button>
            <button onclick="window.location.href='rendezvous.jsp'" class="btn-outline">Prendre un autre RDV</button>
        </div>
    </div>

</body>
</html>