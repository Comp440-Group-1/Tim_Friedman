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
IF OBJECT_ID ('AddNewFeature', 'P') IS NOT NULL
	DROP PROCEDURE dbo.AddNewFeature;
GO

CREATE PROCEDURE [dbo].[AddNewFeature]
	-- Add the parameters for the stored procedure here
	@product_name nvarchar(40),
	@product_platform varchar(10),
	@version_num varchar(10),
	@feature_name nvarchar(40),
	@feature_desc nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @product_id int; DECLARE @feature_id int; DECLARE @version_id int;
	SET @product_id = (SELECT product_id FROM dbo.Product WHERE product_name = @product_name AND product_platform = @product_platform);
	IF(SELECT feature_id FROM Feature WHERE feature_name=@feature_name) IS NULL
		BEGIN
			INSERT INTO dbo.Feature VALUES(@feature_name, @feature_desc);
			SET @feature_id=SCOPE_IDENTITY();
		END
	ELSE
		BEGIN
			SET @feature_id = (SELECT feature_id FROM dbo.Feature WHERE feature_name=@feature_name)
		END
	SET @version_id = (SELECT version_id FROM dbo.ProductVersion WHERE product_id = @product_id AND version_num = @version_num);
	INSERT INTO dbo.FeatureByVersion VALUES(@version_id, @feature_id);
END
