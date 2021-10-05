// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Add
  internal static let add = L10n.tr("Localizable", "add")
  /// Add to favorites
  internal static let addToFavorites = L10n.tr("Localizable", "add_to_favorites")
  /// All
  internal static let all = L10n.tr("Localizable", "all")
  /// d2frdirPKmh2OC5STRU4AdRYHkHKelZZB1UiBwEC
  internal static let applicationId = L10n.tr("Localizable", "applicationId")
  /// Cancel
  internal static let cancel = L10n.tr("Localizable", "cancel")
  /// childDetails
  internal static let childDetails = L10n.tr("Localizable", "child_details")
  /// bgUpLtYqHwES7ZWyOMtXXbI92ZspcKkXanuzKTSt
  internal static let clientKey = L10n.tr("Localizable", "clientKey")
  /// Delete
  internal static let delete = L10n.tr("Localizable", "delete")
  /// Delete from favorites?
  internal static let deleteFromFavorites = L10n.tr("Localizable", "delete_from_favorites")
  /// Deleting
  internal static let deleting = L10n.tr("Localizable", "deleting")
  /// Details
  internal static let details = L10n.tr("Localizable", "details")
  /// DetailsViewController
  internal static let detailsViewController = L10n.tr("Localizable", "details_view_controller")
  /// Couldn't fetch data from API
  internal static let emptyData = L10n.tr("Localizable", "empty_data")
  /// Error
  internal static let error = L10n.tr("Localizable", "error")
  /// Favorites
  internal static let favorites = L10n.tr("Localizable", "favorites")
  /// An error occurred. Please try again
  internal static let genericError = L10n.tr("Localizable", "generic_error")
  /// heart
  internal static let heart = L10n.tr("Localizable", "heart")
  /// heart.fill
  internal static let heartFill = L10n.tr("Localizable", "heart_fill")
  /// init(coder:) has not been implemented
  internal static let initError = L10n.tr("Localizable", "init_error")
  /// Couldn't get JSON data
  internal static let invalidJson = L10n.tr("Localizable", "invalid_json")
  /// Error connecting to API
  internal static let invalidResponse = L10n.tr("Localizable", "invalid_response")
  /// Leave a comment
  internal static let leaveAComment = L10n.tr("Localizable", "leave_a_comment")
  /// Movie
  internal static let movie = L10n.tr("Localizable", "movie")
  /// Movies
  internal static let movies = L10n.tr("Localizable", "movies")
  /// navBar
  internal static let navBarColor = L10n.tr("Localizable", "nav_bar_color")
  /// OK
  internal static let ok = L10n.tr("Localizable", "ok")
  /// parentMovie
  internal static let parentMovie = L10n.tr("Localizable", "parent_movie")
  /// poster-
  internal static let poster = L10n.tr("Localizable", "poster")
  /// Both passwords must be the same
  internal static let registerErrorDifferentPasswords = L10n.tr("Localizable", "register_error_different_passwords")
  /// All fields must be filled
  internal static let registerErrorEmptyFields = L10n.tr("Localizable", "register_error_empty_fields")
  /// Invalid email
  internal static let registerErrorInvalidEmail = L10n.tr("Localizable", "register_error_invalid_email")
  /// Invalid e-mail or password
  internal static let registerErrorInvalidEmailOrPassword = L10n.tr("Localizable", "register_error_invalid_email_or_password")
  /// Password must be between 8 and 16 characters, with at least one capital and one lowercase letter
  internal static let registerErrorInvalidPassword = L10n.tr("Localizable", "register_error_invalid_password")
  /// Please type your full name
  internal static let registerErrorNameFull = L10n.tr("Localizable", "register_error_name_full")
  /// releaseDate
  internal static let releaseDate = L10n.tr("Localizable", "release_date")
  /// Current password is incorrect
  internal static let resetpasswordMessageWrongCurrentPassword = L10n.tr("Localizable", "resetpassword_message_wrong_current_password")
  /// Saving
  internal static let saving = L10n.tr("Localizable", "saving")
  /// Search Movie
  internal static let searchMovie = L10n.tr("Localizable", "search_movie")
  /// https://parseapi.back4app.com/
  internal static let server = L10n.tr("Localizable", "server")
  /// totoro
  internal static let totoroColor = L10n.tr("Localizable", "totoro_color")
  /// TOTORO
  internal static let totoroImage = L10n.tr("Localizable", "totoro_image")
  /// https://ghibliapi.herokuapp.com/films
  internal static let url = L10n.tr("Localizable", "url")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
