--download files to a folder, unzip the files to a folder, right click on the folder and select security, click advanced, click findnow, select everyone, give all permissions to everyone


BULK INSERT [Date]
FROM 'C:\Users\gopib\Desktop\Demo Data\date.tsv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR ='\t',
    ROWTERMINATOR='\n'
    );	

	--holiday

	BULK INSERT Holiday
FROM 'C:\Users\gopib\Desktop\Demo Data\holidays.tsv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR ='\t',
    ROWTERMINATOR='\n'
    );	

	--campaign

	BULK INSERT Campaign
FROM 'C:\Users\gopib\Desktop\Demo Data\ad_campaigns.tsv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR ='\t',
    ROWTERMINATOR='\n'
    );	


insert into State(State_Name) Values('MO');
insert into State(State_Name) Values('OH');
insert into State(State_Name) Values('RI');
insert into State(State_Name) Values('NV');
insert into State(State_Name) Values('OR');
insert into State(State_Name) Values('WV');
insert into State(State_Name) Values('CA');
insert into State(State_Name) Values('HI');
insert into State(State_Name) Values('KS');
insert into State(State_Name) Values('FL');
insert into State(State_Name) Values('MT');
insert into State(State_Name) Values('WA');
insert into State(State_Name) Values('AR');
insert into State(State_Name) Values('MN');
insert into State(State_Name) Values('TX');
insert into State(State_Name) Values('NY');
insert into State(State_Name) Values('VT');
insert into State(State_Name) Values('NC');
insert into State(State_Name) Values('WY');
insert into State(State_Name) Values('AZ');
insert into State(State_Name) Values('DE');
insert into State(State_Name) Values('GA');
insert into State(State_Name) Values('CO');
insert into State(State_Name) Values('AL');
insert into State(State_Name) Values('IA');
insert into State(State_Name) Values('MI');
insert into State(State_Name) Values('NH');
insert into State(State_Name) Values('MA');
insert into State(State_Name) Values('CT');
insert into State(State_Name) Values('IL');
insert into State(State_Name) Values('OK');
insert into State(State_Name) Values('MD');
insert into State(State_Name) Values('ID');
insert into State(State_Name) Values('IN');
insert into State(State_Name) Values('LA');
insert into State(State_Name) Values('NE');
insert into State(State_Name) Values('WI');
insert into State(State_Name) Values('KY');
insert into State(State_Name) Values('VA');
insert into State(State_Name) Values('UT');
insert into State(State_Name) Values('PA');
insert into State(State_Name) Values('SD');
insert into State(State_Name) Values('NM');
insert into State(State_Name) Values('NJ');
insert into State(State_Name) Values('MS');
insert into State(State_Name) Values('TN');
insert into State(State_Name) Values('ME');
insert into State(State_Name) Values('AK');
insert into State(State_Name) Values('SC');
insert into State(State_Name) Values('ND');


BULK INSERT City
FROM 'C:\Users\gopib\Desktop\Demo Data\cities.tsv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR ='\t',
    ROWTERMINATOR='\n'
    );	


BULK INSERT Category
FROM 'C:\Users\gopib\Desktop\Demo Data\productcategories.tsv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR ='\t',
    ROWTERMINATOR='\n'
    );	

insert into Category(Category_Name) values('Pet Furniture');

BULK INSERT Product
FROM 'C:\Users\gopib\Desktop\Demo Data\products.tsv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR ='\t',
    ROWTERMINATOR='\n'
    );	


	BULK INSERT Discount
FROM 'C:\Users\gopib\Desktop\Demo Data\discounts.tsv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR ='\t',
    ROWTERMINATOR='\n'
    );	

	

	insert into Limit(Limit_Mins) values(30),(45),(60);


		BULK INSERT Store
FROM 'C:\Users\gopib\Desktop\Demo Data\store_updated.txt'
WITH (FIRSTROW = 2,
FIELDTERMINATOR ='\t',
    ROWTERMINATOR='\n'
    );	


	
		BULK INSERT Sale
FROM 'C:\Users\gopib\Desktop\Demo Data\sales.tsv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR ='\t',
    ROWTERMINATOR='\n'
    );	
