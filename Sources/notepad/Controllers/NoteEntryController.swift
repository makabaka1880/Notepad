import Fluent
import Vapor

struct NoteEntryController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let noteEntries = routes.grouped("entries")

        noteEntries.get(use: self.index)
        noteEntries.post(use: self.create)
        noteEntries.group(":id") { noteEntry in
            noteEntry.delete(use: self.delete)
        }
    }

    @Sendable
    func index(req: Request) async throws -> [NoteEntryDTO] {
        try await NoteEntry.query(on: req.db).all().map { $0.toDTO() }
    }

    @Sendable
    func create(req: Request) async throws -> NoteEntryDTO {
        let noteEntry = try req.content.decode(NoteEntryDTO.self).toModel()

        try await noteEntry.save(on: req.db)
        return noteEntry.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let noteEntry = try await NoteEntry.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await noteEntry.delete(on: req.db)
        return .noContent
    }
}
