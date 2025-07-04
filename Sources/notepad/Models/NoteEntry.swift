// Created by Sean L. on Jul. 2.
// Last Updated by Sean L. on Jul. 2.
// 
// Notepad - Backend
// Sources/init/Models/NoteEntry.swift
// 
// Makabaka1880, 2025. All rights reserved.

import Fluent

final class NoteEntry: Model, @unchecked Sendable {
	static let schema: String = "entries"

	@ID
	var id: UUID?

	@Field(key: "title")
	var title: String

	@Field(key: "created_at")
	var createdAt: Date

	@Field(key: "tags")
	var tags: [String]?

	@Field(key: "content")
	var content: String

	init() { }

	init(
		id: UUID? = nil,
		title: String,
		createdAt: Date,
		tags: [String]? = nil,
		content: String
	) {
		self.id = id
		self.title = title
		self.createdAt = createdAt
		self.tags = tags
		self.content = content
	}
}

extension NoteEntryDTO {
	func toModel() -> NoteEntry {
		.init(
			id: self.id,
			title: self.title,
			createdAt: self.createdAt,
			tags: self.tags,
			content: self.content
		)
	}
}