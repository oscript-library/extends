#Использовать annotations
#Использовать decorator
#Использовать reflector

Перем _ОбъектНаследник;
Перем _ОбъектРодитель;

Функция Построить() Экспорт

	РефлекторОбъекта = Новый РефлекторОбъекта(_ОбъектНаследник);
	
	СвойстваНаследника_Родитель = РефлекторОбъекта.ПолучитьТаблицуСвойств("Родитель", Истина);
	МетодыНаследника = РефлекторОбъекта.ПолучитьТаблицуМетодов(, Ложь);
	Метод = РаботаСАннотациями.НайтиМетодыСАннотацией(МетодыНаследника, "Расширяет")[0];
	АннотацияРасширяет = РаботаСАннотациями.НайтиАннотацию(Метод.Аннотации, "Расширяет");

	ИмяПоляОбъектРодитель = "_ОбъектРодитель";
	ИмяТипаРодителя = РаботаСАннотациями.ПолучитьЗначениеПараметраАннотации(АннотацияРасширяет);
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

		ПеренестиАннотации(Метод, МетодРодителя.Аннотации);
		
		ИменаПараметров = Новый Массив;
		Для Каждого ПараметрРодителя Из МетодРодителя.Параметры Цикл
			ПараметрМетода = ПараметрМетодаИзДанныхРефлектора(ПараметрРодителя);
			Метод.Параметр(ПараметрМетода);

			ИменаПараметров.Добавить(ПараметрРодителя.Имя);
		КонецЦикла;
		СтрокаПараметры = СтрСоединить(ИменаПараметров, ", ");
		
		ТелоМетода = ИмяПоляОбъектРодитель + "." + МетодРодителя.Имя + "(" + СтрокаПараметры + ");";
		Если МетодРодителя.ЭтоФункция Тогда
			ТелоМетода = "Возврат " + ТелоМетода;
		Иначе
			Метод.ЭтоПроцедура();
		КонецЕсли;
		Метод.ТелоМетода(ТелоМетода);

		Декоратор.Метод(Метод);

	КонецЦикла;

	// Перенос конструктора
	КонструкторНаследника = РефлекторОбъекта.ПолучитьТаблицуМетодов(Неопределено, Ложь).Найти("ПриСозданииОбъекта", "Имя");
	КонструкторРодителя = РефлекторОбъектаРодителя.ПолучитьТаблицуМетодов(Неопределено, Ложь).Найти("ПриСозданииОбъекта", "Имя");

	Если КонструкторНаследника <> Неопределено ИЛИ КонструкторРодителя <> Неопределено Тогда
		Метод = Новый Метод(КонструкторНаследника.Имя).ЭтоПроцедура();
		
		Если КонструкторНаследника <> Неопределено Тогда
			ПеренестиАннотации(Метод, КонструкторНаследника.Аннотации, "Расширяет");
		КонецЕсли;

		Если КонструкторРодителя <> Неопределено Тогда
			ПеренестиАннотации(Метод, КонструкторРодителя.Аннотации, "Расширяет");
		КонецЕсли;

		Декоратор.Метод(Метод);
	КонецЕсли;

	Декоратор.ЗарегистрироватьВСистемеТипов("" + ТипЗнч(_ОбъектНаследник) + "_Расширяет_" + ИмяТипаРодителя);

	Объект = Декоратор.Построить();

	Возврат Объект;
КонецФункции

Процедура ПеренестиАннотации(МетодИлиПараметр, Аннотации, ИмяИсключаемойАннотации = "")
	Для Каждого ДанныеАннотации Из Аннотации Цикл
		Если ВРег(ДанныеАннотации.Имя) = ВРег(ИмяИсключаемойАннотации) Тогда
			Продолжить;
		КонецЕсли;

		Аннотация = АннотацияИзДанныхРефлектора(ДанныеАннотации);
		МетодИлиПараметр.Аннотация(Аннотация);
	КонецЦикла;
КонецПроцедуры

Функция ПараметрМетодаИзДанныхРефлектора(Параметр)

	ПараметрМетода = Новый ПараметрМетода(Параметр.Имя);
	Если Параметр.ПоЗначению Тогда
		ПараметрМетода.ПоЗначению();
	КонецЕсли;
	Если Параметр.ЕстьЗначениеПоУмолчанию Тогда
		ПараметрМетода.ЗначениеПоУмолчанию(Параметр.ЗначениеПоУмолчанию);
	КонецЕсли;

	ПеренестиАннотации(ПараметрМетода, Параметр.Аннотации);

	Возврат ПараметрМетода;

КонецФункции

Функция АннотацияИзДанныхРефлектора(ДанныеАннотации)
	
	Аннотация = Новый Аннотация(ДанныеАннотации.Имя);
	Для Каждого Параметр Из ДанныеАннотации.Параметры Цикл
		Аннотация.Параметр(Параметр.Значение, Параметр.Имя);
	КонецЦикла;

	Возврат Аннотация;

КонецФункции

Процедура ПриСозданииОбъекта(ОбъектНаследник, ОбъектРодитель)
	_ОбъектНаследник = ОбъектНаследник;
	_ОбъектРодитель = ОбъектРодитель;
КонецПроцедуры
