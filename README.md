## Переменные окружения

Создание файла с переменными окружениями

```sh
cp development.env.sample development.env
```

Модифицировать значения в файле development.env - убрать # и задать значения пароля для postgres 


## Run

Сборка образа приложения

```sh
docker build . -t money_transfer_app
```

Запуск установщика

```sh
docker-compose up -d installer
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

## Unit tests

```sh
export $(cat development.env | xargs)
export POSTGRES_HOST=localhost && rake test:unit
```