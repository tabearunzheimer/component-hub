import { ResultSetHeader } from 'mysql2';
import { I_Component_Id, I_Component_Database, I_Component, I_Vendor_Info, I_Vendor_Info_Id } from '../models/component/component.model';
import { CustomErrorHandler } from '../services/error.service';

import { KnexDatabase } from './knex.database';

export class ComponentDatabase extends KnexDatabase implements I_Component_Database {

    async getComponentsByNameDB(name: string, orderBy?: string, sortOrder?: string): Promise<CustomErrorHandler | I_Component_Id[]> {
        if (orderBy && sortOrder) {
            return this.queryWrapper(async () => {
                return this.db('components')
                    .where(builder => {
                        void builder.whereRaw('LOWER(description) LIKE ?', [`%${name.toLowerCase()}%`])
                            .orWhereRaw('LOWER(name) LIKE ?', [`%${name.toLowerCase()}%`]);
                    })
                    .orderBy(orderBy, sortOrder);
            })();
        } else if (orderBy) {
            return this.queryWrapper(async () => {
                return this.db('components')
                    .where(builder => {
                        void builder.whereRaw('LOWER(description) LIKE ?', [`%${name.toLowerCase()}%`])
                            .orWhereRaw('LOWER(name) LIKE ?', [`%${name.toLowerCase()}%`]);
                    })
                    .orderBy(orderBy, 'asc');
            })();
        } else {
            return this.queryWrapper(async () => {
                return this.db('components')
                    .where(builder => {
                        void builder.whereRaw('LOWER(description) LIKE ?', [`%${name.toLowerCase()}%`])
                            .orWhereRaw('LOWER(name) LIKE ?', [`%${name.toLowerCase()}%`]);
                    });
            })();
        }
    }

    async importComponentsDB(component: I_Component): Promise<CustomErrorHandler | I_Component_Id[]> {
        return this.queryWrapper(async () => {
            return this.db('components').insert(component);
        })();
    }

    async getAllComponentsDB(): Promise<I_Component_Id[] | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('components') as Promise<I_Component_Id[] | CustomErrorHandler>;
        })();
    }
    async createComponentDB(name: string, description: string, category: string, stock: number, urls: string, location: number): Promise<ResultSetHeader | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('components').insert({ name, description, category, stock, urls, location });
        })();
    }
    async getComponentByIdDB(componentId: number): Promise<I_Component_Id[] | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('components').where({ componentId });
        })();
    }
    async deleteComponentByIdDB(componentId: number): Promise<number | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('components').where({ componentId }).delete();
        })();
    }
    async updateComponentByIdDB(componentId: number, name: string, description: string, category: string, stock: number, urls: string, location: number): Promise<number | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('components').update({ name, description, category, stock, urls, location }).where({ componentId });
        })();
    }

    async updateComponentStockByIdDB(componentId: number, stock: number): Promise<number | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('components').update({ stock }).where({ componentId });
        })();
    }
    async updateComponentLocationByIdDB(componentId: number, location: number): Promise<number | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('components').update({ location }).where({ componentId });
        })();
    }
    async addComponentVendorByIdDB(componentId: number, vendorId: number, price: number): Promise<number | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('componentVendorInfo').insert({ componentId, 'vendorInfoId' : vendorId, price });
        })();
    }
    async deleteComponentVendorByIdDB(componentId: number, vendorId: number): Promise<number | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('componentVendorInfo').where({ componentId, 'vendorInfoId' : vendorId }).delete();
        })();
    }
    async getAllVendorInfosDB(): Promise<I_Vendor_Info[] | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('vendorInfos') as Promise<I_Vendor_Info_Id[] | CustomErrorHandler>;
        })();
    }
    async getAllVendorsDB(): Promise<string[] | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db.select('name').from('vendorInfos') as Promise<string[] | CustomErrorHandler>;
        })();
    }
    async createVendorInfoDB(name: string): Promise<ResultSetHeader | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('components').insert({ name });
        })();
    }
    async getVendorInfoByIdDB(vendorId: number): Promise<I_Vendor_Info[] | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('vendorInfos').where({'vendorInfoId' : vendorId}) as Promise<I_Vendor_Info_Id[] | CustomErrorHandler>;
        })();
    }
    async deleteVendorByIdDB(vendorId: number): Promise<number | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('vendorInfos').where({'vendorInfoId' : vendorId}).del();
        })();
    }
    async updateVendorInfoPriceByIdDB(vendorId: number, price: number): Promise<number | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('vendorInfoId').update({ price }).where({ 'vendorInfoId' : vendorId });
        })();
    }
    async updateVendorInfoLastBoughtByIdDB(vendorId: number, lastBought: Date): Promise<number | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('vendorInfoId').update({ lastBought }).where({ 'vendorInfoId' : vendorId });
        })();
    }

}