/// <reference path="../pb_data/types.d.ts" />

migrate((db) => {
  const userCollection = new Collection({
    "id": "user",
    "name": "User",
    "schema": [
      {
        "id": "username",
        "name": "username",
        "type": "text",
        "required": true,
        "unique": true
      },
      {
        "id": "email",
        "name": "email",
        "type": "text",
        "required": true,
        "unique": true
      },
      {
        "id": "password",
        "name": "password",
        "type": "text",
        "required": true
      },
      {
        "id": "role",
        "name": "role",
        "type": "text",
        "required": true
      }
    ]
  });
  const dao = new Dao(db);
  return dao.saveCollection(userCollection);
}, (db) => {
  const dao = new Dao(db);
  return dao.deleteCollection(userCollection);
});