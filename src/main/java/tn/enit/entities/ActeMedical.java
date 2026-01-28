package tn.enit.entities;

import java.io.Serializable;
import java.math.BigDecimal;

// ATTENTION : Vérifiez bien ces imports !
import jakarta.persistence.Entity; // Indispensable
import jakarta.persistence.Table;
import jakarta.persistence.Id;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Column;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.Lob;

@Entity // <--- C'est cette ligne qui manque ou qui bug !
@Table(name = "ActeMedical")
public class ActeMedical implements Serializable {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int idAM;

    @ManyToOne
    @JoinColumn(name = "idRv", nullable = false)
    private Rendezvous rendezvous;

    @ManyToOne
    @JoinColumn(name = "numSM", nullable = false)
    private ServiceMedical serviceMedical;

    @Lob
    private String descriptionAM;

    @Column(precision = 6, scale = 2)
    private BigDecimal tarifAM;

    public ActeMedical() {}

	public int getIdAM() {
		return idAM;
	}

	public void setIdAM(int idAM) {
		this.idAM = idAM;
	}

	public Rendezvous getRendezvous() {
		return rendezvous;
	}

	public void setRendezvous(Rendezvous rendezvous) {
		this.rendezvous = rendezvous;
	}

	public ServiceMedical getServiceMedical() {
		return serviceMedical;
	}

	public void setServiceMedical(ServiceMedical serviceMedical) {
		this.serviceMedical = serviceMedical;
	}

	public String getDescriptionAM() {
		return descriptionAM;
	}

	public void setDescriptionAM(String descriptionAM) {
		this.descriptionAM = descriptionAM;
	}

	public BigDecimal getTarifAM() {
		return tarifAM;
	}

	public void setTarifAM(BigDecimal tarifAM) {
		this.tarifAM = tarifAM;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

    
}