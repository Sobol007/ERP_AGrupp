
#Область ПрограммныйИнтерфейс

// Формирует дерево поиска группы доступа.
//
// Параметры:
//  ИмяМетаданных - Строка - Имя метаданных.
// 
// Возвращаемое значение:
//  ДеревоЗначений - Дерево поиска групп доступа.
//
Функция СформироватьДеревоПоискаГруппыДоступа(ИмяМетаданных) Экспорт 

	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ИмяМетаданных);
	
	ДеревоПоискаГруппДоступа = ДеревоПоискаГруппДоступа();
	
	Если Не CRM_ОбщегоНазначенияПовтИсп.ЭтоCRM() Тогда
	
		Возврат ДеревоПоискаГруппДоступа;
	
	КонецЕсли; 
	
	ЗаполнитьТаблицуПоискаГруппыДоступа(ОбъектМетаданных, ДеревоПоискаГруппДоступа);

	Возврат ДеревоПоискаГруппДоступа;

КонецФункции // СформироватьДеревоГруппДоступа()

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

Функция ДеревоПоискаГруппДоступа()
	
	Дерево = Новый ДеревоЗначений;
	
	ТипСтрока = Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(500));
	
	Дерево.Колонки.Добавить(ИмяКолонкиИмяМетаданных(), ТипСтрока);
	Дерево.Колонки.Добавить(ИмяКолонкиРеквизит(), ТипСтрока);
	Дерево.Колонки.Добавить(ИмяКолонкиТип(), Новый ОписаниеТипов("Тип"));
	Дерево.Колонки.Добавить(ИмяКолонкиСоставнойТип(), Новый ОписаниеТипов("Булево"));
	
	Дерево.Колонки.Добавить("Уровней", Новый ОписаниеТипов("Число"));
	
	Возврат Дерево;

КонецФункции // ДеревоПоискаГруппДоступа()

Процедура ЗаполнитьТаблицуПоискаГруппыДоступа(ОбъектМетаданных, ДеревоПоиска)

	НайтиГруппуДоступаПоОбъектуМетаданных(ОбъектМетаданных, ДеревоПоиска);

КонецПроцедуры

Процедура НайтиГруппуДоступаПоОбъектуМетаданных(ОбъектМетаданных, СтрокаПоиска, ТекущийУровень = 0)

	Если ТекущийУровень <= ЧислоУровнейПоискаГруппыДоступа() Тогда
		
		НайтиГруппуДоступаВРеквизитахОбъекта(ОбъектМетаданных, СтрокаПоиска, ТекущийУровень);
					
	КонецЕсли; 
							
	Если СтрокаПоиска.Строки.Количество() = 0
		 И ОбъектМетаданных.Имя <> "Партнеры" Тогда
	
		УдалитьСтроку(СтрокаПоиска);
		
	КонецЕсли; 						

КонецПроцедуры

Процедура НайтиГруппуДоступаВРеквизитахОбъекта(ОбъектМетаданных, СтрокаПоиска, ТекущийУровень)

	Если Метаданные.Справочники.Содержит(ОбъектМетаданных)
		 Или Метаданные.Документы.Содержит(ОбъектМетаданных)
		 Или Метаданные.Задачи.Содержит(ОбъектМетаданных)
		 Или Метаданные.ПланыВидовХарактеристик.Содержит(ОбъектМетаданных)
		 Или Метаданные.БизнесПроцессы.Содержит(ОбъектМетаданных) Тогда
		 
		 Если ОбъектМетаданных = Метаданные.НайтиПоТипу(Тип("СправочникСсылка.Партнеры")) Тогда
			 
			Если ТекущийУровень = 0 Тогда
			
				ЗаполнитьДанныеУровняПоиска(СтрокаПоиска,
										ТекущийУровень,
										ОбъектМетаданных.ПолноеИмя(),
										"Ссылка",
										Тип("СправочникСсылка.Партнеры"),
										Ложь);
										
			Иначе 
										
				Возврат;
			
			КонецЕсли; 
			
		Иначе 
			
			ПоискУровняДоступаПоРеквизитам(ОбъектМетаданных.СтандартныеРеквизиты, СтрокаПоиска, ТекущийУровень);
			
			Если Метаданные.Задачи.Содержит(ОбъектМетаданных) Тогда
			
				ПоискУровняДоступаПоРеквизитам(ОбъектМетаданных.РеквизитыАдресации, СтрокаПоиска, ТекущийУровень);
			
			КонецЕсли; 
			
			ПоискУровняДоступаПоРеквизитам(ОбъектМетаданных.Реквизиты, СтрокаПоиска, ТекущийУровень);
			
		КонецЕсли;  
		 
	ИначеЕсли Метаданные.РегистрыСведений.Содержит(ОбъектМетаданных) Тогда 
		
		ПоискУровняДоступаПоРеквизитам(ОбъектМетаданных.Ресурсы, СтрокаПоиска, ТекущийУровень);
		ПоискУровняДоступаПоРеквизитам(ОбъектМетаданных.Измерения, СтрокаПоиска, ТекущийУровень);
		ПоискУровняДоступаПоРеквизитам(ОбъектМетаданных.СтандартныеРеквизиты, СтрокаПоиска, ТекущийУровень);
		ПоискУровняДоступаПоРеквизитам(ОбъектМетаданных.Реквизиты, СтрокаПоиска, ТекущийУровень);
		
	ИначеЕсли Метаданные.Константы.Содержит(ОбъектМетаданных) Тогда 
		
		ПоискУровняДоступаПоТипам("Значение",
								ОбъектМетаданных.Тип.Типы(),
								СтрокаПоиска,
								ТекущийУровень);
		
	КонецЕсли;	

КонецПроцедуры
 
Процедура ПоискУровняДоступаПоРеквизитам(Реквизиты, СтрокаПоиска, ТекущийУровень)

	Для Каждого Реквизит Из Реквизиты Цикл 
		
		Если ТипЗнч(Реквизит) = Тип("ОписаниеСтандартногоРеквизита")
			 И (Реквизит.Имя = "Ссылка"
			 Или Реквизит.Имя = "Родитель") Тогда
		
			Продолжить;
		
		КонецЕсли; 
		
		ПоискУровняДоступаПоТипам(Реквизит.Имя,
								  Реквизит.Тип.Типы(),
								  СтрокаПоиска,
								  ТекущийУровень); 
	
	КонецЦикла; 	

КонецПроцедуры

Процедура ПоискУровняДоступаПоТипам(ИмяРеквизита, Типы, СтрокаПоиска, ТекущийУровень)
		
	СоставнойТип = Типы.Количество() > 1;
	
	Для Каждого Тип Из Типы Цикл 
		
		ОбъектМетаданных = Метаданные.НайтиПоТипу(Тип);
		
		Если ОбъектМетаданных = Неопределено Тогда
		
			Продолжить;
		
		КонецЕсли; 
		
		Строка = ЗаполнитьДанныеУровняПоиска(СтрокаПоиска,
											ТекущийУровень,
											ОбъектМетаданных.ПолноеИмя(),
											ИмяРеквизита,
											Тип,
											СоставнойТип);
		
		НайтиГруппуДоступаПоОбъектуМетаданных(ОбъектМетаданных,
											Строка,
											ТекущийУровень + 1);
											
	
	КонецЦикла;  									

КонецПроцедуры

Функция ЗаполнитьДанныеУровняПоиска(СтрокаПоиска, УровеньПоиска, ИмяМетаданных, Реквизит, Тип, СоставнойТип)

	Строка = СтрокаПоиска.Строки.Добавить();
	
	Строка[ИмяКолонкиИмяМетаданных()] = ИмяМетаданных;
	Строка[ИмяКолонкиРеквизит()] = Реквизит;
	Строка[ИмяКолонкиТип()] = Тип;
	Строка[ИмяКолонкиСоставнойТип()] = СоставнойТип;
	
	ЗаполнитьКоличествоУровней(Строка, УровеньПоиска);
	
	Возврат Строка;

КонецФункции

Функция ИмяКолонкиИмяМетаданных()

	Возврат "ИмяМетаданных";
	
КонецФункции // ИмяКолонкиИмяМетаданных()

Функция ИмяКолонкиРеквизит()

	Возврат "Реквизит";

КонецФункции // ИмяКолонкиИмяМетаданных()

Функция ИмяКолонкиТип()

	Возврат "Тип";

КонецФункции // ИмяКолонкиИмяМетаданных()

Функция ИмяКолонкиСоставнойТип()

	Возврат "СоставнойТип";

КонецФункции // ИмяКолонкиИмяМетаданных()
 
Функция ЧислоУровнейПоискаГруппыДоступа()
	
	Возврат 2;

КонецФункции // ЧислоУровнейПоискаГруппыДоступа()

Процедура УдалитьСтроку(СтрокаПоиска)

	Если ТипЗнч(СтрокаПоиска) = Тип("СтрокаДереваЗначений") Тогда
		
		Родитель = СтрокаПоиска.Родитель;
		
		Если Родитель = Неопределено Тогда
		
			Родитель = СтрокаПоиска.Владелец();
		
		КонецЕсли; 
		
		Родитель.Строки.Удалить(СтрокаПоиска);

	КонецЕсли;

КонецПроцедуры
 
Процедура ЗаполнитьКоличествоУровней(СтрокаПоиска, Уровень)

	Если СтрокаПоиска = Неопределено Тогда
	
		Возврат;
	
	КонецЕсли; 
	
	СтрокаПоиска.Уровней = Макс(Уровень, СтрокаПоиска.Уровней);
	
	ЗаполнитьКоличествоУровней(СтрокаПоиска.Родитель, Уровень);

КонецПроцедуры

#КонецОбласти 
