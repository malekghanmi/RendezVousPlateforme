<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="tn.enit.entities.*, java.util.List, java.util.ArrayList, java.math.BigDecimal" %>

<%
    // 1. SÉCURITÉ
    Dentiste d = (Dentiste) session.getAttribute("dentisteConnecte");
    if (d == null) { response.sendRedirect("connexionDentiste.jsp"); return; }

    // 2. RÉCUPÉRATION DES DONNÉES
    Rendezvous rdv = (Rendezvous) request.getAttribute("leRdv");
    List<ActeMedical> actes = (List<ActeMedical>) request.getAttribute("listeActes");
    List<ServiceMedical> services = (List<ServiceMedical>) request.getAttribute("listeServices");

    if (actes == null) actes = new ArrayList<>();
    if (services == null) services = new ArrayList<>();
    
    double totalFacture = 0.0;
    for(ActeMedical a : actes) {
        if(a.getTarifAM() != null) totalFacture += a.getTarifAM().doubleValue();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Consultation - Smile Everyday</title>
    <style>
        /* --- CONFIGURATION DE BASE --- */
        html, body { margin: 0; padding: 0; height: 100%; overflow-x: hidden; font-family: 'Segoe UI', Arial, sans-serif; }

        /* --- FOND ANIMÉ (IDENTIQUE AUX AUTRES PAGES) --- */
        .slideshow { position: fixed; width: 100%; height: 100%; top: 0; left: 0; z-index: -1; list-style: none; margin: 0; padding: 0; }
        .slideshow li { width: 100%; height: 100%; position: absolute; background-size: cover; background-position: center; opacity: 0; filter: blur(1px); animation: imageAnimation 28s linear infinite; }
        .slideshow li:nth-child(1) { animation-delay: 0s; background-image: url('<%= request.getContextPath() %>/images/image2.png'); }
        .slideshow li:nth-child(2) { animation-delay: 4s; background-image: url('<%= request.getContextPath() %>/images/image3.png'); }
        .slideshow li:nth-child(3) { animation-delay: 8s; background-image: url('<%= request.getContextPath() %>/images/image6.png'); }
        .slideshow li:nth-child(4) { animation-delay: 12s; background-image: url('<%= request.getContextPath() %>/images/image11.png'); }
        
        @keyframes imageAnimation { 0% { opacity: 0; } 8% { opacity: 1; } 14% { opacity: 1; } 22% { opacity: 0; } 100% { opacity: 0; } }

        /* --- HEADER HARMONISÉ --- */
        .header { position: fixed; top: 0; left: 0; width: 100%; height: 90px; background: transparent; display: flex; justify-content: center; align-items: center; padding: 0 40px; z-index: 1000; box-sizing: border-box; }
        .logo { position: absolute; left: 40px; font-size: 1.8em; font-weight: bold; color: white; text-transform: uppercase; text-shadow: 2px 2px 4px rgba(0,0,0,0.5); }
        .logo span { color: #2ecc71; }
        .nav-links { list-style: none; display: flex; gap: 30px; background: rgba(0,0,0,0.3); padding: 10px 30px; border-radius: 50px; backdrop-filter: blur(5px); }
        .nav-links a { text-decoration: none; color: white; font-weight: 600; text-shadow: 1px 1px 2px black; }
        .nav-links a:hover { color: #2ecc71; }

        /* --- CONTENU --- */
        .container { max-width: 1100px; margin: 120px auto 50px auto; padding: 0 20px; display: grid; grid-template-columns: 1fr 2fr; gap: 30px; }

        /* --- GLASS CARD STYLE --- */
        .glass-card { 
            background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(15px);
            padding: 30px; border-radius: 20px; box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            border: 1px solid rgba(255,255,255,0.7);
        }

        .patient-header { text-align: center; border-bottom: 1px solid #eee; padding-bottom: 20px; margin-bottom: 20px; }
        .patient-name { font-size: 1.4em; color: #2c3e50; font-weight: bold; }
        
        .rdv-info-box { background: #eafaf1; color: #27ae60; padding: 15px; border-radius: 12px; font-size: 0.9em; border-left: 5px solid #2ecc71; }

        /* --- FORMULAIRE --- */
        .form-acte { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-bottom: 30px; }
        .full-width { grid-column: 1 / -1; }
        
        input, select, textarea { padding: 12px; border-radius: 10px; border: 1px solid #ddd; font-family: inherit; }
        .btn-add { background: linear-gradient(45deg, #2ecc71, #27ae60); color: white; border: none; padding: 12px; border-radius: 50px; cursor: pointer; font-weight: bold; transition: 0.3s; grid-column: 1 / -1; }
        .btn-add:hover { transform: scale(1.02); box-shadow: 0 5px 15px rgba(46,204,113,0.3); }

        /* --- TABLEAU --- */
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { text-align: left; padding: 12px; color: #7f8c8d; border-bottom: 2px solid #eee; font-size: 14px; }
        td { padding: 15px 12px; border-bottom: 1px solid #eee; }
        .total-section { margin-top: 30px; text-align: right; font-size: 1.6em; font-weight: bold; color: #2c3e50; border-top: 2px solid #2ecc71; padding-top: 15px; }
        
        .btn-del { background: #fff5f5; color: #e74c3c; border: 1px solid #ffe3e3; padding: 5px 10px; border-radius: 8px; cursor: pointer; }
        .btn-del:hover { background: #e74c3c; color: white; }
    </style>

    <script>
        function updatePrix() {
            var select = document.getElementById("serviceSelect");
            var prixInput = document.getElementById("prixInput");
            var prix = select.options[select.selectedIndex].getAttribute("data-prix");
            prixInput.value = prix;
        }
    </script>
</head>
<body>

    <ul class="slideshow"><li></li><li></li><li></li><li></li></ul>

    <div class="header">
        <div class="logo">Smile <span>Docteur</span></div>
        <ul class="nav-links">
            <li><a href="Controleur?action=espaceDentiste">📊 Dashboard</a></li>
            <li><a href="Controleur?action=listerServicesMedical">🛠️ Services</a></li>
            <li><a href="Controleur?action=listerPubs">📢 Publications</a></li>
        </ul>
    </div>

    <div class="container">
        <div class="glass-card">
            <div class="patient-header">
                <div style="font-size: 50px;">👤</div>
                <div class="patient-name"><%= rdv.getPatient().getNomP().toUpperCase() %> <%= rdv.getPatient().getPrenomP() %></div>
            </div>
            <p><strong>Date de naissance:</strong> <%= rdv.getPatient().getDateNP() %></p>
            <p><strong>Téléphone:</strong> <%= rdv.getPatient().getTelP() %></p>
            <div class="rdv-info-box">
                <strong>Motif:</strong> <%= rdv.getDetailsRv() %>
            </div>
        </div>

        <div class="glass-card">
            <h2 style="margin-top:0; color:#2c3e50;">🩺 Soins effectués</h2>
            
            <form action="Controleur" method="post" class="form-acte">
                <input type="hidden" name="action" value="ajouterActe">
                <input type="hidden" name="idRdv" value="<%= rdv.getIdRv() %>">

                <div class="full-width">
                    <label>Soin effectué :</label><br>
                    <select name="idService" id="serviceSelect" onchange="updatePrix()" required style="width:100%">
                        <option value="" data-prix="">-- Sélectionner un service --</option>
                        <% for(ServiceMedical s : services) { %>
                            <option value="<%= s.getIdService() %>" data-prix="<%= s.getTarifService() %>">
                                <%= s.getNomService() %>
                            </option>
                        <% } %>
                    </select>
                </div>

                <div class="full-width">
                    <label>Notes (optionnel) :</label>
                    <textarea name="description" rows="2" style="width:100%" placeholder="Observations sur l'acte..."></textarea>
                </div>

                <div class="full-width">
                    <label>Prix appliqué (DT) :</label>
                    <input type="number" step="0.5" name="prix" id="prixInput" required style="width:100%">
                </div>

                <button type="submit" class="btn-add">Ajouter au bilan</button>
            </form>

            <table>
                <thead>
                    <tr>
                        <th>Acte</th>
                        <th>Prix</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(ActeMedical a : actes) { %>
                        <tr>
                            <td><strong><%= a.getServiceMedical().getNomService() %></strong><br>
                                <small style="color:#7f8c8d"><%= (a.getDescriptionAM() != null) ? a.getDescriptionAM() : "" %></small>
                            </td>
                            <td style="font-weight:bold;"><%= a.getTarifAM() %> DT</td>
                            <td>
                                <form action="Controleur" method="post" onsubmit="return confirm('Supprimer ?');">
                                    <input type="hidden" name="action" value="supprimerActe">
                                    <input type="hidden" name="idActe" value="<%= a.getIdAM() %>">
                                    <input type="hidden" name="idRdv" value="<%= rdv.getIdRv() %>">
                                    <button type="submit" class="btn-del">🗑️</button>
                                </form>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>

            <div class="total-section">
                Total Facturé : <span style="color:#27ae60;"><%= totalFacture %> DT</span>
            </div>
        </div>
    </div>

</body>
</html>