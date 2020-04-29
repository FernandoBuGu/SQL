package feBueno.HibernateExample;

/**
 * Hibernate mapping relationship example
 * Two tables, Mutation and Patient are added to the BreastCancerGeneExpression database and there is 
 * a ManytoMany mapping relationship between the two: Each mutation can occur in more than one patient and 
 * each patient can have more than one mutation.
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


public class App2 
{
    public static void main( String[] args )
    {
        Mutation m1 = new Mutation();
        Patient p1 = new Patient();

        m1.mutId=101;
        m1.geneName="BRCA1";
        m1.getPatient().add(p1);
        
        p1.CaseId=1;
        p1.SampleName="CR2-HGF12-8918";
        p1.ExpectedSurvival=26;
        p1.getMutation().add(m1);

           
        Configuration con = new Configuration().configure().addAnnotatedClass(Mutation.class).addAnnotatedClass(Patient.class);
        ServiceRegistry reg = new ServiceRegistryBuilder().applySettings(con.getProperties()).buildServiceRegistry();       
        SessionFactory sf=con.buildSessionFactory(reg);
        Session session = sf.openSession();
        
        session.beginTransaction();
                
        session.save(m1);
        session.save(p1);
        print(p1);
        print(m1);
                
        session.getTransaction().commit();
    }
}
