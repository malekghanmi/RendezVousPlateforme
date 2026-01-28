<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="tn.enit.entities.*, java.util.*, java.text.SimpleDateFormat" %>

<%
    // --- 1. SÉCURITÉ INTELLIGENTE (Dentiste OU Patient) ---
    Dentiste d = (Dentiste) session.getAttribute("dentisteConnecte");
    Patient connectedPatient = (Patient) session.getAttribute("patientConnecte");

    // Si personne n'est connecté, on redirige
    if (d == null && connectedPatient == null) { 
        response.sendRedirect("index.jsp"); 
        return; 
    }

    // --- 2. RÉCUPÉRATION DES DONNÉES ---
    Patient p = (Patient) request.getAttribute("lePatient");
    List<Rendezvous> historique = (List<Rendezvous>) request.getAttribute("historiqueRdv");
    Map<Integer, List<ActeMedical>> mapActes = (Map<Integer, List<ActeMedical>>) request.getAttribute("mapActes");

    SimpleDateFormat sdf = new SimpleDateFormat("dd MMMM yyyy");
    SimpleDateFormat shf = new SimpleDateFormat("HH:mm");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dossier Médical - <%= p.getNomP() %></title>
    <link rel="stylesheet" type="text/css" href="mesStyles.css">
    <style>
        /* --- STYLE HARMONISÉ (Glassmorphism) --- */
        html, body { margin: 0; padding: 0; height: 100%; overflow-x: hidden; font-family: 'Segoe UI', Arial, sans-serif; font-size: 16px; }

        /* FOND ANIMÉ */
        .slideshow { position: fixed; width: 100%; height: 100%; top: 0; left: 0; z-index: -1; list-style: none; margin: 0; padding: 0; }
        .slideshow li { width: 100%; height: 100%; position: absolute; top: 0; left: 0; background-size: cover; background-position: center; opacity: 0; z-index: 0; filter: blur(2px); transform: scale(1.02); animation: imageAnimation 18s linear infinite; }
        @keyframes imageAnimation { 0% { opacity: 0; transform: scale(1.02); } 10% { opacity: 1; } 33% { opacity: 1; } 43% { opacity: 0; transform: scale(1.1); } 100% { opacity: 0; } }

        /* HEADER TRANSPARENT */
        .header { position: fixed; top: 0; left: 0; width: 100%; height: 90px; background: transparent; display: flex; justify-content: center; align-items: center; padding: 0 40px; z-index: 1000; box-sizing: border-box; }
        .logo { position: absolute; left: 40px; font-size: 1.8em; font-weight: bold; color: white; text-transform: uppercase; text-shadow: 2px 2px 4px rgba(0,0,0,0.5); }
        .logo span { color: #2ecc71; }

        /* MENU */
        .nav-links { list-style: none; display: flex; gap: 30px; margin: 0; padding: 0; background: rgba(0,0,0,0.3); padding: 10px 30px; border-radius: 50px; backdrop-filter: blur(5px); }
        .nav-links a { text-decoration: none; color: white; font-weight: 600; font-size: 16px; transition: 0.3s; text-shadow: 1px 1px 2px black; }
        .nav-links a:hover, .nav-links a.active { color: #2ecc71; transform: scale(1.1); }

        /* BOUTON DÉCONNEXION */
        .logout-btn { position: absolute; right: 40px; background-color: #e74c3c; color: white; padding: 8px 20px; border-radius: 25px; text-decoration: none; font-weight: bold; font-size: 14px; box-shadow: 0 4px 10px rgba(0,0,0,0.3); }

        /* --- CONTENU SPÉCIFIQUE DOSSIER --- */
        .container { max-width: 1000px; margin: 120px auto 50px auto; padding: 0 20px; }

        /* CARTE EN VERRE */
        .glass-card {
            background: rgba(255, 255, 255, 0.95); /* Un peu plus opaque pour la lisibilité */
            backdrop-filter: blur(15px);
            padding: 30px; border-radius: 20px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.1); 
            border: 1px solid rgba(255,255,255,0.7);
            margin-bottom: 40px;
        }

        /* FICHE PATIENT */
        .patient-header { display: flex; align-items: center; gap: 25px; border-bottom: 2px solid #eee; padding-bottom: 20px; margin-bottom: 30px; }
        .avatar { width: 80px; height: 80px; background: #ecf0f1; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 35px; color: #3498db; border: 3px solid #3498db; }
        .info h1 { margin: 0; color: #2c3e50; font-size: 1.8em; }
        .info p { margin: 5px 0; color: #7f8c8d; }

        /* TIMELINE */
        .timeline { position: relative; padding-left: 30px; border-left: 3px solid #3498db; margin-left: 10px; }
        .rdv-block { position: relative; margin-bottom: 40px; }
        .rdv-point { position: absolute; left: -39px; top: 0; width: 15px; height: 15px; background: #3498db; border-radius: 50%; border: 3px solid white; box-shadow: 0 0 0 3px #ddd; }
        
        .rdv-content { background: #f8f9fa; border-radius: 10px; padding: 20px; border: 1px solid #eee; position: relative; }
        .rdv-content::before { content: ""; position: absolute; left: -10px; top: 5px; border-width: 10px 10px 10px 0; border-style: solid; border-color: transparent #f8f9fa transparent transparent; }

        .rdv-header { display: flex; justify-content: space-between; border-bottom: 1px solid #ddd; padding-bottom: 10px; margin-bottom: 10px; }
        .rdv-date { font-weight: bold; color: #2c3e50; font-size: 1.1em; }
        .rdv-status { font-size: 0.9em; font-weight: bold; padding: 3px 8px; border-radius: 5px; }

        /* Liste des Actes */
        .actes-list { list-style: none; padding: 0; margin: 0; }
        .acte-item { display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px dotted #ccc; font-size: 0.95em; }
        .acte-nom { font-weight: 600; color: #2c3e50; }
        .acte-desc { color: #7f8c8d; font-size: 0.9em; font-style: italic; margin-left: 10px; }
        .acte-prix { color: #27ae60; font-weight: bold; }

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
            <% if (d != null) { /* SI C'EST UN DENTISTE */ %>
            <li><a href="Controleur?action=espaceDentiste" class="active">📊 Tableau de Bord</a></li>
            <li><a href="Service.jsp">➕ Gérer les Services</a></li>
            
            <li><a href="Controleur?action=listerPubs">📢 Gérer les Publications</a></li>
            <% } else { /* SI C'EST UN PATIENT */ %>
                
            <li><a href="EspacePatient.jsp" class="active">Mon Espace</a></li>
            <li><a href="Controleur?action=voirProfil">⚙️ Mon Profil</a></li>
            
            <li><a href="Controleur?action=voirDossier&idPatient=<%= p.getIdP() %>">📂 Mon Dossier</a></li>
            
            <li><a href="Controleur?action=listerServices">🏥 Voir les Services</a></li>
            <li><a href="rendezvous.jsp">📅 Nouveau RDV</a></li>
            <li><a href="Controleur?action=murPublications">📰 Actualités</a></li>
        
            <% } %>
        </ul>
        
        <a href="${pageContext.request.contextPath}/Controleur?action=deconnexion" class="logout-btn">Déconnexion</a>
    </div>

    <div class="container">
        
        <div class="glass-card">
            
            <div class="patient-header">
                <div class="avatar">👤</div>
                <div class="info">
                    <h1><%= p.getNomP().toUpperCase() %> <%= p.getPrenomP() %></h1>
                    <p>📞 <%= (p.getTelP()!=null)?p.getTelP():"-" %> | 📧 <%= p.getEmailP() %></p>
                    <p>🩸 Groupe : <%= (p.getGroupeSanguinP()!=null)?p.getGroupeSanguinP():"-" %> | 🏠 <%= (p.getAdresseP()!=null)?p.getAdresseP():"-" %></p>
                </div>
            </div>

            <h2 style="color: #2c3e50; margin-bottom: 30px; border-left: 5px solid #2ecc71; padding-left: 15px;">
                📅 Historique des Consultations
            </h2>

            <div class="timeline">
                <% if (historique == null || historique.isEmpty()) { %>
                    <p style="color: #7f8c8d; font-style: italic; padding: 20px;">Aucun historique médical disponible pour le moment.</p>
                <% } else { 
                    for (Rendezvous r : historique) { %>
                    
                    <div class="rdv-block">
                        <div class="rdv-point" style="background: <%= "Validé".equals(r.getStatutRv()) ? "#27ae60" : "#95a5a6" %>; border-color: <%= "Validé".equals(r.getStatutRv()) ? "#27ae60" : "#ccc" %>;"></div>
                        
                        <div class="rdv-content">
                            <div class="rdv-header">
                                <span class="rdv-date">
                                    <%= (r.getDateRv()!=null)?sdf.format(r.getDateRv()):"" %> à <%= (r.getHeureRv()!=null)?shf.format(r.getHeureRv()):"" %>
                                </span>
                                <span class="rdv-status" style="background: <%= "Validé".equals(r.getStatutRv()) ? "#e8f8f5" : "#f4f6f7" %>; color: <%= "Validé".equals(r.getStatutRv()) ? "#27ae60" : "#7f8c8d" %>;">
                                    <%= r.getStatutRv() %>
                                </span>
                            </div>

                            <div style="margin-bottom: 15px; color: #555;">
                                <strong>Motif :</strong> <%= r.getDetailsRv() %>
                            </div>

                            <div style="background: white; padding: 15px; border-radius: 8px; border: 1px solid #e0e0e0;">
                                <strong style="color:#3498db; font-size:0.9em; text-transform:uppercase; display:block; margin-bottom:8px;">Soins & Actes réalisés :</strong>
                                <ul class="actes-list">
                                    <% 
                                        List<ActeMedical> actesDuRdv = mapActes.get(r.getIdRv());
                                        if (actesDuRdv != null && !actesDuRdv.isEmpty()) {
                                            for (ActeMedical a : actesDuRdv) { 
                                    %>
                                        <li class="acte-item">
                                            <div>
                                                <span class="acte-nom">• <%= a.getServiceMedical().getNomService() %></span>
                                                <span class="acte-desc"><%= (a.getDescriptionAM()!=null) ? "("+a.getDescriptionAM()+")" : "" %></span>
                                            </div>
                                            <span class="acte-prix"><%= a.getTarifAM() %> DT</span>
                                        </li>
                                    <%      } 
                                        } else { %>
                                        <li class="acte-item" style="color: #bdc3c7; font-style: italic;">Aucun acte enregistré pour ce rendez-vous.</li>
                                    <% } %>
                                </ul>
                            </div>

                        </div>
                    </div>

                <% } } %>
            </div>

        </div>
    </div>

</body>
</html>