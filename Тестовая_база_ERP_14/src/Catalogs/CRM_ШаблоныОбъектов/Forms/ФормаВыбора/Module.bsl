
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПоказатьПодсказку = CRM_ХранилищеНастроек.Загрузить(ЭтотОбъект.ИмяФормы, "ПоказыватьПодсказкуШаблоныДокументов");
	Элементы.Описание.Видимость = ?(ПоказатьПодсказку = Неопределено, Истина, ПоказатьПодсказку);
КонецПроцедуры

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОписаниеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	CRM_ХранилищеНастроек.Сохранить(ЭтотОбъект.ИмяФормы, "ПоказыватьПодсказкуШаблоныДокументов", Ложь);
	Элементы.Описание.Видимость = Ложь;
КонецПроцедуры

#КонецОбласти

#КонецОбласти
