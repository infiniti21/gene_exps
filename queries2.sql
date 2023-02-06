USE projekt1;

-- PART I
-- Question 1
DROP PROCEDURE IF EXISTS AvgDifference;
DELIMITER $$
CREATE PROCEDURE AvgDifference(IN id VARCHAR(15), dis_name VARCHAR(25))
BEGIN
/*
Calculating stats for exp where s_id's are qualified on ds_name ('All' or not 'All')
and pb_id's on uid where go_id is 'id' (input 'id' for the genes)
*/
SELECT (
SELECT AVG(exp) FROM microarray_fact WHERE s_id IN 
(SELECT s_id FROM clinical_dis WHERE ds_name=dis_name) AND
pb_id IN(SELECT pb_id FROM probes WHERE uid IN
(SELECT uid FROM gene_fact WHERE go_id = id)))
-
(SELECT AVG(exp) FROM microarray_fact WHERE s_id IN 
(SELECT s_id FROM clinical_dis WHERE ds_name!=dis_name) AND
pb_id IN(SELECT pb_id FROM probes WHERE uid IN
(SELECT uid FROM gene_fact WHERE go_id = id))
) AS exp_difference;
END $$
DELIMITER ;

CALL AvgDifference("0081222", 'Giloblastome');

-- Question 2

DROP PROCEDURE IF EXISTS GeneStatistics;
DELIMITER $$
CREATE PROCEDURE GeneStatistics (IN id VARCHAR(15), IN diseaseName VARCHAR(25), 
OUT Count INT, OUT Avg DECIMAL(20,2), OUT Sum INT)
BEGIN
/*
Calculating stats for exp where s_id's are qualified on ds_name (equal to input 'diseaseName')
and pb_id's on uid where go_id is 'id' (input 'id' for the genes)
*/
    SELECT COUNT(DISTINCT exp), AVG(DISTINCT exp), SUM(DISTINCT exp) INTO Count, Avg, Sum FROM microarray_fact
	WHERE s_id IN (SELECT s_id FROM clinical_dis WHERE ds_name = diseaseName)
	AND pb_id IN(SELECT pb_id FROM probes WHERE uid IN
	(SELECT uid FROM gene_fact WHERE go_id = id));
END $$
DELIMITER ;

CALL GeneStatistics('0007154', 'Giloblastome', @Count, @Avg, @Sum);
SELECT @Count, @Avg, @Sum;


-- PART II

DROP PROCEDURE IF EXISTS ttest_gene_dis;
DELIMITER $$
CREATE PROCEDURE ttest_gene_dis(IN diseaseName VARCHAR(25), IN geneUID VARCHAR(15),
OUT t FLOAT, OUT ttest VARCHAR(10))
BEGIN
/*
Declaring std dev (s), mean (mu), sample size(n), dof (f), pooled variance (sp)
for both groups of the t-test
*/
DECLARE s1 FLOAT; 
DECLARE s2 FLOAT;
DECLARE mu1 FLOAT;
DECLARE mu2 FLOAT;
DECLARE n1 INT; 
DECLARE n2 INT;
DECLARE f INT;
DECLARE sp FLOAT;
DECLARE talpha FLOAT;
/* 
Calculating required statistics of exp for probes of relevant gene ('geneUID')
for both groups (Group 1- ds_name = 'diseaseName', and Group 2- ds_name != 'diseaseName') 
*/
SELECT STD(exp), AVG(exp), count(*)
INTO s1, mu1, n1
FROM (SELECT exp FROM microarray_fact WHERE s_id IN 
(SELECT s_id FROM clinical_dis WHERE ds_name = diseaseName)
AND pb_id IN (SELECT pb_id FROM probes WHERE uid = geneUID)) t1;

SELECT STD(exp), AVG(exp), count(*)
INTO s2, mu2, n2
FROM (SELECT exp FROM microarray_fact WHERE s_id IN 
(SELECT s_id FROM clinical_dis WHERE ds_name != diseaseName)
AND pb_id IN (SELECT pb_id FROM probes WHERE uid = geneUID)) t1;

-- Calculations for the t-test
SET f = n1 + n2 - 2;
SET sp = ((n1-1)*s1*s1 + (n2-1)*s2*s2)/f;
SET t = ABS(mu1-mu2) / SQRT(sp*(1/n1+1/n2));

-- Comparing with talpha from talpha values stored in table t_table_2tail
SELECT t_alpha INTO talpha FROM t_table_2tail WHERE dof=f;

-- Display result of t-test
IF t > talpha THEN SET ttest = 'Pass';
ELSE
SET ttest = 'Fail';
END IF;
END $$
DELIMITER ;

CALL ttest_gene_dis('ALL', '0018493181', @t_stat, @ttest);
SELECT @t_stat, @ttest;


-- INTRODUCTION TO BONUS!

-- A procedure which creates a table containing all the informative genes for a disease
DROP PROCEDURE IF EXISTS all_informative;
DELIMITER $$
CREATE PROCEDURE all_informative (IN dis_name VARCHAR(25))
BEGIN
	DECLARE n INT DEFAULT 0;
    DECLARE i INT DEFAULT 0;
	SELECT COUNT(*) FROM genes INTO n;
    SET i=0;
    -- Create a new table of informative gene uids for a disease
    DROP TABLE IF EXISTS info_genes;
	CREATE TABLE info_genes (info_uid VARCHAR(25));
    -- Run loop n times, where n is the number of genes (uids) in genes table (where uid is PK)
    WHILE i<n DO
		-- For each uid, check if it is informative for that disease or not
        SELECT uid FROM genes LIMIT i,1 INTO @imp_gene;
        CALL ttest_gene_dis(dis_name, @imp_gene, @t_stat, @ttest);
        -- If uid is informative, insert uid to a table of informative genes for that disease, named 'info_genes'
        IF @ttest='Pass' THEN 
			INSERT INTO info_genes (info_uid) VALUES (@imp_gene);
            END IF;
		SET i=i+1;
    END WHILE;
END; $$
DELIMITER ;

CALL all_informative("Colon tumor");
SELECT * FROM info_genes;
