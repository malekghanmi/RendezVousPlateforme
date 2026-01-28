package tn.enit.entities;

import java.io.Serializable;
import java.util.Date;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;

@Entity
public class AideSoignant implements Serializable {
    
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int idAS;

    private String nomAS;
    private String prenomAS;
    
    // --- C'EST CE CHAMP QUI MANQUAIT ! ---
    private String adresseAS; 
    // -------------------------------------
    
    private String emailAS;
    private String mdpAS;
    private String telAS;
    private String diplomeAS;
    private String sexeAS;

    @Temporal(TemporalType.DATE)
    private Date dateNAS;

    public AideSoignant() {
        super();
    }
 // ... vos autres champs (nom, prenom, adresse...) ...

    // --- NOUVEAU CHAMP ---
    private String statut; // Sera "En attente" ou "Validé"

    // --- GETTER ET SETTER ---
    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    // --- GETTERS ET SETTERS ---
    public int getIdAS() { return idAS; }
    public void setIdAS(int idAS) { this.idAS = idAS; }

    public String getNomAS() { return nomAS; }
    public void setNomAS(String nomAS) { this.nomAS = nomAS; }

    public String getPrenomAS() { return prenomAS; }
    public void setPrenomAS(String prenomAS) { this.prenomAS = prenomAS; }

    // --- GETTER/SETTER AJOUTÉS POUR ADRESSE ---
    public String getAdresseAS() { return adresseAS; }
    public void setAdresseAS(String adresseAS) { this.adresseAS = adresseAS; }
    // ------------------------------------------

    public String getEmailAS() { return emailAS; }
    public void setEmailAS(String emailAS) { this.emailAS = emailAS; }

    public String getMdpAS() { return mdpAS; }
    public void setMdpAS(String mdpAS) { this.mdpAS = mdpAS; }

    public String getTelAS() { return telAS; }
    public void setTelAS(String telAS) { this.telAS = telAS; }

    public String getDiplomeAS() { return diplomeAS; }
    public void setDiplomeAS(String diplomeAS) { this.diplomeAS = diplomeAS; }

    public String getSexeAS() { return sexeAS; }
    public void setSexeAS(String sexeAS) { this.sexeAS = sexeAS; }

    public Date getDateNAS() { return dateNAS; }
    public void setDateNAS(Date dateNAS) { this.dateNAS = dateNAS; }
 // --- AJOUTER CES CHAMPS ---
    private String photo;
    private String cv;

    // --- AJOUTER LES GETTERS ET SETTERS ---
    public String getPhoto() { return photo; }
    public void setPhoto(String photo) { this.photo = photo; }

    public String getCv() { return cv; }
    public void setCv(String cv) { this.cv = cv; }
}