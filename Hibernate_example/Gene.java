package feBueno.HibernateExamaple;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;



@Entity
@Table(name="gene_properties")

public class Gene {
	
	@Id 
	private int aid;// Id for primary key
	//@Column(name="mgeneName") //to rename column
	private GeneDescription aname;
	//@Transient //to not create ensemlb column
	private String ensembl;
	public int getAid() {
		return aid;
	}
	public void setAid(int aid) {
		this.aid = aid;
	}
	public GeneDescription getAname() {
		return aname;
	}
	public void setAname(GeneDescription aname) {
		this.aname = aname;
	}
	public String getEnsembl() {
		return ensembl;
	}
	public void setEnsembl(String ensembl) {
		this.ensembl = ensembl;
	}
	@Override
	public String toString() {
		return "Gene [aid=" + aid + ", aname=" + aname + ", ensembl=" + ensembl + "]";
	}
	
}
