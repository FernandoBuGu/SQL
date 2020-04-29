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
public class Mutation {

	@Id
	public int mutId;
	public String geneName;
	@ManyToMany
	public List<Patient> patient = new ArrayList<Patient>();

	
	public int getMutId() {
		return mutId;
	}
	public void setMutId(int mutId) {
		this.mutId = mutId;
	}
	public String getGeneName() {
		return geneName;
	}
	public void setGeneName(String geneName) {
		this.geneName = geneName;
	}
	public List<Patient> getPatient() {
		return patient;
	}
	public void setPatient(List<Patient> patient) {
		this.patient = patient;
	}
	
}
