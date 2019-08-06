
#Область ПрограммныйИнтерфейс

// Дополнительная настройка доступности элементов формы узла обмен
//
// Параметры:
//  ФормаУзла  - УправляемаяФорма - форма узла, для которой настраивается доступность.
//  ОбъектУзла  - ПланОбменаОбъект.ОбменССайтом - план обмен, для формы узла которого настраивается доступность
//
Процедура УстановитьДоступностьЭлементовФормыУзла(ФормаУзла, ОбъектУзла) Экспорт
	
	//++ НЕ ГОСИС
	ФормаУзла.Элементы.ГруппаДоступаПартнеров.Доступность = ФормаУзла.ИспользуютсяГруппыДоступаПартнеров 
	                                                        И (ФормаУзла.ИспользоватьПартнеровКакКонтрагентов
	                                                          ИЛИ ФормаУзла.СоздаватьПартнеровДляНовыхКонтрагентов);
															  
	ФормаУзла.Элементы.ВыгружатьФайлы.Доступность = ОбъектУзла.ВыгружатьТовары;
	//-- НЕ ГОСИС
	
КонецПроцедуры

#КонецОбласти