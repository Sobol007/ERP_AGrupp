#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
	
// Получает параметры формы для отрытия записи регистра.
//
//	Параметры:
//		Организация - СправочникСсылка.Организации - Организация, для которой открывается форма записи регистра;
//		Контрагент - СправочникСсылка.Контрагенты, СправочникСсылка.Организации - контрагент, для которого открывается форма записи регистра;
//		Период - Дата - дата, на которую открывается форма записи регистра.
//
//	Возвращаемое значение:
//		Структура - структура с ключами:
//			* Ключ - РегистрСведенийКлючЗаписи.ДанныеПоКонтрагентамКонтролируемыхСделок - ключ записи регистра в базе данных по переданным параметрам;
//			* ЗначенияЗаполнения - Структура - структура начальных значений заполнения новой записи контрагента:
//				** Организация - СправочникСсылка.Организации - организация, переданная в качестве параметра;
//				** Контрагент - СправочникСсылка.Контрагенты, СправочникСсылка.Организации - контрагент, переданный в качестве параметра;
//				** Период - Дата - дата, переданная в качестве параметра;
//			* ДоступностьКлючевыхЗаписей - Булево - задает значение Ложь, чтобы в открывшейся форме нельзя было редактировать поля Контрагент и Период.
//
Функция ПолучитьПараметрыОткрытияФормыЗаписиВзаимозависимогоЛица(Организация, Контрагент, Период) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Контрагент)
		ИЛИ НЕ ЗначениеЗаполнено(Период)
		ИЛИ НЕ ЗначениеЗаполнено(Организация) Тогда
		Возврат(Неопределено);
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	                      |	ВзаимозависимыеЛица.Период КАК Период,
	                      |	ВзаимозависимыеЛица.Организация,
	                      |	ВзаимозависимыеЛица.Контрагент,
	                      |	ВзаимозависимыеЛица.ТипВзаимозависимости
	                      |ИЗ
	                      |	РегистрСведений.ВзаимозависимыеЛица КАК ВзаимозависимыеЛица
	                      |ГДЕ
	                      |	ВзаимозависимыеЛица.Организация = &Организация
	                      |	И ВзаимозависимыеЛица.Контрагент = &Контрагент
	                      |	И ВзаимозависимыеЛица.Период <= &Период
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Период УБЫВ");
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Период", Период);
	ВыборкаЗаписей = Запрос.Выполнить().Выбрать();
	
	Если ВыборкаЗаписей.Следующий() Тогда
		СвойстваКлючаЗаписи = Новый Структура("Организация, Контрагент, Период", Организация, Контрагент, ВыборкаЗаписей.Период);
		ПараметрыФормы = Новый Структура("Ключ", РегистрыСведений.ВзаимозависимыеЛица.СоздатьКлючЗаписи(СвойстваКлючаЗаписи));
	Иначе
		СвойстваЗаполнения = Новый Структура("Организация, Контрагент, Период", Организация, Контрагент, Период);
		ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", СвойстваЗаполнения);
	КонецЕсли;
	
	ПараметрыФормы.Вставить("ДоступностьКлючевыхЗаписей",Ложь);
	
	Возврат(ПараметрыФормы);

КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли