import type { Knex } from "knex";


export async function up(knex: Knex): Promise<void> {
    return knex.schema.createTable('componentVendorInfo', (table) => {
        table.increments('componentVendorId').primary(),
            table.integer('vendorInfoId').unsigned().nullable(),
            table.integer('componentId').unsigned().notNullable(),
            table.foreign('vendorInfoId').references('vendorInfoId').inTable('vendorInfos');
            table.foreign('componentId').references('componentId').inTable('components'),
            table.dateTime('updatedAt').defaultTo(knex.raw('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'));
    });
}


export async function down(knex: Knex): Promise<void> {
    return knex.schema.dropTableIfExists('componentVendorInfo');
}

