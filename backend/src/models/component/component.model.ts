import { Request, Response, NextFunction } from 'express';
import { CustomErrorHandler } from '../../services/error.service';
import { Service } from '../service/service.model';
import { ResultSetHeader } from 'mysql2';

import { KnexDatabase } from '../../database/knex.database';

export interface I_Component {
   name: string;
   category: string;
   description: string;
   imageUrl: string;
   stock: number;
   vendorInfo?: number[] | I_Vendor_Info_Id[];
   urls: Object;
   location: number;
}

export interface I_Component_Id extends I_Component {
    componentId: number,
}


export interface I_Vendor_Info {
    name: string;
}

export interface I_Vendor_Info_Id extends I_Vendor_Info {
    componentId: number,
}

    // TODO: update variables
export interface I_Component_Database  extends KnexDatabase{
    getAllComponentsDB(): Promise<I_Component_Id[] | CustomErrorHandler>,
    createComponentDB(name: string, description: string, category: string, stock: number, urls: string, location: number): Promise<ResultSetHeader | CustomErrorHandler>, 
    getComponentByIdDB(componentId: number): Promise<I_Component_Id[] | CustomErrorHandler>
    getComponentsByNameDB(name: string, orderBy?: string, sortOrder?: string): Promise<I_Component_Id[] | CustomErrorHandler>
    importComponentsDB(component: I_Component): Promise<I_Component_Id[] | CustomErrorHandler>
    deleteComponentByIdDB(componentId: number): Promise<number | CustomErrorHandler>
    updateComponentByIdDB(componentId: number, name: string, description: string, category: string, stock: number, urls: string, location: number): Promise<number | CustomErrorHandler>
    updateComponentStockByIdDB(componentId: number, stock: number): Promise<number | CustomErrorHandler>,
    updateComponentLocationByIdDB(componentId: number, location: number): Promise<number | CustomErrorHandler>,

    //Vendor Component
    addComponentVendorByIdDB(componentId: number, vendorId: number, price: number): Promise<number | CustomErrorHandler>,
    deleteComponentVendorByIdDB(componentId: number, vendorId: number): Promise<number | CustomErrorHandler>,
    
    //Vendor   
    getAllVendorInfosDB(): Promise<I_Vendor_Info[] | CustomErrorHandler>,
    getAllVendorsDB(): Promise<string[] | CustomErrorHandler>,
    createVendorInfoDB(name: string): Promise<ResultSetHeader | CustomErrorHandler>, 
    getVendorInfoByIdDB(vendorId: number): Promise<I_Vendor_Info[] | CustomErrorHandler>
    deleteVendorByIdDB(vendorId: number): Promise<number | CustomErrorHandler>
    updateVendorInfoPriceByIdDB(vendorInfo: number, price: number): Promise<number | CustomErrorHandler>,
    updateVendorInfoLastBoughtByIdDB(vendorInfo: number, lastBought: Date): Promise<number | CustomErrorHandler>,
}

export interface I_Component_Service extends Service {
    getAllComponents(req: Request, res: Response, next: NextFunction): void
    createComponent(req: Request, res: Response, next: NextFunction): void
    getComponentById(req: Request, res: Response, next: NextFunction): void
    deleteComponentById(req: Request, res: Response, next: NextFunction): void
    updateComponentById(req: Request, res: Response, next: NextFunction): void
    exportComponents(req: Request, res: Response, next: NextFunction): void
    importComponents(req: Request, res: Response, next: NextFunction): void
    updateComponentStockById(req: Request, res: Response, next: NextFunction): void
    updateComponentLocationById(req: Request, res: Response, next: NextFunction): void
    
    addComponentVendorById(req: Request, res: Response, next: NextFunction): void
    deleteComponentVendorById(req: Request, res: Response, next: NextFunction): void
    
    getAllVendorInfos(req: Request, res: Response, next: NextFunction): void
    getAllVendors(req: Request, res: Response, next: NextFunction): void
    createVendorInfo(req: Request, res: Response, next: NextFunction): void
    getVendorInfoById(req: Request, res: Response, next: NextFunction): void
    deleteVendorById(req: Request, res: Response, next: NextFunction): void
    updateVendorInfoPriceById(req: Request, res: Response, next: NextFunction): void
    updateVendorInfoLastBoughtById(req: Request, res: Response, next: NextFunction): void
}
