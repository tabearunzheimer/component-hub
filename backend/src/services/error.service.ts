import { NextFunction, Request, Response } from 'express';
import { logger } from './logger.service';

/**
 * Custom error handler class.
 */
export class CustomErrorHandler extends Error {

    /**
     * The error code.
     */
    public code: number;

    /**
     * The error message.
     */
    public message: string;

    /**
     * The public message.
     */
    public publicMessage: string;

    /**
     * Constructs a new CustomErrorHandler instance.
     * @param {number} code - The error code.
     * @param {string} message - The error message.
     * @param {string} publicMessage - The public message.
     */
    constructor(code: number, message: string, publicMessage: string) {
        super(message);
        this.code = code;
        this.message = message;
        this.publicMessage = publicMessage;
    }
}

/**
 * Handles request errors.
 * @param {CustomErrorHandler} err - The error object.
 * @param {Request} req - The Express Request object.
 * @param {Response} res - The Express Response object.
 * @param {NextFunction} next - The NextFunction middleware.
 */
export function handleRequestError(err: CustomErrorHandler, req: Request, res: Response, next: NextFunction) {
    if (res.headersSent) return next(err.publicMessage);
    logger.error(err);
    res.status(err.code).send(err.publicMessage);
}
