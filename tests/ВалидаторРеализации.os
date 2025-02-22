#Использовать ".."
#Использовать "."
#Использовать asserts

&Тест
Процедура СломаннаяРеализацияИнтерфейсаБросаетИсключение() Экспорт

	// Дано
	ВалидаторРеализации = Новый ВалидаторРеализации;
	ТестоваяРеализация = Новый ТестоваяСломаннаяРеализация();

	// Когда-тогда
	ПараметрыМетода = Новый Массив();
	ПараметрыМетода.Добавить(ТестоваяРеализация);
	Ожидаем.Что(ВалидаторРеализации).Метод("ИнтерфейсыРеализованыКорректно", ПараметрыМетода).ВыбрасываетИсключение();

КонецПроцедуры

&Тест
Процедура РаботающаяРеализацияИнтерфейсаНеБросаетИсключение() Экспорт

	// Дано
	ВалидаторРеализации = Новый ВалидаторРеализации;
	ТестоваяРеализация = Новый ТестоваяРаботающаяРеализация();

	// Когда-Тогда не бросает исключение
	ВалидаторРеализации.ИнтерфейсыРеализованыКорректно(ТестоваяРеализация);

КонецПроцедуры
