import { Request, Response, NextFunction } from 'express';
import { CustomErrorHandler } from '../../services/error.service';
import { Service } from '../service/service.model';
import { ResultSetHeader } from 'mysql2';

import { KnexDatabase } from '../../database/knex.database';

export interface I_Project {
   name: string;
   description: string;
   urls: Object;
}

export interface I_Project_Id extends I_Project {
    projectId: number,
}

export interface I_File {
    type: string;
    path: string;
}

export interface I_File_Id extends I_File {
    fileId: number,
}

export interface I_Project_Files {
    fileId: number,
    projectId: number,
}

export interface I_Project_Components {
    componentId: number,
    projectId: number,
    amount: number
}


export interface I_Project_Database  extends KnexDatabase{
    getAllProjectsDB(): Promise<I_Project_Id[] | CustomErrorHandler>,
    createProjectDB(name: string, description: string, secondIdentifier: string): Promise<ResultSetHeader | CustomErrorHandler>, 
    getProjectByIdDB(projectId: number): Promise<I_Project_Id[] | CustomErrorHandler>
    getProjectsByNameDB(name: string, orderBy?: string, sortOrder?: string): Promise<I_Project_Id[] | CustomErrorHandler> 
    deleteProjectByIdDB(projectId: number): Promise<number | CustomErrorHandler>
    updateProjectByIdDB(projectId: number, name: string, description: string, urls: string): Promise<number | CustomErrorHandler>
    updateProjectDescriptionByIdDB(projectId: number, description: string): Promise<number | CustomErrorHandler>
    updateProjectNameByIdDB(projectId: number, name: string): Promise<number | CustomErrorHandler>
   
    getAllProjectComponentsDB(projectId: number): Promise<I_Project_Components[] | CustomErrorHandler>,
    updateProjectComponentAmountDB(projectId: number, componentId: number, amount: number): Promise<number | CustomErrorHandler>
    createProjectComponentDB(projectId: number, componentId: number, amount: number): Promise<number | CustomErrorHandler>
    deleteProjectComponentDB(projectId: number, componentId: number): Promise<number | CustomErrorHandler>
    
    getAllProjectFilesDB(projectId: number): Promise<I_Project_Files[] | CustomErrorHandler>,
    getFilePath(fileId: number): Promise<I_File_Id[]|CustomErrorHandler>
    uploadFileDB(path: string, projectId: number, type: 'image'|'document'): Promise<number | CustomErrorHandler>,
    deleteFileDB(fileId: number, projectId: number): Promise<number | CustomErrorHandler>,
}

export interface I_Project_Service extends Service {
    getAllProjects(req: Request, res: Response, next: NextFunction): void
    createProject(req: Request, res: Response, next: NextFunction): void
    getProjectById(req: Request, res: Response, next: NextFunction): void
    getProjectsByName(req: Request, res: Response, next: NextFunction): void
    deleteProjectById(req: Request, res: Response, next: NextFunction): void
    updateProjectById(req: Request, res: Response, next: NextFunction): void
    updateProjectDescriptionById(req: Request, res: Response, next: NextFunction): void
    updateProjectNameById(req: Request, res: Response, next: NextFunction): void
    
    getAllProjectComponents(req: Request, res: Response, next: NextFunction): void
    updateProjectComponentAmount(req: Request, res: Response, next: NextFunction): void
    createProjectComponent(req: Request, res: Response, next: NextFunction): void
    deleteProjectComponent(req: Request, res: Response, next: NextFunction): void
    
    getAllProjectFiles(req: Request, res: Response, next: NextFunction): void,
    uploadImage(req: Request, res: Response, next: NextFunction): void,
    uploadDocument(req: Request, res: Response, next: NextFunction): void,
    deleteImage(req: Request, res: Response, next: NextFunction): void,
    deleteDocument(req: Request, res: Response, next: NextFunction): void,
    getImage(req: Request, res: Response, next: NextFunction): void,
    getDocument(req: Request, res: Response, next: NextFunction): void,
}
