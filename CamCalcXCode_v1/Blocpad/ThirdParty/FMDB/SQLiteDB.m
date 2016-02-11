//
//  SQLiteDB.m
//  WetCement
//
//  Created by Hugh Lang on 7/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SQLiteDB.h"

@implementation SQLiteDB

@synthesize dbpath;
//@synthesize _database;
static FMDatabase *dbInstance = nil;
static NSString *sourceDbPath = @"blocpad.sqlite";

+ (FMDatabase *) sharedConnection {
    @synchronized(self)
    {
        
        if (dbInstance == nil) {
//            NSArray *pathsToDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//            NSString *documentsDirectory = [pathsToDocuments objectAtIndex:0];
//
//            NSString *resourcePath = [documentsDirectory stringByAppendingPathComponent:@"blocpad.sqlite"];
            NSString *resourcePath = [self getDBfilepath];

            BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:resourcePath];
            
            if ( exists ) { 
                NSLog(@"Found database at resourcePath=%@", resourcePath);
                
            } else {
                NSLog(@"Database does not exist at %@", resourcePath);
                return nil; 
            }

            
            dbInstance = [FMDatabase databaseWithPath:resourcePath];
            
            if (![dbInstance open]) {
                NSLog(@"Database not open");
            }

        }
        return dbInstance;
    }
}
+ (FMDatabaseQueue *) sharedQueue {
    NSString *resourcePath = [self getDBfilepath];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:resourcePath];
    return queue;
}
// This is only used for unit tests
+ (FMDatabase *) testConnection {
    @synchronized(self)
    {
        
        if (dbInstance == nil) {
            
//            NSString *dataDirectory = @"/Users/hlang/Library/Application Support/iPhone Simulator/6.1/Applications/92C617B8-2420-4EAA-BEC0-05F5E9D371CC/Blocpad.app/";
            
            NSString *dataDirectory = @"/Sandbox/BLOC/blocpad/Blocpad/Resources/Data/";
            NSString *resourcePath = [dataDirectory stringByAppendingPathComponent:@"blocpad.sqlite"];
            BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:resourcePath];
            
            if ( exists ) {
                NSLog(@"Found database at resourcePath=%@", resourcePath);
                
            } else {
                NSLog(@"Database does not exist at %@", resourcePath);
                return nil;
            }
            
            
            dbInstance = [FMDatabase databaseWithPath:resourcePath];
            
            if (![dbInstance open]) {
                NSLog(@"Database not open");
            }
            
        }
        return dbInstance;
    }
}

+ (NSString *) getDBfilepath {
    NSArray *pathsToDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [pathsToDocuments objectAtIndex:0];
    
    NSString *filepath = [documentsDirectory stringByAppendingPathComponent:@"blocpad.sqlite"];
    return filepath;

}
+(BOOL) installDatabase {
    
    // Get the path to the main bundle resource directory.
    
    NSString *pathsToResources = [[NSBundle mainBundle] resourcePath];
    
    NSString *yourOriginalDatabasePath = [pathsToResources stringByAppendingPathComponent:sourceDbPath];
    
    // Create the path to the database in the Documents directory.
    
    NSArray *pathsToDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [pathsToDocuments objectAtIndex:0];
    
    NSString *yourNewDatabasePath = [documentsDirectory stringByAppendingPathComponent:@"blocpad.sqlite"];
    
    NSLog(@"Ready to copy database from %@ to %@", yourOriginalDatabasePath, yourNewDatabasePath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success;
    NSError *error;
    
    success = [fileManager fileExistsAtPath:yourNewDatabasePath];
    if ( success ) { 
        NSLog(@"Database already exists at %@", yourNewDatabasePath);
        //        return YES; 
    }
    
    success = [fileManager copyItemAtPath:yourOriginalDatabasePath toPath:yourNewDatabasePath error:&error];
    
    if (success) {
        NSLog(@"Installed database at %@", yourNewDatabasePath);
        return YES;
    } else {
        NSLog(@"Failed to install database at %@", yourNewDatabasePath);
        return NO;
    }
}

@end
