//
//
//  Created by Tapash Majumder on 5/2/19.
//  Copyright © 2019 Iterable. All rights reserved.
//

import Foundation

protocol DependencyContainerProtocol {
    var dateProvider: DateProviderProtocol { get }
    var networkSession: NetworkSessionProtocol { get }
    var notificationStateProvider: NotificationStateProviderProtocol { get }
    var localStorage: LocalStorageProtocol { get }
    var inAppDisplayer: InAppDisplayerProtocol { get }
    var inAppPersister: InAppPersistenceProtocol { get }
    var urlOpener: UrlOpenerProtocol { get }
    var applicationStateProvider: ApplicationStateProviderProtocol { get }
    var notificationCenter: NotificationCenterProtocol { get }
    
    func createInAppFetcher(internalApi: IterableAPIInternal) -> InAppFetcherProtocol
}

extension DependencyContainerProtocol {
    func createInAppManager(config: IterableConfig, internalApi: IterableAPIInternal) -> IterableInAppManagerProtocolInternal {
        return InAppManager(internalApi: internalApi,
                            fetcher: createInAppFetcher(internalApi: internalApi),
                            displayer: inAppDisplayer,
                            persister: inAppPersister,
                            inAppDelegate: config.inAppDelegate,
                            urlDelegate: config.urlDelegate,
                            customActionDelegate: config.customActionDelegate,
                            urlOpener: urlOpener,
                            applicationStateProvider: applicationStateProvider,
                            notificationCenter: notificationCenter,
                            dateProvider: dateProvider,
                            retryInterval: config.inAppDisplayInterval)
    }
}

struct DependencyContainer : DependencyContainerProtocol {
    func createInAppFetcher(internalApi: IterableAPIInternal) -> InAppFetcherProtocol {
        return InAppFetcher(internalApi: internalApi)
    }
    
    let dateProvider: DateProviderProtocol = SystemDateProvider()
    let networkSession: NetworkSessionProtocol = URLSession(configuration: .default)
    let notificationStateProvider: NotificationStateProviderProtocol = SystemNotificationStateProvider()
    let localStorage: LocalStorageProtocol = UserDefaultsLocalStorage()
    let inAppDisplayer: InAppDisplayerProtocol = InAppDisplayer()
    let inAppPersister: InAppPersistenceProtocol = InAppFilePersister()
    let urlOpener: UrlOpenerProtocol = AppUrlOpener()
    let applicationStateProvider: ApplicationStateProviderProtocol = UIApplication.shared
    let notificationCenter: NotificationCenterProtocol = NotificationCenter.default
}