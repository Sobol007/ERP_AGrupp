
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Заголовок = "Проведение документа """ + СокрЛП(Ссылка) + """: ";
	
	Если ВидПоказателя = Перечисления.АГ_ВидыНормативныхПоказателей.ВероятностьОтгрузки ИЛИ 
		ВидПоказателя = Перечисления.АГ_ВидыНормативныхПоказателей.ВнутриотраслевоеПотребление Тогда
		
		Если Не ЗначениеЗаполнено(Отрасль) Тогда
			
			ТекстОшибки = "Не выбрана отрасль!";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			,
			,
			Отказ);
		КонецЕсли;
	Иначе
		Если Не ЗначениеЗаполнено(ЦФО) Тогда
			
			ТекстОшибки = "Не выбран металлоцентр!";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			,
			,
			Отказ);
		КонецЕсли;
	КонецЕсли;
	
	Если ВидПоказателя = Перечисления.АГ_ВидыНормативныхПоказателей.ВнутриотраслевоеПотребление Тогда
		Если НЕ ПотреблениеНоменклатуры.Итог("ДоляПотребления") = 100 Тогда
			
			ТекстОшибки = "Сумма долей потребления не равна 100!";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			,
			,
			Отказ);
		КонецЕсли;
	КонецЕсли;
	
	Если ВидПоказателя = Перечисления.АГ_ВидыНормативныхПоказателей.ДомашниеРегионы Тогда
		Если НЕ ЗначениеЗаполнено(ОсновнойДомашнийРегион) Тогда
			
			ТекстОшибки = "Не выбран основной регион!";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			,
			,
			Отказ);
		КонецЕсли;
	КонецЕсли;
	
	Для Каждого ТекСтр Из СезонностиРегиона Цикл
		ВСЕГО = ТекСтр.Январь + ТекСтр.Февраль + ТекСтр.Март + ТекСтр.Апрель + ТекСтр.Май + ТекСтр.Июнь + ТекСтр.Июль + ТекСтр.Август + ТекСтр.Сентябрь + ТекСтр.Октябрь + ТекСтр.Ноябрь + ТекСтр.Декабрь;
		
		Если Не ВСЕГО = 100 Тогда
			
			ТекстОшибки = "В строке " + Строка(ТекСтр.НомерСтроки) + " табличной части ""Сезонность региона"" общая сумма коэффициентов не равна 100!";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			,
			,
			Отказ);
		КонецЕсли;
	КонецЦикла;
	
	ВыполнитьПрверкуНаДублиДомашнихРегионов(Отказ, Заголовок);
	
КонецПроцедуры

Процедура ВыполнитьПрверкуНаДублиДомашнихРегионов(Отказ, Заголовок)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ВводНормативныхПоказателейРегионы.Регион КАК Регион,
	|	ВложенныйЗапрос.ЦФО КАК ЦФО
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВводНормативныхПоказателей.ЦФО КАК ЦФО,
	|		МАКСИМУМ(ВводНормативныхПоказателей.Период) КАК Период,
	|		ВводНормативныхПоказателей.ВидПоказателя КАК ВидПоказателя
	|	ИЗ
	|		Документ.АГ_ВводНормативныхПоказателей КАК ВводНормативныхПоказателей
	|	ГДЕ
	|		ВводНормативныхПоказателей.Проведен
	|		И ВводНормативныхПоказателей.ЦФО <> &ЦФО
	|		И ВводНормативныхПоказателей.ВидПоказателя = &ВидПоказателя
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ВводНормативныхПоказателей.ЦФО,
	|		ВводНормативныхПоказателей.ВидПоказателя) КАК ВложенныйЗапрос
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.АГ_ВводНормативныхПоказателей.Регионы КАК ВводНормативныхПоказателейРегионы
	|		ПО ВложенныйЗапрос.ЦФО = ВводНормативныхПоказателейРегионы.Ссылка.ЦФО
	|			И ВложенныйЗапрос.Период = ВводНормативныхПоказателейРегионы.Ссылка.Период
	|			И ВложенныйЗапрос.ВидПоказателя = ВводНормативныхПоказателейРегионы.Ссылка.ВидПоказателя
	|ГДЕ
	|	ВводНормативныхПоказателейРегионы.Ссылка.Проведен
	|	И ВводНормативныхПоказателейРегионы.Ссылка.ЦФО <> &ЦФО
	|	И ВводНормативныхПоказателейРегионы.Регион В(&Регион)
	|	И ВводНормативныхПоказателейРегионы.Регион.CRM_КодСтраны = ""7""
	|
	|СГРУППИРОВАТЬ ПО
	|	ВводНормативныхПоказателейРегионы.Регион,
	|	ВложенныйЗапрос.ЦФО";
	
	Запрос.УстановитьПараметр("ЦФО", ЦФО);
	Запрос.УстановитьПараметр("ВидПоказателя", Перечисления.АГ_ВидыНормативныхПоказателей.ДомашниеРегионы);
	Запрос.УстановитьПараметр("Регион", Регионы.ВыгрузитьКолонку("Регион"));
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ОбщегоНазначения.СообщитьОбОшибке("Регион " + Строка(Выборка.Регион) + " присутствует в другом ЦФО: " + Строка(Выборка.ЦФО), Отказ, Заголовок);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если Не Отказ Тогда
		Если ВидПоказателя = Перечисления.АГ_ВидыНормативныхПоказателей.ДомашниеРегионы Тогда
						
			ЦФООб = ЦФО.ПолучитьОбъект();
			ВыполнитьДвиженияПоДомашниеРегионы(ЦФООб);
			ЦФООб.АГ_ОсновнойРегион = ОсновнойДомашнийРегион;
			 Попытка
				ЦФООб.ОбменДанными.Загрузка = Истина;
				ЦФООб.Записать();
			Исключение
			КонецПопытки;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьДвиженияПоДомашниеРегионы(ЦФООб)
	
	ЦФООб.АГ_Регионы.Загрузить(Регионы.Выгрузить());
	
КонецПроцедуры

