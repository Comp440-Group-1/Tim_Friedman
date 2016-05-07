
-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Verify that the stored procedure does not exist.
IF OBJECT_ID ( 'dbo.GetNewFeatures', N'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.GetNewFeatures;
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE dbo.GetNewFeatures
	@product_name nvarchar(40),
	@product_platform varchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Get the latest version of the product
	DECLARE @latest_version varchar(10)
	SET @latest_version=(SELECT latest_version FROM dbo.Product WHERE @product_name=product_name AND @product_platform=product_platform)

	-- Create temporary tables for features in the latest version and in previous versions
	CREATE TABLE dbo.TempNewFeatures(product_name nvarchar(40), version_num varchar(10), feature_id int, feature_name nvarchar(40), feature_desc nvarchar(100))
	CREATE TABLE dbo.TempOldFeatures(product_name nvarchar(40), version_num varchar(10), feature_id int, feature_name nvarchar(40), feature_desc nvarchar(100))
	-- Populate temporary tables with features that are present in the latest version and in previous versions
	INSERT INTO dbo.TempNewFeatures
			SELECT a.product_name, b.version_num, d.feature_id, d.feature_name, d.feature_desc FROM dbo.Product as a INNER JOIN dbo.ProductVersion as b
			ON a.product_id=b.product_id INNER JOIN dbo.FeatureByVersion as c
			ON b.version_id=c.version_id INNER JOIN dbo.Feature as d
			ON c.feature_id=d.feature_id
			WHERE a.product_name=@product_name AND b.version_num=@latest_version AND a.product_platform=@product_platform
	INSERT INTO dbo.TempOldFeatures
			SELECT a.product_name, b.version_num, d.feature_id, d.feature_name, d.feature_desc FROM dbo.Product as a INNER JOIN dbo.ProductVersion as b
			ON a.product_id=b.product_id INNER JOIN dbo.FeatureByVersion as c
			ON b.version_id=c.version_id INNER JOIN dbo.Feature as d
			ON c.feature_id=d.feature_id
			WHERE a.product_name=@product_name AND b.version_num!=@latest_version AND a.product_platform=@product_platform

	-- Get the number of features in the new features table that are not in the old features table
	DECLARE @numFeatures int =(SELECT COUNT(*) FROM TempNewFeatures) - (SELECT COUNT(*) FROM TempOldFeatures)
	IF 0=@numFeatures
	PRINT 'No new features - this is a bux-fix release.'
	ELSE
	PRINT 'There are ' + CAST(@numFeatures AS VARCHAR) + ' new features in the ' + @latest_version + ' release.';
	-- Drop the temporary tables
	DROP TABLE dbo.TempNewFeatures
	DROP TABLE dbo.TempOldFeatures
END
GO
