// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get about => 'About';

  @override
  String get about_link_max => 'MAX';

  @override
  String get about_link_privacy => 'Privacy policy';

  @override
  String get about_link_telegram => 'Telegram';

  @override
  String get about_link_terms => 'Terms of service';

  @override
  String get about_link_website => 'Website';

  @override
  String get about_version => 'Version 1.0';

  @override
  String get account_suspended => 'Account suspended';

  @override
  String get action_archive => 'Archive';

  @override
  String get action_cancel_send => 'Cancel';

  @override
  String get action_chat => 'Chat';

  @override
  String get action_copy => 'Copy';

  @override
  String get action_copy_link => 'Copy link';

  @override
  String get action_delete => 'Delete';

  @override
  String get action_delete_chat => 'Delete chat';

  @override
  String get action_edit => 'Edit';

  @override
  String get action_mark_read => 'Mark as read';

  @override
  String get action_open_settings => 'Settings';

  @override
  String get action_reply => 'Reply';

  @override
  String get action_retry_send => 'Retry';

  @override
  String get action_save => 'Save';

  @override
  String get action_select => 'Select';

  @override
  String get action_wipe_local_cache_confirm_body =>
      'All offline messages and downloads for every server instance on this device will be deleted. Unsent messages in the outbox will be lost.';

  @override
  String get action_wipe_local_cache_confirm_title => 'Clear local data?';

  @override
  String get action_wipe_local_cache_done => 'Local data cleared';

  @override
  String get action_wipe_local_cache_supporting =>
      'Removes cached messages, media, and pending sends on this device. Your account on the server is not affected.';

  @override
  String get action_wipe_local_cache_title => 'Clear local data';

  @override
  String get api_port_label => 'Port';

  @override
  String get app_desc =>
      '100% free and open messenger. Supports self-hosted installation on your own server.';

  @override
  String get app_name => 'FromChat';

  @override
  String get as_system => 'Same as phone';

  @override
  String get attachment_image_load_failed => 'Failed to load';

  @override
  String get attachment_open_chooser_title => 'Open with';

  @override
  String get attachment_open_failed =>
      'Couldn\'t open this file. Try Save from the message menu.';

  @override
  String get attachment_retry => 'Retry';

  @override
  String get attachment_upload_failed => 'Couldn\'t send file';

  @override
  String get attachment_upload_failed_too_large =>
      'File is too large to send on this device';

  @override
  String auth_char_count(Object arg1, Object arg2) {
    return '$arg1/$arg2';
  }

  @override
  String get auth_get_started => 'Get started';

  @override
  String get auth_legal_notice_and => ' and ';

  @override
  String get auth_legal_notice_prefix =>
      'By creating an account you agree to the ';

  @override
  String get auth_rate_limit => 'Too many attempts. Try again later.';

  @override
  String get auth_server_connect_failed => 'Failed to connect to the server';

  @override
  String get auth_step_confirm_body => 'Enter the same password again.';

  @override
  String get auth_step_confirm_title => 'Confirm your password';

  @override
  String get auth_step_password_body =>
      'We will sign you in or create a new account.';

  @override
  String get auth_step_password_title => 'Enter your password';

  @override
  String get auth_step_profile_body =>
      'Enter your display name and, if you like, a few words about yourself.';

  @override
  String get auth_step_profile_title => 'Create your profile';

  @override
  String get auth_step_username_body =>
      'This is your login. It helps us tell you apart from everyone else.';

  @override
  String get auth_step_username_title => 'Enter your username';

  @override
  String get auth_username_taken =>
      'This username was just taken. Please choose another one.';

  @override
  String get auth_welcome_tagline => 'The 100% free and open source messenger.';

  @override
  String get auth_welcome_title => 'Welcome to FromChat';

  @override
  String get auth_wrong_password => 'Wrong password';

  @override
  String get back => 'Back';

  @override
  String get call_accept => 'Accept';

  @override
  String get call_decline => 'Decline';

  @override
  String get call_dismiss => 'OK';

  @override
  String get call_failed_title => 'Could not connect';

  @override
  String get call_incoming_subtitle => 'Incoming call';

  @override
  String get call_status_calling => 'Calling…';

  @override
  String get call_status_connecting => 'Connecting…';

  @override
  String get call_status_in_call => 'In call';

  @override
  String get call_status_reconnecting => 'Reconnecting…';

  @override
  String call_status_reconnecting_with_detail(Object arg1) {
    return 'Reconnecting… $arg1';
  }

  @override
  String get call_status_starting => 'Starting call…';

  @override
  String get calls_port_label => 'Calls port';

  @override
  String get cancel => 'Cancel';

  @override
  String get cd_account_blocked => 'Account blocked';

  @override
  String get cd_attachment_retry => 'Retry loading image';

  @override
  String get cd_attachment_upload_retry => 'Retry sending file';

  @override
  String get cd_call => 'Call';

  @override
  String get cd_call_camera => 'Camera';

  @override
  String get cd_call_end => 'End call';

  @override
  String get cd_call_mic => 'Microphone';

  @override
  String get cd_call_screenshare => 'Share screen';

  @override
  String get cd_chat_preview_sending => 'Sending message';

  @override
  String get cd_chat_preview_uploading => 'Uploading file';

  @override
  String get cd_chat_selected => 'Selected';

  @override
  String get cd_close => 'Close';

  @override
  String get cd_close_selection => 'Close selection';

  @override
  String get cd_emoji => 'Emoji';

  @override
  String get cd_message_send_failed => 'Message failed to send';

  @override
  String get cd_pick_file => 'Choose file';

  @override
  String get cd_pick_image => 'Choose photo';

  @override
  String get cd_remove => 'Remove';

  @override
  String get cd_selection_more => 'More actions';

  @override
  String get cd_send => 'Send';

  @override
  String get cd_similar_verified => 'May be a verified account';

  @override
  String get cd_verified_account => 'Verified account';

  @override
  String get change_server => 'Change server';

  @override
  String get change_server_d =>
      'Connect to an alternative FromChat server and sign out.';

  @override
  String get chat_date_today => 'Today';

  @override
  String get chat_date_yesterday => 'Yesterday';

  @override
  String get chat_delete_confirm_body =>
      'Messages in selected chats will be deleted from this device and the server.';

  @override
  String get chat_delete_confirm_title => 'Delete chats?';

  @override
  String chat_delete_partial_failure(Object arg1) {
    return 'Could not delete $arg1 chat(s)';
  }

  @override
  String get chat_group_label => 'Group';

  @override
  String get chat_last_mesaage => 'You: last message';

  @override
  String chat_members_count(Object arg1) {
    return '$arg1 people';
  }

  @override
  String get chat_preview_attachment => 'Attachment';

  @override
  String chat_preview_image(Object arg1) {
    return '$arg1 1 photo';
  }

  @override
  String get chat_preview_image_emoji => '📷';

  @override
  String get chat_scroll_to_bottom_cd => 'Scroll to latest messages';

  @override
  String get chats => 'Chats';

  @override
  String chats_selected_count(Object arg1) {
    return '$arg1 chats selected';
  }

  @override
  String get coming_soon => 'Coming soon…';

  @override
  String get confirm => 'Confirm';

  @override
  String get confirm_password => 'Password again';

  @override
  String get contacts => 'Contacts';

  @override
  String get contacts_empty_body =>
      'Your contacts will appear here when this feature is ready.';

  @override
  String get contacts_empty_title => 'Coming soon';

  @override
  String get dark => 'Dark';

  @override
  String get debug_tools => 'Debug API';

  @override
  String get debug_tools_d =>
      'Inspect profile and DM endpoints used by the client.';

  @override
  String get deleted_account => 'Deleted account';

  @override
  String get display_name => 'Name shown to others';

  @override
  String get display_name_error => 'Use between 1 and 64 characters';

  @override
  String get dms => 'Private chats';

  @override
  String get error_connection => 'Couldn’t connect. Check your internet.';

  @override
  String get error_invalid_credentials => 'Wrong username or password';

  @override
  String get error_unexpected => 'Something went wrong';

  @override
  String get error_unknown => 'Something went wrong. Please try again.';

  @override
  String get feature_not_implemented => 'Not implemented yet';

  @override
  String get fill_all_fields => 'Please fill in every field';

  @override
  String get hide_password => 'Hide password';

  @override
  String get home => 'Home';

  @override
  String get https_enabled => 'Secure connection';

  @override
  String get legal_document_cached_banner =>
      'Showing a saved copy. Content may be out of date.';

  @override
  String get legal_document_load_error =>
      'Couldn\'t load the document. Check your connection and try again.';

  @override
  String get legal_privacy_title => 'Privacy policy';

  @override
  String get legal_terms_title => 'Terms of service';

  @override
  String get light => 'Light';

  @override
  String get link_copied => 'Link copied';

  @override
  String get login => 'Log in';

  @override
  String get login_d => 'Log in to your account';

  @override
  String get logout => 'Log out';

  @override
  String get logs_browse_files_cd => 'Browse log files';

  @override
  String get logs_clean => 'Clean logs';

  @override
  String get logs_clean_all_body =>
      'Deletes the current log file and all rotated archives.';

  @override
  String get logs_clean_apply => 'Clean';

  @override
  String get logs_clean_date_body =>
      'Delete entries and archives before the selected date (your time zone).';

  @override
  String get logs_clean_date_day => 'Day';

  @override
  String get logs_clean_date_month => 'Month';

  @override
  String get logs_clean_date_year => 'Year';

  @override
  String get logs_clean_entries_body =>
      'Keep only the newest entries in the current log file.';

  @override
  String logs_clean_entries_count(Object arg1) {
    return 'Keep newest: $arg1';
  }

  @override
  String get logs_clean_mode_all => 'Delete everything';

  @override
  String get logs_clean_mode_date => 'Before date';

  @override
  String get logs_clean_mode_entries => 'By entry count';

  @override
  String get logs_clean_mode_size => 'By total size';

  @override
  String get logs_clean_size_body =>
      'Delete oldest archives and entries until total log storage is below the limit.';

  @override
  String logs_clean_size_mb(Object arg1) {
    return 'Limit: $arg1 MB';
  }

  @override
  String get logs_clean_title => 'Clean logs';

  @override
  String get logs_clear_all_cd => 'Clear all log files';

  @override
  String get logs_clear_all_confirm_body =>
      'This deletes the current log and all rotated archives.';

  @override
  String get logs_clear_all_confirm_title => 'Clear all log files?';

  @override
  String get logs_copied => 'Copied to clipboard';

  @override
  String get logs_decompressing => 'Decompressing…';

  @override
  String get logs_delete_file_confirm_body =>
      'This file will be permanently removed from the device.';

  @override
  String get logs_delete_file_confirm_title => 'Delete log file?';

  @override
  String logs_delete_files_confirm_body(Object arg1) {
    return '$arg1 files will be permanently removed from the device.';
  }

  @override
  String get logs_delete_files_confirm_title => 'Delete selected log files?';

  @override
  String get logs_empty => 'No log entries yet';

  @override
  String logs_file_size_kb(Object arg1) {
    return '$arg1 KB';
  }

  @override
  String logs_file_size_mb(Object arg1) {
    return '$arg1 MB';
  }

  @override
  String get logs_files_title => 'Log files';

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
  String get logs_open => 'Open';

  @override
  String get logs_rotate => 'Rotate logs';

  @override
  String get logs_rotate_confirm_body =>
      'The current log will be archived and a new empty log file will be started.';

  @override
  String get logs_rotate_confirm_title => 'Rotate log file?';

  @override
  String get logs_scroll_to_bottom_cd => 'Scroll to latest logs';

  @override
  String get logs_search => 'Search';

  @override
  String get logs_search_hint => 'Search log entries';

  @override
  String logs_selected_count(Object arg1) {
    return '$arg1 selected';
  }

  @override
  String get logs_share => 'Share logs';

  @override
  String get logs_share_compressed => 'Compressed';

  @override
  String get logs_share_compressed_desc =>
      'Smaller file size, but requires gzip to view';

  @override
  String get logs_share_how_title => 'How do you want to send the logs?';

  @override
  String get logs_share_uncompressed => 'Uncompressed';

  @override
  String get logs_share_uncompressed_desc =>
      'Easier to read without any additional software';

  @override
  String get logs_title => 'Logs';

  @override
  String get materialYou => 'Material You';

  @override
  String get materialYou_d =>
      'Match colors to your wallpaper. Works on Android 12 and up.';

  @override
  String get message_corrupted => 'This message could not be shown.';

  @override
  String get message_corrupted_short => 'Can’t show this message';

  @override
  String get message_edited_suffix => '(edited)';

  @override
  String get message_editing_title => 'Edit message';

  @override
  String get message_placeholder => 'Write a message…';

  @override
  String get message_reply_jump_cd => 'Jump to quoted message';

  @override
  String get message_reply_photo => 'Photo';

  @override
  String message_replying_to(Object arg1) {
    return 'Reply to $arg1';
  }

  @override
  String get message_send_failed => 'Couldn\'t send';

  @override
  String get message_sender_you => 'You';

  @override
  String get month_apr => 'Apr';

  @override
  String get month_aug => 'Aug';

  @override
  String get month_dec => 'Dec';

  @override
  String get month_feb => 'Feb';

  @override
  String get month_jan => 'Jan';

  @override
  String get month_jul => 'Jul';

  @override
  String get month_jun => 'Jun';

  @override
  String get month_mar => 'Mar';

  @override
  String get month_may => 'May';

  @override
  String get month_name_apr => 'april';

  @override
  String get month_name_aug => 'august';

  @override
  String get month_name_dec => 'december';

  @override
  String get month_name_feb => 'february';

  @override
  String get month_name_jan => 'january';

  @override
  String get month_name_jul => 'july';

  @override
  String get month_name_jun => 'june';

  @override
  String get month_name_mar => 'march';

  @override
  String get month_name_may => 'may';

  @override
  String get month_name_nov => 'november';

  @override
  String get month_name_oct => 'october';

  @override
  String get month_name_sep => 'september';

  @override
  String get month_nov => 'Nov';

  @override
  String get month_oct => 'Oct';

  @override
  String get month_sep => 'Sep';

  @override
  String get more => 'More';

  @override
  String get notif_call_channel_name => 'Ongoing call';

  @override
  String get notif_call_ongoing_text =>
      'Camera and microphone stay active while you’re away';

  @override
  String get notif_call_ongoing_title => 'Video call';

  @override
  String get notif_file_copy_channel_name => 'Saving file';

  @override
  String get notif_file_copy_text => 'Copying file in the background';

  @override
  String get notif_file_copy_title => 'Saving attachment';

  @override
  String get notif_file_download_channel_name => 'File download';

  @override
  String notif_file_download_percent(Object arg1) {
    return '$arg1\\u0025';
  }

  @override
  String notif_file_download_progress(Object arg1, Object arg2) {
    return '$arg1 · $arg2';
  }

  @override
  String get notif_file_download_text => 'Download continues in the background';

  @override
  String get notif_file_download_title => 'Downloading attachment';

  @override
  String get notif_media_upload_channel_name => 'Media upload';

  @override
  String notif_media_upload_percent(Object arg1) {
    return '$arg1\\u0025';
  }

  @override
  String notif_media_upload_progress(Object arg1, Object arg2) {
    return '$arg1 · $arg2';
  }

  @override
  String get notif_media_upload_text => 'Upload continues in the background';

  @override
  String get notif_media_upload_title => 'Sending attachment';

  @override
  String get notif_screenshare_text => 'Screen capture is active for this call';

  @override
  String get notif_screenshare_title => 'Screen sharing';

  @override
  String get password => 'Password';

  @override
  String get password_length_error => 'Password must be 5 to 50 characters';

  @override
  String get passwords_dont_match => 'The two passwords don’t match';

  @override
  String presence_date_full(
    Object arg1,
    Object arg2,
    Object arg3,
    Object arg4,
  ) {
    return '$arg1 $arg2 $arg3 at $arg4';
  }

  @override
  String presence_date_this_year(Object arg1, Object arg2, Object arg3) {
    return '$arg1 $arg2 at $arg3';
  }

  @override
  String get presence_long_ago => 'last seen a long time ago';

  @override
  String get presence_online => 'Online';

  @override
  String get presence_recently => 'Active recently';

  @override
  String presence_today_at(Object arg1) {
    return 'Today at $arg1';
  }

  @override
  String presence_weekday_at(Object arg1, Object arg2) {
    return '$arg1 at $arg2';
  }

  @override
  String presence_yesterday_at(Object arg1) {
    return 'Yesterday at $arg1';
  }

  @override
  String get profile => 'Profile';

  @override
  String get profile_action_call => 'Call';

  @override
  String get profile_action_chat => 'Chat';

  @override
  String get profile_action_contact_info => 'Contact info';

  @override
  String get profile_action_link => 'Link';

  @override
  String get profile_action_search => 'Search';

  @override
  String get profile_action_settings => 'Settings';

  @override
  String get profile_action_video => 'Video';

  @override
  String profile_bio_length_error(Object arg1) {
    return 'Up to $arg1 characters';
  }

  @override
  String get profile_details_category => 'About this person';

  @override
  String get profile_edit_saved => 'Profile updated';

  @override
  String get profile_edit_title => 'Edit';

  @override
  String get profile_headline_bio => 'About';

  @override
  String get profile_headline_member_since => 'Joined';

  @override
  String get profile_headline_username => 'Username';

  @override
  String get profile_headline_verification => 'Verified account';

  @override
  String get profile_load_failed => 'Couldn’t load this profile';

  @override
  String get profile_not_found => 'This profile could not be found';

  @override
  String get profile_open_failed =>
      'Could not open this profile. Please try again.';

  @override
  String profile_registration_date(Object arg1, Object arg2, Object arg3) {
    return '$arg1 $arg2 $arg3';
  }

  @override
  String get profile_title => 'Profile';

  @override
  String get profile_verified_support => 'This account is verified';

  @override
  String get profile_verify_prompt_support => 'Tap to verify (admins only)';

  @override
  String get public_chat => 'Main chat';

  @override
  String get register => 'Sign up';

  @override
  String get register_button => 'Create account';

  @override
  String get register_d => 'Create a new account';

  @override
  String get save_continue => 'Save and continue';

  @override
  String get search_hint => 'Search by name, username or chat';

  @override
  String get search_not_found => 'No results';

  @override
  String get search_not_found_message =>
      'Nothing found here. Try rephrasing your query.';

  @override
  String get search_title => 'Search';

  @override
  String get server_config_action_check => 'Check';

  @override
  String get server_config_action_reset => 'Reset';

  @override
  String get server_config_action_reset_confirm_body =>
      'This restores the default server address.';

  @override
  String get server_config_action_reset_confirm_title => 'Reset to defaults?';

  @override
  String get server_config_checking => 'Checking…';

  @override
  String get server_config_fab_reset => 'Reset to defaults';

  @override
  String get server_config_fab_verify => 'Check server';

  @override
  String get server_config_host_error =>
      'Enter a valid host, or host:port (default port 443).';

  @override
  String get server_config_https_headline => 'HTTPS';

  @override
  String get server_config_https_hint =>
      'Uses HTTPS. Turn off only for plain HTTP.';

  @override
  String get server_config_https_local_hint =>
      'Secure connection. If your server is local, you probably should turn it off.';

  @override
  String get server_config_port_error => 'Enter a port from 1 to 65535.';

  @override
  String get server_config_session_logged_out_no_instance =>
      'Session ended: server instance ID could not be resolved.';

  @override
  String get server_config_snackbar_api_fail => 'Cannot reach the API.';

  @override
  String get server_config_snackbar_calls_fail => 'Calls not reachable.';

  @override
  String get server_config_snackbar_defaults => 'Defaults applied.';

  @override
  String get server_config_snackbar_ok_api_calls_bad =>
      'Server OK; calls did not respond.';

  @override
  String server_config_snackbar_ok_calls(Object arg1) {
    return 'Server OK. Calls reachable. Ping: $arg1 ms.';
  }

  @override
  String server_config_snackbar_ok_calls_skip(Object arg1) {
    return 'Server OK. Calls unavailable. Ping: $arg1 ms.';
  }

  @override
  String get server_config_snackbar_timeout =>
      'Server did not respond in time. Try again.';

  @override
  String get server_config_subtitle =>
      'Connect to an alternative FromChat server. This can give you more privacy and control over data.';

  @override
  String get server_config_title => 'Connect to a server';

  @override
  String get server_config_unsupported_no_instance_id =>
      'This server does not provide a valid instance ID. Cannot connect.';

  @override
  String get server_ip_hint => 'api.fromchat.ru or host:port';

  @override
  String get server_ip_label => 'Server';

  @override
  String get settings => 'Settings';

  @override
  String get settings_account_delete => 'Delete account';

  @override
  String get settings_account_delete_confirm_body => 'This cannot be undone.';

  @override
  String get settings_account_delete_confirm_title => 'Delete account?';

  @override
  String get settings_account_delete_d =>
      'Permanently delete your account and data';

  @override
  String get settings_account_deleted => 'Account deleted';

  @override
  String get settings_account_logout_confirm_body =>
      'You will need to sign in again.';

  @override
  String get settings_account_logout_confirm_title => 'Log out?';

  @override
  String get settings_account_title => 'Account';

  @override
  String get settings_category_account => 'Account';

  @override
  String get settings_category_account_d => 'Log out or delete account';

  @override
  String get settings_category_appearance => 'Appearance';

  @override
  String get settings_category_appearance_d => 'Theme and Material You';

  @override
  String get settings_category_devices => 'Devices';

  @override
  String get settings_category_devices_d => 'Signed-in sessions';

  @override
  String get settings_category_notifications => 'Notifications';

  @override
  String get settings_category_notifications_d =>
      'Open system notification settings';

  @override
  String get settings_category_security => 'Security';

  @override
  String get settings_category_security_d => 'Change password';

  @override
  String get settings_category_server_tools => 'Server and tools';

  @override
  String get settings_category_server_tools_d => 'Change server, debug API';

  @override
  String get settings_change_password => 'Change password';

  @override
  String get settings_confirm_new_password => 'Confirm new password';

  @override
  String get settings_current_password => 'Current password';

  @override
  String get settings_delete_account_button => 'Delete account';

  @override
  String get settings_delete_confirm_phrase =>
      'i confirm that i want to delete my account';

  @override
  String settings_delete_confirm_phrase_instruction(Object arg1) {
    return 'To avoid you accidentally clicking the button, please type “$arg1” (case-insensitive).';
  }

  @override
  String get settings_delete_confirm_phrase_quote =>
      'I confirm that I want to delete my account';

  @override
  String get settings_delete_consequence_chat_history =>
      'You will lose all your chat history.';

  @override
  String get settings_delete_consequence_messages =>
      'Your sent messages will be anonymized.';

  @override
  String get settings_delete_consequence_permanent => 'This cannot be undone.';

  @override
  String get settings_delete_consequence_username =>
      'Your username will become available to everyone and anyone can claim it.';

  @override
  String get settings_delete_step_final_body =>
      'Your account will be deleted FOREVER and CANNOT be recovered. You will be signed out on all devices and lose access immediately.';

  @override
  String get settings_delete_step_final_title => 'Last warning';

  @override
  String get settings_delete_step_intro_body =>
      'Your account will be deleted forever. If you confirm the action, this will happen:';

  @override
  String get settings_delete_step_intro_title =>
      'Do you want to delete your account?';

  @override
  String get settings_delete_step_password_body =>
      'Enter your password to continue.';

  @override
  String get settings_delete_step_password_title => 'Confirm your password';

  @override
  String get settings_devices_active_sessions => 'Active sessions';

  @override
  String get settings_devices_current_hint => 'You are signed in here.';

  @override
  String get settings_devices_empty => 'No active sessions';

  @override
  String get settings_devices_empty_sub =>
      'When you sign in on other phones or browsers, they will show up here.';

  @override
  String get settings_devices_field_brand => 'Brand';

  @override
  String get settings_devices_field_browser => 'Browser';

  @override
  String get settings_devices_field_browser_version => 'Browser version';

  @override
  String get settings_devices_field_device_name => 'Device name';

  @override
  String get settings_devices_field_device_type => 'Device type';

  @override
  String get settings_devices_field_last_active => 'Last active';

  @override
  String get settings_devices_field_model => 'Model';

  @override
  String get settings_devices_field_os => 'System';

  @override
  String get settings_devices_field_os_version => 'System version';

  @override
  String get settings_devices_field_session_id => 'Session ID';

  @override
  String get settings_devices_field_signed_in => 'Signed in';

  @override
  String settings_devices_last_active(Object arg1) {
    return 'Last active $arg1';
  }

  @override
  String get settings_devices_logout_all => 'Sign out all other devices';

  @override
  String get settings_devices_logout_all_confirm_body =>
      'You stay signed in on this device only.';

  @override
  String get settings_devices_logout_all_confirm_title =>
      'Sign out everywhere else?';

  @override
  String get settings_devices_revoke => 'Sign out';

  @override
  String get settings_devices_sheet_title => 'Session details';

  @override
  String get settings_devices_sign_out_sheet => 'Sign out on this device';

  @override
  String get settings_devices_signing_out => 'Signing out…';

  @override
  String get settings_devices_this_device => 'This device';

  @override
  String get settings_devices_title => 'Devices';

  @override
  String get settings_devices_unknown => 'Unknown device';

  @override
  String get settings_hub_about_sub => 'Version, links, and more';

  @override
  String get settings_hub_logs_sub => 'View, share, and manage app logs';

  @override
  String get settings_logout_other_sessions =>
      'Sign out all other devices after change';

  @override
  String get settings_new_password => 'New password';

  @override
  String get settings_next => 'Next';

  @override
  String get settings_notification_settings => 'Notification settings';

  @override
  String get settings_notification_settings_d =>
      'Here you can enable or disable certain types of notifications, change the sound and more.';

  @override
  String get settings_notifications_permission_required =>
      'Open system notification settings to allow alerts.';

  @override
  String get settings_notifications_title => 'Notifications';

  @override
  String get settings_password_changed => 'Password updated';

  @override
  String get settings_push_notifications => 'Push notifications';

  @override
  String get settings_push_notifications_d =>
      'These will let you know if you got a new message when the app is closed.';

  @override
  String get settings_security_change_password_sub =>
      'Update the password you use to sign in';

  @override
  String get settings_security_step_confirm_body =>
      'Type your new password again to make sure it matches.';

  @override
  String get settings_security_step_confirm_title => 'Confirm new password';

  @override
  String get settings_security_step_current_body =>
      'Enter the password you use now to continue.';

  @override
  String get settings_security_step_current_title => 'Current password';

  @override
  String get settings_security_step_new_body =>
      'Choose a strong password you have not used here before.';

  @override
  String get settings_security_step_new_title => 'New password';

  @override
  String get settings_security_title => 'Security';

  @override
  String get show_password => 'Show password';

  @override
  String get status_connecting => 'Connecting';

  @override
  String get status_updating => 'Updating';

  @override
  String get suspend_chat_banner_message => 'Your account was blocked';

  @override
  String get suspended_default_reason =>
      'Reason not provided. Your account access is currently read-only.';

  @override
  String get suspended_sheet_action_contact_support => 'Contact support';

  @override
  String get suspended_sheet_desc =>
      'Your account was blocked for violating the community rules.\\nYou can still read your chats, but new messages are currently paused.\\nIf you think this is a mistake, contact support and we can help.';

  @override
  String get suspended_sheet_reason_label => 'Reason';

  @override
  String get suspended_sheet_title => 'Account blocked';

  @override
  String get theme => 'Look';

  @override
  String get typing_alone => 'typing…';

  @override
  String typing_many(Object arg1, Object arg2, Object arg3) {
    return '$arg1, $arg2 and $arg3 more are typing…';
  }

  @override
  String typing_single(Object arg1) {
    return '$arg1 is typing…';
  }

  @override
  String typing_two(Object arg1, Object arg2) {
    return '$arg1 and $arg2 are typing…';
  }

  @override
  String get unknown => 'Unknown';

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
  String get unverify => 'Remove verification';

  @override
  String get username => 'Username';

  @override
  String get username_length_error => 'Username must be 3 to 20 characters';

  @override
  String get verify => 'Verify';

  @override
  String get weekday_fri => 'Friday';

  @override
  String get weekday_mon => 'Monday';

  @override
  String get weekday_sat => 'Saturday';

  @override
  String get weekday_sun => 'Sunday';

  @override
  String get weekday_thu => 'Thursday';

  @override
  String get weekday_tue => 'Tuesday';

  @override
  String get weekday_wed => 'Wednesday';

  @override
  String get welcome => 'Welcome!';
}
