import { Service } from '../service/service.model';
import { Router } from 'express';
import * as Joi from 'joi';

export interface I_Query_Options {
    limit: number,
    offset: number,
    sortBy: string,
    sortOrder: string
}

export interface I_Router {
    service: Service;
    router: Router;
}

export interface I_API_Schemas {
    [route: string]: { [method: string]: Joi.ObjectSchema }
}
