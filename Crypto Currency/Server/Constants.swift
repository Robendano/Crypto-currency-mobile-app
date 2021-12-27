//
//  Constants.swift
//  Crypto Currency
//
//  Created by Aidar Bekturov on 13/12/21.
//

import Foundation

struct ServerConstants {
  struct ErrorMessage {
    static let NO_INTERNET_CONNECTION = "Подключение к Интернету отсутствует"
    static let UNABLE_LOAD_DATA = "Невозможно загрузить данные"
    static let NO_HTTP_STATUS_CODE = "Невозможно получить ответ HTTP-код состояния"
    static let FORBIDDEN = "Ошибка 403"
    static let UNAUTHORIZED = "Unauthorized error"
    static let NOT_FOUND = "404 Ненайдено"
    static let SERVER_ERROR = "Сервер не работает"
    static let BAD_REQUEST = "Ошибка 400"
  }
}
