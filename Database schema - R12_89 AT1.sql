CREATE TABLE Employee (
	EmpID INT NOT NULL PRIMARY KEY,
	DateOfBirth DATE NOT NULL,
	Name VARCHAR(50) NOT NULL,
	HomeAddress VARCHAR(100) NOT NULL
);

/* 9 - A particular Employee has not been issued with any device - allowed - employee doesn’t need a device, but a device needs an employee

12 - A particular employee used two devices - allowed - employee can use multiple devices, but device only issued to one
14 - A particular employee has not used any device - allowed - employee does not require a device, but a device requires an employee*/



CREATE TABLE Model (
  ModelNumber INT UNIQUE NOT NULL,
  Manufacturer VARCHAR(20) UNIQUE NOT NULL,
  Description VARCHAR(200) NOT NULL,
  Weight INTEGER NOT NULL,
  PRIMARY KEY (ModelNumber, Manufacturer)
);

/* Two models were allocated to the same department. - allowed, departments can have as many models allocated to them
A particular model was allocated to three departments. - allowed, models can be allocated to as many departments

A particular model has not been allocated to any department. - allowed, models are independent and any amount of departments can be allocated including none */

CREATE TABLE Device (
  DeviceID INT NOT NULL PRIMARY KEY,
  PurchaseDate DATE NOT NULL,
  SerialNumber BIGINT NOT NULL,
  PurchaseCost MONEY NOT NULL,
  EmpID INT NOT NULL REFERENCES Employee(EmpID),
  IsAPhone BOOLEAN NOT NULL,
  maxAllocations INT NOT NULL,
  ModelNumber INT NOT NULL REFERENCES Model(ModelNumber),
  Manufacturer VARCHAR(20) NOT NULL REFERENCES Model(Manufacturer) 
  
);

/* 5. There is a device which is not a phone - allowed, the ‘isAPhone’ attribute of the Device table is a boolean allowing true or false value to be stored, not all devices need to be phones.
6. A particular device was issued to three employees - not allowed, the EmpID attribute allows only 1 employee to be issued any given device.
7. A particular employee was issued two devices - allowed. Since each device may only be issued to one employee, but an employee can have 0 or more devices, the foreign key link only happens from device to employee and therefore an employee can be issued two different devices.
A particular device was used by one employee. - Allowed, devices can be used by an employee
8 - A particular device was not issued to any employee - not allowed - EmpID is not null
10 - A particular device was issued to one employee - allowed - device has at most one employee
11 - A particular device was used by three employees - allowed - no restriction
13 - A particular device was not used by any employee - allowed - thin line implies no ‘at least’ */


CREATE TABLE Service (
	ABN VARCHAR(11) NOT NULL PRIMARY KEY,
	ServiceName VARCHAR(50) NOT NULL,
	Owed INT,
	Email VARCHAR(75) NOT NULL
);

CREATE TABLE Repair (
  RepairID INT NOT NULL PRIMARY KEY,
  StartDate DATE NOT NULL,
  EndDate DATE NOT NULL,
  FaultReport VARCHAR(150) NOT NULL,
  Cost MONEY NOT NULL,
	DeviceID INT NOT NULL REFERENCES Device(DeviceID),
	ABN VARCHAR(11) NOT NULL REFERENCES Service(ABN)
);

/* 1. A particular device is repaired twice - allowed, a repair connects to one device but there can be many repairs with the same deviceID as there is no UNIQUE constraint on that value.
2. A particular device was never repaired - allowed, each repair has one device but no requirement for a repair to exist for each device.
3. One repair fixes two devices - not allowed, this is not possible as only 1 deviceID can be associated with a repair.
4. A particular repair is not done to any device - not allowed, this is restricted by the NOT NULL constraint on the deviceID attribute of the Repair table. */

CREATE TABLE Phone (
  DeviceID INT NOT NULL PRIMARY KEY REFERENCES Device(DeviceID),
  Number BIGINT NOT NULL,
  plan VARCHAR(30) NOT NULL,
  carrier VARCHAR(50) NOT NULL
);



CREATE TABLE EmployeePhoneNumbers (
	EmpID INT NOT NULL REFERENCES Employee(EmpID),
	PhoneNumber INTEGER NOT NULL PRIMARY KEY
);


/* A particular department has not had any model allocated to it. - allowed, departments are independent and any amount of models can be allocated including none */

CREATE TABLE Department (
	Name VARCHAR(50) NOT NULL PRIMARY KEY,
	Budget INT NOT NULL
);

CREATE TABLE DepartmentOfficeLocations (
	DepName VARCHAR(50) NOT NULL REFERENCES Department(Name),
	OfficeLocation VARCHAR(100) NOT NULL PRIMARY KEY
);




CREATE TABLE DepartmentModels (
	DepName VARCHAR(50) NOT NULL REFERENCES Department(Name),
  ModelNumber INT NOT NULL REFERENCES Model(ModelNumber),
  PRIMARY KEY (DepName, ModelNumber)
);

CREATE TABLE DeviceUsage (
  DeviceID INT NOT NULL REFERENCES Device(DeviceID),
  EmpID INT NOT NULL REFERENCES Employee(EmpID)
);

CREATE TABLE DepartmentEmployees (
	DepName VARCHAR(50) NOT NULL REFERENCES Department(Name),
  EmpID INT NOT NULL REFERENCES Employee(EmpID),
  PRIMARY KEY (DepName, EmpID)
);
