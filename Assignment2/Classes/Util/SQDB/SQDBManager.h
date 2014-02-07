//
//  BDManager.h
//  SQDB
//
//  Created by Alexandre Oliveira Santos on 23/08/12.
//  Copyright (c) 2012 Squadra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

/**
 Classe base gerenciadora de uma base de dados sqlite.
 Esta classe encapsula operações básicas de criação, conexão e execução de _queries_ e transações no banco.
 Utiliza classes do projeto _open source_ *FMDB*.
 */

@interface SQDBManager : NSObject

/**---------------------------------------------------------------------------------------
 * @name Propriedades
 * ---------------------------------------------------------------------------------------
 */
/**
 * A fila onde são executadas as _queries_ e transações.
 */
@property (strong, readonly) FMDatabaseQueue *dbQueue;

/**---------------------------------------------------------------------------------------
 * @name Diretórios
 * ---------------------------------------------------------------------------------------
 */

/**
 * @return Retorna o diretório _Library_ do aplicativo atual.
 */
+ (NSString *) libraryDirPath;
/**
 * @return Retorna o diretório _Documents_ do aplicativo atual.
 */
+ (NSString *) documentsDirPath;

/**
 * @param fileName Nome do arquivo do banco de dados _sqlite_.
 * @return Retorna o caminho completo do arquivo _sqlite_ do banco de dados.
 */
+ (NSString *) dbFilePathWithFileName:(NSString *) fileName;

/**
 * @param fileName Nome do arquivo do banco de dados _sqlite_.
 * @return Retorna `YES` caso o arquivo indicado exista e `NO` caso contrário.
 */
+ (BOOL) isDBFileCreatedWithName:(NSString *) fileName;

/**---------------------------------------------------------------------------------------
 * @name Instanciação de Objetos
 * ---------------------------------------------------------------------------------------
 */

/**
 * Cria um gerenciador de banco de dados com o nome de arquivo especificado.
 * @param fileName Nome do arquivo onde se encontra o banco de dados. Caso não exista, será criado um novo arquivo.
 * @return Uma nova instância de um gerenciador.
 */
- (id) initWithFileName:(NSString *) fileName;

/**---------------------------------------------------------------------------------------
 * @name Gerenciamento de Conexão
 * ---------------------------------------------------------------------------------------
 */

/**
 * Abre uma nova conexão com o banco de dados especificado em `fileName`.
 * @param fileName Nome do arquivo onde se encontra o banco de dados. Caso não exista, será criado um novo arquivo.
 * @return `YES` em caso de sucesso e `NO` caso contrário.
 */
- (BOOL) openDBWithFileName:(NSString *) fileName;

/**
 * Fecha a conexão atual com o banco de dados.
 */
- (void) closeDB;

/**---------------------------------------------------------------------------------------
 * @name Execução de SQL
 * ---------------------------------------------------------------------------------------
 */

/**
 * Enfileira as _queries_ e comandos SQL contidos em `sql` para serem executados em _background_.
 * @param sql Bloco que contém as _queries_ e comandos SQL a serem executados.
 * @param finish Bloco chamado na _thread_ principal ao final da execução do SQL.
 */
- (void) runInBackground:(void (^)(FMDatabase *db))sql finishBlock:(void (^)(void))finish;
/**
 * Enfileira o SQL em uma transação para ser executada em _background_.
 * @param sql Bloco que contém as _queries_ e comandos SQL a serem executados.
 * @param finish Bloco chamado na _thread_ principal ao final da execução da transação SQL.
 */
- (void) transactionInBackground:(void (^)(FMDatabase *db, BOOL *rollback))sql finishBlock:(void (^)(void))finish;

/**
 * Enfileira as _queries_ e comandos SQL contidos no arquivo para serem executados em _background_.
 * @param filePath Caminho absoluto do arquivo que contém as _queries_ e comandos SQL a serem executados.
 * @param finish Bloco chamado na _thread_ principal ao final da execução do SQL.
 */
- (void) runBackgroundScriptFromFilePath:(NSString *) filePath finishBlock:(void (^)(BOOL success, NSError *error))finish;

/**
 * Enfileira as _queries_ e comandos SQL contidos no arquivo para serem executados na _thread_ atual.
 * @param filePath Caminho absoluto do arquivo que contém as _queries_ e comandos SQL a serem executados.
 * @param error Objeto `NSError` que será preenchido caso tenha ocorrido algum erro.
 * @return `YES` em caso de sucesso e `NO` caso contrário.
 */
- (BOOL) runScriptFromFilePath:(NSString *) filePath error:(NSError **) error;

/**
 * Enfileira as _queries_ e comandos SQL contidos no arquivo para serem executados na _thread_ atual.
 * @param fileName Nome do arquivo que contém as _queries_ e comandos SQL a serem executados.
 * @param error Objeto `NSError` que será preenchido caso tenha ocorrido algum erro.
 * @return `YES` em caso de sucesso e `NO` caso contrário.
 */
- (BOOL) runScriptFromResourceFile:(NSString *) fileName error:(NSError **) error;

@end
