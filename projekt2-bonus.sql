USE projekt1;

/*
A procedure which takes input of disease name and test (test1, test2, etc) 
and predicts whether the test has the disease or not based on method given in question
*/
DROP PROCEDURE IF EXISTS patient_corr_test;
DELIMITER $$
CREATE PROCEDURE patient_corr_test(IN dis_name VARCHAR(25), IN test_num VARCHAR(25))
BEGIN
	-- Declaring variables for looping (i,n) and for calculating correlation
    DECLARE n INT DEFAULT 0;
    DECLARE i INT DEFAULT 0;
    DECLARE s INT DEFAULT 0;
    DECLARE corr_coef FLOAT;
	DECLARE sig_x FLOAT DEFAULT 0;
	DECLARE sig_y FLOAT DEFAULT 0;
    DECLARE sig_xsq FLOAT DEFAULT 0;
    DECLARE sig_ysq FLOAT DEFAULT 0;
    DECLARE sig_xy FLOAT DEFAULT 0;
    
    -- Prepared statement for selecting which test sample to use based on input (test1, test2, etc.)
    SET @colname = test_num;
    SET @sql1 = CONCAT('CREATE TABLE test_exps AS SELECT uid, ',@colname,' FROM test_samples WHERE uid IN (SELECT uid FROM info_genes)');
    SET @sql2 = CONCAT('ALTER TABLE test_exps RENAME COLUMN ',@colname,' TO test');
    PREPARE stmt1 FROM @sql1;
    PREPARE stmt2 FROM @sql2;
	/*
    Calling procedure all_informative with input variable 'dis_name' to get all 
    informative genes of the disease into table 'info_genes'
    */
    CALL all_informative(dis_name);
    /* 
    Create table 'test_exps' with uids and their exp value for the given test case, 
    using sql statements prepared earlier
    */
    DROP TABLE IF EXISTS test_exps;
    EXECUTE stmt1;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt1;
	DEALLOCATE PREPARE stmt2;
	/*
    Create table "positive-disease correlation", pos_dis_corr, to store correlation values of 
    test's genes' exp with those of all patients who have the disease.
    Similarly, table neg_dis_corr stores values of correlation between exp of test's genes 
    and exp of patients without the disease.
    */
    DROP TABLE IF EXISTS pos_dis_corr;
    CREATE TABLE pos_dis_corr(corr FLOAT);
    DROP TABLE IF EXISTS neg_dis_corr;
    CREATE TABLE neg_dis_corr(corr FLOAT);
    
    SELECT COUNT(*) FROM clinical_dis WHERE ds_name=dis_name AND s_id IS NOT NULL INTO n;
    SET i=0;
    WHILE i<n DO
		-- ith sample id stored into @p_s_id
		SELECT DISTINCT s_id FROM clinical_dis WHERE ds_name=dis_name AND s_id IS NOT NULL LIMIT i,1 INTO @p_s_id; 
        
        -- Create table pat_exps to store exp values for the current s_id
        DROP TABLE IF EXISTS pat_exps;
        CREATE TABLE pat_exps AS SELECT t2.uid, t1.exp FROM 
        (SELECT pb_id, exp FROM microarray_fact WHERE s_id=@p_s_id) t1 JOIN (SELECT pb_id, t3.uid FROM probes t3 WHERE uid IN
        (SELECT uid FROM info_genes)) t2 ON t1.pb_id=t2.pb_id;
        
        /*
        Create view pat_test_exps to retieve information in the form- 
        uid, tests' exp value, current patient's exp value 
        */
        DROP VIEW IF EXISTS pat_test_exps;
        CREATE VIEW pat_test_exps AS
        SELECT t1.uid, test, exp FROM test_exps t1 
        JOIN pat_exps t2 ON t1.uid=t2.uid;
        
        -- Calculate correlation and store the correlation value in pos_dis_corr
        SELECT COUNT(*), SUM(exp), SUM(test), SUM(POW(exp,2)), SUM(POW(test,2)), SUM(exp*test) 
        INTO s, sig_x, sig_y, sig_xsq, sig_ysq, sig_xy FROM pat_test_exps;
        SET corr_coef = (s*sig_xy - sig_x*sig_y)/SQRT((s*sig_xsq-POW(sig_x,2))*(s*sig_ysq-POW(sig_y,2)));
        INSERT INTO pos_dis_corr (corr) VALUES(corr_coef);        
    	SET i=i+1;
    END WHILE;
    
    -- Same procedure done for the group of patients without the disease with resulting correlation values stored in neg_dis_corr
    SELECT COUNT(*) FROM clinical_dis WHERE ds_name!=dis_name AND s_id IS NOT NULL INTO n;
    SET i=0;
    WHILE i<n DO
		SELECT DISTINCT s_id FROM clinical_dis WHERE ds_name!=dis_name AND s_id IS NOT NULL LIMIT i,1 INTO @p_s_id;
        
        DROP TABLE IF EXISTS pat_exps;
        CREATE TABLE pat_exps AS SELECT t2.uid, t1.exp FROM 
        (SELECT pb_id, exp FROM microarray_fact WHERE s_id=@p_s_id) t1 JOIN (SELECT pb_id, t3.uid FROM probes t3 WHERE uid IN
        (SELECT uid FROM info_genes)) t2 ON t1.pb_id=t2.pb_id;
        
        DROP VIEW IF EXISTS pat_test_exps;
        CREATE VIEW pat_test_exps AS
        SELECT t1.uid, test, exp FROM test_exps t1 
        JOIN pat_exps t2 ON t1.uid=t2.uid;
        
        SELECT COUNT(*), SUM(exp), SUM(test), SUM(POW(exp,2)), SUM(POW(test,2)), SUM(exp*test) 
        INTO s, sig_x, sig_y, sig_xsq, sig_ysq, sig_xy FROM pat_test_exps;
        
        SET corr_coef = (s*sig_xy - sig_x*sig_y)/SQRT((s*sig_xsq-POW(sig_x,2))*(s*sig_ysq-POW(sig_y,2)));
        INSERT INTO neg_dis_corr (corr) VALUES(corr_coef);  
		SET i=i+1;
    END WHILE;
END; $$
DELIMITER ;

DROP PROCEDURE IF EXISTS ttest_predict;
DELIMITER $$
CREATE PROCEDURE ttest_predict(OUT t FLOAT, OUT ttest VARCHAR(10))
BEGIN
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
Performing two sample t test (alpha = 0.01) on correlation values from 
pos_dis_corr and neg_dis_corr
*/
SELECT STD(corr), AVG(corr), count(*)
INTO s1, mu1, n1
FROM pos_dis_corr;

SELECT STD(corr), AVG(corr), count(*)
INTO s2, mu2, n2
FROM neg_dis_corr;

-- Calculations for the t-test

SET f = n1 + n2 - 2;
SET sp = ((n1-1)*s1*s1 + (n2-1)*s2*s2)/f;
-- SELECT s1, s2, n1, n2, f, sp, mu1, mu2;
SET t = ABS(mu1-mu2) / SQRT(sp*(1/n1+1/n2));

SELECT t_alpha INTO talpha FROM t_table_2tail WHERE dof=f;

SELECT t, talpha;

-- Display result of t-test
IF t > talpha THEN 
	SET ttest = 'Pass';
ELSE
	SET ttest = 'Fail';
END IF;
END $$
DELIMITER ;

CALL patient_corr_test('ALL', 'test4'); -- patient n = test n+1
/*
Now that all correlation values are stored in pos_dis_corr and neg_dis_corr,
use ttest_predict to perform t-test on pos_dis_corr and neg_dis_corr and make prediction for disease in test
*/
CALL ttest_predict(@t, @ttest);
SELECT @t, @ttest;
