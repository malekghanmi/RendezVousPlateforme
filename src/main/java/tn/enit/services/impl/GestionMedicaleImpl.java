package tn.enit.services.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;

import tn.enit.entities.*;
import tn.enit.services.interfaces.GestionMedicaleLocal;

@Stateless
public class GestionMedicaleImpl implements GestionMedicaleLocal {

    @PersistenceContext(unitName = "SmileEverydayPU")
    private EntityManager em;

    // --- PATIENTS ---
    @Override
    public void ajouterPatient(Patient p) {
        try {
            System.out.println(">>> [DEBUG] Ajout Patient : " + p.getNomP());
            em.persist(p);
        } catch (Exception e) {
            System.err.println(">>> [ERREUR] Ajout Patient : " + e.getMessage());
            throw e;
        }
    }

    @Override
    public Patient verifierConnexionPatient(String email, String mdp) {
        try {
            TypedQuery<Patient> query = em.createQuery(
                "SELECT p FROM Patient p WHERE p.emailP = :email AND p.mdpP = :mdp", Patient.class);
            query.setParameter("email", email);
            query.setParameter("mdp", mdp);
            return query.getSingleResult();
        } catch (Exception e) {
            System.out.println(">>> [INFO] Connexion échouée pour : " + email);
            return null;
        }
    }

    // --- DENTISTES ---
    @Override
    public void ajouterDentiste(Dentiste d) {
        em.persist(d);
    }
    
    @Override
    public List<Dentiste> listerDentistes() {
        return em.createQuery("SELECT d FROM Dentiste d", Dentiste.class).getResultList();
    }

    @Override
    public Dentiste trouverDentiste(int idD) {
        return em.find(Dentiste.class, idD);
    }
    
    @Override
    public Dentiste verifierConnexionDentiste(String email, String mdp) {
        try {
            System.out.println(">>> Tentative connexion Dentiste : " + email + " avec mdp : " + mdp);
            
            // On vérifie email et mdpD
            TypedQuery<Dentiste> query = em.createQuery(
                "SELECT d FROM Dentiste d WHERE d.emailD = :email AND d.mdpD = :mdp", Dentiste.class);
            
            query.setParameter("email", email);
            query.setParameter("mdp", mdp);
            
            Dentiste d = query.getSingleResult();
            System.out.println(">>> Connexion Dentiste RÉUSSIE pour : " + d.getNomD());
            return d;
            
        } catch (Exception e) {
            System.out.println(">>> Connexion Dentiste ÉCHOUÉE (Mauvais email ou mot de passe)");
            return null;
        }
    }

    // --- SERVICES ---
    @Override
    public void ajouterService(ServiceMedical sm) {
        em.persist(sm);
    }

    @Override
    public List<ServiceMedical> listerServices() {
        return em.createQuery("SELECT s FROM ServiceMedical s", ServiceMedical.class).getResultList();
    }

    // --- RENDEZ-VOUS ---
    @Override
    public void prendreRendezvous(Rendezvous rv) {
        try {
            System.out.println(">>> [DEBUG] Prise de RDV pour patient ID: " + 
                (rv.getPatient() != null ? rv.getPatient().getIdP() : "NULL"));
            em.persist(rv);
        } catch (Exception e) {
            System.err.println(">>> [ERREUR] Prise RDV : " + e.getMessage());
            throw e;
        }
    }

    @Override
    public List<Rendezvous> listerRendezvousParPatient(int idP) {
        try {
            TypedQuery<Rendezvous> q = em.createQuery(
                "SELECT r FROM Rendezvous r WHERE r.patient.idP = :id ORDER BY r.dateRv DESC", 
                Rendezvous.class);
            q.setParameter("id", idP);
            return q.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>(); 
        }
    }

    @Override
    public List<Rendezvous> listerRendezvousEnAttente() {
        return em.createQuery("SELECT r FROM Rendezvous r WHERE r.statutRv = 'En attente'", Rendezvous.class).getResultList();
    }

    @Override
    public void validerRendezvous(int idRdv, int idDentiste) {
        Rendezvous r = em.find(Rendezvous.class, idRdv);
        Dentiste d = em.find(Dentiste.class, idDentiste);
        
        if (r != null && d != null) {
            r.setStatutRv("Validé"); // Change le statut
            r.setDentiste(d);        // Assigne le médecin
            em.merge(r);             // Sauvegarde
            System.out.println(">>> RDV " + idRdv + " validé par Dr. " + d.getNomD());
        }
    }

    @Override
    public void refuserRendezvous(int idRdv, int idDentiste) {
        Rendezvous r = em.find(Rendezvous.class, idRdv);
        Dentiste d = em.find(Dentiste.class, idDentiste);
        
        if (r != null && d != null) {
            r.setStatutRv("Refusé"); // Statut Refusé
            r.setDentiste(d);        // On note quel médecin a refusé
            em.merge(r);
            System.out.println(">>> RDV " + idRdv + " REFUSÉ par Dr. " + d.getNomD());
        }
    }

    // --- AIDE SOIGNANT ---
    @Override
    public void ajouterAideSoignant(AideSoignant as) {
        try {
            System.out.println(">>> [DEBUG] Ajout AideSoignant : " + as.getNomAS());
            em.persist(as);
        } catch (Exception e) {
            System.err.println(">>> [ERREUR] Ajout AideSoignant : " + e.getMessage());
            e.printStackTrace();
            throw e; 
        }
    }

    @Override
    public List<AideSoignant> listerAideSoignants() {
        try {
            return em.createQuery("SELECT a FROM AideSoignant a ORDER BY a.idAS DESC", AideSoignant.class).getResultList();
        } catch (Exception e) {
            return Collections.emptyList();
        }
    }

    @Override
    public void validerAideSoignant(int idAS) {
        try {
            AideSoignant as = em.find(AideSoignant.class, idAS);
            if (as != null) {
                as.setStatut("Validé");
                em.merge(as); 
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // --- PUBLICATION ---
 // --- PUBLICATION ---
    @Override
    public void ajouterPublication(Publication pub) {
        em.persist(pub);
    }

    // --- AJOUTEZ CE BLOC ICI ---
    @Override
    public List<Publication> listerPublications() {
        // On récupère toutes les pubs, triées par date (la plus récente en haut)
        try {
            return em.createQuery("SELECT p FROM Publication p ORDER BY p.datePub DESC", Publication.class).getResultList();
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }

    @Override
    public void supprimerPublication(int id) {
        Publication p = em.find(Publication.class, id);
        if (p != null) {
            em.remove(p);
        }
    }
    // ---------------------------
    @Override
    public List<AideSoignant> listerAideSoignantsValides() {
        return em.createQuery("SELECT a FROM AideSoignant a WHERE a.statut = 'Validé'", AideSoignant.class).getResultList();
    }

    @Override
    public List<Rendezvous> listerRendezvousValides() {
        return em.createQuery("SELECT r FROM Rendezvous r WHERE r.statutRv = 'Validé' ORDER BY r.dateRv DESC", Rendezvous.class).getResultList();
    }
    @Override
    public void supprimerAideSoignant(int id) {
        AideSoignant as = em.find(AideSoignant.class, id);
        if (as != null) {
            em.remove(as);
            System.out.println(">>> AideSoignant supprimé : ID " + id);
        }
    }

    @Override
    public void supprimerRendezvous(int id) {
        Rendezvous r = em.find(Rendezvous.class, id);
        if (r != null) {
            em.remove(r);
            System.out.println(">>> Rendez-vous supprimé : ID " + id);
        }
    }
 // ... dans GestionMedicaleImpl.java ...

    // --- ACTES MEDICAUX ---
    @Override
    public void ajouterActe(ActeMedical acte) {
        // On enregistre l'acte dans la base
        em.persist(acte);
    }

    @Override
    public List<ActeMedical> listerActesParRendezvous(int idRdv) {
        // On récupère la liste des actes pour UN rendez-vous précis
        try {
            return em.createQuery("SELECT a FROM ActeMedical a WHERE a.rendezvous.idRv = :id", ActeMedical.class)
                     .setParameter("id", idRdv)
                     .getResultList();
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }

    @Override
    public void supprimerActe(int idActe) {
        ActeMedical a = em.find(ActeMedical.class, idActe);
        if (a != null) {
            em.remove(a);
        }
    }
    @Override
    public Rendezvous trouverRendezvous(int idRdv) {
        return em.find(Rendezvous.class, idRdv);
    }
    @Override
    public Patient trouverPatient(int idPatient) {
        return em.find(Patient.class, idPatient);
    }
 // ... fin du fichier ...

    // --- STATISTIQUES ---
     // ... Dans GestionMedicaleImpl.java ...

    // --- STATISTIQUES CORRIGÉES ---
    
    @Override
    public long getNombrePatientsTotal() {
        try {
            // Compte les patients
            Long count = em.createQuery("SELECT COUNT(p) FROM Patient p", Long.class).getSingleResult();
            System.out.println(">>> DEBUG: Nombre Patients = " + count);
            return (count != null) ? count : 0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public long getNombreRdvAujourdhui() {
        try {
            // Compte les RDV du jour
            Long count = em.createQuery("SELECT COUNT(r) FROM Rendezvous r WHERE r.dateRv = CURRENT_DATE", Long.class).getSingleResult();
            System.out.println(">>> DEBUG: RDV Aujourd'hui = " + count);
            return (count != null) ? count : 0;
        } catch (Exception e) {
            return 0;
        }
    }

    @Override
    public double getChiffreAffairesTotal() {
        try {
            // Somme des tarifs (coalesce transforme NULL en 0)
            Double total = em.createQuery("SELECT SUM(a.tarifAM) FROM ActeMedical a", Double.class).getSingleResult();
            
            // Sécurité : Si total est null, on renvoie 0.0
            if (total == null) total = 0.0;
            
            System.out.println(">>> DEBUG: Chiffre d'Affaires = " + total);
            return total;
        } catch (Exception e) {
            e.printStackTrace();
            return 0.0;
        }
    }
 // --- RECHERCHE AVANCÉE ---
    @Override
    public List<Rendezvous> rechercherRendezvous(String motCle, java.util.Date dateFiltre) {
        try {
            // On commence la requête de base (RDV Validés uniquement)
            String sql = "SELECT r FROM Rendezvous r WHERE r.statutRv = 'Validé'";

            // Si on a un mot clé (Nom ou Prénom)
            if (motCle != null && !motCle.isEmpty()) {
                sql += " AND (LOWER(r.patient.nomP) LIKE :mc OR LOWER(r.patient.prenomP) LIKE :mc)";
            }
            
            // Si on a une date
            if (dateFiltre != null) {
                sql += " AND r.dateRv = :dt";
            }
            
            // On ordonne par heure
            sql += " ORDER BY r.dateRv DESC, r.heureRv ASC";

            // Création de la requête
            TypedQuery<Rendezvous> query = em.createQuery(sql, Rendezvous.class);

            // Remplissage des paramètres
            if (motCle != null && !motCle.isEmpty()) {
                query.setParameter("mc", "%" + motCle.toLowerCase() + "%"); // Le % permet de chercher "partout"
            }
            if (dateFiltre != null) {
                query.setParameter("dt", dateFiltre);
            }

            return query.getResultList();

        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    @Override
    public void modifierPatient(Patient p) {
        em.merge(p); // 'merge' sert à mettre à jour une entité existante
    }

    @Override
    public void supprimerService(int id) {
        ServiceMedical sm = em.find(ServiceMedical.class, id);
        if (sm != null) {
            // 1. On nettoie d'abord les rendez-vous qui utilisent ce service
            em.createQuery("DELETE FROM Rendezvous r WHERE r.serviceMedical.idService = :id")
              .setParameter("id", id)
              .executeUpdate();
              
            // 2. Maintenant on peut supprimer le service sans erreur
            em.remove(sm);
            em.flush(); // Indispensable pour valider dans MySQL
        }
   
    }
    @Override
    public List<ServiceMedical> listerTousLesServices() {
        // Utilisation d'une requête JPQL pour tout récupérer
        return em.createQuery("SELECT sm FROM ServiceMedical sm", ServiceMedical.class).getResultList();
    }
}