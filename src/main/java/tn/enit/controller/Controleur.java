package tn.enit.controller;
import java.util.Map;
import java.util.HashMap;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import tn.enit.entities.*;
import tn.enit.services.interfaces.GestionMedicaleLocal;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

@MultipartConfig
@WebServlet("/Controleur")
public class Controleur extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // DOSSIER DE STOCKAGE (Doit exister sur votre PC)
    private static final String UPLOAD_DIR = "C:/smile_uploads";

    @EJB
    
    private GestionMedicaleLocal service;

    public Controleur() { super(); }

    // --- 1. MÉTHODE POUR RÉCUPÉRER LE NOM DU FICHIER ---
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        for (String content : contentDisp.split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf("=") + 2, content.length() - 1);
            }
        }
        return "";
    }

    // --- 2. MÉTHODE POUR SAUVEGARDER SUR LE DISQUE ---
    private String sauvegarderFichier(Part part) throws IOException {
        String fileName = getFileName(part);
        if (fileName != null && !fileName.isEmpty()) {
            File uploadDir = new File(UPLOAD_DIR);
            if (!uploadDir.exists()) uploadDir.mkdir();
            
            File file = new File(uploadDir, fileName);
            try (java.io.InputStream input = part.getInputStream()) {
                Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }
            return fileName;
        }
        return null;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            // -----------------------------------------------------------
            // GESTION DU TÉLÉCHARGEMENT
            // -----------------------------------------------------------
            if ("telechargerCV".equals(action)) {
                String fileName = request.getParameter("fichier");
                File file = new File(UPLOAD_DIR, fileName);

                if (file.exists()) {
                    response.setContentType("application/octet-stream");
                    response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
                    
                    try (FileInputStream in = new FileInputStream(file);
                         OutputStream out = response.getOutputStream()) {
                        byte[] buffer = new byte[4096];
                        int length;
                        while ((length = in.read(buffer)) > 0) {
                            out.write(buffer, 0, length);
                        }
                    }
                } else {
                    response.getWriter().write("Erreur : Fichier introuvable.");
                }
                return; 
            }

            // -----------------------------------------------------------
            // INSCRIPTION PATIENT
            // -----------------------------------------------------------
            if ("inscriptionPatient".equals(action)) {
                // 1. Récupération des paramètres
                String nom = request.getParameter("nom");
                String prenom = request.getParameter("prenom");
                String adresse = request.getParameter("adresse");
                String tel = request.getParameter("tel");
                String email = request.getParameter("email");
                String mdp = request.getParameter("mdp");
                String sexe = request.getParameter("sexe");
                String recouvrement = request.getParameter("recouvrement");
                String groupe = request.getParameter("groupe");
                String dateStr = request.getParameter("dateN");

                // 2. VALIDATIONS DES RESTRICTIONS
                // Téléphone : exactement 8 chiffres
                boolean telValide = (tel != null && tel.matches("[0-9]{8}"));
                
                // Mot de passe : minimum 8 caractères
                boolean mdpValide = (mdp != null && mdp.length() >= 8);
                
                // Email : présence de @ et .
                boolean emailValide = (email != null && email.matches("^[A-Za-z0-9+_.-]+@(.+)$"));

                if (telValide && mdpValide && emailValide) {
                    Patient p = new Patient();
                    p.setNomP(nom);
                    p.setPrenomP(prenom);
                    p.setAdresseP(adresse);
                    p.setTelP(tel);
                    p.setEmailP(email);
                    p.setMdpP(mdp);
                    p.setSexeP(sexe);
                    p.setRecouvrementP(recouvrement);
                    p.setGroupeSanguinP(groupe);

                    // Gestion de la date
                    try {
                        if (dateStr != null && !dateStr.isEmpty()) {
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                            p.setDateNP(sdf.parse(dateStr));
                        } else {
                            p.setDateNP(new java.util.Date());
                        }
                    } catch (Exception e) {
                        p.setDateNP(new java.util.Date());
                    }

                    // 3. Persistance via EJB
                    if (service != null) {
                        service.ajouterPatient(p);
                        response.sendRedirect("validerInscription.jsp");
                    }
                } else {
                    // 4. Gestion d'erreur (si les restrictions ne sont pas respectées)
                    String msgErreur = "Erreur : ";
                    if (!telValide) msgErreur += "Le téléphone doit avoir 8 chiffres. ";
                    if (!mdpValide) msgErreur += "Le mot de passe doit avoir au moins 8 caractères. ";
                    if (!emailValide) msgErreur += "L'email est invalide.";
                    
                    request.setAttribute("erreur", msgErreur);
                    request.getRequestDispatcher("inscriptionPatient.jsp").forward(request, response);
                }
            }
            // -----------------------------------------------------------
            // INSCRIPTION AIDE-SOIGNANT
            // -----------------------------------------------------------
            else if ("inscriptionAideSoignant".equals(action)) {
                AideSoignant as = new AideSoignant();
                as.setNomAS(request.getParameter("nom"));
                as.setPrenomAS(request.getParameter("prenom"));
                as.setAdresseAS(request.getParameter("adresse")); 
                as.setEmailAS(request.getParameter("email"));
                as.setTelAS(request.getParameter("tel"));
                as.setMdpAS(request.getParameter("mdp"));
                as.setDiplomeAS(request.getParameter("diplome"));
                as.setSexeAS(request.getParameter("sexe"));
                as.setStatut("En attente");

                String dateStr = request.getParameter("dateN");
                if(dateStr != null && !dateStr.isEmpty()) {
                    try {
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                        as.setDateNAS(sdf.parse(dateStr));
                    } catch (Exception e) { e.printStackTrace(); }
                }

                try {
                    Part partPhoto = request.getPart("photo");
                    String photoName = sauvegarderFichier(partPhoto);
                    as.setPhoto(photoName != null ? photoName : "default.png");

                    Part partCV = request.getPart("cv");
                    String cvName = sauvegarderFichier(partCV);
                    as.setCv(cvName != null ? cvName : "Non fourni");
                } catch(Exception ex) {
                    System.out.println("Erreur upload : " + ex.getMessage());
                }

                if (service != null) {
                    service.ajouterAideSoignant(as);
                    
                    
                    response.sendRedirect("verificationAS.jsp");
                }
            }
         // -----------------------------------------------------------
            // ACTIONS SERVICES MÉDICAUX
            // -----------------------------------------------------------
           
         // On traite les deux actions en une seule fois
            else if ("listerServicesMedical".equals(action) || "listerServices".equals(action)) {
                
                // 1. Récupération commune des données
                List<ServiceMedical> liste = service.listerServices(); 
                request.setAttribute("listeServices", liste);
                
                // 2. Choix de la page de destination
                String pageDestination = "listerServices".equals(action) ? "ListeServices.jsp" : "Service.jsp";
                
                request.getRequestDispatcher(pageDestination).forward(request, response);
            }
            // -----------------------------------------------------------
            // CONNEXION PATIENT
            // -----------------------------------------------------------
            else if ("connexion".equals(action)) {
                String email = request.getParameter("email"); 
                String mdp = request.getParameter("mdp");
                Patient p = service.verifierConnexionPatient(email, mdp);
                
                if (p != null) { 
                    HttpSession session = request.getSession(); 
                    session.setAttribute("patientConnecte", p);
                    List<Rendezvous> mesRdv = service.listerRendezvousParPatient(p.getIdP()); 
                    session.setAttribute("mesRdv", mesRdv);
                    response.sendRedirect("EspacePatient.jsp"); 
                } else { 
                    response.sendRedirect("connexion.jsp?error=login_failed"); 
                }
            }
            
            // -----------------------------------------------------------
            // LISTER SERVICES (PATIENT)
            // -----------------------------------------------------------
            
            
            // -----------------------------------------------------------
            // DÉCONNEXION
            // -----------------------------------------------------------
            else if ("deconnexion".equals(action)) { 
                HttpSession session = request.getSession(false); 
                if (session != null) session.invalidate(); 
                response.sendRedirect("index.jsp"); 
            }
            
            // -----------------------------------------------------------
            // AJOUT RDV
            // -----------------------------------------------------------
            else if ("ajoutRDV".equals(action)) {
                HttpSession session = request.getSession(); 
                Patient patient = (Patient) session.getAttribute("patientConnecte");
                if (patient == null) { response.sendRedirect("connexion.jsp"); return; }
                
                Rendezvous rdv = new Rendezvous(); 
                rdv.setPatient(patient); 
                
                String dateStr = request.getParameter("dateRDV"); 
                String heureStr = request.getParameter("heureRDV");
                
                if (dateStr != null) { 
                    SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd"); 
                    rdv.setDateRv(sdfDate.parse(dateStr)); 
                }
                if (heureStr != null) { 
                    try { 
                        SimpleDateFormat sdfHeure = new SimpleDateFormat("HH:mm"); 
                        rdv.setHeureRv(sdfHeure.parse(heureStr)); 
                    } catch (Exception ex) { 
                        SimpleDateFormat sdfHeureLong = new SimpleDateFormat("HH:mm:ss"); 
                        rdv.setHeureRv(sdfHeureLong.parse(heureStr)); 
                    } 
                }
                rdv.setDetailsRv("Service: " + request.getParameter("categorieService") + " | " + request.getParameter("details"));
                rdv.setStatutRv("En attente"); 
                
                service.prendreRendezvous(rdv);
                
                List<Rendezvous> mesRdv = service.listerRendezvousParPatient(patient.getIdP()); 
                session.setAttribute("mesRdv", mesRdv);
                response.sendRedirect("SuccesRDV.jsp");
            }

            // -----------------------------------------------------------
            // AJOUT SERVICE (ADMIN/DENTISTE)
            // -----------------------------------------------------------
            else if ("ajoutService".equals(action)) {
                ServiceMedical sm = new ServiceMedical();
                sm.setNomService(request.getParameter("nomSM"));
                sm.setTypeService(request.getParameter("typeSM"));
                sm.setDescriptionService(request.getParameter("descriptionSM"));
                
                if (request.getParameter("tarifSM") != null) sm.setTarifService(Double.parseDouble(request.getParameter("tarifSM")));
                if (request.getParameter("nbSeances") != null) sm.setNbSeances(Integer.parseInt(request.getParameter("nbSeances")));
                
                service.ajouterService(sm);

                // --- LA CORRECTION ICI ---
                // On ne va plus vers SuccesService.jsp, on recharge la liste
                response.sendRedirect("SuccesService.jsp");
            }
            
            // -----------------------------------------------------------
            // CONNEXION DENTISTE
            // -----------------------------------------------------------
            else if ("connexionDentiste".equals(action)) {
                Dentiste d = service.verifierConnexionDentiste(request.getParameter("email"), request.getParameter("mdp"));
                if (d != null) { 
                    HttpSession session = request.getSession(); 
                    session.setAttribute("dentisteConnecte", d); 
                    response.sendRedirect("Controleur?action=espaceDentiste"); 
                } else { 
                    response.sendRedirect("connexionDentiste.jsp?error=bad_login"); 
                }
            }
            
            // -----------------------------------------------------------
            // ESPACE DENTISTE (Chargement des données)
            // -----------------------------------------------------------
         // =========================================================
            //  GESTION PROFIL PATIENT
            // =========================================================
            
            // 1. Afficher la page Profil
            else if ("voirProfil".equals(action)) {
                // On recharge le patient depuis la BDD pour avoir les infos fraîches
                Patient pSession = (Patient) request.getSession().getAttribute("patientConnecte");
                Patient pAjour = service.trouverPatient(pSession.getIdP());
                
                request.setAttribute("patient", pAjour);
                request.getRequestDispatcher("ProfilPatient.jsp").forward(request, response);
            }

            // 2. Enregistrer les modifications
            else if ("updateProfil".equals(action)) {
                HttpSession session = request.getSession();
                Patient pSession = (Patient) session.getAttribute("patientConnecte");
                
                // On récupère le patient original
                Patient p = service.trouverPatient(pSession.getIdP());
                
                // Mise à jour des textes
                p.setTelP(request.getParameter("tel"));
                p.setAdresseP(request.getParameter("adresse"));
                p.setEmailP(request.getParameter("email"));
                p.setMdpP(request.getParameter("mdp")); // En vrai projet, il faudrait le chiffrer
                
                // GESTION DE LA PHOTO (Même logique que les Publications)
                try {
                    Part partPhoto = request.getPart("photo");
                    // On vérifie si l'utilisateur a envoyé une nouvelle photo
                    if (partPhoto != null && partPhoto.getSize() > 0) {
                        String photoName = sauvegarderFichier(partPhoto);
                        p.setPhoto(photoName);
                    }
                } catch (Exception e) {
                    // Pas de nouvelle photo, on garde l'ancienne
                }

                // Sauvegarde en base
                service.modifierPatient(p);
                
                // IMPORTANT : Mettre à jour la session pour que le header change tout de suite
                session.setAttribute("patientConnecte", p);
                
                // Retour au profil avec message de succès
                response.sendRedirect("Controleur?action=voirProfil&success=1");
            }
            else if ("espaceDentiste".equals(action)) {
                HttpSession session = request.getSession(); 
                Dentiste d = (Dentiste) session.getAttribute("dentisteConnecte");
                if (d == null) { response.sendRedirect("connexionDentiste.jsp"); return; }
                
                // 1. Récupération des paramètres de recherche du formulaire
                String txtRecherche = request.getParameter("txtRecherche");
                String dateRecherche = request.getParameter("dateRecherche");
                
                List<Rendezvous> listeValide;

                // 2. Logique de filtrage
                if ((txtRecherche != null && !txtRecherche.isEmpty()) || (dateRecherche != null && !dateRecherche.isEmpty())) {
                    // Si recherche active
                    Date dateFiltre = null;
                    if(dateRecherche != null && !dateRecherche.isEmpty()) {
                        try { dateFiltre = new SimpleDateFormat("yyyy-MM-dd").parse(dateRecherche); } catch(Exception e){}
                    }
                    listeValide = service.rechercherRendezvous(txtRecherche, dateFiltre);
                } else {
                    // Sinon, liste normale
                    listeValide = service.listerRendezvousValides();
                }

                // 3. Envoi des données (Listes + Stats comme avant)
                request.setAttribute("listeAttente", service.listerRendezvousEnAttente()); 
                request.setAttribute("listeValide", listeValide); // La liste filtrée ou normale
                request.setAttribute("listeAS", service.listerAideSoignants());
                
                // Pour réafficher ce qu'on a tapé dans la barre de recherche (UX)
                request.setAttribute("txtRecherche", txtRecherche);
                request.setAttribute("dateRecherche", dateRecherche);

                request.getRequestDispatcher("EspaceDentiste.jsp").forward(request, response);
            }
            
            // -----------------------------------------------------------
            // ACTIONS DENTISTE (Valider/Refuser RDV & AS)
            // -----------------------------------------------------------
            else if ("validerRDV_Dentiste".equals(action)) { 
                Dentiste d = (Dentiste) request.getSession().getAttribute("dentisteConnecte"); 
                if(d != null) service.validerRendezvous(Integer.parseInt(request.getParameter("idRdv")), d.getIdD()); 
                response.sendRedirect("Controleur?action=espaceDentiste"); 
            }
            else if ("refuserRDV_Dentiste".equals(action)) { 
                Dentiste d = (Dentiste) request.getSession().getAttribute("dentisteConnecte"); 
                if(d != null) service.refuserRendezvous(Integer.parseInt(request.getParameter("idRdv")), d.getIdD()); 
                response.sendRedirect("Controleur?action=espaceDentiste"); 
            }
            else if ("validerAS".equals(action)) { 
                service.validerAideSoignant(Integer.parseInt(request.getParameter("id"))); 
                response.sendRedirect("Controleur?action=espaceDentiste"); 
            }
            else if ("supprimerAS".equals(action)) { 
                service.supprimerAideSoignant(Integer.parseInt(request.getParameter("id"))); 
                response.sendRedirect("Controleur?action=espaceDentiste"); 
            }
            else if ("supprimerRDV".equals(action)) { 
                service.supprimerRendezvous(Integer.parseInt(request.getParameter("id"))); 
                response.sendRedirect("Controleur?action=espaceDentiste"); 
            }
            

            // =========================================================
            //  GESTION DES PUBLICATIONS (Blog)
            // =========================================================
            
            // 1. Lister
            else if ("listerPubs".equals(action)) {
                List<Publication> liste = service.listerPublications();
                request.setAttribute("mesPubs", liste);
                request.getRequestDispatcher("Publication.jsp").forward(request, response);
            }

            // 2. Ajouter
            else if ("ajoutPublication".equals(action)) {
                Publication pub = new Publication();
                pub.setTitre(request.getParameter("titre"));
                pub.setContenu(request.getParameter("contenu"));

                String dateStr = request.getParameter("date");
                if (dateStr != null && !dateStr.isEmpty()) {
                    try { pub.setDatePub(new SimpleDateFormat("yyyy-MM-dd").parse(dateStr)); } 
                    catch (Exception e) { pub.setDatePub(new Date()); }
                } else { pub.setDatePub(new Date()); }

                try {
                    Part partImage = request.getPart("image");
                    String imgName = sauvegarderFichier(partImage);
                    pub.setImage(imgName); 
                } catch (Exception e) { pub.setImage(null); }

                service.ajouterPublication(pub); 
                response.sendRedirect("Controleur?action=listerPubs");
            }
            
            // 3. Supprimer
            else if ("supprimerPub".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                service.supprimerPublication(id);
                response.sendRedirect("Controleur?action=listerPubs");
            }
            else if ("supprimerService".equals(action)) {
                // On récupère l'ID du service
            	int idService = Integer.parseInt(request.getParameter("id"));
                
                // Appel de la méthode de suppression dans ton EJB
                service.supprimerService(idService);
                
                // Redirection vers la liste des services pour rafraîchir l'affichage
                response.sendRedirect("Controleur?action=listerServicesMedical");
            }
         // ... après le bloc supprimerPub ...

            // 4. ACTION SPECIALE : AFFICHER IMAGE DEPUIS C:
            else if ("afficherImage".equals(action)) {
                String imgName = request.getParameter("image");
                File file = new File(UPLOAD_DIR, imgName);

                if (file.exists()) {
                    // On dit au navigateur que c'est une image
                    response.setContentType("image/jpeg"); 
                    try (FileInputStream in = new FileInputStream(file);
                         OutputStream out = response.getOutputStream()) {
                        
                        // On copie l'image vers le navigateur
                        byte[] buffer = new byte[4096];
                        int length;
                        while ((length = in.read(buffer)) > 0) {
                            out.write(buffer, 0, length);
                        }
                    }
                }
                return; // On arrête ici, pas de redirection
            }

            // ... avant le dernier else ...
         // =========================================================
            //  MUR PUBLICATIONS (POUR LE PATIENT)
            // =========================================================
            else if ("murPublications".equals(action)) {
                // 1. Récupérer la liste
                List<Publication> liste = service.listerPublications();
                
                // 2. Envoyer à la nouvelle JSP
                request.setAttribute("lesPubs", liste);
                
                // 3. Rediriger vers la page "Mur"
                request.getRequestDispatcher("MurPublications.jsp").forward(request, response);
            }
         // -----------------------------------------------------------
            // ACTION INDISPENSABLE : SERVIR L'IMAGE DEPUIS C:/
            // -----------------------------------------------------------
            else if ("afficherImage".equals(action)) {
                String imgName = request.getParameter("image");
                if (imgName == null || imgName.isEmpty()) return;

                File file = new File(UPLOAD_DIR, imgName);

                if (file.exists()) {
                    // On dit au navigateur que c'est une image
                    response.setContentType("image/jpeg"); 
                    try (FileInputStream in = new FileInputStream(file);
                         OutputStream out = response.getOutputStream()) {
                        
                        byte[] buffer = new byte[4096];
                        int length;
                        while ((length = in.read(buffer)) > 0) {
                            out.write(buffer, 0, length);
                        }
                    }
                }
                return; // On arrête ici pour ne pas rediriger
            }
         // =========================================================
            //  FACTURE PATIENT (POUR QU'IL VOIT SES SOINS)
            // =========================================================
            else if ("voirFacture".equals(action)) {
                int idRdv = Integer.parseInt(request.getParameter("idRdv"));
                
                // 1. On récupère le RDV et les Actes
                Rendezvous rdv = service.trouverRendezvous(idRdv);
                List<ActeMedical> actes = service.listerActesParRendezvous(idRdv);
                
                // 2. On envoie tout à la page de facture
                request.setAttribute("leRdv", rdv);
                request.setAttribute("listeActes", actes);
                
                request.getRequestDispatcher("Facture.jsp").forward(request, response);
            }
         // =========================================================
            //  GESTION DES ACTES (CONSULTATION DENTISTE)
            // =========================================================

            // 1. Accéder à la page de consultation pour un RDV précis
            else if ("detailsRDV".equals(action)) {
                int idRdv = Integer.parseInt(request.getParameter("idRdv"));
                
                // On récupère le RDV pour afficher les infos du patient
             // CORRECTION : On demande au service
                Rendezvous rdv = service.trouverRendezvous(idRdv); // Idéalement via une méthode service.trouverRendezvous(id)
                
                // On récupère les actes déjà faits pour ce RDV
                List<ActeMedical> actes = service.listerActesParRendezvous(idRdv);
                
                // On a besoin de la liste des services pour le menu déroulant (pour en ajouter un nouveau)
                List<ServiceMedical> services = service.listerServices();

                request.setAttribute("leRdv", rdv);
                request.setAttribute("listeActes", actes);
                request.setAttribute("listeServices", services);

                request.getRequestDispatcher("Consultation.jsp").forward(request, response);
            }

            // 2. Ajouter un acte à ce RDV
            else if ("ajouterActe".equals(action)) {
                int idRdv = Integer.parseInt(request.getParameter("idRdv"));
                int idService = Integer.parseInt(request.getParameter("idService"));
                String desc = request.getParameter("description");
                String prixStr = request.getParameter("prix");

                // On récupère les objets liés
                // Note : Vous devrez peut-être ajouter 'trouverRendezvous' et 'trouverService' dans votre interface si ce n'est pas fait.
                // Pour simplifier ici, je suppose que vous pouvez les récupérer ou le faire via le service.
                
                Rendezvous rdv = new Rendezvous(); rdv.setIdRv(idRdv); // Astuce pour lier par ID sans chercher tout l'objet
                ServiceMedical sm = new ServiceMedical(); // Au lieu de sm.setId(idService);
                sm.setIdService(idService); // Idem (vérifiez le nom de l'ID dans ServiceMedical)

                ActeMedical acte = new ActeMedical();
                acte.setRendezvous(rdv);
                acte.setServiceMedical(sm);
                acte.setDescriptionAM(desc);
                
                // Conversion du prix (BigDecimal)
                if (prixStr != null && !prixStr.isEmpty()) {
                    acte.setTarifAM(new java.math.BigDecimal(prixStr));
                }

                service.ajouterActe(acte);

                // On recharge la page de consultation
                response.sendRedirect("Controleur?action=detailsRDV&idRdv=" + idRdv);
            }
            
            // 3. Supprimer un acte (en cas d'erreur)
            else if ("supprimerActe".equals(action)) {
                int idActe = Integer.parseInt(request.getParameter("idActe"));
                int idRdv = Integer.parseInt(request.getParameter("idRdv")); // On le garde pour revenir à la bonne page
                
                service.supprimerActe(idActe);
                
                response.sendRedirect("Controleur?action=detailsRDV&idRdv=" + idRdv);
            }
         // =========================================================
            //  VOIR DOSSIER MÉDICAL (HISTORIQUE COMPLET)
            // =========================================================
            else if ("voirDossier".equals(action)) {
                int idPatient = Integer.parseInt(request.getParameter("idPatient"));
                
                // 1. Infos du Patient
                Patient p = service.trouverPatient(idPatient);
                
                // 2. Tous ses Rendez-vous (Passés et Futurs)
                List<Rendezvous> listeRdv = service.listerRendezvousParPatient(idPatient);
                
                // 3. Les Actes pour chaque RDV (Astuce : on utilise une Map)
                Map<Integer, List<ActeMedical>> mapActes = new HashMap<>();
                
                if (listeRdv != null) {
                    for (Rendezvous r : listeRdv) {
                        List<ActeMedical> actes = service.listerActesParRendezvous(r.getIdRv());
                        mapActes.put(r.getIdRv(), actes);
                    }
                }

                // 4. Envoi à la JSP
                request.setAttribute("lePatient", p);
                request.setAttribute("historiqueRdv", listeRdv);
                request.setAttribute("mapActes", mapActes); // On envoie la Map des actes
                
                request.getRequestDispatcher("DossierMedical.jsp").forward(request, response);
            }
            else if ("espaceDentiste".equals(action)) {
                HttpSession session = request.getSession(); 
                Dentiste d = (Dentiste) session.getAttribute("dentisteConnecte");
                if (d == null) { response.sendRedirect("connexionDentiste.jsp"); return; }
                
                // --- RECUPERATION DES LISTES (Code existant) ---
                request.setAttribute("listeAttente", service.listerRendezvousEnAttente()); 
                request.setAttribute("listeValide", service.listerRendezvousValides());
                request.setAttribute("listeAS", service.listerAideSoignants());
                
                // --- NOUVEAU : RECUPERATION DES STATISTIQUES ---
                request.setAttribute("stat_patients", service.getNombrePatientsTotal());
                request.setAttribute("stat_rdv_jour", service.getNombreRdvAujourdhui());
                request.setAttribute("stat_ca", service.getChiffreAffairesTotal());
                
                request.getRequestDispatcher("EspaceDentiste.jsp").forward(request, response);
            }
         // =========================================================
            //  TÉLÉCHARGER FACTURE PDF (iText 5)
            // =========================================================
            else if ("telechargerFacturePDF".equals(action)) {
                try {
                    int idRdv = Integer.parseInt(request.getParameter("idRdv"));
                    
                    // 1. Récupération des données
                    Rendezvous rdv = service.trouverRendezvous(idRdv);
                    List<ActeMedical> actes = service.listerActesParRendezvous(idRdv);
                    Patient pat = rdv.getPatient();
                    Dentiste dent = rdv.getDentiste();

                    // 2. Configuration de la réponse HTTP (Pour dire au navigateur : "C'est un PDF !")
                    response.setContentType("application/pdf");
                    response.setHeader("Content-Disposition", "attachment; filename=\"Facture_Smile_Everyday_" + idRdv + ".pdf\"");

                    // 3. Création du Document PDF
                    Document document = new Document();
                    PdfWriter.getInstance(document, response.getOutputStream());
                    document.open();

                    // --- DEBUT DU DESSIN DU PDF ---

                    // A. En-tête (Logo et Titre)
                    Font fontTitre = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, BaseColor.BLACK);
                    Paragraph titre = new Paragraph("FACTURE DE SOINS DENTAIRES", fontTitre);
                    titre.setAlignment(Element.ALIGN_CENTER);
                    document.add(titre);
                    document.add(new Paragraph(" ")); // Saut de ligne

                    // B. Infos Cabinet & Patient (Tableau invisible pour la mise en page)
                    PdfPTable headerTable = new PdfPTable(2);
                    headerTable.setWidthPercentage(100);
                    
                    // Colonne Gauche : Cabinet
                    PdfPCell cellG = new PdfPCell(new Phrase("Cabinet Smile Everyday\nDr. " + dent.getNomD() + "\nTunis, Tunisie"));
                    cellG.setBorder(Rectangle.NO_BORDER);
                    headerTable.addCell(cellG);

                    // Colonne Droite : Patient
                    PdfPCell cellD = new PdfPCell(new Phrase("Patient :\n" + pat.getNomP().toUpperCase() + " " + pat.getPrenomP() + "\nDate du soin : " + rdv.getDateRv()));
                    cellD.setBorder(Rectangle.NO_BORDER);
                    cellD.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    headerTable.addCell(cellD);

                    document.add(headerTable);
                    document.add(new Paragraph(" ")); // Saut de ligne
                    document.add(new Paragraph(" ")); 

                    // C. Tableau des Actes
                    PdfPTable table = new PdfPTable(3); // 3 colonnes
                    table.setWidthPercentage(100);
                    table.setWidths(new float[] { 4, 4, 2 }); // Largeurs relatives

                    // En-têtes du tableau
                    Font fontHeader = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, BaseColor.WHITE);
                    PdfPCell c1 = new PdfPCell(new Phrase("Acte / Soin", fontHeader));
                    c1.setBackgroundColor(BaseColor.DARK_GRAY);
                    c1.setPadding(8);
                    table.addCell(c1);

                    PdfPCell c2 = new PdfPCell(new Phrase("Détails", fontHeader));
                    c2.setBackgroundColor(BaseColor.DARK_GRAY);
                    c2.setPadding(8);
                    table.addCell(c2);

                    PdfPCell c3 = new PdfPCell(new Phrase("Prix (DT)", fontHeader));
                    c3.setBackgroundColor(BaseColor.DARK_GRAY);
                    c3.setPadding(8);
                    c3.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    table.addCell(c3);

                    // Remplissage des données
                    double total = 0.0;
                    for (ActeMedical a : actes) {
                        table.addCell(new Phrase(a.getServiceMedical().getNomService()));
                        table.addCell(new Phrase((a.getDescriptionAM() != null) ? a.getDescriptionAM() : "-"));
                        
                        double prix = (a.getTarifAM() != null) ? a.getTarifAM().doubleValue() : 0.0;
                        PdfPCell cellPrix = new PdfPCell(new Phrase(String.format("%.2f", prix)));
                        cellPrix.setHorizontalAlignment(Element.ALIGN_RIGHT);
                        table.addCell(cellPrix);
                        
                        total += prix;
                    }

                    document.add(table);

                    // D. Total
                    document.add(new Paragraph(" "));
                    Paragraph pTotal = new Paragraph("TOTAL À PAYER : " + String.format("%.2f", total) + " DT", fontTitre);
                    pTotal.setAlignment(Element.ALIGN_RIGHT);
                    document.add(pTotal);

                    // E. Pied de page
                    document.add(new Paragraph(" "));
                    document.add(new Paragraph(" "));
                    Font fontFooter = FontFactory.getFont(FontFactory.HELVETICA_OBLIQUE, 10, BaseColor.GRAY);
                    Paragraph footer = new Paragraph("Merci de votre confiance. Ce document est une preuve de paiement.", fontFooter);
                    footer.setAlignment(Element.ALIGN_CENTER);
                    document.add(footer);

                    document.close();

                } catch (Exception e) {
                    e.printStackTrace();
                }
                return; // Important : on arrête ici car la réponse est un fichier PDF
            }

            // -----------------------------------------------------------
            // CAS PAR DÉFAUT
            // -----------------------------------------------------------
            else { 
                response.sendRedirect("index.jsp"); 
            }

        } catch (Exception e) {
            e.printStackTrace();
            // En cas d'erreur globale, on renvoie vers l'accueil pour éviter la page blanche
            response.sendRedirect("index.jsp"); 
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
}