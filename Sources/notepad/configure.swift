import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor

public func configure(_ app: Application) async throws {
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    SecretsManager.configure()

    let dbHost = SecretsManager.get(.dbHost) ?? "localhost"
    let dbPort = SecretsManager.get(.dbPort).flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber
    let dbUsername = SecretsManager.get(.dbUsername) ?? "vapor_username"
    let dbPassword = SecretsManager.get(.dbPassword) ?? "vapor_password"
    let dbName = SecretsManager.get(.dbName) ?? "vapor_database"

    print("dbHost: \(dbHost)")
    print("dbPort: \(dbPort)")
    print("dbUsername: \(dbUsername)")
    print("dbPassword: \(dbPassword)")
    print("dbName: \(dbName)")
    app.databases.use(
        .postgres(
            configuration: .init(
                hostname: dbHost,
                port: dbPort,
                username: dbUsername,
                password: dbPassword,
                database: dbName,
                tls: .prefer(try .init(configuration: .clientDefault))
            )
        ),
        as: .psql
    )

    app.logger.info("🔌 Connecting to PostgreSQL at \(dbHost):\(dbPort) as \(dbUsername) on database '\(dbName)'")

    app.migrations.add(CreateNoteEntries())

    Task {
        do {
            let count = try await NoteEntry.query(on: app.db).count()
            app.logger.info("📬 Connected to DB — found \(count) entries in '\(NoteEntry.schema)' table.")
        } catch {
            app.logger.error("❌ Failed to query '\(NoteEntry.schema)' table: \(error)")
        }
    }
    
    let corsConfig = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .DELETE, .OPTIONS],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent]
    )

    // register routes
    try routes(app)
}
