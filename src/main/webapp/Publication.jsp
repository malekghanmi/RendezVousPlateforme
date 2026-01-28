<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="tn.enit.entities.Dentiste" %>
<%@ page import="tn.enit.entities.Publication" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // 1. SÉCURITÉ MÉDECIN
    Dentiste d = (Dentiste) session.getAttribute("dentisteConnecte");
    if (d == null) {
        response.sendRedirect("connexionDentiste.jsp");
        return;
    }

    // 2. RÉCUPÉRATION DE LA LISTE
    List<Publication> mesPubs = (List<Publication>) request.getAttribute("mesPubs");
    
    if (mesPubs == null) {
        mesPubs = new ArrayList<>();
    }

    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestion des Publications - Smile Everyday</title>
    <link rel="stylesheet" type="text/css" href="mesStyles.css">
    <style>
        /* --- STYLE HARMONISÉ --- */
        html, body { margin: 0; padding: 0; height: 100%; overflow-x: hidden; font-family: 'Segoe UI', Arial, sans-serif; font-size: 16px; }

        /* FOND ANIMÉ */
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

        /* MENU */
        .nav-links { list-style: none; display: flex; gap: 30px; margin: 0; padding: 0; background: rgba(0,0,0,0.3); padding: 10px 30px; border-radius: 50px; backdrop-filter: blur(5px); }
        .nav-links a { text-decoration: none; color: white; font-weight: 600; font-size: 16px; transition: 0.3s; text-shadow: 1px 1px 2px black; }
        .nav-links a:hover, .nav-links a.active { color: #2ecc71; transform: scale(1.1); }

        /* CONTENU */
        .container { max-width: 1000px; margin: 120px auto 50px auto; padding: 0 20px; }

        /* FORMULAIRE & CARTE */
        .glass-card {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(15px);
            padding: 30px; border-radius: 20px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.1); 
            border: 1px solid rgba(255,255,255,0.7);
            margin-bottom: 40px;
        }

        h2 { color: #2c3e50; border-bottom: 3px solid rgba(0,0,0,0.1); padding-bottom: 10px; margin-bottom: 20px; }

        label { font-weight: bold; color: #444; display:block; margin-top:15px; margin-bottom: 5px; }
        
        /* Styles des inputs ajustés */
        input[type="text"], textarea, input[type="file"], input[type="date"], select { 
            width: 100%; padding: 12px; border-radius: 8px; border: 1px solid #ccc; 
            transition: 0.3s; box-sizing: border-box; font-size: 14px; background-color: #fff; 
        }
        input:focus, textarea:focus, select:focus { border-color: #2ecc71; outline: none; }

        /* BOUTONS */
        .btn-group { display: flex; gap: 15px; margin-top: 25px; }
        
        .btn-publish { 
            flex: 1; padding: 12px; background: linear-gradient(45deg, #27ae60, #2ecc71); 
            color: white; border: none; border-radius: 50px; cursor: pointer; 
            font-weight: bold; font-size: 16px; transition: 0.3s; 
        }
        .btn-publish:hover { transform: scale(1.02); box-shadow: 0 5px 15px rgba(39, 174, 96, 0.4); }

        .btn-cancel { 
            flex: 1; padding: 12px; background: #95a5a6; 
            color: white; border: none; border-radius: 50px; cursor: pointer; 
            font-weight: bold; font-size: 16px; transition: 0.3s; 
        }
        .btn-cancel:hover { background: #7f8c8d; }

        /* LISTE */
        .pub-list { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .pub-item { background: white; border-radius: 15px; overflow: hidden; box-shadow: 0 5px 15px rgba(0,0,0,0.1); transition: 0.3s; }
        .pub-item:hover { transform: translateY(-5px); }
        .pub-img { width: 100%; height: 180px; object-fit: cover; }
        .pub-content { padding: 20px; }
        .pub-date { font-size: 12px; color: #888; margin-bottom: 5px; display: block; }
        .pub-title { font-size: 1.3em; font-weight: bold; color: #2c3e50; margin: 0 0 10px 0; }
        .pub-text { font-size: 14px; color: #555; line-height: 1.5; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; }
        
        .btn-delete { display: block; width: 100%; text-align: center; padding: 10px; background: #e74c3c; color: white; border: none; cursor: pointer; border-radius: 8px; margin-top: 15px; font-weight: bold; font-size: 14px; transition: 0.3s; }
        .btn-delete:hover { background: #c0392b; transform: scale(1.02); }

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
        <div class="logo">Smile <span>Docteur</span></div>
        <ul class="nav-links">
            <li><a href="Controleur?action=espaceDentiste">📊 Tableau de Bord</a></li>
            <li><a href="Service.jsp">➕ Gérer les Services</a></li>
            <li><a href="Controleur?action=listerPubs" class="active">📢 Gérer les Publications</a></li>
            <li><a href="${pageContext.request.contextPath}/Controleur?action=deconnexion" style="color:#e74c3c;">🚪 Déconnexion</a></li>
        </ul>
    </div>

    <div class="container">

        <div class="glass-card">
            <h2>📢 Nouvelle Publication</h2>
            
            <form action="${pageContext.request.contextPath}/Controleur" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="ajoutPublication">
                
                <label>Titre</label>
                <input type="text" name="titre" placeholder="Saisir le titre de publication .." required>

                <label>Date de publication</label>
                <input type="date" name="date" placeholder="jj/mm/aaaa">

                <label>Affiche</label>
                <input type="file" name="image" accept="image/*">
                
                <label>Type de publication</label>
                <select name="type_dummy">
                    <option value="">[Choisir catégorie]</option>
                    <option value="conseil">Conseil Santé</option>
                    <option value="news">Actualité</option>
                    <option value="promo">Offre Spéciale</option>
                </select>

                <label>Résumé</label>
                <textarea name="contenu" rows="4" placeholder="Saisir la description associée .." required></textarea>

                <div class="btn-group">
                    <button type="submit" class="btn-publish">Enregistrer</button>
                    <button type="reset" class="btn-cancel">Annuler</button>
                </div>
            </form>
        </div>

        <% if (mesPubs != null && !mesPubs.isEmpty()) { %>
            <div class="glass-card" style="background: rgba(255,255,255,0.8);">
                <h2>📚 Vos Articles Récents</h2>
                <div class="pub-list">
                    <% for (Publication pub : mesPubs) { %>
                        <div class="pub-item">
                            
                            <img src="Controleur?action=afficherImage&image=<%= pub.getImage() %>" 
                                 class="pub-img" 
                                 alt="Affiche"
                                 onerror="this.src='images/default-pub.jpg';">
                            
                            <div class="pub-content">
                                <span class="pub-date">📅 <%= (pub.getDatePub() != null) ? sdf.format(pub.getDatePub()) : "--/--/----" %></span>
                                
                                <h3 class="pub-title"><%= pub.getTitre() %></h3>
                                <p class="pub-text"><%= pub.getContenu() %></p>
                                
                                <form action="Controleur" method="post" onsubmit="return confirm('Voulez-vous vraiment supprimer cet article ?');">
                                    <input type="hidden" name="action" value="supprimerPub">
                                    <input type="hidden" name="id" value="<%= pub.getIdPub() %>">
                                    <button class="btn-delete">🗑️ Supprimer</button>
                                </form>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
        <% } else { %>
            <div class="glass-card" style="text-align: center;">
                <h3>Aucune publication pour le moment.</h3>
            </div>
        <% } %>

    </div>

</body>
</html>