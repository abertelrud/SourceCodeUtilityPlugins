import PackagePlugin
import Foundation

@main
struct RegenerateContributorsList: CommandPlugin {

    func performCommand(
        context: PluginContext,
        arguments: [String]
    ) async throws {
        // Start by locating the `generate_contributors.sh` script.
        let scriptsDir = Path(#filePath).removingLastComponent()
        let scriptFile = scriptsDir.appending(subpath: "generate_contributors_list.sh")

        // Extract the arguments that specify what targets to format.
        var argExtractor = ArgumentExtractor(arguments)
        let verbose = argExtractor.extractFlag(named: "verbose")

        // Invoke `generate_contributors_list.sh` on the package directory,
        // passing a configuration file from the package directory.
        let scriptExec = URL(fileURLWithPath: scriptFile.string)
        var scriptArgs: [String] = []
        if verbose > 0 {
            scriptArgs.append("--verbose")
        }
        scriptArgs.append("\(context.package.directory)")
        let process = try Process.run(scriptExec, arguments: scriptArgs)
        process.waitUntilExit()

        // Check whether the subprocess invocation was successful.
        if process.terminationReason == .exit && process.terminationStatus == 0 {
            print("Regenerated the contributors list in \(context.package.directory).")
        }
        else {
            let problem = "\(process.terminationReason):\(process.terminationStatus)"
            Diagnostics.error("generate_contributors_list.sh invocation failed: \(problem)")
        }
    }
}
