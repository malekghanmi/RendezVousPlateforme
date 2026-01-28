<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="tn.enit.entities.Dentiste" %>
<%@ page import="tn.enit.entities.ServiceMedical" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%
    // 1. SÉCURITÉ MÉDECIN
    Dentiste d = (Dentiste) session.getAttribute("dentisteConnecte");
    if (d == null) { 
        response.sendRedirect("connexionDentiste.jsp"); 
        return; 
    }

    // 2. RÉCUPÉRATION DE LA LISTE DES SERVICES
    List<ServiceMedical> listeServices = (List<ServiceMedical>) request.getAttribute("listeServices");
    if (listeServices == null) {
        listeServices = new ArrayList<>();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestion des Services - Smile Everyday</title>
    <link rel="stylesheet" type="text/css" href="mesStyles.css">
    
    <style>
        /* --- STYLE HARMONISÉ (IDENTIQUE AUX PUBLICATIONS) --- */
        html, body { margin: 0; padding: 0; height: 100%; overflow-x: hidden; font-family: 'Segoe UI', Arial, sans-serif; font-size: 16px; }

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

        /* MENU */
        .nav-links { list-style: none; display: flex; gap: 30px; margin: 0; padding: 0; background: rgba(0,0,0,0.3); padding: 10px 30px; border-radius: 50px; backdrop-filter: blur(5px); }
        .nav-links a { text-decoration: none; color: white; font-weight: 600; font-size: 16px; transition: 0.3s; text-shadow: 1px 1px 2px black; }
        .nav-links a:hover, .nav-links a.active { color: #2ecc71; transform: scale(1.1); }

        /* CONTENU */
        .container { max-width: 1000px; margin: 120px auto 50px auto; padding: 0 20px; }

        /* GLASS CARD */
        .glass-card {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(15px);
            padding: 30px; border-radius: 20px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.1); 
            border: 1px solid rgba(255,255,255,0.7);
            margin-bottom: 40px;
        }

        h2 { color: #2c3e50; border-bottom: 3px solid rgba(0,0,0,0.1); padding-bottom: 10px; margin-bottom: 20px; }
        p.subtitle { text-align: center; color: #7f8c8d; margin-top: -15px; margin-bottom: 25px; }

        label { font-weight: bold; color: #444; display:block; margin-top:15px; margin-bottom: 5px; }
        input, select, textarea { width: 100%; padding: 12px; border-radius: 8px; border: 1px solid #ccc; box-sizing: border-box; font-size: 14px; background: white; }
        input:focus, select:focus, textarea:focus { border-color: #2ecc71; outline: none; }

        .btn-save { width: 100%; padding: 14px; color: white; border: none; border-radius: 50px; cursor: pointer; background: linear-gradient(45deg, #2ecc71, #27ae60); font-size: 16px; font-weight: bold; margin-top: 25px; transition: 0.3s; }
        .btn-save:hover { transform: scale(1.02); box-shadow: 0 5px 15px rgba(46, 204, 113, 0.3); }

        /* LISTE DES SERVICES (GRID) */
        .service-list { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .service-item { background: white; border-radius: 15px; padding: 20px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); transition: 0.3s; border-left: 5px solid #2ecc71; }
        .service-item:hover { transform: translateY(-5px); }
        
        .service-cat { font-size: 11px; text-transform: uppercase; color: #2ecc71; font-weight: bold; letter-spacing: 1px; }
        .service-title { font-size: 1.3em; font-weight: bold; color: #2c3e50; margin: 5px 0; }
        .service-price { font-size: 1.1em; color: #27ae60; font-weight: bold; margin-bottom: 10px; display: block; }
        .service-desc { font-size: 14px; color: #666; line-height: 1.4; height: 40px; overflow: hidden; }

        .btn-delete { display: block; width: 100%; text-align: center; padding: 10px; background: #fdf2f2; color: #e74c3c; border: 1px solid #fadbd8; cursor: pointer; border-radius: 8px; margin-top: 15px; font-weight: bold; font-size: 14px; transition: 0.3s; }
        .btn-delete:hover { background: #e74c3c; color: white; }

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
            <li><a href="Controleur?action=listerServicesMedical" class="active">🛠️ Gérer les Services</a></li>
            <li><a href="Controleur?action=listerPubs">📢 Gérer les Publications</a></li>
            <li><a href="${pageContext.request.contextPath}/Controleur?action=deconnexion" style="color:#e74c3c;">🚪 Déconnexion</a></li>
        </ul>
    </div>

    <div class="container">

        <div class="glass-card">
            <h2>➕ Nouveau Service</h2>
            <p class="subtitle">Ajoutez un soin au catalogue du cabinet</p>
            
            <form action="${pageContext.request.contextPath}/Controleur" method="post">
                <input type="hidden" name="action" value="ajoutService">

                <label>Nom du Service</label>
                <input type="text" name="nomSM" required placeholder="Ex: Blanchiment Dentaire">

                <div style="display: flex; gap: 15px;">
                    <div style="flex: 1;">
                        <label>Tarif (DT)</label>
                        <input type="number" name="tarifSM" required placeholder="Ex: 150">
                    </div>
                    <div style="flex: 1;">
                        <label>Séances</label>
                        <input type="number" name="nbSeances" required placeholder="Nombre" min="1">
                    </div>
                </div>

                <label>Catégorie</label>
                <select name="typeSM" required>
                    <option value="Dentisterie générale">Dentisterie générale</option>
                    <option value="Chirurgie">Chirurgie dentaire</option>
                    <option value="Orthodontie">Orthodontie</option>
                    <option value="Implantologie">Implantologie</option>
                    <option value="Esthétique">Esthétique dentaire</option>
                </select>

                <label>Description</label>
                <textarea name="descriptionSM" rows="3" placeholder="Description du soin..."></textarea>

                <button type="submit" class="btn-save">Enregistrer le Service</button>
            </form>
        </div>

        <%-- ... (le début du code reste identique) ... --%>

        <% if (listeServices != null && !listeServices.isEmpty()) { %>
            <div class="glass-card" style="background: rgba(255,255,255,0.85);">
                <h2>🛠️ Services Actuellement Proposés</h2>
                <div class="service-list">
                    <% for (ServiceMedical sm : listeServices) { %>
                        <div class="service-item">
                            <span class="service-cat"><%= sm.getTypeService() %></span>
                            <h3 class="service-title"><%= sm.getNomService() %></h3>
                            <span class="service-price"><%= sm.getTarifService() %> DT <small style="color:#999; font-weight:normal;">/ <%= sm.getNbSeances() %> séance(s)</small></span>
                            <p class="service-desc"><%= (sm.getDescriptionService() != null) ? sm.getDescriptionService() : "Aucune description fournie." %></p>
                            
                            <%-- LE BOUTON DE SUPPRESSION A ÉTÉ ENLEVÉ D'ICI --%>
                            
                        </div>
                    <% } %>
                </div>
            </div>
        <% } else { %>
            <div class="glass-card" style="text-align: center;">
                <h3>Aucun service au catalogue pour le moment.</h3>
            </div>
        <% } %>

    </div>

</body>
</html>