# gene_exps

PART 1 - 'queries1.sql'

## Identifying important genes for a disease and predicting presence of disease based on gene expression values.

Implement a clinical and genomic database based on your schema design using the MySQL system. The database should: (1) support regular queries and statistical OLAP operations; (2) be robust to potential changes in the future; an (3) support knowledge discovery.
Following are some typical queries by users, write MySQL scripts to answer them. Notice that you should retrieve the data from the MySQL system instead of the original plain text files. Report your approach and the results returned by your database.

•	List the number of patients who had “tumor” (disease description), “leukemia” (disease type) and “ALL’ (disease name), separately.
•	List the types of drugs which have been applied to patients with “tumor”.
•	For each sample of patients with “ALL”, list the mRNA values (expression) of probes in cluster id “00002” for each experiment with measure unit id=“001”. 
(Note: mea-sure unit id corresponds to mu_id in microarray_fact.txt, cluster id corresponds to cl_id in gene_fact.txt, mRNA expression value corresponds to exp in microarray_fact.txt, UID in porbe.txt is a foreign key referring to gene_fact.txt.)
•	For probes belonging to GO with id = “0012502”, calculate the difference between the average of the expression values of patients with “ALL” and the average of expression values of patients without “ALL”. 
•	For probes belonging to GO with id=“0007154”, calculate the average of the expression values among patients with “ALL”, “AML”, “colon tumor” and “breast tumor”, and order by the average value in a descending order. 
 
A	Appendix: Descriptions of data file format
For each files in data_og.zip, it is considered as an entity which starts with a row describing the fields of the entity. Then, each following row in the file corresponds to one instance of the entity.

A.1	Clinical data space
Entities: patient, disease, drug, test and sample; Fact table: clinical_fact.

•	patient.txt (p_id, ssn, name, gender,DOB)

•	disease.txt (ds_id, name, type, description)

•	drug.txt (dr_id, name, type, description)

•	test.txt (tt_id, name, type, setting)

•	clinical_fact.txt (p_id, ds_id, sympton, ds_from, ds_to, dr_id, dosage, dr_from, dr_to, tt_id, result, tt_date, s_id)

A.2	Sample data space
Entities: sample, marker, assay, term; Fact table: sample_fact.

•	sample.txt (s_id, source, amount, sp_date)

•	marker (mk_id, name, type, locus, description)

•	assay.txt (as_id, name, type, setting, description)

•	term.txt (tm_id, name, type, setting)

•	sample_fact.txt (s_id, mk_id, mk_result, mk_date, as_id, as_result, as_date, tm_id, tm_description)

A.3	Microarray and proteomic data space
Entities: probe, measureUnit; Fact table: microarray_fact.

•	probe.txt (pb_id, UID, name, description, isQC)

•	measureUnit.txt (mu_id, name, type, description)

•	microarray_fact.txt (s_id, e_id, pb_id, mu_id, expression)
 
A.4	Gene data space
Entites: gene, go, cluster, domain, promoter; Fact table: gene_fact.

•	gene.txt (UID, seqType, accession, version, seqDataset, speciesID, status)

•	go.txt (go_id, accession, type, name, definition)

•	cluster.txt (cl_id, num, pattern, tool, tSetting, description)

•	domain.txt (dm_id, type, db, accession, title, length, description)

•	promoter.txt (pm_id, type, sequence, length, description)

•	gene_fact.txt (UID, go_id, cl_id, dm_id, pm_id, UID2)

A.5	Experiment data space
Entities: experiment, project, platform, norm, person, protocal, publication; Fact table: experi- ment_fact.
•	experiment.txt (e_id, name, type)

•	project.txt (pj_id, name, investigator, description)

•	platform.txt (pf_id, hardware, software, settings, description)

•	norm.txt (nm_id, type, software, parameters, description)

•	person.txt (pn_id, name, labName, contact)

•	protocal.txt (pt_id, name, text, createdBy)

•	publication.txt (pu_id, pub_med_id, title, authors, abstract, pubDate)

•	experiment_fact.txt (e_id, nm_id, pj_id, pn_id, pf_id, pt_id, pu_id)

