import { Request, Response, NextFunction } from 'express';
import { CustomErrorHandler } from '../../services/error.service';
import { Service } from '../service/service.model';
import { ResultSetHeader } from 'mysql2';

import { KnexDatabase } from '../../database/knex.database';

export interface I_Location {
   name: string;
   secondIdentifier: string;
   description: string;
}

export interface I_Location_Id extends I_Location {
    locationId: number,
}

export interface I_Component_Location {
    locationId: number,
    componentId: number,
}


export interface I_Location_Database  extends KnexDatabase{
    getAllLocationsDB(): Promise<I_Location_Id[] | CustomErrorHandler>,
    createLocationDB(name: string, secondIdentifier: string, description: string): Promise<ResultSetHeader | CustomErrorHandler>, 
    getLocationByIdDB(locationId: number): Promise<I_Location_Id[] | CustomErrorHandler>
    getLocationsByNameDB(name: string, orderBy?: string, sortOrder?: string): Promise<I_Location_Id[] | CustomErrorHandler>    
    deleteLocationByIdDB(locationId: number): Promise<number | CustomErrorHandler>
    updateLocationByIdDB(locationId: number, name:string, secondIdentifier: string, description: string): Promise<number | CustomErrorHandler>
    
    //Component Location
    getComponentLocationByComponentIdDB(componentId: number): Promise<I_Component_Location[] | CustomErrorHandler>,
    getComponentLocationByLocationIdDB(locationId: number): Promise<I_Component_Location[] | CustomErrorHandler>,
    addComponentLocationByIdDB(locationId: number, componentId: number): Promise<number | CustomErrorHandler>,
    deleteComponentLocationByIdDB(locationId: number, componentId: number): Promise<number | CustomErrorHandler>,
}

export interface I_Location_Service extends Service {
    getAllLocations(req: Request, res: Response, next: NextFunction): void
    createLocation(req: Request, res: Response, next: NextFunction): void
    getLocationById(req: Request, res: Response, next: NextFunction): void
    getLocationsByName(req: Request, res: Response, next: NextFunction): void
    deleteLocationById(req: Request, res: Response, next: NextFunction): void
    updateLocationById(req: Request, res: Response, next: NextFunction): void
    
    getComponentLocationByLocationIdDB(req: Request, res: Response, next: NextFunction): void
    getComponentLocationByComponentIdDB(req: Request, res: Response, next: NextFunction): void
    addComponentLocationById(req: Request, res: Response, next: NextFunction): void
    deleteComponentLocationById(req: Request, res: Response, next: NextFunction): void
}
