package feBueno.HibernateExample;



import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.OneToOne;
import javax.persistence.OneToMany;
import javax.persistence.ManyToMany;


import java.util.*;


@Entity
public class Sample {

	@Id
	public int CaseId;
	public String SampleName;
	public int ExpectedSurvival;
	@OneToMany(mappedBy="sample",fetch=FetchType.EAGER)//left outer join
	public Collection<DEgene> mDEgenes = new ArrayList<DEgene>();
	
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
	
	
	public Collection<DEgene> getmDEgenes() {
		return mDEgenes;
	}
	public void setmDEgenes(Collection<DEgene> DEgene) {
		this.mDEgenes = DEgene;
	}
	@Override
	public String toString() {
		return "Sample [Case=" + CaseId + ", SampleName=" + SampleName + ", ExpectedSurvival=" + ExpectedSurvival + "]";
	}
	
}
