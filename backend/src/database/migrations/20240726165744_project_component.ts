import { Knex } from "knex";

export async function up(knex: Knex): Promise<void> {
    return knex.schema.createTable('projectComponents', (table) => {
        table.increments('projectComponentsId').primary(),
            table.integer('componentId').unsigned().nullable(),
            table.integer('projectId').unsigned().nullable(),
            table.integer('amount'),
            table.foreign('projectId').references('projectId').inTable('projects');
            table.foreign('componentId').references('componentId').inTable('components');
            table.dateTime('updatedAt').defaultTo(knex.raw('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'));
    });
}


export async function down(knex: Knex): Promise<void> {
    return knex.schema.dropTableIfExists('projectComponents');
}

