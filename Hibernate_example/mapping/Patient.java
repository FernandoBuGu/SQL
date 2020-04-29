package feBueno.HibernateExample;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.OneToOne;
import javax.persistence.OneToMany;
import javax.persistence.ManyToMany;


import java.util.*;


@Entity
public class Patient {

	@Id
	public int CaseId;
	public String SampleName;
	public int ExpectedSurvival;
	@ManyToMany(mappedBy="patient")
	public List<Mutation> mutation = new ArrayList<Mutation>();
	
	public int getCase() {
		return CaseId;
	}
	public void setCase(int case1) {
		CaseId = case1;
	}
	public String getSampleName() {
		return SampleName;
	}
	public void setSampleName(String sampleName) {
		SampleName = sampleName;
	}
	public int getExpectedSurvival() {
		return ExpectedSurvival;
	}
	public void setExpectedSurvival(int expectedSurvival) {
		ExpectedSurvival = expectedSurvival;
	}
	
	
	public List<Mutation> getMutation() {
		return mutation;
	}
	public void setMutation(List<Mutation> mutation) {
		this.mutation = mutation;
	}
	@Override
	public String toString() {
		return "Patient [Case=" + CaseId + ", SampleName=" + SampleName + ", ExpectedSurvival=" + ExpectedSurvival + "]";
	}
	
}
