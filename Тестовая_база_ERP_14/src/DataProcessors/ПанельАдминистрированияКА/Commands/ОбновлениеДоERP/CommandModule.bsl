
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ДополнительныеПараметры = Новый Структура("ЗаголовокОкна,ЗаголовокНетОбновления");
	ДополнительныеПараметры.ЗаголовокОкна = НСтр("ru = 'Переход на программу: 1С:ERP Управление предприятием 2';
												|en = 'Migration to the application: 1C:ERP 2 (Enterprise Resource Management)'");
	ДополнительныеПараметры.ЗаголовокНетОбновления = НСтр("ru = 'Обновления отсутствуют.';
															|en = 'There are no updates.'");
	
	ПолучениеОбновленийПрограммыКлиент.ПерейтиНаДругуюПрограмму("Enterprise20",,ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти



