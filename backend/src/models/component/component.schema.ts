import * as Joi from 'joi';
import { dateTimeValidationHelper, schemas } from '../../services/validator.service';

export const vendorInfoScheme = Joi.object({
    name: Joi.string(),
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

export const vendorComponentScheme = Joi.object({
    componentId: Joi.number().integer().min(1),
    vendorInfoId: Joi.number().integer().min(1),
    price: Joi.number().precision(2),
    lastBought: Joi.string().custom(dateTimeValidationHelper),
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
schemas['/components/location'] = {
    PATCH: Joi.object({
        location: Joi.number().integer().min(1),
    })
};
schemas['/components/stock'] = {
    PATCH: Joi.object({
        stock: Joi.number().integer().min(0),
    })
};


schemas['/components/vendor'] = {
    POST: Joi.object({
        componentId: Joi.number().integer().min(1),
        vendorInfoId: Joi.number().integer().min(1),
        price: Joi.number().precision(2),
    }),
    DELETE: Joi.object({
        componentId: Joi.number().integer().min(1),
        vendorInfoId: Joi.number().integer().min(1),
    })
};

schemas['/components/vendor/price'] = {
    PATCH: Joi.object({
        price: Joi.number().precision(2),
    }),
};
schemas['/components/vendor/bought'] = {
    PATCH: Joi.object({
        lastBought: Joi.string().custom(dateTimeValidationHelper),
    }),
};

schemas['/vendors'] = {
    GET: Joi.object({}),
};
schemas['/vendorinfos'] = {
    GET: Joi.object({}),
};
schemas['/vendor'] = {
    GET: Joi.object({
        vendorInfoId: Joi.number().integer().min(1),
    }),
    POST: vendorInfoScheme,
    DELETE: Joi.object({
        vendorInfoId: Joi.number().integer().min(1),
    }),
};
