
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Параметры.Свойство("ВидПоказателей", ВидПоказателей) Тогда
		ТекстСообщения = НСтр("ru = 'Непосредственное открытие этой формы не предусмотрено. Открытие данной формы выполняется при начале выбора вида ячейки в форме ""Настройка ячеек вида отчета"" справочника ""Элементы финансовых отчетов"".';
								|en = 'Cannot open this form directly. Open the form when you start to select a cell kind in the ""Set up report kind cells"" form of the ""Financial report items"" catalog.'");
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	ОбновитьДеревоНовыхЭлементов();

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура БыстрыйПоискНовыхПриИзменении(Элемент)
	
	ОбновитьДеревоНовыхЭлементов();
	Для Каждого Строка Из ДеревоНовыхЭлементов.ПолучитьЭлементы() Цикл
		Элементы.ДеревоНовыхЭлементов.Свернуть(Строка.ПолучитьИдентификатор());
		Элементы.ДеревоНовыхЭлементов.Развернуть(Строка.ПолучитьИдентификатор(), Ложь);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыДеревоНовыхЭлементов

&НаКлиенте
Процедура ДеревоНовыхЭлементовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбработкаВыбораЭлементаОтчета();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыДеревоСохраненныхЭлементов

&НаКлиенте
Процедура ДеревоСохраненныхЭлементовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбработкаВыбораЭлементаОтчета();
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиСохраненныйЭлемент(Команда)
	
	ОбновитьДеревоСохраненныхЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура БыстрыйПоискСохраненныхПриИзменении(Элемент)

	ОбновитьДеревоСохраненныхЭлементов();

КонецПроцедуры

&НаКлиенте
Процедура ФильтрПоВидуОтчетаПриИзменении(Элемент)
	
	ОбновитьДеревоСохраненныхЭлементов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НайтиНовыйЭлемент(Команда)
	
	ОбновитьДеревоНовыхЭлементов();
	Для Каждого Строка Из ДеревоНовыхЭлементов.ПолучитьЭлементы() Цикл
		Элементы.ДеревоНовыхЭлементов.Свернуть(Строка.ПолучитьИдентификатор());
		Элементы.ДеревоНовыхЭлементов.Развернуть(Строка.ПолучитьИдентификатор(), Ложь);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	ОбработкаВыбораЭлементаОтчета();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаВыбораЭлементаОтчета()
	
	ТекущиеДанные = ТекущийЭлемент.ТекущиеДанные;
	Если Не ЗначениеЗаполнено(ТекущиеДанные.ВидЭлемента)
			ИЛИ ТекущиеДанные.ЭтоГруппа Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Элемент не может быть выбран!';
													|en = 'Item cannot be selected.'"));
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура("ЭлементОтчета,ВидЭлемента,НаименованиеДляПечати");
	Результат.ВидЭлемента = ТекущиеДанные.ВидЭлемента;
	Результат.НаименованиеДляПечати = ТекущиеДанные.НаименованиеДляПечати;
	Если ТекущиеДанные.Свойство("ЭтоСвязанный") Тогда
		Результат.Вставить("СвязанныйЭлемент", ТекущиеДанные.СвязанныйЭлемент);
		Результат.Вставить("ЭтоСвязанный", Истина);
	Иначе
		Результат.Вставить("ЭлементОтчета", ТекущиеДанные.ЭлементВидаОтчетности);
		Результат.Вставить("ЭтоСвязанный", Ложь);
	КонецЕсли;
	Закрыть(Результат);
	
КонецПроцедуры

&НаСервере 
Процедура ОбновитьДеревоНовыхЭлементов()
	
	//++ НЕ УТКА
	ПараметрыДерева = МеждународнаяОтчетностьКлиентСервер.НовыеПараметрыДереваЭлементов();
	ПараметрыДерева.ВидПоказателей = ВидПоказателей;
	ПараметрыДерева.РежимРаботы = Перечисления.РежимыОтображенияДереваНовыхЭлементов.НастройкаВидаОтчетаТолькоПоказатели;
	ПараметрыДерева.БыстрыйПоиск = БыстрыйПоискНовых;
	
	МеждународнаяОтчетностьСервер.ОбновитьДеревоНовыхЭлементов(ЭтаФорма, ПараметрыДерева);
	//-- НЕ УТКА
	Возврат;// в УТ11 обработчик пустой

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДеревоСохраненныхЭлементов()

	ОбновитьДеревоСохраненныхЭлементовНаСервере();
	//++ НЕ УТКА
	Если ЗначениеЗаполнено(ФильтрПоВидуОтчета) Тогда
		МеждународнаяОтчетностьКлиент.РазвернутьДеревоСохраненныхЭлементов(ЭтаФорма, ДеревоСохраненныхЭлементов);
	КонецЕсли;
	//-- НЕ УТКА

КонецПроцедуры

&НаСервере 
Процедура ОбновитьДеревоСохраненныхЭлементовНаСервере()
	
	Если НЕ ЗначениеЗаполнено(БыстрыйПоискСохраненных)
		И НЕ ЗначениеЗаполнено(ФильтрПоВидуОтчета) Тогда
		СохраненныеЭлементы = ДеревоСохраненныхЭлементов.ПолучитьЭлементы();
		СохраненныеЭлементы.Очистить();
		Возврат;
	КонецЕсли;
	//++ НЕ УТКА
	ПараметрыДерева = МеждународнаяОтчетностьКлиентСервер.НовыеПараметрыДереваЭлементов();
	ПараметрыДерева.ИмяЭлементаДерева = "ДеревоСохраненныхЭлементов";
	ПараметрыДерева.РежимРаботы = Перечисления.РежимыОтображенияДереваНовыхЭлементов.НастройкаВидаОтчетаТолькоПоказатели;
	ПараметрыДерева.ФильтрПоВидуОтчета = ФильтрПоВидуОтчета;
	ПараметрыДерева.БыстрыйПоиск = БыстрыйПоискСохраненных;
	ПараметрыДерева.ВидПоказателей = ВидПоказателей;
	
	МеждународнаяОтчетностьСервер.ОбновитьДеревоСохраненныхЭлементов(ЭтаФорма, ПараметрыДерева);
	//-- НЕ УТКА

КонецПроцедуры

#КонецОбласти
