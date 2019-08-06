
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("ОбъектыСДопРекИКИ") Тогда
		АдресОбъектов = ПоместитьВоВременноеХранилище(Параметры.ОбъектыСДопРекИКИ, УникальныйИдентификатор);
		Для каждого ОбъектСДопРекИКИ из Параметры.ОбъектыСДопРекИКИ Цикл
			Элементы.Справочник.СписокВыбора.Добавить(ОбъектСДопРекИКИ.Ключ);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СправочникПриИзменении(Элемент)
	Элементы.ТипПоля.СписокВыбора.Очистить();
	ОбъектыСДопРекИКИ = ПолучитьИзВременногоХранилища(АдресОбъектов);
	Если ОбъектыСДопРекИКИ[Справочник].ДополнительныеРеквизиты Тогда
		Элементы.ТипПоля.СписокВыбора.Добавить(Новый ОписаниеТипов("Булево"), НСтр("ru = 'Да/Нет'"));
		Элементы.ТипПоля.СписокВыбора.Добавить(Новый ОписаниеТипов("Дата"), НСтр("ru='Дата';en='Date'"));
		Элементы.ТипПоля.СписокВыбора.Добавить(Новый ОписаниеТипов("Строка"), НСтр("ru='Строка';en='Строка'"));
		Элементы.ТипПоля.СписокВыбора.Добавить(Новый ОписаниеТипов("Число"), НСтр("ru='Число';en='Number'"));
		Элементы.ТипПоля.СписокВыбора.Добавить(Новый ОписаниеТипов("СправочникСсылка.ЗначенияСвойствОбъектов"), НСтр("ru='Справочник';en='Reference manual'"));
	КонецЕсли;
	Если ОбъектыСДопРекИКИ[Справочник].КонтактнаяИнформация Тогда
		МассивТиповКИ = МассивТиповКИ();
		Для каждого ТипКИ из МассивТиповКИ Цикл
			Элементы.ТипПоля.СписокВыбора.Добавить(ТипКИ);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Создать(Команда)
	Если ТипЗнч(ТипПоля) = Тип("ПеречислениеСсылка.ТипыКонтактнойИнформации") Тогда
		СтруктураРеквизита = СоздатьВидКонтактнойИнформации();
	Иначе
		СтруктураРеквизита = СоздатьДополнительныйРеквизит();
	КонецЕсли;
	Закрыть(СтруктураРеквизита);
КонецПроцедуры

&НаКлиенте
Процедура Отменить(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция МассивТиповКИ()
	
	МассивТипов = Новый Массив;
	Для каждого ТипКИ из Перечисления.ТипыКонтактнойИнформации Цикл
		Если ТипКИ <> Перечисления.ТипыКонтактнойИнформации.Другое Тогда
			МассивТипов.Добавить(ТипКИ);
		КонецЕсли;
	КонецЦикла;
	Возврат МассивТипов;
	
КонецФункции

&НаСервере
Функция СоздатьВидКонтактнойИнформации()
	
	Попытка
		Родитель = Справочники.ВидыКонтактнойИнформации[СтрЗаменить(Справочник.ПолноеИмя, ".", "")];
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	НовыйВид = Справочники.ВидыКонтактнойИнформации.СоздатьЭлемент();
	НовыйВид.Родитель = Родитель;
	НовыйВид.Тип = ТипПоля;
	НовыйВид.Наименование = Наименование;
	НовыйВид.Используется = Истина;
	НовыйВид.Записать();
	СтруктураРеквизита = Новый Структура;
	СтруктураРеквизита.Вставить("Объект", Справочник.ПолноеИмя);
	СтруктураРеквизита.Вставить("ИмяРеквизита", НовыйВид.Ссылка);
	СтруктураРеквизита.Вставить("ПредставлениеРеквизита", Наименование+ " (" + Справочник.Синоним + ")");
	СтруктураРеквизита.Вставить("ТипРеквизита", Новый ОписаниеТипов("Строка"));
	СтруктураРеквизита.Вставить("Обязательный", Ложь);
	Возврат СтруктураРеквизита;
	
КонецФункции

&НаСервере
Функция СоздатьДополнительныйРеквизит()
	
	Попытка
		НаборыСвойств = УправлениеСвойствамиСлужебный.ПолучитьНаборыСвойствОбъекта(Справочник.ЗначениеПустойСсылки);
		НаборСвойств = НаборыСвойств[0].Набор;
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	НовыйДопРеквизит = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.СоздатьЭлемент();
	НовыйДопРеквизит.НаборСвойств = НаборСвойств;
	НовыйДопРеквизит.ТипЗначения = ТипПоля;
	НовыйДопРеквизит.ДополнительныеЗначенияИспользуются = (ТипПоля = Новый ОписаниеТипов("СправочникСсылка.ЗначенияСвойствОбъектов")); 
	НовыйДопРеквизит.Наименование = Наименование + " (" + НаборСвойств.Наименование + ")";
	НовыйДопРеквизит.Заголовок = Наименование;
	НовыйДопРеквизит.Доступен = Истина;
	НовыйДопРеквизит.Виден = Истина;
	ЗаголовокОбъекта = НовыйДопРеквизит.Заголовок;
	ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ЗаголовокОбъекта, "");
	ЗаголовокОбъектаЧастями = СтрРазделить(ЗаголовокОбъекта, " ", Ложь);
	Для Каждого ЧастьЗаголовка Из ЗаголовокОбъектаЧастями Цикл
		НовыйДопРеквизит.Имя = НовыйДопРеквизит.Имя + ВРег(Лев(ЧастьЗаголовка, 1)) + Сред(ЧастьЗаголовка, 2);
	КонецЦикла;
	УИД = Новый УникальныйИдентификатор();
	СтрокаУИД = СтрЗаменить(Строка(УИД), "-", "");
	НовыйДопРеквизит.Имя = НовыйДопРеквизит.Имя + "_" + СтрокаУИД;
	НовыйДопРеквизит.Записать();
	ОбъектНаборСвойств = НаборСвойств.ПолучитьОбъект();
	НоваяСтрока = ОбъектНаборСвойств.ДополнительныеРеквизиты.Добавить();
	НоваяСтрока.Свойство = НовыйДопРеквизит.Ссылка;
	ОбъектНаборСвойств.Записать();
	СтруктураРеквизита = Новый Структура;
	СтруктураРеквизита.Вставить("Объект", Справочник.ПолноеИмя);
	СтруктураРеквизита.Вставить("ИмяРеквизита", НовыйДопРеквизит.Ссылка);
	СтруктураРеквизита.Вставить("ПредставлениеРеквизита", НовыйДопРеквизит.Заголовок+ " (" + Справочник.Синоним + ")");
	СтруктураРеквизита.Вставить("ТипРеквизита", НовыйДопРеквизит.ТипЗначения);
	СтруктураРеквизита.Вставить("Обязательный", Ложь);
	СтруктураРеквизита.Вставить("Создавать", Истина);
	Возврат СтруктураРеквизита;
	
КонецФункции

#КонецОбласти





