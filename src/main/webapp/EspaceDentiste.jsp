<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="tn.enit.entities.*, java.util.List, java.text.SimpleDateFormat" %>

<%
    // Récupération des listes (RDV, Candidats)
    List<Rendezvous> rdvAttente = (List<Rendezvous>) request.getAttribute("listeAttente");
    List<Rendezvous> rdvValide = (List<Rendezvous>) request.getAttribute("listeValide");
    List<AideSoignant> listeAS = (List<AideSoignant>) request.getAttribute("listeAS");
    
    // Variables pour la recherche (si utilisées)
    String txtRecherche = (String) request.getAttribute("txtRecherche");
    String dateRecherche = (String) request.getAttribute("dateRecherche");
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat shf = new SimpleDateFormat("HH:mm");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tableau de Bord Médecin</title>
    <link rel="stylesheet" type="text/css" href="mesStyles.css">
    <style>
        /* --- 1. CONFIGURATION DE BASE --- */
        html, body { margin: 0; padding: 0; height: 100%; overflow-x: hidden; font-family: 'Segoe UI', Arial, sans-serif; font-size: 16px; }
        
        /* FOND D'ÉCRAN */
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
        /* --- 2. HEADER TRANSPARENT --- */
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
        .nav-links a { text-decoration: none; color: white; font-weight: 600; font-size: 16px; transition: 0.3s; text-shadow: 1px 1px 2px black; }
        .nav-links a:hover, .nav-links a.active { color: #2ecc71; transform: scale(1.1); }

        /* BOUTON DÉCONNEXION */
        .logout-btn { position: absolute; right: 40px; background-color: #e74c3c; color: white; padding: 8px 20px; border-radius: 25px; text-decoration: none; font-weight: bold; font-size: 14px; box-shadow: 0 4px 10px rgba(0,0,0,0.3); }

        /* --- 3. CONTENU --- */
        .container { max-width: 1400px; margin: 120px auto 50px auto; padding: 0 30px; }
        .grid-dashboard { display: grid; grid-template-columns: 1fr 1fr; gap: 40px; margin-bottom: 40px; }

        /* CARD TRANSPARENTE */
        .card-panel { 
            background: rgba(255, 255, 255, 0.9); 
            backdrop-filter: blur(15px);
            border-radius: 15px; padding: 30px; 
            box-shadow: 0 15px 35px rgba(0,0,0,0.1); 
            height: 100%; border: 1px solid rgba(255,255,255,0.7);
        }
        
        h2 { color: #2c3e50; border-bottom: 3px solid rgba(0,0,0,0.1); padding-bottom: 15px; margin-bottom: 25px; font-size: 1.6em; text-transform: uppercase; letter-spacing: 1px; margin-top: 0; }

        /* TABLEAUX & LISTES */
        .mini-table { width: 100%; border-collapse: separate; border-spacing: 0 15px; }
        .mini-table td { padding: 15px; background: white; border-top: 1px solid #eee; border-bottom: 1px solid #eee; color: #333; vertical-align: middle; font-size: 15px; }
        .mini-table tr td:first-child { border-left: 6px solid transparent; border-top-left-radius: 10px; border-bottom-left-radius: 10px; }
        .mini-table tr td:last-child { border-top-right-radius: 10px; border-bottom-right-radius: 10px; border-right: 1px solid #eee; }
        
        .row-wait td:first-child { border-left-color: #f39c12; }
        .row-recruit td:first-child { border-left-color: #3498db; }
        .row-ok td:first-child { border-left-color: #27ae60; }
        .row-team td:first-child { border-left-color: #8e44ad; }

        /* BOUTONS ACTIONS */
        .btn-action { border: none; padding: 8px 15px; border-radius: 8px; cursor: pointer; font-weight: bold; color: white; transition: 0.2s; font-size: 14px; }
        .btn-ok { background: #27ae60; } .btn-ok:hover { transform: scale(1.1); }
        .btn-no { background: #e74c3c; } .btn-no:hover { transform: scale(1.1); }
        .btn-recruit { background: #3498db; width: 100%; margin-top:10px; padding: 10px; font-size: 15px; }

        strong { font-weight: 800; color: #2c3e50; font-size: 1.2em; display:block; margin-bottom: 5px; }
        .badge-date { background: #ecf0f1; padding: 6px 12px; border-radius: 6px; font-weight: bold; font-size: 14px; color: #555; display: inline-block; margin-bottom: 8px; }
        .badge-diplome { background: #eaf2f8; color: #3498db; padding: 5px 10px; border-radius: 6px; font-weight: bold; font-size: 14px; text-transform: uppercase; display: inline-block; margin-bottom: 8px;}
        .detail-list { list-style: none; padding: 0; margin: 0; font-size: 14px; color: #555; }
        .detail-list li { margin-bottom: 4px; display: flex; align-items: center; gap: 8px; }
        .btn-download { display: inline-block; margin-top: 8px; background: white; border: 2px solid #3498db; color: #3498db; padding: 5px 12px; border-radius: 20px; text-decoration: none; font-weight: bold; font-size: 13px; transition: 0.3s; }
        .btn-download:hover { background: #3498db; color: white; }

        /* BOUTON DOSSIER (Petit) */
        .btn-folder { font-size: 11px; background: #8e44ad; color: white; padding: 2px 6px; border-radius: 4px; text-decoration: none; margin-left: 8px; vertical-align: middle; }
        .btn-folder:hover { background: #9b59b6; }

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
            <li><a href="Controleur?action=espaceDentiste" class="active">📊 Tableau de Bord</a></li>
            <li><a href="Service.jsp">➕ Gérer les Services</a></li>
            
            <li><a href="Controleur?action=listerPubs">📢 Gérer les Publications</a></li>
        </ul>
        <a href="${pageContext.request.contextPath}/Controleur?action=deconnexion" class="logout-btn">Déconnexion</a>
    </div>

    <div class="container">

        <div class="grid-dashboard">
            
            <div class="card-panel" style="border-top: 6px solid #f39c12;">
                <h2 style="color: #e67e22;">⏳ Demandes de Rendez-vous</h2>
                <% if (rdvAttente == null || rdvAttente.isEmpty()) { %>
                    <p style="color:#7f8c8d; text-align:center; padding:30px; font-size: 1.1em;">Aucune demande en attente.</p>
                <% } else { %>
                    <table class="mini-table">
                        <% for (Rendezvous r : rdvAttente) { %>
                        <tr class="row-wait">
                            <td width="25%" style="text-align: center;">
                                <span class="badge-date"><%= sdf.format(r.getDateRv()) %></span><br>
                                <span style="font-size:1.6em; font-weight:bold; color:#34495e;">🕒 <%= shf.format(r.getHeureRv()) %></span>
                            </td>
                            <td>
                                <strong>
                                    <%= r.getPatient().getNomP().toUpperCase() %> <%= r.getPatient().getPrenomP() %>
                                    <a href="Controleur?action=voirDossier&idPatient=<%= r.getPatient().getIdP() %>" class="btn-folder" title="Voir l'historique">📂 Dossier</a>
                                </strong>
                                <ul class="detail-list">
                                    <li>📞 <%= r.getPatient().getTelP() %></li>
                                    <li>📝 <i><%= r.getDetailsRv() %></i></li>
                                </ul>
                            </td>
                            <td style="text-align:right;">
                                <form action="Controleur" method="post" style="display:inline;"><input type="hidden" name="action" value="validerRDV_Dentiste"><input type="hidden" name="idRdv" value="<%= r.getIdRv() %>"><button class="btn-action btn-ok" title="Valider">✔</button></form>
                                <form action="Controleur" method="post" style="display:inline; margin-left:5px;"><input type="hidden" name="action" value="refuserRDV_Dentiste"><input type="hidden" name="idRdv" value="<%= r.getIdRv() %>"><button class="btn-action btn-no" title="Refuser">✖</button></form>
                            </td>
                        </tr>
                        <% } %>
                    </table>
                <% } %>
            </div>

            <div class="card-panel" style="border-top: 6px solid #3498db;">
                <h2 style="color: #2980b9;">🎓 Candidatures</h2>
                <% 
                    boolean hasCandidate = false;
                    if (listeAS != null) { for (AideSoignant as : listeAS) { if (!"Validé".equals(as.getStatut())) { hasCandidate = true; break; } } }
                %>
                <% if (!hasCandidate) { %>
                    <p style="color:#7f8c8d; text-align:center; padding:30px; font-size: 1.1em;">Aucun candidat.</p>
                <% } else { %>
                    <table class="mini-table">
                        <% for (AideSoignant as : listeAS) { if (!"Validé".equals(as.getStatut())) { %>
                        <tr class="row-recruit">
                            <td width="70%">
                                <strong><%= as.getNomAS().toUpperCase() %> <%= as.getPrenomAS() %></strong>
                                <span class="badge-diplome"><%= as.getDiplomeAS() %></span>
                                
                                <ul class="detail-list" style="margin-top: 8px;">
                                    <li>👤 <%= as.getSexeAS() %> | Né(e) le : <%= (as.getDateNAS()!=null)?sdf.format(as.getDateNAS()):"-" %></li>
                                    <li>🏠 <%= as.getAdresseAS() %></li>
                                    <li>📞 <%= as.getTelAS() %></li>
                                    <li>📧 <%= as.getEmailAS() %></li>
                                </ul>

                                <% if (as.getCv() != null && !as.getCv().equals("Non fourni")) { %>
                                    <a href="Controleur?action=telechargerCV&fichier=<%= as.getCv() %>" target="_blank" class="btn-download">
                                        📥 Télécharger le CV
                                    </a>
                                <% } %>
                            </td>
                            <td style="text-align:right; vertical-align: middle;">
                                <form action="Controleur" method="post"><input type="hidden" name="action" value="validerAS"><input type="hidden" name="id" value="<%= as.getIdAS() %>"><button class="btn-action btn-recruit">✅ Recruter</button></form>
                                <form action="Controleur" method="post" onsubmit="return confirm('Refuser définitivement ?');" style="margin-top:10px;"><input type="hidden" name="action" value="supprimerAS"><input type="hidden" name="id" value="<%= as.getIdAS() %>"><button class="btn-action btn-no" style="width:100%;">🗑️ Refuser</button></form>
                            </td>
                        </tr>
                        <% } } %>
                    </table>
                <% } %>
            </div>
        </div>

        <%-- ... (Tout le début du code reste identique jusqu'à la section Planning Validé) ... --%>

        <div class="grid-dashboard">
            
            <div class="card-panel" style="border-top: 6px solid #27ae60;">
                
                <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 3px solid rgba(0,0,0,0.1); padding-bottom: 15px; margin-bottom: 25px;">
                    <h2 style="color: #27ae60; margin: 0; border: none; padding: 0;">📅 Planning Validé</h2>
                    
                    <form action="Controleur" method="get" style="display: flex; gap: 5px;">
                        <input type="hidden" name="action" value="espaceDentiste">
                        <input type="date" name="dateRecherche" value="<%= (dateRecherche!=null)?dateRecherche:"" %>" 
                               style="padding: 5px; border: 1px solid #ddd; border-radius: 5px; color: #555;">
                        <input type="text" name="txtRecherche" placeholder="Nom du patient..." value="<%= (txtRecherche!=null)?txtRecherche:"" %>" 
                               style="padding: 5px; border: 1px solid #ddd; border-radius: 5px; width: 140px;">
                        <button type="submit" style="background: #27ae60; color: white; border: none; padding: 5px 10px; border-radius: 5px; cursor: pointer;">🔍</button>
                        <% if ((txtRecherche!=null && !txtRecherche.isEmpty()) || (dateRecherche!=null && !dateRecherche.isEmpty())) { %>
                            <a href="Controleur?action=espaceDentiste" style="text-decoration:none; color:#e74c3c; font-weight:bold; padding:5px;">✖</a>
                        <% } %>
                    </form>
                </div>

                <% if (rdvValide == null || rdvValide.isEmpty()) { %>
                    <p style="color:#7f8c8d; text-align:center; padding:30px;">Aucun rendez-vous trouvé.</p>
                <% } else { %>
                    <table class="mini-table">
                        <% for (Rendezvous r : rdvValide) { %>
                        <tr class="row-ok">
                            <td width="20%" style="text-align:center;">
                                <span style="font-weight:bold; color:#2c3e50; font-size:1.1em;"><%= sdf.format(r.getDateRv()) %></span><br>
                                <span style="font-size:1.4em; color:#27ae60; font-weight:bold;"><%= shf.format(r.getHeureRv()) %></span>
                            </td>
                            <td>
                                <strong>
                                    <%= r.getPatient().getNomP().toUpperCase() %> <%= r.getPatient().getPrenomP() %>
                                    <a href="Controleur?action=voirDossier&idPatient=<%= r.getPatient().getIdP() %>" class="btn-folder" title="Voir l'historique">📂 Dossier</a>
                                </strong>
                                <ul class="detail-list">
                                    <li>📞 <%= r.getPatient().getTelP() %></li>
                                    <li>🔎 <%= r.getDetailsRv() %></li>
                                </ul>
                            </td>
                            <td style="text-align:right;">
                                <%-- LE BOUTON DE SUPPRESSION A ÉTÉ ENLEVÉ ICI --%>
                                <a href="Controleur?action=detailsRDV&idRdv=<%= r.getIdRv() %>" class="btn-action" style="background:#3498db; text-decoration:none; display:inline-block; padding: 10px 20px;">🦷 Consulter</a>
                            </td>
                        </tr>
                        <% } %>
                    </table>
                <% } %>
            </div>

<%-- ... (Le reste du code pour le Personnel Actif demeure inchangé) ... --%>

            <div class="card-panel" style="border-top: 6px solid #8e44ad;">
                <h2 style="color: #8e44ad;">🏥 Personnel Actif</h2>
                <table class="mini-table">
                    <% if (listeAS != null) { for (AideSoignant as : listeAS) { if ("Validé".equals(as.getStatut())) { %>
                    <tr class="row-team">
                        <td>
                            <strong><%= as.getNomAS().toUpperCase() %> <%= as.getPrenomAS() %></strong>
                            <span class="badge-diplome" style="color:#8e44ad; background:#f4ecf7;"><%= as.getDiplomeAS() %></span>
                            <ul class="detail-list" style="margin-top:5px;">
                                <li>📞 <%= as.getTelAS() %></li>
                                <li>📧 <%= as.getEmailAS() %></li>
                            </ul>
                        </td>
                        <td style="text-align:right;">
                            <form action="Controleur" method="post" onsubmit="return confirm('Licencier ce membre ?');"><input type="hidden" name="action" value="supprimerAS"><input type="hidden" name="id" value="<%= as.getIdAS() %>"><button class="btn-action btn-no">🗑️</button></form>
                        </td>
                    </tr>
                    <% } } } %>
                </table>
            </div>
        </div>

    </div>

</body>
</html>