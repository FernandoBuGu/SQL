-- Get diffExpResult and geneName sorted by geneName if logFoldChange > 0.5
SELECT diffExpResult, geneName FROM expression
WHERE logFoldChange > 0.5 ORDER BY geneName;

-- From the previous Differential Expression results, print average for each diffExpResult 
SELECT AVG(mostExtreme_logFoldChange), diffExpResult
FROM previous_findings
GROUP BY diffExpResult;

-- Subset upregulated results
CREATE OR REPLACE VIEW upreg_results AS
SELECT geneName, ensemblName, logFoldChange
FROM expression
WHERE expressionDirection = 'Upreg';

-- Add, swap and remmove columns from table
ALTER TABLE method ADD avExprTumor FLOAT(3, 2) NOT NULL;
ALTER TABLE method ADD avExprControl FLOAT(3, 2) NOT NULL;
DESCRIBE method;
UPDATE method SET avExprTumor=avExprControl, avExprControl=avExprTumor;
ALTER TABLE method DROP avExprTumor, DROP avExprControl;

-- Find all columns that are INT 
SELECT c.* from INFORMATION_SCHEMA.columns c
INNER JOIN INFORMATION_SCHEMA.tables t ON t.table_name = c.table_name
WHERE c.data_type = 'int' AND t.table_type = 'base table';

-- Get Table's PRIMARY KEYS
SHOW KEYS FROM previous_findings WHERE Key_name = 'PRIMARY';

-- Get Tableś FOREIGN KEYS
SELECT 
  TABLE_NAME,COLUMN_NAME,CONSTRAINT_NAME, REFERENCED_TABLE_NAME,REFERENCED_COLUMN_NAME
FROM
  INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE
  REFERENCED_TABLE_SCHEMA = 'BreastCancerGeneExpression' AND
  REFERENCED_TABLE_NAME = 'expression';

-- Get all BRCA entries
SELECT * From expression WHERE GeneName LIKE 'BRCA%';

-- Get PCR_lab for which genes number was in (7000,15000) ordered by GeneNumber
SELECT DISTINCT PCR_lab FROM PCR_laboratory WHERE
genesNumber BETWEEN 7000 AND 15000 ORDER BY genesNumber;

-- Return GeneName, and FoldChange for those diffExpResult that are in method.mostStrikingResult
SELECT GeneName, logFoldChange FROM expression INNER
JOIN method ON expression.diffExpResult = method.mostStrikingResult;

-- Get 50% increment in the mostExtreme_logFoldChange. Do even if value was NULL
SELECT (mostExtreme_logFoldChange + 0.5*IFNULL(mostExtreme_logFoldChange, 0)) 
FROM previous_findings ORDER BY mostExtreme_logFoldChange;

-- Get average logFoldChange for each geneName if it is >1
SELECT AVG(logFoldChange), geneName
FROM expression
GROUP BY geneName
HAVING AVG(logFoldChange) > 1;

-- Print first author
SELECT SUBSTRING_INDEX(authors, "et", 1) AS firtsAuthor
FROM publications;

-- For each geneName rank the logFoldChange's obtained
SELECT diffExpResult,
geneName,
logFoldChange,
DENSE_RANK() OVER (PARTITION BY geneName ORDER BY logFoldChange) AS ranking
FROM expression;

-- For each geneName return a column with the lowest logFoldChange
SELECT geneName,
       logFoldChange,
       MIN(logFoldChange) OVER (PARTITION BY geneName ORDER BY logFoldChange) AS min_logFoldChange
FROM   expression;

-- Find a list of all publications & PCR_laboratory' names
SELECT publications.authors AS studies_authors, publications.methodId AS DiffExp_Method
FROM publications
UNION
SELECT PCR_laboratory.PCR_lab, PCR_laboratory.methodId
FROM PCR_laboratory;

-- Use join to get the geneName of the mostStrikingResult for each method
SELECT expression.diffExpResult, expression.geneName, method.methodName
FROM expression
JOIN method    -- LEFT JOIN for all geneNames to appear (not only those that are mostStrikingResult)
ON expression.diffExpResult = method.mostStrikingResult;

-- Find the names of all publications who have reported average mostExtreme_logFoldChange >6.3
SELECT publications.authors
FROM publications
WHERE publications.paper_index IN (
                          SELECT paper_index
                          FROM (
                                SELECT AVG(previous_findings.mostExtreme_logFoldChange) AS av_LFC, paper_index
                                FROM previous_findings
                                GROUP BY paper_index) AS average_LFC
                          WHERE av_LFC > 6.3
);

-- Find all publications related to the method that reported BRCA2 as 
-- Assume you DONT'T know BRCA2 key
 SELECT publications.paper_index, publications.authors
 FROM publications
 WHERE publications.methodID = (SELECT method.methodID
                           FROM method
                           WHERE method.mostStrikingResult = (SELECT expression.diffExpResult
                                                  FROM expression
                                                  WHERE expression.geneName = 'BRCA2' AND expression.expressionDirection ='Upreg'
                                                  LIMIT 1));

-- Use of triggers to keep track of the diffExpResult added
CREATE TABLE trigger_test (
     message VARCHAR(100)
);
DELIMITER $$
CREATE
    TRIGGER my_trigger BEFORE INSERT
    ON expression
    FOR EACH ROW BEGIN
         IF NEW.expressionDirection = 'Upreg' THEN
               INSERT INTO trigger_test VALUES('added upregulated diffExpResult');
         ELSEIF NEW.expressionDirection = 'Downreg' THEN
               INSERT INTO trigger_test VALUES('added downregulated diffExpResult');
         ELSE
               INSERT INTO trigger_test VALUES('added other diffExpResult');
         END IF;
    END$$
DELIMITER ;

DELIMITER $$
CREATE
    TRIGGER my_trigger2 BEFORE INSERT
    ON expression
    FOR EACH ROW BEGIN
        INSERT INTO trigger_test VALUES(NEW.geneName);
    END$$
DELIMITER ;

INSERT INTO expression
VALUES(11, 'NBN', 'ENSG00000104320', 11, 'Downreg', 0.5, 6, 103);
DROP TRIGGER my_trigger;
DROP TRIGGER my_trigger2;



