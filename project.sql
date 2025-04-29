
--------------------------------
select ProductID,Name,StockQuantity from Products where ProductID in (1,2,7)

with Productsold as (
select p.ProductID,s.ShippingStatus,sum(od.Quantity) as 'total sold' 
from Products p inner join OrderDetails od on p.ProductID=od.ProductID 
inner join Orders o on o.OrderID=od.OrderID inner join Shipments s on s.OrderID = o.OrderID
where s.ShippingStatus  not like '%Shipped%'
group by p.ProductID,s.ShippingStatus
)
update p 
set p.StockQuantity = p.StockQuantity + ps.[total sold] 
from Products p inner join Productsold ps on p.ProductID = ps.ProductID

select ProductID,Name,StockQuantity from Products where ProductID in (1,2,7)


--------------------------------

begin
	
	
	Declare @Discout float;
	select @Discout= d.DiscountValue from Discounts d where d.DiscountCode like '%SUMMER%' 
	select p.ProductID,p.Name,p.Price,(p.Price*(1-@Discout/100)) as 'gia sau khi giam' from Products p
	end