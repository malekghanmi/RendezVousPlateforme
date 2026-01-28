<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="tn.enit.entities.*, java.util.List, java.util.ArrayList, java.math.BigDecimal" %>

<%
    // Sécurité Patient
    Patient p = (Patient) session.getAttribute("patientConnecte");
    if (p == null) { response.sendRedirect("connexion.jsp"); return; }

    // Récupération des données
    Rendezvous rdv = (Rendezvous) request.getAttribute("leRdv");
    List<ActeMedical> actes = (List<ActeMedical>) request.getAttribute("listeActes");
    if (actes == null) actes = new ArrayList<>();

    // Calcul du total
    double total = 0.0;
    for(ActeMedical a : actes) {
        if(a.getTarifAM() != null) total += a.getTarifAM().doubleValue();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Détail des Soins - Facture</title>
    <style>
        body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; background: #555; padding: 40px; }
        
        .invoice-box {
            max-width: 800px; margin: auto; padding: 30px;
            border: 1px solid #eee; background: white;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.15); border-radius: 10px;
        }
        
        .header-invoice { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #eee; padding-bottom: 20px; margin-bottom: 20px; }
        .logo { font-size: 24px; font-weight: bold; color: #2c3e50; }
        .logo span { color: #2ecc71; }
        
        .info-section { display: flex; justify-content: space-between; margin-bottom: 40px; }
        .info-box h3 { margin-top: 0; color: #3498db; font-size: 16px; text-transform: uppercase; }
        .info-box p { margin: 5px 0; color: #555; font-size: 14px; }
        
        table { width: 100%; line-height: inherit; text-align: left; border-collapse: collapse; }
        table th { background: #f8f9fa; color: #333; font-weight: bold; padding: 12px; border-bottom: 2px solid #ddd; }
        table td { padding: 12px; border-bottom: 1px solid #eee; color: #555; }
        
        .total-row td { border-top: 2px solid #333; font-weight: bold; font-size: 1.2em; color: #2c3e50; padding-top: 20px; }
        
        /* Styles des boutons */
        .btn-print { background: #2c3e50; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer; margin-top: 20px; font-size: 16px; transition: 0.3s; }
        .btn-print:hover { background: #34495e; }
        
        .btn-pdf { background: #e74c3c; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer; margin-top: 20px; font-size: 16px; text-decoration: none; display: inline-block; transition: 0.3s; margin-left: 10px; }
        .btn-pdf:hover { background: #c0392b; }

        .btn-back { text-decoration: none; color: #7f8c8d; font-size: 14px; display: inline-block; margin-top: 20px; margin-left: 20px;}

        /* Pour l'impression papier, on cache les boutons */
        @media print {
            body { background: white; padding: 0; }
            .invoice-box { box-shadow: none; border: none; }
            .btn-print, .btn-pdf, .btn-back { display: none; }
        }
    </style>
</head>
<body>

    <div class="invoice-box">
        <div class="header-invoice">
            <div class="logo">Smile <span>Everyday</span></div>
            <div style="text-align: right; color: #7f8c8d;">
                Facture N° #<%= rdv.getIdRv() %><br>
                Date : <%= rdv.getDateRv() %>
            </div>
        </div>

        <div class="info-section">
            <div class="info-box">
                <h3>Patient</h3>
                <p><strong><%= p.getNomP().toUpperCase() %> <%= p.getPrenomP() %></strong></p>
                <p><%= (p.getAdresseP()!=null) ? p.getAdresseP() : "" %></p>
                <p><%= p.getEmailP() %></p>
            </div>
            <div class="info-box" style="text-align: right;">
                <h3>Praticien</h3>
                <p><strong>Dr. <%= rdv.getDentiste().getNomD() %> <%= rdv.getDentiste().getPrenomD() %></strong></p>
                <p>Chirurgien Dentiste</p>
                <p>Cabinet Smile Everyday</p>
            </div>
        </div>

        <table>
            <thead>
                <tr>
                    <th>Description du Soin</th>
                    <th>Détails Techniques</th>
                    <th style="text-align: right;">Montant</th>
                </tr>
            </thead>
            <tbody>
                <% if(actes.isEmpty()) { %>
                    <tr><td colspan="3" style="text-align:center; padding:30px;">Aucun acte facturé pour ce rendez-vous.</td></tr>
                <% } else { 
                    for(ActeMedical a : actes) { %>
                    <tr>
                        <td><%= a.getServiceMedical().getNomService() %></td>
                        <td><%= (a.getDescriptionAM() != null) ? a.getDescriptionAM() : "-" %></td>
                        <td style="text-align: right;"><%= a.getTarifAM() %> DT</td>
                    </tr>
                <% } } %>
                
                <tr class="total-row">
                    <td></td>
                    <td style="text-align: right;">TOTAL À PAYER :</td>
                    <td style="text-align: right; color: #27ae60;"><%= total %> DT</td>
                </tr>
            </tbody>
        </table>

        <div>
            <button onclick="window.print()" class="btn-print">🖨️ Imprimer</button>
            
            <a href="Controleur?action=telechargerFacturePDF&idRdv=<%= rdv.getIdRv() %>" class="btn-pdf">
                📥 Télécharger PDF
            </a>

            <a href="EspacePatient.jsp" class="btn-back">⬅ Retour à mon espace</a>
        </div>
    </div>

</body>
</html>