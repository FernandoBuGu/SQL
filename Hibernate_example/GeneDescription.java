package feBueno.HibernateExample;

import javax.persistence.Embeddable;

@Embeddable
public class GeneDescription {
	String protein_family;
	String UniProtKB;
	String interaction;
	public String getProtein_family() {
		return protein_family;
	}
	public void setProtein_family(String protein_family) {
		this.protein_family = protein_family;
	}
	public String getUniProtKB() {
		return UniProtKB;
	}
	public void setUniProtKB(String uniProtKB) {
		UniProtKB = uniProtKB;
	}
	public String getInteraction() {
		return interaction;
	}
	public void setInteraction(String interaction) {
		this.interaction = interaction;
	}
	@Override
	public String toString() {
		return "GeneDescription [protein_family=" + protein_family + ", UniProtKB=" + UniProtKB + ", interaction="
				+ interaction + "]";
	}
	
	
}
