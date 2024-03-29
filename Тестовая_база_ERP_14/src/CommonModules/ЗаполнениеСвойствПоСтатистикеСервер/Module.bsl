
#Область ПрограммныйИнтерфейс

// Заполняет реквизиты объекта по статистике.
// Используется в случае, когда надо заполнить реквизиты объекта в процедуре ОбработкаЗаполнения.
//
// Параметры:
//	Объект - ДокументОбъект или ДанныеФормыСтруктура - Заполняемый объект
//  ДанныеЗаполнения - Произвольный - одноименный параметр процедуры-обработчика заполнения модуля объекта.
//
//	Возвращаемое значение:
//		Структура
//			Ключ - имя измененного реквизита объекта
//			Значение - новое значение реквизита объекта.
//
Функция ЗаполнитьСвойстваОбъекта(Объект, ДанныеЗаполнения = Неопределено) Экспорт
	
	Возврат ЗаполнитьСвойства(Объект, , ДанныеЗаполнения);
	
КонецФункции

// Заполняет реквизиты объекта по статистике.
// Используется в случае, когда надо заполнить часть реквизитов Объекта при изменении реквизита формы.
//
// Параметры:
//	Объект - ДокументОбъект или ДанныеФормыСтруктура - Заполняемый объект
//	ОтборПоРеквизитуРодителю - Строка - Имя реквизита объекта, подчиненные реквизиты которого надо заполнить по статистике.
//
//	Возвращаемое значение:
//		Структура
//			Ключ - имя измененного реквизита объекта
//			Значение - новое значение реквизита объекта.
//
Функция ЗаполнитьПодчиненныеСвойства(Объект, ОтборПоРеквизитуРодителю) Экспорт
	
	Возврат ЗаполнитьСвойства(Объект, ОтборПоРеквизитуРодителю);
	
КонецФункции

// Заполняет требуемые реквизиты по статистике.
// Используется в случае, когда надо получить значения реквизитов в виде структуры.
//
// Параметры:
//	Ссылка - ЛюбаяСсылка - Объект, реквизиты которого надо заполнить
//	ЗаполняемыеРеквизиты - Структура - описание реквизитов, которые необходимо заполнить по статистике
//		Ключ - имя реквизита
//		Значение - Произвольный - на выходе будет заполнение значением по статистике
//	РеквизитыДляОтбора - Структура - описание реквизитов, которые используются для отбора статистики
//		Ключ - имя реквизита
//		Значение - Произвольный - значение реквизита.
//
Процедура ПолучитьЗначенияСвойств(Ссылка, ЗаполняемыеРеквизиты, РеквизитыДляОтбора) Экспорт
	
	// Получим шаблон описания заполняемых реквизитов
	ОписаниеРеквизитовОбъекта = ШаблонОписанияРеквизитовОбъекта();
	
	// Добавим в описание реквизитов объекта информацию о самом заполняемом объекте
	ОписаниеРеквизитовОбъекта.Вставить("Объект", Новый Структура);
	ОписаниеРеквизитовОбъекта.Объект.Вставить("Ссылка", 			  Ссылка);
	ОписаниеРеквизитовОбъекта.Объект.Вставить("ИмяОбъектаМетаданных", ПолноеИмяОбъектаМетаданных(Ссылка));
	
	// Закэшируем значения реквизитов для отбора и получим список этих реквизитов в виде строки.
	ИменаРеквизитовДляОтбора = "";
	
	Для Каждого ТекущийРеквизит Из РеквизитыДляОтбора Цикл
		
		ИменаРеквизитовДляОтбора = ИменаРеквизитовДляОтбора + ?(ИменаРеквизитовДляОтбора = "", "", ",") + ТекущийРеквизит.Ключ;
		
		ОписаниеРеквизитовОбъекта.КэшЗначенияРеквизитов.Вставить(ТекущийРеквизит.Ключ, ТекущийРеквизит.Значение);
		
	КонецЦикла;
	
	// Если в объекте есть реквизит Автор, то он тоже участвует в отборе статистики
	Если НЕ РеквизитыДляОтбора.Свойство("Автор") И ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(Ссылка, "Автор") Тогда
		// Закэшируем реквизит Автор
		ОписаниеРеквизитовОбъекта.КэшЗначенияРеквизитов.Вставить("Автор", Пользователи.АвторизованныйПользователь());
		ИменаОбязательныхРеквизитов = "Автор";
	Иначе
		ИменаОбязательныхРеквизитов = "";
	КонецЕсли;
	
	// Заполним каждый реквизит из параметра ЗаполняемыеРеквизиты 
	Для Каждого ТекущийРеквизит Из ЗаполняемыеРеквизиты Цикл
		
		// Сформируем описание заполняемого реквизита
		ЗаполняемыйРеквизит = Новый Структура("ИмяРеквизита, СтароеЗначение, НовоеЗначение", ТекущийРеквизит.Ключ);
		
		// Добавим информацию о заполняемом реквизите в описание реквизитов объекта
		ДобавитьЗаполняемыеРеквизиты(
			ОписаниеРеквизитовОбъекта.РеквизитыОбъекта,
			ЗаполняемыйРеквизит.ИмяРеквизита,
			ИменаОбязательныхРеквизитов,
			ИменаРеквизитовДляОтбора,
			"");
		
		// Получим значение реквизита по статистике
		ЗначениеРеквизитаПоСтатистике(ОписаниеРеквизитовОбъекта, ЗаполняемыйРеквизит);
		
		// Перенесем полученное значение в параметр ЗаполняемыеРеквизиты
		ЗаполняемыеРеквизиты.Вставить(ЗаполняемыйРеквизит.ИмяРеквизита, ЗаполняемыйРеквизит.НовоеЗначение);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область МеханизмЗаполнения

// Заполняет реквизиты объекта по статистике.
//
// Параметры:
//	Объект - ДокументОбъект или ДанныеФормыСтруктура - Заполняемый объект
//	ОтборПоРеквизитуРодителю - Строка - Имя реквизита объекта, подчиненные реквизиты которого надо заполнить по статистике.
//  ДанныеЗаполнения - Произвольный - одноименный параметр процедуры-обработчика заполнения модуля объекта.
//
//	Возвращаемое значение:
//		Структура
//			Ключ - имя измененного реквизита объекта
//			Значение - новое значение реквизита объекта.
//
Функция ЗаполнитьСвойства(Объект, ОтборПоРеквизитуРодителю = "", ДанныеЗаполнения = Неопределено)
	
	ИмяОбъектаМетаданных = ПолноеИмяОбъектаМетаданных(Объект);
	
	// Получим описание структуры реквизитов для заполнения
	ОписаниеРеквизитовОбъекта =
		ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(
			ЗаполнениеСвойствПоСтатистикеПовтИсп.ОписаниеЗаполняемыхРеквизитовОбъекта(
				ИмяОбъектаМетаданных,
				ОтборПоРеквизитуРодителю));
	
	Если ЗначениеЗаполнено(ОписаниеРеквизитовОбъекта.ТекстОшибки) Тогда
		ВызватьИсключение ОписаниеРеквизитовОбъекта.ТекстОшибки; // ошибка в описании заполняемых реквизитов объекта
	КонецЕсли;
	
	// Если способ расчета вознаграждения = не рассчитывается, 
	// реквизит "ПроцентВознаграждения"= 0 и не заполнятся по статистике
	Если ИмяОбъектаМетаданных = "Документ.ОтчетКомиссионера"
		И Объект.СпособРасчетаВознаграждения = ПредопределенноеЗначение("Перечисление.СпособыРасчетаКомиссионногоВознаграждения.НеРассчитывается") Тогда
		
		СтрПорядокЗаполненияРеквизитов = ОписаниеРеквизитовОбъекта.ПорядокЗаполненияРеквизитов[0];
		Если СтрПорядокЗаполненияРеквизитов.Свойство("ПроцентВознаграждения") Тогда
			СтрПорядокЗаполненияРеквизитов.Удалить("ПроцентВознаграждения");
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		ЗначенияИзДанныхЗаполнения =
			ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(
				ЗаполнениеСвойствПоСтатистикеПовтИсп.РеквизитыЗаполняемыеИзДанныхЗаполнения(ИмяОбъектаМетаданных));
		
		ЗаполнитьЗначенияСвойств(ЗначенияИзДанныхЗаполнения, ДанныеЗаполнения);
		
		Для Каждого КлючИЗначение Из ЗначенияИзДанныхЗаполнения Цикл
			Если ЗначениеЗаполнено(КлючИЗначение.Значение) И НЕ ЗначениеЗаполнено(Объект[КлючИЗначение.Ключ]) Тогда
				// Перенесем значение из данных заполнения в объект.
				// Это необходимо для того, чтобы не заполнять по статистике реквизиты,
				// которые должны заполниться из данных заполнения.
				Объект[КлючИЗначение.Ключ] = КлючИЗначение.Значение;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	// Добавим в описание реквизитов объекта информацию о самом заполняемом объекте
	ОписаниеРеквизитовОбъекта.Вставить("Объект", Новый Структура);
	ОписаниеРеквизитовОбъекта.Объект.Вставить("Ссылка", 			  Объект.Ссылка);
	ОписаниеРеквизитовОбъекта.Объект.Вставить("ИмяОбъектаМетаданных", ИмяОбъектаМетаданных);
	
	ИзмененныеРеквизиты = Новый Структура; // измененные реквизиты объекта
	
	// Автора берем не из реквизита документа, а из пользователя ИБ, т.к. статистику надо собирать по этому человеку.
	ОписаниеРеквизитовОбъекта.КэшЗначенияРеквизитов.Вставить("Автор", Пользователи.АвторизованныйПользователь());
	
	// Обходим дерево реквизитов - от "родителей" верхнего уровня до реквизитов, не имеющих "подчиненных" реквизитов.
	Для Каждого РеквизитыТекущегоУровня Из ОписаниеРеквизитовОбъекта.ПорядокЗаполненияРеквизитов Цикл
		
		// Что надо заполнить на этой итерации
		ЗаполняемыеРеквизиты = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(РеквизитыТекущегоУровня);
		ЗаполнитьЗначенияСвойств(ЗаполняемыеРеквизиты, Объект);
		
		// Заполним каждый реквизит текущего уровня дерева реквизитов
		Для Каждого Реквизит Из ЗаполняемыеРеквизиты Цикл
			
			// Добавим в кэш значения отсутствующих в нем "реквизитов-родителей" (которые еще не использовались).
			Для Каждого Родитель Из ОписаниеРеквизитовОбъекта.РеквизитыОбъекта[Реквизит.Ключ] Цикл
				Если НЕ ОписаниеРеквизитовОбъекта.КэшЗначенияРеквизитов.Свойство(Родитель.Ключ) Тогда
					ОписаниеРеквизитовОбъекта.КэшЗначенияРеквизитов.Вставить(Родитель.Ключ);
					ЗаполнитьЗначенияСвойств(ОписаниеРеквизитовОбъекта.КэшЗначенияРеквизитов, Объект, Родитель.Ключ);
				КонецЕсли;
			КонецЦикла;
			
			// Сформируем описание заполняемого реквизита
			ЗаполняемыйРеквизит = Новый Структура;
			ЗаполняемыйРеквизит.Вставить("ИмяРеквизита",   Реквизит.Ключ);
			ЗаполняемыйРеквизит.Вставить("СтароеЗначение", Реквизит.Значение);
			ЗаполняемыйРеквизит.Вставить("НовоеЗначение",  Неопределено);
			
			// Получим значение реквизита по статистике
			ЗначениеРеквизитаПоСтатистике(ОписаниеРеквизитовОбъекта, ЗаполняемыйРеквизит);
			
			Если ЗначениеЗаполнено(ЗаполняемыйРеквизит.НовоеЗначение)
			 И ЗаполняемыйРеквизит.НовоеЗначение <> ЗаполняемыйРеквизит.СтароеЗначение Тогда
				
				// Значение реквизита объекта отличается от значения, полученного по статистике
				ИзмененныеРеквизиты.Вставить(ЗаполняемыйРеквизит.ИмяРеквизита, ЗаполняемыйРеквизит.НовоеЗначение);
				
				Объект[ЗаполняемыйРеквизит.ИмяРеквизита] = ЗаполняемыйРеквизит.НовоеЗначение;
				
			КонецЕсли;
			
			// Добавим текущий реквизит в кэш (для заполнения "подчиненных" ему реквизитов)
			ОписаниеРеквизитовОбъекта.КэшЗначенияРеквизитов.Вставить(ЗаполняемыйРеквизит.ИмяРеквизита, ЗаполняемыйРеквизит.НовоеЗначение);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ИзмененныеРеквизиты; // справочно - сами реквизиты объекта уже изменены
	
КонецФункции


// Определяет значение реквизита, которое согласно статистике является "частотным".
//
// Параметры:
//	ОписаниеРеквизитовОбъекта - Структура - описание структуры реквизитов для заполнения, содержит ключи
//		Объект - Структура - содержит ключи
//			Ссылка - ЛюбаяСсылка - ссылка на объект
//			ИмяОбъектаМетаданных - Строка - полное имя объекта метаданных
//		остальные ключи см. ЗаполнениеСвойствПоСтатистикеПовтИсп.ОписаниеЗаполняемыхРеквизитовОбъекта()
//	ЗаполняемыйРеквизит - Структура - описание заполняемого реквизита, содержит ключи
//		ИмяРеквизита - Строка - имя заполняемого реквизита объекта
//		СтароеЗначение - Произвольный - текущее значение заполняемого реквизита
//		НовоеЗначение - Произвольный - новое значение заполняемого реквизита, по умолчанию Неопределено.
//
Процедура ЗначениеРеквизитаПоСтатистике(ОписаниеРеквизитовОбъекта, ЗаполняемыйРеквизит)
	
	СтандартнаяОбработка = Истина;
	
	// Переопределим типовое поведение 
	ЗаполнениеСвойствПоСтатистикеПереопределяемый.ПриОпределенииЗначенияРеквизитаПоСтатистике(
		ОписаниеРеквизитовОбъекта,
		ЗаполняемыйРеквизит,
		СтандартнаяОбработка);
	
	Если НЕ СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
#Область ОсобыеСлучаиЗаполненияРеквизитов
	
	// Реквизит вида Подразделение:
	//	1. Если есть документ-основание и у него есть реквизит вида "подразделение", то подразделение перезаполняем из основания
	//	2. Если есть реквизит "менеджер" и подразделение документа еще не заполнено, то подразделение заполняем из реквизита менеджера
	//	3. Иначе заполняем подразделение стандартно, по статистике.
	Если ЗаполняемыйРеквизит.ИмяРеквизита = ИмяРеквизитаПоВиду("Подразделение", ОписаниеРеквизитовОбъекта) Тогда
		
		// Проверка документа-основания
		ИмяРеквизитаОснования = ИмяРеквизитаПоВиду("ДокументОснование", ОписаниеРеквизитовОбъекта);	
		ДокументОснование 	  = ЗначениеРеквизитаИзКэша(ИмяРеквизитаОснования, ОписаниеРеквизитовОбъекта);
		
		Если ЗначениеЗаполнено(ДокументОснование) Тогда
			
			// У текущего документа заполнен документ-основание, возьмем подразделение из него
			ИмяРеквизитаПодразделение =
				ЗаполнениеСвойствПоСтатистикеПовтИсп.ИмяРеквизитаПодразделение(ПолноеИмяОбъектаМетаданных(ДокументОснование));
			
			Если ЗначениеЗаполнено(ИмяРеквизитаПодразделение) Тогда
				
				// Документы-исключения, в которых подразделение не перезаполняется по основанию
				НеЗаполняемыеПоОснованию = Новый Массив;
				//++ НЕ УТ
				НеЗаполняемыеПоОснованию.Добавить(Метаданные.Документы.ЗаказПереработчику.ПолноеИмя());
				//-- НЕ УТ
				
				Если НеЗаполняемыеПоОснованию.Найти(ОписаниеРеквизитовОбъекта.Объект.ИмяОбъектаМетаданных) = Неопределено Тогда
					ЗаполняемыйРеквизит.НовоеЗначение =
						ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование, ИмяРеквизитаПодразделение);
					Если ЗначениеЗаполнено(ЗаполняемыйРеквизит.НовоеЗначение) Тогда
						Возврат; // Если не документ-исключение, то новое значение: Объект.<Документ-основание>.<Подразделение>
					КонецЕсли;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
		// Проверка менеджера
		ИмяРеквизитаМенеджер = ИмяРеквизитаПоВиду("Менеджер", ОписаниеРеквизитовОбъекта);	
		Менеджер 			 = ЗначениеРеквизитаИзКэша(ИмяРеквизитаМенеджер, ОписаниеРеквизитовОбъекта);
			
		Если ЗначениеЗаполнено(Менеджер) И НЕ ЗначениеЗаполнено(ЗаполняемыйРеквизит.СтароеЗначение) Тогда
		 	
			// У текущего документа заполнен менеджер и еще не заполнено подразделение.
			// Если у этого менеджера указано подразделение, то перенесем его в документ.
			ПодразделениеМенеджера = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Менеджер);
			Если ЗначениеЗаполнено(ПодразделениеМенеджера) Тогда
				ЗаполняемыйРеквизит.НовоеЗначение = ПодразделениеМенеджера;
				Возврат; // Новое значение: Объект.<Менеджер>.Подразделение
			КонецЕсли;
			
		КонецЕсли;
		
		// Удалим "техногенные" реквизиты вида ДокументОснование и Менеджер из "родителей" реквизита вида Подразделение.
		// Статистика будет собираться стандартным способом по оставшимся "реквизитам-родителям".
		Если ЗначениеЗаполнено(ИмяРеквизитаОснования) Тогда
			ОписаниеРеквизитовОбъекта.РеквизитыОбъекта[ЗаполняемыйРеквизит.ИмяРеквизита].Удалить(ИмяРеквизитаОснования);
		КонецЕсли;
		Если ЗначениеЗаполнено(ИмяРеквизитаМенеджер) Тогда
			ОписаниеРеквизитовОбъекта.РеквизитыОбъекта[ЗаполняемыйРеквизит.ИмяРеквизита].Удалить(ИмяРеквизитаМенеджер);
		КонецЕсли;
		
	ИначеЕсли ЗаполняемыйРеквизит.ИмяРеквизита = ИмяРеквизитаПоВиду("Склад", ОписаниеРеквизитовОбъекта) Тогда
		
		Если ОписаниеРеквизитовОбъекта.Объект.ИмяОбъектаМетаданных = Метаданные.Документы.РеализацияТоваровУслуг.ПолноеИмя() Тогда
			
			// Проверка документа-основания
			ИмяРеквизитаОснования = ИмяРеквизитаПоВиду("ДокументОснование", ОписаниеРеквизитовОбъекта);	
			ДокументОснование 	  = ЗначениеРеквизитаИзКэша(ИмяРеквизитаОснования, ОписаниеРеквизитовОбъекта);
			
			Если ЗначениеЗаполнено(ДокументОснование) И ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ЗаказКлиента") Тогда
				// Для реализации, созданной на основании заказа клиента, не надо заполнять склад по статистике:
				// он или возьмется из основания, или должен быть ограничен группой складов из заказа и его выберет пользователь.
				ЗаполняемыйРеквизит.НовоеЗначение = ЗаполняемыйРеквизит.СтароеЗначение;
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
#КонецОбласти
	
	// Если реквизит уже заполнен, то его значение не перезаполняем
	Если ЗначениеЗаполнено(ЗаполняемыйРеквизит.СтароеЗначение) Тогда
		ЗаполняемыйРеквизит.НовоеЗначение = ЗаполняемыйРеквизит.СтароеЗначение;
		Возврат;
	КонецЕсли;
	
	// Обработаем реквизиты, по которым нужно отбирать данные для статистики
	РеквизитыРодители = ОписаниеРеквизитовОбъекта.РеквизитыОбъекта[ЗаполняемыйРеквизит.ИмяРеквизита];
	
	// Получим значения для отбора
	ЗначенияРеквизитовРодителей = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(РеквизитыРодители);
	ЗаполнитьЗначенияСвойств(ЗначенияРеквизитовРодителей, ОписаниеРеквизитовОбъекта.КэшЗначенияРеквизитов);
	
	Если ЗначенияРеквизитовРодителей.Свойство("Ответственный")
	 И НЕ ЗначениеЗаполнено(ЗначенияРеквизитовРодителей.Ответственный) Тогда
		ЗначенияРеквизитовРодителей.Ответственный = Пользователи.АвторизованныйПользователь();
	КонецЕсли;
	
	// Проверим заполненность значений для отбора
	Для Каждого ОписаниеРодителя Из РеквизитыРодители Цикл
		Если НЕ ЗначениеЗаполнено(ЗначенияРеквизитовРодителей[ОписаниеРодителя.Ключ]) Тогда
			Если ОписаниеРодителя.Значение = 1 Тогда
				// Этот реквизит-родитель должен быть обязательно заполнен, без него собирать статистику не имеет смысла.
				Возврат; 
			ИначеЕсли ОписаниеРодителя.Значение = 3 Тогда
				// Этот родитель не заполнен и на отбор статистики не влияет - удалим его из структуры для отбора.
				ЗначенияРеквизитовРодителей.Удалить(ОписаниеРодителя.Ключ);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	// Определим параметры сбора статистики
	ПараметрыСбораСтатистики = Новый Структура;
	ПараметрыСбораСтатистики.Вставить("РазмерВыборки", 5);
	ПараметрыСбораСтатистики.Вставить("ЧастотаИспользованияЗначения", 0.5);
	
	ЗаполнениеСвойствПоСтатистикеПереопределяемый.УстановитьПараметрыСбораСтатистики(
		ОписаниеРеквизитовОбъекта,
		ЗаполняемыйРеквизит,
		ПараметрыСбораСтатистики);
	
	// Сформируем текст запроса (содержит шаблоны для замены)
	// Алгоритм расчета значения реквизита:
	// - выберем последние по дате объекты в количестве "РазмерВыборки" (кроме помеченных на удаление объектов и текущего объекта)
	// - посчитаем количество раз, которое использовалось каждое значение заполняемого реквизита в выбранных объектах
	//	 	например, Зн1 = 1 раз, Зн2 - 3 раза, Зн3 - 1 раз
	// - выберем одно значение реквизита, вес которого среди всех значений составляет больше 0,5 (50%)
	//		например, вес Зн1 = 0,2, вес Зн2 = 0,6, вес Зн3 = 0,2, т.е. будет выбрано Зн2
	//	 	если значения с подходящим весом (> 0,5) нет, то не будет выбрано ничего,
	//	 	т.е. нет такого значения реквизита, которое по статистическим данным является "частотным".
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Статистика.ЗначениеРеквизита КАК ЗначениеРеквизита,
	|	СУММА(Статистика.ВесЗначения) КАК ВесЗначения
	|ПОМЕСТИТЬ ВТСтатистика
	|ИЗ
	|	(ВЫБРАТЬ ПЕРВЫЕ %РазмерВыборки%
	|		ТаблицаОбъекта.%ИмяРеквизита% КАК ЗначениеРеквизита,
	|		1 КАК ВесЗначения
	|	ИЗ
	|		%ИмяОбъектаМетаданных% КАК ТаблицаОбъекта
	|	ГДЕ
	|		НЕ ТаблицаОбъекта.ПометкаУдаления
	|		И НЕ ТаблицаОбъекта.Ссылка = &Ссылка
	|		%ОтборПоРодителям%
	|	
	|	УПОРЯДОЧИТЬ ПО
	|		ТаблицаОбъекта.Дата УБЫВ) КАК Статистика
	|
	|СГРУППИРОВАТЬ ПО
	|	Статистика.ЗначениеРеквизита
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВложенныйЗапрос.ЗначениеРеквизита
	|ИЗ
	|	(ВЫБРАТЬ
	|		Статистика.ЗначениеРеквизита,
	|		Статистика.ВесЗначения / ОбщееКоличество.ОбщийВес КАК УдельныйВес
	|	ИЗ
	|		ВТСтатистика КАК Статистика
	|			ЛЕВОЕ СОЕДИНЕНИЕ 
	|				(ВЫБРАТЬ
	|					СУММА(Статистика.ВесЗначения) КАК ОбщийВес
	|				 ИЗ
	|					ВТСтатистика КАК Статистика) КАК ОбщееКоличество
	|			ПО ИСТИНА) КАК ВложенныйЗапрос
	|ГДЕ
	|	ВложенныйЗапрос.УдельныйВес > &ЧастотаИспользованияЗначения
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВложенныйЗапрос.УдельныйВес,
	|	ВложенныйЗапрос.ЗначениеРеквизита";
	
	// Отборы запроса:
	// - по объекту, реквизит которого заполняется по статистике.
	Запрос.УстановитьПараметр("Ссылка", ОписаниеРеквизитовОбъекта.Объект.Ссылка);
	// - по минимальному весу значения; вес выше этого позволяет считать значение "частотным".
	Запрос.УстановитьПараметр("ЧастотаИспользованияЗначения", ПараметрыСбораСтатистики.ЧастотаИспользованияЗначения);
	
	// - по реквизитам-родителям; параметры запроса вида "&Отбор_<Имя реквизита-родителя>".
	ТекстОтборПоРодителям = "";
	
	Для Каждого Родитель Из ЗначенияРеквизитовРодителей Цикл
		
		ТекстОтборПоРодителям = ТекстОтборПоРодителям + ?(ЗначениеЗаполнено(ТекстОтборПоРодителям), Символы.ПС + "		", "")
			+ "И ТаблицаОбъекта." + Родитель.Ключ + " = &Отбор_" + Родитель.Ключ;
		
		Запрос.УстановитьПараметр("Отбор_" + Родитель.Ключ, Родитель.Значение);
		
	КонецЦикла;
	
	// Заменим шаблоны в тексте запроса:
	// Размер статистической выборки объектов.
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "%РазмерВыборки%", 	   Формат(ПараметрыСбораСтатистики.РазмерВыборки, "ЧГ=0"));
	// Имя заполняемого реквизита
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ИмяРеквизита%", 		   ЗаполняемыйРеквизит.ИмяРеквизита);
	// Имя объекта метаданных
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ИмяОбъектаМетаданных%", ОписаниеРеквизитовОбъекта.Объект.ИмяОбъектаМетаданных);
	// Текст условия для отбора по реквизитам-родителям
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ОтборПоРодителям%", 	   ТекстОтборПоРодителям);
	
	// Получим значение реквизита по статистике
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполняемыйРеквизит.НовоеЗначение = Выборка.ЗначениеРеквизита;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает имя реквизита объекта по его "виду" из описания реквизитов объекта.
// Например, вид реквизита - "Организация", а реквизит объекта может иметь имя "ОрганизацияОтправитель".
// 
// Параметры:
//	ВидРеквизита - Строка - "вид" реквизита
//	ОписаниеРеквизитовОбъекта - Структура - описание структуры реквизитов для заполнения,
//		подробнее см. ЗаполнениеСвойствПоСтатистикеПовтИсп.ОписаниеЗаполняемыхРеквизитовОбъекта().
//
// Возвращаемое значение:
//	Строка - имя реквизита объекта.
//
Функция ИмяРеквизитаПоВиду(ВидРеквизита, ОписаниеРеквизитовОбъекта)
	
	Если ОписаниеРеквизитовОбъекта.СинонимыРеквизитов.Свойство(ВидРеквизита) Тогда
		// Реквизит этого "вида" в объекте имеет другое имя
		ИмяРеквизита = ОписаниеРеквизитовОбъекта.СинонимыРеквизитов[ВидРеквизита];
	Иначе
		// Имя этого реквизита в объекте совпадает с его "видом"
		ИмяРеквизита = ВидРеквизита;
	КонецЕсли;
	
	Возврат ИмяРеквизита;
	
КонецФункции

// Возвращает значение реквизита, сохраненное в кэше, по имени реквизита.
//
// Параметры:
//	ИмяРеквизита - Строка - имя реквизита
//	ОписаниеРеквизитовОбъекта - Структура - описание структуры реквизитов для заполнения,
//		подробнее см. ЗаполнениеСвойствПоСтатистикеПовтИсп.ОписаниеЗаполняемыхРеквизитовОбъекта().
//
// Возвращаемое значение:
//	Произвольное - значение реквизита, сохраненное в кэше.
//	
Функция ЗначениеРеквизитаИзКэша(ИмяРеквизита, ОписаниеРеквизитовОбъекта)
	
	Если ЗначениеЗаполнено(ИмяРеквизита)
	 И ОписаниеРеквизитовОбъекта.КэшЗначенияРеквизитов.Свойство(ИмяРеквизита)
	 И ЗначениеЗаполнено(ОписаниеРеквизитовОбъекта.КэшЗначенияРеквизитов[ИмяРеквизита]) Тогда
		
		Возврат ОписаниеРеквизитовОбъекта.КэшЗначенияРеквизитов[ИмяРеквизита];
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Возвращает имя объекта метаданных.
//
// Параметры:
//	Объект - Произвольный
//
// Возвращаемое значение:
// 	Строка - полное имя объекта метаданных.
//
Функция ПолноеИмяОбъектаМетаданных(Объект)
	
	Если ТипЗнч(Объект) = Тип("ДанныеФормыСтруктура") Тогда
		ИмяОбъектаМетаданных = Объект.Ссылка.Метаданные().ПолноеИмя();
	Иначе // ДокументОбъект
		ИмяОбъектаМетаданных = Объект.Метаданные().ПолноеИмя();
	КонецЕсли;
	
	Возврат ИмяОбъектаМетаданных;
	
КонецФункции

#КонецОбласти

#Область ОписаниеСтруктурыРеквизитов

// Возвращает шаблон структуры для описания реквизитов объекта.
//
// Возвращаемое значение:
//	Структура, см. комментарий к ОписаниеЗаполняемыхРеквизитовОбъекта().
//
Функция ШаблонОписанияРеквизитовОбъекта() Экспорт
	
	ОписаниеРеквизитовОбъекта = Новый Структура;
	ОписаниеРеквизитовОбъекта.Вставить("РеквизитыОбъекта",   		  Новый Структура);
	ОписаниеРеквизитовОбъекта.Вставить("СинонимыРеквизитов", 		  Новый Структура);
	ОписаниеРеквизитовОбъекта.Вставить("ПорядокЗаполненияРеквизитов", Новый Массив);
	ОписаниеРеквизитовОбъекта.Вставить("КэшЗначенияРеквизитов", 	  Новый Структура);
	ОписаниеРеквизитовОбъекта.Вставить("ТекстОшибки", 				  "");
	
	Возврат ОписаниеРеквизитовОбъекта;
	
КонецФункции

// Добавляет в структуру описания реквизитов информацию о реквизитах и их "родителях".
//
// Параметры:
//	РеквизитыОбъекта - Структура
//		Подробнее см. одноименный ключ в комментарии к ЗаполнениеСвойствПоСтатистикеПовтИсп.ОписаниеЗаполняемыхРеквизитовОбъекта()
//  ИменаРеквизитов - Строка - имена реквизитов объекта, разделенные запятыми
//	НедопустимыПустыеЗначения - Строка - реквизиты-родители, для которых недопустимы пустые значения
//		Подробнее см. комментарий к ЗаполнениеСвойствПоСтатистикеПовтИсп.ОписаниеЗаполняемыхРеквизитовОбъекта()
//	ОтбиратьПриЛюбыхЗначениях - Строка - реквизиты-родители, которые участвуют в отборе статистики всегда
//		Подробнее см. комментарий к ЗаполнениеСвойствПоСтатистикеПовтИсп.ОписаниеЗаполняемыхРеквизитовОбъекта()
//	ОтбиратьТолькоЗаполненные - Строка - реквизиты-родители, которые участвуют в отборе статистики только если они заполнены
//		Подробнее см. комментарий к ЗаполнениеСвойствПоСтатистикеПовтИсп.ОписаниеЗаполняемыхРеквизитовОбъекта().
//
Процедура ДобавитьЗаполняемыеРеквизиты(РеквизитыОбъекта, ИменаРеквизитов,
			НедопустимыПустыеЗначения = "", ОтбиратьПриЛюбыхЗначениях = "", ОтбиратьТолькоЗаполненные = "") Экспорт
	
	НовыеРеквизиты = Новый Структура(ИменаРеквизитов);
	
	Для Каждого Реквизит Из НовыеРеквизиты Цикл
		
		РеквизитыОбъекта.Вставить(Реквизит.Ключ, Новый Структура);
		
		ВспомогательнаяСтруктура = Новый Структура(НедопустимыПустыеЗначения);
		Для Каждого КлючИЗначение Из ВспомогательнаяСтруктура Цикл
			РеквизитыОбъекта[Реквизит.Ключ].Вставить(КлючИЗначение.Ключ, 1);
		КонецЦикла;
		
		ВспомогательнаяСтруктура = Новый Структура(ОтбиратьПриЛюбыхЗначениях);
		Для Каждого КлючИЗначение Из ВспомогательнаяСтруктура Цикл
			РеквизитыОбъекта[Реквизит.Ключ].Вставить(КлючИЗначение.Ключ, 2);
		КонецЦикла;
		
		ВспомогательнаяСтруктура = Новый Структура(ОтбиратьТолькоЗаполненные);
		Для Каждого КлючИЗначение Из ВспомогательнаяСтруктура Цикл
			РеквизитыОбъекта[Реквизит.Ключ].Вставить(КлючИЗначение.Ключ, 3);
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиПодписокНаСобытия

// Заполняет реквизит Автор нового документа, являющегося источников для подписки УстановитьАвтораДокумента .
// 
// Параметры:
//	Источник - ДокументОбъект - документ с реквизитом Автор.
//	Отказ - см. в справочной информации по платформе
//	РежимЗаписи - см. в справочной информации по платформе
//	РежимПроведения - см. в справочной информации по платформе.
//
Процедура УстановитьАвтораДокументаПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Источник.Ссылка) Тогда
		Источник.Автор = Пользователи.АвторизованныйПользователь();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
