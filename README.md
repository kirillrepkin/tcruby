
## Run

Сборка образа установшика (инициализация БД)

```sh
docker build . -f Install.dockerfile -t money_transfer_app_install
```

Сборка образа приложения

```sh
docker build . -f Application.dockerfile -t money_transfer_app
```

Запуск установщика

```sh
docker-compose up -d install
```

Просмотр логов установщика. Не должно быть ошибок

```sh
docker-compose logs installer
```

Запуск приложения

```sh
docker-compose up -d app
```

Проверка работоспособности

```sh
curl -X GET http://localhost:8080/api/v1/user/ivan01.ivanov/balance | jq
```

Результат должен быть следующим

```json
{
  "user_id": "4fe31bba-ad0b-11ec-b909-0242ac120002",
  "sum": 10500,
  "currency": "EUR"
}
```