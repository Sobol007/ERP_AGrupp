
////////////////////////////////////////////////////////////////////////////////
// CRM пользовательские настройки сервер
//  
////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс

// Добавить подменю пользовательских настроек
//
// Параметры:
//  Форма				 - УправляемаяФорма - Передаваемая форма.
//  Список				 - ДинамическийСписок - Передаваемый список.
//  КлючОбъектаНастроек	 - Строка - Ключ настроек.
//
Процедура ДобавитьПодменюПользовательскихНастроек(Форма, Список, КлючОбъектаНастроек) Экспорт
	СписокНаУдаление = Новый Массив;
	Для Каждого ЭлементКнопка Из Форма.Элементы.ГруппаСтандартныеНастройки.ПодчиненныеЭлементы Цикл
		СписокНаУдаление.Добавить(ЭлементКнопка)
	КонецЦикла;	
	Для Каждого КнопкаНаУдаление Из СписокНаУдаление Цикл
		Форма.Команды.Удалить(Форма.Команды.Найти(КнопкаНаУдаление.ИмяКоманды));
		Форма.Элементы.Удалить(КнопкаНаУдаление);
	КонецЦикла;	
	СписокНаУдаление = Новый Массив;
	Для Каждого ЭлементКнопка Из Форма.Элементы.ГруппаКоммандВыбораНастроек.ПодчиненныеЭлементы Цикл
		СписокНаУдаление.Добавить(ЭлементКнопка)
	КонецЦикла;	
	Для Каждого КнопкаНаУдаление Из СписокНаУдаление Цикл
		Форма.Команды.Удалить(Форма.Команды.Найти(КнопкаНаУдаление.ИмяКоманды));
		Форма.Элементы.Удалить(КнопкаНаУдаление);
	КонецЦикла;
	СписокНаУдаление = Новый Массив;
	Для Каждого ЭлементКнопка Из Форма.Элементы.ГруппаСКоммандыНастроек.ПодчиненныеЭлементы Цикл
		Если ЭлементКнопка.Имя = "СписокНастройкаСписка" Тогда Продолжить КонецЕсли;
		СписокНаУдаление.Добавить(ЭлементКнопка)
	КонецЦикла;	
	Для Каждого КнопкаНаУдаление Из СписокНаУдаление Цикл
		Форма.Команды.Удалить(Форма.Команды.Найти(КнопкаНаУдаление.ИмяКоманды));
		Форма.Элементы.Удалить(КнопкаНаУдаление);
	КонецЦикла;
	Сч = 0;
	СписокНастроек = ХранилищеПользовательскихНастроекДинамическихСписков.ПолучитьСписок(КлючОбъектаНастроек, ИмяПользователя());
	Если СписокНастроек.Количество() = 0 Тогда
		ТекущиеНастройкиСписка = Список.КомпоновщикНастроек.ПользовательскиеНастройки;
		ОписаниеНастроек = Новый ОписаниеНастроек;
		ОписаниеНастроек.Представление = НСтр("ru = 'Без отборов'");
		ОписаниеНастроек.КлючНастроек = "Стандартные_Настройки";
		ОписаниеНастроек.КлючОбъекта = КлючОбъектаНастроек;
		ОписаниеНастроек.Пользователь = ИмяПользователя();
		
		ХранилищеПользовательскихНастроекДинамическихСписков.Сохранить(КлючОбъектаНастроек, "Стандартные_Настройки", Список.КомпоновщикНастроек.ПользовательскиеНастройки, ОписаниеНастроек, ИмяПользователя()); 
		СписокНастроек = ХранилищеПользовательскихНастроекДинамическихСписков.ПолучитьСписок(КлючОбъектаНастроек, ИмяПользователя());
		Форма.ИдентификаторПользовательскойНастройки = "Стандартные_Настройки";
	КонецЕсли;	
		
	Для Каждого ЭлементНастройки Из СписокНастроек Цикл	
		НоваяКоманда = Форма.Команды.Добавить("Подключаемый_ОбработатьВыборНастройки_"+Формат(Сч, "ЧН=; ЧГ="));
		НоваяКоманда.Действие = "Подключаемый_ОбработатьВыборНастройки";
		// Добавляем элемент "КомандаПредупредить" с типом "Кнопка формы"
		Если ЭлементНастройки.Значение = "Стандартные_Настройки" Тогда
			НовыйЭлемент = Форма.Элементы.Добавить("Настройка_"+Формат(Сч, "ЧН=; ЧГ="), Тип("КнопкаФормы"), Форма.Элементы.ГруппаСтандартныеНастройки);
			НовыйЭлемент.Заголовок = НСтр("ru = 'Без отборов'");
		Иначе	
			НовыйЭлемент = Форма.Элементы.Добавить("Настройка_"+Формат(Сч, "ЧН=; ЧГ="), Тип("КнопкаФормы"), Форма.Элементы.ГруппаКоммандВыбораНастроек);
			НовыйЭлемент.Заголовок = ЭлементНастройки.Представление;
		КонецЕсли;	
		// Присваиваем команду для созданной кнопке
		НовыйЭлемент.ИмяКоманды = "Подключаемый_ОбработатьВыборНастройки_"+Формат(Сч, "ЧН=; ЧГ=");
		
		НовыйЭлемент.Пометка =  ЭлементНастройки.Значение = Форма.ИдентификаторПользовательскойНастройки;
		Если ЭлементНастройки.Значение = Форма.ИдентификаторПользовательскойНастройки Тогда
			Форма.Элементы.ГруппаПользовательскиеНастройки.Заголовок = ЭлементНастройки.Представление;
		КонецЕсли;
		Сч = Сч + 1;
	КонецЦикла;	
	
	
	НоваяКоманда = Форма.Команды.Добавить("Подключаемый_СохранитьТекущиеНастройки");
	НоваяКоманда.Действие = "Подключаемый_СохранитьТекущиеНастройки";
	// Добавляем элемент "КомандаПредупредить" с типом "Кнопка формы"
	НовыйЭлемент = Форма.Элементы.Добавить("Подключаемый_СохранитьТекущиеНастройки", Тип("КнопкаФормы"), Форма.Элементы.ГруппаСКоммандыНастроек);
	// Присваиваем команду для созданной кнопке
	НовыйЭлемент.ИмяКоманды = "Подключаемый_СохранитьТекущиеНастройки";
	НовыйЭлемент.Заголовок = "Сохранить текущую настройку";
	
	НоваяКоманда = Форма.Команды.Добавить("Подключаемый_УдалитьТекущуюНастройку");
	НоваяКоманда.Действие = "Подключаемый_УдалитьТекущуюНастройку";
	// Добавляем элемент "КомандаПредупредить" с типом "Кнопка формы"
	НовыйЭлемент = Форма.Элементы.Добавить("Подключаемый_УдалитьТекущуюНастройку", Тип("КнопкаФормы"), Форма.Элементы.ГруппаСКоммандыНастроек);
	// Присваиваем команду для созданной кнопке
	НовыйЭлемент.ИмяКоманды = "Подключаемый_УдалитьТекущуюНастройку";
	НовыйЭлемент.Заголовок = "Удалить текущую настройку";
КонецПроцедуры

// Получить представление настройки.
//
// Параметры:
//  КлючНастройки		 - Строка - Ключ загружаемых настроек.
//  КлючОбъектаНастроек	 - Строка - Ключ объекта настройки. 
// 
// Возвращаемое значение:
//  Строка - Представление настройки.
//
Функция ПолучитьПредставлениеНастройки(КлючНастройки, КлючОбъектаНастроек) Экспорт
	ОписаниеНастроек = Новый ОписаниеНастроек;
	ТекущиеНастройкиСписка = ХранилищеПользовательскихНастроекДинамическихСписков.Загрузить(КлючОбъектаНастроек, КлючНастройки, ОписаниеНастроек, ИмяПользователя());
	Возврат ОписаниеНастроек.Представление;
КонецФункции

// Установить пользовательские настройки.
//
// Параметры:
//  Список				 - ДинамическийСписок - Передаваемый список.
//  КлючНастройки		 - Строка - Ключ загружаемых настроек.
//  КлючОбъектаНастроек	 - Строка - Ключ объекта настройки. 
//
Процедура УстановитьПользовательскиеНастройки(Список, КлючНастройки, КлючОбъектаНастроек) Экспорт
	ТекущиеНастройкиСписка = ХранилищеПользовательскихНастроекДинамическихСписков.Загрузить(КлючОбъектаНастроек, КлючНастройки, , ИмяПользователя());
	Если ТекущиеНастройкиСписка = Неопределено Тогда
		ТекущиеНастройкиСписка = Новый ПользовательскиеНастройкиКомпоновкиДанных;
	КонецЕсли;
	Список.КомпоновщикНастроек.ЗагрузитьПользовательскиеНастройки(ТекущиеНастройкиСписка);	
КонецПроцедуры

// Обработать выбор настройки на сервере
//
// Параметры:
//  НомерНастройки		 - Число - Номер настройки.
//  Список				 - ДинамическийСписок - Передаваемый список.
//  Форма				 - УправляемаяФорма - Передаваемая форма.
//  КлючОбъектаНастроек	 - Строка - Ключ объекта настройки. 
//
Процедура ОбработатьВыборНастройкиНаСервере(НомерНастройки, Список, Форма, КлючОбъектаНастроек) Экспорт
	СписокНастроек = ХранилищеПользовательскихНастроекДинамическихСписков.ПолучитьСписок(КлючОбъектаНастроек, ИмяПользователя());
	Форма.ИдентификаторПользовательскойНастройки = СписокНастроек.Получить(НомерНастройки).Значение;
	УстановитьПользовательскиеНастройки(Список, Форма.ИдентификаторПользовательскойНастройки, КлючОбъектаНастроек);
	Сч = 0;
	СписокНастроек = ХранилищеПользовательскихНастроекДинамическихСписков.ПолучитьСписок(КлючОбъектаНастроек, ИмяПользователя());
	Для Каждого ЭлементНастройки Из СписокНастроек Цикл	
		Форма.Элементы["Настройка_"+Формат(Сч, "ЧН=; ЧГ=")].Пометка = ЭлементНастройки.Значение = Форма.ИдентификаторПользовательскойНастройки;
		Если ЭлементНастройки.Значение = Форма.ИдентификаторПользовательскойНастройки Тогда
			Форма.Элементы.ГруппаПользовательскиеНастройки.Заголовок = ЭлементНастройки.Представление;
		КонецЕсли;	
		Сч = Сч + 1;
	КонецЦикла;
КонецПроцедуры

// Сохранить текущие настройки на сервере.
//
// Параметры:
//  ИмяНастройки		 - Строка - Имя настройки. 
//  Список				 - ДинамическийСписок - Передаваемый список.
//  Форма				 - УправляемаяФорма - Передаваемая форма.
//  КлючОбъектаНастроек	 - Строка - Ключ объекта настройки
//
Процедура СохранитьТекущиеНастройкиНаСервере(ИмяНастройки, Список, Форма, КлючОбъектаНастроек) Экспорт
	СписокНастроек = ХранилищеПользовательскихНастроекДинамическихСписков.ПолучитьСписок(КлючОбъектаНастроек, ИмяПользователя());
	Для Каждого ЭлементНастройки Из СписокНастроек Цикл	
		Если ЭлементНастройки.Представление = ИмяНастройки Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Настройка с таким именем уже существует!";
			Сообщение.Сообщить();
			Возврат;
		КонецЕсли;	
	КонецЦикла;	
	ОписаниеНастроек = Новый ОписаниеНастроек;
	ОписаниеНастроек.Представление = ИмяНастройки;
	ИДНастройки = Строка(Новый УникальныйИдентификатор);
	ОписаниеНастроек.КлючНастроек = ИДНастройки;
	ОписаниеНастроек.КлючОбъекта = КлючОбъектаНастроек;
	ОписаниеНастроек.Пользователь = ИмяПользователя();
	ХранилищеПользовательскихНастроекДинамическихСписков.Сохранить(КлючОбъектаНастроек, ИДНастройки, Список.КомпоновщикНастроек.ПользовательскиеНастройки, ОписаниеНастроек, ИмяПользователя()); 
	ИдентификаторПользовательскойНастройки = ИДНастройки;
	УстановитьПользовательскиеНастройки(Список, ИдентификаторПользовательскойНастройки, КлючОбъектаНастроек);
	ДобавитьПодменюПользовательскихНастроек(Форма, Список, КлючОбъектаНастроек);
КонецПроцедуры

#КонецОбласти

