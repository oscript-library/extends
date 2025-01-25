#Использовать annotations
#Использовать decorator
#Использовать reflector

Перем _ОбъектНаследник;
Перем _ОбъектРодитель;

Функция Построить() Экспорт

	РефлекторОбъекта = Новый РефлекторОбъекта(_ОбъектНаследник);
	
	СвойстваНаследника_Родитель = РефлекторОбъекта.ПолучитьТаблицуСвойств("Родитель", Истина);
	МетодыНаследника = РефлекторОбъекта.ПолучитьТаблицуМетодов(, Ложь);
	Метод = РаботаСАннотациями.НайтиМетодыСАннотацией(МетодыНаследника, "Наследует")[0];
	АннотацияНаследует = РаботаСАннотациями.НайтиАннотацию(Метод.Аннотации, "Наследует");

	ИмяПоляОбъектРодитель = "_ОбъектРодитель";
	ИмяТипаРодителя = РаботаСАннотациями.ПолучитьЗначениеПараметраАннотации(АннотацияНаследует);
	РефлекторОбъектаРодителя = Новый РефлекторОбъекта(Тип(ИмяТипаРодителя));
	МетодыРодителя = РефлекторОбъектаРодителя.ПолучитьТаблицуМетодов();

	Декоратор = Новый ПостроительДекоратора(_ОбъектНаследник);

	Если СвойстваНаследника_Родитель.Количество() = 0 Тогда
		Поле = Новый Поле("_ОбъектРодитель")
			.ЗначениеПоУмолчанию(_ОбъектРодитель);
	
		Декоратор.Поле(Поле);
	Иначе
		Рефлектор = Новый Рефлектор();
		Для Каждого СвойствоНаследника_Родитель Из СвойстваНаследника_Родитель Цикл
			Рефлектор.УстановитьСвойство(_ОбъектНаследник, СвойствоНаследника_Родитель.Имя, _ОбъектРодитель);
			ИмяПоляОбъектРодитель = СвойствоНаследника_Родитель.Имя;
		КонецЦикла;
	КонецЕсли;

	Для Каждого МетодРодителя Из МетодыРодителя Цикл
		
		Если МетодРодителя.ЭтоФункция И РефлекторОбъекта.ЕстьФункция(МетодРодителя.Имя, МетодРодителя.КоличествоПараметров) Тогда
			Продолжить;
		КонецЕсли;
		Если НЕ МетодРодителя.ЭтоФункция И РефлекторОбъекта.ЕстьПроцедура(МетодРодителя.Имя, МетодРодителя.КоличествоПараметров) Тогда
			Продолжить;
		КонецЕсли;

		Метод = Новый Метод(МетодРодителя.Имя).Публичный();
		
		ТелоМетода = ИмяПоляОбъектРодитель + "." + МетодРодителя.Имя + "();";
		Если МетодРодителя.ЭтоФункция Тогда
			ТелоМетода = "Возврат " + ТелоМетода;
		Иначе
			Метод.ЭтоПроцедура();
		КонецЕсли;
		Метод.ТелоМетода(ТелоМетода);

		Декоратор.Метод(Метод);

	КонецЦикла;

	Объект = Декоратор.Построить();

	Возврат Объект;
КонецФункции

Процедура ПриСозданииОбъекта(ОбъектНаследник, ОбъектРодитель)
	_ОбъектНаследник = ОбъектНаследник;
	_ОбъектРодитель = ОбъектРодитель;
КонецПроцедуры
