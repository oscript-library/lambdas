#Использовать decorator

Перем РазобранноеВыражение; // Структура разобранного лямбда выражения

Перем мВыражение; // Лямбда выражение
Перем мИнтерфейс; // Функциональный интерфейс для лямбда выражения
Перем мКонтекст;  // Структура с контекстом для лямбда выражения
Перем мОбъект;    // Объект который будет захвачен в лямбда выражение
Перем Отладка;    // Отладочное сохранение текста сценария в файл

Перем СодержитВозвратЗначения; // Регулярное выражение проверяющее наличие возврата значения
Перем ЭтоЛямбдаВыражение;      // Регулярное выражение проверяющее лямбда выражение

// Устанавливает функциональный интерфейс для лямбда выражения.
//  В случае если метод интерфейса это функция:
//   1. Добавляет "Возврат" в лямбда выражение если оно однострочное и не содержит возврат
//   2. Проверяет что многострочное выражение содержит возврат значения
//  В случае В случае если метод интерфейса это процедура:
//   1. Проверяет что выражение не содержит возврат значения
//
// Параметры:
//   Интерфейс - ИнтерфейсОбъекта - Устанавливаемый функциональный интерфейс
//
//  Возвращаемое значение:
//   ЛямбдаВыражение - Инстанс текущего выражения
//
Функция Интерфейс(Интерфейс) Экспорт

	ЭтоФункция       = Интерфейс.ПолучитьКартуИнтерфейса()[0].ЭтоФункция;
	ВозвратыЗначений = СодержитВозвратЗначения.НайтиСовпадения(РазобранноеВыражение.Тело);

	Если ЭтоФункция Тогда

		Если СтрЧислоСтрок(РазобранноеВыражение.Тело) > 1
			И ВозвратыЗначений.Количество() = 0 Тогда

			ВызватьИсключение Новый ИнформацияОбОшибке(
				"Лямбда выражение должно возвращать значение",
				мВыражение
			);

		КонецЕсли;

		Если СтрЧислоСтрок(РазобранноеВыражение.Тело) = 1 
			И ВозвратыЗначений.Количество() = 0 Тогда

			РазобранноеВыражение.Тело = "Возврат " + РазобранноеВыражение.Тело; 

		КонецЕсли;

	ИначеЕсли ВозвратыЗначений.Количество() <> 0 Тогда

		ВызватьИсключение Новый ИнформацияОбОшибке(
			"Лямбда выражение не должно возвращать значение",
			мВыражение
		);

	КонецЕсли; // BSLLS:IfElseIfEndsWithElse-off

	мИнтерфейс = Интерфейс;

	Возврат ЭтотОбъект;

КонецФункции

// Устанавливает контекст для лямбда выражения.
// При исполнении лямбда выражения все значения контекста будут доступны для использования в лямбда выражении
//
// Параметры:
//   Контекст - Структура, ФиксированнаяСтруктура - Устанавливаемый контекст
//
//  Возвращаемое значение:
//   ЛямбдаВыражение - Инстанс текущего выражения
//
Функция Контекст(Контекст) Экспорт

	Если Не ТипЗнч(Контекст) = Тип("Структура")
		И Не ТипЗнч(Контекст) = Тип("ФиксированнаяСтруктура") Тогда
		ВызватьИсключение "Контекстом для лямбда выражения может выступать только структура";
	КонецЕсли;

	мКонтекст = Контекст;

	Возврат ЭтотОбъект;

КонецФункции

// Захватывает переданный объект для использования его в качестве контекста лямбда выражения.
// При исполнении лямбда выражения в нём будут доступны публичные и приватные поля переданного объекта
//  а так же публичные методы.
//
// Параметры:
//   Объект - Сценарий - Захватываемый объект
//
//  Возвращаемое значение:
//   ЛямбдаВыражение - Инстанс текущего выражения
//
Функция ЗахватитьОбъект(Объект) Экспорт

	мОбъект = Объект;

	Возврат ЭтотОбъект;

КонецФункции

// Включает возможность отладки. Достигается сохранением текста модуля во временный файл.
//
//  Параметры:
//   Включена - Булево - Включить отладку
//
//  Возвращаемое значение:
//   ЛямбдаВыражение - Инстанс текущего выражения
//
Функция Отладка(Включена = Истина) Экспорт
	
	Отладка = Включена;
	
	Возврат ЭтотОбъект;
	
КонецФункции

// Возвращает действие (делегат) на метод созданный по лямбда выражению
//
//  Возвращаемое значение:
//   Действие - Действие на метод лямбда выражения
//
Функция ВДействие() Экспорт
	
	Объект = ВОбъект();

	Возврат Новый Действие(
		Объект,
		мИнтерфейс.ПолучитьКартуИнтерфейса()[0].Имя
	);

КонецФункции

// Возвращает сценарий созданный по лямбда выражению, который содержит метод согласно интерфейса
//
//  Возвращаемое значение:
//   Сценарий - Созданный сценарий
//
Функция ВОбъект() Экспорт
	
	Если Не ЗначениеЗаполнено(мИнтерфейс) Тогда
		ОпределитьИнтерфейс();
	КонецЕсли;

	МетодИнтерфейса = мИнтерфейс.ПолучитьКартуИнтерфейса()[0];

	Метод = Новый Метод(МетодИнтерфейса.Имя)
		.Публичный()
		.ТелоМетода(РазобранноеВыражение.Тело);

	Если Не МетодИнтерфейса.ЭтоФункция Тогда
		Метод.ЭтоПроцедура();
	КонецЕсли;

	Для Каждого Аннотация Из РазобранноеВыражение.Аннотации Цикл

		АннотацияМетода = Новый Аннотация(Аннотация.Имя);

		Для Каждого ПараметрАннотации Из Аннотация.Параметры Цикл
			АннотацияМетода.Параметр(ПараметрАннотации.Значение, ПараметрАннотации.Имя);
		КонецЦикла;

		Метод.Аннотация(АннотацияМетода);

	КонецЦикла;

	Для каждого Параметр Из РазобранноеВыражение.Параметры Цикл

		ПараметрМетода = Новый ПараметрМетода(Параметр.Имя);

		Для Каждого Аннотация Из Параметр.Аннотации Цикл

			АннотацияПараметра = Новый Аннотация(Аннотация.Имя);

			Для Каждого ПараметрАннотации Из Аннотация.Параметры Цикл
				АннотацияПараметра.Параметр(ПараметрАннотации.Значение, ПараметрАннотации.Имя);
			КонецЦикла;

			ПараметрМетода.Аннотация(АннотацияПараметра);

		КонецЦикла;

		Метод.Параметр(ПараметрМетода);

	КонецЦикла;

	Построитель = Новый ПостроительДекоратора(мОбъект)
		.Отладка(Отладка)
		.Поле(Новый Поле("Выражение").ЗначениеПоУмолчанию(мВыражение))
		.Метод(Метод)
		.Метод(
			Новый Метод("ОбработкаПолученияПредставления")
				.ЭтоПроцедура()
				.Параметр(Новый ПараметрМетода("Представление"))
				.Параметр(Новый ПараметрМетода("СтандартнаяОбработка"))
				.ТелоМетода("СтандартнаяОбработка = Ложь; Представление = Выражение;")
		);

	Для каждого ПеременнаяИЗначение Из мКонтекст Цикл
		
		Построитель.Поле(
			Новый Поле(ПеременнаяИЗначение.Ключ)
				.ЗначениеПоУмолчанию(ПеременнаяИЗначение.Значение)
		);

	КонецЦикла;
	
	Объект = Построитель.Построить();

	Рефлектор = Новый РефлекторОбъекта(Объект);

	Рефлектор.РеализуетИнтерфейс(мИнтерфейс, Истина);

	Возврат Объект;

КонецФункции

Процедура РазобратьВыражение(Выражение)
	
	Если Не ЭтоЛямбдаВыражение.Совпадает(Выражение) Тогда
		ВызватьИсключение Новый ИнформацияОбОшибке("Переданное выражение не является лямбда выражением", Выражение);
	КонецЕсли;

	Совпадения = ЭтоЛямбдаВыражение.НайтиСовпадения(Выражение);

	РезультатРазбора = ПарсерЛямбдаВыражений.РазобратьСтрокуПараметров(Совпадения[0].Группы[1].Значение);

	РазобранноеВыражение.Параметры = РезультатРазбора.Параметры;
	РазобранноеВыражение.Аннотации = РезультатРазбора.Аннотации;

	Тело = Совпадения[0].Группы[2].Значение;

	Если СтрНачинаетсяС(Тело, "{") Тогда
		Тело = Прав(Тело, СтрДлина(Тело) - 1);
	КонецЕсли;

	Если СтрЗаканчиваетсяНа(Тело, "}") Тогда
		Тело = Лев(Тело, СтрДлина(Тело) - 1);
	КонецЕсли;

	РазобранноеВыражение.Тело = Тело;

КонецПроцедуры

Процедура ОпределитьИнтерфейс()
	
	ЭтоФункция           = СодержитВозвратЗначения.НайтиСовпадения(РазобранноеВыражение.Тело).Количество() <> 0;
	КоличествоПараметров = РазобранноеВыражение.Параметры.Количество();

	Если ЭтоФункция Тогда

		Если КоличествоПараметров = 0 Тогда
			мИнтерфейс = ФункциональныеИнтерфейсы.Вызываемый();
		ИначеЕсли КоличествоПараметров = 1 Тогда
			мИнтерфейс = ФункциональныеИнтерфейсы.УниФункция();
		ИначеЕсли КоличествоПараметров = 2 Тогда // BSLLS:MagicNumber-off
			мИнтерфейс = ФункциональныеИнтерфейсы.БиФункция();
		ИначеЕсли КоличествоПараметров = 3 Тогда // BSLLS:MagicNumber-off
			мИнтерфейс = ФункциональныеИнтерфейсы.ТриФункция();
		КонецЕсли; // BSLLS:IfElseIfEndsWithElse-off

	Иначе

		Если КоличествоПараметров = 0 Тогда
			мИнтерфейс = ФункциональныеИнтерфейсы.Запускаемый();
		ИначеЕсли КоличествоПараметров = 1 Тогда
			мИнтерфейс = ФункциональныеИнтерфейсы.УниПроцедура();
		ИначеЕсли КоличествоПараметров = 2 Тогда // BSLLS:MagicNumber-off
			мИнтерфейс = ФункциональныеИнтерфейсы.БиПроцедура();
		ИначеЕсли КоличествоПараметров = 3 Тогда // BSLLS:MagicNumber-off
			мИнтерфейс = ФункциональныеИнтерфейсы.ТриПроцедура();
		КонецЕсли; // BSLLS:IfElseIfEndsWithElse-off

	КонецЕсли;

	Если Не ЗначениеЗаполнено(мИнтерфейс) Тогда

		Параметры = Новый Структура(
			"Выражение, ЭтоФункция, КоличествоПараметров",
			мВыражение,
			ЭтоФункция,
			КоличествоПараметров
		);

		ВызватьИсключение Новый ИнформацияОбОшибке(
			"Невозможно определить функциональный интерфейс для лямбда выражения",
			Параметры
		);

	КонецЕсли;

КонецПроцедуры

Процедура ПриСозданииОбъекта(Выражение)

	РазобранноеВыражение = Новый Структура(
		"Аннотации, Параметры, Тело"
	);

	мВыражение = Выражение;
	мКонтекст  = Новый Структура();
	Отладка    = Ложь;

	РазобратьВыражение(Выражение);

КонецПроцедуры

ЭтоЛямбдаВыражение      = ЛямбдыКешируемыеЗначения.РегулярноеВыражениеЭтоЛямбдаВыражение();
СодержитВозвратЗначения = ЛямбдыКешируемыеЗначения.РегулярноеВыражениеСодержитВозвратЗначения();
