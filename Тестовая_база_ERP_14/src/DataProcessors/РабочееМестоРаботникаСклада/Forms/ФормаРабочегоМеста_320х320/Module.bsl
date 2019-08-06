
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Автотест") Тогда
		Возврат;
	КонецЕсли;
	
	РазрешениеЭкрана = Перечисления.РазрешенияЭкрана.Разрешение320х320;
	
	РабочееМестоРаботникаСкладаСервер.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ИнтерфейсВерсии82 Тогда
		
		Оповещение = Новый ОписаниеОповещения("ЗапускРабочегоМестаРаботникаСкладаНеВТаксиЗавершение", ЭтаФорма);
		
		ОткрытьФорму("Обработка.РабочееМестоРаботникаСклада.Форма.ПеревестиВИнтерфейс8_2",
			,
			ЭтаФорма
			,,,,
			Оповещение, 
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
		Возврат;
		
	КонецЕсли;
	
	// МеханизмВнешнегоОборудования
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(
		Новый ОписаниеОповещения("НачатьПодключениеОборудованиеПриОткрытииФормыЗавершение", ЭтотОбъект),
		ЭтотОбъект,
		"СканерШтрихкода");
	// Конец МеханизмВнешнегоОборудования
	
	ПодключитьОбработчикОжидания("Подключаемый_ОбновитьСписокЗаданийОбработчикОжидания", 60);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" Тогда
		
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			
			// Преобразуем предварительно к ожидаемому формату
			Если Параметр[1] = Неопределено Тогда
				Штрихкод = Параметр[0];
			Иначе
				Штрихкод = Параметр[1][1];
			КонецЕсли;
			
			Если ПараметрыРежима.Режим = "ЗапросИнформации" Тогда
				
				ВывестиИнформациюПоШтрихкодуНаСервере(Штрихкод);
				
			ИначеЕсли ПараметрыРежима.Режим = "Сканирование" Тогда
				
				ПриСканированииЗначенияНаСервере(Штрихкод);
				
				#Если НЕ ВебКлиент Тогда
				Если ЗначениеЗаполнено(СообщениеОбОшибке) Тогда
					Сигнал();
				КонецЕсли;
				#КонецЕсли
				
			ИначеЕсли ПараметрыРежима.Режим = "ВыборЗадания"
				Или ПараметрыРежима.Режим = "ВыборОперации" Тогда
				
				ПриСканированииШтрихкодаЗаданияНаСервере(Штрихкод);
				
			Иначе
				
				// Данный режим не предназначен для сканирования.
				#Если НЕ ВебКлиент Тогда
				Сигнал();
				#КонецЕсли
				
			КонецЕсли;
			
			ПодключитьОбработчикОжидания("Подключаемый_ВывестиСостояниеВыполненияЗаданияОбработчикОжидания", 5, Истина);
			
		КонецЕсли;
		
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		РабочееМестоРаботникаСкладаКлиент.ПередЗакрытием(ЭтаФорма, Отказ, ТекстПредупреждения, СтандартнаяОбработка);
		Возврат;
	КонецЕсли;
	
	ПередЗакрытиемНаСервере(Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	РабочееМестоРаботникаСкладаКлиент.ПриЗакрытии(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗадания

&НаКлиенте
Процедура СписокЗаданийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СписокЗаданийВыборНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗоныприемкиотгрузки

&НаКлиенте
Процедура ЗоныПриемкиРазмещенияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗоныПриемкиРазмещенияПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗоныПриемкиРазмещенияПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗоныПриемкиРазмещенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПриВыбореЗоныПриемкиРазмещенияНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОсновноеМенюОбновить(Команда)
	
	ОсновноеМенюОбновитьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаданияВыбрать(Команда)
	
	ЗаданияВыбратьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СканированиеВвестиКоличество(Команда)
	
	СканированиеВвестиКоличествоНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ВводКоличестваОК(Команда)
	
	РабочееМестоРаботникаСкладаКлиент.ВводКоличестваОК(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВводКоличестваОтмена(Команда)
	
	ВводКоличестваОтменаНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновноеМенюИнформация(Команда)
	
	ОсновноеМенюИнформацияНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаданияПерейтиВОсновноеМеню(Команда)
	
	ЗаданияПерейтиВОсновноеМенюНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаданияПоказатьВсе(Команда)
	
	ЗаданияПоказатьВсеНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ИнформацияЗакрыть(Команда)
	
	ИнформацияЗакрытьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновноеМенюОтбор(Команда)
	
	ОсновноеМенюОтборНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновноеМенюПриемка(Команда)
	
	ОсновноеМенюПриемкаНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновноеМенюПроверкаОтбора(Команда)
	
	ОсновноеМенюПроверкаОтбораНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновноеМенюРазмещение(Команда)
	
	ОсновноеМенюРазмещениеНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновноеМенюПеремещение(Команда)
	
	ОсновноеМенюПеремещениеНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновноеМенюПересчет(Команда)
	
	ОсновноеМенюПересчетНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновноеМенюОтметитьЯчейкуКПересчету(Команда)
	
	ОсновноеМенюОтметитьЯчейкуКПересчетуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновноеМенюЗакрыть(Команда)
	
	ОсновноеМенюЗакрытьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СканированиеИнформация(Команда)
	
	СканированиеИнформацияНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СканированиеЯчейка(Команда)
	
	РабочееМестоРаботникаСкладаКлиент.СканированиеЯчейка(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СканированиеСерия(Команда)
	
	ТекстСообщенияПользователю = "";
	
КонецПроцедуры

&НаКлиенте
Процедура СканированиеТовар(Команда)
	
	СканированиеТоварНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНовоеСкладскоеЗадание(Команда)
	
	СоздатьНовоеСкладскоеЗаданиеНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СканированиеДействия(Команда)
	
	СканированиеДействияНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СканированиеДалее(Команда)
	
	СканированиеДалееНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФормуМобильногоРабочегоМеста(Команда)
	
	РабочееМестоРаботникаСкладаКлиент.ЗакрытьФормуМобильногоРабочегоМеста(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НеЗакрыватьФормуМобильногоРабочегоМеста(Команда)
	
	НеЗакрыватьФормуМобильногоРабочегоМестаНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВыполнениеЗадания(Команда)
	
	ОтменитьВыполнениеЗаданияНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьВыполнениеЗадания(Команда)
	
	ЗавершитьВыполнениеЗаданияНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКРазмещениюТоваров(Команда)
	
	ПерейтиКРазмещениюТоваровНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКСледующемуТоваруСканирования(Команда)
	
	ПерейтиКСледующейСтрокеСканированияНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКСледующейЯчейкеСканирования(Команда)
	
	ПерейтиКСледующейЯчейкеСканированияНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьТоварыИзДругихЯчеекПриПереходеКСледующейЯчейке(Команда)
	
	ПодобратьТоварыИзДругихЯчеекПриПереходеКСледующейЯчейкеНаСервере();
	ПодключитьОбработчикОжидания("Подключаемый_ВывестиСостояниеВыполненияЗаданияОбработчикОжидания", 5, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПодборТоваровИзДругихЯчеекПриПереходеКСледующейЯчейке(Команда)
	
	ОтменитьПодборТоваровИзДругихЯчеекПриПереходеКСледующейЯчейкеНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьТоварыИзДругихЯчеек(Команда)
	
	ПодобратьТоварыИзДругихЯчеекНаСервере();
	ПодключитьОбработчикОжидания("Подключаемый_ВывестиСостояниеВыполненияЗаданияОбработчикОжидания", 5, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПодборТоваровИзДругихЯчеек(Команда)
	
	ОтменитьПодборТоваровИзДругихЯчеекНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобратьТовары(Команда)
	
	ДобратьТоварыНаСервере();
	ПодключитьОбработчикОжидания("Подключаемый_ВывестиСостояниеВыполненияЗаданияОбработчикОжидания", 5, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СканированиеВвестиЗначение(Команда)
	
	СканированиеВвестиЗначениеНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборЗначенияОК(Команда)
	
	РабочееМестоРаботникаСкладаКлиент.ВыборЗначенияОК(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборЗначенияОтмена(Команда)
	
	ВыборЗначенияОтменаНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКСканированию(Команда)
	
	ПерейтиКСканированиюНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКПриемкеТоваров(Команда)
	
	ПерейтиКПриемкеТоваровНаСервере()
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаПредыдущуюСтраницу(Команда)
	
	ПерейтиНаПредыдущуюСтраницуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ВернутьсяКВыполнениюЗадания(Команда)
	
	ВернутьсяКВыполнениюЗаданияНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКВыборуЗаданияНаОтбор(Команда)
	
	ПерейтиКВыборуЗаданияНаОтборНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКВыборуЗаданияНаРазмещение(Команда)
	
	ПерейтиКВыборуЗаданияНаРазмещениеНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКВыборуЗаданияНаПеремещение(Команда)
	
	ПерейтиКВыборуЗаданияНаПеремещениеНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКВыборуЗаданияНаПересчет(Команда)
	
	ПерейтиКВыборуЗаданияНаПересчетНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКВыборуЗоныПриемки(Команда)
	
	ПерейтиКВыборуЗоныПриемкиНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаданияОбновить(Команда)
	
	ЗаданияОбновитьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьЗонуПриемкиРазмещения(Команда)
	
	ПриВыбореЗоныПриемкиРазмещенияНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВыборЗоныПриемкиРазмещения(Команда)
	
	ОтменитьВыборЗоныПриемкиРазмещенияНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПрерватьВыполнениеЗадания(Команда)
	
	ОтменитьВыполнениеЗаданияНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СканированиеНазначение(Команда)
	
	СканированиеНазначениеНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура НазначенияВыбрать(Команда)
	НазначенияВыбратьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура НазначенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	НазначенияВыбратьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура НазначенияВернуться(Команда)
	НазначенияВернутьсяНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКВыборуСкладскойОперации(Команда)
	
	ПерейтиКВыборуСкладскойОперацииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СканированиеНеОтгружать(Команда)
	
	СканированиеНеОтгружатьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СервисРежимСканированияСерийТСТ(Команда)
	
	СервисРежимСканированияСерийТСТНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СервисРежимСканированияСерийТВТ(Команда)
	
	СервисРежимСканированияСерийТВТНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СканированиеСервис(Команда)
	
	СканированиеСервисНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СканированиеОтметитьЯчейкуКПересчету(Команда)
	
	СканированиеОтметитьЯчейкуКПересчетуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СервисПродолжитьСканирование(Команда)
	
	СервисПродолжитьСканированиеНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СервисПорядокОбработкиЯчейкаТовар(Команда)
	
	СервисПорядокОбработкиЯчейкаТоварНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СервисПорядокОбработкиТоварЯчейка(Команда)
	
	СервисПорядокОбработкиТоварЯчейкаНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Подключаемые

&НаКлиенте
Процедура Подключаемый_ВводКоличестваОКОбработчикОжидания()
	
	ВводКоличестваОКОбработчикОжиданияНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыборЗначенияОКОбработчикОжидания()
	
	ВыборЗначенияОКОбработчикОжиданиянаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыборАдресаОКОбработчикОжидания()
	
	ВыборАдресаОКОбработчикОжиданияНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьСписокЗаданийОбработчикОжидания()
	
	Если РабочееМестоРаботникаСкладаКлиент.НужноОбновитьСписокЗаданий(ЭтаФорма) Тогда
		ОбновитьСписокЗаданийОбработчикОжиданияНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВывестиСостояниеВыполненияЗаданияОбработчикОжидания()
	
	Если РабочееМестоРаботникаСкладаКлиент.НужноОбновитьСостояниеВыполненияЗадания(ЭтаФорма) Тогда
		ВывестиСостояниеВыполненияЗаданияОбработчикОжиданияНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочие

&НаКлиенте
Процедура ВводКоличестваКоличествоПриИзменении(Элемент)
	
	РабочееМестоРаботникаСкладаКлиент.ВводКоличестваКоличествоПриИзменении(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВводКоличестваВесПриИзменении(Элемент)
	
	РабочееМестоРаботникаСкладаКлиент.ВводКоличестваВесПриИзменении(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВводКоличестваОбъемПриИзменении(Элемент)
	
	РабочееМестоРаботникаСкладаКлиент.ВводКоличестваОбъемПриИзменении(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ШтрихкодПараметраСканированияПриИзменении(Элемент)
	
	РабочееМестоРаботникаСкладаКлиент.ШтрихкодПараметраСканированияПриИзменении(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресЯчейкиПриИзменении(Элемент)
	
	РабочееМестоРаботникаСкладаКлиент.АдресЯчейкиПриИзменении(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокГодностиСерииПриИзменении(Элемент)
	
	РабочееМестоРаботникаСкладаКлиент.СрокГодностиСерииПриИзменении(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОсновноеМенюОбновитьНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ОбновитьОсновноеМеню(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура СоздатьНовоеСкладскоеЗаданиеНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.СоздатьНовоеСкладскоеЗадание(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьВыполнениеЗаданияНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ОтменитьВыполнениеЗадания(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ЗавершитьВыполнениеЗаданияНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ЗавершитьВыполнениеЗадания(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПерейтиКРазмещениюТоваровНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ПриЗавершенииСканированияТекущегоЗадания(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПерейтиКСледующейСтрокеСканированияНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ПерейтиКСледующемуТоваруСканирования(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПерейтиКСледующейЯчейкеСканированияНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ПерейтиКСледующейЯчейкеСканирования(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура СканированиеВвестиЗначениеНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.СканированиеВвестиЗначение(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПерейтиКСканированиюНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ПерейтиКСканированию(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПерейтиКПриемкеТоваровНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ПерейтиКПриемкеТоваров(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОсновноеМенюОтборНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ПерейтиКВыборуЗадания(ЭтаФорма, "Отбор");
	
КонецПроцедуры

&НаСервере
Процедура ЗаданияОбновитьНаСервере()
	
	ТипЗадания = ЭтаФорма.ПараметрыРежима.ТипЗадания;
	
	РабочееМестоРаботникаСкладаСервер.ПерейтиКВыборуЗадания(ЭтаФорма, ТипЗадания);
	
КонецПроцедуры

&НаСервере
Процедура ОсновноеМенюЗакрытьНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ОсновноеМенюЗакрыть(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ЗаданияПерейтиВОсновноеМенюНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ПерейтиКВыборуСкладскойОперации(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура СканированиеДалееНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.СканированиеДалее(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОсновноеМенюИнформацияНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ПерейтиКПолучениюИнформации(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОсновноеМенюОтметитьЯчейкуКПересчетуНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ПерейтиКОтметкеЯчейкиКПересчету(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура СканированиеИнформацияНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ПерейтиКПолучениюИнформации(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокЗаданийОбработчикОжиданияНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ОбновитьСписокЗаданийОбработчикОжидания(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура НеЗакрыватьФормуМобильногоРабочегоМестаНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.НеЗакрыватьФормуМобильногоРабочегоМеста(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ИнформацияЗакрытьНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ИнформацияЗакрыть(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗакрытиемНаСервере(Отказ, СтандартнаяОбработка)
	
	РабочееМестоРаботникаСкладаСервер.ПередЗакрытием(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ЗаданияПоказатьВсеНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ОтобразитьВсеТолькоСвоиСкладскиеЗадания(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ЗаданияВыбратьНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ПриВыбореЗадания(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура СканированиеДействияНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.СканированиеДействия(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ВыборЗначенияОтменаНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ВыборЗначенияОтмена(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ВернутьсяКВыполнениюЗаданияНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ВернутьсяКВыполнениюЗадания(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура СканированиеТоварНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ВывестиИнформациюПоТекущемуТовару(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ВыборЗначенияОКОбработчикОжиданиянаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ВыборЗначенияОКОбработчикОжидания(ЭтаФорма);
	
	ШтрихкодПараметраСканирования = "";
	СрокГодностиСерии = "";
	
КонецПроцедуры

&НаСервере
Процедура ВыборАдресаОКОбработчикОжиданияНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ВыборАдресаОКОбработчикОжидания(ЭтаФорма);
	
	ШтрихкодПараметраСканирования = "";
	
КонецПроцедуры

&НаСервере
Процедура ВывестиСостояниеВыполненияЗаданияОбработчикОжиданияНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ВывестиСостояниеВыполненияЗадания(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОсновноеМенюРазмещениеНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ПерейтиКВыборуЗадания(ЭтаФорма, "Размещение");
	
КонецПроцедуры

&НаСервере
Процедура ОсновноеМенюПеремещениеНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ПерейтиКВыборуЗадания(ЭтаФорма, "Перемещение");
	
КонецПроцедуры

&НаСервере
Процедура ОсновноеМенюПроверкаОтбораНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ПерейтиКВыборуЗадания(ЭтаФорма, "ПроверкаОтбора");
	
КонецПроцедуры

&НаСервере
Процедура ОсновноеМенюПересчетНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ПерейтиКВыборуЗадания(ЭтаФорма, "Пересчет");
	
КонецПроцедуры

&НаСервере
Процедура ОсновноеМенюПриемкаНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ПерейтиКВыборуЗадания(ЭтаФорма, "Приемка");
	
КонецПроцедуры

&НаСервере
Процедура ПриВыбореЗоныПриемкиРазмещенияНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ПриВыбореЗоныПриемкиОтгрузки(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура СписокЗаданийВыборНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ПриВыбореЗадания(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура СканированиеВвестиКоличествоНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.СканированиеВвестиКоличество(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ВводКоличестваОКОбработчикОжиданияНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ВводКоличестваОКОбработчикОжидания(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ВводКоличестваОтменаНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ВводКоличестваОтмена(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПерейтиКВыборуСкладскойОперацииНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ПерейтиКВыборуСкладскойОперации(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура СканированиеНеОтгружатьНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.СканированиеНеОтгружать(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПерейтиНаПредыдущуюСтраницуНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ПерейтиНаПредыдущуюСтраницу(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура СканированиеСервисНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.СканированиеСервис(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура СканированиеОтметитьЯчейкуКПересчетуНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ПерейтиКОтметкеЯчейкиКПересчету(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура СервисПродолжитьСканированиеНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.СервисПродолжитьСканирование(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура СервисРежимСканированияСерийТСТНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.СервисРежимСканированияСерийТСТ(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура СервисРежимСканированияСерийТВТНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.СервисРежимСканированияСерийТВТ(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура СервисПорядокОбработкиТоварЯчейкаНаСервере();
	
	РабочееМестоРаботникаСкладаСервер.ПриУстановкеПорядкаОбработкиТоварЯчейка(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура СервисПорядокОбработкиЯчейкаТоварНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ПриУстановкеПорядкаОбработкиЯчейкаТовар(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьВыборЗоныПриемкиРазмещенияНаСервере()

	РабочееМестоРаботникаСкладаСервер.ВернутьсяКВыполнениюЗадания(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ВывестиИнформациюПоШтрихкодуНаСервере(Штрихкод)
	
	РабочееМестоРаботникаСкладаСервер.ВывестиИнформациюПоШтрихкоду(ЭтаФорма, Штрихкод);
	
КонецПроцедуры

&НаСервере
Процедура ПриСканированииЗначенияНаСервере(Штрихкод)
	
	РабочееМестоРаботникаСкладаСервер.ПриСканированииЗначения(ЭтаФорма, Штрихкод, , Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПриСканированииШтрихкодаЗаданияНаСервере(Штрихкод)
	
	РабочееМестоРаботникаСкладаСервер.ПриСканированииШтрихкодаЗадания(ЭтаФорма, Штрихкод);
	
КонецПроцедуры

&НаСервере
Процедура ПерейтиКВыборуЗаданияНаРазмещениеНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ПерейтиКВыборуЗадания(ЭтаФорма, "Размещение");
	
КонецПроцедуры

&НаСервере
Процедура ПерейтиКВыборуЗаданияНаПеремещениеНаСервере()

	РабочееМестоРаботникаСкладаСервер.ПерейтиКВыборуЗадания(ЭтаФорма, "Перемещение");

КонецПроцедуры

&НаСервере
Процедура ПерейтиКВыборуЗаданияНаПересчетНаСервере()

	РабочееМестоРаботникаСкладаСервер.ПерейтиКВыборуЗадания(ЭтаФорма, "Пересчет");

КонецПроцедуры

&НаСервере
Процедура ПерейтиКВыборуЗаданияНаОтборНаСервере()

	РабочееМестоРаботникаСкладаСервер.ПерейтиКВыборуЗадания(ЭтаФорма, "Отбор");

КонецПроцедуры

&НаСервере
Процедура ПерейтиКВыборуЗоныПриемкиНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ПерейтиКВыборуЗоныПриемкиОтгрузки(ЭтаФорма, "ЗонаПриемки");
	
КонецПроцедуры

&НаСервере
Процедура ПриОшибкеПодключенияОборудованияНаСервере(ОписаниеОшибки)
	
	РабочееМестоРаботникаСкладаСервер.ПриОшибкеПодключенияОборудования(ЭтаФорма, ОписаниеОшибки);
	
КонецПроцедуры

&НаСервере
Процедура СканированиеНазначениеНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ПерейтиКВыборуНазначения(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура НазначенияВыбратьНаСервере()
	РабочееМестоРаботникаСкладаСервер.ПриВыбореНазначения(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура НазначенияВернутьсяНаСервере()
	РабочееМестоРаботникаСкладаСервер.ВернутьсяКВыполнениюЗадания(ЭтаФорма)
КонецПроцедуры

&НаСервере
Процедура ПодобратьТоварыИзДругихЯчеекПриПереходеКСледующейячейкеНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ПодобратьТоварыИзДругихЯчеекПриПереходеКСледующейЯчейке(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьПодборТоваровИзДругихЯчеекПриПереходеКСледующейЯчейкеНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ОтменитьПодборТоваровИзДругихЯчеекПриПереходеКСледующейЯчейке(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПодобратьТоварыИзДругихЯчеекНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ПодобратьТоварыИзДругихЯчеек(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьПодборТоваровИзДругихЯчеекНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ОтменитьПодборТоваровИзДругихЯчеек(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ДобратьТоварыНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.ДобратьТовары(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапускРабочегоМестаРаботникаСкладаНеВТаксиЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ = КодВозвратаДиалога.ОК Тогда
		
		ЗапускРабочегоМестаРаботникаСкладаНеВТаксиЗавершениеНаСервере();
		ЗавершитьРаботуСистемы(Ложь, Истина);
		
	Иначе
		
		ЗавершитьРаботуСистемы(Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗапускРабочегоМестаРаботникаСкладаНеВТаксиЗавершениеНаСервере()
	
	РабочееМестоРаботникаСкладаСервер.УстановитьВариантИнтерфейсаКлиентскогоПриложенияВерсии8_2(
		ПользователиИнформационнойБазы.ТекущийПользователь().Имя);
		
КонецПроцедуры

&НаКлиенте
Процедура НачатьПодключениеОборудованиеПриОткрытииФормыЗавершение(РезультатВыполнения, ДополнительныеПараметры) Экспорт

	Если НЕ РезультатВыполнения.Результат Тогда
		
		ПриОшибкеПодключенияОборудованияНаСервере(РезультатВыполнения.ОписаниеОшибки);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
