/// <reference path="../pb_data/types.d.ts" />

migrate((db) => {
  const profileCollection = new Collection({
      "id": "profile",
      "name": "Profile",
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
              "id": "first_name",
              "name": "first_name",
              "type": "text",
              "required": true
          },
          {
              "id": "last_name",
              "name": "last_name",
              "type": "text",
              "required": true
          },
          {
              "id": "gender",
              "name": "gender",
              "type": "text"
          },
          {
              "id": "date_of_birth",
              "name": "date_of_birth",
              "type": "date"
          },
          {
              "id": "address",
              "name": "address",
              "type": "text"
          },
          {
              "id": "phone_number",
              "name": "phone_number",
              "type": "text"
          }
      ]
  });

  const dao = new Dao(db);
  return dao.saveCollection(profileCollection);
}, (db) => {
  const dao = new Dao(db);
  const profileCollection = dao.findCollectionByNameOrId("profile");
  return dao.deleteCollection(profileCollection);
});
