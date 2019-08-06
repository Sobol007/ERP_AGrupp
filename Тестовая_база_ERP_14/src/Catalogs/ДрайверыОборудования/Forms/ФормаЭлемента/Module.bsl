
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	 
	Если Параметры.Свойство("ПолноеИмяФайла") Тогда
		ИмяФайлДрайвераДляЗагрузки = Параметры.ПолноеИмяФайла;
	КонецЕсли;
	
	РевизияИнтерфейса = 0;
	ДополнительнаяИнформация = "";
	ПоставляемыйВСоставеКонфигурации = Объект.Предопределенный;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.ПоставляетсяДистрибутивом = Истина;
	КонецЕсли;
	
	Если НЕ ПоставляемыйВСоставеКонфигурации И НЕ ПустаяСтрока(Объект.ИмяФайлаДрайвера) Тогда
		СсылкаНаДрайвер = ПолучитьНавигационнуюСсылку(Объект.Ссылка, "ЗагруженныйДрайвер");
		ИмяФайлДрайвераНаФорме = Объект.ИмяФайлаДрайвера;
	КонецЕсли;
	
	Элементы.ИмяФайлаДрайвера.Видимость = НЕ ПоставляемыйВСоставеКонфигурации;
	Элементы.ИмяМакетаДрайвера.Видимость = ПоставляемыйВСоставеКонфигурации;
	Элементы.ТипОборудования.ТолькоПросмотр = ПоставляемыйВСоставеКонфигурации;
	Элементы.Наименование.ТолькоПросмотр = ПоставляемыйВСоставеКонфигурации;
	Элементы.ИдентификаторОбъекта.ТолькоПросмотр = ПоставляемыйВСоставеКонфигурации;
	Элементы.ИдентификаторОбъекта.ПодсказкаВвода = ?(ПоставляемыйВСоставеКонфигурации, НСтр("ru = '<Не указан>';
																							|en = '<Not specified>'"), 
		НСтр("ru = '<ProgID компоненты не введен>';
			|en = '<component ProgID is not entered>'"));
	Элементы.ИмяМакетаДрайвера.ПодсказкаВвода = ?(ПоставляемыйВСоставеКонфигурации, НСтр("ru = '<Не указан>';
																						|en = '<Not specified>'"), "");
	
	Элементы.Сохранить.Видимость = НЕ ПоставляемыйВСоставеКонфигурации;
	Элементы.ЗаписатьИЗакрыть.Видимость = НЕ ПоставляемыйВСоставеКонфигурации;
	Элементы.ФормаЗакрыть.Видимость =ПоставляемыйВСоставеКонфигурации;
	Элементы.ФормаЗакрыть.КнопкаПоУмолчанию = Элементы.ФормаЗакрыть.Видимость;
	
	Элементы.СнятСПоддержки.Видимость = Объект.СнятСПоддержки;
	
	// Загрузка и установка списка доступных макетов с драйверами.
	Для каждого МакетДрайвера Из Метаданные.ОбщиеМакеты Цикл
		Если Найти(МакетДрайвера.Имя, "Драйвер") > 0 Тогда
			Элементы.ИмяМакетаДрайвера.СписокВыбора.Добавить(МакетДрайвера.Имя);
		КонецЕсли;
	КонецЦикла;  
	
	ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
	ЦветУстановки = ЦветаСтиля.ЦветФонаВыделенияПоля;
	ЦветОшибки = ЦветаСтиля.ЦветОтрицательногоЧисла;
	
	Элементы.Функции.Видимость = НЕ ОбщегоНазначенияКлиентСервер.ЭтоМобильныйКлиент();
	
	МенеджерОборудованияВызовСервера.ПодготовитьЭлементУправления(Элементы.ТипДрайвера);
	МенеджерОборудованияВызовСервера.ПодготовитьЭлементУправления(Элементы.Наименование);
	МенеджерОборудованияВызовСервера.ПодготовитьЭлементУправления(Элементы.ТипОборудования);
	МенеджерОборудованияВызовСервера.ПодготовитьЭлементУправления(Элементы.ИдентификаторОбъекта);
	МенеджерОборудованияВызовСервера.ПодготовитьЭлементУправления(Элементы.ИмяФайлаДрайвера);
	МенеджерОборудованияВызовСервера.ПодготовитьЭлементУправления(Элементы.ИмяМакетаДрайвера);
	МенеджерОборудованияВызовСервера.ПодготовитьЭлементУправления(Элементы.ДополнительнаяИнформация);
	МенеджерОборудованияВызовСервера.ПодготовитьЭлементУправления(Элементы.ТекущийСтатусДрайвера);
	МенеджерОборудованияВызовСервера.ПодготовитьЭлементУправления(Элементы.УстановленнаяВерсия);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НЕ ПустаяСтрока(ИмяФайлДрайвераДляЗагрузки) Тогда
	#Если НЕ ВебКлиент Тогда
		ПолучитьИнформациюДрайвераПоФайлу(ИмяФайлДрайвераДляЗагрузки);
	#КонецЕсли
	Иначе
		ОбновитьСостояниеЭлементов();
		Если НЕ ПустаяСтрока(Объект.Ссылка) Тогда
			ОбновитьСтатусДрайвера();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Получить файл из хранилища и поместить его в объект.
	Если НЕ ПоставляемыйВСоставеКонфигурации И ЭтоАдресВременногоХранилища(СсылкаНаДрайвер) Тогда
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(СсылкаНаДрайвер);
		ТекущийОбъект.ЗагруженныйДрайвер = Новый ХранилищеЗначения(ДвоичныеДанные, Новый СжатиеДанных(5));
		ТекущийОбъект.ИмяФайлаДрайвера = ИмяФайлДрайвераНаФорме;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если НЕ ПоставляемыйВСоставеКонфигурации И НЕ ПустаяСтрока(Объект.ИмяФайлаДрайвера) Тогда
		СсылкаНаДрайвер = ПолучитьНавигационнуюСсылку(Объект.Ссылка, "ЗагруженныйДрайвер");
		ИмяФайлДрайвераНаФорме = Объект.ИмяФайлаДрайвера;
	КонецЕсли;
	
	ОбновитьСостояниеЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПустаяСтрока(Объект.ТипОборудования) Тогда 
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Тип оборудования не указан.';
																|en = 'Hardware type is not specified.'")); 
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(Объект.Наименование) Тогда 
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Наименование не указано.';
																|en = 'Name is not specified.'")); 
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьДрайверКоманда(Команда)
	
	Если Модифицированность Тогда
		Текст = НСтр("ru = 'Продолжение операции возможно только после записи данных.
			|Записать данные и продолжить?';
			|en = 'You can continue the operation only after data writing.
			|Write the data and continue?'");
		Оповещение = Новый ОписаниеОповещения("УстановитьДрайверКоманда_Завершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет);
	Иначе
		УстановитьДрайвер();
	КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДрайверКоманда_Завершение(Результат, Параметры) Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Если Модифицированность И НЕ Записать() Тогда
			Возврат;
		КонецЕсли;
		УстановитьДрайвер();
	КонецЕсли;  
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьФайлДрайвераКоманда(Команда)
	
	Если ПоставляемыйВСоставеКонфигурации Тогда
		
		Если ПустаяСтрока(Объект.ИмяМакетаДрайвера) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Имя макета драйвера не указано.';
																	|en = 'Driver template name is not specified.'"));
			Возврат;
		Иначе
			ВыгрузитьМакетДрайвера();
		КонецЕсли;   
		
	Иначе 
		
		Если ПустаяСтрока(Объект.ИмяФайлаДрайвера) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Файл драйвера не загружен.';
																	|en = 'Driver file is not imported.'"));
			Возврат;
		КонецЕсли;
		
		Если Модифицированность Тогда
			Текст = НСтр("ru = 'Продолжение операции возможно только после записи данных.
				|Записать данные и продолжить?';
				|en = 'You can continue the operation only after data writing.
				|Write the data and continue?'");
			Оповещение = Новый ОписаниеОповещения("ВыгрузитьФайлДрайвераКоманда_Завершение", ЭтотОбъект);
			ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет);
		Иначе
			ВыгрузитьФайлДрайвера();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьФайлДрайвераКоманда_Завершение(Результат, Параметры)Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Если Модифицированность И НЕ Записать() Тогда
			Возврат;
		КонецЕсли;
		ВыгрузитьФайлДрайвера();
	КонецЕсли;  
	
КонецПроцедуры 

&НаКлиенте
Процедура ЗагрузитьФайлДрайвераКоманда(Команда)
	
	#Если ВебКлиент Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Данный функционал доступен только в режиме тонкого и толстого клиента.';
										|en = 'This functionality is available only in the thin and thick client mode.'"));
		Возврат;
	#КонецЕсли
	
	Оповещение = Новый ОписаниеОповещения("ЗагрузитьФайлДрайвераКоманда_ВыборФайлаЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьВыборФайлаДрайвера(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьФайлДрайвераКоманда_ВыборФайлаЗавершение(ПолноеИмяФайла, Параметры) Экспорт
	
	Если Не ПустаяСтрока(ПолноеИмяФайла) Тогда
		ПолучитьИнформациюДрайвераПоФайлу(ПолноеИмяФайла);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПолучитьИнформациюДрайвераПоФайлу(ПолноеИмяФайла) 
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("ПолноеИмяФайла", ПолноеИмяФайла);
	
	Оповещение = Новый ОписаниеОповещения("ПолучитьИнформациюДрайвераПоФайлу_ИнициализацияФайлаЗавершение", ЭтотОбъект, ПараметрыВыполнения);
	ФайлДрайвера = Новый Файл();
	ФайлДрайвера.НачатьИнициализацию(Оповещение, ПолноеИмяФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьИнформациюДрайвераПоФайлу_ИнициализацияФайлаЗавершение(ФайлДрайвера, ПараметрыВыполнения) Экспорт 
	
	ПараметрыВыполнения.Вставить("ФайлДрайвера", ФайлДрайвера);
	
	Оповещение = Новый ОписаниеОповещения("ПолучитьИнформациюДрайвераПоФайлу_Завершение", ЭтотОбъект, ПараметрыВыполнения);
	НачатьПолучениеКаталогаВременныхФайлов(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьИнформациюДрайвераПоФайлу_Завершение(Результат, ПараметрыВыполнения) Экспорт 
	
	ВременныйКаталог = Результат + "cel\";
	
	ИмяФайла              = ПараметрыВыполнения.ФайлДрайвера.Имя;
	ИмяФайлаПолное        = ПараметрыВыполнения.ФайлДрайвера.ПолноеИмя;
	ИмяФайлаБезРасширения = ПараметрыВыполнения.ФайлДрайвера.ИмяБезРасширения;
	ИмяФайлаРасширение    = ВРег(ПараметрыВыполнения.ФайлДрайвера.Расширение);
	
	Если НЕ МенеджерОборудованияКлиентПовтИсп.ЭтоLinuxКлиент() И ИмяФайлаРасширение = ".EXE" Тогда
		
		// Файл драйвера поставляется дистрибутивом.
		Объект.ПоставляетсяДистрибутивом = Истина; 
		ЗагрузитьФайлДрайвераВБазу(ИмяФайлаПолное, ИмяФайла);
		                                      
	ИначеЕсли ИмяФайлаРасширение = ".ZIP" Тогда
		
		АрхивДрайвера = Новый ЧтениеZipФайла();
		АрхивДрайвера.Открыть(ИмяФайлаПолное);
		
		Для Каждого ЭлементАрхива Из АрхивДрайвера.Элементы Цикл
			МанифестНайден = Ложь;
			
			// Проверяем, есть ли файл манифеста.
			Если ВРег(ЭлементАрхива.Имя) = "MANIFEST.XML" Тогда
				Объект.ПоставляетсяДистрибутивом = Ложь; 
				МанифестНайден = Истина;
			КонецЕсли;
			
			// Проверяем, есть ли файл информации.
			Если ВРег(ЭлементАрхива.Имя) = "INFO.XML" Тогда
				
				АрхивДрайвера.Извлечь(ЭлементАрхива, ВременныйКаталог);
				
				ФайлИнформации = Новый ЧтениеТекста(ВременныйКаталог + "INFO.XML", КодировкаТекста.UTF8);
				ПрочитатьИнформацииОДрайвере(ФайлИнформации.Прочитать());
				ФайлИнформации.Закрыть(); 
				
				НачатьУдалениеФайлов(, ВременныйКаталог + "INFO.XML");
			КонецЕсли;
			
			// Драйвер поставляется дистрибутивом упакованным в архив.
			Если НЕ МенеджерОборудованияКлиентПовтИсп.ЭтоLinuxКлиент() И НЕ МанифестНайден Тогда
				Если (ВРег(ЭлементАрхива.Имя) = "SETUP.EXE" 
					Или ВРег(ЭлементАрхива.Имя) = ВРег(ИмяФайлаБезРасширения) + ".EXE") Тогда
						Объект.ПоставляетсяДистрибутивом = Истина; 
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
		
		Если ПустаяСтрока(Объект.ИдентификаторОбъекта) Тогда
			Объект.ИдентификаторОбъекта = "AddIn.None";
		КонецЕсли;
		
		ЗагрузитьФайлДрайвераВБазу(ИмяФайлаПолное, ИмяФайла);
		
	Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'Неверное расширение файла.';
										|en = 'Invalid file extension.'"));
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПрочитатьИнформацииОДрайвере(ИнформацияФайла)
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(ИнформацияФайла);
	ЧтениеXML.ПерейтиКСодержимому();
	
	Если ЧтениеXML.Имя = "drivers" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда  
		Пока ЧтениеXML.Прочитать() Цикл 
			Если ЧтениеXML.Имя = "component" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда  
				Объект.ИдентификаторОбъекта = ЧтениеXML.ЗначениеАтрибута("progid");
				Объект.Наименование = ЧтениеXML.ЗначениеАтрибута("name");
				Объект.ВерсияДрайвера = ЧтениеXML.ЗначениеАтрибута("version");
				ВремТипОборудования = ЧтениеXML.ЗначениеАтрибута("type");
				Если НЕ ПустаяСтрока(ВремТипОборудования) Тогда
					Объект.ТипОборудования = МенеджерОборудованияВызовСервера.ПолучитьТипОборудования(ВремТипОборудования);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;  
	КонецЕсли;
	ЧтениеXML.Закрыть(); 
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьФайлДрайвераВБазу(ПолноеИмяФайла, ИмяФайла) Экспорт 
	
	Оповещение = Новый ОписаниеОповещения("ЗагрузитьФайлДрайвераВБазу_Завершение", ЭтотОбъект, ИмяФайла);
	НачатьПомещениеФайлов(Оповещение, Неопределено, ПолноеИмяФайла, Ложь) 
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьФайлДрайвераВБазу_Завершение(ПомещенныеФайлы, ИмяФайла) Экспорт 
	
	Если ПомещенныеФайлы.Количество() > 0 Тогда
		ИмяФайлДрайвераНаФорме = ИмяФайла;
		СсылкаНаДрайвер = ПомещенныеФайлы[0].Хранение;
		ОбновитьСостояниеЭлементов();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьОписаниеРевизииИнтерфейса(РевизияИнтерфейса)
	
	Версия = "";
	Если РевизияИнтерфейса >= 3000 Тогда
		Версия = "3." + (РевизияИнтерфейса - 3000);
	ИначеЕсли РевизияИнтерфейса >= 2000 Тогда
		Версия = "2." + (РевизияИнтерфейса - 2000);
	ИначеЕсли РевизияИнтерфейса > 1000 Тогда
		Версия = "1." + (РевизияИнтерфейса - 1000);
	КонецЕсли;
	
	Результат = Символы.НПП + НСтр("ru = '(Версия требований к разработке драйверов %Версия%)';
									|en = '(Version of driver development requirements %Версия%)'");
	Результат = СтрЗаменить(Результат, "%Версия%", Версия);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьТекущийСтатусДрайвера()
	
	Если НоваяАрхитектура И ИнтеграционныйКомпонент Тогда
		ТекущийСтатусДрайвера = НСтр("ru = 'Установлен интеграционный компонент.';
									|en = 'Integration component is installed.'") + Символы.НПП;
		ТекущийСтатусДрайвера = ТекущийСтатусДрайвера + ?(ОсновнойДрайверУстановлен, НСтр("ru = 'Установлена основная поставка драйвера.';
																							|en = 'Main driver supply is installed.'"),
																					 НСтр("ru = 'Основная поставка драйвера не установлена.';
																							|en = 'Main driver supply is not installed.'")); 
	Иначе
		ТекущийСтатусДрайвера = НСтр("ru = 'Установлен на текущем компьютере.';
									|en = 'Installed on the current computer.'");
	КонецЕсли;
	
	Если Не ПустаяСтрока(ТекущаяВерсия) Тогда
		УстановленнаяВерсия = ТекущаяВерсия + ПолучитьОписаниеРевизииИнтерфейса(Число(РевизияИнтерфейса));
		Элементы.УстановленнаяВерсия.Видимость = Истина;
	Иначе
		Элементы.УстановленнаяВерсия.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьНомерВерсииЗавершение(РезультатВызова, ПараметрыВызова, ДополнительныеПараметры) Экспорт;
	
	Если Не ПустаяСтрока(РезультатВызова) Тогда
		ТекущаяВерсия = РезультатВызова;
		ОбновитьТекущийСтатусДрайвера();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьОписаниеЗавершение(РезультатВызова, ПараметрыВызова, ДополнительныеПараметры) Экспорт;
	
	НоваяАрхитектура = Истина;
	НаименованиеДрайвера = ПараметрыВызова[0];
	ОписаниеДрайвера     = ПараметрыВызова[1];
	ТипОборудования      = ПараметрыВызова[2]; 
	РевизияИнтерфейса    = ПараметрыВызова[3];
	ИнтеграционныйКомпонент   = ПараметрыВызова[4];
	ОсновнойДрайверУстановлен = ПараметрыВызова[5];
	URLЗагрузкиДрайвера       = ПараметрыВызова[6];
	ОбновитьТекущийСтатусДрайвера();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучениеОбъектаДрайвераЗавершение(ОбъектДрайвера, Параметры) Экспорт
	
	Если ПустаяСтрока(Объект.ИдентификаторОбъекта) И ПоставляемыйВСоставеКонфигурации Тогда
		ТекущийСтатусДрайвера = НСтр("ru = 'Установка драйвера не требуется.';
									|en = 'Driver installation is not required.'");
	ИначеЕсли ПустаяСтрока(ОбъектДрайвера) Тогда
		ТекущийСтатусДрайвера = НСтр("ru = 'Не установлен на текущем компьютере. Не определен тип:';
									|en = 'Not installed on the current computer. Type is not defined:'") + Символы.НПП + Объект.ИдентификаторОбъекта;
		Элементы.ТекущийСтатусДрайвера.ЦветТекста = ЦветОшибки;
		Элементы.УстановленнаяВерсия.ЦветТекста = ЦветОшибки;
	Иначе
		Элементы.ФормаУстановитьДрайвер.Доступность = Ложь;
		Элементы.ТекущийСтатусДрайвера.ЦветТекста = ЦветУстановки;
		Элементы.УстановленнаяВерсия.ЦветТекста = ЦветУстановки;
		ТекущаяВерсия = "";
		Попытка
			ОповещениеМетода = Новый ОписаниеОповещения("ПолучитьНомерВерсииЗавершение", ЭтотОбъект);
			ОбъектДрайвера.НачатьВызовПолучитьНомерВерсии(ОповещениеМетода);
		Исключение
			ОбновитьТекущийСтатусДрайвера()
		КонецПопытки;
		
		Попытка
			НоваяАрхитектура          = Ложь;
			НаименованиеДрайвера      = "";
			ОписаниеДрайвера          = "";
			ТипОборудования           = "";
			ИнтеграционныйКомпонент   = Ложь;
			ОсновнойДрайверУстановлен = Ложь;
			РевизияИнтерфейса         = МенеджерОборудованияКлиентПовтИсп.РевизияИнтерфейсаДрайверов();
			URLЗагрузкиДрайвера       = "";
			ОповещениеМетода = Новый ОписаниеОповещения("ПолучитьОписаниеЗавершение", ЭтотОбъект);
			ОбъектДрайвера.НачатьВызовПолучитьОписание(ОповещениеМетода, НаименованиеДрайвера, ОписаниеДрайвера, ТипОборудования, РевизияИнтерфейса, 
											ИнтеграционныйКомпонент, ОсновнойДрайверУстановлен, URLЗагрузкиДрайвера);
		Исключение
			ОбновитьТекущийСтатусДрайвера()
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтатусДрайвера();
	
	ДанныеДрайвера = Новый Структура();
	ДанныеДрайвера.Вставить("ДрайверОборудования"       , Объект.Ссылка);
	ДанныеДрайвера.Вставить("ВСоставеКонфигурации"      , Объект.Предопределенный);
	ДанныеДрайвера.Вставить("ИдентификаторОбъекта"      , Объект.ИдентификаторОбъекта);
	ДанныеДрайвера.Вставить("ПоставляетсяДистрибутивом" , Объект.ПоставляетсяДистрибутивом);
	ДанныеДрайвера.Вставить("ИмяМакетаДрайвера"         , Объект.ИмяМакетаДрайвера);
	ДанныеДрайвера.Вставить("ИмяФайлаДрайвера"          , Объект.ИмяФайлаДрайвера);
	
	Элементы.ТекущийСтатусДрайвера.ЦветТекста = ЦветТекста;
	
	Оповещение = Новый ОписаниеОповещения("ПолучениеОбъектаДрайвераЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьПолучениеОбъектаДрайвера(Оповещение, ДанныеДрайвера);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСостояниеЭлементов();
	
	Если ПоставляемыйВСоставеКонфигурации И ПустаяСтрока(Объект.ИмяМакетаДрайвера) Тогда
		ВидимостьВыгрузитьФайл = Ложь;
	ИначеЕсли НЕ ПоставляемыйВСоставеКонфигурации И ПустаяСтрока(ИмяФайлДрайвераНаФорме) Тогда
		ВидимостьВыгрузитьФайл = Ложь;
	Иначе
		ВидимостьВыгрузитьФайл = НЕ ПустаяСтрока(Объект.Ссылка);
	КонецЕсли;
		
	Элементы.ФормаВыгрузитьФайлДрайвера.Видимость = ВидимостьВыгрузитьФайл;
	Элементы.ФормаУстановитьДрайвер.Видимость     = ВидимостьВыгрузитьФайл;
	Элементы.ФормаЗагрузитьФайлДрайвера.Видимость = НЕ ПоставляемыйВСоставеКонфигурации;
	
	Если НЕ ПустаяСтрока(ИмяФайлДрайвераНаФорме) Или ПоставляемыйВСоставеКонфигурации Тогда
		Если ПустаяСтрока(Объект.ИдентификаторОбъекта) Тогда
			ДополнительнаяИнформация = НСтр("ru = 'Не указан ProgID компоненты или установка драйвера не требуется.';
											|en = 'ProgID of the component is not specified or driver installation is not required.'");
		ИначеЕсли Объект.ПоставляетсяДистрибутивом Тогда
			ДополнительнаяИнформация = НСтр("ru = 'Драйвер поставляется в виде дистрибутива поставщика.';
											|en = 'Driver is supplied as a supplier distribution.'");
		Иначе
			ДополнительнаяИнформация = НСтр("ru = 'Драйвер поставляется в виде архива.';
											|en = 'The driver is supplied as an archive.'")
				+ ?(ПустаяСтрока(Объект.ВерсияДрайвера), "", Символы.ПС + НСтр("ru = 'Версия драйвера в архиве:';
																				|en = 'Driver version in the archive:'")
				+ Символы.НПП + Объект.ВерсияДрайвера);
		КонецЕсли;
	Иначе
		ДополнительнаяИнформация = НСтр("ru = 'Подключение установленного драйвера на локальных компьютерах.';
										|en = 'Connection of the installed driver on local computers.'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьМакетДрайвера()
	
	ВремИмяФайла = ?(ПустаяСтрока(Объект.ИмяФайлаДрайвера), Объект.ИмяМакетаДрайвера + ".zip", Объект.ИмяФайлаДрайвера);
	Если ВРег(Прав(ВремИмяФайла, 4)) = ".EXE" Тогда  
		ВремИмяФайла = Лев(ВремИмяФайла, СтрДлина(ВремИмяФайла) - 4) + ".zip";  
	КонецЕсли;
	СсылкаНаФайл = МенеджерОборудованияВызовСервера.ПолучитьМакетССервера(Объект.ИмяМакетаДрайвера);
	ПолучитьФайл(СсылкаНаФайл, ВремИмяФайла); 
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьФайлДрайвера()
	
	СсылкаНаФайлВИБ = ПолучитьНавигационнуюСсылку(Объект.Ссылка, "ЗагруженныйДрайвер");
	ПолучитьФайл(СсылкаНаФайлВИБ, Объект.ИмяФайлаДрайвера); 
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДрайверИзАрхиваПриЗавершении(Результат) Экспорт 
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Установка драйвера завершена.';
															|en = 'Driver is installed.'")); 
	ОбновитьСтатусДрайвера();
	
КонецПроцедуры 

&НаКлиенте
Процедура УстановитьДрайверИзДистрибутиваПриЗавершении(Результат, Параметры) Экспорт 
	
	Если Результат Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Установка драйвера завершена.';
																|en = 'Driver is installed.'")); 
		ОбновитьСтатусДрайвера();
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'При установке драйвера из дистрибутива произошла ошибка.';
																|en = 'An error occurred when installing the driver from distribution.'")); 
	КонецЕсли;

КонецПроцедуры 

&НаКлиенте
Процедура УстановитьДрайвер()
	
	ОчиститьСообщения();
	
	ОповещенияДрайверИзДистрибутиваПриЗавершении = Новый ОписаниеОповещения("УстановитьДрайверИзДистрибутиваПриЗавершении", ЭтотОбъект);
	ОповещенияДрайверИзАрхиваПриЗавершении = Новый ОписаниеОповещения("УстановитьДрайверИзАрхиваПриЗавершении", ЭтотОбъект);
	
	МенеджерОборудованияКлиент.УстановитьДрайвер(Объект.Ссылка, ОповещенияДрайверИзДистрибутиваПриЗавершении, ОповещенияДрайверИзАрхиваПриЗавершении);
	
КонецПроцедуры

#КонецОбласти
