# CryptorAksenov

Тестовое задание SafeTech, версия 2. 

Что было исправлено/переделано: 

1) Ассиметричная ключевая пара и Secure Enclave. Разобрался как что работает сделал класс для ключей CryptorKeysHelper. Самое сложное было - понять, что для работы с KeyChain во вреймворке нужно TestHost App
2) Выпилил сторонний фреймворк для шифрования - использую SecKeyCreateEncryptedData/SecKeyCreateDecryptedData
3) Данные в CoreData теперь хранятся не в формате String, а в формате Data - показался лишним этап конвертации в строку после шифрования
4) Остальное по мелочи