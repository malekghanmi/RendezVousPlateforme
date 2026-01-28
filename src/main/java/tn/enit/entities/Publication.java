package tn.enit.entities;

import java.io.Serializable;
import java.util.Date;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Lob;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;

@Entity
public class Publication implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int idPub;

    private String titre;
    
    @Lob // Permet de stocker de longs textes
    private String contenu;
    
    private String image;

    @Temporal(TemporalType.DATE)
    private Date datePub;

    // --- CONSTRUCTEURS ---

    public Publication() {
        super();
    }

    public Publication(String titre, String contenu, String image, Date datePub) {
        this.titre = titre;
        this.contenu = contenu;
        this.image = image;
        this.datePub = datePub;
    }

    // --- GETTERS ET SETTERS (Standardisés pour le JSP) ---

    public int getIdPub() {
        return idPub;
    }

    public void setIdPub(int idPub) {
        this.idPub = idPub;
    }

    public String getTitre() {
        return titre;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    public String getContenu() {
        return contenu;
    }

    public void setContenu(String contenu) {
        this.contenu = contenu;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public Date getDatePub() {
        return datePub;
    }

    public void setDatePub(Date datePub) {
        this.datePub = datePub;
    }
}