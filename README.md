# Корзина покупок с системой скидок

Это Ruby on Rails приложение, которое позволяет добавлять товары в корзину, применять скидку, 
и оформлять заказ.

## Основные возможности

- **Корзина покупок**: добавление и удаление товаров, изменение их количества.
- **Система скидок**: возможность применения денежной скидки, которая не может превышать общую стоимость корзины.
- **Разделение логики**: реализованы сервисные объекты для повторного заполнения пустой корзины данными по умолчанию, для склонения существительных множественного числа, а также для оформления заказа.

## Технологии

- Ruby (версия 3.4.1)
- Ruby on Rails (версия 8.0.2)
- Tailwind CSS
- SQLite

## Установка

Клонируйте репозиторий:

```bash
git clone <url>
cd <название_папки>
```

Установите зависимости:

```bash
bundle install
```

Поднимите базу данных:

```bash
rails db:create
rails db:migrate
rails db:seed
```

Запустите сервер:

```bash
bin/dev
```

