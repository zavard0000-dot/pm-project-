## Система локализации TeamUp - Руководство интеграции

### Что было создано:

1. **`lib/providers/language_provider.dart`** - управление текущим языком
2. **`lib/localization/app_localizations.dart`** - словарь с 50+ ключами (EN + RU)
3. **`lib/features/settings/views/settings_screen.dart`** - полная интеграция + переключатель языка

### Быстрая интеграция в другие экраны:

#### Шаг 1: Добавить импорты
```dart
import 'package:teamup/providers/language_provider.dart';
import 'package:teamup/localization/app_localizations.dart';
```

#### Шаг 2: В методе build получить текущий язык
```dart
@override
Widget build(BuildContext context) {
  final langProvider = context.watch<LanguageProvider>();
  final currentLocale = langProvider.locale;
  
  // Ваш код...
}
```

#### Шаг 3: Заменить все текстовые строки
**Вместо:**
```dart
Text('Edit Profile')
Text('No favorites')
Text('Удалить')
```

**Используйте:**
```dart
Text(AppLocalizations.get('edit_profile', locale: currentLocale))
Text(AppLocalizations.get('no_favorites', locale: currentLocale))
Text(AppLocalizations.get('remove', locale: currentLocale))
```

### Доступные ключи локализации:

#### Навигация
- `home_tab` - Главная
- `favorites_tab` - Избранное
- `create_tab` - Создать
- `notifications_tab` - Уведомления
- `profile_tab` - Профиль

#### Кнопки и действия
- `edit_profile` - Редактировать профиль
- `cancel` - Отмена
- `remove` - Удалить
- `logout` - Вывести из аккаунта
- `create_announcement_button` - Создать объявление

#### Сообщения и статусы
- `not_logged_in` - Вы не авторизованы
- `no_favorites` - Нет избранных объявлений
- `user_not_found` - Пользователь не найден
- `profile_updated_success` - Профиль обновлен успешно

#### Объявления
- `announcement_type_project` - 📌 Проект
- `announcement_type_team` - 👥 Команда
- `announcement_type_person` - 👤 Персона
- `deadline_expired` - Истёк
- `deadline_today` - 🔴 Сегодня

#### Формы
- `email_label` - Email
- `password_label` - Пароль
- `full_name_label` - Полное имя
- `ad_title_label` - Название объявления
- `description_label` - Описание

#### Избранное
- `remove_favorite_title` - Удалить из избранного?
- `removed_from_favorites` - Удалено из избранного
- `error_removing_favorite` - Ошибка при удалении из избранного

#### Профиль
- `click_to_edit_profile` - Нажми для редактирования профеля
- `about_me_hint` - Расскажи о себе...
- `location_hint` - Алматы, Казахстан

#### Настройки
- `settings_title` - Настройки
- `language` - Язык
- `dark_theme` - Темная тема
- `version` - Версия 1.0.0

### Файлы для обновления (приоритет):

1. **HIGH** - `lib/features/home/tabs/favorites_tab/tab_view/favorites_tab_screen.dart`
   - Замены: dialog titles, empty states, buttons

2. **HIGH** - `lib/features/edit_profile/views/edit_profile_screen.dart`
   - Замены: section titles, form labels, hints

3. **HIGH** - `lib/features/home/tabs/create_tab/tab_view/creat_tab_screen.dart`
   - Замены: form labels, button text, hints

4. **MEDIUM** - `lib/features/home/view/home_screen.dart`
   - Замены: tab labels

5. **MEDIUM** - `lib/features/onboarding/view/onboarding_screen.dart`
   - Замены: titles, descriptions, buttons

6. **MEDIUM** - Auth screens (`login_screen.dart`, `signup_screen.dart`)
   - Замены: form labels, error messages, links

7. **LOW** - `lib/features/announcement_details/` (все файлы)
   - Замены: headings, labels, formats

### Примеры интеграции:

#### Пример 1: Простой Text
```dart
// Было
Text('No favorite announcements')

// Стало
Text(AppLocalizations.get('no_favorites', locale: currentLocale))
```

#### Пример 2: SnackBar
```dart
// Было
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Removed from favorites'))
);

// Стало
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(
      AppLocalizations.get('removed_from_favorites', locale: currentLocale)
    )
  )
);
```

#### Пример 3: Dialog
```dart
// Было
AlertDialog(
  title: Text('Remove from favorites?'),
  content: Text('Are you sure...'),
  actions: [
    TextButton(child: Text('Cancel'), ...),
    TextButton(child: Text('Remove'), ...),
  ],
)

// Стало
AlertDialog(
  title: Text(AppLocalizations.get('remove_favorite_title', locale: currentLocale)),
  content: Text(AppLocalizations.get('remove_favorite_content', locale: currentLocale)),
  actions: [
    TextButton(
      child: Text(AppLocalizations.get('cancel', locale: currentLocale)), 
      ...
    ),
    TextButton(
      child: Text(AppLocalizations.get('remove', locale: currentLocale)), 
      ...
    ),
  ],
)
```

#### Пример 4: Form Label
```dart
// Было
TextField(label: Text('Email'), hint: Text('example@university.kz'))

// Стало
TextField(
  label: Text(AppLocalizations.get('email_label', locale: currentLocale)),
  hint: Text('example@university.kz')
)
```

### Как переключение языка работает:

1. **Пользователь открывает Settings** → видит текущий язык (English/Русский)
2. **Нажимает на "Language"** → открывается dialog с двумя вариантами
3. **Выбирает язык** → `LanguageProvider.setLocale()` вызывается
4. **Экран обновляется** → `context.watch<LanguageProvider>()` выполняет rebuild
5. **Все тексты меняются** → `AppLocalizations.get()` возвращает новые значения

### Добавление новых ключей локализации:

Когда найдёте новый текст в приложении:

1. Откройте `lib/localization/app_localizations.dart`
2. Добавьте ключ в оба языка (en и ru):
```dart
'new_key': 'English text',  // en
'new_key': 'Русский текст',  // ru
```
3. Используйте в коде:
```dart
Text(AppLocalizations.get('new_key', locale: currentLocale))
```

### Альтернативный синтаксис (Helper Extension):

Можно использовать helper extension для более короткого синтаксиса:

```dart
// Вместо:
AppLocalizations.get('edit_profile', locale: currentLocale)

// Используйте (если setup) примерно так:
// context.tr('edit_profile')  // будет требовать setup в main.dart
```

### Текущий статус локализации:

✅ **Готово:**
- Settings screen (100%)
- Language provider
- 50+ ключей локализации
- Theme provider интеграция

🟡 **В процессе:**
- Остальные экраны требуют интеграции

❌ **Не начато:**
- Constants (университеты, курсы, навыки)
- Comments (низкий приоритет)

### Следующие шаги:

1. Интегрировать локализацию в Favorites tab
2. Интегрировать в Edit Profile screen
3. Интегрировать в Create Announcement
4. Добавить ключи для констант (universities, skills, courses)
5. Протестировать все экраны с обоими языками
