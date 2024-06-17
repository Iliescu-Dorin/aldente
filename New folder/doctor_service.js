/// <reference path="../pb_data/types.d.ts" />

migrate((db) => {
  const doctorServiceCollection = new Collection({
    "id": "doctor_service",
    "name": "DoctorService",
    "schema": [
      {
        "id": "doctor_id",
        "name": "doctor_id",
        "type": "relation",
        "required": true,
        "options": {
          "collectionId": "doctor",
          "cascadeDelete": true,
          "minSelect": 1,
          "maxSelect": 1
        }
      },
      {
        "id": "service_id",
        "name": "service_id",
        "type": "relation",
        "required": true,
        "options": {
          "collectionId": "service",
          "cascadeDelete": true,
          "minSelect": 1,
          "maxSelect": 1
        }
      },
      {
        "id": "price",
        "name": "price",
        "type": "number",
        "required": true
      },
      {
        "id": "clinic_id",
        "name": "clinic_id",
        "type": "relation",
        "required": true,
        "options": {
          "collectionId": "clinic",
          "cascadeDelete": false,
          "minSelect": 1,
          "maxSelect": 1
        }
      }
    ]
  });
  const dao = new Dao(db);
  return dao.saveCollection(doctorServiceCollection);
}, (db) => {
  const dao = new Dao(db);
  return dao.deleteCollection(doctorServiceCollection);
});