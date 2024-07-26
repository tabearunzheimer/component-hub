import { Server } from './services/server.service';
import { ComponentRouter } from './controller/component.controller';
import { ProjectRouter } from './controller/project.controller';
import { LocationRouter } from './controller/location.controller';
import { ComponentService } from './services/component.service';
import { ProjectService } from './services/project.service';
import { LocationService } from './services/location.service';
import { ComponentDatabase } from './database/component.database';
import { ProjectDatabase } from './database/project.database';
import { LocationDatabase } from './database/location.database';

const server = new Server();

const componentRouter = new ComponentRouter(new ComponentService(new ComponentDatabase()), server.multerUpload);
const projectRouter = new ProjectRouter(new ProjectService(new ProjectDatabase()), server.multerUpload);
const locationRouter = new LocationRouter(new LocationService(new LocationDatabase()), server.multerUpload);

void server.startService([], [
     { route: '/', router: componentRouter },
     { route: '/', router: projectRouter },
     { route: '/', router: locationRouter },
]);
