package tn.enit.services.interfaces;

import java.util.List;
import jakarta.ejb.Local;
import tn.enit.entities.*; 

@Local
public interface GestionMedicaleLocal {
    
    // --- PATIENT ---
    void ajouterPatient(Patient p);
    Patient verifierConnexionPatient(String email, String mdp);
    
    // --- DENTISTE ---
    void ajouterDentiste(Dentiste d);
    List<Dentiste> listerDentistes();
    Dentiste trouverDentiste(int idD);
    Dentiste verifierConnexionDentiste(String email, String mdp);
    
    // --- SERVICE ---
    void ajouterService(ServiceMedical sm);
    List<ServiceMedical> listerServices();
    
    // --- RENDEZ-VOUS ---
    void prendreRendezvous(Rendezvous rv);
    List<Rendezvous> listerRendezvousParPatient(int idP);
    List<Rendezvous> listerRendezvousEnAttente();
    
    // Actions du Dentiste sur les RDV
    void validerRendezvous(int idRdv, int idDentiste);
    void refuserRendezvous(int idRdv, int idDentiste); 

    // --- AIDE SOIGNANT ---
    void ajouterAideSoignant(AideSoignant as);
    List<AideSoignant> listerAideSoignants();
    void validerAideSoignant(int idAS);

 // --- PUBLICATION (MODIFIÉ ICI) ---
 // Gestion des Publications
    void ajouterPublication(Publication pub);
    List<Publication> listerPublications();     // <--- C'est cette ligne qui manque !
    void supprimerPublication(int id);
    
    
 // ... dans GestionMedicaleLocal.java ...

    // --- GESTION DES ACTES MEDICAUX ---
    List<Rendezvous> rechercherRendezvous(String motCle, java.util.Date dateFiltre);
    void modifierPatient(Patient p);
    void ajouterActe(ActeMedical acte);
    List<ActeMedical> listerActesParRendezvous(int idRdv);
    void supprimerActe(int idActe);
 // Dans l'interface
    Rendezvous trouverRendezvous(int idRdv);
    List<AideSoignant> listerAideSoignantsValides();
    List<Rendezvous> listerRendezvousValides();
 // --- SUPPRESSIONS ---
    void supprimerAideSoignant(int id);
    void supprimerRendezvous(int id);
    Patient trouverPatient(int idPatient);
 // ... dans GestionMedicaleLocal.java ...

    // --- STATISTIQUES DASHBOARD ---
    long getNombrePatientsTotal();
    long getNombreRdvAujourdhui();
    double getChiffreAffairesTotal();
    public void supprimerService(int idService);
    public List<ServiceMedical> listerTousLesServices();
}