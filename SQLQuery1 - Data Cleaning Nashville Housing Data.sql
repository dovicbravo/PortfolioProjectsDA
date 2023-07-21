/* 

Cleaning Data in SQL Queries

*/

SELECT *
FROM PortfolioProject..nahousing


-- Standardize Date Format

ALTER TABLE nahousing
Add SaleDateConverted Date;

Update nahousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

SELECT SaleDateConverted
FROM PortfolioProject..nahousing


-- Populate the Property Address Data

SELECT *
FROM PortfolioProject..nahousing
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..nahousing a
JOIN PortfolioProject..nahousing b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..nahousing a
JOIN PortfolioProject..nahousing b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null


-- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM PortfolioProject..nahousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS City
FROM PortfolioProject..nahousing


ALTER TABLE nahousing
ADD PropertySplitAddress Nvarchar(200);

Update nahousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) 

ALTER TABLE nahousing
ADD PropertySplitCity Nvarchar(200);

Update nahousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) 

SELECT *
FROM PortfolioProject..nahousing

SELECT OwnerAddress
FROM PortfolioProject..nahousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS OwnerSplitAddress, 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS OwnerSplitCity,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS OwnerSplitState
FROM PortfolioProject..nahousing

ALTER TABLE nahousing
ADD OwnerSplitAddress Nvarchar(200);

Update nahousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE nahousing
ADD OwnerSplitCity Nvarchar(200);

Update nahousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE nahousing
ADD OwnerSplitState Nvarchar(200);

Update nahousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT *
FROM PortfolioProject..nahousing


-- Changing Y and N into Yes and No in "Sold as Vacant" Column

SELECT DISTINCT SoldAsVacant, COUNT(SoldAsVacant)
FROM PortfolioProject..nahousing
GROUP BY SoldAsVacant
ORDER BY COUNT(SoldAsVacant)

SELECT SoldAsVacant,
	CASE
		WHEN SoldAsVacant = 'Y'
			THEN 'Yes'
		WHEN SoldAsVacant = 'N'
			THEN 'No'
		ELSE SoldAsVacant
		END 
FROM PortfolioProject..nahousing

Update nahousing
SET SoldAsVacant = CASE
		WHEN SoldAsVacant = 'Y'
			THEN 'Yes'
		WHEN SoldAsVacant = 'N'
			THEN 'No'
		ELSE SoldAsVacant
		END


-- Removing Duplicates

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID
				 ) row_num
FROM PortfolioProject..nahousing
)
DELETE
FROM RowNumCTE
Where row_num > 1


-- Deleting Unused/Duplicated Columns

SELECT *
FROM PortfolioProject..nahousing

ALTER TABLE PortfolioProject..nahousing
DROP COLUMN TaxDistrict, OwnerAddress, PropertyAddress

ALTER TABLE PortfolioProject..nahousing
DROP COLUMN SaleDate

