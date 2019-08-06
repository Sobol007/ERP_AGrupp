#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура УстановитьСостояние(ДанныеЗаписи) Экспорт
    
    Менеджер = СоздатьМенеджерЗаписи();
    ЗаполнитьЗначенияСвойств(Менеджер, ДанныеЗаписи);
    Менеджер.Записать();
    
КонецПроцедуры

Процедура ОчиститьСостояние(ИдентификаторОбъекта, УчетнаяСистема) Экспорт
    
    Набор = СоздатьНаборЗаписей();
    Набор.Отбор.ИдентификаторОбъекта.Установить(ИдентификаторОбъекта, Истина);
    Набор.Отбор.УчетнаяСистема.Установить(УчетнаяСистема, Истина);
    Набор.ДополнительныеСвойства.Вставить("ИдентификаторОбъекта", ИдентификаторОбъекта);
    Набор.Записать();
    
КонецПроцедуры

Функция НовыйДанныеЗаписи() Экспорт
	
    ДанныеЗаписи = Новый Структура;
    ДанныеЗаписи.Вставить("УчетнаяСистема");
    ДанныеЗаписи.Вставить("ИдентификаторОбъекта", "");
    ДанныеЗаписи.Вставить("Состояние", Перечисления.СостоянияИнтеграцииОбъектов.ПустаяСсылка());
    ДанныеЗаписи.Вставить("Описание", "");
    
    Возврат ДанныеЗаписи;
	
КонецФункции


#КонецОбласти

#КонецЕсли
