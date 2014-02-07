//
//  DatabaseManager.h
//  Assignment2
//
//  Created by Alexandre on 07/02/14.
//  Copyright (c) 2014 Avenue Code. All rights reserved.
//

#import "SQDBManager.h"
#import "SQMacros.h"

@interface SQDBManager ()

@property (strong, readwrite) FMDatabaseQueue *dbQueue;

@end

@implementation SQDBManager
@synthesize dbQueue = _dbQueue;

#pragma mark - Private Methods

- (void)dispatchInBackground:(void (^)(void))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

- (void)dispatchOnMainThread:(void (^)(void))block {
    // If a block is submitted to the queue that is already on the main run loop,
    // the thread will block forever waiting for the completion of the block -- which will never happen.
    if ([NSThread currentThread] == [NSThread mainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

#pragma mark - Helper Methods

+ (NSString *) libraryDirPath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return path;
}

+ (NSString *) documentsDirPath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return path;
}

+ (NSString *) dbFilePathWithFileName:(NSString *) fileName
{
    return [[self libraryDirPath] stringByAppendingPathComponent:fileName];
}

+ (BOOL) isDBFileCreatedWithName:(NSString *) fileName
{
    NSString *absolutPath = [[self class] dbFilePathWithFileName:fileName];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:absolutPath];
}

- (id) initWithFileName:(NSString *) fileName
{
    self = [self init];
    
    if(self)
    {
        if(![self openDBWithFileName:fileName])
        {
            SQLog(@"Não foi possível abrir arquivo do banco: %@", [[self class] dbFilePathWithFileName:fileName]);
            return nil;
        }
    }
    
    return self;
}

- (BOOL) openDBWithFileName:(NSString *) fileName
{
    BOOL success = YES;
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[[self class] dbFilePathWithFileName:fileName]];
    self.dbQueue = queue;
    
    if(queue == nil)
        success = NO;
        
    return success;
}

- (void) closeDB
{
    [self.dbQueue close];
}

- (void) runInBackground:(void (^)(FMDatabase *db))sql finishBlock:(void (^)(void))finish
{
    // Executa em background
    [self dispatchInBackground:^{
        
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            sql(db);
        }];
        
        // Terminou a execução, chama o bloco na thread de interface
        [self dispatchOnMainThread:^{
            finish();
        }];
    }];
}

- (void) transactionInBackground:(void (^)(FMDatabase *db, BOOL *rollback))sql finishBlock:(void (^)(void))finish
{
    // Executa em background
    [self dispatchInBackground:^{
        
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            sql(db, rollback);
        }];
        
        // Terminou a execução da transação, chama o bloco na thread de interface
        [self dispatchOnMainThread:^{
            finish();
        }];
    }];
}

- (void) runBackgroundScriptFromFilePath:(NSString *) filePath finishBlock:(void (^)(BOOL success, NSError *error))finish
{
    __block NSError *_error = nil;
    __block BOOL _success = NO;
    
    // Executa em background
    [self dispatchInBackground:^{
        
        _success = [self runScriptFromFilePath:filePath error:&_error];
        
        // Terminou a execução do script, chama o bloco `finish` na thread de interface
        [self dispatchOnMainThread:^{
            finish(_success, _error);
        }];
    }];
}

- (BOOL) runScriptFromFilePath:(NSString *) filePath error:(NSError **) error
{
    __block BOOL _success = YES;
    
    // Extrai os comandos do arquivo
    NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:error];
    
    if(fileContents)
    {
        NSArray *allStatements = [fileContents componentsSeparatedByString:@";"];
        NSMutableArray *sqlStatements = [NSMutableArray arrayWithCapacity:[allStatements count]];
        
        // Remove os comentários -- e as linhas vazias
        for (NSString *sqlStatement in allStatements)
        {
            if([sqlStatement length] > 0)
            {
                NSMutableString *sqlCommand = nil;
                
                NSArray *sqlLines = [sqlStatement componentsSeparatedByString:@"\n"];
                
                // Limpa o comando SQL
                for (NSString *sqlLine in sqlLines)
                {
                    if([sqlLine length] > 0)
                    {
                        NSRange rangeComment = [sqlLine rangeOfString:@"--"];
                        // Ignora os comentário
                        if(rangeComment.location == NSNotFound)
                        {
                            if(sqlCommand == nil)
                                sqlCommand = [NSMutableString stringWithCapacity:[sqlLine length]];
                            
                            [sqlCommand appendFormat:@"%@ ", sqlLine];
                        }
                    }
                }
                
                if([sqlCommand length] > 0)
                    [sqlStatements addObject:sqlCommand];
            }
        }
        
        // Executa os comandos
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            for (NSString *sqlStatement in sqlStatements)
            {
                _success = [db executeUpdate:sqlStatement, nil];
                
                if(_success == NO)
                    *error = [db lastError];
            }
        }];
    }
    
    return _success;
}

- (BOOL) runScriptFromResourceFile:(NSString *) fileName error:(NSError **) error
{
    NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    return [self runScriptFromFilePath:filePath error:error];
}

- (void) dealloc
{
    SQRelease(_dbQueue);
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

@end
