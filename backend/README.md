# <img src="../frontend/assets/logos/logo_whitespace.png" height=80> <span style="font-size: 2em;" > Component Hub</span> 

**Component Hub** is an intuitive inventory management app tailored for private makers and engineers. This innovative solution leverages the power of NFC tags, allowing you to seamlessly access your component inventory, costs, specifications, and datasheets directly from your phone. No need for additional devices like labelers for QR codes or barcode scanners. With Component Hub, managing your components becomes faster, easier, and more efficient, all within the convenience of your mobile device.

- Starting a new project? Create it in the app, add components, and instantly see what's missing. 
- Trying to find a specific component? Check its location in the app with ease. 
- Ever thought, "Wasn't that cheaper the last time I bought it?" With Component Hub, you can check pricing information in the app and see what you paid previously. 
  
Simplify your inventory management and focus more on creating with Component Hub.

## Installation

### Development
1. Clone the repository
2. From the projects root folder run `npm install` to install npm packages.
3. Run `npm run git:update` to install or update the git submodules.
4. Navigate from project root folder to `config` and run `docker compose up -d mysql`.
5. Run `npm run migrate` to apply database migrations using knexjs.
6. Optionally, run `npm run seed` to populate the database with initial data.
7. Navigate back to project root folder and run `npm run start:dev` which will run the application with nodemon for faster development. Application is started on `localhost` with port defined by `BACKEND_PORT`, default is `8080`. 
8.  Run `npm run migrate` and then `npm run seed` to add database data. 
9.  (optional) Run `npm run prepare` to configure husky and git hooks. Usually this is done automatically when running `npm install`.
   
> Note: Make sure to adhere to the commitlint guidelines for commiting, otherwise hooks might fail. An online helper can be found [here](https://commitlint.io/)

#### Commands
You can run all commands from the `package.json`, just preface it with `npm run <command>`. These are some basic explanations:

| Command     | Details |
|-------------|-----------|
| start:dev   | Run the application with `nodemon` for automatic reloading when applying changes in `src` folder. |
| build       | Build the TypeScript files to JavaScript. Output can be found in `dist` folder. |
| lint        | Highlight formatting issues using eslint. |
| format      | Try autoformatting files in `src`. Issues not being autoformatted will be printed. |
| test        | Run the tests in `tests` folder. |
| test:ci     | Run the tests in `tests` folder using a coverage reporter for Gitlab CI/CD and Badges. |
| prepare     | Runs automatically when using `npm i` or equivalent. Will install husky and apply git hooks in folder `.husky`. |
| migrate     | Apply database migrations using `knexjs` from folder `src/database/migrations` |
| rollback    | Rollback database migrations using `knexjs` from folder `src/database/migrations` |
| seed        | Apply database seeds using `knexjs` from folder `src/database/seeds` |
| docs        | Generate or update TSDOC Code documentation in `docs` folder. |
| git:update  | Update git submodules in this project |

#### Add a new Endpoint/ API Route

This guide explains how to develop a new route for the backend. Make sure to read the full guide before starting!

##### Controller
First you should figure out which "type" your new route belongs to e.g. if your route returns informations on a component, the route should be added to `src/controller/component.controller.ts`. To add a new route check the `loadRoutes` function of the according file, this is where all endpoints are set. Choose the according API method (e.g. GET) and add the route like this
```sh
this.router.get('/components', TODO);
```
If you need params (e.g. productId) in your route add them like this `/product/:productId`.
> Note: You do not need to manually handle where the data ends up. The validator will merge all data from query, params and body together and append it to `req.body`.

##### Validation
All routes require data validation therefore you need to add `validateRequest` to your route:
```js
this.router.get('/products', validateRequest, TODO);
```
So far you've added the route and added valdidation method but no information on how to validate. Navigate to `src/models/products` (or create a new folder in `models` if your new route did not fit any of the existing types). In every models subfolder are usually two files: `model.ts` and `scheme.ts`. The model file defines the data of the according type (e.g. product) in the database as well as the services and database interfaces (more of that later). You should first define your reponse data in the model file. The scheme file is similar to the model file but here the data is represented using Joi for validation. Check if the according types already exist or create a new one. Make sure to export your data both in the scheme as well as the model file. To define which Joi scheme should be applied to your route for validation, modify the `scheme` constant. Example:
```js
schemas['/products'] = {
    GET: productIdScheme
};
```
The above example will check the `/products` route with method `GET` according to the `productIdScheme`. Be careful not to overwrite existing validations. If you have a route with parameters e.g. `GET /products/:productId/name` remove the parameters from the route so you get `/product/name`. This will be the route the scheme validator will search for (`schemas['/products/name'] = {...}`). 

> Note: You do not need to manually handle where the data ends up. The validator will merge all data from query, params and body together and append it to `req.body`.

##### Service and Database 

In order to handle the request you need to modify the according service and database handlers. Check the `src/models/product/product.model.ts` file. In there you will find two interfaces `I_Product_Database` and `I_Product_Service`.

> Note: This applies to every controller e.g. controller order also has two files `order.scheme.ts` and `order.model.ts` in `src/models/order` with the two interfaces for Service and Database in the model file. 

The Service and Database interfaces define the functions (with input and output) the classes need to implement. Note that the controllers all have a `Service` given by the constructor. The type of the service references the interface and NOT the actual class. The same applies to the actual service classes which reference the database interfaces NOT the database classes. This is done in order to only define the functionality, making it easier to exchange classes without having to modify too much code. 

Add your new function to the Service Interface and if you need also to the Database interface. If you check the according files in `src/services` and `src/database`, you should be getting an error due to missing functions. Add the functions and make sure the type definitions are correct, then implement them. If any form of error can appear in either your service or database function, use `CustomErrorHandler` to create an error and return it with `return next(...) `. In your service class make sure to send the response with the according status and pick either `res.send` or `res.json`. For sending or receiving files make sure to check  `src/services/file.service.ts`. Database requests are handled using [Knex.js](https://knexjs.org/). 

> Note: If you use automatic fix (e.g. in VSCode) the service classes usually import the wrong type for `req, res, response`. Make sure they reference the express defintions.

The last step is to add your service function to the according route. Let's say you implemented the function `getAllProducts` for `I_Product_Service`. You need to add it to your controller like this:
```js
this.router.get('/products', validateRequest, this.service.getAllProducts);
```

### Production

### pm2
1. Follow the [dev instructions for installation](#development).
2. From the backend project’s root folder, run npm run build to build the JavaScript
files from the existing TypeScript Source Code. This will create a new folder `dist`
3. Optionally, to run the application in background, install pm2 globally (`npm i pm2`)
4. Start the app with either `node dist/index.js` or an equivalent command like `pm2 start
dist/index.js`

### Docker
Coming soon

## Roadmap

- [x] Add knex migration files for database setup
- [x] test component controller, service, database files
- [ ] add remaining handlers
  - [ ] project
  - [ ] location
- [x] update file handler 
  - [x] write location in database
  - [x] set write location as env
- [x] update component 
  - [x] database vendor informations
  - [x] file handler 