import { Request, Response, NextFunction } from 'express';
import { Service } from '../models/service/service.model';
import { CustomErrorHandler } from './error.service';
import { I_Component_Database, I_Component_Id, I_Component_Service, I_Vendor_Info } from '../models/component/component.model';
import { createJsonFile, deleteFile, readJsonFile } from './file.service';
import { dateFormatter } from './validator.service';

/**
 * Service class for handling component-related operations.
 */
export class ComponentService extends Service implements I_Component_Service {

    /**
     * Database instance for components.
     */
    db!: I_Component_Database;

    /**
     * Constructs an instance of ComponentService.
     * @param db - The database instance for components.
     */
    constructor(db: I_Component_Database) {
        super(db);
    }

    
    addComponentVendorById = async (req: Request, res: Response, next: NextFunction) =>  {
        const { componentId, vendorId, price } = req.body;
        const result = await this.db.addComponentVendorByIdDB(componentId, vendorId, price);
        if (result instanceof CustomErrorHandler) return next(result);
        res.status(200).json({ componentId, vendorId });
    }

    deleteComponentVendorById = async (req: Request, res: Response, next: NextFunction) =>  {
        const { componentId, vendorId} = req.body;
        const result = await this.db.deleteComponentVendorByIdDB(componentId, vendorId);
        if (result instanceof CustomErrorHandler) return next(result);
        res.status(200).json({ componentId, vendorId });
    }


    updateComponentStockById = async (req: Request, res: Response, next: NextFunction) =>  {
        const { componentId, stock} = req.body;
        const result = await this.db.updateComponentStockByIdDB(componentId, stock);
        if (result instanceof CustomErrorHandler) return next(result);
        res.status(200).json({ componentId, stock });
    }

    updateComponentLocationById = async (req: Request, res: Response, next: NextFunction) =>  {
        const { componentId, location } = req.body;
        const result = await this.db.updateComponentLocationByIdDB(componentId, location);
        if (result instanceof CustomErrorHandler) return next(result);
        res.status(200).json({ componentId, location });
    }

    getAllVendorInfos = async (req: Request, res: Response, next: NextFunction) => {
        const { name, sortOrder, orderBy } = req.body;
        const result: CustomErrorHandler | I_Vendor_Info[] = await this.db.getAllVendorInfosDB();
        if (result instanceof CustomErrorHandler) return next(result);
        res.status(200).send(result);
    }

    getAllVendors = async (req: Request, res: Response, next: NextFunction) => {
        const { name, sortOrder, orderBy } = req.body;
        const result: CustomErrorHandler | string[] = await this.db.getAllVendorsDB();
        if (result instanceof CustomErrorHandler) return next(result);
        res.status(200).send(result);
    }

    createVendorInfo = async (req: Request, res: Response, next: NextFunction) => {
        const { name } = req.body;
        const result = await this.db.createVendorInfoDB(name);
        if (result instanceof CustomErrorHandler) return next(result);
        res.status(200).json({ name, vendorInfoId: result.insertId });
    }

    getVendorInfoById = async (req: Request, res: Response, next: NextFunction) => {
        const { vendorInfoId } = req.body;
        const result = await this.db.getComponentByIdDB(vendorInfoId);
        if (result instanceof CustomErrorHandler) return next(result);
        if (result.length !== 0) res.status(200).json(result[0]);
        else res.status(204).send();
    }

    deleteVendorById = async (req: Request, res: Response, next: NextFunction) => {
        const { componentId: vendorInfoId } = req.body;
        const result = await this.db.deleteComponentByIdDB(vendorInfoId);
        if (result instanceof CustomErrorHandler) return next(result);
        if (result === 1) res.status(200).send();
        else res.status(204).send();
    }

    updateVendorInfoPriceById = async (req: Request, res: Response, next: NextFunction) => {
        const { vendorInfoId, price} = req.body;
        const result = await this.db.updateVendorInfoPriceByIdDB(vendorInfoId, price);
        if (result instanceof CustomErrorHandler) return next(result);
        res.status(200).json({ vendorInfoId, price });
    }

    updateVendorInfoLastBoughtById = async (req: Request, res: Response, next: NextFunction) => {
        const { vendorInfoId, lastBought} = req.body;
        const result = await this.db.updateVendorInfoLastBoughtByIdDB(vendorInfoId, lastBought);
        if (result instanceof CustomErrorHandler) return next(result);
        res.status(200).json({ vendorInfoId, lastBought });
    }

    /**
     * Retrieves all components or components filtered by name and sorted.
     * @param req - The request object.
     * @param res - The response object.
     * @param next - The next function in the middleware chain.
     */
    getAllComponents = async (req: Request, res: Response, next: NextFunction) => {
        console.log(req.body);
        
        const { name, sortOrder, orderBy } = req.body;
        let result: CustomErrorHandler | I_Component_Id[];
        if (name) result = await this.db.getComponentsByNameDB(name, orderBy, sortOrder);
        else result = await this.db.getAllComponentsDB();
        if (result instanceof CustomErrorHandler) return next(result);
        res.status(200).send(result);
    };

    /**
     * Exports a component as a JSON file.
     * @param req - The request object.
     * @param res - The response object.
     * @param next - The next function in the middleware chain.
     */
    exportComponents = async (req: Request, res: Response, next: NextFunction) => {
        const { componentId } = req.body;
        const result = await this.db.getComponentByIdDB(componentId);        
        if (result instanceof CustomErrorHandler) return next(result);
        const filename = await createJsonFile(result[0], 'exported_component.json');
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
     * Imports components from a JSON file.
     * @param req - The request object.
     * @param res - The response object.
     * @param next - The next function in the middleware chain.
     */
    importComponents = async (req: Request, res: Response, next: NextFunction) => {
        const component = await readJsonFile(req.file.path);        
        if (component instanceof CustomErrorHandler) return next(new CustomErrorHandler(400, 'No file', 'Please upload a file'));
        // TODO
        //if (component.vendorInfo.) component.createdAt = dateFormatter(component.createdAt);
        //if (component.updatedAt) component.updatedAt = dateFormatter(component.updatedAt);
        const result = await this.db.importComponentsDB(component);
        if (result instanceof CustomErrorHandler) return next(result);
        res.status(200).send({componentId: result[0], ...component});
        void deleteFile(req.file.path);
    };

    /**
     * Creates a new component.
     * @param req - The request object.
     * @param res - The response object.
     * @param next - The next function in the middleware chain.
     */
    createComponent = async (req: Request, res: Response, next: NextFunction) => {
        const { name, description, category, stock, urls, location } = req.body;
        const result = await this.db.createComponentDB(name, description, category, stock, urls, location);
        if (result instanceof CustomErrorHandler) return next(result);
        res.status(200).json({ name, description, category, stock, urls, location, componentId: result.insertId });
    };

    /**
     * Retrieves a component by its ID.
     * @param req - The request object.
     * @param res - The response object.
     * @param next - The next function in the middleware chain.
     */
    getComponentById = async (req: Request, res: Response, next: NextFunction) => {
        const { componentId } = req.body;
        const result = await this.db.getComponentByIdDB(componentId);
        if (result instanceof CustomErrorHandler) return next(result);
        if (result.length !== 0) res.status(200).json(result[0]);
        else res.status(204).send();
    };

    /**
     * Deletes a component by its ID.
     * @param req - The request object.
     * @param res - The response object.
     * @param next - The next function in the middleware chain.
     */
    deleteComponentById = async (req: Request, res: Response, next: NextFunction) => {
        const { componentId } = req.body;
        const result = await this.db.deleteComponentByIdDB(componentId);
        if (result instanceof CustomErrorHandler) return next(result);
        if (result === 1) res.status(200).send();
        else res.status(204).send();
    };

    /**
     * Update a component by its ID.
     * @param req - The request object.
     * @param res - The response object.
     * @param next - The next function in the middleware chain.
     */
    updateComponentById = async (req: Request, res: Response, next: NextFunction) => {
        const { componentId, name, description, category, stock, url, location } = req.body;
        const result = await this.db.updateComponentByIdDB(componentId, name, description, category, stock, url, location);
        if (result instanceof CustomErrorHandler) return next(result);
        res.status(200).json({ componentId, name, description, category, stock, url, location });
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