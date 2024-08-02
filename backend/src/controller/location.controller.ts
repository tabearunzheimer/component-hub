/**
 * Router for handling location-related endpoints.
 * @author Tabea Runzheimer
 */


import { I_Location_Service } from '../models/location/location.model';
import { validateRequest } from '../services/validator.service';
import { CustomRouter } from './router.controller';
import multer from 'multer';

export class LocationRouter extends CustomRouter {

    
    service!: I_Location_Service;
    multerUpload!: multer;


    /**
     * Constructs a new LocationRouter instance.
     * @param {I_Location_Service} service - The location service to be used.
     * @param {multer} multerUpload - The multer instance for file upload.
     */

    constructor(service: I_Location_Service, multerUpload: multer) {
        super (service, multerUpload);
    }

    
    /**
     * Loads routes for location-related endpoints.
     */
    loadRoutes(): void {
        this.router.get('/locations', validateRequest, this.service.getAllLocations);
        this.router.post('/location', validateRequest, this.service.createLocation);
        this.router.get('/location/:locationId', validateRequest, this.service.getLocationById);
        this.router.get('/location/:name', validateRequest, this.service.getLocationsByName);
        this.router.put('/location/:locationId', validateRequest, this.service.updateLocationById);
        this.router.delete('/location/:locationId', validateRequest, this.service.deleteLocationById);
       
        this.router.get('/location/:locationId/component', validateRequest, this.service.getComponentLocationByLocationIdDB);
        this.router.get('/component/:componentId/location', validateRequest, this.service.getComponentLocationByComponentIdDB);
        this.router.post('/location/:locationId/component', validateRequest, this.service.addComponentLocationById);
        this.router.delete ('/location/:locationId/component/:componentId', validateRequest, this.service.deleteComponentLocationById);
   
        
    }


}
