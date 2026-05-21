allprojects {
    repositories {
        google()
        mavenCentral()
    }
    configurations.all {
        resolutionStrategy.force(
            "org.jetbrains.kotlin:kotlin-stdlib:2.1.21",
            "org.jetbrains.kotlin:kotlin-stdlib-jdk7:2.1.21",
            "org.jetbrains.kotlin:kotlin-stdlib-jdk8:2.1.21",
            "org.jetbrains.kotlin:kotlin-stdlib-common:2.1.21"
        )
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

// Patch: inject namespace for legacy Flutter plugins that declare it only in AndroidManifest.xml
subprojects {
    plugins.withId("com.android.library") {
        val androidLib = extensions.findByType(com.android.build.gradle.LibraryExtension::class.java)
        if (androidLib != null && androidLib.namespace == null) {
            val manifestFile = file("src/main/AndroidManifest.xml")
            if (manifestFile.exists()) {
                val pkg = groovy.xml.XmlParser().parse(manifestFile).attribute("package") as String?
                if (pkg != null) androidLib.namespace = pkg
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
