import * as Joi from 'joi';
import { dateTimeValidationHelper, schemas } from '../../services/validator.service';



export const projectScheme = Joi.object({
    name: Joi.string(),
    description: Joi.string(),
    urls: Joi.string(),
});

export const projectIdScheme = projectScheme.keys({
    projectId: Joi.number().integer().min(1)
});

export const fileScheme = Joi.object({
    type: Joi.string(),
    path: Joi.string(),
});

export const fileIdScheme = fileScheme.keys({
    fileId: Joi.number().integer().min(1)
});

export const projectComponentScheme = Joi.object({
    componentId: Joi.number().integer().min(1),
    projectId: Joi.number().integer().min(1),
    amount: Joi.number().integer().min(1)
});

schemas['/projects'] = {
    GET: Joi.object({})
};
schemas['/project'] = {
    GET: projectIdScheme,
    POST: projectScheme,
    PUT: projectIdScheme,
    DELETE: Joi.object({
        projectsId: Joi.number()
    })
};

schemas['/project/description'] = {
    PATCH: Joi.object({
        description: Joi.string(),
    })
};
schemas['/project/name'] = {
    PATCH: Joi.object({
        name: Joi.string(),
    })
};
schemas['/project/components'] = {
    GET: Joi.object({
        projectId: Joi.number().integer().min(1),
    })
};
schemas['/project/component'] = {
    POST: projectComponentScheme,
    DELETE: Joi.object({
        componentId: Joi.number().integer().min(1),
        projectId: Joi.number().integer().min(1),
    }),
    PATCH: Joi.object({
        amount: Joi.number().integer().min(1),
    })
};

schemas['/project/files'] = {
    GET: Joi.object({
        projectId: Joi.number().integer().min(0),
    }),
};
schemas['/project/file'] = {
    GET: Joi.object({
        fileId: Joi.number().integer().min(0),
    }),
    DELETE: Joi.object({
        fileId: Joi.number().integer().min(0),
    })
};