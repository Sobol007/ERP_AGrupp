//<--АГ:[УСЛ0017][11.05.2019 18:05][Давиденко А.В.]
&НаКлиенте
Процедура Команда1(Команда)
	СоздатьДокументы();
КонецПроцедуры

&НаСервере
Процедура СоздатьДокументы()
	ЭтаОбработка =  РеквизитФормыВЗначение("Объект");
	ЭтаОбработка.СоздатьДокументы(ДокументПоступления);	
КонецПроцедуры;
//-->АГ:[УСЛ0017]
