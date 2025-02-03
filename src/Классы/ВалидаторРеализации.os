#Использовать annotations
#Использовать reflector

Процедура ИнтерфейсыРеализованыКорректно(ПроверяемыйОбъект) Экспорт
	
	РефлекторОбъекта = Новый РефлекторОбъекта(ПроверяемыйОбъект);
	МетодыСАннотацией = РефлекторОбъекта.ПолучитьТаблицуМетодов("Реализует", Ложь);
	
	Если МетодыСАннотацией.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Метод Из МетодыСАннотацией Цикл
		
		Аннотации = РаботаСАннотациями.НайтиАннотации(Метод.Аннотации, "Реализует");
		
		Для Каждого Аннотация Из Аннотации Цикл
			ИмяИнтерфейса = РаботаСАннотациями.ПолучитьЗначениеПараметраАннотации(Аннотация);
			
			ИнтерфейсОбъекта = Новый ИнтерфейсОбъекта();
			ИнтерфейсОбъекта.ИзОбъекта(Вычислить(ИмяИнтерфейса));
			
			ВызватьИсключениеРеализации = Истина;
			РефлекторОбъекта.РеализуетИнтерфейс(ИнтерфейсОбъекта, ВызватьИсключениеРеализации);
		КонецЦикла;
	
	КонецЦикла;
КонецПроцедуры
