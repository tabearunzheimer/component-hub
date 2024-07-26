import * as Joi from 'joi';
import { dateTimeValidationHelper, schemas } from '../../services/validator.service';

export const vendorInfoScheme = Joi.object({
    lastBought: Joi.string().custom(dateTimeValidationHelper),
    name: Joi.string(),
    price: Joi.number().precision(2),
})

export const vendorInfoIdScheme = vendorInfoScheme.keys({
    vendorInfoId: Joi.number().integer().min(1)
});

export const componentScheme = Joi.object({
    category: Joi.string(),
    description: Joi.string(),
    imageUrl: Joi.string(),
    stock: Joi.number().integer().min(0),
    vendorInfo: Joi.array().items(vendorInfoIdScheme),
    urls: Joi.string(),
    location: Joi.number().integer().min(1),
    name: Joi.string(),
});

export const componentIdScheme = componentScheme.keys({
    componentId: Joi.number().integer().min(1)
});

schemas['/components'] = {
    GET: Joi.object({})
};
schemas['/component'] = {
    GET: componentIdScheme,
    POST: componentScheme,
    PUT: componentIdScheme,
    DELETE: Joi.object({
        componentsId: Joi.number()
    })
};
schemas['/component/export'] = {
    GET: Joi.object({
        componentsId: Joi.number()
    })
};
schemas['/component/import'] = {
    GET: componentScheme
};
schemas['/components/quote'] = {
    GET: Joi.object({})
};