import * as winston from 'winston';

/**
 * Logger instance configured with Winston.
 * @author Tabea Runzheimer
 */
export const logger = winston.createLogger({
    level: 'info',
    format: winston.format.combine(
        winston.format.timestamp(),
        winston.format.json()
    ),
    transports: [
        new winston.transports.Console(),
        new winston.transports.File({filename: 'info.log'})
    ]
});
