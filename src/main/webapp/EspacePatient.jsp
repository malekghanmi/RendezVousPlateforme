<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="tn.enit.entities.Patient" %>
<%@ page import="tn.enit.entities.Rendezvous" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // 1. SÉCURITÉ
    Patient p = (Patient) session.getAttribute("patientConnecte");
    if (p == null) {
        response.sendRedirect("connexion.jsp");
        return;
    }
    
    // 2. DATA
    @SuppressWarnings("unchecked")
    List<Rendezvous> listeRdv = (List<Rendezvous>) session.getAttribute("mesRdv");
    
    SimpleDateFormat sdfDate = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat sdfHeure = new SimpleDateFormat("HH:mm");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Mon Espace - Smile Everyday</title>
    <link rel="stylesheet" type="text/css" href="mesStyles.css">
    
    <style>
        /* --- 1. CONFIGURATION DE BASE --- */
        html, body { margin: 0; padding: 0; height: 100%; overflow-x: hidden; font-family: 'Segoe UI', Arial, sans-serif; font-size: 16px; }

        /* FOND D'ÉCRAN ANIMÉ */
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
        /* --- 2. HEADER TRANSPARENT (HARMONISÉ ET ÉPURÉ) --- */
        .header {
            position: fixed; top: 0; left: 0; width: 100%; height: 90px;
            background: transparent;
            display: flex; justify-content: center; align-items: center;
            padding: 0 40px; z-index: 1000; box-sizing: border-box;
        }

        .logo { position: absolute; left: 40px; font-size: 1.8em; font-weight: bold; color: white; text-transform: uppercase; text-shadow: 2px 2px 4px rgba(0,0,0,0.5); }
        .logo span { color: #2ecc71; }

        /* MENU CENTRÉ (JUSTE LES ACTIONS) */
        .nav-links { 
            list-style: none; display: flex; gap: 20px; margin: 0; padding: 0; 
            background: rgba(0,0,0,0.3); padding: 10px 30px; border-radius: 50px; 
            backdrop-filter: blur(5px);
        }
        .nav-links a { 
            text-decoration: none; color: white; font-weight: 600; font-size: 15px; 
            transition: 0.3s; text-shadow: 1px 1px 2px black; display: flex; align-items: center; gap: 8px;
        }
        .nav-links a:hover, .nav-links a.active { color: #2ecc71; transform: scale(1.1); }

        /* BOUTON DÉCONNEXION (DROITE) */
        .logout-wrapper { position: absolute; right: 40px; }
        .btn-logout-header {
            background-color: #e74c3c; color: white; padding: 8px 20px;
            border-radius: 25px; text-decoration: none; font-weight: bold;
            font-size: 14px; box-shadow: 0 4px 10px rgba(0,0,0,0.3);
            transition: 0.3s; display: flex; align-items: center; gap: 5px;
        }
        .btn-logout-header:hover { background-color: #c0392b; transform: translateY(-2px); }

        /* --- 3. CONTENU DASHBOARD --- */
        .dashboard { display: flex; max-width: 1300px; margin: 150px auto 50px auto; gap: 40px; padding: 0 30px; }

        /* CARTES EN VERRE */
        .card-glass {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(15px);
            padding: 30px; border-radius: 20px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.1); 
            border: 1px solid rgba(255,255,255,0.7);
        }

        /* Colonne Gauche (Profil) */
        .card-profile { flex: 1; text-align: center; border-top: 6px solid #2ecc71; height: fit-content; }
        
        /* Correction ici pour gérer l'image */
        .avatar-circle { 
            width: 100px; height: 100px; 
            background: white; 
            border-radius: 50%; 
            margin: 0 auto 15px; 
            display: flex; align-items: center; justify-content: center; 
            font-size: 45px; color: #2ecc71; 
            border: 3px solid #2ecc71; 
            box-shadow: 0 5px 15px rgba(0,0,0,0.1); 
            overflow: hidden; 
            padding: 0;
        }
        
        .info-group { text-align: left; margin-top: 20px; border-bottom: 1px solid rgba(0,0,0,0.05); padding-bottom: 10px; }
        .info-label { font-size: 12px; color: #7f8c8d; text-transform: uppercase; letter-spacing: 1px; font-weight: bold; }
        .info-value { font-size: 16px; color: #2c3e50; font-weight: 600; margin-top: 3px; }

        /* Colonne Droite (RDV) */
        .card-rdv { flex: 2; border-top: 6px solid #3498db; }
        .header-rdv { margin-bottom: 25px; border-bottom: 2px solid rgba(0,0,0,0.05); padding-bottom: 15px; text-align: left; }
        .title-rdv { font-size: 1.8em; color: #2c3e50; font-weight: bold; margin: 0; }
        
        /* Items RDV */
        .rdv-item {
            display: flex; justify-content: space-between; align-items: center;
            background: white; border: 1px solid rgba(0,0,0,0.05);
            padding: 20px; border-radius: 15px; margin-bottom: 15px;
            transition: 0.3s; position: relative; overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }
        .rdv-item:hover { transform: translateY(-3px); box-shadow: 0 10px 20px rgba(0,0,0,0.1); border-color: #2ecc71; }
        .rdv-item::before { content: ''; position: absolute; left: 0; top: 0; height: 100%; width: 6px; background: #3498db; }

        .date-box { text-align: center; min-width: 90px; margin-right: 20px; }
        .date-day { font-size: 1.3em; font-weight: bold; color: #2c3e50; }
        .date-time { color: #555; font-size: 1em; font-weight: bold; background: #f0f0f0; padding: 3px 10px; border-radius: 5px; margin-top: 5px; display: inline-block;}

        .details-box { flex: 1; }
        .medecin-name { color: #3498db; font-weight: bold; font-size: 1.2em; margin-bottom: 5px; }
        .rdv-desc { color: #555; font-size: 1em; }

        .status-box { text-align: right; min-width: 110px; }
        .badge { padding: 8px 15px; border-radius: 20px; font-size: 12px; font-weight: bold; color: white; text-transform: uppercase; letter-spacing: 0.5px; }
        .b-wait { background: #f39c12; }
        .b-ok { background: #27ae60; }

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
            <li><a href="EspacePatient.jsp" class="active">Mon Espace</a></li>
            <li><a href="Controleur?action=voirProfil">⚙️ Mon Profil</a></li>
            
            <li><a href="Controleur?action=voirDossier&idPatient=<%= p.getIdP() %>">📂 Mon Dossier</a></li>
            
            <li><a href="Controleur?action=listerServices">🏥 Voir les Services</a></li>
            <li><a href="rendezvous.jsp">📅 Nouveau RDV</a></li>
            <li><a href="Controleur?action=murPublications">📰 Actualités</a></li>
        </ul>
        
        <div class="logout-wrapper">
            <a href="${pageContext.request.contextPath}/Controleur?action=deconnexion" class="btn-logout-header">
                🚪 Déconnexion
            </a>
        </div>
    </div>

    <div class="dashboard">

        <div class="card-glass card-profile">
            <div class="avatar-circle">
                <% if (p.getPhoto() != null && !p.getPhoto().isEmpty()) { %>
                    <img src="Controleur?action=afficherImage&image=<%= p.getPhoto() %>" 
                         style="width: 100%; height: 100%; object-fit: cover;" 
                         alt="Photo profil">
                <% } else { %>
                    <span style="font-size: 45px;">👤</span>
                <% } %>
            </div>

            <h2 style="margin: 10px 0; color: #2c3e50;"><%= p.getNomP().toUpperCase() %> <%= p.getPrenomP() %></h2>
            <div style="background:#e8f8f5; color:#27ae60; padding:5px 10px; border-radius:5px; display:inline-block; font-size:12px; font-weight:bold;">PATIENT VÉRIFIÉ</div>

            <div style="margin-top: 30px;"></div>

            <div class="info-group">
                <div class="info-label">Email</div>
                <div class="info-value"><%= p.getEmailP() %></div>
            </div>
            <div class="info-group">
                <div class="info-label">Téléphone</div>
                <div class="info-value"><%= (p.getTelP() != null) ? p.getTelP() : "Non renseigné" %></div>
            </div>
            <div class="info-group">
                <div class="info-label">Adresse</div>
                <div class="info-value"><%= (p.getAdresseP() != null) ? p.getAdresseP() : "Non renseignée" %></div>
            </div>
            <div class="info-group">
                <div class="info-label">Groupe Sanguin</div>
                <div class="info-value" style="color: #e74c3c; font-weight:bold;"><%= (p.getGroupeSanguinP() != null) ? p.getGroupeSanguinP() : "-" %></div>
            </div>
            <div class="info-group" style="border-bottom: none;">
                <div class="info-label">Couverture Santé</div>
                <div class="info-value"><%= (p.getRecouvrementP() != null) ? p.getRecouvrementP() : "Aucune" %></div>
            </div>
        </div>

        <div class="card-glass card-rdv">
            <div class="header-rdv">
                <h3 class="title-rdv">Mes Rendez-vous</h3>
                </div>

            <% if (listeRdv == null || listeRdv.isEmpty()) { %>
                <div style="text-align:center; padding: 60px; color:#7f8c8d;">
                    <div style="font-size: 60px; margin-bottom: 20px;">📅</div>
                    <p style="font-size: 1.2em;">Aucun rendez-vous programmé.</p>
                    <p>Utilisez le menu en haut pour prendre rendez-vous.</p>
                </div>
            <% } else { 
                for (Rendezvous r : listeRdv) { %>
                
                <div class="rdv-item">
                    <div class="date-box">
                        <div class="date-day"><%= (r.getDateRv() != null) ? sdfDate.format(r.getDateRv()) : "--/--" %></div>
                        <div class="date-time"><%= (r.getHeureRv() != null) ? sdfHeure.format(r.getHeureRv()) : "--:--" %></div>
                    </div>

                    <div class="details-box">
                        <% if (r.getDentiste() != null) { %>
                            <div class="medecin-name">👨‍⚕️ Dr. <%= r.getDentiste().getNomD() %> <%= r.getDentiste().getPrenomD() %></div>
                        <% } else { %>
                            <div style="color:#95a5a6; font-style:italic; font-size:0.9em; margin-bottom:5px;">⏳ Médecin : En attente d'affectation</div>
                        <% } %>
                        <div class="rdv-desc"><%= (r.getDetailsRv() != null) ? r.getDetailsRv() : "Aucun détail" %></div>
                    </div>

                    <div class="status-box">
                        <% if ("Validé".equals(r.getStatutRv())) { %>
                            <span class="badge b-ok">Confirmé</span>
                            
                            <div style="margin-top: 8px;">
                                <a href="Controleur?action=voirFacture&idRdv=<%= r.getIdRv() %>" 
                                   style="color: #3498db; font-size: 12px; text-decoration: none; font-weight: bold; border: 1px solid #3498db; padding: 3px 8px; border-radius: 4px; display: inline-block;">
                                   📄 Voir Facture
                                </a>
                            </div>
                        
                        <% } else if ("Refusé".equals(r.getStatutRv())) { %>
                            <span class="badge" style="background: #e74c3c; color: white;">Refusé</span>
                            <div style="font-size: 11px; color: #c0392b; margin-top: 5px;">Indisponible</div>
                        
                        <% } else { %>
                            <span class="badge b-wait">En attente</span>
                        <% } %>
                    </div>
                </div>
            <% } } %>
        </div>

    </div>

</body>
</html>