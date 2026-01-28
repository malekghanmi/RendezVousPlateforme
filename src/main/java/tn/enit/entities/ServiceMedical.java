package tn.enit.entities;

import java.io.Serializable;

import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.persistence.Id;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Column;
import jakarta.persistence.Lob;

@Entity
@Table(name = "ServiceMedical")
public class ServiceMedical implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int idService; 

    @Column(length = 100, nullable = false)
    private String nomService;

    @Column(length = 100, nullable = false)
    private String typeService;

    @Lob 
    private String descriptionService;

    // --- CORRECTION ICI ---
    // On retire (precision = 10, scale = 2) car c'est interdit pour un "double"
    @Column(nullable = false) 
    private double tarifService;

    private int nbSeances;

    // --- CONSTRUCTEUR ---
    public ServiceMedical() {
        super();
    }

    // --- GETTERS ET SETTERS ---

    public int getIdService() {
        return idService;
    }

    public void setIdService(int idService) {
        this.idService = idService;
    }

    public String getNomService() {
        return nomService;
    }

    public void setNomService(String nomService) {
        this.nomService = nomService;
    }

    public String getTypeService() {
        return typeService;
    }

    public void setTypeService(String typeService) {
        this.typeService = typeService;
    }

    public String getDescriptionService() {
        return descriptionService;
    }

    public void setDescriptionService(String descriptionService) {
        this.descriptionService = descriptionService;
    }

    public double getTarifService() {
        return tarifService;
    }

    public void setTarifService(double tarifService) {
        this.tarifService = tarifService;
    }

    public int getNbSeances() {
        return nbSeances;
    }

    public void setNbSeances(int nbSeances) {
        this.nbSeances = nbSeances;
    }
}