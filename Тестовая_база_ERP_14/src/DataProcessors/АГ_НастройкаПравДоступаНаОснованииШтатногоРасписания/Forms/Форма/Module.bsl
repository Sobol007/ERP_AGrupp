//<--АГ:[Permission _003][14.04.2019 12:05][Давиденко А.В.]

&НаСервере
Процедура ЗаполнитьГруппыДоступаНаОснованииШтатногоРасписанияНаСервере()
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	ОбработкаОбъект.ЗаполнитьГруппыДоступа(Пользователь);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьГруппыДоступаНаОснованииШтатногоРасписания(Команда)
	ЗаполнитьГруппыДоступаНаОснованииШтатногоРасписанияНаСервере();
КонецПроцедуры

//-->АГ:[Permission _003]