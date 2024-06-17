/// <reference path="../pb_data/types.d.ts" />

migrate((db) => {
  const serviceCollection = new Collection({
      "id": "service",
      "name": "Service",
      "schema": [
          {
              "id": "specialty_id",
              "name": "specialty_id",
              "type": "relation",
              "required": true,
              "options": {
                  "collectionId": "specialty",
                  "cascadeDelete": false,
                  "minSelect": 1,
                  "maxSelect": 1
              }
          },
          {
              "id": "name",
              "name": "name",
              "type": "text",
              "required": true
          },
          {
              "id": "description",
              "name": "description",
              "type": "text"
          }
      ]
  });

  const dao = new Dao(db);
  return dao.saveCollection(serviceCollection);
}, (db) => {
  const dao = new Dao(db);
  const serviceCollection = dao.findCollectionByNameOrId("service");
  return dao.deleteCollection(serviceCollection);
});