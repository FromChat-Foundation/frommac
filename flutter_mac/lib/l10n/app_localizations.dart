import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @about_link_max.
  ///
  /// In en, this message translates to:
  /// **'MAX'**
  String get about_link_max;

  /// No description provided for @about_link_privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get about_link_privacy;

  /// No description provided for @about_link_telegram.
  ///
  /// In en, this message translates to:
  /// **'Telegram'**
  String get about_link_telegram;

  /// No description provided for @about_link_terms.
  ///
  /// In en, this message translates to:
  /// **'Terms of service'**
  String get about_link_terms;

  /// No description provided for @about_link_website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get about_link_website;

  /// No description provided for @about_version.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0'**
  String get about_version;

  /// No description provided for @account_suspended.
  ///
  /// In en, this message translates to:
  /// **'Account suspended'**
  String get account_suspended;

  /// No description provided for @action_archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get action_archive;

  /// No description provided for @action_cancel_send.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get action_cancel_send;

  /// No description provided for @action_chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get action_chat;

  /// No description provided for @action_copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get action_copy;

  /// No description provided for @action_copy_link.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get action_copy_link;

  /// No description provided for @action_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get action_delete;

  /// No description provided for @action_delete_chat.
  ///
  /// In en, this message translates to:
  /// **'Delete chat'**
  String get action_delete_chat;

  /// No description provided for @action_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get action_edit;

  /// No description provided for @action_mark_read.
  ///
  /// In en, this message translates to:
  /// **'Mark as read'**
  String get action_mark_read;

  /// No description provided for @action_open_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get action_open_settings;

  /// No description provided for @action_reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get action_reply;

  /// No description provided for @action_retry_send.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get action_retry_send;

  /// No description provided for @action_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get action_save;

  /// No description provided for @action_select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get action_select;

  /// No description provided for @action_wipe_local_cache_confirm_body.
  ///
  /// In en, this message translates to:
  /// **'All offline messages and downloads for every server instance on this device will be deleted. Unsent messages in the outbox will be lost.'**
  String get action_wipe_local_cache_confirm_body;

  /// No description provided for @action_wipe_local_cache_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Clear local data?'**
  String get action_wipe_local_cache_confirm_title;

  /// No description provided for @action_wipe_local_cache_done.
  ///
  /// In en, this message translates to:
  /// **'Local data cleared'**
  String get action_wipe_local_cache_done;

  /// No description provided for @action_wipe_local_cache_supporting.
  ///
  /// In en, this message translates to:
  /// **'Removes cached messages, media, and pending sends on this device. Your account on the server is not affected.'**
  String get action_wipe_local_cache_supporting;

  /// No description provided for @action_wipe_local_cache_title.
  ///
  /// In en, this message translates to:
  /// **'Clear local data'**
  String get action_wipe_local_cache_title;

  /// No description provided for @api_port_label.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get api_port_label;

  /// No description provided for @app_desc.
  ///
  /// In en, this message translates to:
  /// **'100% free and open messenger. Supports self-hosted installation on your own server.'**
  String get app_desc;

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'FromChat'**
  String get app_name;

  /// No description provided for @as_system.
  ///
  /// In en, this message translates to:
  /// **'Same as phone'**
  String get as_system;

  /// No description provided for @attachment_image_load_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load'**
  String get attachment_image_load_failed;

  /// No description provided for @attachment_open_chooser_title.
  ///
  /// In en, this message translates to:
  /// **'Open with'**
  String get attachment_open_chooser_title;

  /// No description provided for @attachment_open_failed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open this file. Try Save from the message menu.'**
  String get attachment_open_failed;

  /// No description provided for @attachment_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get attachment_retry;

  /// No description provided for @attachment_upload_failed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send file'**
  String get attachment_upload_failed;

  /// No description provided for @attachment_upload_failed_too_large.
  ///
  /// In en, this message translates to:
  /// **'File is too large to send on this device'**
  String get attachment_upload_failed_too_large;

  /// No description provided for @auth_char_count.
  ///
  /// In en, this message translates to:
  /// **'{arg1}/{arg2}'**
  String auth_char_count(Object arg1, Object arg2);

  /// No description provided for @auth_get_started.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get auth_get_started;

  /// No description provided for @auth_legal_notice_and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get auth_legal_notice_and;

  /// No description provided for @auth_legal_notice_prefix.
  ///
  /// In en, this message translates to:
  /// **'By creating an account you agree to the '**
  String get auth_legal_notice_prefix;

  /// No description provided for @auth_rate_limit.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again later.'**
  String get auth_rate_limit;

  /// No description provided for @auth_server_connect_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to connect to the server'**
  String get auth_server_connect_failed;

  /// No description provided for @auth_step_confirm_body.
  ///
  /// In en, this message translates to:
  /// **'Enter the same password again.'**
  String get auth_step_confirm_body;

  /// No description provided for @auth_step_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get auth_step_confirm_title;

  /// No description provided for @auth_step_password_body.
  ///
  /// In en, this message translates to:
  /// **'We will sign you in or create a new account.'**
  String get auth_step_password_body;

  /// No description provided for @auth_step_password_title.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get auth_step_password_title;

  /// No description provided for @auth_step_profile_body.
  ///
  /// In en, this message translates to:
  /// **'Enter your display name and, if you like, a few words about yourself.'**
  String get auth_step_profile_body;

  /// No description provided for @auth_step_profile_title.
  ///
  /// In en, this message translates to:
  /// **'Create your profile'**
  String get auth_step_profile_title;

  /// No description provided for @auth_step_username_body.
  ///
  /// In en, this message translates to:
  /// **'This is your login. It helps us tell you apart from everyone else.'**
  String get auth_step_username_body;

  /// No description provided for @auth_step_username_title.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get auth_step_username_title;

  /// No description provided for @auth_username_taken.
  ///
  /// In en, this message translates to:
  /// **'This username was just taken. Please choose another one.'**
  String get auth_username_taken;

  /// No description provided for @auth_welcome_tagline.
  ///
  /// In en, this message translates to:
  /// **'The 100% free and open source messenger.'**
  String get auth_welcome_tagline;

  /// No description provided for @auth_welcome_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome to FromChat'**
  String get auth_welcome_title;

  /// No description provided for @auth_wrong_password.
  ///
  /// In en, this message translates to:
  /// **'Wrong password'**
  String get auth_wrong_password;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @call_accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get call_accept;

  /// No description provided for @call_decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get call_decline;

  /// No description provided for @call_dismiss.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get call_dismiss;

  /// No description provided for @call_failed_title.
  ///
  /// In en, this message translates to:
  /// **'Could not connect'**
  String get call_failed_title;

  /// No description provided for @call_incoming_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Incoming call'**
  String get call_incoming_subtitle;

  /// No description provided for @call_status_calling.
  ///
  /// In en, this message translates to:
  /// **'Calling…'**
  String get call_status_calling;

  /// No description provided for @call_status_connecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get call_status_connecting;

  /// No description provided for @call_status_in_call.
  ///
  /// In en, this message translates to:
  /// **'In call'**
  String get call_status_in_call;

  /// No description provided for @call_status_reconnecting.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting…'**
  String get call_status_reconnecting;

  /// No description provided for @call_status_reconnecting_with_detail.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting… {arg1}'**
  String call_status_reconnecting_with_detail(Object arg1);

  /// No description provided for @call_status_starting.
  ///
  /// In en, this message translates to:
  /// **'Starting call…'**
  String get call_status_starting;

  /// No description provided for @calls_port_label.
  ///
  /// In en, this message translates to:
  /// **'Calls port'**
  String get calls_port_label;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @cd_account_blocked.
  ///
  /// In en, this message translates to:
  /// **'Account blocked'**
  String get cd_account_blocked;

  /// No description provided for @cd_attachment_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry loading image'**
  String get cd_attachment_retry;

  /// No description provided for @cd_attachment_upload_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry sending file'**
  String get cd_attachment_upload_retry;

  /// No description provided for @cd_call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get cd_call;

  /// No description provided for @cd_call_camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get cd_call_camera;

  /// No description provided for @cd_call_end.
  ///
  /// In en, this message translates to:
  /// **'End call'**
  String get cd_call_end;

  /// No description provided for @cd_call_mic.
  ///
  /// In en, this message translates to:
  /// **'Microphone'**
  String get cd_call_mic;

  /// No description provided for @cd_call_screenshare.
  ///
  /// In en, this message translates to:
  /// **'Share screen'**
  String get cd_call_screenshare;

  /// No description provided for @cd_chat_preview_sending.
  ///
  /// In en, this message translates to:
  /// **'Sending message'**
  String get cd_chat_preview_sending;

  /// No description provided for @cd_chat_preview_uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading file'**
  String get cd_chat_preview_uploading;

  /// No description provided for @cd_chat_selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get cd_chat_selected;

  /// No description provided for @cd_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get cd_close;

  /// No description provided for @cd_close_selection.
  ///
  /// In en, this message translates to:
  /// **'Close selection'**
  String get cd_close_selection;

  /// No description provided for @cd_emoji.
  ///
  /// In en, this message translates to:
  /// **'Emoji'**
  String get cd_emoji;

  /// No description provided for @cd_message_send_failed.
  ///
  /// In en, this message translates to:
  /// **'Message failed to send'**
  String get cd_message_send_failed;

  /// No description provided for @cd_pick_file.
  ///
  /// In en, this message translates to:
  /// **'Choose file'**
  String get cd_pick_file;

  /// No description provided for @cd_pick_image.
  ///
  /// In en, this message translates to:
  /// **'Choose photo'**
  String get cd_pick_image;

  /// No description provided for @cd_remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get cd_remove;

  /// No description provided for @cd_selection_more.
  ///
  /// In en, this message translates to:
  /// **'More actions'**
  String get cd_selection_more;

  /// No description provided for @cd_send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get cd_send;

  /// No description provided for @cd_similar_verified.
  ///
  /// In en, this message translates to:
  /// **'May be a verified account'**
  String get cd_similar_verified;

  /// No description provided for @cd_verified_account.
  ///
  /// In en, this message translates to:
  /// **'Verified account'**
  String get cd_verified_account;

  /// No description provided for @change_server.
  ///
  /// In en, this message translates to:
  /// **'Change server'**
  String get change_server;

  /// No description provided for @change_server_d.
  ///
  /// In en, this message translates to:
  /// **'Connect to an alternative FromChat server and sign out.'**
  String get change_server_d;

  /// No description provided for @chat_date_today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get chat_date_today;

  /// No description provided for @chat_date_yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get chat_date_yesterday;

  /// No description provided for @chat_delete_confirm_body.
  ///
  /// In en, this message translates to:
  /// **'Messages in selected chats will be deleted from this device and the server.'**
  String get chat_delete_confirm_body;

  /// No description provided for @chat_delete_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Delete chats?'**
  String get chat_delete_confirm_title;

  /// No description provided for @chat_delete_partial_failure.
  ///
  /// In en, this message translates to:
  /// **'Could not delete {arg1} chat(s)'**
  String chat_delete_partial_failure(Object arg1);

  /// No description provided for @chat_group_label.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get chat_group_label;

  /// No description provided for @chat_last_mesaage.
  ///
  /// In en, this message translates to:
  /// **'You: last message'**
  String get chat_last_mesaage;

  /// No description provided for @chat_members_count.
  ///
  /// In en, this message translates to:
  /// **'{arg1} people'**
  String chat_members_count(Object arg1);

  /// No description provided for @chat_preview_attachment.
  ///
  /// In en, this message translates to:
  /// **'Attachment'**
  String get chat_preview_attachment;

  /// No description provided for @chat_preview_image.
  ///
  /// In en, this message translates to:
  /// **'{arg1} 1 photo'**
  String chat_preview_image(Object arg1);

  /// No description provided for @chat_preview_image_emoji.
  ///
  /// In en, this message translates to:
  /// **'📷'**
  String get chat_preview_image_emoji;

  /// No description provided for @chat_scroll_to_bottom_cd.
  ///
  /// In en, this message translates to:
  /// **'Scroll to latest messages'**
  String get chat_scroll_to_bottom_cd;

  /// No description provided for @chats.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chats;

  /// No description provided for @chats_selected_count.
  ///
  /// In en, this message translates to:
  /// **'{arg1} chats selected'**
  String chats_selected_count(Object arg1);

  /// No description provided for @coming_soon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon…'**
  String get coming_soon;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Password again'**
  String get confirm_password;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @contacts_empty_body.
  ///
  /// In en, this message translates to:
  /// **'Your contacts will appear here when this feature is ready.'**
  String get contacts_empty_body;

  /// No description provided for @contacts_empty_title.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get contacts_empty_title;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @debug_tools.
  ///
  /// In en, this message translates to:
  /// **'Debug API'**
  String get debug_tools;

  /// No description provided for @debug_tools_d.
  ///
  /// In en, this message translates to:
  /// **'Inspect profile and DM endpoints used by the client.'**
  String get debug_tools_d;

  /// No description provided for @deleted_account.
  ///
  /// In en, this message translates to:
  /// **'Deleted account'**
  String get deleted_account;

  /// No description provided for @display_name.
  ///
  /// In en, this message translates to:
  /// **'Name shown to others'**
  String get display_name;

  /// No description provided for @display_name_error.
  ///
  /// In en, this message translates to:
  /// **'Use between 1 and 64 characters'**
  String get display_name_error;

  /// No description provided for @dms.
  ///
  /// In en, this message translates to:
  /// **'Private chats'**
  String get dms;

  /// No description provided for @error_connection.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t connect. Check your internet.'**
  String get error_connection;

  /// No description provided for @error_invalid_credentials.
  ///
  /// In en, this message translates to:
  /// **'Wrong username or password'**
  String get error_invalid_credentials;

  /// No description provided for @error_unexpected.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get error_unexpected;

  /// No description provided for @error_unknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get error_unknown;

  /// No description provided for @feature_not_implemented.
  ///
  /// In en, this message translates to:
  /// **'Not implemented yet'**
  String get feature_not_implemented;

  /// No description provided for @fill_all_fields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in every field'**
  String get fill_all_fields;

  /// No description provided for @hide_password.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hide_password;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @https_enabled.
  ///
  /// In en, this message translates to:
  /// **'Secure connection'**
  String get https_enabled;

  /// No description provided for @legal_document_cached_banner.
  ///
  /// In en, this message translates to:
  /// **'Showing a saved copy. Content may be out of date.'**
  String get legal_document_cached_banner;

  /// No description provided for @legal_document_load_error.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the document. Check your connection and try again.'**
  String get legal_document_load_error;

  /// No description provided for @legal_privacy_title.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get legal_privacy_title;

  /// No description provided for @legal_terms_title.
  ///
  /// In en, this message translates to:
  /// **'Terms of service'**
  String get legal_terms_title;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @link_copied.
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get link_copied;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @login_d.
  ///
  /// In en, this message translates to:
  /// **'Log in to your account'**
  String get login_d;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @logs_browse_files_cd.
  ///
  /// In en, this message translates to:
  /// **'Browse log files'**
  String get logs_browse_files_cd;

  /// No description provided for @logs_clean.
  ///
  /// In en, this message translates to:
  /// **'Clean logs'**
  String get logs_clean;

  /// No description provided for @logs_clean_all_body.
  ///
  /// In en, this message translates to:
  /// **'Deletes the current log file and all rotated archives.'**
  String get logs_clean_all_body;

  /// No description provided for @logs_clean_apply.
  ///
  /// In en, this message translates to:
  /// **'Clean'**
  String get logs_clean_apply;

  /// No description provided for @logs_clean_date_body.
  ///
  /// In en, this message translates to:
  /// **'Delete entries and archives before the selected date (your time zone).'**
  String get logs_clean_date_body;

  /// No description provided for @logs_clean_date_day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get logs_clean_date_day;

  /// No description provided for @logs_clean_date_month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get logs_clean_date_month;

  /// No description provided for @logs_clean_date_year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get logs_clean_date_year;

  /// No description provided for @logs_clean_entries_body.
  ///
  /// In en, this message translates to:
  /// **'Keep only the newest entries in the current log file.'**
  String get logs_clean_entries_body;

  /// No description provided for @logs_clean_entries_count.
  ///
  /// In en, this message translates to:
  /// **'Keep newest: {arg1}'**
  String logs_clean_entries_count(Object arg1);

  /// No description provided for @logs_clean_mode_all.
  ///
  /// In en, this message translates to:
  /// **'Delete everything'**
  String get logs_clean_mode_all;

  /// No description provided for @logs_clean_mode_date.
  ///
  /// In en, this message translates to:
  /// **'Before date'**
  String get logs_clean_mode_date;

  /// No description provided for @logs_clean_mode_entries.
  ///
  /// In en, this message translates to:
  /// **'By entry count'**
  String get logs_clean_mode_entries;

  /// No description provided for @logs_clean_mode_size.
  ///
  /// In en, this message translates to:
  /// **'By total size'**
  String get logs_clean_mode_size;

  /// No description provided for @logs_clean_size_body.
  ///
  /// In en, this message translates to:
  /// **'Delete oldest archives and entries until total log storage is below the limit.'**
  String get logs_clean_size_body;

  /// No description provided for @logs_clean_size_mb.
  ///
  /// In en, this message translates to:
  /// **'Limit: {arg1} MB'**
  String logs_clean_size_mb(Object arg1);

  /// No description provided for @logs_clean_title.
  ///
  /// In en, this message translates to:
  /// **'Clean logs'**
  String get logs_clean_title;

  /// No description provided for @logs_clear_all_cd.
  ///
  /// In en, this message translates to:
  /// **'Clear all log files'**
  String get logs_clear_all_cd;

  /// No description provided for @logs_clear_all_confirm_body.
  ///
  /// In en, this message translates to:
  /// **'This deletes the current log and all rotated archives.'**
  String get logs_clear_all_confirm_body;

  /// No description provided for @logs_clear_all_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Clear all log files?'**
  String get logs_clear_all_confirm_title;

  /// No description provided for @logs_copied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get logs_copied;

  /// No description provided for @logs_decompressing.
  ///
  /// In en, this message translates to:
  /// **'Decompressing…'**
  String get logs_decompressing;

  /// No description provided for @logs_delete_file_confirm_body.
  ///
  /// In en, this message translates to:
  /// **'This file will be permanently removed from the device.'**
  String get logs_delete_file_confirm_body;

  /// No description provided for @logs_delete_file_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Delete log file?'**
  String get logs_delete_file_confirm_title;

  /// No description provided for @logs_delete_files_confirm_body.
  ///
  /// In en, this message translates to:
  /// **'{arg1} files will be permanently removed from the device.'**
  String logs_delete_files_confirm_body(Object arg1);

  /// No description provided for @logs_delete_files_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Delete selected log files?'**
  String get logs_delete_files_confirm_title;

  /// No description provided for @logs_empty.
  ///
  /// In en, this message translates to:
  /// **'No log entries yet'**
  String get logs_empty;

  /// No description provided for @logs_file_size_kb.
  ///
  /// In en, this message translates to:
  /// **'{arg1} KB'**
  String logs_file_size_kb(Object arg1);

  /// No description provided for @logs_file_size_mb.
  ///
  /// In en, this message translates to:
  /// **'{arg1} MB'**
  String logs_file_size_mb(Object arg1);

  /// No description provided for @logs_files_title.
  ///
  /// In en, this message translates to:
  /// **'Log files'**
  String get logs_files_title;

  /// No description provided for @logs_level_debug.
  ///
  /// In en, this message translates to:
  /// **'debug'**
  String get logs_level_debug;

  /// No description provided for @logs_level_error.
  ///
  /// In en, this message translates to:
  /// **'error'**
  String get logs_level_error;

  /// No description provided for @logs_level_fatal.
  ///
  /// In en, this message translates to:
  /// **'fatal'**
  String get logs_level_fatal;

  /// No description provided for @logs_level_info.
  ///
  /// In en, this message translates to:
  /// **'info'**
  String get logs_level_info;

  /// No description provided for @logs_level_verbose.
  ///
  /// In en, this message translates to:
  /// **'verbose'**
  String get logs_level_verbose;

  /// No description provided for @logs_level_warn.
  ///
  /// In en, this message translates to:
  /// **'warning'**
  String get logs_level_warn;

  /// No description provided for @logs_open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get logs_open;

  /// No description provided for @logs_rotate.
  ///
  /// In en, this message translates to:
  /// **'Rotate logs'**
  String get logs_rotate;

  /// No description provided for @logs_rotate_confirm_body.
  ///
  /// In en, this message translates to:
  /// **'The current log will be archived and a new empty log file will be started.'**
  String get logs_rotate_confirm_body;

  /// No description provided for @logs_rotate_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Rotate log file?'**
  String get logs_rotate_confirm_title;

  /// No description provided for @logs_scroll_to_bottom_cd.
  ///
  /// In en, this message translates to:
  /// **'Scroll to latest logs'**
  String get logs_scroll_to_bottom_cd;

  /// No description provided for @logs_search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get logs_search;

  /// No description provided for @logs_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search log entries'**
  String get logs_search_hint;

  /// No description provided for @logs_selected_count.
  ///
  /// In en, this message translates to:
  /// **'{arg1} selected'**
  String logs_selected_count(Object arg1);

  /// No description provided for @logs_share.
  ///
  /// In en, this message translates to:
  /// **'Share logs'**
  String get logs_share;

  /// No description provided for @logs_share_compressed.
  ///
  /// In en, this message translates to:
  /// **'Compressed'**
  String get logs_share_compressed;

  /// No description provided for @logs_share_compressed_desc.
  ///
  /// In en, this message translates to:
  /// **'Smaller file size, but requires gzip to view'**
  String get logs_share_compressed_desc;

  /// No description provided for @logs_share_how_title.
  ///
  /// In en, this message translates to:
  /// **'How do you want to send the logs?'**
  String get logs_share_how_title;

  /// No description provided for @logs_share_uncompressed.
  ///
  /// In en, this message translates to:
  /// **'Uncompressed'**
  String get logs_share_uncompressed;

  /// No description provided for @logs_share_uncompressed_desc.
  ///
  /// In en, this message translates to:
  /// **'Easier to read without any additional software'**
  String get logs_share_uncompressed_desc;

  /// No description provided for @logs_title.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get logs_title;

  /// No description provided for @materialYou.
  ///
  /// In en, this message translates to:
  /// **'Material You'**
  String get materialYou;

  /// No description provided for @materialYou_d.
  ///
  /// In en, this message translates to:
  /// **'Match colors to your wallpaper. Works on Android 12 and up.'**
  String get materialYou_d;

  /// No description provided for @message_corrupted.
  ///
  /// In en, this message translates to:
  /// **'This message could not be shown.'**
  String get message_corrupted;

  /// No description provided for @message_corrupted_short.
  ///
  /// In en, this message translates to:
  /// **'Can’t show this message'**
  String get message_corrupted_short;

  /// No description provided for @message_edited_suffix.
  ///
  /// In en, this message translates to:
  /// **'(edited)'**
  String get message_edited_suffix;

  /// No description provided for @message_editing_title.
  ///
  /// In en, this message translates to:
  /// **'Edit message'**
  String get message_editing_title;

  /// No description provided for @message_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Write a message…'**
  String get message_placeholder;

  /// No description provided for @message_reply_jump_cd.
  ///
  /// In en, this message translates to:
  /// **'Jump to quoted message'**
  String get message_reply_jump_cd;

  /// No description provided for @message_reply_photo.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get message_reply_photo;

  /// No description provided for @message_replying_to.
  ///
  /// In en, this message translates to:
  /// **'Reply to {arg1}'**
  String message_replying_to(Object arg1);

  /// No description provided for @message_send_failed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send'**
  String get message_send_failed;

  /// No description provided for @message_sender_you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get message_sender_you;

  /// No description provided for @month_apr.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get month_apr;

  /// No description provided for @month_aug.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get month_aug;

  /// No description provided for @month_dec.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get month_dec;

  /// No description provided for @month_feb.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get month_feb;

  /// No description provided for @month_jan.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get month_jan;

  /// No description provided for @month_jul.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get month_jul;

  /// No description provided for @month_jun.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get month_jun;

  /// No description provided for @month_mar.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get month_mar;

  /// No description provided for @month_may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get month_may;

  /// No description provided for @month_name_apr.
  ///
  /// In en, this message translates to:
  /// **'april'**
  String get month_name_apr;

  /// No description provided for @month_name_aug.
  ///
  /// In en, this message translates to:
  /// **'august'**
  String get month_name_aug;

  /// No description provided for @month_name_dec.
  ///
  /// In en, this message translates to:
  /// **'december'**
  String get month_name_dec;

  /// No description provided for @month_name_feb.
  ///
  /// In en, this message translates to:
  /// **'february'**
  String get month_name_feb;

  /// No description provided for @month_name_jan.
  ///
  /// In en, this message translates to:
  /// **'january'**
  String get month_name_jan;

  /// No description provided for @month_name_jul.
  ///
  /// In en, this message translates to:
  /// **'july'**
  String get month_name_jul;

  /// No description provided for @month_name_jun.
  ///
  /// In en, this message translates to:
  /// **'june'**
  String get month_name_jun;

  /// No description provided for @month_name_mar.
  ///
  /// In en, this message translates to:
  /// **'march'**
  String get month_name_mar;

  /// No description provided for @month_name_may.
  ///
  /// In en, this message translates to:
  /// **'may'**
  String get month_name_may;

  /// No description provided for @month_name_nov.
  ///
  /// In en, this message translates to:
  /// **'november'**
  String get month_name_nov;

  /// No description provided for @month_name_oct.
  ///
  /// In en, this message translates to:
  /// **'october'**
  String get month_name_oct;

  /// No description provided for @month_name_sep.
  ///
  /// In en, this message translates to:
  /// **'september'**
  String get month_name_sep;

  /// No description provided for @month_nov.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get month_nov;

  /// No description provided for @month_oct.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get month_oct;

  /// No description provided for @month_sep.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get month_sep;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @notif_call_channel_name.
  ///
  /// In en, this message translates to:
  /// **'Ongoing call'**
  String get notif_call_channel_name;

  /// No description provided for @notif_call_ongoing_text.
  ///
  /// In en, this message translates to:
  /// **'Camera and microphone stay active while you’re away'**
  String get notif_call_ongoing_text;

  /// No description provided for @notif_call_ongoing_title.
  ///
  /// In en, this message translates to:
  /// **'Video call'**
  String get notif_call_ongoing_title;

  /// No description provided for @notif_file_copy_channel_name.
  ///
  /// In en, this message translates to:
  /// **'Saving file'**
  String get notif_file_copy_channel_name;

  /// No description provided for @notif_file_copy_text.
  ///
  /// In en, this message translates to:
  /// **'Copying file in the background'**
  String get notif_file_copy_text;

  /// No description provided for @notif_file_copy_title.
  ///
  /// In en, this message translates to:
  /// **'Saving attachment'**
  String get notif_file_copy_title;

  /// No description provided for @notif_file_download_channel_name.
  ///
  /// In en, this message translates to:
  /// **'File download'**
  String get notif_file_download_channel_name;

  /// No description provided for @notif_file_download_percent.
  ///
  /// In en, this message translates to:
  /// **'{arg1}\\u0025'**
  String notif_file_download_percent(Object arg1);

  /// No description provided for @notif_file_download_progress.
  ///
  /// In en, this message translates to:
  /// **'{arg1} · {arg2}'**
  String notif_file_download_progress(Object arg1, Object arg2);

  /// No description provided for @notif_file_download_text.
  ///
  /// In en, this message translates to:
  /// **'Download continues in the background'**
  String get notif_file_download_text;

  /// No description provided for @notif_file_download_title.
  ///
  /// In en, this message translates to:
  /// **'Downloading attachment'**
  String get notif_file_download_title;

  /// No description provided for @notif_media_upload_channel_name.
  ///
  /// In en, this message translates to:
  /// **'Media upload'**
  String get notif_media_upload_channel_name;

  /// No description provided for @notif_media_upload_percent.
  ///
  /// In en, this message translates to:
  /// **'{arg1}\\u0025'**
  String notif_media_upload_percent(Object arg1);

  /// No description provided for @notif_media_upload_progress.
  ///
  /// In en, this message translates to:
  /// **'{arg1} · {arg2}'**
  String notif_media_upload_progress(Object arg1, Object arg2);

  /// No description provided for @notif_media_upload_text.
  ///
  /// In en, this message translates to:
  /// **'Upload continues in the background'**
  String get notif_media_upload_text;

  /// No description provided for @notif_media_upload_title.
  ///
  /// In en, this message translates to:
  /// **'Sending attachment'**
  String get notif_media_upload_title;

  /// No description provided for @notif_screenshare_text.
  ///
  /// In en, this message translates to:
  /// **'Screen capture is active for this call'**
  String get notif_screenshare_text;

  /// No description provided for @notif_screenshare_title.
  ///
  /// In en, this message translates to:
  /// **'Screen sharing'**
  String get notif_screenshare_title;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @password_length_error.
  ///
  /// In en, this message translates to:
  /// **'Password must be 5 to 50 characters'**
  String get password_length_error;

  /// No description provided for @passwords_dont_match.
  ///
  /// In en, this message translates to:
  /// **'The two passwords don’t match'**
  String get passwords_dont_match;

  /// No description provided for @presence_date_full.
  ///
  /// In en, this message translates to:
  /// **'{arg1} {arg2} {arg3} at {arg4}'**
  String presence_date_full(Object arg1, Object arg2, Object arg3, Object arg4);

  /// No description provided for @presence_date_this_year.
  ///
  /// In en, this message translates to:
  /// **'{arg1} {arg2} at {arg3}'**
  String presence_date_this_year(Object arg1, Object arg2, Object arg3);

  /// No description provided for @presence_long_ago.
  ///
  /// In en, this message translates to:
  /// **'last seen a long time ago'**
  String get presence_long_ago;

  /// No description provided for @presence_online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get presence_online;

  /// No description provided for @presence_recently.
  ///
  /// In en, this message translates to:
  /// **'Active recently'**
  String get presence_recently;

  /// No description provided for @presence_today_at.
  ///
  /// In en, this message translates to:
  /// **'Today at {arg1}'**
  String presence_today_at(Object arg1);

  /// No description provided for @presence_weekday_at.
  ///
  /// In en, this message translates to:
  /// **'{arg1} at {arg2}'**
  String presence_weekday_at(Object arg1, Object arg2);

  /// No description provided for @presence_yesterday_at.
  ///
  /// In en, this message translates to:
  /// **'Yesterday at {arg1}'**
  String presence_yesterday_at(Object arg1);

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @profile_action_call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get profile_action_call;

  /// No description provided for @profile_action_chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get profile_action_chat;

  /// No description provided for @profile_action_contact_info.
  ///
  /// In en, this message translates to:
  /// **'Contact info'**
  String get profile_action_contact_info;

  /// No description provided for @profile_action_link.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get profile_action_link;

  /// No description provided for @profile_action_search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get profile_action_search;

  /// No description provided for @profile_action_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profile_action_settings;

  /// No description provided for @profile_action_video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get profile_action_video;

  /// No description provided for @profile_bio_length_error.
  ///
  /// In en, this message translates to:
  /// **'Up to {arg1} characters'**
  String profile_bio_length_error(Object arg1);

  /// No description provided for @profile_details_category.
  ///
  /// In en, this message translates to:
  /// **'About this person'**
  String get profile_details_category;

  /// No description provided for @profile_edit_saved.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profile_edit_saved;

  /// No description provided for @profile_edit_title.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get profile_edit_title;

  /// No description provided for @profile_headline_bio.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get profile_headline_bio;

  /// No description provided for @profile_headline_member_since.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get profile_headline_member_since;

  /// No description provided for @profile_headline_username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get profile_headline_username;

  /// No description provided for @profile_headline_verification.
  ///
  /// In en, this message translates to:
  /// **'Verified account'**
  String get profile_headline_verification;

  /// No description provided for @profile_load_failed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t load this profile'**
  String get profile_load_failed;

  /// No description provided for @profile_not_found.
  ///
  /// In en, this message translates to:
  /// **'This profile could not be found'**
  String get profile_not_found;

  /// No description provided for @profile_open_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not open this profile. Please try again.'**
  String get profile_open_failed;

  /// No description provided for @profile_registration_date.
  ///
  /// In en, this message translates to:
  /// **'{arg1} {arg2} {arg3}'**
  String profile_registration_date(Object arg1, Object arg2, Object arg3);

  /// No description provided for @profile_title.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile_title;

  /// No description provided for @profile_verified_support.
  ///
  /// In en, this message translates to:
  /// **'This account is verified'**
  String get profile_verified_support;

  /// No description provided for @profile_verify_prompt_support.
  ///
  /// In en, this message translates to:
  /// **'Tap to verify (admins only)'**
  String get profile_verify_prompt_support;

  /// No description provided for @public_chat.
  ///
  /// In en, this message translates to:
  /// **'Main chat'**
  String get public_chat;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get register;

  /// No description provided for @register_button.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get register_button;

  /// No description provided for @register_d.
  ///
  /// In en, this message translates to:
  /// **'Create a new account'**
  String get register_d;

  /// No description provided for @save_continue.
  ///
  /// In en, this message translates to:
  /// **'Save and continue'**
  String get save_continue;

  /// No description provided for @search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, username or chat'**
  String get search_hint;

  /// No description provided for @search_not_found.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get search_not_found;

  /// No description provided for @search_not_found_message.
  ///
  /// In en, this message translates to:
  /// **'Nothing found here. Try rephrasing your query.'**
  String get search_not_found_message;

  /// No description provided for @search_title.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search_title;

  /// No description provided for @server_config_action_check.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get server_config_action_check;

  /// No description provided for @server_config_action_reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get server_config_action_reset;

  /// No description provided for @server_config_action_reset_confirm_body.
  ///
  /// In en, this message translates to:
  /// **'This restores the default server address.'**
  String get server_config_action_reset_confirm_body;

  /// No description provided for @server_config_action_reset_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Reset to defaults?'**
  String get server_config_action_reset_confirm_title;

  /// No description provided for @server_config_checking.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get server_config_checking;

  /// No description provided for @server_config_fab_reset.
  ///
  /// In en, this message translates to:
  /// **'Reset to defaults'**
  String get server_config_fab_reset;

  /// No description provided for @server_config_fab_verify.
  ///
  /// In en, this message translates to:
  /// **'Check server'**
  String get server_config_fab_verify;

  /// No description provided for @server_config_host_error.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid host, or host:port (default port 443).'**
  String get server_config_host_error;

  /// No description provided for @server_config_https_headline.
  ///
  /// In en, this message translates to:
  /// **'HTTPS'**
  String get server_config_https_headline;

  /// No description provided for @server_config_https_hint.
  ///
  /// In en, this message translates to:
  /// **'Uses HTTPS. Turn off only for plain HTTP.'**
  String get server_config_https_hint;

  /// No description provided for @server_config_https_local_hint.
  ///
  /// In en, this message translates to:
  /// **'Secure connection. If your server is local, you probably should turn it off.'**
  String get server_config_https_local_hint;

  /// No description provided for @server_config_port_error.
  ///
  /// In en, this message translates to:
  /// **'Enter a port from 1 to 65535.'**
  String get server_config_port_error;

  /// No description provided for @server_config_session_logged_out_no_instance.
  ///
  /// In en, this message translates to:
  /// **'Session ended: server instance ID could not be resolved.'**
  String get server_config_session_logged_out_no_instance;

  /// No description provided for @server_config_snackbar_api_fail.
  ///
  /// In en, this message translates to:
  /// **'Cannot reach the API.'**
  String get server_config_snackbar_api_fail;

  /// No description provided for @server_config_snackbar_calls_fail.
  ///
  /// In en, this message translates to:
  /// **'Calls not reachable.'**
  String get server_config_snackbar_calls_fail;

  /// No description provided for @server_config_snackbar_defaults.
  ///
  /// In en, this message translates to:
  /// **'Defaults applied.'**
  String get server_config_snackbar_defaults;

  /// No description provided for @server_config_snackbar_ok_api_calls_bad.
  ///
  /// In en, this message translates to:
  /// **'Server OK; calls did not respond.'**
  String get server_config_snackbar_ok_api_calls_bad;

  /// No description provided for @server_config_snackbar_ok_calls.
  ///
  /// In en, this message translates to:
  /// **'Server OK. Calls reachable. Ping: {arg1} ms.'**
  String server_config_snackbar_ok_calls(Object arg1);

  /// No description provided for @server_config_snackbar_ok_calls_skip.
  ///
  /// In en, this message translates to:
  /// **'Server OK. Calls unavailable. Ping: {arg1} ms.'**
  String server_config_snackbar_ok_calls_skip(Object arg1);

  /// No description provided for @server_config_snackbar_timeout.
  ///
  /// In en, this message translates to:
  /// **'Server did not respond in time. Try again.'**
  String get server_config_snackbar_timeout;

  /// No description provided for @server_config_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Connect to an alternative FromChat server. This can give you more privacy and control over data.'**
  String get server_config_subtitle;

  /// No description provided for @server_config_title.
  ///
  /// In en, this message translates to:
  /// **'Connect to a server'**
  String get server_config_title;

  /// No description provided for @server_config_unsupported_no_instance_id.
  ///
  /// In en, this message translates to:
  /// **'This server does not provide a valid instance ID. Cannot connect.'**
  String get server_config_unsupported_no_instance_id;

  /// No description provided for @server_ip_hint.
  ///
  /// In en, this message translates to:
  /// **'api.fromchat.ru or host:port'**
  String get server_ip_hint;

  /// No description provided for @server_ip_label.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get server_ip_label;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settings_account_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get settings_account_delete;

  /// No description provided for @settings_account_delete_confirm_body.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get settings_account_delete_confirm_body;

  /// No description provided for @settings_account_delete_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get settings_account_delete_confirm_title;

  /// No description provided for @settings_account_delete_d.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete your account and data'**
  String get settings_account_delete_d;

  /// No description provided for @settings_account_deleted.
  ///
  /// In en, this message translates to:
  /// **'Account deleted'**
  String get settings_account_deleted;

  /// No description provided for @settings_account_logout_confirm_body.
  ///
  /// In en, this message translates to:
  /// **'You will need to sign in again.'**
  String get settings_account_logout_confirm_body;

  /// No description provided for @settings_account_logout_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get settings_account_logout_confirm_title;

  /// No description provided for @settings_account_title.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settings_account_title;

  /// No description provided for @settings_category_account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settings_category_account;

  /// No description provided for @settings_category_account_d.
  ///
  /// In en, this message translates to:
  /// **'Log out or delete account'**
  String get settings_category_account_d;

  /// No description provided for @settings_category_appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settings_category_appearance;

  /// No description provided for @settings_category_appearance_d.
  ///
  /// In en, this message translates to:
  /// **'Theme and Material You'**
  String get settings_category_appearance_d;

  /// No description provided for @settings_category_devices.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get settings_category_devices;

  /// No description provided for @settings_category_devices_d.
  ///
  /// In en, this message translates to:
  /// **'Signed-in sessions'**
  String get settings_category_devices_d;

  /// No description provided for @settings_category_notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settings_category_notifications;

  /// No description provided for @settings_category_notifications_d.
  ///
  /// In en, this message translates to:
  /// **'Open system notification settings'**
  String get settings_category_notifications_d;

  /// No description provided for @settings_category_security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settings_category_security;

  /// No description provided for @settings_category_security_d.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get settings_category_security_d;

  /// No description provided for @settings_category_server_tools.
  ///
  /// In en, this message translates to:
  /// **'Server and tools'**
  String get settings_category_server_tools;

  /// No description provided for @settings_category_server_tools_d.
  ///
  /// In en, this message translates to:
  /// **'Change server, debug API'**
  String get settings_category_server_tools_d;

  /// No description provided for @settings_change_password.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get settings_change_password;

  /// No description provided for @settings_confirm_new_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get settings_confirm_new_password;

  /// No description provided for @settings_current_password.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get settings_current_password;

  /// No description provided for @settings_delete_account_button.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get settings_delete_account_button;

  /// No description provided for @settings_delete_confirm_phrase.
  ///
  /// In en, this message translates to:
  /// **'i confirm that i want to delete my account'**
  String get settings_delete_confirm_phrase;

  /// No description provided for @settings_delete_confirm_phrase_instruction.
  ///
  /// In en, this message translates to:
  /// **'To avoid you accidentally clicking the button, please type “{arg1}” (case-insensitive).'**
  String settings_delete_confirm_phrase_instruction(Object arg1);

  /// No description provided for @settings_delete_confirm_phrase_quote.
  ///
  /// In en, this message translates to:
  /// **'I confirm that I want to delete my account'**
  String get settings_delete_confirm_phrase_quote;

  /// No description provided for @settings_delete_consequence_chat_history.
  ///
  /// In en, this message translates to:
  /// **'You will lose all your chat history.'**
  String get settings_delete_consequence_chat_history;

  /// No description provided for @settings_delete_consequence_messages.
  ///
  /// In en, this message translates to:
  /// **'Your sent messages will be anonymized.'**
  String get settings_delete_consequence_messages;

  /// No description provided for @settings_delete_consequence_permanent.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get settings_delete_consequence_permanent;

  /// No description provided for @settings_delete_consequence_username.
  ///
  /// In en, this message translates to:
  /// **'Your username will become available to everyone and anyone can claim it.'**
  String get settings_delete_consequence_username;

  /// No description provided for @settings_delete_step_final_body.
  ///
  /// In en, this message translates to:
  /// **'Your account will be deleted FOREVER and CANNOT be recovered. You will be signed out on all devices and lose access immediately.'**
  String get settings_delete_step_final_body;

  /// No description provided for @settings_delete_step_final_title.
  ///
  /// In en, this message translates to:
  /// **'Last warning'**
  String get settings_delete_step_final_title;

  /// No description provided for @settings_delete_step_intro_body.
  ///
  /// In en, this message translates to:
  /// **'Your account will be deleted forever. If you confirm the action, this will happen:'**
  String get settings_delete_step_intro_body;

  /// No description provided for @settings_delete_step_intro_title.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete your account?'**
  String get settings_delete_step_intro_title;

  /// No description provided for @settings_delete_step_password_body.
  ///
  /// In en, this message translates to:
  /// **'Enter your password to continue.'**
  String get settings_delete_step_password_body;

  /// No description provided for @settings_delete_step_password_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get settings_delete_step_password_title;

  /// No description provided for @settings_devices_active_sessions.
  ///
  /// In en, this message translates to:
  /// **'Active sessions'**
  String get settings_devices_active_sessions;

  /// No description provided for @settings_devices_current_hint.
  ///
  /// In en, this message translates to:
  /// **'You are signed in here.'**
  String get settings_devices_current_hint;

  /// No description provided for @settings_devices_empty.
  ///
  /// In en, this message translates to:
  /// **'No active sessions'**
  String get settings_devices_empty;

  /// No description provided for @settings_devices_empty_sub.
  ///
  /// In en, this message translates to:
  /// **'When you sign in on other phones or browsers, they will show up here.'**
  String get settings_devices_empty_sub;

  /// No description provided for @settings_devices_field_brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get settings_devices_field_brand;

  /// No description provided for @settings_devices_field_browser.
  ///
  /// In en, this message translates to:
  /// **'Browser'**
  String get settings_devices_field_browser;

  /// No description provided for @settings_devices_field_browser_version.
  ///
  /// In en, this message translates to:
  /// **'Browser version'**
  String get settings_devices_field_browser_version;

  /// No description provided for @settings_devices_field_device_name.
  ///
  /// In en, this message translates to:
  /// **'Device name'**
  String get settings_devices_field_device_name;

  /// No description provided for @settings_devices_field_device_type.
  ///
  /// In en, this message translates to:
  /// **'Device type'**
  String get settings_devices_field_device_type;

  /// No description provided for @settings_devices_field_last_active.
  ///
  /// In en, this message translates to:
  /// **'Last active'**
  String get settings_devices_field_last_active;

  /// No description provided for @settings_devices_field_model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get settings_devices_field_model;

  /// No description provided for @settings_devices_field_os.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settings_devices_field_os;

  /// No description provided for @settings_devices_field_os_version.
  ///
  /// In en, this message translates to:
  /// **'System version'**
  String get settings_devices_field_os_version;

  /// No description provided for @settings_devices_field_session_id.
  ///
  /// In en, this message translates to:
  /// **'Session ID'**
  String get settings_devices_field_session_id;

  /// No description provided for @settings_devices_field_signed_in.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get settings_devices_field_signed_in;

  /// No description provided for @settings_devices_last_active.
  ///
  /// In en, this message translates to:
  /// **'Last active {arg1}'**
  String settings_devices_last_active(Object arg1);

  /// No description provided for @settings_devices_logout_all.
  ///
  /// In en, this message translates to:
  /// **'Sign out all other devices'**
  String get settings_devices_logout_all;

  /// No description provided for @settings_devices_logout_all_confirm_body.
  ///
  /// In en, this message translates to:
  /// **'You stay signed in on this device only.'**
  String get settings_devices_logout_all_confirm_body;

  /// No description provided for @settings_devices_logout_all_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Sign out everywhere else?'**
  String get settings_devices_logout_all_confirm_title;

  /// No description provided for @settings_devices_revoke.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get settings_devices_revoke;

  /// No description provided for @settings_devices_sheet_title.
  ///
  /// In en, this message translates to:
  /// **'Session details'**
  String get settings_devices_sheet_title;

  /// No description provided for @settings_devices_sign_out_sheet.
  ///
  /// In en, this message translates to:
  /// **'Sign out on this device'**
  String get settings_devices_sign_out_sheet;

  /// No description provided for @settings_devices_signing_out.
  ///
  /// In en, this message translates to:
  /// **'Signing out…'**
  String get settings_devices_signing_out;

  /// No description provided for @settings_devices_this_device.
  ///
  /// In en, this message translates to:
  /// **'This device'**
  String get settings_devices_this_device;

  /// No description provided for @settings_devices_title.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get settings_devices_title;

  /// No description provided for @settings_devices_unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown device'**
  String get settings_devices_unknown;

  /// No description provided for @settings_hub_about_sub.
  ///
  /// In en, this message translates to:
  /// **'Version, links, and more'**
  String get settings_hub_about_sub;

  /// No description provided for @settings_hub_logs_sub.
  ///
  /// In en, this message translates to:
  /// **'View, share, and manage app logs'**
  String get settings_hub_logs_sub;

  /// No description provided for @settings_logout_other_sessions.
  ///
  /// In en, this message translates to:
  /// **'Sign out all other devices after change'**
  String get settings_logout_other_sessions;

  /// No description provided for @settings_new_password.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get settings_new_password;

  /// No description provided for @settings_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get settings_next;

  /// No description provided for @settings_notification_settings.
  ///
  /// In en, this message translates to:
  /// **'Notification settings'**
  String get settings_notification_settings;

  /// No description provided for @settings_notification_settings_d.
  ///
  /// In en, this message translates to:
  /// **'Here you can enable or disable certain types of notifications, change the sound and more.'**
  String get settings_notification_settings_d;

  /// No description provided for @settings_notifications_permission_required.
  ///
  /// In en, this message translates to:
  /// **'Open system notification settings to allow alerts.'**
  String get settings_notifications_permission_required;

  /// No description provided for @settings_notifications_title.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settings_notifications_title;

  /// No description provided for @settings_password_changed.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get settings_password_changed;

  /// No description provided for @settings_push_notifications.
  ///
  /// In en, this message translates to:
  /// **'Push notifications'**
  String get settings_push_notifications;

  /// No description provided for @settings_push_notifications_d.
  ///
  /// In en, this message translates to:
  /// **'These will let you know if you got a new message when the app is closed.'**
  String get settings_push_notifications_d;

  /// No description provided for @settings_security_change_password_sub.
  ///
  /// In en, this message translates to:
  /// **'Update the password you use to sign in'**
  String get settings_security_change_password_sub;

  /// No description provided for @settings_security_step_confirm_body.
  ///
  /// In en, this message translates to:
  /// **'Type your new password again to make sure it matches.'**
  String get settings_security_step_confirm_body;

  /// No description provided for @settings_security_step_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get settings_security_step_confirm_title;

  /// No description provided for @settings_security_step_current_body.
  ///
  /// In en, this message translates to:
  /// **'Enter the password you use now to continue.'**
  String get settings_security_step_current_body;

  /// No description provided for @settings_security_step_current_title.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get settings_security_step_current_title;

  /// No description provided for @settings_security_step_new_body.
  ///
  /// In en, this message translates to:
  /// **'Choose a strong password you have not used here before.'**
  String get settings_security_step_new_body;

  /// No description provided for @settings_security_step_new_title.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get settings_security_step_new_title;

  /// No description provided for @settings_security_title.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settings_security_title;

  /// No description provided for @show_password.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get show_password;

  /// No description provided for @status_connecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting'**
  String get status_connecting;

  /// No description provided for @status_updating.
  ///
  /// In en, this message translates to:
  /// **'Updating'**
  String get status_updating;

  /// No description provided for @suspend_chat_banner_message.
  ///
  /// In en, this message translates to:
  /// **'Your account was blocked'**
  String get suspend_chat_banner_message;

  /// No description provided for @suspended_default_reason.
  ///
  /// In en, this message translates to:
  /// **'Reason not provided. Your account access is currently read-only.'**
  String get suspended_default_reason;

  /// No description provided for @suspended_sheet_action_contact_support.
  ///
  /// In en, this message translates to:
  /// **'Contact support'**
  String get suspended_sheet_action_contact_support;

  /// No description provided for @suspended_sheet_desc.
  ///
  /// In en, this message translates to:
  /// **'Your account was blocked for violating the community rules.\\nYou can still read your chats, but new messages are currently paused.\\nIf you think this is a mistake, contact support and we can help.'**
  String get suspended_sheet_desc;

  /// No description provided for @suspended_sheet_reason_label.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get suspended_sheet_reason_label;

  /// No description provided for @suspended_sheet_title.
  ///
  /// In en, this message translates to:
  /// **'Account blocked'**
  String get suspended_sheet_title;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Look'**
  String get theme;

  /// No description provided for @typing_alone.
  ///
  /// In en, this message translates to:
  /// **'typing…'**
  String get typing_alone;

  /// No description provided for @typing_many.
  ///
  /// In en, this message translates to:
  /// **'{arg1}, {arg2} and {arg3} more are typing…'**
  String typing_many(Object arg1, Object arg2, Object arg3);

  /// No description provided for @typing_single.
  ///
  /// In en, this message translates to:
  /// **'{arg1} is typing…'**
  String typing_single(Object arg1);

  /// No description provided for @typing_two.
  ///
  /// In en, this message translates to:
  /// **'{arg1} and {arg2} are typing…'**
  String typing_two(Object arg1, Object arg2);

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @unread_count.
  ///
  /// In en, this message translates to:
  /// **'+{arg1}'**
  String unread_count(Object arg1);

  /// No description provided for @unread_count_badge.
  ///
  /// In en, this message translates to:
  /// **'{arg1}'**
  String unread_count_badge(Object arg1);

  /// No description provided for @unread_count_overflow.
  ///
  /// In en, this message translates to:
  /// **'99+'**
  String get unread_count_overflow;

  /// No description provided for @unverify.
  ///
  /// In en, this message translates to:
  /// **'Remove verification'**
  String get unverify;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @username_length_error.
  ///
  /// In en, this message translates to:
  /// **'Username must be 3 to 20 characters'**
  String get username_length_error;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @weekday_fri.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get weekday_fri;

  /// No description provided for @weekday_mon.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get weekday_mon;

  /// No description provided for @weekday_sat.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get weekday_sat;

  /// No description provided for @weekday_sun.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get weekday_sun;

  /// No description provided for @weekday_thu.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get weekday_thu;

  /// No description provided for @weekday_tue.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get weekday_tue;

  /// No description provided for @weekday_wed.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get weekday_wed;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
