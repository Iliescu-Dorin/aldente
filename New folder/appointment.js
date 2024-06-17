/// <reference path="../pb_data/types.d.ts" />

migrate((db) => {
    const appointmentCollection = new Collection({
        "id": "appointment",
        "name": "Appointment",
        "schema": [
            {
                "id": "doctor_id",
                "name": "doctor_id",
                "type": "relation",
                "required": true,
                "options": {
                    "collectionId": "doctor",
                    "cascadeDelete": false,
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
                    "cascadeDelete": false,
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
                    "cascadeDelete": false,
                    "minSelect": 1,
                    "maxSelect": 1
                }
            },
            {
                "id": "user_id",
                "name": "user_id",
                "type": "relation",
                "required": true,
                "options": {
                    "collectionId": "user",
                    "cascadeDelete": false,
                    "minSelect": 1,
                    "maxSelect": 1
                }
            },
            {
                "id": "start_time",
                "name": "start_time",
                "type": "date",
                "required": true
            },
            {
                "id": "end_time",
                "name": "end_time",
                "type": "date",
                "required": true
            },
            {
                "id": "status",
                "name": "status",
                "type": "text",
                "required": true
            }
        ]
    });

    const dao = new Dao(db);
    return dao.saveCollection(appointmentCollection);
}, (db) => {
    const dao = new Dao(db);
    const appointmentCollection = dao.findCollectionByNameOrId("appointment");
    return dao.deleteCollection(appointmentCollection);
});
