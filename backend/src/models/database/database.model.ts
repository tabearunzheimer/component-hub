import { Connection, OkPacket, RowDataPacket } from 'mysql2';
import { CustomErrorHandler } from '../../services/error.service';

type DB_Connection = Connection

export interface I_DB_Settings {
    host: string,
    user: string,
    password: string,
    port: number,
    connectionLimit: number
}

export type DbDefaults = RowDataPacket[] | RowDataPacket[][] | OkPacket[] | OkPacket;
export type DbQueryResult<T> = T & DbDefaults;
export type DBReturn<T> = T | (T & RowDataPacket) | (T & RowDataPacket[]) | (T & OkPacket)

export interface DB {
    getConnection(query: string): Promise<DB_Connection>;
    closeConnection(): Promise<void | Error>;
    query<T>(sql: string, options?: unknown): Promise<DBReturn<T> | CustomErrorHandler>; 
}

export type DBFunction<T> = (...args: any[]) => Promise<CustomErrorHandler | T>; //eslint-disable-line