USE Vodokanal;
GO

CREATE OR ALTER PROCEDURE sp_ПоказатьФизЛиц
AS
BEGIN
    SELECT ID_абонента, Фамилия, Имя, Отчество, Телефон, Адрес_регистрации
    FROM Абоненты WHERE ID_типа = 1 ORDER BY Фамилия;
END;
GO


CREATE OR ALTER PROCEDURE sp_ДолгПоСчёту @НомерСчёта NVARCHAR(50)
AS
BEGIN
    SELECT лс.Номер_счёта, 
           CASE WHEN а.Фамилия IS NOT NULL THEN а.Фамилия + N' ' + а.Имя ELSE а.Наименование_юрлица END AS Абонент,
           лс.Текущий_баланс AS Долг
    FROM Лицевые_счета лс
    LEFT JOIN Договоры д ON д.ID_лицевого_счёта = лс.ID_лицевого_счёта
    LEFT JOIN Абоненты а ON а.ID_абонента = д.ID_абонента
    WHERE лс.Номер_счёта = @НомерСчёта;
END;
GO


CREATE OR ALTER PROCEDURE sp_ИсторияПлатежей @НомерСчёта NVARCHAR(50)
AS
BEGIN
    SELECT п.Дата_платежа, п.Сумма, п.Способ_оплаты, п.Статус_платежа
    FROM Платежи п
    INNER JOIN Лицевые_счета лс ON лс.ID_лицевого_счёта = п.ID_лицевого_счёта
    WHERE лс.Номер_счёта = @НомерСчёта ORDER BY п.Дата_платежа DESC;
END;
GO

PRINT 'Хранимые процедуры созданы успешно';
GO
