
////////////////////////////////////////////////////////////////////////////////
// Dropbox клиент (iCRM)
//  
////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс

// Выполняет авторизацию.
//
// Параметры:
//  МетодЗавершения		 - Строка - Метод завершения.
//  ФормаВладелец		 - УправляемаяФорма - Форма-владелец.
//  МетодПриАвторизации	 - Строка - Метод при авторизации.
//
Процедура ВыполнитьАвторизацию(МетодЗавершения, ФормаВладелец, МетодПриАвторизации = Неопределено) Экспорт
	
	Результат = Ложь;
	
	ОткрытьФорму("ОбщаяФорма.CRM_АвторизацияВСервисеDropbox",
					Новый Структура("МетодЗавершения, МетодПриАвторизации, ЗакрыватьПриЗакрытииВладельца", МетодЗавершения, МетодПриАвторизации, Истина),
					ФормаВладелец);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОтключитьАккаунт(ОписаниеОповещения) Экспорт
	
	// Получить данные аккаунта
	ЕмейлАккаунта = CRM_DropboxКлиентСервер.ПолучитьЭлектронныйАдресАккаунта();
	
	// Вопрос пользователю для подтверждения намерений выхода из аккаунта
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВопросОтключенияЗавершение",
												ЭтотОбъект,
												Новый Структура("ОписаниеОповещения", ОписаниеОповещения));
	
	Режим = РежимДиалогаВопрос.ДаНет;
	ТекстВопроса = НСтр("de='Möchten Sie sich wirklich vom Konto %ИмяАккаунта% abmelden?';en='Are you sure you want to sign out of %ИмяАккаунта%?';es='¿Seguro que deseas salir de la cuenta %ИмяАккаунта%?';fr='Voulez-vous vraiment vous déconnecter du compte %ИмяАккаунта% ?';it=""Sei sicuro di voler uscire dall'account %ИмяАккаунта%?"";ja='%ИмяАккаунта%のアカウントからログオフしてよろしいですか？';ko='%ИмяАккаунта%에서 로그아웃하시겠습니까?';nb='Er du sikker på at du vil logge ut av %ИмяАккаунта%?';pt='Você tem certeza que quer sair da conta %ИмяАккаунта%?';ru='Вы уверены, что хотите выйти из аккаунта %ИмяАккаунта%?';zh='确定要退出 %ИмяАккаунта%？';vi='Are you sure you want to sign out of %ИмяАккаунта%?'");
	ТекстВопроса = СтрЗаменить(ТекстВопроса, "%ИмяАккаунта%", ЕмейлАккаунта);	
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Режим, 0);
	
КонецФункции

Процедура ВопросОтключенияЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт 

	Результат = Ложь;
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		Результат = Истина;
		
		CRM_DropboxСервер.СохранитьПараметрыАвторизации(Неопределено);
		
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещения, Результат);
	
КонецПроцедуры

Процедура СообщитьОбОшибке(ОписаниеОшибки) Экспорт

	ПодробноеОписаниеОшибки = Неопределено;
	ТекстСообщения = "";
	
	Если ТипЗнч(ОписаниеОшибки) = Тип("Структура")
		И ОписаниеОшибки.Свойство("error", ПодробноеОписаниеОшибки) Тогда
		
		Если ПодробноеОписаниеОшибки = Неопределено Тогда
		
			Возврат;
		
		КонецЕсли; 
		
		ТипОшибки = ПодробноеОписаниеОшибки["tag"];		
		
		Если ТипОшибки = "path" Тогда
			
			ПредставлениеОшибки = ПодробноеОписаниеОшибки[ТипОшибки]["tag"];
			
			Если ПредставлениеОшибки = "not_found" Тогда
			
				ТекстСообщения = НСтр("de='Die angegebene Adresse wurde nicht gefunden';en='Specified address not found!';es='¡La dirección especificada no se encuentra!';fr='Adresse introuvable!';it='Indirizzo specificato non trovato!';ja='ご指定の住所が見つかりません!';ko='명시된 주소를 찾을 수 없습니다!';nb='Angitt adresse ikke funnet!';pt='Endereço especificado não encontrado!';ru='Заданный путь не найден!';zh='未找到指定地址！';vi='Specified address not found!'");
				
			ИначеЕсли ПредставлениеОшибки = "not_file" Тогда
			
				ТекстСообщения = НСтр("de='Die angegebene Adresse entspricht nicht der erwarteten Datei.';en=""Specified address doesn't match with the expected file!"";es='¡La dirección especificada no coincide con el archivo esperado!';fr=""L'adresse ne correspond pas au fichier!"";it=""L'indirizzo specificato non corrisponde al file previsto!"";ja='ご指定の住所はファイ ルに一致しません!';ko='명시된 주소가 예상 파일과 일치하지 않습니다!';nb='Angitt adresse stemmer ikke med den forventede filen!';pt='O endereço especificado não coincide com o ficheiro previsto!';ru='Ожидается файл, указанный путь не соответствует файлу!';zh='指定地址与预期文件不符！';vi=""Specified address doesn't match with the expected file!""");
				
			ИначеЕсли ПредставлениеОшибки = "not_folder" Тогда
			
				ТекстСообщения = НСтр("de='Die angegebene Adresse entspricht nicht dem erwarteten Katalog.';en=""Specified address doesn't match with the expected catalog!"";es='¡La dirección especificada no coincide con el catálogo esperado!';fr=""L'adresse ne correspond pas au catalogue!"";it=""L'indirizzo specificato non corrisponde al catalogo previsto!"";ja='ご指定の住所はカタロ グに一致しません!';ko='명시된 주소가 예상 카탈로그와 일치하지 않습니다!';nb='Angitt adresse stemmer ikke med den forventede katalogen!';pt='O endereço especificado não coincide com o catálogo previsto!';ru='Ожидается каталог, указанный путь не соответствует каталогу!';zh='指定地址与预期目录不符！';vi=""Specified address doesn't match with the expected catalog!""");
			
			КонецЕсли;			
		
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОписаниеОшибки) = Тип("Строка") Тогда
		
		ТекстСообщения = ОписаниеОшибки;
		
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ТекстСообщения) Тогда
	
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрЗаменить(НСтр("de='Fehler: %1';en='Error: %1';es='Error: %1';fr='Erreur: %1';it='Errore: %1';ja='エラー: %1';ko='오류: %1';nb='Feil: %1';pt='Erro: %1';ru='Ошибка: %1';zh='错误：%1';vi='Error: %1'"), "%1", ТекстСообщения));
	
	КонецЕсли; 

КонецПроцедуры

#КонецОбласти

