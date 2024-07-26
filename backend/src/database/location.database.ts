import { ResultSetHeader } from 'mysql2';
import { I_Location_Id, I_Location_Database, I_Location, I_Component_Location } from '../models/location/location.model';
import { CustomErrorHandler } from '../services/error.service';

import { KnexDatabase } from './knex.database';

export class LocationDatabase extends KnexDatabase implements I_Location_Database {

    getComponentLocationByComponentIdDB(componentId: number): Promise<I_Component_Location[] | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('componentLocation').where({ componentId });
        })();
    }
    getComponentLocationByLocationIdDB(locationId: number): Promise<I_Component_Location[] | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('componentLocation').where({ locationId });
        })();
    }
    addComponentLocationByIdDB(locationId: number, componentId: number): Promise<number | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('componentLocation').insert({ locationId, componentId });
        })();
    }
    deleteComponentLocationByIdDB(locationId: number, componentId: number): Promise<number | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('componentLocation').where({ locationId, componentId }).del();
        })();
    }
    
    uploadImageDB(path: string, locationId: number): Promise<number | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db.transaction(async (trx) => {
                const result = await trx('files').insert({ path, type: 'image' }, 'fileId');
                if (result instanceof CustomErrorHandler) return result;
                await trx('fileStore').insert({fileId: result[0], locationId})
                return result[0] as number;
            })
        })();
    }

    deleteImageDB(fileId: number, locationId: number): Promise<number | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db.transaction(async (trx) => {
                let result = await trx('files').where({ fileId }).delete();
                result = await trx('fileStore').where({fileId, locationId}).delete();
                return result;
            })
        })();
    }

    getFilePath(fileId: number): Promise<string[]|CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('files')
                .where({fileId});
        })();
    }


    async getLocationsByNameDB(name: string, orderBy?: string, sortOrder?: string): Promise<CustomErrorHandler | I_Location_Id[]> {
        if (orderBy && sortOrder) {
            return this.queryWrapper(async () => {
                return this.db('locations')
                    .where(builder => {
                        void builder.whereRaw('LOWER(description) LIKE ?', [`%${name.toLowerCase()}%`])
                            .orWhereRaw('LOWER(name) LIKE ?', [`%${name.toLowerCase()}%`]);
                    })
                    .orderBy(orderBy, sortOrder);
            })();
        } else if (orderBy) {
            return this.queryWrapper(async () => {
                return this.db('locations')
                    .where(builder => {
                        void builder.whereRaw('LOWER(description) LIKE ?', [`%${name.toLowerCase()}%`])
                            .orWhereRaw('LOWER(name) LIKE ?', [`%${name.toLowerCase()}%`]);
                    })
                    .orderBy(orderBy, 'asc');
            })();
        } else {
            return this.queryWrapper(async () => {
                return this.db('locations')
                    .where(builder => {
                        void builder.whereRaw('LOWER(description) LIKE ?', [`%${name.toLowerCase()}%`])
                            .orWhereRaw('LOWER(name) LIKE ?', [`%${name.toLowerCase()}%`]);
                    });
            })();
        }
    }

    async importLocationsDB(location: I_Location): Promise<CustomErrorHandler | I_Location_Id[]> {
        return this.queryWrapper(async () => {
            return this.db('locations').insert(location);
        })();
    }

    async getAllLocationsDB(): Promise<I_Location_Id[] | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('locations') as Promise<I_Location_Id[] | CustomErrorHandler>;
        })();
    }
    async createLocationDB(name: string, description: string): Promise<ResultSetHeader | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('locations').insert({ name, description });
        })();
    }
    async getLocationByIdDB(locationId: number): Promise<I_Location_Id[] | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('locations').where({ locationId });
        })();
    }
    async deleteLocationByIdDB(locationId: number): Promise<number | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('locations').where({ locationId }).delete();
        })();
    }
    async updateLocationByIdDB(locationId: number, name:string, secondIdentifier: string, description: string): Promise<number | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('locations').update({ name, description, locationId, secondIdentifier }).where({ locationId });
        })();
    }

    async updateLocationStockByIdDB(locationId: number, stock: number): Promise<number | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('locations').update({ stock }).where({ locationId });
        })();
    }
    async updateLocationLocationByIdDB(locationId: number, location: number): Promise<number | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('locations').update({ location }).where({ locationId });
        })();
    }
    async addLocationVendorByIdDB(locationId: number, vendorId: number, price: number): Promise<number | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('locationVendorInfo').insert({ locationId, 'vendorInfoId' : vendorId, price });
        })();
    }
    async deleteLocationVendorByIdDB(locationId: number, vendorId: number): Promise<number | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('locationVendorInfo').where({ locationId, 'vendorInfoId' : vendorId }).delete();
        })();
    }

}