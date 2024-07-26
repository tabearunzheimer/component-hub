import { NextFunction, Request, Response } from 'express';
import * as coreJoi from 'joi';
import joiDate from '@joi/date';
const Joi = coreJoi.extend(joiDate) as typeof coreJoi;
import { I_API_Schemas } from '../models/api/api.model';
import { CustomErrorHandler } from './error.service';
import * as path from 'path';
import { logger } from './logger.service';

export const schemas: I_API_Schemas = {};

/**
 * Validate incoming requests 'body' and 'params' data
 * @param req - Incoming Request
 * @param res - Response
 * @param next - Nextfunction
 * @returns CustomErrorHandler if the data was incorrect or no schema found. Otherwise continue process
 */
export function validateRequest(req: Request, res: Response, next: NextFunction) {    
    const url = extractURLWithoutQueries(extractURLWithoutParams(req.url, req.params));
    if (!schemas[url] || !schemas[url][req.method]) return next(new CustomErrorHandler(400, 'Missing Joi schema for url or request method', 'Request couldn\'t be validated. Please contact an admin.'));   
    const schema: coreJoi.Schema = schemas[url][req.method];
    const data = { ...req.params, ...req.body, ...req.query };
    const { error, value } = schema.validate(data, { allowUnknown: true });  
    if (error) return next(new CustomErrorHandler(400, `Missing or incorrect request input:\n${error}`, 'Request couldn\'t be validated. If the problem persists, please contact an admin.'));
    req.body = value;
    next();
}

/**
 * Remove 'params' from url to get only fixed parts of the url
 * @param url - original url with all dynamic values
 * @param params - dynamic parameters to remove from the url
 * @returns url without dynamic parts
 */
export function extractURLWithoutParams(url: string, params: { [keys: string]: unknown }) {
    for (let i = 0; i < Object.keys(params).length; i++) {
        url = url.replace(`/${params[Object.keys(params)[i]]}`, '');
    }
    return url;
}

/**
 * Remove all appended query parameters to get the base-url
 * @param url - original url with queries
 * @returns url without queries
 */
export function extractURLWithoutQueries(url: string) {
    return url.replace(/\?[\w=&%.]+/, '');
}

/**
 * Validate a date string and return the unchanged value if the date is ok. Otherwise return an error.
 * This avoids manual date validation because Joi will append a time to every date otherwise.
 * @param input - date in the format (yyyy-mm-dd)
 * @param helper - Joi.Custom Helper (see https://joi.dev/api/?v=17.7.0)
 * @returns Date string if the date is ok. Otherwise the Joi.Error
 */
export const dateValidationHelper = (input: string, helper: coreJoi.CustomHelpers) => {
    const schema = Joi.date().format('YYYY-MM-DD');
    const { error } = schema.validate(input);
    if (error) return helper.error(`${error}`);
    return helper.original;
};

/**
 * Validate a date string and return the date in the format 'YYYY-mm-dd HH:MM:SS' if the date is ok. Otherwise return an error. 
 * @param input - date in any kind of format
 * @param helper - Joi.CustomHelper (see https://joi.dev/api/?v=17.7.0)
 * @returns Date string in the format 'YYYY-mm-dd HH:MM:SS', otherwise a Joi.Error
 */
export const dateTimeValidationHelper = (input: string, helper: coreJoi.CustomHelpers) => {
    const schema = Joi.date();
    const { error } = schema.validate(input);
    if (error) return helper.error(`${error}`);
    const inputDate = new Date(input);
    return `${inputDate.getFullYear()}-${padZero(inputDate.getMonth() + 1)}-${padZero(inputDate.getDate())} ${padZero(inputDate.getHours())}:${padZero(inputDate.getMinutes())}:${padZero(inputDate.getSeconds())}`;
};

export const jsonValidationHelper = (input: string, helper: coreJoi.CustomHelpers) => {
    try {
        const obj = JSON.parse(input);
        return obj;
    } catch (error) {
        return helper.error(`${error}`);
    }
};

function padZero(num: number): string {
    return num.toString().padStart(2, '0');
}

/**
 * Load validator schemes from models/##/#.scheme.ts
 */
export async function updateSchemas() {
    const modelPath = path.join(__dirname, '../models');
    const filesToImport = ['component/component.schema', 'location/location.schema', 'project/project.schema'];
    try {
        const promises = filesToImport.map(async (file) => {
          const { default: fileSchemes } = await import(path.join(modelPath, file));
          Object.assign(schemas, fileSchemes);
        });
    
        await Promise.all(promises);
        logger.info('Schemas updated successfully.');
      } catch (error) {
        logger.error('Error updating schemas:', error);
        throw error;
      }
}

/**
 * Format a date string to 'YYYY-mm-dd HH:MM:SS' format
 * @param date - Date string or Date object
 * @returns Formatted date string
 */
export function dateFormatter(date: string|Date): string {
    return new Date(date).toISOString().replace('Z', '').replace('T', ' ');
}
