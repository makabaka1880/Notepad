// Created by Sean L. on Jun. 28.
// Last Updated by Sean L. on Jun. 28.
// 
// Notepad - Backend
// Sources/Utils/SecretsManager.swift
// 
// Sean L., 2025. All rights reserved.

#if DEBUG
import SwiftDotenv
#endif
import Foundation

enum SecretsKey: String, CaseIterable {
	case dbUsername         = "NOTEPAD_DB_USERNAME"
	case dbPassword         = "NOTEPAD_DB_PASSWORD"
	case dbHost             = "NOTEPAD_DB_HOST"
	case dbName             = "NOTEPAD_DB_NAME"
	case dbPort             = "NOTEPAD_DB_PORT"
	case adminPanelKey      = "NOTEPAD_ADMIN_PANEL_TOKEN"
    case adminReviewKey     = "NOTEPAD_ADMIN_REVIEW_TOKEN"
	case maintenanceMode    = "NOTEPAD_MAINTENANCE_MODE"
    case writeToken         = "NOTEPAD_DB_WRITE_TOKEN"
    case deleteToken        = "NOTEPAD_DB_DELETE_TOKEN"
    case badgeFetchPAT      = "NOTEPAD_BADGE_FETCH_PAT"
    case bucketUrl          = "NOTEPAD_BUCKET_URL"
}

class SecretsManager {
	static func configure() {
		#if DEBUG
		do {
			try Dotenv.configure()
			print("✅ Loaded .env for DEBUG")
		} catch {
			print("⚠️ Could not load .env file: \(error)")
		}
		#else
		let secretsPath = "/run/secrets"
		let fm = FileManager.default

		for key in SecretsKey.allCases {
			let filename = key.rawValue
			let fullPath = secretsPath + "/" + filename

			if fm.fileExists(atPath: fullPath),
			let contents = try? String(contentsOfFile: fullPath, encoding: .utf8) {
				let trimmed = contents.trimmingCharacters(in: .whitespacesAndNewlines)
				setenv(filename, trimmed, 1)
				print("🔐 Loaded secret: \(filename)")
			} else {
                if ProcessInfo.processInfo.environment[filename] == nil {
                    print("⚠️ Missing or unreadable secret: \(filename)")
                } else {
                    print("✅ Secret loaded from env var: \(filename)")
                }
			}
		}
		#endif
	}

	/// Check if a given token matches the environment secret for that key
	static func authenticate(key: SecretsKey, against test: String) -> Bool {
		guard let actual = ProcessInfo.processInfo.environment[key.rawValue] else {
			print("⚠️ Secret \(key.rawValue) not found in environment")
			return false
		}
		return actual == test
	}

	/// Helper to fetch secret string from environment
	static func get(_ key: SecretsKey) -> String? {
		return ProcessInfo.processInfo.environment[key.rawValue]
	}
}