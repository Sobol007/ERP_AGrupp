
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Заголовок = Параметры.Заголовок;
	Элементы.ДекорацияПредставлениеРезультата.Заголовок = Параметры.ПредставлениеРезультата;
	
	Если ЗначениеЗаполнено(Параметры.ТабличныйДокумент) Тогда
		
		ИмяСправочника = "ИсторияПроверкиИКорректировкиДанныхПрисоединенныеФайлы";
		Если Метаданные.Справочники.Найти(ИмяСправочника) <> Неопределено
			И ТипЗнч(Параметры.ТабличныйДокумент) = Тип("СправочникСсылка." + ИмяСправочника) Тогда
			
			НачатьТранзакцию();
			Попытка
				
				Блокировка = Новый БлокировкаДанных;
				ЭлементБлокировки = Блокировка.Добавить("Справочник.ИсторияПроверкиИКорректировкиДанныхПрисоединенныеФайлы");
				ЭлементБлокировки.УстановитьЗначение("Ссылка", Параметры.ТабличныйДокумент);
				ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
				
				Попытка
					Блокировка.Заблокировать();
				Исключение
					ВызватьИсключение НСтр("ru = 'Файл уже удален, возможно в другом сеансе была запущена проверка.';
											|en = 'File is already removed. Checking may have been started in another session.'");
				КонецПопытки;
				
				ТабличныйДокумент = ПроверкаИКорректировкаДанных.ТабличныйДокументИзПрисоединенногоФайла(Параметры.ТабличныйДокумент);
				ЗафиксироватьТранзакцию();
				
			Исключение
				ОтменитьТранзакцию();
				ВызватьИсключение;
			КонецПопытки;
			
		ИначеЕсли ЭтоАдресВременногоХранилища(Параметры.ТабличныйДокумент) Тогда
			
			ИмяВременногоФайла = ПолучитьИмяВременногоФайла("mxl");
			ДвоичныеДанные = ПолучитьИзВременногоХранилища(Параметры.ТабличныйДокумент);
			ДвоичныеДанные.Записать(ИмяВременногоФайла);
			ТабличныйДокумент.Прочитать(ИмяВременногоФайла);
			УдалитьФайлы(ИмяВременногоФайла);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
