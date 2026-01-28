package tn.enit.entities;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

// IMPORTS OBLIGATOIRES : jakarta.* (pas javax.*)
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.persistence.Id;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Column;
import jakarta.persistence.OneToMany;

@Entity
@Table(name = "Dentiste")
public class Dentiste implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int idD;

    @Column(length = 100, nullable = false)
    private String nomD;

    @Column(length = 100, nullable = false)
    private String prenomD;

    @Column(length = 100, nullable = false, unique = true)
    private String emailD;

    @Column(length = 100, nullable = false)
    private String specialiteD;

    @Column(length = 10)
    private String mdpD;

    @Column(length = 100)
    private String photoD;

    @Column(length = 1)
    private String sexeD;

    @Column(length = 8)
    private int telD;

    // Initialisation de la liste pour éviter les erreurs null
    @OneToMany(mappedBy = "dentiste")
    private List<Rendezvous> listeRendezvous = new ArrayList<>();

    public Dentiste() {
        super();
    }

	public int getIdD() {
		return idD;
	}

	public void setIdD(int idD) {
		this.idD = idD;
	}

	public String getNomD() {
		return nomD;
	}

	public void setNomD(String nomD) {
		this.nomD = nomD;
	}

	public String getPrenomD() {
		return prenomD;
	}

	public void setPrenomD(String prenomD) {
		this.prenomD = prenomD;
	}

	public String getEmailD() {
		return emailD;
	}

	public void setEmailD(String emailD) {
		this.emailD = emailD;
	}

	public String getSpecialiteD() {
		return specialiteD;
	}

	public void setSpecialiteD(String specialiteD) {
		this.specialiteD = specialiteD;
	}

	public String getMdpD() {
		return mdpD;
	}

	public void setMdpD(String mdpD) {
		this.mdpD = mdpD;
	}

	public String getPhotoD() {
		return photoD;
	}

	public void setPhotoD(String photoD) {
		this.photoD = photoD;
	}

	public String getSexeD() {
		return sexeD;
	}

	public void setSexeD(String sexeD) {
		this.sexeD = sexeD;
	}

	public int getTelD() {
		return telD;
	}

	public void setTelD(int telD) {
		this.telD = telD;
	}

	public List<Rendezvous> getListeRendezvous() {
		return listeRendezvous;
	}

	public void setListeRendezvous(List<Rendezvous> listeRendezvous) {
		this.listeRendezvous = listeRendezvous;
	}

    

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
    
    
}
    