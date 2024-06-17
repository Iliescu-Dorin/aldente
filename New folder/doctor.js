/// <reference path="../pb_data/types.d.ts" />

migrate((db) => {
  const doctorCollection = new Collection({
      "id": "doctor",
      "name": "Doctor",
      "schema": [
          {
              "id": "user_id",
              "name": "user_id",
              "type": "relation",
              "required": true,
              "options": {
                  "collectionId": "user",
                  "cascadeDelete": true,
                  "minSelect": 1,
                  "maxSelect": 1
              }
          },
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
              "id": "license_number",
              "name": "license_number",
              "type": "text",
              "required": true,
              "unique": true
          },
          {
              "id": "years_of_exp",
              "name": "years_of_exp",
              "type": "number"
          }
      ]
  });

  const dao = new Dao(db);
  return dao.saveCollection(doctorCollection);
}, (db) => {
  const dao = new Dao(db);
  const doctorCollection = dao.findCollectionByNameOrId("doctor");
  return dao.deleteCollection(doctorCollection);
});