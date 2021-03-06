
/****** Object:  StoredProcedure [dbo].[createAllTables]    Script Date: 5/2/2016 9:01:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- Procedure to create all tables

-- Drop procedure if it already exists
IF OBJECT_ID ( 'CreateTables', 'P' ) IS NOT NULL 
	DROP PROCEDURE CreateTables;
GO

CREATE PROCEDURE CreateTables 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Drop tables if they already exist

	IF OBJECT_ID ( 'ProductLinks', 'U' ) IS NOT NULL 
		DROP TABLE ProductLinks;

	IF OBJECT_ID ( 'Release', 'U' ) IS NOT NULL 
		DROP TABLE Release;

	IF OBJECT_ID ( 'Iteration', 'U' ) IS NOT NULL 
		DROP TABLE Iteration;

	IF OBJECT_ID ( 'Download', 'U' ) IS NOT NULL 
		DROP TABLE Download;

	IF OBJECT_ID ( 'Phone', 'U' ) IS NOT NULL 
		DROP TABLE Phone;

	IF OBJECT_ID ( 'CustomerByCompany', 'U' ) IS NOT NULL
		DROP TABLE CustomerByCompany;

	IF OBJECT_ID ( 'Customer', 'U' ) IS NOT NULL 
		DROP TABLE Customer;

	IF OBJECT_ID ( 'CompanyAddress', 'U' ) IS NOT NULL 
		DROP TABLE CompanyAddress;

	IF OBJECT_ID ( 'Company', 'U' ) IS NOT NULL 
		DROP TABLE Company;

	IF OBJECT_ID ( 'FeatureByVersion', 'U' ) IS NOT NULL 
		DROP TABLE FeatureByVersion;

	IF OBJECT_ID ( 'ProductVersion', 'U' ) IS NOT NULL 
		DROP TABLE ProductVersion;

	IF OBJECT_ID ( 'Feature', 'U' ) IS NOT NULL 
		DROP TABLE Feature;

	IF OBJECT_ID ( 'Product', 'U' ) IS NOT NULL 
		DROP TABLE Product;

	-- Create all tables

	CREATE TABLE Product (product_id int IDENTITY(1, 1) PRIMARY KEY, product_name nvarchar(40) NOT NULL, product_desc nvarchar(100) NOT NULL, product_platform varchar(10) NOT NULL, latest_version varchar(10) NOT NULL)

	CREATE TABLE ProductVersion (version_id int IDENTITY(1, 1) PRIMARY KEY, product_id int NOT NULL, version_num varchar(10) NOT NULL
	CONSTRAINT FK_product_version FOREIGN KEY (product_id) REFERENCES Product (product_id))

	CREATE TABLE ProductLinks (product_id int NOT NULL, download_link varchar(200) NOT NULL, support_link varchar(200) NOT NULL
	CONSTRAINT FK_product_links FOREIGN KEY (product_id) REFERENCES Product (product_id))

	CREATE TABLE Feature (feature_id int IDENTITY(1, 1) PRIMARY KEY, feature_name nvarchar(40) NOT NULL, feature_desc nvarchar(100) NOT NULL)

	CREATE TABLE FeatureByVersion (version_id int NOT NULL, feature_id int NOT NULL
	CONSTRAINT FK_feature_id_featurebyversion FOREIGN KEY (feature_id) REFERENCES Feature (feature_id),
	CONSTRAINT FK_version_id_featurebyversion FOREIGN KEY (version_id) REFERENCES ProductVersion (version_id))

	CREATE TABLE Release (product_id int NOT NULL, release_num varchar(10) NOT NULL, release_desc nvarchar(500) NOT NULL, release_date date NOT NULL
	CONSTRAINT FK_release_product_id FOREIGN KEY (product_id) REFERENCES Product (product_id))

	CREATE TABLE Iteration (product_id int NOT NULL, change_desc nvarchar(200) NOT NULL, repo_link varchar(200) NOT NULL, itr_date date NOT NULL, itr_platform nvarchar(20) NOT NULL
	CONSTRAINT FK_iteration_product_id FOREIGN KEY (product_id) REFERENCES Product (product_id))

	CREATE TABLE Customer (cust_id int IDENTITY(1, 1) PRIMARY KEY, last_name nvarchar(50) NOT NULL, first_name nvarchar(25) NOT NULL, cust_email nvarchar(40) NOT NULL)

	CREATE TABLE Company (company_id int IDENTITY(1, 1) PRIMARY KEY, company_name nvarchar(50) NOT NULL)

	CREATE TABLE Download (cust_id int NOT NULL, company_id int NOT NULL, product_id int NOT NULL, version_id int NOT NULL, dl_time date NOT NULL
	CONSTRAINT FK_download_cust_id FOREIGN KEY (cust_id) REFERENCES Customer (cust_id),
	CONSTRAINT FK_download_company_id FOREIGN KEY (company_id) REFERENCES Company (company_id),
	CONSTRAINT FK_download_product_id FOREIGN KEY (product_id) REFERENCES Product (product_id),
	CONSTRAINT FK_download_version_id FOREIGN KEY (version_id) REFERENCES ProductVersion (version_id))

	CREATE TABLE CompanyAddress (company_id int NOT NULL, addr_first_line nvarchar(30) NOT NULL, addr_second_line nvarchar(30), addr_third_line nvarchar(30), city nvarchar(50) NOT NULL, region nvarchar(50), country nvarchar(50) NOT NULL, zip_code nvarchar(12) NOT NULL
	CONSTRAINT FK_company_addr FOREIGN KEY (company_id) REFERENCES Company (company_id))

	CREATE TABLE Phone (cust_id int NOT NULL, phone_num varchar(15) NOT NULL, phone_ext varchar(10), phone_type nvarchar(10) NOT NULL
	CONSTRAINT FK_cust_phone FOREIGN KEY (cust_id) REFERENCES Customer (cust_id))

	CREATE TABLE CustomerByCompany (cust_id int NOT NULL, company_id int NOT NULL
	CONSTRAINT FK_cust_id FOREIGN KEY (cust_id) REFERENCES Customer (cust_id),
	CONSTRAINT FK_company_id FOREIGN KEY (company_id) REFERENCES Company(company_id));

END
GO

IF OBJECT_ID ( 'PopulateTables', 'P' ) IS NOT NULL 
	DROP PROCEDURE PopulateTables;
GO

CREATE PROCEDURE PopulateTables
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXEC AddNewProduct 'EHR system', 'health records system for the patients', 'Windows', '1.1';
	EXEC AddNewProduct 'EHR system', 'health records system for the patients', 'Linux', '1.2';

	INSERT INTO dbo.ProductLinks VALUES
	((SELECT product_id FROM dbo.Product WHERE product_name='EHR system' AND product_platform='Windows'),
	'www.foocorp.com/dl/ehr_windows',
	'www.foocorp.com/support/ehr_windows'),
	((SELECT product_id FROM dbo.Product WHERE product_name='EHR system' AND product_platform='Linux'),
	'www.foocorp.com/dl/ehr_linux',
	'www.foocorp.com/support/ehr_linux')

	INSERT INTO dbo.Company VALUES
	('ABC records'),
	('ZYX Corp'),
	('99 store')

	INSERT INTO dbo.Customer VALUES
	('Smith', 'Peter', 'p.smith@abc.com'),
	('Bounte', 'Maria', 'maria@zyx.com'),
	('Sommerset', 'David', 'david.sommerset@99cents.store'),
	('Bounte', 'Maria', 'maria.bounte@99cents.store')

	INSERT INTO dbo.CustomerByCompany VALUES
	(1, 1), (2, 2), (3, 3), (4, 3)

	

	INSERT INTO dbo.Phone VALUES
	(1, '123-485-8973', NULL, 'work'),
	(2, '1-28-397863896', NULL, 'work'),
	(3, '179-397-87968', NULL, 'mobile'),
	(4, '178-763-98764', NULL, 'mobile')

	INSERT INTO dbo.CompanyAddress VALUES
	((SELECT company_id FROM dbo.Company WHERE company_name='ABC records'), '123 Privet Street', NULL, NULL, 'Los Angeles', 'CA', 'United States', '91601'),
	((SELECT company_id FROM dbo.Company WHERE company_name='ZYX Corp'), '348 Jinx Road', NULL, NULL, 'London', NULL, 'England', '18232')

	INSERT INTO dbo.Release VALUES
	((SELECT product_id FROM dbo.Product WHERE product_name='EHR system' AND product_platform='Windows'), '1.1', 'First release of the EHR system for Windows', '2000-1-1'),
	((SELECT product_id FROM dbo.Product WHERE product_name='EHR system' AND product_platform='Linux'), '1.1', 'First release of the EHR system for Linux', '2000-1-1')

	EXEC AddNewFeature 'EHR system', 'Windows', '1.1', 'login module', 'allows user login';
	EXEC AddNewFeature 'EHR system', 'Windows', '1.1', 'patient registration', 'allows registering a new patient';
	EXEC AddNewFeature 'EHR system', 'Windows', '1.1', 'patient profile', 'stores patient information';
	EXEC AddNewFeature 'EHR system', 'Windows', '1.1', 'patient release form', 'form for discharging patients';
	EXEC AddNewFeature 'EHR system', 'Windows', '1.1', 'physician profile', 'stores physician information';
	EXEC AddNewFeature 'EHR system', 'Windows', '1.1', 'address verification', 'verifies patient address';

	EXEC AddNewFeature 'EHR system', 'Linux', '1.2', 'login module', 'allows user login';
	EXEC AddNewFeature 'EHR system', 'Linux', '1.2', 'patient registration', 'allows registering a new patient';
	EXEC AddNewFeature 'EHR system', 'Linux', '1.2', 'patient profile', 'stores patient information';
	EXEC AddNewFeature 'EHR system', 'Linux', '1.2', 'patient release form', 'form for discharging patients';
	EXEC AddNewFeature 'EHR system', 'Linux', '1.2', 'physician profile', 'stores physician information';
	EXEC AddNewFeature 'EHR system', 'Linux', '1.2', 'address verification', 'verifies patient address';

	EXEC UpdateProduct 'EHR system', 'Windows', '2.1'
	EXEC UpdateProduct 'EHR system', 'Linux', '2.2'

	INSERT INTO dbo.Release VALUES
	((SELECT product_id FROM dbo.Product WHERE product_name='EHR system' AND product_platform='Windows'), '2.1', 'New features of the EHR system for Windows', '2000-5-1'),
	((SELECT product_id FROM dbo.Product WHERE product_name='EHR system' AND product_platform='Linux'), '2.1', 'New features of the EHR system for Linux', '2000-5-1')

	INSERT INTO dbo.Release VALUES
	((SELECT product_id FROM dbo.Product WHERE product_name='EHR system' AND product_platform='Linux'), '2.2', 'Bug fixes for the EHR system for Linux', '2000-6-13')

	EXEC AddNewFeature 'EHR system', 'Windows', '2.1', 'login module', 'allows user login';
	EXEC AddNewFeature 'EHR system', 'Windows', '2.1', 'patient registration', 'allows registering a new patient';
	EXEC AddNewFeature 'EHR system', 'Windows', '2.1', 'patient profile', 'stores patient information';
	EXEC AddNewFeature 'EHR system', 'Windows', '2.1', 'patient release form', 'form for discharging patients';
	EXEC AddNewFeature 'EHR system', 'Windows', '2.1', 'physician profile', 'stores physician information';
	EXEC AddNewFeature 'EHR system', 'Windows', '2.1', 'address verification', 'verifies patient address';

	EXEC AddNewFeature 'EHR system', 'Linux', '2.2', 'login module', 'allows user login';
	EXEC AddNewFeature 'EHR system', 'Linux', '2.2', 'patient registration', 'allows registering a new patient';
	EXEC AddNewFeature 'EHR system', 'Linux', '2.2', 'patient profile', 'stores patient information';
	EXEC AddNewFeature 'EHR system', 'Linux', '2.2', 'patient release form', 'form for discharging patients';
	EXEC AddNewFeature 'EHR system', 'Linux', '2.2', 'physician profile', 'stores physician information';
	EXEC AddNewFeature 'EHR system', 'Linux', '2.2', 'address verification', 'verifies patient address';

	EXEC AddNewFeature 'EHR system', 'Windows', '2.1', 'patient authentication', 'allows authentication of patient credentials';
	EXEC AddNewFeature 'EHR system', 'Windows', '2.1', 'patient medication form', 'allows online medication paperwork';
	EXEC AddNewFeature 'EHR system', 'Windows', '2.1', 'patient e-bill', 'allows online patient billing';
	EXEC AddNewFeature 'EHR system', 'Windows', '2.1', 'patient reporting', 'form for reporting patients';

	EXEC AddNewFeature 'EHR system', 'Linux', '2.2', 'patient authentication', 'allows authentication of patient credentials';
	EXEC AddNewFeature 'EHR system', 'Linux', '2.2', 'patient medication form', 'allows online medication paperwork';
	EXEC AddNewFeature 'EHR system', 'Linux', '2.2', 'patient e-bill', 'allows online patient billing';
	EXEC AddNewFeature 'EHR system', 'Linux', '2.2', 'patient reporting', 'form for reporting patients';

	INSERT INTO dbo.Iteration VALUES
	((SELECT product_id FROM dbo.Product WHERE product_name='EHR system' AND product_platform='Windows'), 'Created framework for EHR for Windows', 'www.foocorp.com/dev/ehr_windows_dev_branch', '1999-10-10', 'Windows'),
	((SELECT product_id FROM dbo.Product WHERE product_name='EHR system' AND product_platform='Linux'), 'Created framework for EHR for Linux', 'www.foocorp.com/dev/ehr_linux_dev_branch', '1999-10-10', 'Linux')

	INSERT INTO dbo.Iteration VALUES
	((SELECT product_id FROM dbo.Product WHERE product_name='EHR system' AND product_platform='Windows'), 'Added new features to EHR for Windows', 'www.foocorp.com/dev/ehr_windows_dev_branch', '2000-4-4', 'Windows'),
	((SELECT product_id FROM dbo.Product WHERE product_name='EHR system' AND product_platform='Linux'), 'Added new features to for EHR for Linux', 'www.foocorp.com/dev/ehr_linux_dev_branch', '2000-4-4', 'Linux')

	INSERT INTO dbo.Download VALUES
	(1, 1, 1, 3, '2000-6-1'),
	(2, 2, 1, 3, '2000-3-1'),
	(3, 3, 2, 4, '2000-7-1'),
	(4, 3, 2, 4, '2000-9-1')
END
GO

EXEC CreateTables;
EXEC PopulateTables;