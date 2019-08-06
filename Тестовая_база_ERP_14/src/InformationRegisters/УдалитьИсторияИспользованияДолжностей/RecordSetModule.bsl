#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	СохранитьИзменениеИспользованияДолжностей(ЭтотОбъект.Отбор.Регистратор.Значение, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СохранитьИзменениеИспользованияДолжностей(Регистратор, ТекущийНабор)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Регистратор);
	Запрос.УстановитьПараметр("ТекущийНабор", ТекущийНабор);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИсторияИспользованияДолжностей.Должность
	|ПОМЕСТИТЬ ВТПредыдущийНабор
	|ИЗ
	|	РегистрСведений.УдалитьИсторияИспользованияДолжностей КАК ИсторияИспользованияДолжностей
	|ГДЕ
	|	ИсторияИспользованияДолжностей.Регистратор = &Регистратор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТекущийНабор.Должность,
	|	ТекущийНабор.Используется,
	|	ТекущийНабор.Период
	|ПОМЕСТИТЬ ВТТекущийНабор
	|ИЗ
	|	&ТекущийНабор КАК ТекущийНабор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТекущийНабор.Должность,
	|	ТекущийНабор.Период,
	|	ТекущийНабор.Используется
	|ПОМЕСТИТЬ ВТДолжностиНаборов
	|ИЗ
	|	ВТТекущийНабор КАК ТекущийНабор
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПредыдущийНабор.Должность,
	|	ДАТАВРЕМЯ(1, 1, 1),
	|	ЛОЖЬ
	|ИЗ
	|	ВТПредыдущийНабор КАК ПредыдущийНабор
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТекущийНабор КАК ТекущийНабор
	|		ПО ПредыдущийНабор.Должность = ТекущийНабор.Должность
	|ГДЕ
	|	ТекущийНабор.Должность ЕСТЬ NULL 
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	МИНИМУМ(ИсторияИспользованияДолжностей.Период) КАК Период,
	|	ИсторияИспользованияДолжностей.Должность КАК Должность,
	|	ИсторияИспользованияДолжностей.Используется КАК Используется
	|ПОМЕСТИТЬ ВТРанниеПериодыИспользованияДолжностей
	|ИЗ
	|	РегистрСведений.УдалитьИсторияИспользованияДолжностей КАК ИсторияИспользованияДолжностей
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДолжностиНаборов КАК ДолжностиНаборов
	|		ПО ИсторияИспользованияДолжностей.Должность = ДолжностиНаборов.Должность
	|			И (ИсторияИспользованияДолжностей.Используется)
	|			И (ИсторияИспользованияДолжностей.Регистратор <> &Регистратор)
	|
	|СГРУППИРОВАТЬ ПО
	|	ИсторияИспользованияДолжностей.Должность,
	|	ИсторияИспользованияДолжностей.Используется
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИсторияИспользованияДолжностей.Организация КАК Организация,
	|	ИсторияИспользованияДолжностей.Должность КАК Должность,
	|	МАКСИМУМ(ИсторияИспользованияДолжностей.Период) КАК Период
	|ПОМЕСТИТЬ ВТПоздниеПериодыДолжностейПоОрганизациям
	|ИЗ
	|	РегистрСведений.УдалитьИсторияИспользованияДолжностей КАК ИсторияИспользованияДолжностей
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДолжностиНаборов КАК ДолжностиНаборов
	|		ПО ИсторияИспользованияДолжностей.Должность = ДолжностиНаборов.Должность
	|			И (ИсторияИспользованияДолжностей.Регистратор <> &Регистратор)
	|
	|СГРУППИРОВАТЬ ПО
	|	ИсторияИспользованияДолжностей.Организация,
	|	ИсторияИспользованияДолжностей.Должность
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	МАКСИМУМ(ИсторияИспользованияДолжностейПоздние.Период) КАК Период,
	|	ИсторияИспользованияДолжностейПоздние.Должность КАК Должность,
	|	ИсторияИспользованияДолжностейПоздние.Используется КАК Используется
	|ПОМЕСТИТЬ ВТИспользуемыеДолжности
	|ИЗ
	|	ВТПоздниеПериодыДолжностейПоОрганизациям КАК ПоздниеПериодыДолжностейПоОрганизациям
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.УдалитьИсторияИспользованияДолжностей КАК ИсторияИспользованияДолжностейПоздние
	|		ПО ПоздниеПериодыДолжностейПоОрганизациям.Должность = ИсторияИспользованияДолжностейПоздние.Должность
	|			И ПоздниеПериодыДолжностейПоОрганизациям.Организация = ИсторияИспользованияДолжностейПоздние.Организация
	|			И ПоздниеПериодыДолжностейПоОрганизациям.Период = ИсторияИспользованияДолжностейПоздние.Период
	|			И (ИсторияИспользованияДолжностейПоздние.Используется)
	|
	|СГРУППИРОВАТЬ ПО
	|	ИсторияИспользованияДолжностейПоздние.Должность,
	|	ИсторияИспользованияДолжностейПоздние.Используется
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ИсторияИспользованияДолжностейПоздние.Период) КАК Период,
	|	ИсторияИспользованияДолжностейПоздние.Должность КАК Должность,
	|	ИсторияИспользованияДолжностейПоздние.Используется КАК Используется
	|ПОМЕСТИТЬ ВТИсключенныеДолжности
	|ИЗ
	|	ВТПоздниеПериодыДолжностейПоОрганизациям КАК ПоздниеПериодыДолжностейПоОрганизациям
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.УдалитьИсторияИспользованияДолжностей КАК ИсторияИспользованияДолжностейПоздние
	|		ПО ПоздниеПериодыДолжностейПоОрганизациям.Должность = ИсторияИспользованияДолжностейПоздние.Должность
	|			И ПоздниеПериодыДолжностейПоОрганизациям.Организация = ИсторияИспользованияДолжностейПоздние.Организация
	|			И ПоздниеПериодыДолжностейПоОрганизациям.Период = ИсторияИспользованияДолжностейПоздние.Период
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТИспользуемыеДолжности КАК ВТИспользуемыеДолжности
	|		ПО ПоздниеПериодыДолжностейПоОрганизациям.Должность = ВТИспользуемыеДолжности.Должность
	|ГДЕ
	|	ВТИспользуемыеДолжности.Должность ЕСТЬ NULL 
	|
	|СГРУППИРОВАТЬ ПО
	|	ИсторияИспользованияДолжностейПоздние.Должность,
	|	ИсторияИспользованияДолжностейПоздние.Используется
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИспользуемыеДолжности.Период КАК Период,
	|	ИспользуемыеДолжности.Должность КАК Должность,
	|	ИспользуемыеДолжности.Используется КАК Используется
	|ПОМЕСТИТЬ ВТПоздниеПериодыИспользованияДолжностей
	|ИЗ
	|	ВТИспользуемыеДолжности КАК ИспользуемыеДолжности
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВТИсключенныеДолжности.Период,
	|	ВТИсключенныеДолжности.Должность,
	|	ВТИсключенныеДолжности.Используется
	|ИЗ
	|	ВТИсключенныеДолжности КАК ВТИсключенныеДолжности
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДолжностиНаборов.Должность,
	|	ВЫБОР
	|		КОГДА РанниеПериодыИспользованияДолжностей.Период ЕСТЬ NULL 
	|				ИЛИ РанниеПериодыИспользованияДолжностей.Период > ДолжностиНаборов.Период
	|					И ДолжностиНаборов.Используется
	|			ТОГДА ВЫБОР
	|					КОГДА ДолжностиНаборов.Используется
	|						ТОГДА ДолжностиНаборов.Период
	|					ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
	|				КОНЕЦ
	|		ИНАЧЕ РанниеПериодыИспользованияДолжностей.Период
	|	КОНЕЦ КАК ДатаВвода,
	|	ВЫБОР
	|		КОГДА ПоздниеПериодыИспользованияДолжностей.Период ЕСТЬ NULL 
	|				ИЛИ ПоздниеПериодыИспользованияДолжностей.Период < ДолжностиНаборов.Период
	|			ТОГДА ВЫБОР
	|					КОГДА ДолжностиНаборов.Используется
	|						ТОГДА ДАТАВРЕМЯ(1, 1, 1)
	|					ИНАЧЕ ДолжностиНаборов.Период
	|				КОНЕЦ
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ПоздниеПериодыИспользованияДолжностей.Используется
	|					ТОГДА ДАТАВРЕМЯ(1, 1, 1)
	|				ИНАЧЕ ПоздниеПериодыИспользованияДолжностей.Период
	|			КОНЕЦ
	|	КОНЕЦ КАК ДатаИсключения
	|ПОМЕСТИТЬ ВТАктуальныеДанныеДолжностей
	|ИЗ
	|	ВТДолжностиНаборов КАК ДолжностиНаборов
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТРанниеПериодыИспользованияДолжностей КАК РанниеПериодыИспользованияДолжностей
	|		ПО ДолжностиНаборов.Должность = РанниеПериодыИспользованияДолжностей.Должность
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПоздниеПериодыИспользованияДолжностей КАК ПоздниеПериодыИспользованияДолжностей
	|		ПО ДолжностиНаборов.Должность = ПоздниеПериодыИспользованияДолжностей.Должность
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АктуальныеЗначенияДолжностей.Должность,
	|	АктуальныеЗначенияДолжностей.ДатаВвода,
	|	ВЫБОР
	|		КОГДА АктуальныеЗначенияДолжностей.ДатаВвода = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ДАТАВРЕМЯ(1, 1, 1)
	|		ИНАЧЕ АктуальныеЗначенияДолжностей.ДатаИсключения
	|	КОНЕЦ КАК ДатаИсключения,
	|	ВЫБОР
	|		КОГДА АктуальныеЗначенияДолжностей.ДатаВвода = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ВведенаВШтатноеРасписание,
	|	ВЫБОР
	|		КОГДА АктуальныеЗначенияДолжностей.ДатаВвода = ДАТАВРЕМЯ(1, 1, 1)
	|				ИЛИ АктуальныеЗначенияДолжностей.ДатаИсключения = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ИсключенаИзШтатногоРасписания
	|ПОМЕСТИТЬ ВТНовыеДанныеПозиций
	|ИЗ
	|	ВТАктуальныеДанныеДолжностей КАК АктуальныеЗначенияДолжностей
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НовыеДанныеПозиций.Должность,
	|	НовыеДанныеПозиций.ДатаВвода,
	|	НовыеДанныеПозиций.ДатаИсключения,
	|	НовыеДанныеПозиций.ВведенаВШтатноеРасписание,
	|	НовыеДанныеПозиций.ИсключенаИзШтатногоРасписания
	|ИЗ
	|	ВТНовыеДанныеПозиций КАК НовыеДанныеПозиций
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Должности КАК Должности
	|		ПО НовыеДанныеПозиций.Должность = Должности.Ссылка
	|ГДЕ
	|	(НовыеДанныеПозиций.ДатаВвода <> Должности.ДатаВвода
	|			ИЛИ НовыеДанныеПозиций.ДатаИсключения <> Должности.ДатаИсключения
	|			ИЛИ НовыеДанныеПозиций.ВведенаВШтатноеРасписание <> Должности.ВведенаВШтатноеРасписание
	|			ИЛИ НовыеДанныеПозиций.ИсключенаИзШтатногоРасписания <> Должности.ИсключенаИзШтатногоРасписания)";
	
	ИзменившиесяДанные = Запрос.Выполнить().Выбрать();
	
	Пока ИзменившиесяДанные.Следующий() Цикл
		
		ДолжностьОбъект = ИзменившиесяДанные.Должность.ПолучитьОбъект();
		
		Попытка 
			ДолжностьОбъект.Заблокировать();
		Исключение
			ТекстИсключенияЗаписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось изменить должность ""%1"".
			|Возможно, должность редактируется другим пользователем';
			|en = 'Cannot change the ""%1"" position.
			|Maybe, the position is being edited by another user'"),
			ДолжностьОбъект.Наименование);			
			ВызватьИсключение ТекстИсключенияЗаписи;
		КонецПопытки;	
		
		ЗаполнитьЗначенияСвойств(ДолжностьОбъект, ИзменившиесяДанные);
		
		Если НЕ ДолжностьОбъект.ИсключенаИзШтатногоРасписания И ДолжностьОбъект.ПометкаУдаления Тогда
			ДолжностьОбъект.ПометкаУдаления = Ложь;
		КонецЕсли;
		
		ДолжностьОбъект.Записать();
		
	КонецЦикла;	
	
КонецПроцедуры	

#КонецОбласти

#КонецЕсли