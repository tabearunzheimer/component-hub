import { I_File } from '../../models/file/file.model';

/**
 * Overwriting default express Request
 * @author Tabea Runzheimer
 */
declare global {
    namespace Express {
        export interface Request {
            /**
             * File object attached to the request.
             */
            file: I_File; // File object attached to the request
            access_token: string; 
            refresh_token: string; 
        }
    }
}
