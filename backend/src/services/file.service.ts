import fs from 'fs';
import { CustomErrorHandler } from './error.service';
import { I_Component } from '../models/component/component.model';
import { logger } from './logger.service';

/**
 * Creates a JSON file from the given JSON data and returns its filename.
 * @param data - The JSON data to write to the file.
 * @param filename - The name of the JSON file to create.
 * @returns The filename of the created JSON file, or a CustomErrorHandler object if an error occurred.
 */
export async function createJsonFile(data: unknown, filename: string): Promise<string | CustomErrorHandler> {
    try {
        const jsonData = JSON.stringify(data, null, 2);
        await fs.promises.writeFile(filename, jsonData);
        logger.info('JSON file created successfully:', filename);
        return filename;
    } catch (error) {
        console.error('Error creating JSON file:', error);
        return new CustomErrorHandler(500, error, 'Something went wrong trying to create the JSON file. Please try again later or contact an admin.');
    }
}

/**
 * Reads a JSON file and returns its contents.
 * @param filename - The name of the JSON file to read.
 * @returns The contents of the JSON file, or a CustomErrorHandler object if an error occurred.
 */
export async function readJsonFile(filename: string): Promise<I_Component | CustomErrorHandler> {
    try {
        const jsonData = await fs.promises.readFile(filename, 'utf-8');
        const parsedData = JSON.parse(jsonData);
        logger.info('JSON file read successfully:', filename);
        return parsedData as I_Component;
    } catch (error) {
        console.error('Error reading JSON file:', error);
        return new CustomErrorHandler(500, error, 'Something went wrong trying to import the JSON file. Please try again later or contact an admin.');
    }
}

/**
 * Deletes a file from the filesystem.
 * @param filename - The name of the file to be deleted.
 */
export async function deleteFile(filename: string): Promise<number|CustomErrorHandler> {
    try {
        await fs.promises.unlink(filename);
        logger.info('File deleted successfully:', filename);
        return 1;
    } catch (error) {
        console.error('Error deleting file:', error);
        throw new CustomErrorHandler(500, error, 'Something went wrong trying to delete the file. Please try again later or contact an admin.');
    }
}
