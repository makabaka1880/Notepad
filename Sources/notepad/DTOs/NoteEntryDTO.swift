// Created by Sean L. on Jul. 2.
// Last Updated by Sean L. on Jul. 2.
// 
// Notepad - Backend
// Sources/init/DTOs/NoteEntryDTO.swift
// 
// Makabaka1880, 2025. All rights reserved.

import Vapor

struct NoteEntryDTO: Content {
	var id: UUID?
    var title: String
	var createdAt: Date
    var tags: [String]?
	var content: String
}

extension NoteEntry {
	func toDTO() -> NoteEntryDTO {
		.init(
			id: self.id,
			title: self.title,
			createdAt: self.createdAt,
			tags: self.tags,
			content: self.content
		)
	}
}