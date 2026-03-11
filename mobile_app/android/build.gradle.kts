allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// AGP 8+ requires `namespace` for all Android modules.
// Some third-party Flutter plugins (e.g. older `isar_flutter_libs`) may omit it.
subprojects {
    pluginManager.withPlugin("com.android.library") {
        // AGP 8+ forbids package= in library manifests; some older plugins still ship it.
        val manifestFile = project.file("src/main/AndroidManifest.xml")
        if (manifestFile.exists()) {
            val original = manifestFile.readText()
            val patched = original.replace(
                Regex("""<manifest([^>]*?)\spackage="[^"]*"([^>]*?)>"""),
                "<manifest$1$2>",
            )
            if (patched != original) {
                manifestFile.writeText(patched)
            }
        }

        val androidExt = extensions.findByName("android") ?: return@withPlugin
        val getNamespace = androidExt.javaClass.methods.firstOrNull { it.name == "getNamespace" }
        val setNamespace = androidExt.javaClass.methods.firstOrNull {
            it.name == "setNamespace" && it.parameterTypes.size == 1
        }

        if (getNamespace == null || setNamespace == null) return@withPlugin

        val currentNamespace = getNamespace.invoke(androidExt) as? String
        if (currentNamespace.isNullOrBlank()) {
            val fallbackNamespace = "dev.flutter.plugins.${project.name.replace('-', '_')}"
            setNamespace.invoke(androidExt, fallbackNamespace)
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
