import express, { Express } from 'express';
import { Server as NodeServer } from 'http';
import { handleRequestError } from './error.service';
import { config } from '../config/config';
import { RouteHandler } from '../models/server/server.model';
import { updateSchemas } from './validator.service';
import { logger } from './logger.service';
import multer from 'multer';

/**
 * Class representing the server.
 * @author Tabea Runzheimer
 */
export class Server {

    server!: NodeServer;
    multerUpload: multer;
    app: Express;


    constructor() {
        this.app = express();
        this.multerUpload = this.configureMulter();
    }

    /**
     * Starts the server with specified middlewares and routes.
     * @param {express.RequestHandler[]} middlewares - The array of middleware functions.
     * @param {RouteHandler[]} routes - The array of route handlers.
     * @returns {Promise<void>}
     */
    async startService(middlewares?: express.RequestHandler[], routes?: RouteHandler[]): Promise<void> {
        return new Promise((resolve, reject) => {
            resolve(this.load(middlewares, routes));
            reject(Error(`Couldn't start server`));
        });
    }

    /**
     * Load middlewares and routes, then start the server.
     * @param {express.RequestHandler[]} middlewares - The array of middleware functions.
     * @param {RouteHandler[]} routes - The array of route handlers.
     * @returns {Promise<void>}
     */
    private async load(middlewares?: express.RequestHandler[], routes?: RouteHandler[]): Promise<void> {
        this.addProcessHandler();
        this.initRouteHandler(middlewares);
        if (routes) this.initRoutes(routes);
        this.app.use(handleRequestError);
        await updateSchemas();
        await this.start();
    }

    /**
     * Start the HTTP server.
     * @returns {Promise<void>}
     */
    private async start(): Promise<void> {
        return new Promise((resolve, reject) => {
            this.server = this.app.listen(config.BACKEND_PORT, () => {
                logger.info(`Server ${config.APP_NAME} started on ${config.HOST}, listening on port ${config.BACKEND_PORT}`);
                resolve();
            }).on('error', (err) => reject(err));
        });
    }

    /**
     * Initialize routes for the server.
     * @param {RouteHandler[]} routeHandlers - The array of route handlers.
     */
    private initRoutes(routeHandlers: RouteHandler[]): void {
        if (!routeHandlers) return;
        for (const handler of routeHandlers) {
            this.app.use(handler.route, handler.router.getRouter());
        }
    }

    /**
     * Initialize middlewares for the server.
     * @param {express.RequestHandler[]} middlewares - The array of middleware functions.
     */
    private initRouteHandler(middlewares?: express.RequestHandler[]): void {
        this.app.use(express.urlencoded({ extended: false }));
        this.app.use(express.json());
        if (!middlewares) return;
        for (const middleware of middlewares) {
            this.app.use(middleware);
        }
    }

    /**
     * Configure multer for file upload.
     * @returns {multer}
     */
    private configureMulter(): multer {
        const storage = multer.diskStorage({
            destination: (req, file, cb) => {
                cb(null, config.ASSET_PATH); // Destination folder for uploaded files
            },
            filename: (req, file, cb) => {
                cb(null, file.originalname); // Use the original file name
            }
        });
        const upload = multer({ storage });
        return upload;
    }

    /**
     * Add signal handlers for process termination.
     * @param {Array<{ event: NodeJS.Signals, listener: NodeJS.SignalsListener }>} handlers - The array of signal handlers.
     */
    addProcessHandler(handlers?: [{ event: NodeJS.Signals, listener: NodeJS.SignalsListener }]) {
        process.once('SIGINT', this.closeApplication.bind(this));
        process.once('SIGTERM', this.closeApplication.bind(this));
        if (!handlers) return;
        for (const handler of handlers) {
            process.once(handler.event, handler.listener);
        }
    }

    /**
     * Handles the closing of the application upon receiving a termination signal.
     * @param {string | number} signal - The termination signal received.
     */
    private async closeApplication(signal: string | number): Promise<void> {
        logger.info(`${config.APP_NAME} => Received signal to terminate: ${signal}`);
        //await this.db.closeConnection();
        this.server.close();
        process.kill(process.pid, signal);
    }


}