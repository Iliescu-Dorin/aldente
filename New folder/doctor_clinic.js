/// <reference path="../pb_data/types.d.ts" />

migrate((db) => {
  const doctorClinicCollection = new Collection({
    "id": "doctor_clinic",
    "name": "DoctorClinic",
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
        "id": "clinic_id",
        "name": "clinic_id",
        "type": "relation",
        "required": true,
        "options": {
          "collectionId": "clinic",
          "cascadeDelete": true,
          "minSelect": 1,
          "maxSelect": 1
        }
      }
    ]
  });
  const dao = new Dao(db);
  return dao.saveCollection(doctorClinicCollection);
}, (db) => {
  const dao = new Dao(db);
  return dao.deleteCollection(doctorClinicCollection);
});