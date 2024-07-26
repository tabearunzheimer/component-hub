import { Knex } from "knex";

export async function up(knex: Knex): Promise<void> {
    return knex.schema.createTable('componentLocation', (table) => {
        table.increments('componentLocationId').primary(),
            table.integer('componentId').unsigned().nullable(),
            table.integer('locationId').unsigned().nullable(),
            table.foreign('locationId').references('locationId').inTable('locations');
            table.foreign('componentId').references('componentId').inTable('components');
            table.dateTime('updatedAt').defaultTo(knex.raw('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'));
    });
}


export async function down(knex: Knex): Promise<void> {
    return knex.schema.dropTableIfExists('componentLocation');
}

