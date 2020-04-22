DROP DATABASE BreastCancerGeneExpression;
CREATE DATABASE BreastCancerGeneExpression;
USE BreastCancerGeneExpression;
SHOW DATABASES;

CREATE TABLE expression (
  diffExpResult INT PRIMARY KEY,
  geneName VARCHAR(40),
  ensemblName VARCHAR(40) NOT NULL,
  transcriptsNumber INT DEFAULT 1,
  expressionDirection VARCHAR(10),
  logFoldChange FLOAT,
  strongestMutationCorr INT,
  methodID INT
);

CREATE TABLE method (
  methodID INT PRIMARY KEY,
  methodName VARCHAR(40),
  mostStrikingResult INT,
  publicationDate DATE,
  FOREIGN KEY(mostStrikingResult) REFERENCES expression(diffExpResult) ON DELETE SET NULL
);

ALTER TABLE expression
ADD FOREIGN KEY(methodID)
REFERENCES method(methodID)
ON DELETE SET NULL;

ALTER TABLE expression
ADD FOREIGN KEY(strongestMutationCorr)
REFERENCES expression(diffExpResult)
ON DELETE SET NULL;

CREATE TABLE publications (
  paper_index INT PRIMARY KEY,
  authors VARCHAR(40),
  methodID INT,
  FOREIGN KEY(methodID) REFERENCES method(methodID) ON DELETE SET NULL
);

CREATE TABLE previous_findings (
  diffExpResult INT,
  paper_index INT,
  mostExtreme_logFoldChange FLOAT,
  PRIMARY KEY(diffExpResult, paper_index),
  FOREIGN KEY(diffExpResult) REFERENCES expression(diffExpResult) ON DELETE CASCADE,
  FOREIGN KEY(paper_index) REFERENCES publications(paper_index) ON DELETE CASCADE
);

CREATE TABLE PCR_laboratory (
  methodID INT,
  PCR_lab VARCHAR(40),
  genesNumber VARCHAR(40),
  PRIMARY KEY(methodID, PCR_lab),
  FOREIGN KEY(methodID) REFERENCES method(methodID) ON DELETE CASCADE
);


-- -----------------------------------------------------------------------------

-- LimmaVoom
INSERT INTO expression VALUES(1,'BRCA1', 'ENSG00000012048', 34, 'Upreg', 2.45, NULL, NULL);

INSERT INTO method VALUES(101, 'LimmaVoom', 1, '2006-02-09');

UPDATE expression
SET methodID = 101
WHERE diffExpResult = 1;

INSERT INTO expression VALUES(2, 'BRCA2', 'ENSG00000139618', 21, 'Upreg', 1.09, 1, 101);

-- DESeq2
INSERT INTO expression VALUES(3, 'PALB2', 'ENSG0000014596', 3, 'Downreg', 2.01, 1, NULL);

INSERT INTO method VALUES(102, 'DESeq2', 3, '1992-04-06');

UPDATE expression
SET methodID = 102
WHERE diffExpResult = 3;

INSERT INTO expression VALUES(4, 'BRCA1', 'ENSG00000012048', 34, 'Upreg', 1.31, 2, 102);
INSERT INTO expression VALUES(5, 'PTEN', 'ENSG0000021585', 13, 'Upreg', 0.6, 2, 102);
INSERT INTO expression VALUES(6, 'TP53', 'ENSG00000141510', 29, 'Downreg', 0.65, 2, 102);

-- edgeR
INSERT INTO expression VALUES(7, 'ATM', 'ENSG00000339512', 14, 'Downreg', 2.41, 4, NULL);

INSERT INTO method VALUES(103, 'edgeR', 6, '1998-02-13');

UPDATE expression
SET methodID = 103
WHERE diffExpResult = 7;

INSERT INTO expression VALUES(8, 'TP53', 'ENSG00000141510', 29, 'Upreg', 1.7, 6, 103);
INSERT INTO expression VALUES(9, 'CDH1', 'ENSG00000610038', 31, 'Downreg', 0.06, 7, 103);


-- PCR_laboratory
INSERT INTO PCR_laboratory VALUES(102, 'Lab 13', '16001');
INSERT INTO PCR_laboratory VALUES(102, 'Lab 7(UK)', '7000');
INSERT INTO PCR_laboratory VALUES(103, 'Lab 4', '14556');
INSERT INTO PCR_laboratory VALUES(102, 'Lab7 & Lab13', '6000');
INSERT INTO PCR_laboratory VALUES(103, 'Lab 5(US)', '5600');
INSERT INTO PCR_laboratory VALUES(103, 'Lab 13', '16001');
INSERT INTO PCR_laboratory VALUES(103, 'Lab 7(UK)', '14000');

-- publications
INSERT INTO publications VALUES(40, 'Pim et al., 2015', 102);
INSERT INTO publications VALUES(41, 'Simon et al., 2018', 102);
INSERT INTO publications VALUES(42, 'Chao et al., 2014', 103);
INSERT INTO publications VALUES(43, 'Daly et al., 2011', 103);
INSERT INTO publications VALUES(44, 'Scranton et al., 2018', 102);
INSERT INTO publications VALUES(45, 'Gutierrez et al., 2020', 103);
INSERT INTO publications VALUES(46, 'Rivera et al., 2019', 102);

-- previous_findings
INSERT INTO previous_findings VALUES(3, 40, 7.1);
INSERT INTO previous_findings VALUES(3, 41, 6.4);
INSERT INTO previous_findings VALUES(8, 42, 5.1);
INSERT INTO previous_findings VALUES(9, 43, 7.7);
INSERT INTO previous_findings VALUES(8, 43, 3.1);
INSERT INTO previous_findings VALUES(4, 44, 2.9);
INSERT INTO previous_findings VALUES(8, 45, 0.9);
INSERT INTO previous_findings VALUES(4, 46, 4.7);
INSERT INTO previous_findings VALUES(3, 46, 3.7);

