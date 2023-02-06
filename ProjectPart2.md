PART - 2

Use your database built for Part 1 to answer the following questions.

1.1	Part I 
Calculate summary statistics for subject and control patients.
1.	For probes belonging to GO with a given id value, write a stored procedure or function, named AvgDifference(id), to calculate the difference between the average of the expres- sion values of patients with “ALL” and the average of expression values of patients without “ALL”. For instance, AvgDifference(“0012502”) is to calculate the difference between the average of the expression values of patients with “ALL” and the average of expression values of patients without “ALL”.
2.	For probes belonging to GO with a given id value, write a stored procedure or function, named GeneStatistics(id, diseaseName), to calculate the number of distinct expression values, average of the expression values, and the summation of the expression values among patients with a given disease. For instance, AvgCalculation(“0007154”, “ALL”, Count, Avg, Sum) calculates the number, average, and summation of the expression values among patients with “ALL”, and save the results into count, avg, and sum respec- tively.

1.2	Part II :
Calculate whether gene is "informative" of a disease, or not.
Given a specific disease and a given gene, tell whether the gene is one informative gene for the disease. You can write a stored procedure or function in MySQL workbench, OR you can use MySQL to query and use other software like Python to calculate the t-statistic.
The steps to tell whether a gene is informative to disease is listed as follows. For example, suppose we are interested in the cancer “ALL”.
1.	Find all the patients with “ALL” (i.e., Group A), while the other patients serve as the control group (i.e., Group B).
2.	For the gene, calculate the t-statistics for the expression values between Group A and Group B.
3.	If the p-value of the t-test is smaller than 0.01, this gene is regarded as an “informative” gene.

1.3	Part III: Bonus Question :
Identify all the informative genes and use informative genes to classify a new patient. There are five test cases in test_samples.txt are given in the data.
For example, given a new patient PN , we want to predict whether he/she has “ALL”.
1.	Find the informative genes with respect to “ALL”
2.	Find all the patients with “ALL” (i.e., Group A)
3.	For each patient PA in Group A, calculate the correlation rA of the expression values of the informative genes between PN and PA
4.	Patients without “ALL” serves as the control group (i.e., Group B)
5.	For each patient PB in Group B, calculate the correlation rB of the expression values of the informative genes between PN and PB
6.	Apply t-test on rA and rB, if the p-value is smaller than 0.01, the patient is classified as “ALL”
