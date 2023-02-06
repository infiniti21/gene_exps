USE projekt1;

DROP VIEW IF EXISTS clinical_dis;
DROP VIEW IF EXISTS clinical_dr;

/*
Creating a base table view "clinical_dis" containing all p_id's, their disease details, 
and sample id's as this information is required several times throughout the project.
1. Join "clinical_fact" and "diseases" to get disease details for each p_id
2. Join the resulting table with clinical_fact again to get s_id, wherever available
*/
CREATE VIEW clinical_dis AS
SELECT t3.p_id, t3.ds_id, t3.ds_name, t3.ds_type, t3.ds_description, t1.s_id FROM
(SELECT t1.p_id, t1.ds_id, t2.ds_name, t2.ds_type, t2.ds_description FROM clinical_fact t1
INNER JOIN diseases t2 ON t1.ds_id = t2.ds_id) t3 LEFT JOIN (SELECT p_id, s_id FROM clinical_fact WHERE s_id IS NOT NULL) t1 ON
 t1.p_id = t3.p_id;

-- Question 1
/*
slecting relevant details from "clinical_dis" which has disease 
and sample details for all p_id's
*/
SELECT ds_description 'Case', COUNT(p_id) 'Count' FROM clinical_dis WHERE ds_description = "tumor" UNION
SELECT ds_type, COUNT(p_id) FROM clinical_dis WHERE ds_type = 'leukemia' UNION
SELECT ds_name, COUNT(p_id) FROM clinical_dis WHERE ds_name = 'ALL';


-- creating view "clinical_dr" with p_id's and the drugs details prescribed to each p_id
CREATE VIEW clinical_dr AS
SELECT t1.p_id, t1.dr_id, t2.dr_type FROM clinical_fact t1
INNER JOIN drugs t2 ON t1.dr_id = t2.dr_id;

-- Question 2
/* 
Joining views with p_id and disease details (clinical_dis) and p_id and drug details (clinical_dr)
to get relevant information 
*/
SELECT DISTINCT dr_type AS dr_type_tumor FROM 
(SELECT t1.p_id, ds_id, ds_description, dr_id, dr_type 
FROM clinical_dr t1 JOIN clinical_dis t2
ON t1.p_id = t2.p_id) t3
WHERE ds_description = 'tumor'
ORDER BY dr_type_tumor;

-- Question 3
/*
Selecting relevant data from "microarray_fact" by qualifying records on-
s_id : selecting only those where ds_name = 'All'
mu_id : '001'
pb_id: selecting only those where uid has cl_id = '00002'
*/
SELECT s_id AS sample, e_id AS experiment, exp AS mRNA_value FROM microarray_fact 
WHERE s_id IN (SELECT s_id FROM clinical_dis WHERE ds_name = 'All') AND mu_id = '001' AND
pb_id IN (SELECT pb_id FROM probes WHERE uid IN
(SELECT uid FROM gene_fact WHERE cl_id = '00002')) 
ORDER BY experiment, mRNA_value;

-- Question 4
/*
Difference of AVG(exp) between s_id's with ds_name "All" and ds_name not "All", 
and whose pb_id is in the list of pb_id's whose uid's have go_id = '0012502'
*/ 
SELECT (
SELECT AVG(exp) FROM microarray_fact WHERE s_id IN 
(SELECT s_id FROM clinical_dis WHERE ds_name='All') AND
pb_id IN(SELECT pb_id FROM probes WHERE uid IN
(SELECT uid FROM gene_fact WHERE go_id = "0012502")))
-
(SELECT AVG(exp) FROM microarray_fact WHERE s_id IN 
(SELECT s_id FROM clinical_dis WHERE ds_name!='All') AND
pb_id IN(SELECT pb_id FROM probes WHERE uid IN
(SELECT uid FROM gene_fact WHERE go_id = "0012502"))
) AS exp_difference;
 
 
 -- Question 5
 /*
 1. Inner join microarray_fact with relevant s_id's and ds_name (based on ds_name) from "clinical_dis"
 2. Qualify resulting records on pb_id (similar to Question 4)
 3. Display ds_name and avg(exp), grouped by ds_name
 */
SELECT ds_name, AVG(exp) FROM microarray_fact t1 JOIN (
SELECT s_id, ds_name FROM clinical_dis WHERE ds_name IN 
("ALL", "AML", "colon tumor", "breast tumor")) t2 ON t1.s_id = t2.s_id WHERE
pb_id IN(SELECT pb_id FROM probes WHERE uid IN
(SELECT uid FROM gene_fact WHERE go_id = "0007154"))
GROUP BY ds_name ORDER BY AVG(exp) DESC;