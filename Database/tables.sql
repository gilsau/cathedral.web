use cathedral
go

print '--------------------------------------------------------------------------'
print 'Drop all foreign keys for all tables'
if exists(select 1 from INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS)
begin
	declare @tblProd table(rowNum int, constraint_name nvarchar(50), table_name nvarchar(50))

	-- get all constraints	
	insert into @tblProd(rowNum, constraint_name, table_name)
	select  ROW_NUMBER() OVER(order by rc.constraint_name) rownumber, rc.CONSTRAINT_NAME, ctu.TABLE_NAME
	from INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS rc
	inner join INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE ctu on ctu.CONSTRAINT_NAME = rc.CONSTRAINT_NAME

	-- loop thru constraints and drop them
	declare @nextRow int, @nextConstraintName nvarchar(50), @nextTableName nvarchar(50), @sql nvarchar(max)
	select top 1 @nextRow=rowNum, @nextConstraintName=constraint_name, @nextTableName=table_name from @tblProd order by rowNum
	while(@nextRow <= (select COUNT(*) from @tblProd))
	begin
		select @nextConstraintName=constraint_name, @nextTableName=table_name from @tblProd where rowNum=@nextRow
		exec('alter table ' + @nextTableName + ' drop constraint ' + @nextConstraintName)
		set @nextRow = @nextRow + 1
	end
end
go

print '--------------------------------------------------------------------------'
print 'Creating Table: AppRole'
if exists (select 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'AppRole')
begin
	drop table dbo.AppRole
end
go
create table dbo.AppRole
(
	Id int identity(1,1) primary key not null,
	Name nvarchar(50) not null,
	Created datetime not null,
	CreatedBy nvarchar(20) not null,
	Updated datetime not null,
	UpdatedBy nvarchar(20) not null
)
go
insert into dbo.AppRole values('Admin', getdate(), 'system', getdate(), 'system')
insert into dbo.AppRole values('Area Manager', getdate(), 'system', getdate(), 'system')
insert into dbo.AppRole values('Supervisor', getdate(), 'system', getdate(), 'system')
insert into dbo.AppRole values('Sub-contractor', getdate(), 'system', getdate(), 'system')
insert into dbo.AppRole values('Punch-man', getdate(), 'system', getdate(), 'system')
insert into dbo.AppRole values('Controller', getdate(), 'system', getdate(), 'system')
go

print '--------------------------------------------------------------------------'
print 'Creating Table: AppUser'
if exists (select 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'AppUser')
begin
	drop table dbo.AppUser
end
go
create table dbo.AppUser
(
	Id int identity(1,1) primary key not null,
	RoleId int not null constraint fk_AppUser_AppRole foreign key references dbo.AppRole(Id),
	FirstName nvarchar(50) not null,
	LastName nvarchar(50) not null,
	Username nvarchar(20) not null,
	[Password] nvarchar(20) not null,
	Email nvarchar(100) null,
	Phone nvarchar(20) null,
	Photo nvarchar(100) null,
	Created datetime not null,
	CreatedBy nvarchar(20) not null,
	Updated datetime not null,
	UpdatedBy nvarchar(20) not null
)
go
insert into dbo.AppUser values(3, 'Gil', 'Sau', 'gil', 'sau', 'gilbert.sauceda@gmail.com', '512-804-8152', null, getdate(), 'system', getdate(), 'system')
go

print '--------------------------------------------------------------------------'
print 'Creating Table: State'
if exists (select 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'State')
begin
	drop table dbo.[State]
end
go
create table dbo.[State]
(
	Id int identity(1,1) not null primary key,
	Abbrev nvarchar(5) not null,
	Name nvarchar(50) not null
)
go
insert into [State]
select 'AL', 'Alabama'
union select 'AK', 'Alaska'
union select 'AZ', 'Arizona'
union select 'AR', 'Arkansas'
union select 'CA', 'California'
union select 'CO', 'Colorado'
union select 'CT', 'Connecticut'
union select 'DE', 'Delaware'
union select 'DC', 'District Of Columbia'
union select 'FL', 'Florida'
union select 'GA', 'Georgia'
union select 'HI', 'Hawaii'
union select 'ID', 'Idaho'
union select 'IL', 'Illinois'
union select 'IN', 'Indiana'
union select 'IA', 'Iowa'
union select 'KS', 'Kansas'
union select 'KY', 'Kentucky'
union select 'LA', 'Louisiana'
union select 'ME', 'Maine'
union select 'MD', 'Maryland'
union select 'MA', 'Massachusetts'
union select 'MI', 'Michigan'
union select 'MN', 'Minnesota'
union select 'MS', 'Mississippi'
union select 'MO', 'Missouri'
union select 'MT', 'Montana'
union select 'NE', 'Nebraska'
union select 'NV', 'Nevada'
union select 'NH', 'New Hampshire'
union select 'NJ', 'New Jersey'
union select 'NM', 'New Mexico'
union select 'NY', 'New York'
union select 'NC', 'North Carolina'
union select 'ND', 'North Dakota'
union select 'OH', 'Ohio'
union select 'OK', 'Oklahoma'
union select 'OR', 'Oregon'
union select 'PA', 'Pennsylvania'
union select 'RI', 'Rhode Island'
union select 'SC', 'South Carolina'
union select 'SD', 'South Dakota'
union select 'TN', 'Tennessee'
union select 'TX', 'Texas'
union select 'UT', 'Utah'
union select 'VT', 'Vermont'
union select 'VA', 'Virginia'
union select 'WA', 'Washington'
union select 'WV', 'West Virginia'
union select 'WI', 'Wisconsin'
union select 'WY', 'Wyoming'
go

print '--------------------------------------------------------------------------'
print 'Creating Table: Community'
if exists (select 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'Community')
begin
	drop table dbo.Community
end
go
create table dbo.Community
(
	Id int identity(1,1) primary key not null,
	Name nvarchar(50) not null,
	City nvarchar(100) not null,
	StateId int not null constraint fk_Community_State foreign key references dbo.State(Id),
	Created datetime not null,
	CreatedBy nvarchar(20) not null,
	Updated datetime not null,
	UpdatedBy nvarchar(20) not null
)
go
insert into dbo.Community values('Alger Park/Ash Creek','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Belmont','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Buckner Terrace','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Caruth Terrace','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Casa Linda Estates','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Casa Linda Park','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Casa View','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Casa View Haven','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Claremont','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Claremont Park','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Eastwood','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Edgemont Park','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Forest Hills','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Gaston Park','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Greenland Hills','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Hillridge','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Hollywood Heights','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Junius Heights','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Lake Park Estates','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Lakewood','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Lakewood Heights','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Lakewood Trails','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Little Forest Hills','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Lochwood','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Lower Greenville','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('North Stonewall Terrace','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Old Lake Highlands','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Ridgewood Park','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Santa Monica','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Stonewall Terrace','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('University Meadows','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Vickery Place','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Wilshire Heights','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Baylor/Meadows','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Belmont Park','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Bryan Place','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Deep Ellum','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Munger Place Historic District','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Peaks Suburban Addition','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Swiss Avenue','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Abrams Place','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Alexanders Village','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Boundbrook Oaks Estates','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Chimney Hill','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Copperfield Community','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Country Forest','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Forest highlands','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Glen Oaks','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Hamilton Park','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Highlands West','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Highland Meadows','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('High Oaks Addition','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Jackson Meadow','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('L Streets','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('[[Lake Highlands, Dallas|Lake Highlands]]','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Lake Highlands Estates','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Lake Highlands North','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Lake Highlands Square','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Lake Ridge Estates','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Merriman Park Estates','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Merriman Park North','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Moss Farm','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Moss Meadows','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Northwood Heights','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Oak Highlands','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Oak Tree Village','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Pebble Creek','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Richland Park Estates','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Rolling Trails','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Royal Highlands','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Royal Highlands Village','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Stultz Road','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Town Creek','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Royal Lane Village','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Walnut Creek Estates','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Whispering Hills','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('White Rock Valley','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Woodbridge','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Woodlands on the Creek','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('University Manor','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('University Terrace','Dallas',44,getdate(),'system',getdate(),'system');
insert into dbo.Community values('Urban Reserve','Dallas',44,getdate(),'system',getdate(),'system');
go

print '--------------------------------------------------------------------------'
print 'Creating Table: Status'
if exists (select 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'Status')
begin
	drop table dbo.[Status]
end
go
create table dbo.[Status]
(
	Id int identity(1,1) primary key not null,
	Name nvarchar(50) not null
)
go
insert into dbo.[Status] values('Complete');
insert into dbo.[Status] values('In Progress');
insert into dbo.[Status] values('Not Ready');
insert into dbo.[Status] values('Received');
go

print '--------------------------------------------------------------------------'
print 'Creating Table: Builder'
if exists (select 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'Builder')
begin
	drop table dbo.Builder
end
go
create table dbo.Builder
(
	Id int identity(1,1) primary key not null,
	Name nvarchar(50) not null,
	ContactPerson nvarchar(50) null,
	Phone nvarchar(20) null,
	Email nvarchar(100) null,
	Created datetime not null,
	CreatedBy nvarchar(20) not null,
	Updated datetime not null,
	UpdatedBy nvarchar(20) not null
)
go
insert into dbo.Builder values('American Legend Homes','Carole Gibb','(415) 362-2266','Proin.velit.Sed@nuncrisus.ca',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('Antares Homes ','Sergio Madrigal','(714) 220-2694','tincidunt.nunc.ac@ipsum.org',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('Ashton Woods Homes','Tim Velarde','(714) 525-3503','ut@dapibusligula.net',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('Bowen Family Homes','Tim Jordan','(909) 391-4477','malesuada.ut.sem@ornarelectus.edu',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('Centex Homes','Anthony Lopez','(909) 621-6001','id@sociis.org',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('Choice Homes','Antonio Goncalves','(510) 490-4432','Phasellus.ornare.Fusce@in.org',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('Coleman Homes','Andrew Stephens','(209) 333-0136','est.Mauris@Maurisutquam.org',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('David Weekley Homes','Scott Smyth','(951) 354-6924','arcu.iaculis.enim@Quisque.ca',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('Drees Custom Homes','David Seeno','(925) 427-5597','tellus.justo.sit@Suspendissenon.ca',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('Five Star Homes','Antonio Ruiz','(415) 647-4010','parturient@egetvolutpatornare.org',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('Fox and Jacobs Homes','Daniel Wilson','(951) 737-3822','ipsum@scelerisque.org',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('Grand Homes','Jim Diani','(805) 925-9533','et@elementum.com',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('Grenadier Homes','Steven MacIntosh','(562) 692-1203','sagittis@Maecenas.org',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('Highland Homes','Margaret McDonald','(818) 767-4767','Class.aptent.taciti@Sedidrisus.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('Horizon Homes','Ramon Mendieta Jr.','(714) 305-7263','urna.Vivamus@eget.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('Huffines Communities','Lawerence Twomey','(510) 658-9796','purus@leo.org',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('Huntington Homes','Keith Trask','(408) 727-5465','mattis.Integer@nonlacinia.org',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('K. Hovnanian Homes','Kenneth Czubernat','(619) 239-3428','dui.nec.urna@Quisque.com',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('KB Home','Rick Schaefer','(909) 988-0390','tempus@nonloremvitae.net',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('Landstar Homes','Luis Allende','(510) 727-0900','enim.Etiam@velarcuCurabitur.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('Morrison Homes','Richard Bolter','(951) 346-8154','tempor@convallisdolorQuisque.net',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('New Lineage Custom','Paul McClain','(916) 645-7747','risus@rutrumnon.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('Newcastle Homes','Steven Altfillisch','(951) 736-2811','Quisque.tincidunt.pede@maurisanunc.ca',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('Oakley Custom','Donald Dolly','(209) 841-1158','sed.orci@Inornare.edu',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('Park Avenue Custom','Robert Seghetti','(509) 242-1234','dis.parturient@eleifend.edu',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('Portrait Homes','Kadin Terry','(916) 993-3671','nec.mauris.blandit@loremlorem.net',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('Premier Home Builders','AJ Fistes','(562) 424-2230','cursus.et@VivamusnisiMauris.edu',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('Pulte Homes','Mark Hall','(925) 207-3550','dui@estconguea.org',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('Quantum Homes','Alfonso Quintor','(510) 568-2300','iaculis.quis@netus.com',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('Ryland Homes','Robert Gonzales Jr.','(925) 427-1199','dolor.Nulla.semper@ipsum.org',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('Sandlin Custom','Tim Masters','(505) 384-6067','neque.Morbi@turpisIncondimentum.edu',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('Sotherby Homes','Michael Moreno','(805) 806-0589','lobortis.mauris.Suspendisse@auctorveliteget.edu',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('Springfield Custom','Brent Bates','(510) 654-8441','Integer@penatibuset.ca',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('Toll Brothers','Nicholas Boscacci','(650) 716-4881','sollicitudin@nonegestas.net',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('Twin Oaks Homes','Michael Stellato','(925) 961-1600','dui.augue.eu@malesuadavel.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Builder values('Wall Homes','Larry Grimes','(559) 651-7900','ipsum@sit.org',getdate(),'system',getdate(),'system');
go

print '--------------------------------------------------------------------------'
print 'Creating Table: Plan'
if exists (select 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'Plan')
begin
	drop table dbo.[Plan]
end
go
create table dbo.[Plan]
(
	Id int identity(1,1) primary key not null,
	Name nvarchar(50) not null,
	[File] nvarchar(100) null,
	Created datetime not null,
	CreatedBy nvarchar(20) not null,
	Updated datetime not null,
	UpdatedBy nvarchar(20) not null
)
go
insert into dbo.[Plan] values('Plan 100', '987UIYTIO874.jpg', getdate(), 'system', getdate(), 'system');
go

print '--------------------------------------------------------------------------'
print 'Creating Table: SubContractor'
if exists (select 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'SubContractor')
begin
	drop table dbo.SubContractor
end
go
create table dbo.SubContractor
(
	Id int identity(1,1) primary key not null,
	Name nvarchar(150) not null,
	ContactPerson nvarchar(50) null,
	Phone nvarchar(20) null,
	Email nvarchar(100) null,
	Created datetime not null,
	CreatedBy nvarchar(20) not null,
	Updated datetime not null,
	UpdatedBy nvarchar(20) not null
)
go
insert into dbo.Subcontractor values('A & B Construction','Carole Gibb','(415) 362-2266','Proin.velit.Sed@nuncrisus.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('A & S Cement Contractors Inc','Sergio Madrigal','(714) 220-2694','tincidunt.nunc.ac@ipsum.org',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('A & V Contractors','Tim Velarde','(714) 525-3503','ut@dapibusligula.net',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('A C L Construction Company','Tim Jordan','(909) 391-4477','malesuada.ut.sem@ornarelectus.edu',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('A Lopez & Sons Inc.','Anthony Lopez','(909) 621-6001','id@sociis.org',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('A M G Pipeline Inc.','Antonio Goncalves','(510) 490-4432','Phasellus.ornare.Fusce@in.org',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('A M Stephens Construction Co Inc','Andrew Stephens','(209) 333-0136','est.Mauris@Maurisutquam.org',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('A-N-W Construction','Scott Smyth','(951) 354-6924','arcu.iaculis.enim@Quisque.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('A-S Pipelines Inc.','David Seeno','(925) 427-5597','tellus.justo.sit@Suspendissenon.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('A. Ruiz Construction Company & Assoc.','Antonio Ruiz','(415) 647-4010','parturient@egetvolutpatornare.org',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('A.D. Wilson Inc.','Daniel Wilson','(951) 737-3822','ipsum@scelerisque.org',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('A.J. Diani Construction Company','Jim Diani','(805) 925-9533','et@elementum.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('A.L MacIntosh Company','Steven MacIntosh','(562) 692-1203','sagittis@Maecenas.org',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('A.M. Concrete','Margaret McDonald','(818) 767-4767','Class.aptent.taciti@Sedidrisus.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('A.M. Construction','Ramon Mendieta Jr.','(714) 305-7263','urna.Vivamus@eget.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('AA Johnson & Son Inc','Lawerence Twomey','(510) 658-9796','purus@leo.org',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('AAA Fence','Keith Trask','(408) 727-5465','mattis.Integer@nonlacinia.org',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('ABC Construction Co., Inc.','Kenneth Czubernat','(619) 239-3428','dui.nec.urna@Quisque.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('ABC Resources Inc','Rick Schaefer','(909) 988-0390','tempus@nonloremvitae.net',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('ABSL Construction','Luis Allende','(510) 727-0900','enim.Etiam@velarcuCurabitur.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('ABSOLUTE OUTDOOR INC','Richard Bolter','(951) 346-8154','tempor@convallisdolorQuisque.net',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('AC Dike Company (Specialty Paving Inc)','Paul McClain','(916) 645-7747','risus@rutrumnon.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('ACI (Altfillisch Contractors Inc)','Steven Altfillisch','(951) 736-2811','Quisque.tincidunt.pede@maurisanunc.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('ACME General Engineering','Donald Dolly','(209) 841-1158','sed.orci@Inornare.edu',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('ACPI (Acme Concrete Paving)','Robert Seghetti','(509) 242-1234','dis.parturient@eleifend.edu',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('AGL Landscapes Inc','Kadin Terry','(916) 993-3671','nec.mauris.blandit@loremlorem.net',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('AJ  Corporation','AJ Fistes','(562) 424-2230','cursus.et@VivamusnisiMauris.edu',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('AJ Ashtin Construction','Mark Hall','(925) 207-3550','dui@estconguea.org',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('AJW Construction','Alfonso Quintor','(510) 568-2300','iaculis.quis@netus.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('ALB Inc.','Robert Gonzales Jr.','(925) 427-1199','dolor.Nulla.semper@ipsum.org',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('ALMS Limited Co.','Tim Masters','(505) 384-6067','neque.Morbi@turpisIncondimentum.edu',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('AMC Painting & General Contracting','Michael Moreno','(805) 806-0589','lobortis.mauris.Suspendisse@auctorveliteget.edu',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('AMG (Asbestos Management Group of California)','Brent Bates','(510) 654-8441','Integer@penatibuset.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('AMP Electric (Boscacci Inc.)','Nicholas Boscacci','(650) 716-4881','sollicitudin@nonegestas.net',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('AMS Electric Inc.','Michael Stellato','(925) 961-1600','dui.augue.eu@malesuadavel.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('APCO (Asphalt Dike Construction Inc.)','Larry Grimes','(559) 651-7900','ipsum@sit.org',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('ARA Concrete Cutting & Coring','Anthony Andrews','(760) 948-7242','Praesent.interdum@etlaciniavitae.org',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('ARB Structures Inc.','David Grant','(949) 598-9242','non@Aeneanmassa.net',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('ARB, Inc','Scott Summers','(949) 598-9242','aliquet.sem@magnaUt.edu',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('AS Contractors','Deni Smith','(209) 742-6684','arcu.Curabitur.ut@loremsit.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('AVAR Constuction, Inc.','Michael Pagano','(510) 354-2000','urna.et.arcu@Phasellusdolorelit.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('AVOR, Inc. (Ver-O-Roses Maintenance)','Anna Rosales','(626) 839-6717','quis@nibh.edu',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Abbett Electric Corp','Jeffrey Abbott','(415) 864-7500','arcu.Sed@Crasegetnisi.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Abels Concrete','Abel Salazar','(831) 320-8098','cursus@Aliquameratvolutpat.net',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Able Fence Company','Dan Boyd','(707) 763-2551','faucibus@Nullamscelerisque.net',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Abrasive Blasting Service','Diana Winn','(951) 683-4692','nunc.sit.amet@urnaNullam.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Acacia Erosion Control','Jonathan Colbert','(805) 964-2585','eros.non.enim@est.org',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Acacia Erosion Control (Los Angeles)','Reed Pollock','(818) 727-0055','amet.diam@neque.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Accent Construction Inc. (Accent Engineering and Construction Inc.)','Rodney Thompson','(619) 954-4852','odio@adipiscinglacus.edu',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Accu-Bore Directional Drilling','Billy Kilmore Jr','(707) 361-5030','Phasellus.libero@sagittis.org',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Accurate Concrete Sawing','Bob Goldman','(562) 777-9100','dignissim.pharetra@facilisis.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Accurate Firestop','Javier Lucatero','(510) 886-1169','aliquam.enim.nec@arcu.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Accurate Sawcutting Inc.','Mary Machado','(209) 632-5010','nulla@lacus.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Ace Engineering Inc.','Peter Moon','(909) 392-4600','justo.eu@egestasDuis.net',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Ace Fence Co. (APW Construction)','America Tang','(626) 333-0727','gravida.molestie.arcu@lectus.edu',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Ace Pipelining Inc.','Adam Tovar','(626) 523-2004','lorem@gravidanuncsed.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Acme Construction Co Inc.','Gregory Mastagni','(209) 523-2674','Sed.congue.elit@magnaSuspendissetristique.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Aderholt Specialty Co Inc.','Herbert Aderholt','(209) 526-2000','libero.mauris.aliquam@fringilla.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Advanced Concrete Sawing and Sealing','Shawn ODonnell','(480) 986-7447','erat.Vivamus@urna.net',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Advanced Construction (Pima Corporation)','Bijan Pirouz','(310) 231-7060','nisl.Nulla@massalobortisultrices.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Advanced Cut & Core (Thomas Construction Company)','Cory Thomas','(530) 391-4398','Nulla@elitpharetraut.net',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Advanced Drilling Works','Brian Armstrong','(925) 417-7422','scelerisque@accumsansed.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Advantage Demolition & Grading Inc.','Keith Dixon','(818) 447-2074','sed.dui@pharetrasedhendrerit.net',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Advantage Directional Drilling','Ralph Torres','(760) 948-7069','ac.urna@necorciDonec.org',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Aerco-Pacific Inc.','Robert Houck','(916) 635-5635','lobortis@Aeneansedpede.net',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Aesthetic Maintenance Corporation','Curtiss Pierose','(213) 353-1525','aliquet.lobortis.nisi@Nullainterdum.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Agee Construction','Gayle Salvucci','(559) 299-3290','Proin.mi@ipsumCurabiturconsequat.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Ahlborn Fence & Steel Inc.','Thomas Ahlborn','(707) 573-0742','eleifend@egestasFusce.edu',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Air Systems Inc.','Arthur Williams','(408) 280-1666','eu.ligula@leoelementum.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Airco Mechanical','Wyatt Jones','(916) 381-4523','lectus.convallis@liberoProin.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Als Landclearing Inc.','Chad Randall','(916) 482-2161','in@pretiumnequeMorbi.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Alabbasi Construction & Engineering (Mamco)','Marwan Alabbasi','(951) 776-9300','Nunc@cursusluctusipsum.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Alarcon Bohm Corp.','Kevin Bohm Sr.','(510) 893-4405','quam.a@bibendumullamcorperDuis.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Alcala Company, Inc.','Steve Plante','(858) 550-2011','cubilia.Curae@justoPraesent.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Alcorn Fence Company','Greg Erickson','(323) 875-1342','velit.egestas.lacinia@vulputateullamcorpermagna.net',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Alert Insulation Company','Donald Kent','(626) 961-9113','aliquet@luctus.org',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Alert Maintenance Systems','Richard Cohen','(408) 298-1231','ac.mattis@nonarcuVivamus.org',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Alexis Fence','Clay Hoggard','(760) 428-8830','posuere@lectusconvallisest.org',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('All American Asphalt','Brad Bradley','(951) 736-7600','luctus@maurissit.edu',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('All Cities Concrete Sawing','Tony Cron','(951) 735-9422','congue@rutrummagnaCras.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('All Commercial Fence','Noel Stamper','(209) 874-5484','cursus.Nunc@purusgravida.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('All Forms Inc.','Richard Steele','(408) 463-0411','euismod@erat.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('All In One Landscaping','Fernando Valdez','(925) 457-5319','dis.parturient@venenatisa.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('All Steel Fence Co.','Thomas Cornell','(209) 983-8406','nibh@mauris.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('All Valley Fence & Supply','Harry Cady','(760) 355-7007','in@magnaPhasellus.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('All-American Construction, Inc.','Jason Stokes','(916) 870-8312','et@Fuscealiquamenim.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Allante Fence Co.','Carlos Lopez','(559) 498-0551','lacus@Proinvelnisl.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Allen A. Waggoner Construction, Inc.','Rocky Myers','(209) 599-8788','ipsum@Donec.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Alliance Contracting Services','Omar Garrido','(510) 264-9900','odio.Phasellus.at@libero.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Allied Environmental Inc.','Allen Wellborn','(530) 676-0595','tellus.lorem@sodalesnisi.net',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Allied-West Construction','Edward Arent','(916) 663-4741','montes@vulputaterisus.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Allstate Boring (CNSB)','Brian Sherrell','(661) 399-5000','ridiculus@ac.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Almendariz Consulting','Mateo Almendariz','(916) 939-3392','blandit@magnaUttincidunt.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Alpha & Omega Pavers','Adam Cuevas','(909) 795-8474','massa.Mauris.vestibulum@Nunclectus.net',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Alta Engineering Group Inc.','David Cantor','(415) 648-4309','pulvinar.arcu@famesacturpis.org',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Alten Construction, Inc.','Robert Alten','(510) 234-4200','est@enimSuspendisse.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('American Civil Constructors West Coast LLC','Jeffrey Foerste','(707) 746-8028','Ut.tincidunt.orci@estmaurisrhoncus.net',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('American Environmental Corp.','Gary Darnell','(562) 204-1014','Fusce.mi.lorem@Donecegestas.org',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('American Integrated Services','Paul David Herrera','(310) 522-1168','auctor@feugiattelluslorem.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('American Landscape, Inc.','Gary Peterson Sr.','(818) 999-2041','ut.odio.vel@tempusrisusDonec.eduemail',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('American Pavement Systems','Gregory Reed','(209) 522-2277','faucibus.Morbi@auguemalesuada.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('American Paving Co.','Stephen Pointdexter','(559) 268-9886','pharetra.Nam.ac@tempor.org',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('American Sandblasting','Edward Wolf','(650) 579-3737','Vestibulum@anteipsum.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('American Scaffold','Alvin Ruis, Jr.','(619) 231-4898','consectetuer.cursus.et@ullamcorpernisl.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('American Sheet Metal Partition','Richard Meeker','(916) 564-6691','sed@purus.edu',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Ames Construction','Jeff Geist','(951) 356-1275','Aenean.euismod@nequesedsem.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Ames Construction (AZ)','Jerry Miller','(602) 431-2111','ridiculus@liberodui.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Ampco North Inc.','Kristopher Huff','(669) 400-7366','feugiat@lectussit.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Anchor Fence','John Stoich','(650) 757-2140','sed.leo.Cras@euligulaAenean.org',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Andes Construction, Inc.','Dan Mayorga','(510) 536-7832','felis.ullamcorper.viverra@idenimCurabitur.net',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Andreini Brothers Inc.','Mario Andreini','(650) 726-2065','id.magna@Nunc.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Andrew L Lee Inc.','Kristen Lee','(209) 369-8077','porttitor.vulputate@fermentum.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Andrew Papac & Sons','Andrew Papac','(626) 443-4061','tempor.lorem@ipsumcursusvestibulum.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Angotti & Reilly Inc.','Jeff Wieland','(415) 575-3700','nisl@tellusimperdiet.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Anning Johnson Company','Lawrence Domino','(510) 670-0100','mauris.aliquam.eu@maurisSuspendissealiquet.edu',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Annuzzi Concrete Service Inc.','Mel Annuzzi','(415) 468-2795','in@eleifend.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Anozira, Inc.','Brian Haber','(925) 771-8400','sit.amet@euismodet.edu',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Antioch Paving Company Inc.','Richard Allison','(925) 757-0123','dapibus.id.blandit@Nuncpulvinar.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Anvil Builders','Hien Tran','(415) 285-5000','neque.tellus@eusemPellentesque.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Anza Engineering Corp.','Randy Potts','(925) 513-2060','et@tacitisociosqu.net',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Apadana Engineering','Sopida Siadat','(415) 508-9710','purus.mauris@consequatauctornunc.edu',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Apex Fence Co Inc.','Author Dorris','(530) 365-3316','sed@In.edu',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Apex Plastering Company','Ash Buchan','(626) 448-0080','mi@auctornunc.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Apollo Pools, Inc.','Alvin Rotter','(310) 477-3061','Cras@necenimNunc.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Applecrest Construction','H. David Alexander','(562) 285-0888','erat@placerat.edu',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Apply-A-Line','Audie Sherberg','(530) 365-4000','facilisis.magna@lobortis.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Arciero Brothers, Inc.','Rob Mook','(714) 572-8100','eget.tincidunt@posuere.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Argo Construction, Inc.','Arkadiy Golster','(415) 850-0857','est@erat.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Argonaut Constructors Inc.','michael Smith','(707) 542-4862','non@Aliquam.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Argus Contracting Inc.','Christopher Rennie','(562) 422-7370','commodo@pharetranibhAliquam.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Arizona Drilling & Blasting (Fisher Sand & Gravel Co.)','Luke Meister','(480) 730-1033','felis.Nulla@ornarelibero.edu',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Arktos Incorporated','James T. Robinson','(510) 728-2144','ipsum.dolor@pedenec.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Arnaudo Construction Inc','Garrett Arnaudo','(209) 207-4501','imperdiet@dapibus.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Arntz Builders','Kenneth Arntz','(415) 382-1188','inceptos.hymenaeos.Mauris@facilisismagnatellus.net',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Arrow Fencing (Woida Enterprises)','Chris Woida','(707) 485-1128','egestas.a@sagittisfelisDonec.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Arrow Signs','Matthew McVey','(951) 813-1053','tempor.est.ac@sociis.net',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('AshLin Pacific Construction, Inc.','Rich Metcalfe','(707) 795-2860','ornare.facilisis.eget@ipsumprimis.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Ashron Construction and Restoration','Ezra Cohen','(408) 956-0909','libero@facilisisnon.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Asphalt Impressions','Stephen Biondi','(916) 383-0441','Duis.elementum.dui@tristique.net',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Associated Traffic Safety (Kellie Avila Construction Services, Inc.)','Kellie Avila','(805) 461-1600','ipsum.dolor.sit@sitamet.org',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Asta Construction Company','Chris Koenig','(707) 374-6472','lacinia@ultricesDuis.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Atkinson Contractors','Mark Padien','(949) 855-9755','Nunc@porttitortellus.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Atlas Peak Construction','Danny McLean','(707) 254-0751','nunc.Quisque@metusvitae.edu',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Atlas Tree Surgery Inc','Rich Kingsborough','(707) 523-4399','aliquam.eu@risusIn.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Atlas Underground Inc.','Hector Loya','(909) 622-7738','mi.ac@ante.edu',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('August Construction, Inc.','Agust Agustsson','(424) 270-0370','est.congue.a@aliquet.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Austerman Inc.','Elaine Austerman','(916) 371-1031','dolor.quam.elementum@amet.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Austin Enterprise (California Grinding Specialties)','Patti Austin','(661) 589-1001','fermentum@nectempus.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Avance Concrete Sawing','Angel Rodriguez','(805) 223-4015','nulla.vulputate.dui@natoquepenatibuset.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Aviation Striping','Sam Nicol','(951) 303-9914','euismod@diam.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Avison Construction Inc.','Louis Avila','(559) 431-0317','mus@arcu.net',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Ayala Boring, Inc.','Ralph Ayala III','(909) 350-8940','ipsum.cursus@laoreet.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Ayala Engineering','Ricardo Ayala','(714) 823-7179','sit.amet.nulla@tellus.net',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Azul Works Inc.','Sandra Rocio Hernandez','(415) 558-1507','ligula@dis.net',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('B & H Mechanical','Donald Black','(575) 524-3759','Nullam.lobortis.quam@Cras.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('B D Evans Construction','Brian Evans','(209) 728-9493','ante.lectus.convallis@dictum.net',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('BASS Electric','Jeffrey Yee','(415) 295-1600','Aenean.massa.Integer@dictumeueleifend.edu',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('BC Traffic Specialist (BC Rentals Inc.)','Bob Carson','(714) 974-1190','faucibus.orci@ascelerisque.org',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('BCCI Construction Company','Debbie Fleser','(415) 817-5100','Cum@nuncnullavulputate.net',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Babcock & Wilcox Construction Co','Ronald Pon','(707) 259-1122','ut@Donectempuslorem.org',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Bailey Fence Co','Kerrick Bailey','(510) 783-2980','odio@dapibusligulaAliquam.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Baileys Trenchless Inc','Andy Tanberg','(530) 662-1113','dictum@duiFusce.edu',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Baines Group Inc','Michael Baines','(510) 238-4666','non.bibendum.sed@magnis.org',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Balfour Beatty Construction LLC','David J. Christensen','(510) 903-2054','malesuada.fringilla@a.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Balfour Beatty Infrastructure','John Foote','(707) 427-8900','vitae.orci.Phasellus@vitaedolor.edu',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Balfour Beatty Rail, Inc','Joe Reed','(626) 571-8597','justo@tempus.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Bali Construction, Inc','Ted Polich','(626) 442-8003','ipsum.leo.elementum@Vestibulumante.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Banicki Construction','Jerry Banicki','(480) 921-8016','diam@ligula.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Barazani Stone Inc.','Yuval Barazani','(818) 701-6977','tellus@et.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Barcelo Construction','Monica Sanchez','(661) 449-1130','nascetur.ridiculus@velitegestas.edu',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Barri Electric Company','Ernest Ulibarri','(415) 468-6477','molestie.tortor.nibh@sociisnatoque.net',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Barrys Backhoe Service','Barry Yanke, Jr.','(209) 229-1815','orci.lobortis.augue@dolordapibusgravida.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Bauman Landscape, Inc.','Michael Bauman','(415) 447-4800','tincidunt.neque@amet.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Bay Area Concretes, Inc.','Michael Price','(925) 245-8900','natoque.penatibus.et@interdumligula.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Bay Area Drilling','Mark Lucido','(925) 427-7574','placerat.orci@conubianostra.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Bay Area Lightworks Inc.','Jim Lau','(415) 822-2336','enim.nisl.elementum@egestashendrerit.edu',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Bay Area Paving','Gerald Kunz','(650) 341-0351','magna.Cras.convallis@aliquetliberoInteger.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Bay Area Traffic Solutions','Rafael De La Cruz, Jr.','(510) 657-2543','sit@Curabitursed.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Bay Area Traffic Solutions (Riverside Office)','William Kearney','(949) 929-3044','malesuada.fringilla@nunc.net',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Bay Cities Paving & Grading','Ben Rodriguez','(925) 687-6666','Aenean@porttitor.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Bay Engineering LLC','Matt Muntean','(415) 343-0220','pharetra@pede.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Bay Line Cutting & Coring','Juan Arrequin','(415) 508-1800','Donec.vitae.erat@Nulla.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Bay Pacific Pipelines','Eugene Carew','(415) 897-6958','vel@ante.net',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Bayley Construction General Partnership','Robert Bayley','(714) 540-8863','facilisis@ipsumprimisin.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Bayside Stripe and Seal','Ramy Mughannam','(707) 765-2871','nisi.dictum@vulputateeuodio.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Bayview Environmental Inc','Michael Christie','(510) 562-6181','commodo@ullamcorperDuis.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Beador Construction Co.,Inc.','David Beador','(951) 674-7352','sagittis@eros.org',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Bear Electrical Solutions','Robert Asuncion','(408) 449-5178','Vivamus.nisi.Mauris@orcitincidunt.net',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Bear Fireproofing','Jasmine Garcia','(408) 262-1700','tellus@blandit.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Beliveau Engineering Contractors Inc','Lawerence Beliveau','(510) 595-1905','diam@Nunc.edu',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Bellanti Plumbing Inc','Ronald Bellanti','(650) 588-2990','sociis.natoque.penatibus@nibh.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Bellfree Contractors','Hans Keifer','(818) 975-5120','luctus.aliquet.odio@purusaccumsan.edu',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Beltramo Electric Inc.','Kimberly Beltramo','(408) 778-0076','Nullam@Nunc.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Bentancourt Brothers Construction Inc.','David Bentancourt','(209) 832-7631','ac.facilisis@lobortis.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Berkeley Ready Mix (Hanson Aggregates)','Berkeley Ready Mix','(925) 244-6100','nec@tempus.edu',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Berry General Engineering Contractors Inc.','Robert Sainsbury','(805) 643-7567','libero.est.congue@atnisi.ca',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Bert W. Salas, Inc.','Bob Salaz','(619) 562-7711','dictum@magnaCrasconvallis.net',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Bevilacqua & Sons, Inc.','Paulette Bevilacqua','(650) 616-4900','hendrerit.consectetuer@sagittis.com',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Bielski Specialty Services, Inc.','Tim Bielski','(714) 630-2316','nec.euismod@at.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Subcontractor values('Bill Coleman Concrete','Bill Coleman','(707) 544-7573','at.velit.Cras@lacusvarius.com',getdate(),'system',getdate(),'system');
go

print '--------------------------------------------------------------------------'
print 'Creating Table: PunchMan'
if exists (select 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'PunchMan')
begin
	drop table dbo.PunchMan
end
go
create table dbo.PunchMan
(
	Id int identity(1,1) primary key not null,
	FirstName nvarchar(50) not null,
	LastName nvarchar(50) not null,
	Phone nvarchar(20) null,
	Email nvarchar(150) null,
	Created datetime not null,
	CreatedBy nvarchar(20) not null,
	Updated datetime not null,
	UpdatedBy nvarchar(20) not null
)
go
insert into dbo.Punchman values('Leonard','James','1-202-792-5731','Proin.velit.Sed@nuncrisus.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Brent','Bruce','1-826-695-4857','tincidunt.nunc.ac@ipsum.org',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Jamal','Chang','1-739-907-7089','ut@dapibusligula.net',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Hyatt','Ford','1-931-705-2868','malesuada.ut.sem@ornarelectus.edu',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Channing','Horne','1-896-924-9689','id@sociis.org',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Abel','Rowland','1-357-575-0970','Phasellus.ornare.Fusce@in.org',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Ali','Torres','1-317-276-9930','est.Mauris@Maurisutquam.org',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Judah','Dixon','1-518-865-6155','arcu.iaculis.enim@Quisque.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Chandler','Oconnor','1-443-330-2814','tellus.justo.sit@Suspendissenon.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Malcolm','Mayer','1-851-122-8398','parturient@egetvolutpatornare.org',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Eagan','Stephenson','1-509-276-4487','ipsum@scelerisque.org',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Francis','Boone','1-414-788-2275','et@elementum.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Price','Lynch','1-149-926-3967','sagittis@Maecenas.org',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Bruce','Fry','1-339-954-0833','Class.aptent.taciti@Sedidrisus.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Bevis','West','1-680-675-9979','urna.Vivamus@eget.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Gage','Mcneil','1-991-238-9664','purus@leo.org',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Abbot','Coleman','1-856-888-9416','mattis.Integer@nonlacinia.org',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Mohammad','Warren','1-810-941-8917','dui.nec.urna@Quisque.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Jin','Briggs','1-799-824-6839','tempus@nonloremvitae.net',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Branden','Long','1-805-885-5584','enim.Etiam@velarcuCurabitur.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Otto','Snyder','1-678-628-2426','tempor@convallisdolorQuisque.net',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Evan','Carver','1-998-301-3391','risus@rutrumnon.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Dalton','Sellers','1-401-102-5268','Quisque.tincidunt.pede@maurisanunc.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Scott','Bishop','1-996-781-5809','sed.orci@Inornare.edu',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Akeem','Griffin','1-129-192-0872','dis.parturient@eleifend.edu',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Ralph','Brewer','1-447-615-2854','nec.mauris.blandit@loremlorem.net',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Louis','Roberson','1-977-374-6101','cursus.et@VivamusnisiMauris.edu',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Camden','Contreras','1-876-103-1355','dui@estconguea.org',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Demetrius','Salas','1-261-816-1962','iaculis.quis@netus.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Brennan','Leblanc','1-806-851-6229','dolor.Nulla.semper@ipsum.org',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Galvin','Burt','1-884-138-8634','neque.Morbi@turpisIncondimentum.edu',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Reed','Hester','1-347-159-0484','lobortis.mauris.Suspendisse@auctorveliteget.edu',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Wyatt','Carr','1-746-270-0309','Integer@penatibuset.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Kasimir','Harding','1-167-517-4213','sollicitudin@nonegestas.net',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Kermit','Rodriquez','1-515-310-6927','dui.augue.eu@malesuadavel.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Mufutau','Peters','1-248-564-8732','ipsum@sit.org',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Hyatt','Nunez','1-651-450-9299','Praesent.interdum@etlaciniavitae.org',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Silas','Vazquez','1-557-549-9411','non@Aeneanmassa.net',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Valentine','Kelley','1-785-348-2190','aliquet.sem@magnaUt.edu',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Vernon','Meyers','1-843-681-0375','arcu.Curabitur.ut@loremsit.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Keaton','Holland','1-469-890-1937','urna.et.arcu@Phasellusdolorelit.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Clarke','Moore','1-267-286-0720','quis@nibh.edu',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Robert','Frye','1-956-169-1899','arcu.Sed@Crasegetnisi.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Allen','Cooke','1-342-714-2968','cursus@Aliquameratvolutpat.net',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Sebastian','Wooten','1-519-484-8323','faucibus@Nullamscelerisque.net',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Keane','Nielsen','1-842-976-1788','nunc.sit.amet@urnaNullam.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Drew','Everett','1-522-104-1472','eros.non.enim@est.org',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Cody','Bowman','1-817-136-0698','amet.diam@neque.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Kirk','James','1-683-405-0323','odio@adipiscinglacus.edu',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Harlan','Franklin','1-180-422-2427','Phasellus.libero@sagittis.org',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Michael','Maddox','1-786-753-1154','dignissim.pharetra@facilisis.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Ezra','Mathis','1-858-192-3084','aliquam.enim.nec@arcu.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Tad','Delaney','1-773-706-4472','nulla@lacus.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Rahim','Lee','1-822-803-9920','justo.eu@egestasDuis.net',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Ryder','Cummings','1-342-653-9166','gravida.molestie.arcu@lectus.edu',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Preston','Hopper','1-494-574-3174','lorem@gravidanuncsed.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Alfonso','Garrett','1-503-523-1480','Sed.congue.elit@magnaSuspendissetristique.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Yuli','Pratt','1-834-262-3138','libero.mauris.aliquam@fringilla.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Hayden','Pacheco','1-399-667-0169','erat.Vivamus@urna.net',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Colton','Knowles','1-508-832-0489','nisl.Nulla@massalobortisultrices.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Laith','Noble','1-640-997-3694','Nulla@elitpharetraut.net',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Murphy','Jenkins','1-866-583-6978','scelerisque@accumsansed.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Sawyer','Shepard','1-684-736-2186','sed.dui@pharetrasedhendrerit.net',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Tyler','Oneill','1-682-784-8412','ac.urna@necorciDonec.org',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Clinton','Freeman','1-117-830-4221','lobortis@Aeneansedpede.net',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Dexter','King','1-842-468-4943','aliquet.lobortis.nisi@Nullainterdum.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Wade','Rose','1-490-957-1737','Proin.mi@ipsumCurabiturconsequat.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Dexter','Bird','1-360-349-3071','eleifend@egestasFusce.edu',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Armand','Fowler','1-189-355-0670','eu.ligula@leoelementum.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Preston','Wise','1-950-848-1959','lectus.convallis@liberoProin.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Amery','Dillon','1-323-253-6992','in@pretiumnequeMorbi.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Julian','Delacruz','1-592-883-1266','Nunc@cursusluctusipsum.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Hasad','Dickson','1-338-104-0871','quam.a@bibendumullamcorperDuis.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Russell','Branch','1-532-964-7198','cubilia.Curae@justoPraesent.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Alvin','Hopper','1-876-876-7124','velit.egestas.lacinia@vulputateullamcorpermagna.net',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Cade','Richmond','1-378-872-5713','aliquet@luctus.org',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Geoffrey','Lester','1-390-234-8987','ac.mattis@nonarcuVivamus.org',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Lewis','Yang','1-761-674-2494','posuere@lectusconvallisest.org',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Joshua','Solis','1-626-591-3408','luctus@maurissit.edu',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Lewis','Morin','1-711-155-6238','congue@rutrummagnaCras.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Chancellor','Norton','1-480-856-9460','cursus.Nunc@purusgravida.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Abbot','Phillips','1-742-545-1293','euismod@erat.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Axel','Camacho','1-628-457-4327','dis.parturient@venenatisa.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Vladimir','Keith','1-640-684-6428','nibh@mauris.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Hammett','Bonner','1-135-971-7246','in@magnaPhasellus.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Dante','Rogers','1-718-574-0939','et@Fuscealiquamenim.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Lars','Kerr','1-569-848-9240','lacus@Proinvelnisl.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Knox','Hahn','1-543-880-1803','ipsum@Donec.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Hamish','Wilcox','1-785-107-9849','odio.Phasellus.at@libero.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Chaney','Faulkner','1-887-258-2065','tellus.lorem@sodalesnisi.net',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Emery','Mcintyre','1-424-311-7572','montes@vulputaterisus.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Caesar','Mccall','1-279-142-5003','ridiculus@ac.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Cadman','Sparks','1-131-995-7310','blandit@magnaUttincidunt.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Bruce','Orr','1-882-861-8786','massa.Mauris.vestibulum@Nunclectus.net',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Slade','Dalton','1-685-895-7409','pulvinar.arcu@famesacturpis.org',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Perry','Douglas','1-900-862-1140','est@enimSuspendisse.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Branden','Washington','1-433-827-2088','Ut.tincidunt.orci@estmaurisrhoncus.net',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Driscoll','Beard','1-326-348-0818','Fusce.mi.lorem@Donecegestas.org',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Seth','Fuller','1-367-276-9741','auctor@feugiattelluslorem.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Edwardfirstname','Ashleyfirstname','1-194-113-8165phone','ut.odio.vel@tempusrisusDonec.eduemail',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Jackson','Howe','1-506-511-6517','faucibus.Morbi@auguemalesuada.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Moses','Oliver','1-251-593-7577','pharetra.Nam.ac@tempor.org',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Hakeem','Poole','1-696-795-3276','Vestibulum@anteipsum.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Randall','England','1-743-467-0617','consectetuer.cursus.et@ullamcorpernisl.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Lamar','Humphrey','1-264-452-1793','sed@purus.edu',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Blake','Harrell','1-716-359-7003','Aenean.euismod@nequesedsem.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Steel','Mayo','1-159-232-1061','ridiculus@liberodui.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Adrian','Wall','1-281-645-9557','feugiat@lectussit.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Edward','Salinas','1-636-313-7758','sed.leo.Cras@euligulaAenean.org',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Finn','Woodward','1-430-269-6576','felis.ullamcorper.viverra@idenimCurabitur.net',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Edan','Jefferson','1-348-455-3714','id.magna@Nunc.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Cairo','Parsons','1-870-395-6162','porttitor.vulputate@fermentum.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Cole','Short','1-665-883-3813','tempor.lorem@ipsumcursusvestibulum.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Chaney','Gomez','1-666-638-2658','nisl@tellusimperdiet.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Eaton','Levine','1-760-414-3720','mauris.aliquam.eu@maurisSuspendissealiquet.edu',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Arsenio','Wade','1-750-269-0534','in@eleifend.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Maxwell','Oliver','1-281-457-2249','sit.amet@euismodet.edu',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Benedict','Gardner','1-797-879-6160','dapibus.id.blandit@Nuncpulvinar.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Denton','Hernandez','1-912-695-4221','neque.tellus@eusemPellentesque.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Cyrus','Head','1-670-627-3456','et@tacitisociosqu.net',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Vance','Stanley','1-208-243-2454','purus.mauris@consequatauctornunc.edu',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Xanthus','Contreras','1-361-614-1066','sed@In.edu',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Wylie','Bolton','1-801-148-9203','mi@auctornunc.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Oliver','Combs','1-420-611-2215','Cras@necenimNunc.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Galvin','Barrett','1-745-106-3516','erat@placerat.edu',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Garrison','Riley','1-463-482-3892','facilisis.magna@lobortis.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Abel','Petersen','1-645-845-4174','eget.tincidunt@posuere.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Dante','Small','1-906-735-2991','est@erat.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Honorato','Gentry','1-831-366-8271','non@Aliquam.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Louis','Burgess','1-507-811-5433','commodo@pharetranibhAliquam.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Merritt','Ross','1-277-323-1114','felis.Nulla@ornarelibero.edu',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Colby','Wynn','1-583-891-1639','ipsum.dolor@pedenec.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Tad','Head','1-106-644-2248','imperdiet@dapibus.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Ezra','Chapman','1-748-826-9639','inceptos.hymenaeos.Mauris@facilisismagnatellus.net',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Erich','Moody','1-562-170-2654','egestas.a@sagittisfelisDonec.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Chase','Moon','1-710-607-1187','tempor.est.ac@sociis.net',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Yasir','Parker','1-830-283-2136','ornare.facilisis.eget@ipsumprimis.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Yardley','Shaw','1-181-332-1843','libero@facilisisnon.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Colin','Dejesus','1-634-388-5727','Duis.elementum.dui@tristique.net',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Emerson','Holland','1-293-442-5173','ipsum.dolor.sit@sitamet.org',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Blaze','Washington','1-732-557-7913','lacinia@ultricesDuis.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Aladdin','Baker','1-130-164-2101','Nunc@porttitortellus.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Camden','Huber','1-973-713-6858','nunc.Quisque@metusvitae.edu',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Harper','Emerson','1-108-429-5228','aliquam.eu@risusIn.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Quinn','Gould','1-339-145-4246','mi.ac@ante.edu',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Dean','Robbins','1-492-619-0906','est.congue.a@aliquet.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Ferris','Fox','1-176-600-3450','dolor.quam.elementum@amet.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Russell','Hunt','1-351-981-5549','fermentum@nectempus.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Chaney','Berry','1-932-857-2020','nulla.vulputate.dui@natoquepenatibuset.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Jin','Randall','1-209-535-2843','euismod@diam.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Cain','Hobbs','1-268-479-4717','mus@arcu.net',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Jacob','Dodson','1-446-269-4848','ipsum.cursus@laoreet.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Rahim','Le','1-400-314-4569','sit.amet.nulla@tellus.net',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Hector','Stuart','1-821-930-7093','ligula@dis.net',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Baxter','Fitzpatrick','1-442-915-8573','Nullam.lobortis.quam@Cras.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Keegan','Price','1-103-893-7062','ante.lectus.convallis@dictum.net',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Bernard','Bishop','1-949-422-4503','Aenean.massa.Integer@dictumeueleifend.edu',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Gary','Jennings','1-417-403-3477','faucibus.orci@ascelerisque.org',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Wyatt','Vasquez','1-814-685-4056','Cum@nuncnullavulputate.net',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Otto','Donaldson','1-325-135-2550','ut@Donectempuslorem.org',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Ezra','Guzman','1-112-603-8834','odio@dapibusligulaAliquam.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Lionel','Alston','1-272-895-9902','dictum@duiFusce.edu',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Holmes','Alston','1-164-623-7965','non.bibendum.sed@magnis.org',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Tyler','Branch','1-432-412-2703','malesuada.fringilla@a.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Clayton','Nolan','1-485-358-8280','vitae.orci.Phasellus@vitaedolor.edu',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Wing','Cox','1-226-362-3746','justo@tempus.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Rooney','Gross','1-937-391-5191','ipsum.leo.elementum@Vestibulumante.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Laith','Mejia','1-184-396-5004','diam@ligula.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Cairo','Bird','1-720-315-3542','tellus@et.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Barclay','Woodward','1-841-390-9795','nascetur.ridiculus@velitegestas.edu',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('George','Harper','1-946-637-6810','molestie.tortor.nibh@sociisnatoque.net',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Samuel','Hayes','1-246-278-2020','orci.lobortis.augue@dolordapibusgravida.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Martin','Ferrell','1-269-542-8893','tincidunt.neque@amet.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Nehru','Oconnor','1-367-476-4793','natoque.penatibus.et@interdumligula.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Grant','Santana','1-190-844-9575','placerat.orci@conubianostra.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Abel','Snyder','1-931-171-1025','enim.nisl.elementum@egestashendrerit.edu',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Neil','Carver','1-839-267-7391','magna.Cras.convallis@aliquetliberoInteger.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Dustin','Montgomery','1-305-562-5751','sit@Curabitursed.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Oleg','Cohen','1-575-284-4401','malesuada.fringilla@nunc.net',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Cruz','Moss','1-756-462-8414','Aenean@porttitor.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Alexander','Freeman','1-314-321-7020','pharetra@pede.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Barclay','Mcdowell','1-530-675-9264','Donec.vitae.erat@Nulla.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Allen','Hale','1-125-160-3549','vel@ante.net',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Guy','Buchanan','1-227-809-2438','facilisis@ipsumprimisin.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Nicholas','Garrett','1-929-302-8584','nisi.dictum@vulputateeuodio.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Sylvester','Frank','1-869-216-8453','commodo@ullamcorperDuis.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Hu','Hooper','1-660-716-4928','sagittis@eros.org',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Kenneth','Keller','1-322-443-5978','Vivamus.nisi.Mauris@orcitincidunt.net',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Burton','Armstrong','1-607-393-7419','tellus@blandit.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('August','Carroll','1-629-869-5126','diam@Nunc.edu',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Marsden','Spears','1-552-353-5600','sociis.natoque.penatibus@nibh.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Isaac','Henry','1-463-925-5962','luctus.aliquet.odio@purusaccumsan.edu',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Nero','Franklin','1-716-213-7824','Nullam@Nunc.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Harper','Romero','1-837-273-4676','ac.facilisis@lobortis.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Dorian','Patterson','1-651-271-2084','nec@tempus.edu',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Finn','Rosario','1-601-914-5496','libero.est.congue@atnisi.ca',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Geoffrey','Howell','1-418-626-9750','dictum@magnaCrasconvallis.net',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Perry','Davidson','1-226-632-8186','hendrerit.consectetuer@sagittis.com',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Ishmael','Flowers','1-536-346-5875','nec.euismod@at.co.uk',getdate(),'system',getdate(),'system');
insert into dbo.Punchman values('Cedric','Hancock','1-848-656-6778','at.velit.Cras@lacusvarius.com',getdate(),'system',getdate(),'system');
go

print '--------------------------------------------------------------------------'
print 'Creating Table: Property'
if exists (select 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'Property')
begin
	drop table dbo.Property
end
go
create table dbo.Property
(
	Id int identity(1,1) primary key not null,
	Address1 nvarchar(100) not null,
	Address2 nvarchar(100) null,
	City nvarchar(100) not null,
	StateId int not null constraint fk_Property_State foreign key references dbo.State(Id),
	Stories int not null,
	CommunityId int not null constraint fk_Property_Community foreign key references dbo.Community(Id),
	BuilderId int null constraint fk_Property_Builder foreign key references dbo.Builder(Id),
	SupervisorId int null constraint fk_Property_Supervisor foreign key references dbo.AppUser(Id),
	AreaManagerId int null constraint fk_Property_AreaManager foreign key references dbo.AppUser(Id),
	SubContractorId int null constraint fk_Property_SubContractor foreign key references dbo.SubContractor(Id),
	PunchMan1Id int null constraint fk_Property_PunchMan1 foreign key references dbo.Punchman(Id),
	PunchMan2Id int null constraint fk_Property_PunchMan2 foreign key references dbo.Punchman(Id),
	PlanId int null constraint fk_Property_Plan foreign key references dbo.[Plan](Id),
	RoughInStatus int null constraint fk_Property_RoughInStatus foreign key references dbo.[Status](Id),
	RoughInDueDate datetime null,
	RoughInStarted datetime null,
	RoughInSupervisorId int null constraint fk_Property_RoughInSupervisor foreign key references dbo.AppUser(Id),
	TopInStatus int null constraint fk_Property_TopInStatus foreign key references dbo.[Status](Id),
	TopInDueDate datetime null,
	TopInStarted datetime null,
	TopInSupervisorId int null constraint fk_Property_TopInSupervisor foreign key references dbo.AppUser(Id),
	TopOutStatus int null constraint fk_Property_TopOutStatus foreign key references dbo.[Status](Id),
	TopOutDueDate datetime null,
	TopOutStarted datetime null,
	TopOutSupervisorId int null constraint fk_Property_TopOutSupervisor foreign key references dbo.AppUser(Id),
	Created datetime not null,
	CreatedBy nvarchar(20) not null,
	Updated datetime not null,
	UpdatedBy nvarchar(20) not null
)
go
insert into dbo.Property values('2186 Felis St.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('Ap #633-4720 Enim, Avenue',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('415-8781 Nam Rd.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('3369 Et, Av.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('P.O. Box 277, 1799 Dignissim Ave',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('Ap #315-3181 Mi. Street',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('Ap #244-6755 Imperdiet St.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('824-9890 Taciti Avenue',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('6042 Erat Road',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('P.O. Box 876, 6108 Vivamus Street',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('P.O. Box 679, 7322 A Rd.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('3024 Metus. Road',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('814-5919 Placerat Av.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('4499 Facilisis St.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('8595 Eleifend Rd.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('231-2368 Euismod Rd.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('Ap #701-7693 Accumsan Av.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('6941 Luctus, Avenue',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('7066 Cras Av.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('P.O. Box 274, 8263 Mauris Ave',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('Ap #192-2498 Nunc Ave',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('329-5377 Risus. St.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('P.O. Box 461, 8968 Eu Rd.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('984-1590 Risus Road',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('5587 Diam Rd.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('917-3519 Ultrices Ave',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('Ap #140-4969 Cum Rd.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('Ap #240-8232 Tincidunt Street',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('9436 Senectus Rd.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('119-2070 Mollis Rd.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('754-7676 Dolor. St.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('P.O. Box 118, 8842 Libero. St.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('P.O. Box 862, 9266 Lobortis, St.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('Ap #405-1146 Egestas Rd.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('596-1000 Lorem, Street',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('3465 Tellus Street',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('2314 Laoreet Ave',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('P.O. Box 537, 1360 Est St.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('690-7297 Magnis Road',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('P.O. Box 100, 5977 Fermentum Street',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('311-3293 Donec Road',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('176-5863 Eros Street',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('P.O. Box 170, 504 Cras Rd.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,getdate(),'system',getdate(),'system');
insert into dbo.Property values('P.O. Box 481, 1356 Ipsum. Road',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,getdate(),'system',getdate(),'system');
insert into dbo.Property values('P.O. Box 655, 2232 Non, St.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,getdate(),'system',getdate(),'system');
insert into dbo.Property values('8743 Luctus Street',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,getdate(),'system',getdate(),'system');
insert into dbo.Property values('557-1020 Blandit Ave',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,getdate(),'system',getdate(),'system');
insert into dbo.Property values('4876 Auctor Rd.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,getdate(),'system',getdate(),'system');
insert into dbo.Property values('Ap #626-9796 Nonummy Av.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,getdate(),'system',getdate(),'system');
insert into dbo.Property values('P.O. Box 687, 4233 At Street',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,getdate(),'system',getdate(),'system');
insert into dbo.Property values('2491 Fermentum St.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,getdate(),'system',getdate(),'system');
insert into dbo.Property values('Ap #619-5701 Magnis Ave',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,getdate(),'system',getdate(),'system');
insert into dbo.Property values('Ap #203-3782 Aliquam Road',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,getdate(),'system',getdate(),'system');
insert into dbo.Property values('P.O. Box 948, 5601 Aliquet. Rd.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,getdate(),'system',getdate(),'system');
insert into dbo.Property values('Ap #344-6902 Ligula. Rd.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,getdate(),'system',getdate(),'system');
insert into dbo.Property values('P.O. Box 537, 6363 Erat Street',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,getdate(),'system',getdate(),'system');
insert into dbo.Property values('P.O. Box 528, 7257 Sed St.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,getdate(),'system',getdate(),'system');
insert into dbo.Property values('7400 Interdum. St.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,getdate(),'system',getdate(),'system');
insert into dbo.Property values('901-6775 Tempor Street',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,getdate(),'system',getdate(),'system');
insert into dbo.Property values('5467 At Avenue',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,getdate(),'system',getdate(),'system');
insert into dbo.Property values('Ap #378-5060 Quam Avenue',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,getdate(),'system',getdate(),'system');
insert into dbo.Property values('144-2865 In Av.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,getdate(),'system',getdate(),'system');
insert into dbo.Property values('Ap #178-8223 At Av.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,getdate(),'system',getdate(),'system');
insert into dbo.Property values('P.O. Box 517, 2005 Metus Road',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,getdate(),'system',getdate(),'system');
insert into dbo.Property values('9154 Ante. St.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,getdate(),'system',getdate(),'system');
insert into dbo.Property values('Ap #167-2671 Quisque Street',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,getdate(),'system',getdate(),'system');
insert into dbo.Property values('452-5562 Tempus Road',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,getdate(),'system',getdate(),'system');
insert into dbo.Property values('P.O. Box 325, 1444 Amet, Rd.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,null,null,null,null,null,null,null,null,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,getdate(),'system',getdate(),'system');
insert into dbo.Property values('7752 Auctor Rd.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('9653 Sed Rd.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('P.O. Box 890, 2125 Sed St.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('P.O. Box 816, 7051 Proin St.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('Ap #243-9644 Erat Rd.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('P.O. Box 561, 6556 At, Av.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('415-313 Pede. Street',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('P.O. Box 432, 2427 Dui St.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('391-2697 Egestas St.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('100 Suspendisse Ave',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('P.O. Box 746, 6971 Malesuada Av.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('3376 Lorem Ave',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('7547 Lorem Road',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('4775 Dapibus Av.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('7384 Fusce St.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('P.O. Box 275, 2239 Dictum Av.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('6701 Purus Street',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('7976 Pede Avenue',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('Ap #971-8496 Aliquet Ave',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('Ap #177-6924 Cras Rd.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('4031 Eu Ave',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('Ap #978-4885 Sed Av.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('438-6348 Non, Rd.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('P.O. Box 721, 5702 Vel Avenue',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('3014 Arcu Rd.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('P.O. Box 180, 8603 Sollicitudin St.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('2827 Mi Street',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('Ap #269-1217 Nullam St.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('Ap #177-7630 Magna. Ave',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('Ap #518-4388 In Ave',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('P.O. Box 934, 9478 Sed St.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
insert into dbo.Property values('P.O. Box 250, 4444 Tempus, St.',null,'Dallas',44,(ABS(Checksum(NewID()) % 2) + 1),ABS(Checksum(NewID()) % (select count(*) from Community)) + 1,ABS(Checksum(NewID()) % (select count(*) from Builder)) + 1,1,1,ABS(Checksum(NewID()) % (select count(*) from SubContractor)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,ABS(Checksum(NewID()) % (select count(*) from PunchMan)) + 1,1,ABS(Checksum(NewID()) % 2) + 1,DATEADD(day,5,getdate()),getdate(),1,null,null,null,null,null,null,null,null,getdate(),'system',getdate(),'system');
go


print '--------------------------------------------------------------------------'
print 'Creating Table: PropertyXPreWalk'
if exists (select 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'PropertyXPreWalk')
begin
	drop table dbo.PropertyXPreWalk
end
go
create table dbo.PropertyXPreWalk
(
	Id int identity(1,1) primary key not null, 
	PropertyId int not null constraint fk_PropertyXPreWalk_Property foreign key references dbo.Property(Id),
	StatusId int not null constraint fk_PropertyXPreWalk_Status foreign key references dbo.[Status](Id),
	ExtensionRequested bit null,
	ExtensionApproved bit null,
	DueDate datetime not null,
	Created datetime not null,
	CreatedBy nvarchar(20) not null,
	Updated datetime not null,
	UpdatedBy nvarchar(20) not null
)
go
insert into dbo.PropertyXPreWalk values(1,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXPreWalk values(2,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXPreWalk values(3,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXPreWalk values(4,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXPreWalk values(5,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXPreWalk values(6,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXPreWalk values(7,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXPreWalk values(8,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXPreWalk values(9,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXPreWalk values(10,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXPreWalk values(11,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXPreWalk values(12,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXPreWalk values(13,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXPreWalk values(14,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXPreWalk values(15,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXPreWalk values(16,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXPreWalk values(17,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXPreWalk values(18,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXPreWalk values(19,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXPreWalk values(20,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXPreWalk values(21,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXPreWalk values(22,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXPreWalk values(23,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXPreWalk values(24,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXPreWalk values(25,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXPreWalk values(26,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXPreWalk values(27,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXPreWalk values(28,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXPreWalk values(29,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXPreWalk values(30,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXPreWalk values(31,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXPreWalk values(32,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXPreWalk values(33,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
go

select * from PropertyXPreWalk

print '--------------------------------------------------------------------------'
print 'Creating Table: PropertyXKickOff'
if exists (select 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'PropertyXKickOff')
begin
	drop table dbo.PropertyXKickOff
end
go
create table dbo.PropertyXKickOff
(
	Id int identity(1,1) primary key not null, 
	PropertyId int not null constraint fk_PropertyXKickOff_Property foreign key references dbo.Property(Id),
	StatusId int not null constraint fk_PropertyXKickOff_Status foreign key references dbo.[Status](Id),
	ExtensionRequested bit null,
	ExtensionApproved bit null,
	DueDate datetime not null,
	Created datetime not null,
	CreatedBy nvarchar(20) not null,
	Updated datetime not null,
	UpdatedBy nvarchar(20) not null
)
go
insert into dbo.PropertyXKickOff values(34,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXKickOff values(35,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXKickOff values(36,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXKickOff values(37,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXKickOff values(38,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXKickOff values(39,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXKickOff values(40,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXKickOff values(41,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXKickOff values(42,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXKickOff values(43,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXKickOff values(44,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXKickOff values(45,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXKickOff values(46,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXKickOff values(47,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXKickOff values(48,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXKickOff values(49,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXKickOff values(50,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXKickOff values(51,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXKickOff values(52,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXKickOff values(53,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXKickOff values(54,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXKickOff values(55,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXKickOff values(56,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXKickOff values(57,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXKickOff values(58,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXKickOff values(59,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXKickOff values(60,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXKickOff values(61,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXKickOff values(62,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXKickOff values(63,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXKickOff values(64,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXKickOff values(65,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXKickOff values(66,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
go

print '--------------------------------------------------------------------------'
print 'Creating Table: PropertyXWalkThrough'
if exists (select 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'PropertyXWalkThrough')
begin
	drop table dbo.PropertyXWalkThrough
end
go
create table dbo.PropertyXWalkThrough
(
	Id int identity(1,1) primary key not null, 
	PropertyId int not null constraint fk_PropertyXWalkThrough_Property foreign key references dbo.Property(Id),
	StatusId int not null constraint fk_PropertyXWalkThrough_Status foreign key references dbo.[Status](Id),
	ExtensionRequested bit null,
	ExtensionApproved bit null,
	DueDate datetime not null,
	Created datetime not null,
	CreatedBy nvarchar(20) not null,
	Updated datetime not null,
	UpdatedBy nvarchar(20) not null
)
go
insert into dbo.PropertyXWalkThrough values(67,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(68,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(69,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(70,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(71,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(72,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(73,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(74,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(75,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(76,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(77,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(78,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(79,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(80,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(81,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(82,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(83,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(84,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(85,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(86,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(87,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(88,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(89,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(90,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(91,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(92,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(93,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(94,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(95,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(96,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(97,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(98,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(99,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
insert into dbo.PropertyXWalkThrough values(100,ABS(Checksum(NewID()) % 2) + 1,null,null,DATEADD(day,2,getdate()),getdate(),'system',getdate(),'system');
go

print '--------------------------------------------------------------------------'
print 'Creating Table: History'
if exists (select 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'History')
begin
	drop table dbo.History
end
go
create table dbo.History
(
	Id int identity(1,1) primary key not null, 
	[Action] nvarchar(20) not null,
	DateOfAction datetime not null,
	ActionBy nvarchar(20) not null
)
go

print '--------------------------------------------------------------------------'
print 'Creating Table: HistoryByColumn'
if exists (select 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'HistoryByColumn')
begin
	drop table dbo.HistoryByColumn
end
go
create table dbo.HistoryByColumn
(
	Id int identity(1,1) primary key not null, 
	TableName nvarchar(20) not null,
	ColumnName nvarchar(20) not null,
	[Action] nvarchar(20) not null,
	DateOfAction datetime not null,
	ActionBy nvarchar(20) not null
)
go
