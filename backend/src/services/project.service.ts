import { Request, Response, NextFunction } from 'express';
import { Service } from '../models/service/service.model';
import { CustomErrorHandler } from './error.service';
import { I_Project_Database, I_Project_Id, I_Project_Service } from '../models/project/project.model';
import { createJsonFile, deleteFile, readJsonFile } from './file.service';

/**
 * Service class for handling project-related operations.
 */
export class ProjectService extends Service implements I_Project_Service {

    /**
     * Database instance for projects.
     */
    db!: I_Project_Database;

    /**
     * Constructs an instance of ProjectService.
     * @param db - The database instance for projects.
     */
    constructor(db: I_Project_Database) {
        super(db);
    }

    getProjectsByName = async (req: Request, res: Response, next: NextFunction)=> {
        const { name } = req.body;
       const result = await this.db.getProjectsByNameDB(name);
        if (result instanceof CustomErrorHandler) return next(result);
        res.status(200).send(result);
    }

    updateProjectDescriptionById = async (req: Request, res: Response, next: NextFunction)=> {
        const { projectId, description } = req.body;
        const result = await this.db.updateProjectDescriptionByIdDB(projectId, description);
        if (result instanceof CustomErrorHandler) return next(result);
        res.status(200).json({ projectId, description });
    }

    updateProjectNameById = async (req: Request, res: Response, next: NextFunction)=> {
        const { projectId, name } = req.body;
        const result = await this.db.updateProjectNameByIdDB(projectId, name);
        if (result instanceof CustomErrorHandler) return next(result);
        res.status(200).json({ projectId, name });
    }

    getAllProjectComponents = async (req: Request, res: Response, next: NextFunction)=> {
        throw new Error('Method not implemented.');
    }

    updateProjectComponentAmount = async (req: Request, res: Response, next: NextFunction)=> {
        const { projectId, amount, componentId } = req.body;
        const result = await this.db.updateProjectComponentAmountDB(projectId, componentId, amount);
        if (result instanceof CustomErrorHandler) return next(result);
        res.status(200).json({ projectId, amount, componentId });
    }

    createProjectComponent = async (req: Request, res: Response, next: NextFunction)=> {
         const { projectId, componentId, amount } = req.body;
        const result = await this.db.createProjectComponentDB(projectId, componentId, amount);
        if (result instanceof CustomErrorHandler) return next(result);
        res.status(200).json({projectId, componentId, amount });
    }
    
    deleteProjectComponent = async (req: Request, res: Response, next: NextFunction)=> {
        const { projectId, componentId } = req.body;
        const result = await this.db.deleteProjectComponentDB(projectId, componentId);
        if (result instanceof CustomErrorHandler) return next(result);
        if (result === 1) res.status(200).send();
        else res.status(204).send();
    }

    getAllProjectFiles = async (req: Request, res: Response, next: NextFunction)=> {
        const { projectId } = req.body;
        const result = await this.db.getAllProjectFilesDB(projectId);
        if (result instanceof CustomErrorHandler) return next(result);
        // TODO send multiple
        res.status(200).send(result);
    }
    uploadDocument = async (req: Request, res: Response, next: NextFunction)=> {
        const docPath = (req.file.path);        
        const {projectId} = req.body;     
       const result = await this.db.uploadFileDB(docPath, projectId, 'document');
        if (result instanceof CustomErrorHandler) return next(result);
        res.status(200).send({projectId: result[0]});
    }
    deleteDocument= async (req: Request, res: Response, next: NextFunction)=> {
        const { projectId, fileId} = req.body;
        let path = await this.db.getFilePath(fileId);
        if (path instanceof CustomErrorHandler) return next(path);
        let result = await deleteFile(path[0].path);
        if (result instanceof CustomErrorHandler) return next(result);
        result = await this.db.deleteFileDB(fileId, projectId);
        if (result instanceof CustomErrorHandler) return next(result);
        res.status(200).json({ projectId, fileId });
    }
    getDocument = async (req: Request, res: Response, next: NextFunction)=> {
        const {fileId} = req.body;
        let path = await this.db.getFilePath(fileId);
        if (path instanceof CustomErrorHandler) return next(path);
        res.status(200).sendFile(path[0].path);
    }
    
    getImage = async (req: Request, res: Response, next: NextFunction) => {
        const {fileId} = req.body;
        let path = await this.db.getFilePath(fileId);
        if (path instanceof CustomErrorHandler) return next(path);
        res.status(200).sendFile(path[0].path);
    }

    uploadImage = async (req: Request, res: Response, next: NextFunction) => {        
        const imagePath = (req.file.path);        
        const {projectId} = req.body;     
       const result = await this.db.uploadFileDB(imagePath, projectId, 'image');
        if (result instanceof CustomErrorHandler) return next(result);
        res.status(200).send({projectId: result[0]});
    }

    deleteImage = async (req: Request, res: Response, next: NextFunction) => {
        const { projectId, fileId} = req.body;
        let path = await this.db.getFilePath(fileId);
        if (path instanceof CustomErrorHandler) return next(path);
        let result = await deleteFile(path[0].path);
        if (result instanceof CustomErrorHandler) return next(result);
        result = await this.db.deleteFileDB(fileId, projectId);
        if (result instanceof CustomErrorHandler) return next(result);
        res.status(200).json({ projectId, fileId });
    }

    /**
     * Retrieves all projects or projects filtered by name and sorted.
     * @param req - The request object.
     * @param res - The response object.
     * @param next - The next function in the middleware chain.
     */
    getAllProjects = async (req: Request, res: Response, next: NextFunction) => {        
        const { name, sortOrder, orderBy } = req.body;
        let result: CustomErrorHandler | I_Project_Id[];
        if (name) result = await this.db.getProjectsByNameDB(name, orderBy, sortOrder);
        else result = await this.db.getAllProjectsDB();
        if (result instanceof CustomErrorHandler) return next(result);
        res.status(200).send(result);
    };

    /**
     * Exports a project as a JSON file.
     * @param req - The request object.
     * @param res - The response object.
     * @param next - The next function in the middleware chain.
     */
    exportProjects = async (req: Request, res: Response, next: NextFunction) => {
        const { projectId } = req.body;
        const result = await this.db.getProjectByIdDB(projectId);        
        if (result instanceof CustomErrorHandler) return next(result);
        const filename = await createJsonFile(result[0], 'exported_project.json');
        if (filename instanceof CustomErrorHandler) return next(filename);
        res.download(filename, (err) => {
            if (err) {
                console.error('Error sending JSON file:', err);
                return next(err);
            }
            void deleteFile(filename);
        });
    };

    /**
     * Creates a new project.
     * @param req - The request object.
     * @param res - The response object.
     * @param next - The next function in the middleware chain.
     */
    createProject = async (req: Request, res: Response, next: NextFunction) => {
        const { name, description, secondIdentifier } = req.body;
        const result = await this.db.createProjectDB(name, description, secondIdentifier);
        if (result instanceof CustomErrorHandler) return next(result);
        res.status(200).json({name, description, secondIdentifier, projectId: result.insertId });
    };

    /**
     * Retrieves a project by its ID.
     * @param req - The request object.
     * @param res - The response object.
     * @param next - The next function in the middleware chain.
     */
    getProjectById = async (req: Request, res: Response, next: NextFunction) => {
        const { projectId } = req.body;
        const result = await this.db.getProjectByIdDB(projectId);
        if (result instanceof CustomErrorHandler) return next(result);
        if (result.length !== 0) res.status(200).json(result[0]);
        else res.status(204).send();
    };

    /**
     * Deletes a project by its ID.
     * @param req - The request object.
     * @param res - The response object.
     * @param next - The next function in the middleware chain.
     */
    deleteProjectById = async (req: Request, res: Response, next: NextFunction) => {
        const { projectId } = req.body;
        const result = await this.db.deleteProjectByIdDB(projectId);
        if (result instanceof CustomErrorHandler) return next(result);
        if (result === 1) res.status(200).send();
        else res.status(204).send();
    };

    /**
     * Update a project by its ID.
     * @param req - The request object.
     * @param res - The response object.
     * @param next - The next function in the middleware chain.
     */
    updateProjectById = async (req: Request, res: Response, next: NextFunction) => {
        const { projectId, name } = req.body;
        const result = await this.db.updateProjectNameByIdDB(projectId, name);
        if (result instanceof CustomErrorHandler) return next(result);
        res.status(200).json({ projectId, name });
    };

}