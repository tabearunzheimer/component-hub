import type { Knex } from "knex";


export async function up(knex: Knex): Promise<void> {
    return knex.schema.createTable('fileStore', (table) => {
        table.increments('fileStoreId').primary(),
            table.integer('componentId').unsigned().nullable(),
            table.integer('projectId').unsigned().nullable(),
            table.integer('fileId').unsigned().notNullable(),
            table.foreign('projectId').references('projectId').inTable('projects');
            table.foreign('componentId').references('componentId').inTable('components'),
            table.foreign('fileId').references('fileId').inTable('files'),
            table.dateTime('updatedAt').defaultTo(knex.raw('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'));
    });
}


export async function down(knex: Knex): Promise<void> {
    return knex.schema.dropTableIfExists('fileStore');
}

