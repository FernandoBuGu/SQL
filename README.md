MySQL code example.

The example uses a dummy database that I created related to Breast Cancer Gene Expression (BCGE). 
A possible application is the study of results consensus across methods and researches.

	- Database description can be found below.
	- BCGE_ERDiagram.pdf: Database ER Diagram
	- BCGEtables.pdf: Database tables 
	- BCGEtables.sql:  Code to insert tables into SQL
	- BCGEqueries.sql: Queries examples
	- BCGEqueries.java: Queries examples using Java Database Connectivity (JDBC)
	- BCGEqueries_DAO.java: Queries examples using Data Access Object (DAO) and JDBC



BCGE database desription:

The "expression" table contains different results from differential expression analyses for 
the main Breast Cancer Genes. Each result contains a number from 1 to 9 
(diffExpResult: key variable).
For each entry, one or null diffExpResult is set as the most correlated entry
and a diffExpResult can be the most correlated one with multiple entries.

Each expression entry uses one "method" and a method can be used in more than one expression 
entry. Each method has a diffExpResult that is the most striking result, and each diffExpResult
can only be the most striking result for one method.

Each method was used in a number of "publications" and each publication uses one method.

A diffExpResult may have been reported previously. For instance, results for a gene with a 
specific method may have been reported in multiple publications. Each "previous_findings" 
entry relates diffExpResult with a previous publication and the most extreme log fold change 
reported in this. A publication may contain findings for more than one diffExpResult.

Data used for each method may come from multiple "PCR_laboratories" and data provided by one
lab may be used for more then one method. 

 

