/*Find the names of genes that were either positively expressed twofold or more with a significance of at least 1.0, in some experiment, or negatively expressed twofold or less with a significance of at least 1.0, in some experiment. List them alongside their organisms in a two-column format. */
SELECT Genes.gid, name, level, significance
FROM Expression, Genes
WHERE Expression.gid = Genes.gid
AND significance >= 1.0
AND (level >= 2.0 OR level <= 2.0);