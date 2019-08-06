
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;	
	
	СтрокаXML = ПолучитьИзВременногоХранилища(Параметры.АдресВоВременномХранилище);
	Ведомость = ОбщегоНазначения.ЗначениеИзСтрокиXML(СтрокаXML);
	
	Обработка = РеквизитФормыВЗначение("Объект");
	ЗаполнитьЗначенияСвойств(Обработка, Ведомость);
	Обработка.МестоВыплаты = Ведомость.МестоВыплаты().Значение;
	Обработка.Состав.Загрузить(Ведомость.Состав.Выгрузить());
	Обработка.Зарплата.Загрузить(Ведомость.Зарплата.Выгрузить());
	Обработка.НДФЛ.Загрузить(Ведомость.НДФЛ.Выгрузить());
	ЗначениеВРеквизитФормы(Обработка, "Объект");
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой");
	
	ЗначениеВРеквизитФормы(Объект.СпособВыплаты.ПолучитьОбъект(), "СпособВыплаты");
	
	Для Каждого СтрокаСостава Из Объект.Состав Цикл
		ВедомостьНаВыплатуЗарплатыФормыРасширенный.ПриПолученииДанныхСтрокиСостава(ЭтаФорма, СтрокаСостава)
	КонецЦикла;
	
	НастроитьОтображениеГруппыПодписей();

	ТолькоПросмотр = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РуководительПриИзменении(Элемент)
	ПодписантПриИзмененииНаСервере()
КонецПроцедуры

&НаКлиенте
Процедура ГлавныйБухгалтерПриИзменении(Элемент)
	ПодписантПриИзмененииНаСервере()
КонецПроцедуры

&НаКлиенте
Процедура КассирПриИзменении(Элемент)
	ПодписантПриИзмененииНаСервере()
КонецПроцедуры

&НаКлиенте
Процедура БухгалтерПриИзменении(Элемент)
	ПодписантПриИзмененииНаСервере()
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСостав

&НаКлиенте
Процедура СоставВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ВедомостьНаВыплатуЗарплатыКлиент.СоставВыбор(ЭтаФорма, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)	
КонецПроцедуры

&НаКлиенте
Процедура СоставПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СоставПередУдалением(Элемент, Отказ)
	ВедомостьНаВыплатуЗарплатыКлиент.СоставПередУдалением(ЭтаФорма, Элемент, Отказ) 
КонецПроцедуры

&НаКлиенте
Процедура СоставПослеУдаления(Элемент)
	СоставПослеУдаленияНаСервере()
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РедактироватьЗарплату(Команда)
	РедактироватьЗарплатуСтроки(Элементы.Состав.ТекущиеДанные);	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьНДФЛ(Команда)
	РедактироватьНДФЛСтроки(Элементы.Состав.ТекущиеДанные);	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	ЗаписатьНаСервере();
	Закрыть()
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	ЗаписатьНаСервере()
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СоставПослеУдаленияНаСервере()
	ВедомостьНаВыплатуЗарплатыФормы.СоставПослеУдаленияНаСервере(ЭтаФорма)
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьЗарплатуСтроки(ДанныеСтроки) Экспорт
	ВедомостьНаВыплатуЗарплатыКлиент.РедактироватьЗарплатуСтроки(ЭтаФорма, ДанныеСтроки);	
КонецПроцедуры

&НаСервере
Процедура РедактироватьЗарплатуСтрокиЗавершениеНаСервере(РезультатыРедактирования) Экспорт
	ВедомостьНаВыплатуЗарплатыФормы.РедактироватьЗарплатуСтрокиЗавершениеНаСервере(ЭтаФорма, РезультатыРедактирования) 
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьНДФЛСтроки(ДанныеСтроки) Экспорт
	ВедомостьНаВыплатуЗарплатыКлиент.РедактироватьНДФЛСтроки(ЭтаФорма, ДанныеСтроки);	
КонецПроцедуры

&НаСервере
Процедура РедактироватьНДФЛСтрокиЗавершениеНаСервере(РезультатыРедактирования) Экспорт
	ВедомостьНаВыплатуЗарплатыФормы.РедактироватьНДФЛСтрокиЗавершениеНаСервере(ЭтаФорма, РезультатыРедактирования) 
КонецПроцедуры

&НаСервере
Функция АдресВХранилищеЗарплатыПоСтроке(ИдентификаторСтроки) Экспорт
	Возврат ВедомостьНаВыплатуЗарплатыФормы.АдресВХранилищеЗарплатыПоСтроке(ЭтаФорма, ИдентификаторСтроки)
КонецФункции	

&НаСервере
Функция АдресВХранилищеНДФЛПоСтроке(ИдентификаторСтроки) Экспорт
	Возврат ВедомостьНаВыплатуЗарплатыФормы.АдресВХранилищеНДФЛПоСтроке(ЭтаФорма, ИдентификаторСтроки)
КонецФункции	

&НаСервере
Процедура ЗаписатьНаСервере()	
	
	Если Модифицированность Тогда
		
		СтрокаXML = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
		Ведомость = ОбщегоНазначения.ЗначениеИзСтрокиXML(СтрокаXML);
			
		Обработка = РеквизитФормыВЗначение("Объект");
		ЗаполнитьЗначенияСвойств(Ведомость, Обработка);
		Ведомость.Зарплата.Загрузить(Обработка.Зарплата.Выгрузить());
		
		СтрокаXML = ОбщегоНазначения.ЗначениеВСтрокуXML(Ведомость);
		ПоместитьВоВременноеХранилище(СтрокаXML, АдресВоВременномХранилище);
		
		Модифицированность = Ложь;
		
	КонецЕсли
	
КонецПроцедуры	

&НаСервере
Процедура ПодписантПриИзмененииНаСервере()
	ВедомостьНаВыплатуЗарплатыФормы.ПодписантПриИзмененииНаСервере(ЭтаФорма)
КонецПроцедуры

&НаСервере
Процедура НастроитьОтображениеГруппыПодписей()
	ЗарплатаКадры.НастроитьОтображениеГруппыПодписей(Элементы.ПодписиГруппа, "Объект.Руководитель", "Объект.ГлавныйБухгалтер", "Объект.Кассир", "Объект.Бухгалтер");
КонецПроцедуры

#КонецОбласти
