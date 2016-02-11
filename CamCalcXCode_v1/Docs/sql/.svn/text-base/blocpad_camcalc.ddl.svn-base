CREATE TABLE IF NOT EXISTS config ( 
    calcId INTEGER 
);

CREATE TABLE IF NOT EXISTS calculation ( 
    calcId INTEGER,
    calcDate TEXT,
	qtrname TEXT,
	vialPrice REAL,
	finalInd INTEGER
);


CREATE TABLE IF NOT EXISTS contract ( 
    contractId INTEGER,  
    groupName TEXT, 
    city TEXT,
    state TEXT, 
    zipcode TEXT,
    camName TEXT,
    territory TEXT,
    effectiveDate TEXT,
    gpoName TEXT,
    avgPrevYear REAL,
    specialInd INTEGER,
    newInd INTEGER,
    search_text TEXT
);


CREATE TABLE IF NOT EXISTS rebate_history ( 
    contractId INTEGER,  
    qtrname TEXT, 
    totalRebateAdj REAL
);

CREATE TABLE IF NOT EXISTS vial_history ( 
    contractId INTEGER,  
    qtrname TEXT, 
    actUnits INTEGER
);
