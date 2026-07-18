// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get about => 'О приложении';

  @override
  String get about_link_max => 'MAX';

  @override
  String get about_link_privacy => 'Политика конфиденциальности';

  @override
  String get about_link_telegram => 'Telegram';

  @override
  String get about_link_terms => 'Пользовательское соглашение';

  @override
  String get about_link_website => 'Сайт';

  @override
  String get about_version => 'Версия 1.0';

  @override
  String get account_suspended => 'Аккаунт заблокирован';

  @override
  String get action_archive => 'В архив';

  @override
  String get action_cancel_send => 'Отменить';

  @override
  String get action_chat => 'Написать';

  @override
  String get action_copy => 'Копировать';

  @override
  String get action_copy_link => 'Скопировать ссылку';

  @override
  String get action_delete => 'Удалить';

  @override
  String get action_delete_chat => 'Удалить чат';

  @override
  String get action_edit => 'Изменить';

  @override
  String get action_mark_read => 'Прочитано';

  @override
  String get action_open_settings => 'Настройки';

  @override
  String get action_reply => 'Ответить';

  @override
  String get action_retry_send => 'Повторить';

  @override
  String get action_save => 'Сохранить';

  @override
  String get action_select => 'Выбрать';

  @override
  String get action_wipe_local_cache_confirm_body =>
      'Будут удалены офлайн-сообщения и загрузки для всех экземпляров сервера на этом устройстве. Неотправленные сообщения из очереди будут потеряны.';

  @override
  String get action_wipe_local_cache_confirm_title =>
      'Очистить локальные данные?';

  @override
  String get action_wipe_local_cache_done => 'Локальные данные очищены';

  @override
  String get action_wipe_local_cache_supporting =>
      'Удаляет кэш сообщений, медиа и отложенные отправки на этом устройстве. Аккаунт на сервере не затрагивается.';

  @override
  String get action_wipe_local_cache_title => 'Очистить локальные данные';

  @override
  String get api_port_label => 'Порт';

  @override
  String get app_desc =>
      '100% бесплатный и открытый мессенджер. Поддерживает self-hosted установку на своём сервере.';

  @override
  String get app_name => 'FromChat';

  @override
  String get as_system => 'Как на телефоне';

  @override
  String get attachment_image_load_failed => 'Не удалось загрузить';

  @override
  String get attachment_open_chooser_title => 'Открыть с помощью';

  @override
  String get attachment_open_failed =>
      'Не удалось открыть файл. Попробуйте «Сохранить» в меню сообщения.';

  @override
  String get attachment_retry => 'Повторить';

  @override
  String get attachment_upload_failed => 'Не удалось отправить файл';

  @override
  String get attachment_upload_failed_too_large =>
      'Файл слишком большой для отправки на этом устройстве';

  @override
  String auth_char_count(Object arg1, Object arg2) {
    return '$arg1/$arg2';
  }

  @override
  String get auth_get_started => 'Начать';

  @override
  String get auth_legal_notice_and => ' и ';

  @override
  String get auth_legal_notice_prefix => 'Регистрируясь, вы соглашаетесь с ';

  @override
  String get auth_rate_limit => 'Слишком много попыток. Попробуйте позже.';

  @override
  String get auth_server_connect_failed => 'Не удалось подключиться к серверу';

  @override
  String get auth_step_confirm_body => 'Введите тот же пароль ещё раз.';

  @override
  String get auth_step_confirm_title => 'Подтвердите пароль';

  @override
  String get auth_step_password_body =>
      'Мы войдём в аккаунт или создадим новый.';

  @override
  String get auth_step_password_title => 'Введите пароль';

  @override
  String get auth_step_profile_body =>
      'Введите ваше отображаемое имя и, если хотите, несколько слов о себе.';

  @override
  String get auth_step_profile_title => 'Создайте ваш профиль';

  @override
  String get auth_step_username_body =>
      'Это ваш логин. С помощью него мы сможем отличить вас от других людей.';

  @override
  String get auth_step_username_title => 'Введите имя пользователя';

  @override
  String get auth_username_taken =>
      'Это имя пользователя уже занято. Выберите другое.';

  @override
  String get auth_welcome_tagline =>
      '100% бесплатный мессенджер с открытым исходным кодом.';

  @override
  String get auth_welcome_title => 'Добро пожаловать в FromChat';

  @override
  String get auth_wrong_password => 'Неверный пароль';

  @override
  String get back => 'Назад';

  @override
  String get call_accept => 'Принять';

  @override
  String get call_decline => 'Отклонить';

  @override
  String get call_dismiss => 'ОК';

  @override
  String get call_failed_title => 'Не удалось соединить';

  @override
  String get call_incoming_subtitle => 'Входящий звонок';

  @override
  String get call_status_calling => 'Вызов…';

  @override
  String get call_status_connecting => 'Подключение…';

  @override
  String get call_status_in_call => 'Разговор';

  @override
  String get call_status_reconnecting => 'Переподключение…';

  @override
  String call_status_reconnecting_with_detail(Object arg1) {
    return 'Переподключение… $arg1';
  }

  @override
  String get call_status_starting => 'Запуск вызова…';

  @override
  String get calls_port_label => 'Порт звонков';

  @override
  String get cancel => 'Отмена';

  @override
  String get cd_account_blocked => 'Аккаунт заблокирован';

  @override
  String get cd_attachment_retry => 'Повторить загрузку изображения';

  @override
  String get cd_attachment_upload_retry => 'Повторить отправку файла';

  @override
  String get cd_call => 'Позвонить';

  @override
  String get cd_call_camera => 'Камера';

  @override
  String get cd_call_end => 'Завершить';

  @override
  String get cd_call_mic => 'Микрофон';

  @override
  String get cd_call_screenshare => 'Демонстрация экрана';

  @override
  String get cd_chat_preview_sending => 'Отправка сообщения';

  @override
  String get cd_chat_preview_uploading => 'Загрузка файла';

  @override
  String get cd_chat_selected => 'Выбрано';

  @override
  String get cd_close => 'Закрыть';

  @override
  String get cd_close_selection => 'Закрыть выбор';

  @override
  String get cd_emoji => 'Эмодзи';

  @override
  String get cd_message_send_failed => 'Сообщение не отправлено';

  @override
  String get cd_pick_file => 'Выбрать файл';

  @override
  String get cd_pick_image => 'Выбрать фото';

  @override
  String get cd_remove => 'Убрать';

  @override
  String get cd_selection_more => 'Ещё действия';

  @override
  String get cd_send => 'Отправить';

  @override
  String get cd_similar_verified => 'Похож на официальный аккаунт';

  @override
  String get cd_verified_account => 'Официальный аккаунт';

  @override
  String get change_server => 'Сменить сервер';

  @override
  String get change_server_d =>
      'Подключиться к альтернативному серверу FromChat и выйти из аккаунта.';

  @override
  String get chat_date_today => 'Сегодня';

  @override
  String get chat_date_yesterday => 'Вчера';

  @override
  String get chat_delete_confirm_body =>
      'Сообщения в выбранных чатах будут удалены с устройства и сервера.';

  @override
  String get chat_delete_confirm_title => 'Удалить чаты?';

  @override
  String chat_delete_partial_failure(Object arg1) {
    return 'Не удалось удалить чатов: $arg1';
  }

  @override
  String get chat_group_label => 'Группа';

  @override
  String get chat_last_mesaage => 'Вы: последнее сообщение';

  @override
  String chat_members_count(Object arg1) {
    return '$arg1 человек';
  }

  @override
  String get chat_preview_attachment => 'Вложение';

  @override
  String chat_preview_image(Object arg1) {
    return '$arg1 1 фото';
  }

  @override
  String get chat_preview_image_emoji => '📷';

  @override
  String get chat_scroll_to_bottom_cd => 'Прокрутить к новым сообщениям';

  @override
  String get chats => 'Чаты';

  @override
  String chats_selected_count(Object arg1) {
    return 'Выбрано чатов: $arg1';
  }

  @override
  String get coming_soon => 'Скоро…';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get confirm_password => 'Пароль ещё раз';

  @override
  String get contacts => 'Контакты';

  @override
  String get contacts_empty_body =>
      'Список контактов появится здесь, когда функция будет готова.';

  @override
  String get contacts_empty_title => 'Скоро';

  @override
  String get dark => 'Тёмное';

  @override
  String get debug_tools => 'Отладка API';

  @override
  String get debug_tools_d =>
      'Просмотр ответов API профиля и личных сообщений.';

  @override
  String get deleted_account => 'Удалённый аккаунт';

  @override
  String get display_name => 'Как вас видят другие';

  @override
  String get display_name_error => 'От 1 до 64 символов';

  @override
  String get dms => 'Личные чаты';

  @override
  String get error_connection => 'Не удалось подключиться. Проверьте интернет.';

  @override
  String get error_invalid_credentials =>
      'Неверное имя пользователя или пароль';

  @override
  String get error_unexpected => 'Что-то пошло не так';

  @override
  String get error_unknown => 'Что-то пошло не так. Попробуйте ещё раз.';

  @override
  String get feature_not_implemented => 'Пока не реализовано';

  @override
  String get fill_all_fields => 'Заполните все поля';

  @override
  String get hide_password => 'Скрыть пароль';

  @override
  String get home => 'Главная';

  @override
  String get https_enabled => 'Защищённое соединение';

  @override
  String get legal_document_cached_banner =>
      'Показана сохранённая копия документа. Содержимое может быть устаревшим.';

  @override
  String get legal_document_load_error =>
      'Не удалось загрузить документ. Проверьте подключение к интернету и попробуйте снова.';

  @override
  String get legal_privacy_title => 'Политика конфиденциальности';

  @override
  String get legal_terms_title => 'Пользовательское соглашение';

  @override
  String get light => 'Светлое';

  @override
  String get link_copied => 'Ссылка скопирована';

  @override
  String get login => 'Войти';

  @override
  String get login_d => 'Войдите в свой аккаунт';

  @override
  String get logout => 'Выйти';

  @override
  String get logs_browse_files_cd => 'Просмотр файлов журнала';

  @override
  String get logs_clean => 'Очистить журнал';

  @override
  String get logs_clean_all_body =>
      'Удаляет текущий файл журнала и все архивы.';

  @override
  String get logs_clean_apply => 'Очистить';

  @override
  String get logs_clean_date_body =>
      'Удаляет записи и архивы до выбранной даты (ваш часовой пояс).';

  @override
  String get logs_clean_date_day => 'День';

  @override
  String get logs_clean_date_month => 'Месяц';

  @override
  String get logs_clean_date_year => 'Год';

  @override
  String get logs_clean_entries_body =>
      'Оставляет только самые новые записи в текущем файле.';

  @override
  String logs_clean_entries_count(Object arg1) {
    return 'Оставить новых: $arg1';
  }

  @override
  String get logs_clean_mode_all => 'Удалить всё';

  @override
  String get logs_clean_mode_date => 'До даты';

  @override
  String get logs_clean_mode_entries => 'По числу записей';

  @override
  String get logs_clean_mode_size => 'По общему размеру';

  @override
  String get logs_clean_size_body =>
      'Удаляет старые архивы и записи, пока общий размер журнала не станет меньше лимита.';

  @override
  String logs_clean_size_mb(Object arg1) {
    return 'Лимит: $arg1 МБ';
  }

  @override
  String get logs_clean_title => 'Очистка журнала';

  @override
  String get logs_clear_all_cd => 'Очистить все файлы логов';

  @override
  String get logs_clear_all_confirm_body =>
      'Будут удалены текущий лог и все архивы.';

  @override
  String get logs_clear_all_confirm_title => 'Очистить все файлы логов?';

  @override
  String get logs_copied => 'Скопировано в буфер обмена';

  @override
  String get logs_decompressing => 'Распаковка…';

  @override
  String get logs_delete_file_confirm_body =>
      'Файл будет безвозвратно удалён с устройства.';

  @override
  String get logs_delete_file_confirm_title => 'Удалить файл журнала?';

  @override
  String logs_delete_files_confirm_body(Object arg1) {
    return 'Будет безвозвратно удалено файлов: $arg1.';
  }

  @override
  String get logs_delete_files_confirm_title =>
      'Удалить выбранные файлы журнала?';

  @override
  String get logs_empty => 'Записей пока нет';

  @override
  String logs_file_size_kb(Object arg1) {
    return '$arg1 КБ';
  }

  @override
  String logs_file_size_mb(Object arg1) {
    return '$arg1 МБ';
  }

  @override
  String get logs_files_title => 'Файлы журнала';

  @override
  String get logs_level_debug => 'debug';

  @override
  String get logs_level_error => 'error';

  @override
  String get logs_level_fatal => 'fatal';

  @override
  String get logs_level_info => 'info';

  @override
  String get logs_level_verbose => 'verbose';

  @override
  String get logs_level_warn => 'warning';

  @override
  String get logs_open => 'Открыть';

  @override
  String get logs_rotate => 'Ротация журнала';

  @override
  String get logs_rotate_confirm_body =>
      'Текущий журнал будет заархивирован и начнётся новый пустой файл.';

  @override
  String get logs_rotate_confirm_title => 'Ротировать файл журнала?';

  @override
  String get logs_scroll_to_bottom_cd => 'Прокрутить к последним записям';

  @override
  String get logs_search => 'Поиск';

  @override
  String get logs_search_hint => 'Поиск по записям журнала';

  @override
  String logs_selected_count(Object arg1) {
    return 'Выбрано: $arg1';
  }

  @override
  String get logs_share => 'Поделиться журналом';

  @override
  String get logs_share_compressed => 'Сжатый';

  @override
  String get logs_share_compressed_desc =>
      'Меньший размер, но нужен gzip для просмотра';

  @override
  String get logs_share_how_title => 'Как отправить журнал?';

  @override
  String get logs_share_uncompressed => 'Без сжатия';

  @override
  String get logs_share_uncompressed_desc =>
      'Проще читать без дополнительных программ';

  @override
  String get logs_title => 'Журнал';

  @override
  String get materialYou => 'Material You';

  @override
  String get materialYou_d =>
      'Цвета как на обоях. Работает с Android 12 и новее.';

  @override
  String get message_corrupted => 'Это сообщение не удалось показать.';

  @override
  String get message_corrupted_short => 'Сообщение не показывается';

  @override
  String get message_edited_suffix => '(изменено)';

  @override
  String get message_editing_title => 'Правка сообщения';

  @override
  String get message_placeholder => 'Напишите сообщение…';

  @override
  String get message_reply_jump_cd => 'Перейти к цитируемому сообщению';

  @override
  String get message_reply_photo => 'Фото';

  @override
  String message_replying_to(Object arg1) {
    return 'Ответ $arg1';
  }

  @override
  String get message_send_failed => 'Не удалось отправить';

  @override
  String get message_sender_you => 'Вы';

  @override
  String get month_apr => 'апр';

  @override
  String get month_aug => 'авг';

  @override
  String get month_dec => 'дек';

  @override
  String get month_feb => 'фев';

  @override
  String get month_jan => 'янв';

  @override
  String get month_jul => 'июл';

  @override
  String get month_jun => 'июн';

  @override
  String get month_mar => 'мар';

  @override
  String get month_may => 'май';

  @override
  String get month_name_apr => 'апреля';

  @override
  String get month_name_aug => 'августа';

  @override
  String get month_name_dec => 'декабря';

  @override
  String get month_name_feb => 'февраля';

  @override
  String get month_name_jan => 'января';

  @override
  String get month_name_jul => 'июля';

  @override
  String get month_name_jun => 'июня';

  @override
  String get month_name_mar => 'марта';

  @override
  String get month_name_may => 'мая';

  @override
  String get month_name_nov => 'ноября';

  @override
  String get month_name_oct => 'октября';

  @override
  String get month_name_sep => 'сентября';

  @override
  String get month_nov => 'ноя';

  @override
  String get month_oct => 'окт';

  @override
  String get month_sep => 'сен';

  @override
  String get more => 'Ещё';

  @override
  String get notif_call_channel_name => 'Активный звонок';

  @override
  String get notif_call_ongoing_text =>
      'Камера и микрофон остаются включёнными, пока вы вне приложения';

  @override
  String get notif_call_ongoing_title => 'Видеозвонок';

  @override
  String get notif_file_copy_channel_name => 'Сохранение файла';

  @override
  String get notif_file_copy_text => 'Копирование файла в фоне';

  @override
  String get notif_file_copy_title => 'Сохранение вложения';

  @override
  String get notif_file_download_channel_name => 'Загрузка файла';

  @override
  String notif_file_download_percent(Object arg1) {
    return '$arg1\\u0025';
  }

  @override
  String notif_file_download_progress(Object arg1, Object arg2) {
    return '$arg1 · $arg2';
  }

  @override
  String get notif_file_download_text => 'Загрузка продолжается в фоне';

  @override
  String get notif_file_download_title => 'Загрузка вложения';

  @override
  String get notif_media_upload_channel_name => 'Загрузка медиа';

  @override
  String notif_media_upload_percent(Object arg1) {
    return '$arg1\\u0025';
  }

  @override
  String notif_media_upload_progress(Object arg1, Object arg2) {
    return '$arg1 · $arg2';
  }

  @override
  String get notif_media_upload_text => 'Загрузка продолжается в фоне';

  @override
  String get notif_media_upload_title => 'Отправка вложения';

  @override
  String get notif_screenshare_text => 'Захват экрана активен для этого звонка';

  @override
  String get notif_screenshare_title => 'Демонстрация экрана';

  @override
  String get password => 'Пароль';

  @override
  String get password_length_error => 'Пароль — от 5 до 50 символов';

  @override
  String get passwords_dont_match => 'Пароли не совпадают';

  @override
  String presence_date_full(
    Object arg1,
    Object arg2,
    Object arg3,
    Object arg4,
  ) {
    return '$arg1 $arg2 $arg3 в $arg4';
  }

  @override
  String presence_date_this_year(Object arg1, Object arg2, Object arg3) {
    return '$arg1 $arg2 в $arg3';
  }

  @override
  String get presence_long_ago => 'был(а) давно';

  @override
  String get presence_online => 'В сети';

  @override
  String get presence_recently => 'Недавно заходил';

  @override
  String presence_today_at(Object arg1) {
    return 'Сегодня в $arg1';
  }

  @override
  String presence_weekday_at(Object arg1, Object arg2) {
    return '$arg1 в $arg2';
  }

  @override
  String presence_yesterday_at(Object arg1) {
    return 'Вчера в $arg1';
  }

  @override
  String get profile => 'Профиль';

  @override
  String get profile_action_call => 'Позвонить';

  @override
  String get profile_action_chat => 'Написать';

  @override
  String get profile_action_contact_info => 'Контактная информация';

  @override
  String get profile_action_link => 'Ссылка';

  @override
  String get profile_action_search => 'Поиск';

  @override
  String get profile_action_settings => 'Настройки';

  @override
  String get profile_action_video => 'Видео';

  @override
  String profile_bio_length_error(Object arg1) {
    return 'Не более $arg1 символов';
  }

  @override
  String get profile_details_category => 'О человеке';

  @override
  String get profile_edit_saved => 'Профиль обновлён';

  @override
  String get profile_edit_title => 'Изменить';

  @override
  String get profile_headline_bio => 'О себе';

  @override
  String get profile_headline_member_since => 'Дата регистрации';

  @override
  String get profile_headline_username => 'Имя пользователя';

  @override
  String get profile_headline_verification => 'Официальный аккаунт';

  @override
  String get profile_load_failed => 'Не получилось загрузить профиль';

  @override
  String get profile_not_found => 'Профиль не найден';

  @override
  String get profile_open_failed =>
      'Не удалось открыть профиль. Попробуйте снова.';

  @override
  String profile_registration_date(Object arg1, Object arg2, Object arg3) {
    return '$arg1 $arg2 $arg3';
  }

  @override
  String get profile_title => 'Профиль';

  @override
  String get profile_verified_support => 'Это официальный аккаунт';

  @override
  String get profile_verify_prompt_support =>
      'Нажмите, чтобы сделать аккаунт официальным (только админы)';

  @override
  String get public_chat => 'Общий чат';

  @override
  String get register => 'Регистрация';

  @override
  String get register_button => 'Создать аккаунт';

  @override
  String get register_d => 'Создать новый аккаунт';

  @override
  String get save_continue => 'Сохранить и продолжить';

  @override
  String get search_hint => 'Найдите пользователя, имя или чат';

  @override
  String get search_not_found => 'Ничего не найдено';

  @override
  String get search_not_found_message =>
      'Ничего не найдено. Попробуйте переформулировать запрос.';

  @override
  String get search_title => 'Поиск';

  @override
  String get server_config_action_check => 'Проверить';

  @override
  String get server_config_action_reset => 'Сбросить';

  @override
  String get server_config_action_reset_confirm_body =>
      'Будет восстановлен адрес сервера по умолчанию.';

  @override
  String get server_config_action_reset_confirm_title => 'Сбросить настройки?';

  @override
  String get server_config_checking => 'Проверка…';

  @override
  String get server_config_fab_reset => 'Сброс';

  @override
  String get server_config_fab_verify => 'Проверить сервер';

  @override
  String get server_config_host_error =>
      'Укажите хост или host:порт (порт по умолчанию — 443).';

  @override
  String get server_config_https_headline => 'HTTPS';

  @override
  String get server_config_https_hint =>
      'HTTPS. Отключайте только для HTTP без шифрования.';

  @override
  String get server_config_https_local_hint =>
      'Защищённое соединение. Если сервер локальный, скорее всего вам нужно это отключить.';

  @override
  String get server_config_port_error => 'Порт от 1 до 65535.';

  @override
  String get server_config_session_logged_out_no_instance =>
      'Сессия завершена: не удалось определить ID экземпляра сервера.';

  @override
  String get server_config_snackbar_api_fail =>
      'Не удалось подключиться к серверу.';

  @override
  String get server_config_snackbar_calls_fail => 'Звонки недоступны.';

  @override
  String get server_config_snackbar_defaults =>
      'Сброшено на значения по умолчанию.';

  @override
  String get server_config_snackbar_ok_api_calls_bad =>
      'Сервер OK; звонки не ответили.';

  @override
  String server_config_snackbar_ok_calls(Object arg1) {
    return 'Сервер доступен, звонки OK, пинг: $arg1 мс.';
  }

  @override
  String server_config_snackbar_ok_calls_skip(Object arg1) {
    return 'Сервер доступен (без звонков), пинг: $arg1 мс.';
  }

  @override
  String get server_config_snackbar_timeout =>
      'Сервер не ответил вовремя. Повторите попытку.';

  @override
  String get server_config_subtitle =>
      'Подключение к альтернативному серверу FromChat. Это дает больше приватности и контроля над данными.';

  @override
  String get server_config_title => 'Настройка сервера';

  @override
  String get server_config_unsupported_no_instance_id =>
      'Сервер не предоставляет корректный ID экземпляра. Подключение невозможно.';

  @override
  String get server_ip_hint => 'api.fromchat.ru или host:порт';

  @override
  String get server_ip_label => 'Сервер';

  @override
  String get settings => 'Настройки';

  @override
  String get settings_account_delete => 'Удалить аккаунт';

  @override
  String get settings_account_delete_confirm_body => 'Это нельзя отменить.';

  @override
  String get settings_account_delete_confirm_title => 'Удалить аккаунт?';

  @override
  String get settings_account_delete_d =>
      'Безвозвратно удалить аккаунт и данные';

  @override
  String get settings_account_deleted => 'Аккаунт удалён';

  @override
  String get settings_account_logout_confirm_body => 'Придётся войти снова.';

  @override
  String get settings_account_logout_confirm_title => 'Выйти?';

  @override
  String get settings_account_title => 'Аккаунт';

  @override
  String get settings_category_account => 'Аккаунт';

  @override
  String get settings_category_account_d => 'Выйти или удалить аккаунт';

  @override
  String get settings_category_appearance => 'Оформление';

  @override
  String get settings_category_appearance_d => 'Тема и Material You';

  @override
  String get settings_category_devices => 'Устройства';

  @override
  String get settings_category_devices_d => 'Активные сессии';

  @override
  String get settings_category_notifications => 'Уведомления';

  @override
  String get settings_category_notifications_d =>
      'Системные настройки уведомлений';

  @override
  String get settings_category_security => 'Безопасность';

  @override
  String get settings_category_security_d => 'Смена пароля';

  @override
  String get settings_category_server_tools => 'Сервер и инструменты';

  @override
  String get settings_category_server_tools_d => 'Смена сервера, отладка API';

  @override
  String get settings_change_password => 'Сменить пароль';

  @override
  String get settings_confirm_new_password => 'Новый пароль ещё раз';

  @override
  String get settings_current_password => 'Текущий пароль';

  @override
  String get settings_delete_account_button => 'Удалить аккаунт';

  @override
  String get settings_delete_confirm_phrase =>
      'я подтверждаю, что хочу удалить свой аккаунт';

  @override
  String settings_delete_confirm_phrase_instruction(Object arg1) {
    return 'Чтобы вы случайно не нажали кнопку, введите «$arg1» (без учёта регистра).';
  }

  @override
  String get settings_delete_confirm_phrase_quote =>
      'Я подтверждаю, что хочу удалить свой аккаунт';

  @override
  String get settings_delete_consequence_chat_history =>
      'Вы потеряете всю историю переписки.';

  @override
  String get settings_delete_consequence_messages =>
      'Отправленные вами сообщения будут анонимизированы.';

  @override
  String get settings_delete_consequence_permanent =>
      'Это действие нельзя отменить.';

  @override
  String get settings_delete_consequence_username =>
      'Ваше имя пользователя станет доступным всем, и его сможет занять любой.';

  @override
  String get settings_delete_step_final_body =>
      'Ваш аккаунт будет удалён НАВСЕГДА и его НЕВОЗМОЖНО восстановить. Вы выйдете на всех устройствах и сразу потеряете доступ.';

  @override
  String get settings_delete_step_final_title => 'Последнее предупреждение';

  @override
  String get settings_delete_step_intro_body =>
      'Ваш аккаунт будет удалён навсегда. Если вы подтвердите действие, произойдёт следующее:';

  @override
  String get settings_delete_step_intro_title => 'Удалить аккаунт?';

  @override
  String get settings_delete_step_password_body =>
      'Введите пароль, чтобы продолжить.';

  @override
  String get settings_delete_step_password_title => 'Подтвердите пароль';

  @override
  String get settings_devices_active_sessions => 'Активные сеансы';

  @override
  String get settings_devices_current_hint => 'Вы вошли на этом устройстве.';

  @override
  String get settings_devices_empty => 'Нет активных сессий';

  @override
  String get settings_devices_empty_sub =>
      'Когда вы войдёте с других телефонов или в браузере, они появятся здесь.';

  @override
  String get settings_devices_field_brand => 'Бренд';

  @override
  String get settings_devices_field_browser => 'Браузер';

  @override
  String get settings_devices_field_browser_version => 'Версия браузера';

  @override
  String get settings_devices_field_device_name => 'Имя устройства';

  @override
  String get settings_devices_field_device_type => 'Тип устройства';

  @override
  String get settings_devices_field_last_active => 'Активность';

  @override
  String get settings_devices_field_model => 'Модель';

  @override
  String get settings_devices_field_os => 'Система';

  @override
  String get settings_devices_field_os_version => 'Версия системы';

  @override
  String get settings_devices_field_session_id => 'ID сессии';

  @override
  String get settings_devices_field_signed_in => 'Вход';

  @override
  String settings_devices_last_active(Object arg1) {
    return 'Активность: $arg1';
  }

  @override
  String get settings_devices_logout_all => 'Выйти на всех других устройствах';

  @override
  String get settings_devices_logout_all_confirm_body =>
      'Вы останетесь в аккаунте только на этом устройстве.';

  @override
  String get settings_devices_logout_all_confirm_title =>
      'Выйти везде, кроме этого?';

  @override
  String get settings_devices_revoke => 'Выйти';

  @override
  String get settings_devices_sheet_title => 'Сведения о сессии';

  @override
  String get settings_devices_sign_out_sheet => 'Выйти на этом устройстве';

  @override
  String get settings_devices_signing_out => 'Выход…';

  @override
  String get settings_devices_this_device => 'Это устройство';

  @override
  String get settings_devices_title => 'Устройства';

  @override
  String get settings_devices_unknown => 'Неизвестное устройство';

  @override
  String get settings_hub_about_sub => 'Версия, ссылки и другое';

  @override
  String get settings_hub_logs_sub => 'Просмотр, отправка и очистка журнала';

  @override
  String get settings_logout_other_sessions =>
      'Выйти на всех других устройствах после смены';

  @override
  String get settings_new_password => 'Новый пароль';

  @override
  String get settings_next => 'Далее';

  @override
  String get settings_notification_settings => 'Настройки уведомлений';

  @override
  String get settings_notification_settings_d =>
      'Здесь вы можете включить или выключить типы уведомлений, изменить звук и т.д.';

  @override
  String get settings_notifications_permission_required =>
      'Откройте системные настройки и разрешите уведомления.';

  @override
  String get settings_notifications_title => 'Уведомления';

  @override
  String get settings_password_changed => 'Пароль обновлён';

  @override
  String get settings_push_notifications => 'Push-уведомления';

  @override
  String get settings_push_notifications_d =>
      'Они помогут вам узнать, если появилось новое сообщение пока приложение закрыто.';

  @override
  String get settings_security_change_password_sub =>
      'Обновите пароль для входа';

  @override
  String get settings_security_step_confirm_body =>
      'Введите новый пароль ещё раз, чтобы убедиться, что без ошибок.';

  @override
  String get settings_security_step_confirm_title => 'Подтверждение пароля';

  @override
  String get settings_security_step_current_body =>
      'Введите пароль, которым пользуетесь сейчас.';

  @override
  String get settings_security_step_current_title => 'Текущий пароль';

  @override
  String get settings_security_step_new_body =>
      'Придумайте надёжный пароль, который вы здесь ещё не использовали.';

  @override
  String get settings_security_step_new_title => 'Новый пароль';

  @override
  String get settings_security_title => 'Безопасность';

  @override
  String get show_password => 'Показать пароль';

  @override
  String get status_connecting => 'Соединение';

  @override
  String get status_updating => 'Обновление';

  @override
  String get suspend_chat_banner_message => 'Ваш аккаунт был заблокирован';

  @override
  String get suspended_default_reason =>
      'Причина не указана. Доступ к отправке временно отключён.';

  @override
  String get suspended_sheet_action_contact_support => 'Связаться с поддержкой';

  @override
  String get suspended_sheet_desc =>
      'Ваш аккаунт заблокирован за нарушение правил.\\nСейчас вы можете читать чаты, но отправка новых сообщений временно отключена.\\nЕсли вы считаете, что это ошибка, свяжитесь с поддержкой и мы поможем разобраться.';

  @override
  String get suspended_sheet_reason_label => 'Причина';

  @override
  String get suspended_sheet_title => 'Аккаунт заблокирован';

  @override
  String get theme => 'Оформление';

  @override
  String get typing_alone => 'печатает…';

  @override
  String typing_many(Object arg1, Object arg2, Object arg3) {
    return '$arg1, $arg2 и ещё $arg3 печатают…';
  }

  @override
  String typing_single(Object arg1) {
    return '$arg1 печатает…';
  }

  @override
  String typing_two(Object arg1, Object arg2) {
    return '$arg1 и $arg2 печатают…';
  }

  @override
  String get unknown => 'Неизвестно';

  @override
  String unread_count(Object arg1) {
    return '+$arg1';
  }

  @override
  String unread_count_badge(Object arg1) {
    return '$arg1';
  }

  @override
  String get unread_count_overflow => '99+';

  @override
  String get unverify => 'Снять официальный статус';

  @override
  String get username => 'Имя пользователя';

  @override
  String get username_length_error => 'Имя пользователя — от 3 до 20 символов';

  @override
  String get verify => 'Сделать официальным';

  @override
  String get weekday_fri => 'пятница';

  @override
  String get weekday_mon => 'понедельник';

  @override
  String get weekday_sat => 'суббота';

  @override
  String get weekday_sun => 'воскресенье';

  @override
  String get weekday_thu => 'четверг';

  @override
  String get weekday_tue => 'вторник';

  @override
  String get weekday_wed => 'среда';

  @override
  String get welcome => 'Добро пожаловать!';
}
