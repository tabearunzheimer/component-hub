import * as Joi from 'joi';
import { dateTimeValidationHelper, schemas } from '../../services/validator.service';

export const locationScheme = Joi.object({
    name: Joi.string(),
    secondIdentifier: Joi.string(),
    description: Joi.string(),
})

export const locationIdScheme = locationScheme.keys({
    locationId: Joi.number().integer().min(1)
});


export const vendorLocationScheme = Joi.object({
    locationId: Joi.number().integer().min(1),
    componentId: Joi.number().integer().min(1),
});

schemas['/locations'] = {
    GET: Joi.object({})
};
schemas['/location'] = {
    GET: locationIdScheme,
    POST: locationScheme,
    PUT: locationIdScheme,
    DELETE: Joi.object({
        locationsId: Joi.number()
    })
};

schemas['/component/location'] = {
    GET: Joi.object({
        locationId: Joi.number().integer().min(1),
        vendorInfoId: Joi.number().integer().min(1)
    }).xor('locationId', 'vendorInfoId'),
    POST: Joi.object({
        locationId: Joi.number().integer().min(1),
        vendorInfoId: Joi.number().integer().min(1),
    }),
    DELETE: Joi.object({
        locationId: Joi.number().integer().min(1),
        vendorInfoId: Joi.number().integer().min(1),
    })
};
