# Discourse YooMoney Plugin

Этот плагин позволяет принимать платежи через ЮMoney (ранее Яндекс.Деньги) на форуме Discourse. После успешной оплаты пользователь автоматически добавляется в указанную группу.

## Функции

- Прием платежей через HTTP-уведомления ЮMoney.
- Автоматическое добавление пользователя в группу после оплаты.
- Настраиваемая сумма оплаты и валюта.
- Поддержка локализации (RU/EN).

## Установка

1. Добавьте URL репозитория в ваш `app.yml`:
   ```yaml
   hooks:
     after_code:
       - exec:
           cd: $home/plugins
           cmd:
             - git clone https://github.com/yourusername/discourse-yoomoney.git
   ```
2. Пересоберите Discourse:
   ```bash
   ./launcher rebuild app
   ```

## Настройка

Перейдите в **Settings -> Plugins -> yoomoney** и заполните следующие поля:

1. **yoomoney_enabled**: Включить плагин.
2. **yoomoney_wallet_id**: Номер вашего кошелька ЮMoney.
3. **yoomoney_notification_secret**: Секретное слово для уведомлений (можно найти в настройках ЮMoney -> API -> HTTP-уведомления).
4. **yoomoney_target_group**: Название группы, в которую будет добавлен пользователь (по умолчанию `trust_level_1`).
5. **yoomoney_payment_amount**: Сумма платежа.

## Лицензия

MIT
