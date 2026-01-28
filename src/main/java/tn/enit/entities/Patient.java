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
public class Patient implements Serializable {
    
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int idP;

    private String nomP;
    private String prenomP;
    
    // --- NOUVEAUX CHAMPS AJOUTÉS ---
    private String adresseP;
    private String telP;
    private String emailP;
    private String mdpP;
    private String sexeP;
    private String groupeSanguinP;
    private String recouvrementP;
    
// ... autres attributs existants ...
    
    private String photo; // Nouveau champ

    // ... autres getters/setters ...

    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }
    @Temporal(TemporalType.DATE)
    private Date dateNP;

    public Patient() {
        super();
    }

    // --- GETTERS ET SETTERS (C'est ce qui manquait) ---

    public int getIdP() { return idP; }
    public void setIdP(int idP) { this.idP = idP; }

    public String getNomP() { return nomP; }
    public void setNomP(String nomP) { this.nomP = nomP; }

    public String getPrenomP() { return prenomP; }
    public void setPrenomP(String prenomP) { this.prenomP = prenomP; }

    public String getAdresseP() { return adresseP; }
    public void setAdresseP(String adresseP) { this.adresseP = adresseP; }

    public String getTelP() { return telP; }
    public void setTelP(String telP) { this.telP = telP; }

    public String getEmailP() { return emailP; }
    public void setEmailP(String emailP) { this.emailP = emailP; }

    public String getMdpP() { return mdpP; }
    public void setMdpP(String mdpP) { this.mdpP = mdpP; }

    public String getSexeP() { return sexeP; }
    public void setSexeP(String sexeP) { this.sexeP = sexeP; }

    public String getGroupeSanguinP() { return groupeSanguinP; }
    public void setGroupeSanguinP(String groupeSanguinP) { this.groupeSanguinP = groupeSanguinP; }

    public String getRecouvrementP() { return recouvrementP; }
    public void setRecouvrementP(String recouvrementP) { this.recouvrementP = recouvrementP; }

    

    public Date getDateNP() { return dateNP; }
    public void setDateNP(Date dateNP) { this.dateNP = dateNP; }
}