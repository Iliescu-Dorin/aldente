/// <reference path="../pb_data/types.d.ts" />

migrate((db) => {
  const clinicCollection = new Collection({
      "id": "clinic",
      "name": "Clinic",
      "schema": [
          {
              "id": "name",
              "name": "name",
              "type": "text",
              "required": true
          },
          {
              "id": "address",
              "name": "address",
              "type": "text",
              "required": true
          },
          {
              "id": "phone_number",
              "name": "phone_number",
              "type": "text"
          }
      ]
  });

  const dao = new Dao(db);
  return dao.saveCollection(clinicCollection);
}, (db) => {
  const dao = new Dao(db);
  const clinicCollection = dao.findCollectionByNameOrId("clinic");
  return dao.deleteCollection(clinicCollection);
});