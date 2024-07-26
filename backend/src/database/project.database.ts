import { ResultSetHeader } from 'mysql2';
import { I_Project_Id, I_Project_Database, I_Project, I_File, I_File_Id, I_Project_Components, I_Project_Files } from '../models/project/project.model';
import { CustomErrorHandler } from '../services/error.service';

import { KnexDatabase } from './knex.database';

export class ProjectDatabase extends KnexDatabase implements I_Project_Database {
    
    updateProjectByNameDB(name: string, description: string, urls: string): Promise<number | CustomErrorHandler> {
        throw new Error('Method not implemented.');
    }
    updateProjectDescriptionByIdDB(projectId: number, description: string): Promise<number | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('projects').update({ description }).where({ projectId });
        })();
    }
    updateProjectNameByIdDB(projectId: number, name: string): Promise<number | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('projects').update({ name }).where({ projectId });
        })();
    }
    getAllProjectComponentsDB(projectId: number): Promise<I_Project_Components[] | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('projectComponents').where({ projectId });
        })();
    }
    updateProjectComponentAmountDB(projectId: number, componentId: number, amount: number): Promise<number | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('projectComponents').update({ amount }).where({ projectId, componentId });
        })();
    }
    createProjectComponentDB(projectId: number, componentId: number, amount: number): Promise<number | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('projectComponents').insert({ projectId, componentId, amount });
        })();
    }
    
    deleteProjectComponentDB(projectId: number, componentId: number): Promise<number | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('projectComponents').where({ projectId, componentId }).delete();
        })();
    }
    getAllProjectFilesDB(projectId: number): Promise<I_Project_Files[] | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('fileStore').where({ projectId });
        })();
    }


    uploadFileDB(path: string, projectId: number, type: 'image' | 'document'): Promise<number | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db.transaction(async (trx) => {
                const result = await trx('files').insert({ path, type }, 'fileId');
                if (result instanceof CustomErrorHandler) return result;
                await trx('fileStore').insert({fileId: result[0], projectId})
                return result[0] as number;
            })
        })();
    }
    deleteFileDB(fileId: number, projectId: number): Promise<number | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db.transaction(async (trx) => {
                let result = await trx('files').where({ fileId }).delete();
                result = await trx('fileStore').where({fileId, projectId}).delete();
                return result;
            })
        })();
    }
    

    getFilePath(fileId: number): Promise<I_File_Id[]|CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('files')
                .where({fileId});
        })();
    }


    async getProjectsByNameDB(name: string, orderBy?: string, sortOrder?: string): Promise<CustomErrorHandler | I_Project_Id[]> {
        if (orderBy && sortOrder) {
            return this.queryWrapper(async () => {
                return this.db('projects')
                    .where(builder => {
                        void builder.whereRaw('LOWER(description) LIKE ?', [`%${name.toLowerCase()}%`])
                            .orWhereRaw('LOWER(name) LIKE ?', [`%${name.toLowerCase()}%`]);
                    })
                    .orderBy(orderBy, sortOrder);
            })();
        } else if (orderBy) {
            return this.queryWrapper(async () => {
                return this.db('projects')
                    .where(builder => {
                        void builder.whereRaw('LOWER(description) LIKE ?', [`%${name.toLowerCase()}%`])
                            .orWhereRaw('LOWER(name) LIKE ?', [`%${name.toLowerCase()}%`]);
                    })
                    .orderBy(orderBy, 'asc');
            })();
        } else {
            return this.queryWrapper(async () => {
                return this.db('projects')
                    .where(builder => {
                        void builder.whereRaw('LOWER(description) LIKE ?', [`%${name.toLowerCase()}%`])
                            .orWhereRaw('LOWER(name) LIKE ?', [`%${name.toLowerCase()}%`]);
                    });
            })();
        }
    }

    async importProjectsDB(project: I_Project): Promise<CustomErrorHandler | I_Project_Id[]> {
        return this.queryWrapper(async () => {
            return this.db('projects').insert(project);
        })();
    }

    async getAllProjectsDB(): Promise<I_Project_Id[] | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('projects') as Promise<I_Project_Id[] | CustomErrorHandler>;
        })();
    }
    async createProjectDB(name: string, description: string, secondIdentifier: string): Promise<ResultSetHeader | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('projects').insert({ name, description,  secondIdentifier });
        })();
    }
    async getProjectByIdDB(projectId: number): Promise<I_Project_Id[] | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('projects').where({ projectId });
        })();
    }
    async deleteProjectByIdDB(projectId: number): Promise<number | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('projects').where({ projectId }).delete();
        })();
    }
    async updateProjectByIdDB(projectId: number, name: string, description: string,urls: string): Promise<number | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('projects').update({ name, description,  urls }).where({ projectId });
        })();
    }

    async updateProjectStockByIdDB(projectId: number, stock: number): Promise<number | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('projects').update({ stock }).where({ projectId });
        })();
    }
    async updateProjectLocationByIdDB(projectId: number, location: number): Promise<number | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('projects').update({ location }).where({ projectId });
        })();
    }
    async addProjectVendorByIdDB(projectId: number, vendorId: number, price: number): Promise<number | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('projectVendorInfo').insert({ projectId, 'vendorInfoId' : vendorId, price });
        })();
    }
    async deleteProjectVendorByIdDB(projectId: number, vendorId: number): Promise<number | CustomErrorHandler> {
        return this.queryWrapper(async () => {
            return this.db('projectVendorInfo').where({ projectId, 'vendorInfoId' : vendorId }).delete();
        })();
    }
}