package tn.enit.entities;

import java.io.Serializable;
import java.util.Date;

// IMPORTS JAKARTA
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.persistence.Id;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Column;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.persistence.Lob;

@Entity
@Table(name = "Rendezvous")
public class Rendezvous implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int idRv;

    // Relation avec Patient (OBLIGATOIRE : Un RDV a toujours un patient)
    @ManyToOne
    @JoinColumn(name = "idP", nullable = false)
    private Patient patient;

    // Relation avec Dentiste (OPTIONNELLE : On peut créer un RDV sans savoir quel dentiste)
    @ManyToOne
    @JoinColumn(name = "idD", nullable = true) // <--- CORRECTION IMPORTANTE ICI (true)
    private Dentiste dentiste;

    @Temporal(TemporalType.DATE)
    @Column(nullable = false)
    private Date dateRv;

    @Temporal(TemporalType.TIME)
    @Column(nullable = false)
    private Date heureRv;

    @Column(length = 100, nullable = false)
    private String statutRv;

    @Lob 
    private String detailsRv; 

    public Rendezvous() {
        super();
    }

    // --- GETTERS ET SETTERS ---

    public int getIdRv() { return idRv; }
    public void setIdRv(int idRv) { this.idRv = idRv; }

    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }

    public Dentiste getDentiste() { return dentiste; }
    public void setDentiste(Dentiste dentiste) { this.dentiste = dentiste; }

    public Date getDateRv() { return dateRv; }
    public void setDateRv(Date dateRv) { this.dateRv = dateRv; }

    public Date getHeureRv() { return heureRv; }
    public void setHeureRv(Date heureRv) { this.heureRv = heureRv; }

    public String getStatutRv() { return statutRv; }
    public void setStatutRv(String statutRv) { this.statutRv = statutRv; }

    public String getDetailsRv() { return detailsRv; }
    public void setDetailsRv(String detailsRv) { this.detailsRv = detailsRv; }
}