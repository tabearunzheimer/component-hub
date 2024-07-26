import { Server } from './services/server.service';
import { ComponentRouter } from './controller/component.controller';
import { ComponentService } from './services/component.service';
import { ComponentDatabase } from './database/component.database';

const server = new Server();

const componentRouter = new ComponentRouter(new ComponentService(new ComponentDatabase()), server.multerUpload);

void server.startService([], [
     { route: '/', router: componentRouter },
]);
