import { Knex, knex } from 'knex';
import * as knexfile from './knexfile';
import { DBFunction } from '../models/database/database.model';
import { CustomErrorHandler } from '../services/error.service';
 
export const db = knex(knexfile);

export class KnexDatabase {
    
    db: Knex;

    constructor() {
        this.db = knex(knexfile);
    }

    queryWrapper<T>(func: DBFunction<T>): DBFunction<T> {
        return async (...args: any[]): Promise<CustomErrorHandler | T> => { //eslint-disable-line
            try {
                return await func(...args);
            } catch (error) {
                console.error('Error in database operation:', error);
                return new CustomErrorHandler(500, 'Internal Server Error', 'An error occurred while processing your request.');
            }
        };
    }

}