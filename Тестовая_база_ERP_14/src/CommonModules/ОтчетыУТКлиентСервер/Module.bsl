
#Область СлужебныйПрограммныйИнтерфейс

// Функция возвращает значение отбора пользователя, установленного в отчете.
Функция ПолучитьЗначениеОтбора(КомпоновщикНастроек, ИмяПоля, МассивОперацийСравнения = Неопределено, ТолькоЕслиИспользуется = Ложь) Экспорт
	Значение = Неопределено;
	ПолеОтбора = Новый ПолеКомпоновкиДанных(ИмяПоля);
	ПоВсемОперациям = ?(ЗначениеЗаполнено(МассивОперацийСравнения), Ложь, Истина);
	Для Каждого Поле Из КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
		Если ТипЗнч(Поле) <> Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			Продолжить;
		КонецЕсли;
		Если Поле.ЛевоеЗначение = ПолеОтбора И (НЕ ТолькоЕслиИспользуется ИЛИ Поле.Использование) Тогда
			Если ПоВсемОперациям Тогда
				ПолеЗначения = НайтиПользовательскуюНастройку(КомпоновщикНастроек.ПользовательскиеНастройки, Поле.ИдентификаторПользовательскойНастройки);
				Значение = ПолеЗначения.ПравоеЗначение;
			Иначе
				Для Каждого ОперацияСравнения Из МассивОперацийСравнения Цикл
					Если Поле.ВидСравнения = ОперацияСравнения Тогда
						ПолеЗначения = НайтиПользовательскуюНастройку(КомпоновщикНастроек.ПользовательскиеНастройки, Поле.ИдентификаторПользовательскойНастройки);
						Если ПолеЗначения <> Неопределено Тогда
							Значение = ПолеЗначения.ПравоеЗначение;
						КонецЕсли;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат Значение;
КонецФункции

// Возвращает окончание периода отчета. Используется в методах
// по актуализации оффлайновых регистров, служит датой окончания расчета.
//	Параметры:
//		КомпоновщикНастроек - КомпоновщикНастроек - Компоновщик настроек отчета
//		ИмяПоля - Строка - Имя поля в параметрах, которое отвечает за период отчета.
//	ВозвращаемоеЗначение:
//		Дата
Функция ГраницаРасчета(КомпоновщикНастроек, ИмяПоля) Экспорт
	ПараметрПериодОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, ИмяПоля);
	Если ТипЗнч(ПараметрПериодОтчета.Значение) = Тип("СтандартныйПериод") Тогда
		ГраницаРасчета = ?(ПараметрПериодОтчета.Использование, ПараметрПериодОтчета.Значение.ДатаОкончания, ОбщегоНазначенияУТВызовСервера.ДатаСеанса());
	Иначе
		ГраницаРасчета = ?(ПараметрПериодОтчета.Использование, ПараметрПериодОтчета.Значение, ОбщегоНазначенияУТВызовСервера.ДатаСеанса());
	КонецЕсли;
	Возврат КонецМесяца(ГраницаРасчета) + 1;
КонецФункции

// Находит пользовательскую настройку по ее идентификатору.
//
// Параметры:
//   ПользовательскиеНастройкиКД - ПользовательскиеНастройкиКомпоновкиДанных - Коллекция пользовательских настроек.
//   Идентификатор - Строка - Идентификатор настройки, которую нужно найти.
//
// Возвращаемое значение:
//   Неопределено - Когда настройка не найдена.
//   ЭлементОтбораКомпоновкиДанных, ЗначениеПараметраНастроекКомпоновкиДанных
//     и прочие типы элементов из КоллекцияЭлементовПользовательскихНастроекКомпоновкиДанных - Пользовательская настройка.
//
Функция НайтиПользовательскуюНастройку(ПользовательскиеНастройкиКД, Идентификатор) Экспорт
	Для Каждого ПользовательскаяНастройка Из ПользовательскиеНастройкиКД.Элементы Цикл
		Если ПользовательскаяНастройка.ИдентификаторПользовательскойНастройки = Идентификатор Тогда
			Возврат ПользовательскаяНастройка;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
КонецФункции

// Возвращает вид периода. В отличии от функции ПолучитьВидПериода на вход принимает СтандартныйПериод.
Функция ПолучитьВидСтандартногоПериода(СтандартныйПериод, ДоступныеПериоды = Неопределено) Экспорт
	
	Если СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ПроизвольныйПериод Тогда
		
		Возврат ПолучитьВидПериода(СтандартныйПериод.ДатаНачала, СтандартныйПериод.ДатаОкончания, ДоступныеПериоды);
		
	ИначеЕсли СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ЭтотГод
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ПрошлыйГод
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СледующийГод
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СНачалаЭтогоГода
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ДоКонцаЭтогоГода
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ПрошлыйГодДоТакойЖеДаты
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СледующийГодДоТакойЖеДаты Тогда
		
		Возврат ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Год");
		
	ИначеЕсли СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ЭтоПолугодие
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ПрошлоеПолугодие
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СледующееПолугодие
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СНачалаЭтогоПолугодия
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ДоКонцаЭтогоПолугодия
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ПрошлоеПолугодиеДоТакойЖеДаты
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СледующееПолугодиеДоТакойЖеДаты Тогда
		
		Возврат ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Полугодие");
		
	ИначеЕсли СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ЭтотКвартал
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ПрошлыйКвартал
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СледующийКвартал
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СНачалаЭтогоКвартала
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ДоКонцаЭтогоКвартала
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ПрошлыйКварталДоТакойЖеДаты
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СледующийКварталДоТакойЖеДаты Тогда
		
		Возврат ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Квартал");
		
	ИначеЕсли СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ЭтотМесяц
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ПрошлыйМесяц
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СледующийМесяц
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.Месяц
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СНачалаЭтогоМесяца
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ДоКонцаЭтогоМесяца
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ПрошлыйМесяцДоТакойЖеДаты
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СледующийМесяцДоТакойЖеДаты Тогда
		
		Возврат ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Месяц");
		
	ИначеЕсли СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ЭтаДекада
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ПрошлаяДекада
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СледующаяДекада
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СНачалаЭтойДекады
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ДоКонцаЭтойДекады
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ПрошлаяДекадаДоТакогоЖеНомераДня
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СледующаяДекадаДоТакогоЖеНомераДня Тогда
		
		Возврат ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Декада");
		
	ИначеЕсли СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ЭтаНеделя
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ПрошлаяНеделя
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СледующаяНеделя
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СНачалаЭтойНедели
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ДоКонцаЭтойНедели
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.Последние7Дней
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.Следующие7Дней
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.ПрошлаяНеделяДоТакогоЖеДняНедели
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.СледующаяНеделяДоТакогоЖеДняНедели Тогда
		
		Возврат ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Неделя");
		
	ИначеЕсли СтандартныйПериод.Вариант = ВариантСтандартногоПериода.Сегодня
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.Вчера
		Или СтандартныйПериод.Вариант = ВариантСтандартногоПериода.Завтра Тогда
		
		Возврат ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.День");
		
	КонецЕсли;
	
КонецФункции

// Возвращает вид периода.
Функция ПолучитьВидПериода(НачалоПериода, КонецПериода, ДоступныеПериоды = Неопределено) Экспорт
	
	ВидПериода = Неопределено;
	Если НачалоПериода = НачалоДня(НачалоПериода)
		И КонецПериода = КонецДня(КонецПериода) Тогда
		
		РазностьДней = (КонецПериода - НачалоПериода + 1) / (60*60*24);
		Если РазностьДней = 1 Тогда
			
			ВидПериода = ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.День");
			
		ИначеЕсли РазностьДней = 7 Тогда
			
			Если НачалоПериода = НачалоНедели(НачалоПериода) Тогда
				ВидПериода = ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Неделя");
			КонецЕсли;
			
		ИначеЕсли РазностьДней <= 11 Тогда
			
			Если (День(НачалоПериода) = 1 И День(КонецПериода) = 10)
				ИЛИ (День(НачалоПериода) = 11 И День(КонецПериода) = 20)
				ИЛИ (День(НачалоПериода) = 21 И КонецПериода = КонецМесяца(НачалоПериода)) Тогда
				ВидПериода = ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Декада");
			КонецЕсли;
			
		ИначеЕсли РазностьДней <= 31 Тогда
			
			Если НачалоПериода = НачалоМесяца(НачалоПериода) И КонецПериода = КонецМесяца(НачалоПериода) Тогда
				ВидПериода = ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Месяц");
			КонецЕсли;
			
		ИначеЕсли РазностьДней <= 92 Тогда
			
			Если НачалоПериода = НачалоКвартала(НачалоПериода) И КонецПериода = КонецКвартала(НачалоПериода) Тогда
				ВидПериода = ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Квартал");
			КонецЕсли;
			
		ИначеЕсли РазностьДней <= 190 Тогда
			
			Если Месяц(НачалоПериода) + 5 = Месяц(КонецПериода)
				И НачалоПериода = НачалоМесяца(НачалоПериода)
				И КонецПериода = КонецМесяца(КонецПериода)
				И (НачалоПериода = НачалоГода(НачалоПериода) ИЛИ КонецПериода = КонецГода(НачалоПериода)) Тогда
				ВидПериода = ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Полугодие");
			КонецЕсли;
			
		ИначеЕсли РазностьДней <= 366 Тогда
			
			Если НачалоПериода = НачалоГода(НачалоПериода) И КонецПериода = КонецГода(НачалоПериода) Тогда
				ВидПериода = ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Год");
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	Если ВидПериода = Неопределено Тогда
		ВидПериода = ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.ПроизвольныйПериод");
	КонецЕсли;
	
	Если ДоступныеПериоды <> Неопределено И ДоступныеПериоды.НайтиПоЗначению(ВидПериода) = Неопределено Тогда
		ВидПериода = ДоступныеПериоды[0].Значение;
	КонецЕсли;
	
	Возврат ВидПериода;
	
КонецФункции

// Добавляет выбранное поле компоновки данных.
//
// Параметры:
//   Куда - КомпоновщикНастроекКомпоновкиДанных, НастройкиКомпоновкиДанных, ВыбранныеПоляКомпоновкиДанных -
//       Коллекция в которую требуется добавить выбранное поле.
//   ИмяИлиПолеКД - Строка, ПолеКомпоновкиДанных - Имя поля.
//   Заголовок    - Строка - Необязательный. Представление поля.
//
// Возвращаемое значение:
//   ВыбранноеПолеКомпоновкиДанных - Добавленное выбранное поле.
//
Функция ДобавитьВыбранноеПоле(Куда, ИмяИлиПолеКД, Заголовок = "") Экспорт
	
	Если ТипЗнч(Куда) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		ВыбранныеПоляКД = Куда.Настройки.Выбор;
	ИначеЕсли ТипЗнч(Куда) = Тип("НастройкиКомпоновкиДанных") Тогда
		ВыбранныеПоляКД = Куда.Выбор;
	Иначе
		ВыбранныеПоляКД = Куда;
	КонецЕсли;
	
	Если ТипЗнч(ИмяИлиПолеКД) = Тип("Строка") Тогда
		ПолеКД = Новый ПолеКомпоновкиДанных(ИмяИлиПолеКД);
	Иначе
		ПолеКД = ИмяИлиПолеКД;
	КонецЕсли;
	
	ВыбранноеПолеКД = ВыбранныеПоляКД.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПолеКД.Поле = ПолеКД;
	Если Заголовок <> "" Тогда
		ВыбранноеПолеКД.Заголовок = Заголовок;
	КонецЕсли;
	
	Возврат ВыбранноеПолеКД;
	
КонецФункции

#КонецОбласти
