import { KnexDatabase } from '../../database/knex.database';

export abstract class Service {

    db: KnexDatabase | undefined;

    constructor(databaseHandler?: KnexDatabase) {
        this.db = databaseHandler;
    }

}
