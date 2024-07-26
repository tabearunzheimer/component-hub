/**
 * Abstract class representing a custom router for handling Express routes.
 */
import * as express from 'express';
import { Service } from '../models/service/service.model';

export abstract class CustomRouter {

    /**
     * The service associated with the router.
     */
    protected service?: Service;

    /**
     * The Express router instance.
     */
    protected router: express.Router;

    /**
     * The multer instance for file upload.
     */
    protected multerUpload;

    /**
     * Constructs a new CustomRouter instance.
     * @param {Service} service - The service associated with the router.
     * @param {multer} multerUpload - The multer instance for file upload.
     */
    constructor(service?: Service, multerUpload?) {        
        this.router = express.Router({ mergeParams: true });
        this.service = service;
        this.multerUpload = multerUpload;
        this.loadRoutes();
    }

    /**
     * Abstract method to load routes for the router.
     */
    abstract loadRoutes(): void;
  
    /**
     * Gets the Express router instance.
     * @returns {express.Router} The Express router instance.
     */
    getRouter(): express.Router {
        return this.router;
    }
}
