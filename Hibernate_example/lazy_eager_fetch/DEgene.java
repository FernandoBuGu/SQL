
package feBueno.HibernateExample;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.ManyToOne;
import javax.persistence.ManyToMany;

import java.util.*;

@Entity
public class DEgene {

	@Id
	public int geneId;
	public String geneName;
	@ManyToOne
	public Sample sample;

	
	public int getgeneId() {
		return geneId;
	}
	public void setgeneId(int geneId) {
		this.geneId = geneId;
	}
	public String getGeneName() {
		return geneName;
	}
	public void setGeneName(String geneName) {
		this.geneName = geneName;
	}
	public Sample getSample() {
		return sample;
	}
	public void setSample(Sample sample) {
		this.sample = sample;
	}
	
}

