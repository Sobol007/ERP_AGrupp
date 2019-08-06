#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Возвращает текст подсказки по особенностям учета номенклатуры.
//
// Параметры:
//	ОсобенностьУчета - ПеречислениеСсылка.ОсобенностиУчетаНоменклатуры	 - особенность учета номенклатуры.
//
// Возвращаемое значение:
//	Строка - подсказка по особенности учета номенклатуры.
//
Функция ПодсказкаПоОсобенностиУчетаНоменклатуры(ОсобенностьУчета) Экспорт
	
	Если ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.БезОсобенностейУчета Тогда
		Возврат "";
	ИначеЕсли ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.АлкогольнаяПродукция Тогда
		Возврат НСтр("ru = 'Формируются декларации по алкогольной продукции и осуществляется обмен с ЕГАИС информацией по обороту.';
					|en = 'Alcoholic product declarations are generated and turnover information is exchanged with USAIS.'");
	ИначеЕсли ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.ПодконтрольнаяПродукцияВЕТИС Тогда
		Возврат НСтр("ru = 'Осуществляется обмен с ВетИС информацией по обороту продукции животного происхождения.';
					|en = 'Information is exchanged with VetIS on turnover of manufactured products of animal origin.'");
	ИначеЕсли ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.СодержитДрагоценныеМатериалы Тогда
		Возврат НСтр("ru = 'Статистическая отчетность по содержанию драгоценных материалов.';
					|en = 'Statistical reporting on precious material content.'");
	ИначеЕсли ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.ПродукцияМаркируемаяДляГИСМ Тогда
		Возврат НСтр("ru = 'Продукция маркируется специальными контрольными идентификационными знаками (КиЗ) и осуществляется обмен с ГИСМ (информационной системой маркировки товаров) информацией по обороту.';
					|en = 'Goods are marked with special control identification marks (CIM), and turnover information is exchanged with SPMS (State Product Marking System).'");
	ИначеЕсли ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.КиЗГИСМ Тогда
		Возврат НСтр("ru = 'Контрольные идентификационные знаки (КИЗ), которыми маркируется продукция, учитываемая в ГИСМ (информационной системе маркировки товаров).';
					|en = 'The control identification marks (CIM) with which products recorded in the SPMS (State Goods Marking System) are marked.'");
	ИначеЕсли ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.ОрганизациейПродавцом Тогда
		Возврат НСтр("ru = 'Услуга выполняется собственной организацией, продается ей же.';
					|en = 'Service is provided by own company, the service is sold by it.'");
	ИначеЕсли ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.ОрганизациейПоАгентскойСхеме Тогда
		Возврат НСтр("ru = 'Услуга выполняется собственной организацией (принципалом), продается по агентскому договору.';
					|en = 'Service is provided by own company (principal), the service is sold under an agency agreement. '");
	ИначеЕсли ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.Партнером Тогда
		Возврат НСтр("ru = 'Услуга выполняется сторонним исполнителем (принципалом), продается по агентскому договору.';
					|en = 'Service is provided by an external assignee (principal), the service is sold under an agency agreement.'");
	ИначеЕсли ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.ТабачнаяПродукция Тогда
		Возврат НСтр("ru = 'Осуществляется обмен с ИС МОТП информацией по обороту табачной продукции.';
					|en = 'Information is exchanged on the turnover of tobacco products with IS MTPT.'");
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли

