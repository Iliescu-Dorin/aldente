/// <reference path="../pb_data/types.d.ts" />

migrate((db) => {
  const specialtyCollection = new Collection({
      "id": "specialty",
      "name": "Specialty",
      "schema": [
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
  return dao.saveCollection(specialtyCollection);
}, (db) => {
  const dao = new Dao(db);
  const specialtyCollection = dao.findCollectionByNameOrId("specialty");
  return dao.deleteCollection(specialtyCollection);
});