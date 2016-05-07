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
-- Procedure to add a new product

-- Drop procedure if it already exists
IF OBJECT_ID ( 'dbo.AddNewProduct', N'P' ) IS NOT NULL 
    DROP PROCEDURE dbo.AddNewProduct;
GO

CREATE PROCEDURE dbo.AddNewProduct
	-- Add the parameters for the stored procedure here
	@product_name nvarchar(40),
	@product_desc nvarchar(100),
	@product_platform varchar(10),
	@version_num varchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Check if the specified product name/platform pair alread exists
	IF(SELECT product_id FROM Product WHERE product_name=@product_name AND product_platform=@product_platform) IS NOT NULL
		Print 'Specified product already exists.'
	ELSE
	BEGIN
		-- Insert the provided values into dbo.Product and dbo.ProductVersion
		INSERT INTO dbo.Product VALUES(@product_name, @product_desc, @product_platform, @version_num)
		DECLARE @product_id int;
		SET @product_id = SCOPE_IDENTITY();
		INSERT INTO dbo.ProductVersion VALUES(@product_id, @version_num)
	END
END
GO