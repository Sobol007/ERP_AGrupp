
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОбъектЗначение = РеквизитФормыВЗначение("Объект");
	ДанныеФайла = ОбъектЗначение.ОбработкаДействия.Получить();
	АдресФайла = ПоместитьВоВременноеХранилище(ДанныеФайла, УникальныйИдентификатор);
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.ИндексЦвета = 10;
	КонецЕсли;
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	#Если ВебКлиент Тогда
		Элементы.РежимОтладки.Видимость = Ложь;
	#КонецЕсли
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ТекущийОбъект.ОбработкаДействия = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(АдресФайла));
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ОбновитьПовторноИспользуемыеЗначения();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПутьКОбработкеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		
	ДиалогВыбораФайла.Фильтр = "Файл обработки (*.epf)|*.epf";
	ДиалогВыбораФайла.Расширение = "html";
	
	ДиалогВыбораФайла.Заголовок = НСтр("ru = 'Выберите внешнюю обработку для отладки'");
	ДиалогВыбораФайла.ПредварительныйПросмотр = Ложь;
	ДиалогВыбораФайла.ИндексФильтра = 0;
	ДиалогВыбораФайла.ПолноеИмяФайла = Объект.ПутьКОбработке;
	ДиалогВыбораФайла.ПроверятьСуществованиеФайла = истина;
	
	ДиалогВыбораФайла.Показать(Новый ОписаниеОповещения("ПутьКОбработкеНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("ДиалогВыбораФайла", ДиалогВыбораФайла)));

КонецПроцедуры

&НаКлиенте
Процедура ПутьКОбработкеНачалоВыбораЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	ДиалогВыбораФайла = ДополнительныеПараметры.ДиалогВыбораФайла;
	
	
	Если (ВыбранныеФайлы <> Неопределено) Тогда
		
		Объект.ПутьКОбработке = ДиалогВыбораФайла.ПолноеИмяФайла;
		
		ЭтаФорма.Модифицированность = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РежимОтладкиПриИзменении(Элемент)
	Если НЕ Объект.РежимОтладки Тогда
		ОписаниеОповещенияЗавершения = Новый ОписаниеОповещения("ВопросЗагрузитьОбработку", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещенияЗавершения, НСтр("ru = 'Загрузить новую обработку действия?'"), РежимДиалогаВопрос.ДаНет);
		
	// Иначе
		// ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		//
		// ДиалогВыбораФайла.Фильтр = "Файл обработки (*.epf)|*.epf";
		// ДиалогВыбораФайла.Расширение = "html";
		//
		// ДиалогВыбораФайла.Заголовок = НСтр("ru = 'Выберите внешнюю обработку для отладки'");
		// ДиалогВыбораФайла.ПредварительныйПросмотр = Ложь;
		// ДиалогВыбораФайла.ИндексФильтра = 0;
		// ДиалогВыбораФайла.ПолноеИмяФайла = Объект.ПутьКОбработке;
		// ДиалогВыбораФайла.ПроверятьСуществованиеФайла = истина;
		//
		// ДиалогВыбораФайла.Показать(Новый ОписаниеОповещения("РежимОтладкиПриИзмененииЗавершение", ЭтотОбъект, Новый Структура("ДиалогВыбораФайла", ДиалогВыбораФайла)));
		// Возврат;
	КонецЕсли;
	РежимОтладкиПриИзмененииФрагмент();
КонецПроцедуры

&НаКлиенте
Процедура ИндексЦветаНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОповещениеНовое = Новый ОписаниеОповещения("ЦветНачалоВыбораЗавершение", ЭтотОбъект);
	ПараметрыФормы = Новый Структура("ТекущийЦвет", Объект.ИндексЦвета);
	ФормаВыбораЦвета = ОткрытьФорму("Справочник.CRM_Категории.Форма.ФормаВыбораЦвета", ПараметрыФормы, Элемент,,,,
		ОповещениеНовое, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);	
КонецПроцедуры // ЦветНачалоВыбора()

&НаКлиенте
// Продолжение процедуры "ЦветНачалоВыбора"
//
Процедура ЦветНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если НЕ (Результат = Неопределено) И НЕ (Результат = КодВозвратаДиалога.Отмена) Тогда
		Объект.ИндексЦвета = Результат[0].Картинка;
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры	

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьСтандартнуюОбработку(Команда)
	
	ОписаниеОповещенияЗавершения = Новый ОписаниеОповещения("ВопроcВосстановитьОбработку", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещенияЗавершения, НСтр("ru = 'Восстановить стандартную обработку ?'"), РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьОбработку(Команда)
	ПодготовитьКВыгрузкеОбработкуНаСервере();

	ОбщегоНазначенияКлиент.ПроверитьРасширениеРаботыСФайламиПодключено(
			Новый ОписаниеОповещения(
				"ВыгрузитьОбработкуПродолжение",
				ЭтотОбъект,
				Новый Структура),
			НСтр("ru='Для продолжения необходимо установить расширение для работы с файлами.';en='Continue, install the file operation extension.'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьОбработкуПродолжение(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт

	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьВыборФайла", ЭтаФорма);
	ИмяФайла = Объект.НазваниеОбработки+".epf";
	Файл = Новый ОписаниеПередаваемогоФайла(ИмяФайла, АдресФайла);
	ПолучаемыеФайлы = Новый Массив;
	ПолучаемыеФайлы.Добавить(Файл);
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	ДиалогОткрытияФайла.Фильтр = "(*.epf)|*.epf";
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	НачатьПолучениеФайлов(ОписаниеОповещения, ПолучаемыеФайлы, ДиалогОткрытияФайла, Истина);
    
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборФайла(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт

	Если ПомещенныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого ПереданныйФайл Из ПомещенныеФайлы Цикл
		Объект.ПутьКОбработке 		= ПереданныйФайл.Имя;
		ЭтаФорма.Модифицированность = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьОбработкуКлиент(Команда)
	
	ОбщегоНазначенияКлиент.ПроверитьРасширениеРаботыСФайламиПодключено(
			Новый ОписаниеОповещения(
				"ЗагрузитьОбработкуПродолжение",
				ЭтотОбъект,
				Новый Структура),
			НСтр("ru='Для продолжения необходимо установить расширение для работы с файлами.';en='Continue, install the file operation extension.'"));

КонецПроцедуры
	
&НаКлиенте
Процедура ЗагрузитьОбработкуПродолжение(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт

	Если ЗначениеЗаполнено(Объект.НазваниеОбработки) Тогда
		ОписаниеОповещенияЗавершения = Новый ОписаниеОповещения("ВопросЗагрузитьОбработку", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещенияЗавершения, НСтр("ru = 'Загрузить новую обработку с диска?'"), РежимДиалогаВопрос.ДаНет);
	Иначе
		ВопросЗагрузитьОбработку(КодВозвратаДиалога.Да, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросЗагрузитьОбработку(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьОбработкуЗавершение", ЭтаФорма);
		ИмяФайла = Объект.НазваниеОбработки+".epf";
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		ДиалогОткрытияФайла.Фильтр = "(*.epf)|*.epf";
		ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
		НачатьПомещениеФайлов(ОписаниеОповещения, , ДиалогОткрытияФайла, Истина, УникальныйИдентификатор);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьОбработкуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
		АдресФайла = Результат[0].Хранение;
		Объект.ПутьКОбработке = Результат[0].Имя;
		ЗагрузитьОбработку();
		ЭтаФорма.Модифицированность = Истина;
		УстановитьВидимость();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВопроcВосстановитьОбработку(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗагрузитьСтандартнуюОбработкуНаСервере();
		ЭтаФорма.Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

// Вызов закомментирован.

//&НаКлиенте
//Процедура РежимОтладкиПриИзмененииЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
//	
//	ДиалогВыбораФайла = ДополнительныеПараметры.ДиалогВыбораФайла;
//	
//	
//	Если (ВыбранныеФайлы <> Неопределено) Тогда
//		
//		Объект.ПутьКОбработке = ДиалогВыбораФайла.ПолноеИмяФайла;
//		
//		// ЗагрузитьОбработку();
//		ЭтаФорма.Модифицированность = Истина;
//	КонецЕсли;
//	
//	РежимОтладкиПриИзмененииФрагмент();

//КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимость()
	
	Элементы.ПутьКОбработке.Видимость 	  = Объект.РежимОтладки;
	Элементы.НазваниеОбработки.Видимость  = НЕ Объект.РежимОтладки;
	Элементы.ЗагрузитьОбработку.Видимость = НЕ Объект.РежимОтладки;
	Элементы.ВыгрузитьОбработку.Видимость = НЕ Объект.РежимОтладки;
	Элементы.ВыгрузитьОбработку.Доступность = ЗначениеЗаполнено(Объект.НазваниеОбработки);
	Элементы.ЗагрузитьСтандартнуюОбработку.Видимость = Объект.Предопределенный и НЕ Объект.РежимОтладки;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьОбработку()
	ПараметрыЗащиты = Новый("ОписаниеЗащитыОтОпасныхДействий"+"");
	ПараметрыЗащиты.ПредупреждатьОбОпасныхДействиях = Ложь;
	
	Объект.ИспользуетсяСтандартнаяОбработка = Ложь;
	Обработка =  ВнешниеОбработки.Создать(ВнешниеОбработки.Подключить(АдресФайла,,Ложь, ПараметрыЗащиты), Ложь);
	Объект.НазваниеОбработки = Обработка.Метаданные().Имя;
	Если Объект.Наименование = "" Тогда
		Объект.Наименование = Обработка.Метаданные().Синоним;
	КонецЕсли;
КонецПроцедуры	

&НаСервере
Функция ПолучитьДвоичныеДанныеИзХранилища()
	ОбъектПолучения = РеквизитФормыВЗначение("Объект");
	Возврат(ОбъектПолучения.ОбработкаДействия.Получить());
КонецФункции

&НаКлиенте
Процедура ПодготовитьКВыгрузкеОбработкуНаСервере()
	// ОбъектЗначение = РеквизитФормыВЗначение("Объект");
	ДанныеФайла = ПолучитьДвоичныеДанныеИзХранилища();
	АдресФайла = ПоместитьВоВременноеХранилище(ДанныеФайла, УникальныйИдентификатор);
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСтандартнуюОбработкуНаСервере()
	
	Если Объект.ИмяПредопределенныхДанных = "ОповещениеПочта" Тогда
		АдресФайла = ПоместитьВоВременноеХранилище(Справочники.CRM_ДействияТриггеров.ПолучитьМакет("CRM_ТриггерПочтовойРассылки"), УникальныйИдентификатор);
		Объект.НазваниеОбработки = "CRM_ТриггерПочтовойРассылки";
	ИначеЕсли Объект.ИмяПредопределенныхДанных = "ОповещениеСМС" Тогда	
		АдресФайла = ПоместитьВоВременноеХранилище(Справочники.CRM_ДействияТриггеров.ПолучитьМакет("CRM_ТриггерСМСРассылки"), УникальныйИдентификатор);
		Объект.НазваниеОбработки = "CRM_ТриггерСМСРассылки";
	ИначеЕсли Объект.ИмяПредопределенныхДанных = "ОповещениеНапоминание" Тогда	
		АдресФайла = ПоместитьВоВременноеХранилище(Справочники.CRM_ДействияТриггеров.ПолучитьМакет("CRM_ТриггерНапоминание"), УникальныйИдентификатор);
		Объект.НазваниеОбработки = "CRM_ТриггерНапоминание";
	ИначеЕсли Объект.ИмяПредопределенныхДанных = "ЗапретитьРедактированиеДокументаКоммерческоеПредложение" Тогда	
		АдресФайла = ПоместитьВоВременноеХранилище(Справочники.CRM_ДействияТриггеров.ПолучитьМакет("CRM_ЗапретитьРедактированиеКП"), УникальныйИдентификатор);
		Объект.НазваниеОбработки = "CRM_ЗапретитьРедактированиеКП";	
	ИначеЕсли Объект.ИмяПредопределенныхДанных = "РассылкаПоСегменту" Тогда	
		АдресФайла = ПоместитьВоВременноеХранилище(Справочники.CRM_ДействияТриггеров.ПолучитьМакет("CRM_ТриггерРассылкаПоСегменту"), УникальныйИдентификатор);
		Объект.НазваниеОбработки = "CRM_ТриггерРассылкаПоСегменту";		
	ИначеЕсли Объект.ИмяПредопределенныхДанных = "ЗаявкаССайта" Тогда	
		АдресФайла = ПоместитьВоВременноеХранилище(Справочники.CRM_ДействияТриггеров.ПолучитьМакет("CRM_ТриггерЗаявкаССайта"), УникальныйИдентификатор);
		Объект.НазваниеОбработки = "CRM_ТриггерЗаявкаССайта";		
	ИначеЕсли Объект.ИмяПредопределенныхДанных = "ВосстановлениеИнтереса" Тогда	
		АдресФайла = ПоместитьВоВременноеХранилище(Справочники.CRM_ДействияТриггеров.ПолучитьМакет("CRM_ТриггерВосстановлениеИнтереса"), УникальныйИдентификатор);
		Объект.НазваниеОбработки = "CRM_ТриггерВосстановлениеИнтереса";		
	ИначеЕсли Объект.ИмяПредопределенныхДанных = "СозданиеЗаявкиНаОснованииПисьма" Тогда	
		АдресФайла = ПоместитьВоВременноеХранилище(Справочники.CRM_ДействияТриггеров.ПолучитьМакет("CRM_ТриггерЗаявкаПоПисьму"), УникальныйИдентификатор);
		Объект.НазваниеОбработки = "CRM_ТриггерЗаявкаПоПисьму";
	ИначеЕсли Объект.ИмяПредопределенныхДанных = "СтартПроизвольногоБП" Тогда	
		АдресФайла = ПоместитьВоВременноеХранилище(Справочники.CRM_ДействияТриггеров.ПолучитьМакет("CRM_ТриггерЗапускаБизнесПроцесса"), УникальныйИдентификатор);
		Объект.НазваниеОбработки = "CRM_ТриггерЗапускаБизнесПроцесса";	
	ИначеЕсли ЗначениеЗаполнено(Объект.ИмяПредопределенныхДанных) Тогда	
		ИмяМакета = "CRM_Модуль_CRM_Триггер"+Объект.ИмяПредопределенныхДанных;
		Если Метаданные.Справочники.CRM_ДействияТриггеров.Макеты.Найти(ИмяМакета) = Неопределено Тогда
			ИмяМакета = "CRM_Триггер"+Объект.ИмяПредопределенныхДанных;
		КонецЕсли;
		АдресФайла = ПоместитьВоВременноеХранилище(Справочники.CRM_ДействияТриггеров.ПолучитьМакет(ИмяМакета), УникальныйИдентификатор);
		Объект.НазваниеОбработки = "CRM_Триггер"+Объект.ИмяПредопределенныхДанных;	
	КонецЕсли;	
	
	Объект.ИспользуетсяСтандартнаяОбработка = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РежимОтладкиПриИзмененииФрагмент()
	
	УстановитьВидимость();

КонецПроцедуры

#КонецОбласти 




