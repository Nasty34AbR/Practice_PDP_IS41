USE Vodokanal;
GO

CREATE OR ALTER TRIGGER trg_ОбновитьБаланс
ON Платежи AFTER INSERT
AS
BEGIN
    UPDATE лс SET Текущий_баланс = лс.Текущий_баланс - i.Сумма
    FROM Лицевые_счета лс INNER JOIN inserted i ON i.ID_лицевого_счёта = лс.ID_лицевого_счёта
    WHERE i.Статус_платежа = N'Проведён';
END;
GO


CREATE OR ALTER TRIGGER trg_ЗапретОтрицательногоБаланса
ON Платежи INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO Платежи (ID_лицевого_счёта, Дата_платежа, Сумма, Способ_оплаты, Статус_платежа, Идентификатор_транзакции)
    SELECT ID_лицевого_счёта, Дата_платежа, Сумма, Способ_оплаты, Статус_платежа, Идентификатор_транзакции
    FROM inserted WHERE EXISTS (SELECT 1 FROM Лицевые_счета лс WHERE лс.ID_лицевого_счёта = inserted.ID_лицевого_счёта AND лс.Текущий_баланс - inserted.Сумма >= 0);
END;
GO

PRINT 'Триггеры созданы успешно';
GO
