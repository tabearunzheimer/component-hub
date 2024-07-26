/**
 * Router for handling component-related endpoints.
 * @author Tabea Runzheimer
 */


import { I_Component_Service } from '../models/component/component.model';
import { validateRequest } from '../services/validator.service';
import { CustomRouter } from './router.controller';
import multer from 'multer';

export class ComponentRouter extends CustomRouter {

    
    service!: I_Component_Service;
    multerUpload!: multer;


    /**
     * Constructs a new ComponentRouter instance.
     * @param {I_Component_Service} service - The component service to be used.
     * @param {multer} multerUpload - The multer instance for file upload.
     */

    constructor(service: I_Component_Service, multerUpload: multer) {
        super (service, multerUpload);
    }

    
    /**
     * Loads routes for component-related endpoints.
     */
    loadRoutes(): void {
        // TODO: add patch route
        this.router.get('/components', validateRequest, this.service.getAllComponents);
        this.router.post('/component', validateRequest, this.service.createComponent);
        this.router.post('/component/import', this.multerUpload.single('file'), this.service.importComponents);
        this.router.get('/component/:componentId', validateRequest, this.service.getComponentById);
        this.router.get('/component/:componentId/export', validateRequest, this.service.exportComponents);
        this.router.put('/component/:componentId', validateRequest, this.service.updateComponentById);
        this.router.delete('/component/:componentId', validateRequest, this.service.deleteComponentById);
        this.router.delete('/component/:componentId', validateRequest, this.service.deleteComponentById);

        this.router.patch('/component/:componentId/location', validateRequest, this.service.addComponentVendorById);
        this.router.patch('/component/:componentId/stock', validateRequest, this.service.deleteComponentVendorById);
        
        this.router.post('/component/:componentId/vendor/:vendorInfoId', validateRequest, this.service.createVendorInfo);
        this.router.delete('/component/:componentId/vendor/:vendorInfoId', validateRequest, this.service.deleteVendorById);

        this.router.get('/vendorinfos', validateRequest, this.service.getAllVendorInfos);
        this.router.get('/vendors', validateRequest, this.service.getAllVendors);
        this.router.post('/vendor', validateRequest, this.service.createVendorInfo);
        this.router.get('/vendor/:vendorInfoId', validateRequest, this.service.getVendorInfoById);
        this.router.delete('/vendor/:vendorInfoId', validateRequest, this.service.deleteVendorById);
        this.router.patch('/vendor/:vendorInfoId/price', validateRequest, this.service.updateVendorInfoPriceById);
        this.router.patch('/vendor/:vendorInfoId/bought', validateRequest, this.service.updateVendorInfoLastBoughtById);
        
    }


}
