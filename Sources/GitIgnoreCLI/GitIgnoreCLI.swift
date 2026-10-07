import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@main
struct GitIgnoreCLI {
    static let usage = """
        Usage:
          gitignore list
          gitignore search <keyword>
          gitignore dump <items,comma-separated>

        Examples:
          gitignore search swift
          gitignore dump macos,swift,xcode > .gitignore
        """

    static func main() async {
        do {
            let arguments = Array(CommandLine.arguments.dropFirst())
            if arguments.isEmpty || arguments == ["--help"] || arguments == ["-h"] {
                print(usage)
                return
            }

            let output: Data
            switch arguments[0] {
            case "list":
                guard arguments.count == 1 else { throw CLIError.usage }
                output = Data(try await list().joined(separator: "\n").appending("\n").utf8)
            case "search":
                guard arguments.count == 2,
                    !arguments[1].trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                else { throw CLIError.usage }
                let matches = try await list().filter {
                    $0.localizedCaseInsensitiveContains(arguments[1])
                }
                output = Data((matches.isEmpty ? "" : matches.joined(separator: "\n") + "\n").utf8)
            case "dump":
                guard arguments.count == 2 else { throw CLIError.usage }
                let items = arguments[1].split(separator: ",", omittingEmptySubsequences: false)
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
                let allowed = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz0123456789-_.+")
                guard items.allSatisfy({ item in
                    !item.isEmpty && item.unicodeScalars.allSatisfy { allowed.contains($0) }
                }) else { throw CLIError.invalidItems }
                output = try await fetch(items.joined(separator: ","))
            default:
                throw CLIError.usage
            }
            try FileHandle.standardOutput.write(contentsOf: output)
        } catch {
            let message = "gitignore: \(error.localizedDescription)\n"
            try? FileHandle.standardError.write(contentsOf: Data(message.utf8))
            exit(1)
        }
    }

    private static func list() async throws -> [String] {
        let data = try await fetch("list")
        guard let text = String(data: data, encoding: .utf8) else {
            throw CLIError.invalidResponse
        }
        return text.split { $0 == "," || $0.isWhitespace }.map(String.init).sorted()
    }

    private static func fetch(_ path: String) async throws -> Data {
        let url = URL(string: "https://www.toptal.com/developers/gitignore/api/")!
            .appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.timeoutInterval = 30
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse else {
            throw CLIError.invalidResponse
        }
        guard (200..<300).contains(response.statusCode) else {
            throw CLIError.http(response.statusCode)
        }
        return data
    }

    private enum CLIError: LocalizedError {
        case usage
        case invalidItems
        case invalidResponse
        case http(Int)

        var errorDescription: String? {
            switch self {
            case .usage: GitIgnoreCLI.usage
            case .invalidItems: "Specify nonempty template names separated by commas."
            case .invalidResponse: "The API returned an invalid response."
            case .http(let status):
                status == 404
                    ? "Unknown template. Use 'gitignore list' to see available templates."
                    : "The API returned HTTP \(status)."
            }
        }
    }
}
