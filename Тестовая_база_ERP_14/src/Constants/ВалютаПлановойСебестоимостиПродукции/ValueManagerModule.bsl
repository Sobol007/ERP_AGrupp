#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Возвращает текст ошибки, в случаях, когда константа необходима, но не включена.
//
// Возвращаемое значение:
//    ТекстИсключения - Строка - Сообщение о том, что константа не задана, и указанием места, где ее можно включить.
//
Процедура СообщитьКонстантаНеЗаполненаИВызватьИсключение() Экспорт
	
	ТекстИсключения = НСтр("ru = 'Не задана валюта плановой себестоимости продукции. Валюта устанавливается в разделе ""НСИ и администрирование"" - ""Производство"".';
							|en = 'Product target cost currency is not specified. The currency is set in section ""Master data and settings"" - ""Manufacturing"".'");
	ВызватьИсключение ТекстИсключения;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли