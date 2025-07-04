import Fluent

struct CreateNoteEntries: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("entries")
            .id()
            .field("title", .string, .required)
            .field("created_at", .date, .required)
            .field("tags", .array(of: .string))
            .field("content", .string, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("todos").delete()
    }
}

