package feBueno.HibernateExample;

/**
 * Hibernate example
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


public class App 
{
    public static void main( String[] args )
    {
    	//insert new entry in database
        Gene gene1 = new Gene();
        gene1.setAid(24);
        gene1.setEnsembl("ENSG00000136492");
        GeneDescription gd = new GeneDescription();
        gd.setInteraction("Protein C-Terminal Helicase 1");
        gd.setProtein_family("Fanconi Anemia Group J Protein");
        gd.setUniProtKB("Q9BX63");
        gene1.setAname(gd);

        
        Configuration con = new Configuration().configure().addAnnotatedClass(Gene.class);//configure: hibernate.cfg.xml by default
        
        ServiceRegistry reg = new ServiceRegistryBuilder().applySettings(con.getProperties()).buildServiceRegistry();
        
        SessionFactory sf=con.buildSessionFactory(reg);
        
        Session session = sf.openSession();
        
        Transaction tx = session.beginTransaction();
                
        session.save(gene1);
        print(gene1);
        
        //fetch from database
        Gene gene2 = null;
        gene2 = (Gene)session.get(Gene.class,24);
        print("gene2");
        print(gene2);
        
        tx.commit();
    }
}
