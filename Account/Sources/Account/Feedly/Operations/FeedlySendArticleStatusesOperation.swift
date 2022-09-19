//
//  FeedlySendArticleStatusesOperation.swift
//  Account
//
//  Created by Kiel Gillard on 14/10/19.
//  Copyright © 2019 Ranchero Software, LLC. All rights reserved.
//

import Foundation
import Articles
import SyncDatabase
import RSCore


/// Take changes to statuses of articles locally and apply them to the corresponding the articles remotely.
final class FeedlySendArticleStatusesOperation: FeedlyOperation, Logging {

	private let database: SyncDatabase
	private let service: FeedlyMarkArticlesService

	init(database: SyncDatabase, service: FeedlyMarkArticlesService) {
		self.database = database
		self.service = service
	}
	
	override func run() {
        logger.debug("Sending article statuses...")

		database.selectForProcessing { result in
			if self.isCanceled {
				self.didFinish()
				return
			}
			
			switch result {
			case .success(let syncStatuses):
				self.processStatuses(syncStatuses)
			case .failure:
				self.didFinish()
			}
		}
	}
}

private extension FeedlySendArticleStatusesOperation {

	func processStatuses(_ pending: [SyncStatus]) {
		let statuses: [(status: SyncStatus.Key, flag: Bool, action: FeedlyMarkAction)] = [
			(.read, false, .unread),
			(.read, true, .read),
			(.starred, true, .saved),
			(.starred, false, .unsaved),
		]

		let group = DispatchGroup()

		for pairing in statuses {
			let articleIds = pending.filter { $0.key == pairing.status && $0.flag == pairing.flag }
			guard !articleIds.isEmpty else {
				continue
			}

			let ids = Set(articleIds.map { $0.articleID })
			let database = self.database
			group.enter()
			service.mark(ids, as: pairing.action) { result in
				assert(Thread.isMainThread)
				switch result {
				case .success:
					database.deleteSelectedForProcessing(Array(ids)) { _ in
						group.leave()
					}
				case .failure:
					database.resetSelectedForProcessing(Array(ids)) { _ in
						group.leave()
					}
				}
			}
		}

		group.notify(queue: DispatchQueue.main) {
            self.logger.debug("Done sending article statuses.")
			self.didFinish()
		}
	}
}
