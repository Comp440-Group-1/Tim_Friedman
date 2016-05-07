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
-- Drop procedure if it already exists
IF OBJECT_ID ( 'dbo.UpdateProduct', N'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.UpdateProduct;
GO

CREATE PROCEDURE [dbo].[UpdateProduct]
	-- Add the parameters for the stored procedure here
	@product_name nvarchar(40),
	@product_platform varchar(10),
	@version_num varchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @product_id int;

	-- Check that the specified product name/platform pair exists
	IF(SELECT product_id FROM Product WHERE product_name=@product_name AND product_platform=@product_platform) IS NULL
		PRINT 'Specified product does not exist.'
	ELSE
	BEGIN
		-- Update the latest_version column in Product and insert a new row into ProductVersion
		UPDATE Product
		SET latest_version=@version_num
		WHERE product_name=@product_name AND product_platform=@product_platform
		SET @product_id=(SELECT product_id FROM Product WHERE product_name=@product_name AND product_platform=@product_platform)
		INSERT INTO ProductVersion VALUES(@product_id, @version_num)
	END
END
GO