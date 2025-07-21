drop table if exists Books;
create table Books(
		Book_ID int primary key,
		Title varchar(100),
		Author varchar(100),
		Genre varchar(100),
		Published_Year int,
		Price decimal(10,2),
		Stock int 
);

select * from Books;

drop table if exists Customers;
create table Customers(
		Customer_ID serial primary key,
		Name varchar(100),
		Email varchar(100),
		Phone varchar(100),
		City varchar(100),
		Country varchar(200) 
);

select * from Customers;


drop table if exists Orders;
create table Orders(
		Order_ID serial primary key,
		Customer_ID INT REFERENCES Customers(Customer_ID),
		Book_ID INT REFERENCES Books(Book_ID) ,
		Order_Date date,
		Quantity int,
		Total_Amount numeric(10,2)
);
select * from Orders;


select * from Books;
select * from Customers;
select * from Orders;


--Q Retireve all the books in the "fiction" genre
select Title ,Genre from Books
Where Genre = 'Fiction';

--Q Find books published after the year 1950
select Title ,Published_Year from Books
Where Published_Year > '1950';

--Q list all the customer from canada 
select name, Country from Customers
where Country ='canada';

--Q show order placed in november 2023
select * from Orders
where Date_trunc('month', Order_Date)='2023-11-01' ;

--Q Retrive the total stock of books available 
select sum(Stock)
from Books;

--Q Find the detail of the most expensive book
select *from Books order by price asc limit 1;

--Q show all customers who order more than one quantity of a book
select * FROM Orders
where Quantity>=1;

--Q retrive all order where the total amount exceeds $20
select * FROM Orders
where Total_Amount>=20;

--Q List all gener available in the books table
select distinct Genre from Books;

--Q find the book with lowest stock
select * FROM Books order by stock desc;

--Q calculate total revenue genrated from the orders
select sum(Total_Amount)
from Orders;


--General Practice question 

--1 Show all records from the Customers table.
Select * from  Customers;

--2. Display name and email of all customers.
Select Name,Email from Customers;

--3. Show all books priced more than ₹300.
Select * from Books
where Price>='300';

--4. List orders where quantity is more than 2.
Select * from Orders
where Quantity>='2';

--5. Show books published after the year 2018.
Select * from Books
where Title>='2018';

--6. Find books with stock between 5 and 20.
Select * from Books
where stock between 5 and 20;

--7. List customers who are from 'India'.
Select * from  Customers
Where Country = 'India';

--8. Display books with genre = 'Fiction' or 'Romance'.
Select * from Books
where Genre ='Fiction ,Romance' ;


--📌 Operators

--9. Show books where title starts with 'A'. 
Select * from Books
where Title like '@A';

--10. Find customers whose name contains 'an'. 
Select*from Customers
where Name like '%an';

--11. Show orders placed between '2023-10-01' and '2023-12-31'.
Select*from Orders
where Order_Date between '2023-10-01' and '2023-12-31';

--12. Show books with price not equal to 500.
Select * from Books
where Price != 500;

--13. Find customers from 'India', 'Nepal', or 'USA'. 
Select*from Customers
where Country = 'India,Nepal,USA';

--📌 Functions

--14. Count total number of customers.
Select count(Customer_Id) from Customers AS total_count;

--15. Show average book price.
Select Avg(Price)from Books;

--16. Show maximum and minimum book price.
Select max(Price),
		min(Price)from Books;

--17. Display total quantity ordered.
Select sum(Quantity)from Orders;

--18. Get total number of orders placed in 2023.
Select sum(Quantity)from Orders
where Date_trunc('Month',Order_Date)= '2023-11-01';

--19. Show total order amount per customer.
Select sum(Total_Amount)from Orders;

--20. Extract month and year from Order_Date
Select extract(Year from Order_Date) as year,
		extract (Month from Order_Date)as month
		From Orders;


---

📌 String Functions

--21. Show all customer names in UPPERCASE.
Select UPPER(Name) from Customers;

--22. Display book titles in lowercase.
Select lower(Title) from Books;

--23. Show length of each customer’s name.
Select length(Name) from Customers;


--📌 Joins (for Relationships)

--24. Show order details along with customer name.
Select c.Name,c.Email,c.Phone,c.City,c.Country,o.Order_Date,o.Quantity,o.Total_Amount
From Customers c
Inner join
Orders o
on c.Customer_Id=o.Order_ID;


--📌 Sorting and Limiting

--28. Show top 5 most expensive books.
Select * from Books
Order by Price Asc
limit 5 ;


--29. List customers alphabetically by name.
Select * from Customers
Order by Name Asc;

--30. Show last 3 orders placed (by date).
Select * from Books
Order by Price desc
limit 3;


--Advanced Question

select * from Books;
select * from Customers;
select * from Orders;

--1. Retive the total no. of books sold in each genre

Select b.Genre, Sum(o.Quantity) as Total_book_sold
from Orders o
Join 
Books b
on o.Book_ID=b.Book_ID
Group by b.Genre;


--2. Find the average price of books in the 'Fantasy'genre

Select avg(Price) from Books
where Genre = 'Fantasy';

--3. List customers who have placed atleast 2 Order
Select o.Customer_ID,count(Order_ID) as Order_detail
from Customers c
Join 
Orders o
on o.Customer_ID=c.Customer_ID
Group by o.Customer_ID
having count(Order_ID) >= 2;

--4. Find the most frequently ordered books
Select o.Book_ID ,b.Title , count(Order_ID) as Order_count
From Orders o
join
Books b
on o.Book_ID = b.Book_ID
Group by o.Book_ID , b.Title 
Order by Order_count DESC Limit 1 ;

--5. show the top 3 most expensive books of fantasy genre 
select Title,Author
from Books 
where Genre = 'fantasy'
Order by price asc
limit 3 ; 


--6. Retrive the total quantity of books sold by each author
select b.Title , b.Author , Sum(o.Quantity) as Order_count 
from Books b
join 
Orders o 
on o.Book_ID = b.Book_ID
Group by b.Author, b.Title;


--7. list the cites where customers who spent over rs 30 are located 
select Distinct c.City , Total_Amount
From Orders o 
Join Customers c 
on o.Customer_ID = c.Customer_ID 
where o.Total_Amount > 30;

--8. Find the customer who spent the most on orders
Select c.Name, o.Customer_ID,sum(o.Total_Amount) as Customer_detail
from Customers c
Join 
Orders o
on o.Customer_ID=c.Customer_ID
Group by o.Customer_ID ,c.Name
order by Customer_detail DESc
limit 1;

--9. Calculate the stock remaining after fullflling all order
select b.Book_ID, b.Title, b.Stock,coalesce(sum(Quantity),0)  as Order_Quantity,
b.Stock - Coalesce (Sum(o.Quantity),0) as Remaining_Quantity
from Books b
Left join 
Orders o 
on b.Book_ID = o.Book_ID
Group by b.Book_ID
order by Book_ID;





