
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьДанными();
			
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставительЯвляетсяЮЛПриИзменении(Элемент)
	
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставительФЛ_ФИООчистка(Элемент, СтандартнаяОбработка)
	
	ПредставительФЛ_Фамилия ="";
	ПредставительФЛ_Имя = "";
	ПредставительФЛ_Отчество = "";
	ПредставительФЛ_ФИО = "";
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставительФЛ_УдостНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СтруктураДанных = Новый Структура;

	СтруктураДанных.Вставить("ДокументВид",					ПредставительФЛ_ВидДок);
	СтруктураДанных.Вставить("ДокументСерия",				ПредставительФЛ_СерДок);
	СтруктураДанных.Вставить("ДокументНомер",				ПредставительФЛ_НомДок);
	СтруктураДанных.Вставить("ДокументДатаВыдачи",			ПредставительФЛ_ДатаДок);
	СтруктураДанных.Вставить("ДокументКемВыдан",			ПредставительФЛ_ВыдДок);
	СтруктураДанных.Вставить("ДокументКодПодразделения",	ПредставительФЛ_КодВыдДок);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПредставительФЛ_УдостНачалоВыбораЗавершение", ЭтотОбъект);
	ОткрытьФорму("Справочник.ДоверенностиНалогоплательщика.Форма.ФормаВводаУдостоверения", Новый Структура("СтруктураДанных", СтруктураДанных), ЭтаФорма,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставительЮЛ_АдресНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СтруктураАдресныхДанных = Новый СписокЗначений;
	СтруктураАдресныхДанных.Добавить(ПредставительЮЛ_Индекс, "Индекс"); // индекс
	СтруктураАдресныхДанных.Добавить(РегламентированнаяОтчетностьВызовСервера.ПолучитьНазваниеРегионаПоКоду(ПредставительЮЛ_Регион), "Регион"); // код
	СтруктураАдресныхДанных.Добавить(ПредставительЮЛ_Район, "Район");
	СтруктураАдресныхДанных.Добавить(ПредставительЮЛ_Город, "Город");
	СтруктураАдресныхДанных.Добавить(ПредставительЮЛ_НаселенныйПункт, "НаселенныйПункт");
	СтруктураАдресныхДанных.Добавить(ПредставительЮЛ_Улица, "Улица");
	СтруктураАдресныхДанных.Добавить(ПредставительЮЛ_Дом, "Дом");
	СтруктураАдресныхДанных.Добавить(ПредставительЮЛ_Корпус, "Корпус");
	СтруктураАдресныхДанных.Добавить(ПредставительЮЛ_Квартира, "Квартира");
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок", "Ввод адреса");
	ПараметрыФормы.Вставить("ЗначенияПолей", СтруктураАдресныхДанных);
	ПараметрыФормы.Вставить("ВидКонтактнойИнформации", ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица"));
	       	
	ДополнительныеПараметры = Элемент;
	
	ТипЗначения = Тип("ОписаниеОповещения");
	ПараметрыКонструктора = Новый Массив(3);
	ПараметрыКонструктора[0] = "ОткрытьФормуКонтактнойИнформацииЗавершение";
	ПараметрыКонструктора[1] = ЭтаФорма;
	ПараметрыКонструктора[2] = ДополнительныеПараметры;
	
	Оповещение = Новый(ТипЗначения, ПараметрыКонструктора);
	
	ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент").ОткрытьФормуКонтактнойИнформации(ПараметрыФормы, , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставительЮЛ_АдресОчистка(Элемент, СтандартнаяОбработка)
	
	ПредставительЮЛ_Индекс = "";
	ПредставительЮЛ_Регион = "";
	ПредставительЮЛ_Район = "";
	ПредставительЮЛ_Город = "";
	ПредставительЮЛ_НаселенныйПункт = "";
	ПредставительЮЛ_Улица = "";
	ПредставительЮЛ_Дом = "";
	ПредставительЮЛ_Корпус = "";
	ПредставительЮЛ_Квартира = "";
	ПредставительЮЛ_Адрес = "";
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставительФЛ_АдресНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СтруктураАдресныхДанных = Новый СписокЗначений;
	СтруктураАдресныхДанных.Добавить(ПредставительФЛ_Индекс, "Индекс"); // индекс
	СтруктураАдресныхДанных.Добавить(РегламентированнаяОтчетностьВызовСервера.ПолучитьНазваниеРегионаПоКоду(ПредставительФЛ_Регион), "Регион"); // код
	СтруктураАдресныхДанных.Добавить(ПредставительФЛ_Район, "Район");
	СтруктураАдресныхДанных.Добавить(ПредставительФЛ_Город, "Город");
	СтруктураАдресныхДанных.Добавить(ПредставительФЛ_НаселенныйПункт, "НаселенныйПункт");
	СтруктураАдресныхДанных.Добавить(ПредставительФЛ_Улица, "Улица");
	СтруктураАдресныхДанных.Добавить(ПредставительФЛ_Дом, "Дом");
	СтруктураАдресныхДанных.Добавить(ПредставительФЛ_Корпус, "Корпус");
	СтруктураАдресныхДанных.Добавить(ПредставительФЛ_Квартира, "Квартира");
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок", "Ввод адреса");
	ПараметрыФормы.Вставить("ЗначенияПолей", СтруктураАдресныхДанных);
	ПараметрыФормы.Вставить("ВидКонтактнойИнформации", ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица"));
	
	ДополнительныеПараметры = Элемент;
	
	ТипЗначения = Тип("ОписаниеОповещения");
	ПараметрыКонструктора = Новый Массив(3);
	ПараметрыКонструктора[0] = "ОткрытьФормуКонтактнойИнформацииЗавершение";
	ПараметрыКонструктора[1] = ЭтаФорма;
	ПараметрыКонструктора[2] = ДополнительныеПараметры;
	
	Оповещение = Новый(ТипЗначения, ПараметрыКонструктора);
	
	ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент").ОткрытьФормуКонтактнойИнформации(ПараметрыФормы, , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставительФЛ_АдресОчистка(Элемент, СтандартнаяОбработка)
	
	ПредставительФЛ_Индекс = "";
	ПредставительФЛ_Регион = "";
	ПредставительФЛ_Район = "";
	ПредставительФЛ_Город = "";
	ПредставительФЛ_НаселенныйПункт = "";
	ПредставительФЛ_Улица = "";
	ПредставительФЛ_Дом = "";
	ПредставительФЛ_Корпус = "";
	ПредставительФЛ_Квартира = "";
	ПредставительФЛ_Адрес = "";
	Модифицированность = Истина;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставительФЛ_ФИОНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ФормаВводаФИО = РегламентированнаяОтчетностьКлиент.ПолучитьОбщуюФормуПоИмени("ФормаВводаФИО");
	ФормаВводаФИО.Фамилия = ПредставительФЛ_Фамилия;
	ФормаВводаФИО.Имя = ПредставительФЛ_Имя;
	ФормаВводаФИО.Отчество = ПредставительФЛ_Отчество;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПредставительФЛ_ФИОНачалоВыбораЗавершение", ЭтотОбъект);
	
	ФормаВводаФИО.ОписаниеОповещенияОЗакрытии = ОписаниеОповещения;
	ФормаВводаФИО.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	ФормаВводаФИО.Открыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьИЗакрыть(Команда)
	
	Если НЕ ВыполнитьПроверку() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("ПредставительЯвляетсяЮЛ", ПредставительЯвляетсяЮЛ);
	СтруктураРеквизитов.Вставить("ПредставительЮЛ_Наименование", ПредставительЮЛ_НаимОрг);
	СтруктураРеквизитов.Вставить("ПредставительЮЛ_ИНН",          ПредставительЮЛ_ИНН);
	СтруктураРеквизитов.Вставить("ПредставительЮЛ_КПП",          ПредставительЮЛ_КПП);
	СтруктураРеквизитов.Вставить("ПредставительЮЛ_ОГРН",         ПредставительЮЛ_ОГРН);
	
	СтруктураРеквизитов.Вставить("ПредставительЮЛ_Индекс",          ПредставительЮЛ_Индекс);
	СтруктураРеквизитов.Вставить("ПредставительЮЛ_Регион",          ПредставительЮЛ_Регион);
	СтруктураРеквизитов.Вставить("ПредставительЮЛ_Район",           ПредставительЮЛ_Район);
	СтруктураРеквизитов.Вставить("ПредставительЮЛ_Город",           ПредставительЮЛ_Город);
	СтруктураРеквизитов.Вставить("ПредставительЮЛ_НаселенныйПункт", ПредставительЮЛ_НаселенныйПункт);
	СтруктураРеквизитов.Вставить("ПредставительЮЛ_Улица",           ПредставительЮЛ_Улица);
	СтруктураРеквизитов.Вставить("ПредставительЮЛ_Дом",             ПредставительЮЛ_Дом);
	СтруктураРеквизитов.Вставить("ПредставительЮЛ_Корпус",          ПредставительЮЛ_Корпус);
	СтруктураРеквизитов.Вставить("ПредставительЮЛ_Квартира",        ПредставительЮЛ_Квартира);
	
	СтруктураРеквизитов.Вставить("ПредставительФЛ_Фамилия",  ПредставительФЛ_Фамилия);
	СтруктураРеквизитов.Вставить("ПредставительФЛ_Имя",      ПредставительФЛ_Имя);
	СтруктураРеквизитов.Вставить("ПредставительФЛ_Отчество", ПредставительФЛ_Отчество);
	
	СтруктураРеквизитов.Вставить("ПредставительФЛ_Индекс",         ПредставительФЛ_Индекс);
	СтруктураРеквизитов.Вставить("ПредставительФЛ_Регион",         ПредставительФЛ_Регион);
	СтруктураРеквизитов.Вставить("ПредставительФЛ_Район",          ПредставительФЛ_Район);
	СтруктураРеквизитов.Вставить("ПредставительФЛ_Город",          ПредставительФЛ_Город);
	СтруктураРеквизитов.Вставить("ПредставительФЛ_НаселенныйПункт",ПредставительФЛ_НаселенныйПункт);
	СтруктураРеквизитов.Вставить("ПредставительФЛ_Улица",          ПредставительФЛ_Улица);
	СтруктураРеквизитов.Вставить("ПредставительФЛ_Дом",            ПредставительФЛ_Дом);
	СтруктураРеквизитов.Вставить("ПредставительФЛ_Корпус",         ПредставительФЛ_Корпус);
	СтруктураРеквизитов.Вставить("ПредставительФЛ_Квартира",       ПредставительФЛ_Квартира);
	
	СтруктураРеквизитов.Вставить("ПредставительФЛ_ВидДок",    ПредставительФЛ_ВидДок);
	СтруктураРеквизитов.Вставить("ПредставительФЛ_СерДок",    ПредставительФЛ_СерДок);
	СтруктураРеквизитов.Вставить("ПредставительФЛ_НомДок",    ПредставительФЛ_НомДок);
	СтруктураРеквизитов.Вставить("ПредставительФЛ_ДатаДок",   ПредставительФЛ_ДатаДок);
	СтруктураРеквизитов.Вставить("ПредставительФЛ_ВыдДок",    ПредставительФЛ_ВыдДок);
	СтруктураРеквизитов.Вставить("ПредставительФЛ_КодВыдДок", ПредставительФЛ_КодВыдДок);
	
	СтруктураРеквизитов.Вставить("ПредставительФЛ_КодСтраны",
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ЗначениеРеквизитаОбъекта(ПредставительФЛ_Гражданство,"Код"));
	СтруктураРеквизитов.Вставить("ПредставительФЛ_ИНН",          ПредставительФЛ_ИНН);
	СтруктураРеквизитов.Вставить("ПредставительФЛ_ДатаРождения", ПредставительФЛ_ДатаРождения);
	СтруктураРеквизитов.Вставить("ПредставительФЛ_ОГРН",         ПредставительФЛ_ОГРН);
	Закрыть(СтруктураРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьДанными()
	
	СтруктураРеквизитов = Параметры.СтруктураРеквизитов;
	Если ТипЗнч(СтруктураРеквизитов) = Тип("Структура") Тогда
		
		ПредставительЯвляетсяЮЛ = СтруктураРеквизитов.ПредставительЯвляетсяЮЛ;
		ПредставительЮЛ_НаимОрг = СтруктураРеквизитов.ПредставительЮЛ_Наименование;
		ПредставительЮЛ_ИНН = СтруктураРеквизитов.ПредставительЮЛ_ИНН;
		ПредставительЮЛ_КПП = СтруктураРеквизитов.ПредставительЮЛ_КПП;
		ПредставительЮЛ_ОГРН = СтруктураРеквизитов.ПредставительЮЛ_ОГРН;
		
		ПредставительЮЛ_Индекс = СтруктураРеквизитов.ПредставительЮЛ_Индекс;
		ПредставительЮЛ_Регион = СтруктураРеквизитов.ПредставительЮЛ_Регион;
		ПредставительЮЛ_Район = СтруктураРеквизитов.ПредставительЮЛ_Район;
		ПредставительЮЛ_Город = СтруктураРеквизитов.ПредставительЮЛ_Город;
		ПредставительЮЛ_НаселенныйПункт = СтруктураРеквизитов.ПредставительЮЛ_НаселенныйПункт;
		ПредставительЮЛ_Улица = СтруктураРеквизитов.ПредставительЮЛ_Улица;
		ПредставительЮЛ_Дом = СтруктураРеквизитов.ПредставительЮЛ_Дом;
		ПредставительЮЛ_Корпус = СтруктураРеквизитов.ПредставительЮЛ_Корпус;
		ПредставительЮЛ_Квартира = СтруктураРеквизитов.ПредставительЮЛ_Квартира;
		
		ПредставительФЛ_Фамилия = СтруктураРеквизитов.ПредставительФЛ_Фамилия;
		ПредставительФЛ_Имя = СтруктураРеквизитов.ПредставительФЛ_Имя;
		ПредставительФЛ_Отчество = СтруктураРеквизитов.ПредставительФЛ_Отчество;
		
		ПредставительФЛ_Индекс = СтруктураРеквизитов.ПредставительФЛ_Индекс;
		ПредставительФЛ_Регион = СтруктураРеквизитов.ПредставительФЛ_Регион;
		ПредставительФЛ_Район = СтруктураРеквизитов.ПредставительФЛ_Район;
		ПредставительФЛ_Город = СтруктураРеквизитов.ПредставительФЛ_Город;
		ПредставительФЛ_НаселенныйПункт = СтруктураРеквизитов.ПредставительФЛ_НаселенныйПункт;
		ПредставительФЛ_Улица = СтруктураРеквизитов.ПредставительФЛ_Улица;
		ПредставительФЛ_Дом = СтруктураРеквизитов.ПредставительФЛ_Дом;
		ПредставительФЛ_Корпус = СтруктураРеквизитов.ПредставительФЛ_Корпус;
		ПредставительФЛ_Квартира = СтруктураРеквизитов.ПредставительФЛ_Квартира;
		
		ПредставительФЛ_ВидДок = СтруктураРеквизитов.ПредставительФЛ_ВидДок;
		ПредставительФЛ_СерДок = СтруктураРеквизитов.ПредставительФЛ_СерДок;
		ПредставительФЛ_НомДок = СтруктураРеквизитов.ПредставительФЛ_НомДок;
		ПредставительФЛ_ДатаДок = СтруктураРеквизитов.ПредставительФЛ_ДатаДок;
		ПредставительФЛ_ВыдДок = СтруктураРеквизитов.ПредставительФЛ_ВыдДок;
		ПредставительФЛ_КодВыдДок = СтруктураРеквизитов.ПредставительФЛ_КодВыдДок;
		
		ПредставительФЛ_Гражданство = Справочники.СтраныМира.НайтиПоКоду(СтруктураРеквизитов.ПредставительФЛ_КодСтраны);
		ПредставительФЛ_ИНН = СтруктураРеквизитов.ПредставительФЛ_ИНН;
		ПредставительФЛ_ДатаРождения = СтруктураРеквизитов.ПредставительФЛ_ДатаРождения;
		ПредставительФЛ_ОГРН = СтруктураРеквизитов.ПредставительФЛ_ОГРН;
		
		
		ПредставительФЛ_Удост = ПредставительФЛ_ВидДок + " " + ПредставительФЛ_СерДок + " №" + ПредставительФЛ_НомДок
			+ " выдан " + Формат(ПредставительФЛ_ДатаДок, "ДЛФ=DD") + " " + ПредставительФЛ_ВыдДок + ", код подразделения:" + ПредставительФЛ_КодВыдДок;
		ПредставительЮЛ_Адрес = ?(ЗначениеЗаполнено(ПредставительЮЛ_Индекс), ПредставительЮЛ_Индекс + ", ", "")
			+ ?(ЗначениеЗаполнено(ПредставительЮЛ_Регион), ПредставительЮЛ_Регион + ", ", "")
			+ ?(ЗначениеЗаполнено(ПредставительЮЛ_Район), ПредставительЮЛ_Район + ", ", "")
			+ ?(ЗначениеЗаполнено(ПредставительЮЛ_Город), ПредставительЮЛ_Город + ", ", "")
			+ ?(ЗначениеЗаполнено(ПредставительЮЛ_НаселенныйПункт), ПредставительЮЛ_НаселенныйПункт + ", ", "")
			+ ?(ЗначениеЗаполнено(ПредставительЮЛ_Улица), ПредставительЮЛ_Улица + ", ", "")
			+ ?(ЗначениеЗаполнено(ПредставительЮЛ_Дом), ПредставительЮЛ_Дом + ", ", "")
			+ ?(ЗначениеЗаполнено(ПредставительЮЛ_Корпус), ПредставительЮЛ_Корпус + ", ", "")
			+ ?(ЗначениеЗаполнено(ПредставительЮЛ_Квартира), ПредставительЮЛ_Квартира, "");
			
		ПредставительФЛ_Адрес = ?(ЗначениеЗаполнено(ПредставительФЛ_Индекс), ПредставительФЛ_Индекс + ", ", "")
			+ ?(ЗначениеЗаполнено(ПредставительФЛ_Регион), ПредставительФЛ_Регион + ", ", "")
			+ ?(ЗначениеЗаполнено(ПредставительФЛ_Район), ПредставительФЛ_Район + ", ", "")
			+ ?(ЗначениеЗаполнено(ПредставительФЛ_Город), ПредставительФЛ_Город + ", ", "")
			+ ?(ЗначениеЗаполнено(ПредставительФЛ_НаселенныйПункт), ПредставительФЛ_НаселенныйПункт + ", ", "")
			+ ?(ЗначениеЗаполнено(ПредставительФЛ_Улица), ПредставительФЛ_Улица + ", ", "")
			+ ?(ЗначениеЗаполнено(ПредставительФЛ_Дом), ПредставительФЛ_Дом + ", ", "")
			+ ?(ЗначениеЗаполнено(ПредставительФЛ_Корпус), ПредставительФЛ_Корпус + ", ", "")
			+ ?(ЗначениеЗаполнено(ПредставительФЛ_Квартира), ПредставительФЛ_Квартира, "");
		ПредставительФЛ_ФИО = ПредставительФЛ_Фамилия+" "+ПредставительФЛ_Имя+" "+ПредставительФЛ_Отчество;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуКонтактнойИнформацииЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Элемент = ДополнительныеПараметры;
	
	Если Элемент.Имя = "ПредставительЮЛ_Адрес" Тогда
		ОбновитьАдресПредставителяЮЛ(РезультатЗакрытия);
	ИначеЕсли Элемент.Имя = "ПредставительФЛ_Адрес" Тогда
		ОбновитьАдресПредставителяФЛ(РезультатЗакрытия);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьАдресПредставителяЮЛ(РезультатРедактирования)
	
	Если ТипЗнч(РезультатРедактирования) = Тип("Структура") Тогда
		
		КомпонентыАдреса = Новый Структура;
		
		КомпонентыАдреса.Вставить("Индекс",          "");
		КомпонентыАдреса.Вставить("КодРегиона",      "");
		КомпонентыАдреса.Вставить("Регион",          "");
		КомпонентыАдреса.Вставить("Район",           "");
		КомпонентыАдреса.Вставить("Город",           "");
		КомпонентыАдреса.Вставить("НаселенныйПункт", "");
		КомпонентыАдреса.Вставить("Улица",           "");
		КомпонентыАдреса.Вставить("Дом",             "");
		КомпонентыАдреса.Вставить("Корпус",          "");
		КомпонентыАдреса.Вставить("Квартира",        "");
		
		РегламентированнаяОтчетностьВызовСервера.СформироватьАдрес(РезультатРедактирования.КонтактнаяИнформация, КомпонентыАдреса);
		
		ПредставительЮЛ_Индекс = КомпонентыАдреса.Индекс;
		ПредставительЮЛ_Регион = РегламентированнаяОтчетностьВызовСервера.КодРегионаПоНазванию(КомпонентыАдреса.Регион);
		ПредставительЮЛ_Район = КомпонентыАдреса.Район;
		ПредставительЮЛ_Город = КомпонентыАдреса.Город;
		ПредставительЮЛ_НаселенныйПункт = КомпонентыАдреса.НаселенныйПункт;
		ПредставительЮЛ_Улица = КомпонентыАдреса.Улица;
		ПредставительЮЛ_Дом = КомпонентыАдреса.Дом;
		ПредставительЮЛ_Корпус = КомпонентыАдреса.Корпус;
		ПредставительЮЛ_Квартира = КомпонентыАдреса.Квартира;
		
		ПредставительЮЛ_Адрес = ?(ЗначениеЗаполнено(ПредставительЮЛ_Индекс), ПредставительЮЛ_Индекс + ", ", "")
			+ ?(ЗначениеЗаполнено(ПредставительЮЛ_Регион), ПредставительЮЛ_Регион + ", ", "")
			+ ?(ЗначениеЗаполнено(ПредставительЮЛ_Район), ПредставительЮЛ_Район + ", ", "")
			+ ?(ЗначениеЗаполнено(ПредставительЮЛ_Город), ПредставительЮЛ_Город + ", ", "")
			+ ?(ЗначениеЗаполнено(ПредставительЮЛ_НаселенныйПункт), ПредставительЮЛ_НаселенныйПункт + ", ", "")
			+ ?(ЗначениеЗаполнено(ПредставительЮЛ_Улица), ПредставительЮЛ_Улица + ", ", "")
			+ ?(ЗначениеЗаполнено(ПредставительЮЛ_Дом), ПредставительЮЛ_Дом + ", ", "")
			+ ?(ЗначениеЗаполнено(ПредставительЮЛ_Корпус), ПредставительЮЛ_Корпус + ", ", "")
			+ ?(ЗначениеЗаполнено(ПредставительЮЛ_Квартира), ПредставительЮЛ_Квартира, "");
			
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьАдресПредставителяФЛ(РезультатРедактирования)
	
	Если ТипЗнч(РезультатРедактирования) = Тип("Структура") Тогда
		
		КомпонентыАдреса = Новый Структура;
		
		КомпонентыАдреса.Вставить("Индекс",          "");
		КомпонентыАдреса.Вставить("КодРегиона",      "");
		КомпонентыАдреса.Вставить("Регион",          "");
		КомпонентыАдреса.Вставить("Район",           "");
		КомпонентыАдреса.Вставить("Город",           "");
		КомпонентыАдреса.Вставить("НаселенныйПункт", "");
		КомпонентыАдреса.Вставить("Улица",           "");
		КомпонентыАдреса.Вставить("Дом",             "");
		КомпонентыАдреса.Вставить("Корпус",          "");
		КомпонентыАдреса.Вставить("Квартира",        "");
		
		РегламентированнаяОтчетностьВызовСервера.СформироватьАдрес(РезультатРедактирования.КонтактнаяИнформация, КомпонентыАдреса);
		
		ПредставительФЛ_Индекс = КомпонентыАдреса.Индекс;
		ПредставительФЛ_Регион = КомпонентыАдреса.КодРегиона;
		ПредставительФЛ_Район = КомпонентыАдреса.Район;
		ПредставительФЛ_Город = КомпонентыАдреса.Город;
		ПредставительФЛ_НаселенныйПункт = КомпонентыАдреса.НаселенныйПункт;
		ПредставительФЛ_Улица = КомпонентыАдреса.Улица;
		ПредставительФЛ_Дом = КомпонентыАдреса.Дом;
		ПредставительФЛ_Корпус = КомпонентыАдреса.Корпус;
		ПредставительФЛ_Квартира = КомпонентыАдреса.Квартира;
		
		ПредставительФЛ_Адрес = ?(ЗначениеЗаполнено(ПредставительФЛ_Индекс), ПредставительФЛ_Индекс + ", ", "")
			+ ?(ЗначениеЗаполнено(ПредставительФЛ_Регион), РегламентированнаяОтчетностьВызовСервера.ПолучитьНазваниеРегионаПоКоду(ПредставительФЛ_Регион) + ", ", "")
			+ ?(ЗначениеЗаполнено(ПредставительФЛ_Район), ПредставительФЛ_Район + ", ", "")
			+ ?(ЗначениеЗаполнено(ПредставительФЛ_Город), ПредставительФЛ_Город + ", ", "")
			+ ?(ЗначениеЗаполнено(ПредставительФЛ_НаселенныйПункт), ПредставительФЛ_НаселенныйПункт + ", ", "")
			+ ?(ЗначениеЗаполнено(ПредставительФЛ_Улица), ПредставительФЛ_Улица + ", ", "")
			+ ?(ЗначениеЗаполнено(ПредставительФЛ_Дом), ПредставительФЛ_Дом + ", ", "")
			+ ?(ЗначениеЗаполнено(ПредставительФЛ_Корпус), ПредставительФЛ_Корпус + ", ", "")
			+ ?(ЗначениеЗаполнено(ПредставительФЛ_Квартира), ПредставительФЛ_Квартира, "");
		
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставительФЛ_ФИОНачалоВыбораЗавершение(РезультатРедактирования, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(РезультатРедактирования) Тогда
		
		ПредставительФЛ_Фамилия = РезультатРедактирования.Фамилия;
		ПредставительФЛ_Имя = РезультатРедактирования.Имя;
		ПредставительФЛ_Отчество = РезультатРедактирования.Отчество;
		ПредставительФЛ_ФИО = ПредставительФЛ_Фамилия+" "+ПредставительФЛ_Имя+" "+ПредставительФЛ_Отчество;
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставительФЛ_УдостНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		
		ПредставительФЛ_ВидДок = Результат.ДокументВид;
		ПредставительФЛ_СерДок = Результат.ДокументСерия;
		ПредставительФЛ_НомДок = Результат.ДокументНомер;
		ПредставительФЛ_ДатаДок = Результат.ДокументДатаВыдачи;
		ПредставительФЛ_ВыдДок = Результат.ДокументКемВыдан;
		ПредставительФЛ_КодВыдДок = Результат.ДокументКодПодразделения;
		ПредставительФЛ_Удост = ПредставительФЛ_ВидДок + " "+ПредставительФЛ_СерДок + " №" + ПредставительФЛ_НомДок
		+ " выдан " + Формат(ПредставительФЛ_ДатаДок, "ДЛФ=DD") + " " + ПредставительФЛ_ВыдДок + ", код подразделения:" + ПредставительФЛ_КодВыдДок;
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ВыполнитьПроверку()
	
	ВсеОК = Истина;
	// проверяем юрлицо-представителя
	Если ПредставительЯвляетсяЮЛ Тогда
		
		// проверка ИНН юрлица-представителя
		Если ЗначениеЗаполнено(ПредставительЮЛ_ИНН) И НЕ РегламентированнаяОтчетностьВызовСервера.ИННСоответствуетТребованиямНаСервере(ПредставительЮЛ_ИНН, Ложь) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Некорректно задан ИНН организации-представителя';
																	|en = 'Некорректно задан ИНН организации-представителя'"), , "ПредставительЮЛ_ИНН", , );
			ВсеОК = Ложь;
		КонецЕсли;
		
		// проверка КПП юрлица-представителя
		Если ЗначениеЗаполнено(ПредставительЮЛ_КПП) И НЕ РегламентированнаяОтчетностьКлиентСервер.КППСоответствуетТребованиям(ПредставительЮЛ_КПП) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Некорректно задан КПП организации-представителя';
																	|en = 'Некорректно задан КПП организации-представителя'"), , "ПредставительЮЛ_КПП", , );
			ВсеОК = Ложь;
		КонецЕсли;
		
		// проверка ОГРН юрлица-представителя
		Если ЗначениеЗаполнено(ПредставительЮЛ_ОГРН) И СтрДлина(СокрЛП(ПредставительЮЛ_ОГРН)) <> 13 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Некорректно задан ОГРН организации-представителя';
																	|en = 'Некорректно задан ОГРН организации-представителя'"), , "ПредставительЮЛ_ОГРН", , );
			ВсеОК = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	// проверяем физлицо-представителя
	
	// проверка ИНН физлица-представителя
	Если ЗначениеЗаполнено(ПредставительФЛ_ИНН) И НЕ РегламентированнаяОтчетностьВызовСервера.ИННСоответствуетТребованиямНаСервере(ПредставительФЛ_ИНН, Истина) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Некорректно задан ИНН физлица-представителя';
																|en = 'Некорректно задан ИНН физлица-представителя'"), , "ПредставительФЛ_ИНН", , );
		ВсеОК = Ложь;
	КонецЕсли;
	
	// проверка ОГРН физлица-представителя
	Если ЗначениеЗаполнено(ПредставительФЛ_ОГРН) И СтрДлина(СокрЛП(ПредставительФЛ_ОГРН)) <> 15 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Некорректно задан ОГРН физлица-представителя';
																|en = 'Некорректно задан ОГРН физлица-представителя'"), , "ПредставительФЛ_ОГРН", , );
		ВсеОК = Ложь;
	КонецЕсли;
	Возврат ВсеОК;
	
КонецФункции

&НаКлиенте
Процедура УстановитьВидимостьЭлементов()
	
	Элементы.ГруппаЛеваяЮрЛицо.Видимость = ПредставительЯвляетсяЮЛ;
	Элементы.ПредставительФЛ_ОГРН.Видимость = Не ПредставительЯвляетсяЮЛ;
	
КонецПроцедуры

#КонецОбласти


