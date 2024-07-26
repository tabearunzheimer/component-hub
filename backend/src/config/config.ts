/**
 * Loads environment variables from a .env file.
 * @remarks
 * The .env file is expected to be located in the parent directory of the current directory.
 * @author Tabea Runzheimer
 */
import * as dotenv from 'dotenv';
import * as path from 'path';

dotenv.config({path: path.join(__dirname, '..', '..', 'development.env')});

/**
 * Configuration object containing various application settings.
 * @author Tabea Runzheimer
 */
export const config = {
    /**
     * The name of the application.
     */
    APP_NAME: require(path.join(__dirname, '..', '..', 'package.json')).name,
    /**
     * The version of the application.
     */
    VERSION: require(path.join(__dirname, '..', '..', 'package.json')).version,
    /**
     * The host address of the backend server.
     */
    HOST: process.env.HOST ?? 'localhost',
    /**
     * The port number of the backend server.
     */
    BACKEND_PORT: process.env.BACKEND_PORT ?? 8080, 
    /**
     * The URL of the frontend application.
     */
    FRONTEND_URL: process.env.FRONTEND_URL  || "http://localhost:3000" ,
    /**
     * The host address of the database server.
     */
    DB_HOST: process.env.DB_HOST || 'localhost',
    /**
     * The username for database authentication.
     */
    DB_USER: process.env.DB_USER || 'admin',
    /**
     * The password for database authentication.
     */
    DB_PASSWORD: process.env.DB_PASSWORD || 'test',
    /**
     * The name of the database to connect to.
     */
    DB_NAME: process.env.DB_NAME || 'componenthub',
    /**
     * The port number for database connection.
     */
    DB_PORT: process.env.DB_PORT || 3306,
    /**
     * The maximum number of simultaneous database connections.
     */
    DB_CONNECTION_LIMIT: process.env.DB_CONNECTION_LIMIT || 5,
    /**
     * The path to the folder where log files are stored.
     */
    LOG_FOLDER_PATH: process.env.LOG_FOLDER || path.join(__dirname, '..', '..', 'logs'), //default path, If changed add log folder to gitignore
    /**
     * The environment mode of the application (e.g., development, production).
     */
    NODE_ENV: process.env.NODE_ENV || "development",
    /**
     * Path where images and documents are saved
     */
    ASSET_PATH: process.env.ASSET_PATH || 'uploads/'
};
