<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Inscription Validée - Smile Everyday</title>
    
    <style>
        /* --- STYLE HARMONISÉ --- */
        html, body { margin: 0; padding: 0; height: 100%; overflow-x: hidden; font-family: 'Segoe UI', Arial, sans-serif; }

        /* FOND ANIMÉ (IDENTIQUE AUX AUTRES PAGES) */
        .slideshow { position: fixed; width: 100%; height: 100%; top: 0; left: 0; z-index: -1; list-style: none; margin: 0; padding: 0; background-color: white; }
        .slideshow li { width: 100%; height: 100%; position: absolute; top: 0; left: 0; background-size: cover; background-position: center; opacity: 0; z-index: 0; filter: blur(2px); animation: imageAnimation 28s linear infinite; }
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

        /* HEADER HARMONISÉ (Style Sombre Transparent) */
        .header { position: fixed; top: 0; left: 0; width: 100%; height: 90px; background: transparent; display: flex; justify-content: center; align-items: center; padding: 0 40px; z-index: 1000; box-sizing: border-box; }
        .logo { position: absolute; left: 40px; font-size: 1.8em; font-weight: bold; color: white; text-transform: uppercase; text-shadow: 2px 2px 4px rgba(0,0,0,0.5); }
        .logo span { color: #2ecc71; }

        .nav-links { list-style: none; display: flex; gap: 30px; margin: 0; padding: 0; background: rgba(0,0,0,0.3); padding: 10px 30px; border-radius: 50px; backdrop-filter: blur(5px); }
        .nav-links a { text-decoration: none; color: white; font-weight: 600; font-size: 16px; transition: 0.3s; text-shadow: 1px 1px 2px black; }
        .nav-links a:hover { color: #2ecc71; transform: scale(1.1); }

        /* GLASS CARD (Style Médical Clean) */
        .glass-card {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(15px);
            padding: 50px; border-radius: 20px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.2); 
            border: 1px solid rgba(255,255,255,0.7);
            max-width: 500px;
            margin: 150px auto;
            text-align: center;
            animation: fadeIn 0.8s ease-in-out;
        }

        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

        .success-icon { font-size: 60px; color: #2ecc71; margin-bottom: 20px; }
        h1 { color: #2c3e50; font-size: 2em; margin-bottom: 15px; border-bottom: 2px solid rgba(46, 204, 113, 0.2); padding-bottom: 10px; }
        p { color: #7f8c8d; font-size: 1.1em; line-height: 1.5; margin-bottom: 30px; }

        /* BOUTONS (Style Smile Docteur) */
        .btn-container { display: flex; flex-direction: column; gap: 15px; }
        .btn-main { 
            background: linear-gradient(45deg, #2ecc71, #27ae60); color: white; 
            padding: 15px; border-radius: 50px; text-decoration: none; 
            font-weight: bold; transition: 0.3s; box-shadow: 0 5px 15px rgba(46, 204, 113, 0.3);
        }
        .btn-main:hover { transform: translateY(-3px); box-shadow: 0 8px 20px rgba(46, 204, 113, 0.4); }
        
        .btn-secondary { 
            color: #7f8c8d; text-decoration: none; font-size: 0.9em; font-weight: 600; 
        }
        .btn-secondary:hover { color: #2c3e50; text-decoration: underline; }

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
            <li><a href="index.jsp">🏠 Accueil</a></li>
            <li><a href="Service.jsp">🛠️ Services</a></li>
            <li><a href="Publication.jsp">📢 Publications</a></li>
            <li><a href="connexion.jsp">🔐 Connexion</a></li>
        </ul>
    </div>

    <div class="glass-card">
        <div class="success-icon">✔️</div>
        <h1>Inscription réussie !</h1>
        <p>Votre compte patient a été créé avec succès.<br>Vous pouvez maintenant accéder à votre espace pour prendre rendez-vous.</p>
        
        <div class="btn-container">
            <a href="connexion.jsp" class="btn-main">Se connecter à mon espace</a>
            <a href="index.jsp" class="btn-secondary">Retourner à la page d'accueil</a>
        </div>
    </div>

</body>
</html>