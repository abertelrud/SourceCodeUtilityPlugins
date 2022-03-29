import PackagePlugin
import Foundation

@main
struct ReformatSourceCode: CommandPlugin {

    func performCommand(
        context: PluginContext,
        arguments: [String]
    ) async throws {
        // Start by locating the `swiftformat` command-line tool.
        let swiftFormatTool = try context.tool(named: "swiftformat")

        // Extract the arguments that specify what targets to format.
        var argExtractor = ArgumentExtractor(arguments)
        let targetNames = argExtractor.extractOption(named: "target")
        let targetsToFormat = try context.package.targets(named: targetNames)

        // Warn and do nothing else if we weren't given any targets.
        if targetsToFormat.isEmpty {
            Diagnostics.warning("No targets specified; not doing anything")
            return
        }

        // By convention, use a a configuration file in the package directory.
        let configFile = context.package.directory.appending(".swiftformat")

        // Iterate over the targets in the package.
        for target in targetsToFormat {
            // Skip any type of target that doesn't have source files.
            guard let target = target as? SourceModuleTarget else {
                Diagnostics.warning("Skipping target “\(target.name)” because it doesn't contain Swift sources")
                continue
            }

            // Invoke `swiftformat` on the target directory, passing a configuration
            // file from the package directory.
            let swiftFormatExec = URL(fileURLWithPath: swiftFormatTool.path.string)
            let swiftFormatArgs = [
                "--config", "\(configFile)",
                "--cache", "\(context.pluginWorkDirectory)",
                "\(target.directory)"
            ]
            let process = try Process.run(swiftFormatExec, arguments: swiftFormatArgs)
            process.waitUntilExit()

            // Check whether the subprocess invocation was successful.
            if process.terminationReason == .exit && process.terminationStatus == 0 {
                print("Formatted the source code in \(target.directory).")
            }
            else {
                let problem = "\(process.terminationReason):\(process.terminationStatus)"
                Diagnostics.error("swift-format invocation failed: \(problem)")
            }
        }
    }
}
