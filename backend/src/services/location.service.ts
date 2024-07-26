import { Request, Response, NextFunction } from 'express';
import { Service } from '../models/service/service.model';
import { CustomErrorHandler } from './error.service';
import { I_Location_Database, I_Location_Id, I_Location_Service } from '../models/location/location.model';
import { createJsonFile, deleteFile, readJsonFile } from './file.service';

/**
 * Service class for handling location-related operations.
 */
export class LocationService extends Service implements I_Location_Service {

    /**
     * Database instance for locations.
     */
    db!: I_Location_Database;

    /**
     * Constructs an instance of LocationService.
     * @param db - The database instance for locations.
     */
    constructor(db: I_Location_Database) {
        super(db);
    }

    getLocationsByName = async (req: Request, res: Response, next: NextFunction)=> {
        const { name, sortOrder, orderBy } = req.body;
        const result = await this.db.getLocationsByNameDB(name, orderBy, sortOrder);
        if (result instanceof CustomErrorHandler) return next(result);
        res.status(200).send(result);
    }
    getComponentLocationByLocationIdDB = async (req: Request, res: Response, next: NextFunction)=> {
        const { locationId } = req.body;
        const result = await this.db.getComponentLocationByLocationIdDB(locationId);
        if (result instanceof CustomErrorHandler) return next(result);
        res.status(200).send(result);
    }
    getComponentLocationByComponentIdDB = async (req: Request, res: Response, next: NextFunction)=> {
        const { componentId } = req.body;
        const result = await this.db.getComponentLocationByComponentIdDB(componentId);
        if (result instanceof CustomErrorHandler) return next(result);
        res.status(200).send(result);
    }
    addComponentLocationById = async (req: Request, res: Response, next: NextFunction)=> {
        const { locationId, componentId } = req.body;
        const result = await this.db.addComponentLocationByIdDB(locationId, componentId);
        if (result instanceof CustomErrorHandler) return next(result);
        res.status(200).json({ locationId, componentId });
    }
    deleteComponentLocationById = async (req: Request, res: Response, next: NextFunction)=> {
        const { locationId, componentId } = req.body;
        const result = await this.db.deleteComponentLocationByIdDB(locationId, componentId);
        if (result instanceof CustomErrorHandler) return next(result);
        if (result === 1) res.status(200).send();
        else res.status(204).send();
    }
    
    /**
     * Retrieves all locations or locations filtered by name and sorted.
     * @param req - The request object.
     * @param res - The response object.
     * @param next - The next function in the middleware chain.
     */
    getAllLocations = async (req: Request, res: Response, next: NextFunction) => {        
        const { name, sortOrder, orderBy } = req.body;
        let result: CustomErrorHandler | I_Location_Id[];
        if (name) result = await this.db.getLocationsByNameDB(name, orderBy, sortOrder);
        else result = await this.db.getAllLocationsDB();
        if (result instanceof CustomErrorHandler) return next(result);
        res.status(200).send(result);
    };

    /**
     * Exports a location as a JSON file.
     * @param req - The request object.
     * @param res - The response object.
     * @param next - The next function in the middleware chain.
     */
    exportLocations = async (req: Request, res: Response, next: NextFunction) => {
        const { locationId } = req.body;
        const result = await this.db.getLocationByIdDB(locationId);        
        if (result instanceof CustomErrorHandler) return next(result);
        const filename = await createJsonFile(result[0], 'exported_location.json');
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
     * Creates a new location.
     * @param req - The request object.
     * @param res - The response object.
     * @param next - The next function in the middleware chain.
     */
    createLocation = async (req: Request, res: Response, next: NextFunction) => {
        const { name, description, secondIdentifier } = req.body;
        const result = await this.db.createLocationDB(name, description, secondIdentifier);
        if (result instanceof CustomErrorHandler) return next(result);
        res.status(200).json({ name, description, secondIdentifier, locationId: result.insertId });
    };

    /**
     * Retrieves a location by its ID.
     * @param req - The request object.
     * @param res - The response object.
     * @param next - The next function in the middleware chain.
     */
    getLocationById = async (req: Request, res: Response, next: NextFunction) => {
        const { locationId } = req.body;
        const result = await this.db.getLocationByIdDB(locationId);
        if (result instanceof CustomErrorHandler) return next(result);
        if (result.length !== 0) res.status(200).json(result[0]);
        else res.status(204).send();
    };

    /**
     * Deletes a location by its ID.
     * @param req - The request object.
     * @param res - The response object.
     * @param next - The next function in the middleware chain.
     */
    deleteLocationById = async (req: Request, res: Response, next: NextFunction) => {
        const { locationId } = req.body;
        const result = await this.db.deleteLocationByIdDB(locationId);
        if (result instanceof CustomErrorHandler) return next(result);
        if (result === 1) res.status(200).send();
        else res.status(204).send();
    };

    /**
     * Update a location by its ID.
     * @param req - The request object.
     * @param res - The response object.
     * @param next - The next function in the middleware chain.
     */
    updateLocationById = async (req: Request, res: Response, next: NextFunction) => {
        const { locationId, secondIdentifier, description, name } = req.body;
        const result = await this.db.updateLocationByIdDB(locationId, name, secondIdentifier, description);
        if (result instanceof CustomErrorHandler) return next(result);
        res.status(200).json({ locationId, secondIdentifier, description, name });
    };

    /**
     * Fetch a random quote from zenquotes API
     * @param req - The request object.
     * @param res - The response object.
     * @param next - The next function in the middleware chain.
     */
    getRandomQuote = async (req: Request, res: Response) =>  {
        let result = await fetch('https://zenquotes.io/api/random');
        result = await result.json();        
        res.status(200).send(result[0].q);
    };
}