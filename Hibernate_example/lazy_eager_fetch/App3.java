
package feBueno.HibernateExample;

/**
 * Hibernate lazy/eager fetch
 * 
 * @author feBueno - April 2020
 * 
 * REQUIRED:
 * BreastCancerGeneExpression was previously created in localhost with mysql
 * in MySQL: CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'password';
 * GRANT ALL PRIVILEGES ON BreastCancerGeneExpression.* TO 'newuser'@'localhost';
 * 
 * From Maven repo add dependencies in pom.xml: 
 * - Core Hibernate OR/M functionality
 * - MySQL connector
 * 
 * eclipse marketplace, JBoss tools, install hibernate plug-in
 * project, new, others, hibernate -> create hibernate.cfg.xml with connection parameters as in BCGEqueries.java
 * in hibernate.cfg.xml add a property to create or update tables in database
 */

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;
import org.hibernate.service.ServiceRegistry;
import org.hibernate.service.ServiceRegistryBuilder;
import static net.mindview.util.Print.print;
import java.util.*;


public class App3 
{
    public static void main( String[] args )
    {
     
        DEgene m1 = new DEgene();
        DEgene m2 = new DEgene();
        DEgene m3 = new DEgene();
        DEgene m4 = new DEgene();

        Sample p1 = new Sample();
        Sample p2 = new Sample();
        Sample p3 = new Sample();


        m1.geneId=101;
        m1.geneName="BRCA1";
        m1.sample=p1;
        m2.geneId=102;
        m2.geneName="BRCA2";
        m2.sample=p1;
        m3.geneId=103;
        m3.geneName="TP53";
        m3.sample=p1;
        m4.geneId=104;
        m4.geneName="AUC";
        m4.sample=p2;
        
        p1.CaseId=1;
        p1.SampleName="CR2-HGF12-8918";
        p1.ExpectedSurvival=26;
        //p1.getmDEgenes().add(m1);
        //p1.getmDEgenes().add(m2);

        
        p2.CaseId=2;
        p2.SampleName="CR2-HGF12-4426";
        p2.ExpectedSurvival=32;
        //p2.getmDEgenes().add(m1);
        
        p3.CaseId=3;
        p3.SampleName="CR2-HGF12-5899";
        p3.ExpectedSurvival=12;
        p3.getmDEgenes().add(m1);
        p3.getmDEgenes().add(m2);
        p3.getmDEgenes().add(m3);
        p3.getmDEgenes().add(m4);
    	

    	
        Configuration con = new Configuration().configure().addAnnotatedClass(DEgene.class).addAnnotatedClass(Sample.class);
        ServiceRegistry reg = new ServiceRegistryBuilder().applySettings(con.getProperties()).buildServiceRegistry();       
        SessionFactory sf=con.buildSessionFactory(reg);
        Session session = sf.openSession();
        
        session.beginTransaction();
        

        
        session.save(m1);
        session.save(m2);
        session.save(m3);
        session.save(m4);
        session.save(p1);
        session.save(p2);
        session.save(p3);

        //fetch
        Sample s1 = (Sample)session.get(Sample.class,1);
        print("s1: "+s1);
        
        //To print DEgenes with lazy fetch
        /*print(s3.getSampleName());
        Collection<DEgene> C_DG = s3.getmDEgenes();

        for(DEgene d:C_DG) {
        	print(d);
        }*/
        
        session.getTransaction().commit();
    }
}
