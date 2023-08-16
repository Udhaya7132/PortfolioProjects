select * from PortfolioProject..HousingData

-- Standardize Date Format

select SaleDate, CONVERT(date,saledate)
from PortfolioProject..HousingData

update PortfolioProject..HousingData
set saledate=CONVERT(date,saledate) --it doesn't Update properly

alter table PortfolioProject..HousingData
add SaleDateConverted Date

select * from PortfolioProject..HousingData

update PortfolioProject..HousingData
set SaleDateConverted = CONVERT(date,SaleDate)

--------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select * from
PortfolioProject..HousingData
order by ParcelID


Select * from
PortfolioProject..HousingData
order by [UniqueID ]


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..HousingData a
JOIN PortfolioProject..HousingData b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..HousingData a
join PortfolioProject..HousingData b
on a.ParcelID = b.parcelId
and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)

select * from PortfolioProject..HousingData
where PropertyAddress is null


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
From PortfolioProject..HousingData

alter table PortfolioProject..HousingData
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProject..HousingData
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE PortfolioProject..HousingData
Add PropertySplitCity Nvarchar(255);

Update PortfolioProject..HousingData
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

select * from PortfolioProject..HousingData

select OwnerAddress
from PortfolioProject..HousingData

select 
PARSENAME(replace(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
from PortfolioProject..HousingData

ALTER TABLE PortfolioProject..HousingData
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProject..HousingData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE PortfolioProject..HousingData
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProject..HousingData
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE PortfolioProject..HousingData
Add OwnerSplitState Nvarchar(255);

Update PortfolioProject..HousingData
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From PortfolioProject..HousingData


--Change Y and N to Yes and No in "Sold as Vacant" field

select Distinct(SoldAsVacant)
from PortfolioProject..HousingData

select Distinct(SoldAsVacant),COUNT(soldAsVacant)
from PortfolioProject..HousingData
group by SoldAsVacant
order by 2 asc


Select SoldAsVacant,
case when SoldAsVacant ='Y' then 'Yes'
when SoldAsVacant ='N' then 'No'
else SoldAsVacant end
from PortfolioProject..HousingData

update PortfolioProject..HousingData
set SoldAsVacant = case when SoldAsVacant ='Y' then 'Yes'
when SoldAsVacant ='N' then 'No'
else SoldAsVacant end


select Distinct(SoldAsVacant),COUNT(soldAsVacant)
from PortfolioProject..HousingData
group by SoldAsVacant
order by 2 asc


-- Remove Duplicates

with RowNumCTE as (
select *, ROW_NUMBER() over( Partition by ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference
ORDER BY UniqueID) row_num
from PortfolioProject..HousingData)
select * from RowNumCTE
where row_num > 1
order by PropertyAddress


with RowNumCTE as (
select *, ROW_NUMBER() over( Partition by ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference
ORDER BY UniqueID) row_num
from PortfolioProject..HousingData)
delete  from RowNumCTE
where row_num > 1


with RowNumCTE as (
select *, ROW_NUMBER() over( Partition by ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference
ORDER BY UniqueID) row_num
from PortfolioProject..HousingData)
select * from RowNumCTE
where row_num > 1
order by PropertyAddress


select *
from PortfolioProject..HousingData


-- Delete unwanted column 


select * from PortfolioProject..HousingData


alter table
PortfolioProject..HousingData
drop column PropertyAddress,SaleDate,OwnerAddress, TaxDistrict