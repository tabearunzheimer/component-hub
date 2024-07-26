/**
 * Router for handling project-related endpoints.
 * @author Tabea Runzheimer
 */


import { I_Project_Service } from '../models/project/project.model';
import { validateRequest } from '../services/validator.service';
import { CustomRouter } from './router.controller';
import multer from 'multer';

export class ProjectRouter extends CustomRouter {

    
    service!: I_Project_Service;
    multerUpload!: multer;


    /**
     * Constructs a new ProjectRouter instance.
     * @param {I_Project_Service} service - The project service to be used.
     * @param {multer} multerUpload - The multer instance for file upload.
     */

    constructor(service: I_Project_Service, multerUpload: multer) {
        super (service, multerUpload);
    }

    
    /**
     * Loads routes for project-related endpoints.
     */
    loadRoutes(): void {
        this.router.get('/projects', validateRequest, this.service.getAllProjects);
        this.router.post('/project', validateRequest, this.service.createProject);
        this.router.get('/project/:projectId', validateRequest, this.service.getProjectById);
        this.router.get('/project/:name', validateRequest, this.service.getProjectsByName);
        this.router.put('/project/:projectId', validateRequest, this.service.updateProjectById);
        this.router.delete('/project/:projectId', validateRequest, this.service.deleteProjectById);
        this.router.patch('/project/:projectId/description', validateRequest, this.service.updateProjectDescriptionById);
        this.router.patch('/project/:projectId/name', validateRequest, this.service.updateProjectNameById);
        
        this.router.post('/project/:projectId/component', validateRequest, this.service.createProjectComponent);
        this.router.get('/project/:projectId/components', validateRequest, this.service.getAllProjectComponents);
        this.router.delete('/project/:projectId/component/:componentId', validateRequest, this.service.deleteProjectComponent);
        this.router.patch('/project/:projectId/component/:componentId/amount', validateRequest, this.service.updateProjectComponentAmount);
       
        this.router.get('/project/:projectId/files', validateRequest, this.service.getAllProjectFiles);
        this.router.get('/project/:projectId/image', validateRequest, this.service.getImage);
        this.router.get('/project/:projectId/document', validateRequest, this.service.getDocument);
        this.router.post('/project/:projectId/image', this.multerUpload.single('file'), this.service.uploadImage);
        this.router.post('/project/:projectId/document', this.multerUpload.single('file'), this.service.uploadDocument);
        this.router.delete ('/project/:projectId/image', validateRequest, this.service.deleteImage);
        this.router.delete ('/project/:projectId/document', validateRequest, this.service.deleteDocument); 
    }


}
