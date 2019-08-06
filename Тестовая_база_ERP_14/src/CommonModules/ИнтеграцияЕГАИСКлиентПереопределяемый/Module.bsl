
#Область СлужебныйПрограммныйИнтерфейс

// Переопределяет параметры открытия формы сопоставления номенклатуры и алкогольной продукции.
//
// Параметры:
//   ИмяФормы                    - Строка                           - имя формы сопоставления.
//   ПараметрыФормы              - Структура                        - параметры открываемой формы, содержит:
//    * АлкогольнаяПродукция - СправочникСсылка.КлассификаторАлкогольнойПродукцииЕГАИС - Сопоставляемая алкогольная продукция,
//    * НоменклатураДляВыбора - Массив - массив номенклатуры для быстрого выбора.
//   Владелец                    - УправляемаяФорма, Неопределено   - Форма-владелец.
//   ОписаниеОповещенияОЗакрытии - ОписаниеОповещения, Неопределено - описание оповещения о закрытии формы.
//
Процедура ПриОпределенииФормыСопоставления(ИмяФормы, ПараметрыФормы, Владелец, ОписаниеОповещенияОЗакрытии) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Заполняет имя события, которое наступает при записи документа поступления в базу данных.
//
Процедура ПриОпределенииСобытияЗаписиДокументаПоступленияТоваров(ИмяСобытия) Экспорт
	
	//++ НЕ ГОСИС
	ИмяСобытия = "Запись_ПриобретениеТоваровУслуг";
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// Заполняет, дополняет реквизиты номенклатуры для выбора алкогольной продукции.
//
// Параметры:
//   Реквизиты   - Структура - значения реквизитов номенклатуры для выбора алкогольной продукции, с полем
//     "ВидАлкогольнойПродукции", для заполнения.
//   Номенклатура - ОпределяемыйТип.Номенклатура - Номенклатура.
// 
Процедура ПриОпределенииРеквизитовНоменклатурыДляВыбораАлкогольнойПродукции(Реквизиты, Номенклатура) Экспорт
	
	//++ НЕ ГОСИС
	Реквизиты.ВидАлкогольнойПродукции = ОбщегоНазначенияУТВызовСервера.ЗначениеРеквизитаОбъекта(Номенклатура,"ВидАлкогольнойПродукции");
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// Заполняет параметры заполнения при создании контрагента из классификатора организаций ЕГАИС в структуру с
//   ключами    - реквизитами справочника контрагентов конфигурации и соответствующими
//   значениями - реквизитами справочника "КлассификаторОрганизацийЕГАИС",
//   например, Результат.Вставить("ИНН","ИНН")
// Параметры:
//   Результат - Структура - структура параметров заполнения
//
Процедура ПриОпределенииПараметровСозданияКонтрагента(Результат) Экспорт
	
	//++ НЕ ГОСИС
	Результат.Вставить("ИНН","ИНН");
	Результат.Вставить("КПП","КПП");
	Результат.Вставить("Наименование","НаименованиеПолное");
	Результат.Вставить("СокращенноеНаименование","Наименование");
	Результат.Вставить("ТорговыйОбъект","ТорговыйОбъект");
	Результат.Вставить("ПредставлениеАдреса","ПредставлениеАдреса");
	Результат.Вставить("Адрес","Адрес");
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

#КонецОбласти

