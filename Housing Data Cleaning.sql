



--Cleaning Data using SQL Queries

Select * From SQL_PROJECT..[NashvilleHousing ]



-- Duplicating out PropertyAddress Column if parcelID Matches

Select a.ParcelID,a.PropertyAddress,b.PropertyAddress From SQL_PROJECT..[NashvilleHousing ] a
join SQL_PROJECT..[NashvilleHousing ] b on 
a.ParcelID =b.ParcelID and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

update a
set propertyAddress =ISNULL(a.propertyAddress,b.propertyAddress)
From SQL_PROJECT..[NashvilleHousing ] a
join SQL_PROJECT..[NashvilleHousing ] b on 
a.ParcelID =b.ParcelID and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null




-- Breaking out Property Address Column into 2 Columns(Address,City)

Select PropertyAddress from SQL_PROJECT..[NashvilleHousing ]

Select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',propertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',propertyAddress)-1,len(propertyAddress)) as City
from SQL_PROJECT..[NashvilleHousing ]

Alter TABLE SQL_PROJECT..NashvilleHousing 
Add PropertySplitAddress NvarChar(255)
Update SQL_PROJECT..NashvilleHousing
Set PropertySplitAddress =SUBSTRING(PropertyAddress,1,CHARINDEX(',',propertyAddress)-1)

Alter TABLE SQL_PROJECT..NashvilleHousing 
Add PropertySplitCity NvarChar(255)
Update SQL_PROJECT..NashvilleHousing
Set PropertySplitCity =SUBSTRING(PropertyAddress,CHARINDEX(',',propertyAddress)+1,len(PropertyAddress))

SELECT * FROM SQL_PROJECT..[NashvilleHousing ] 



-- now Lets Do the Same With OwnerAddress

select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from SQL_PROJECT..[NashvilleHousing ]

Alter TABLE SQL_PROJECT..NashvilleHousing 
Add OwnerSplitAddress NvarChar(255)
Update SQL_PROJECT..NashvilleHousing
Set OwnerSplitAddress =PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Alter TABLE SQL_PROJECT..NashvilleHousing 
Add OwnerSplitCity NvarChar(255)
Update SQL_PROJECT..NashvilleHousing
Set OwnerSplitCity =PARSENAME(REPLACE(OwnerAddress,',','.'),2)

Alter TABLE SQL_PROJECT..NashvilleHousing 
Add OwnerSplitState NvarChar(255)
Update SQL_PROJECT..NashvilleHousing
Set OwnerSplitState =PARSENAME(REPLACE(OwnerAddress,',','.'),1)

SELECT * FROM SQL_PROJECT..[NashvilleHousing ] 



--Viewing 'Sold as vacant' and Mapping 1-> Yes and 0-> No

select distinct(SoldAsVacant),Count(SoldAsVacant)
from SQL_PROJECT..[NashvilleHousing ]
Group by SoldAsVacant

select SoldAsVacant
,Case when SoldAsVacant=1 THEN 'Yes'
	else 'No'
	END
from SQL_PROJECT..[NashvilleHousing ]

Update SQL_PROJECT..[NashvilleHousing ]
SET SoldAsVacant =Case when SoldAsVacant=1 THEN 'Yes'
	else 'No'
	END
from SQL_PROJECT..[NashvilleHousing ]


-- Deleting Unused Columns 

select * 
from SQL_PROJECT..[NashvilleHousing ]

alter table SQL_PROJECT..[NashvilleHousing ]
drop column TaxDistrict,PropertyAddress,OwnerAddress