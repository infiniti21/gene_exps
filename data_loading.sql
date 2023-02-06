DROP DATABASE IF EXISTS projekt1;
CREATE DATABASE projekt1;

USE projekt1;
BEGIN;
CREATE TABLE IF NOT EXISTS patients (p_id VARCHAR(15) PRIMARY KEY, 
ssn VARCHAR(12), p_name VARCHAR(25), p_gender VARCHAR(10), p_dob DATE);
CREATE TABLE IF NOT EXISTS diseases (ds_id VARCHAR(15) PRIMARY KEY, 
ds_name VARCHAR(25), ds_type VARCHAR(35), ds_description VARCHAR(50));
CREATE TABLE IF NOT EXISTS drugs (dr_id VARCHAR(15) PRIMARY KEY, 
dr_name VARCHAR(25), dr_type VARCHAR(35), dr_description VARCHAR(50));
CREATE TABLE IF NOT EXISTS tests (tt_id VARCHAR(15) PRIMARY KEY, 
tt_name VARCHAR(25), tt_type VARCHAR(35), tt_setting VARCHAR(50));
CREATE TABLE IF NOT EXISTS clinical_fact (p_id VARCHAR(15) NOT NULL, ds_id VARCHAR(15), symptom VARCHAR(50), 
ds_from DATE, ds_to DATE, dr_id VARCHAR(15), dosage INT, dr_from DATE, dr_to DATE, 
tt_id VARCHAR(15), tt_result VARCHAR(50), tt_date DATE, s_id VARCHAR(15));

LOAD DATA INFILE 'E:\\MSDA\\Fall22\\Data Management\\Projekt I\\data_OG\\patient.txt' INTO TABLE patients 
FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE 'E:\\MSDA\\Fall22\\Data Management\\Projekt I\\data_OG\\disease.txt' INTO TABLE diseases 
FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE 'E:\\MSDA\\Fall22\\Data Management\\Projekt I\\data_OG\\drug.txt' INTO TABLE drugs 
FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE 'E:\\MSDA\\Fall22\\Data Management\\Projekt I\\data_OG\\test.txt' INTO TABLE tests 
FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE 'E:\\MSDA\\Fall22\\Data Management\\Projekt I\\data_OG\\clinical_fact.txt' INTO TABLE clinical_fact 
FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@vp_id, @vds_id, @vsymptom, @vds_from, @vds_to, @vdr_id, @vdosage, 
@vdr_from, @vdr_to, @vtt_id, @vtt_result, @vtt_date, @vs_id)
SET 
p_id = NULLIF(@vp_id, 'null'),
ds_id = NULLIF(@vds_id, 'null'),
symptom = NULLIF(@vsymptom, 'null'),
ds_from = NULLIF(@vds_from, 'null'),
ds_to = NULLIF(@vds_to, 'null'),
dr_id = NULLIF(@vdr_id, 'null'),
dosage = NULLIF(@vdosage, 'null'),
dr_from = NULLIF(@vds_from, 'null'),
dr_to = NULLIF(@vds_to, 'null'),
tt_id = NULLIF(@vtt_id, 'null'),
tt_result = NULLIF(@vtt_result, 'null'),
tt_date = NULLIF(@vtt_date, 'null'),
s_id = NULLIF(@vs_id, 'null');

CREATE TABLE IF NOT EXISTS samples (s_id VARCHAR(15) PRIMARY KEY, 
s_source VARCHAR(15), s_amount INT, s_date DATE);
CREATE TABLE IF NOT EXISTS markers (mk_id VARCHAR(15) PRIMARY KEY, 
mk_name VARCHAR(25), mk_type VARCHAR(35), mk_locus VARCHAR(50), mk_description VARCHAR(50));
CREATE TABLE IF NOT EXISTS assays (as_id VARCHAR(15) PRIMARY KEY, 
as_name VARCHAR(25), as_type VARCHAR(35), as_setting VARCHAR(50), as_description VARCHAR(50));
CREATE TABLE IF NOT EXISTS terms (tm_id VARCHAR(15) PRIMARY KEY, 
tm_name VARCHAR(25), tm_type VARCHAR(35), tm_setting VARCHAR(50));
CREATE TABLE IF NOT EXISTS sample_fact (s_id VARCHAR(15) NOT NULL, mk_id VARCHAR(15), mk_result VARCHAR(50),
mk_date DATE, as_id VARCHAR(15), as_result VARCHAR(50), as_date DATE, tm_id VARCHAR(15), tm_description VARCHAR(50));


LOAD DATA INFILE 'E:\\MSDA\\Fall22\\Data Management\\Projekt I\\data_OG\\sample.txt' INTO TABLE samples 
FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE 'E:\\MSDA\\Fall22\\Data Management\\Projekt I\\data_OG\\marker.txt' INTO TABLE markers 
FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE 'E:\\MSDA\\Fall22\\Data Management\\Projekt I\\data_OG\\assay.txt' INTO TABLE assays 
FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE 'E:\\MSDA\\Fall22\\Data Management\\Projekt I\\data_OG\\term.txt' INTO TABLE terms 
FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE 'E:\\MSDA\\Fall22\\Data Management\\Projekt I\\data_OG\\sample_fact.txt' INTO TABLE sample_fact 
FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@vs_id, @vmk_id, @vmk_result, @vmk_date, @vas_id, @vas_result, @vas_date, 
@vtm_id, @vtm_description)
SET 
s_id = NULLIF(@vs_id, 'null'),
mk_id = NULLIF(@vmk_id, 'null'),
mk_result = NULLIF(@vmk_result, 'null'),
mk_date = NULLIF(@vmk_date, 'null'),
as_id = NULLIF(@vas_id, 'null'),
as_result = NULLIF(@as_result, 'null'),
as_date = NULLIF(@vas_date, 'null'),
tm_id = NULLIF(@vtm_id, 'null'),
tm_description = NULLIF(@vtm_description, 'null');


CREATE TABLE IF NOT EXISTS probes (pb_id VARCHAR(15) PRIMARY KEY, 
uid VARCHAR(15), pb_name VARCHAR(25), pb_description VARCHAR(50), isqc VARCHAR(10));
CREATE TABLE IF NOT EXISTS measure_units (mu_id VARCHAR(15) PRIMARY KEY, 
mu_name VARCHAR(25), mu_type VARCHAR(35), mu_description VARCHAR(50));
CREATE TABLE microarray_fact (s_id VARCHAR(15) NOT NULL, 
e_id VARCHAR(15), pb_id VARCHAR(15), mu_id VARCHAR(15), exp INT);

LOAD DATA INFILE 'E:\\MSDA\\Fall22\\Data Management\\Projekt I\\data_OG\\probe.txt' INTO TABLE probes 
FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE 'E:\\MSDA\\Fall22\\Data Management\\Projekt I\\data_OG\\measureUnit.txt' INTO TABLE measure_units 
FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE 'E:\\MSDA\\Fall22\\Data Management\\Projekt I\\data_OG\\microarray_fact.txt' INTO TABLE microarray_fact 
FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

CREATE TABLE IF NOT EXISTS genes (uid VARCHAR(15) PRIMARY KEY, 
g_seq_type VARCHAR(35), g_accession VARCHAR(35), g_version VARCHAR(15), 
g_seq_dataset VARCHAR(15), g_species_id VARCHAR(15), g_status VARCHAR(5));
CREATE TABLE IF NOT EXISTS gos (go_id VARCHAR(15) PRIMARY KEY,
go_accession VARCHAR(25), go_type VARCHAR(35), go_name VARCHAR(25), go_definition VARCHAR(50));
CREATE TABLE IF NOT EXISTS clusters (cl_id VARCHAR(15), cl_num VARCHAR(15), 
cl_pattern VARCHAR(35), cl_tool VARCHAR(35), cl_tsetting VARCHAR(50), 
cl_description VARCHAR(50), PRIMARY KEY (cl_id, cl_num));
CREATE TABLE IF NOT EXISTS domains (dm_id VARCHAR(15) PRIMARY KEY,
dm_type VARCHAR(35), dm_db VARCHAR(35), dm_accession VARCHAR(35), dm_title VARCHAR(25), 
dm_length INT, dm_description VARCHAR(50));
CREATE TABLE IF NOT EXISTS promoters (pm_id VARCHAR(15) PRIMARY KEY, 
pm_type VARCHAR(35), pm_sequence VARCHAR(100), pm_length INT, pm_description VARCHAR(50));
CREATE TABLE gene_fact (uid VARCHAR(15) NOT NULL, 
go_id VARCHAR(15), cl_id VARCHAR(15), dm_id VARCHAR(15), pm_id VARCHAR(15), uid2 VARCHAR(15));

LOAD DATA INFILE 'E:\\MSDA\\Fall22\\Data Management\\Projekt I\\data_OG\\gene.txt' INTO TABLE genes 
FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE 'E:\\MSDA\\Fall22\\Data Management\\Projekt I\\data_OG\\go.txt' INTO TABLE gos 
FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE 'E:\\MSDA\\Fall22\\Data Management\\Projekt I\\data_OG\\cluster.txt' INTO TABLE clusters 
FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE 'E:\\MSDA\\Fall22\\Data Management\\Projekt I\\data_OG\\domain.txt' INTO TABLE domains 
FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE 'E:\\MSDA\\Fall22\\Data Management\\Projekt I\\data_OG\\promoter.txt' INTO TABLE promoters 
FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE 'E:\\MSDA\\Fall22\\Data Management\\Projekt I\\data_OG\\gene_fact.txt' INTO TABLE gene_fact 
FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@vuid, @vgo_id, @vcl_id, @vdm_id, @vpm_id, @vuid2)
SET 
uid = NULLIF(@vuid, 'null'),
go_id = NULLIF(@vgo_id, 'null'),
cl_id = NULLIF(@vcl_id, 'null'),
dm_id = NULLIF(@vdm_id, 'null'),
pm_id = NULLIF(@vpm_id, 'null'),
uid2 = NULLIF(@vuid2, 'null');

CREATE TABLE experiments (e_id VARCHAR(15), 
e_name VARCHAR(25), e_type VARCHAR(35));
CREATE TABLE projects (pj_id VARCHAR(15) PRIMARY KEY, 
pj_name VARCHAR(25), pj_investigator VARCHAR(25), pj_description VARCHAR(50));
CREATE TABLE platforms (pf_id VARCHAR(15), pf_hardware VARCHAR(25), pf_software VARCHAR(25), 
pf_setting VARCHAR(50), pf_description VARCHAR(50), PRIMARY KEY (pf_id, pf_hardware, pf_software));
CREATE TABLE norms (nm_id VARCHAR(15), 
nm_type VARCHAR(35), nm_software VARCHAR(25), nm_parameter VARCHAR(50), nm_description VARCHAR(50), PRIMARY KEY (nm_id, nm_software));
CREATE TABLE persons (pn_id VARCHAR(15), pn_name VARCHAR(25), 
pn_lab VARCHAR(25), pn_contact VARCHAR(50), PRIMARY KEY (pn_id, pn_name));
CREATE TABLE protocols (pt_id VARCHAR(15) PRIMARY KEY, 
pt_name VARCHAR(25), pt_text VARCHAR(100), pt_creator VARCHAR(25));
CREATE TABLE publications (pu_id VARCHAR(15), pu_med_id VARCHAR(15), pu_title VARCHAR(25), 
pu_authors VARCHAR(100), pu_abstract VARCHAR(200), pu_date DATE, PRIMARY KEY (pu_id, pu_med_id));
CREATE TABLE experiment_fact (e_id VARCHAR(15) NOT NULL, 
nm_id VARCHAR(15), pj_id VARCHAR(15), pn_id VARCHAR(15), pf_id VARCHAR(15), pt_id VARCHAR(15), pu_id VARCHAR(15));

LOAD DATA INFILE 'E:\\MSDA\\Fall22\\Data Management\\Projekt I\\data_OG\\experiment.txt' INTO TABLE experiments 
FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE 'E:\\MSDA\\Fall22\\Data Management\\Projekt I\\data_OG\\project.txt' INTO TABLE projects 
FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE 'E:\\MSDA\\Fall22\\Data Management\\Projekt I\\data_OG\\platform.txt' INTO TABLE platforms 
FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE 'E:\\MSDA\\Fall22\\Data Management\\Projekt I\\data_OG\\norm.txt' INTO TABLE norms 
FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE 'E:\\MSDA\\Fall22\\Data Management\\Projekt I\\data_OG\\person.txt' INTO TABLE persons 
FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE 'E:\\MSDA\\Fall22\\Data Management\\Projekt I\\data_OG\\publication.txt' INTO TABLE publications 
FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE 'E:\\MSDA\\Fall22\\Data Management\\Projekt I\\data_OG\\experiment_fact.txt' INTO TABLE experiment_fact 
FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(@ve_id, @vnm_id, @vpj_id, @vpn_id, @vpf_id, @vpt_id, @vpu_id)
SET 
e_id = NULLIF(@ve_id, 'null'),
nm_id = NULLIF(@vnm_id, 'null'),
pj_id = NULLIF(@vpj_id, 'null'),
pn_id = NULLIF(@vpn_id, 'null'),
pf_id = NULLIF(@vpf_id, 'null'),
pt_id = NULLIF(@vpt_id, 'null'),
pu_id = NULLIF(@vpu_id, 'null');

-- ======================================================================================================================================
-- New part from here

CREATE TABLE IF NOT EXISTS test_samples (uid VARCHAR(25), 
test1 INT, test2 INT, test3 INT, test4 INT, test5 INT);
LOAD DATA INFILE 'E:\\MSDA\\Fall22\\Data Management\\Projekt I\\data_OG\\test_samples.txt' INTO TABLE test_samples 
FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
/*
1 tailed t test table, we must ignore.

CREATE TABLE IF NOT EXISTS t_table (dof INT, t_alpha FLOAT);
INSERT INTO t_table (dof, t_alpha) VALUES (1,31.8209640681743),
(2,6.96454662829637),
(3,4.54070686828345),
(4,3.7469362723641),
(5,3.36493030772544),
(6,3.14266799250617),
(7,2.99794919556006),
(8,2.89646777673624),
(9,2.82143446383997),
(10,2.76377249974757),
(11,2.7180794859305),
(12,2.6809902919922),
(13,2.65030394075438),
(14,2.62449248111806),
(15,2.60248270933516),
(16,2.58349245996214),
(17,2.56693965638987),
(18,2.55237864621449),
(19,2.53948201134335),
(20,2.52797690336592),
(21,2.51764504355378),
(22,2.50832272286061),
(23,2.49987351708114),
(24,2.4921610020101),
(25,2.48510332312434),
(26,2.47862772084772),
(27,2.47266143560409),
(28,2.46714080276433),
(29,2.46202034759335),
(30,2.45726369030308),
(31,2.45282535615843),
(32,2.44867806031834),
(33,2.44479451794177),
(34,2.44114744418766),
(35,2.43771864916197),
(36,2.4344990379177),
(37,2.43144313571974),
(38,2.42856913246214),
(39,2.42584064835682),
(40,2.42325768340378),
(41,2.420802047709),
(42,2.41847374127246),
(43,2.41625457420013),
(44,2.41413545154501),
(45,2.41211637330707),
(46,2.41018824453931),
(47,2.40834197029471),
(48,2.40657755057327),
(49,2.40488589042797),
(50,2.40326698985882),
(51,2.4017208488658),
(52,2.40022927755489),
(53,2.39879227592609),
(54,2.3974098439794),
(55,2.39608198171481),
(56,2.39479959418532),
(57,2.39357177633792),
(58,2.3923803382786),
(59,2.39122528000734),
(60,2.39011569647118),
(61,2.38904249272309),
(62,2.38800566876307),
(63,2.38700522459112),
(64,2.38604116020724),
(65,2.38509528571739),
(66,2.38418579101562),
(67,2.38330358115491),
(68,2.38244865613524),
(69,2.38161192100961),
(70,2.38080247072502),
(71,2.3800203052815),
(72,2.37925632973201),
(73,2.37851963902358),
(74,2.37780113820917),
(75,2.37710082728881),
(76,2.37641870626248),
(77,2.37575477513019),
(78,2.37510903389193),
(79,2.37448148254771),
(80,2.37387212109751),
(81,2.37327185459434),
(82,2.37268977798521),
(83,2.3721167963231),
(84,2.37156200455501),
(85,2.37101630773395),
(86,2.37048880080692),
(87,2.36997948377393),
(88,2.36947016674093),
(89,2.36897903960198),
(90,2.36849700741004),
(91,2.36802407016512),
(92,2.36756022786721),
(93,2.36711457546335),
(94,2.36666892305947),
(95,2.36624146054965),
(96,2.36582309298683),
(97,2.36540472542401),
(98,2.36500454775523),
(99,2.36460437008645),
(100,2.36421328736469);
*/

CREATE TABLE IF NOT EXISTS t_table_2tail (dof INT, t_alpha FLOAT);
LOAD DATA INFILE 'E:\\MSDA\\Fall22\\Data Management\\Projekt I\\data_OG\\t_2tailed_001.txt' INTO TABLE t_table_2tail 
FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

-- SET GLOBAL local_infile=1;
-- SELECT CAST("null" AS DATE);
-- SELECT CONVERT("null", INT)
-- SELECT @@sql_mode;
-- #'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION'
-- SET @@sql_mode

-- Create table 'clinical_dis' which has all disease details and sample ids for all patient ids
CREATE TABLE IF NOT EXISTS clinical_dis AS
SELECT t3.p_id, t3.ds_id, t3.ds_name, t3.ds_type, t3.ds_description, t1.s_id FROM
(SELECT t1.p_id, t1.ds_id, t2.ds_name, t2.ds_type, t2.ds_description FROM clinical_fact t1
INNER JOIN diseases t2 ON t1.ds_id = t2.ds_id) t3 LEFT JOIN 
(SELECT p_id, s_id FROM clinical_fact WHERE s_id IS NOT NULL) t1 ON t1.p_id = t3.p_id;
-- SELECT * FROM clinical_dis;


-- Creating index on columns used in t test calculation for faster indexing
CREATE INDEX ix_microarray_fact ON microarray_fact (s_id, pb_id);
CREATE INDEX ix_probes ON probes (pb_id, uid);
CREATE INDEX ix_clinical_dis ON clinical_dis (p_id, s_id, ds_name);

