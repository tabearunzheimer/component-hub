import type { Knex } from "knex";


export async function up(knex: Knex): Promise<void> {
    return knex.schema.createTable('components', (table) => {
        table.increments('componentId').primary(),
            table.string('name').notNullable(),
            table.text('description'),
            table.integer('stock'),
            table.text('specs'),
            table.text('urls'),
            table.dateTime('createdAt').notNullable().defaultTo(knex.raw('CURRENT_TIMESTAMP'));
            table.dateTime('updatedAt').defaultTo(knex.raw('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'));
    });

}


export async function down(knex: Knex): Promise<void> {
    return knex.schema.dropTableIfExists('components');
}

