---
layout: post
title:  "Building a decent Java CLI"
date:   2020-07-27 05:30:00 +0200
---
{::comment}
vim: set fo=aw2tq, tw=120, spelllang=en
{:/comment}

Usage and availability of command line interface (CLI) tools for developers is thriving. Almost
every webservice, every build tool, every framework has its own CLI tool. The concept is not going
away any time soon because it's just too convenient: They are easy to build (as opposed to
graphical/web UIs), they can easily be combined for automation in scripts and last but not least,
it's way easier to write documentation or Stack Overflow posts that says "just run `foo --bar --baz
--frux=blorb`" instead of "open the `Foo` dialog, then in the `Bar` tab look for the `Baz`
dropdown..." and so on.

Unfortunately, it's too easy to build crappy CLI tools, especially in the Java universe. This post
addresses some of the pitfalls and then takes a look at a number of available technologies to assist
us building decent CLI tools in Java.

## Let's start with the basics

There are certain established patterns most CLI tools follow, and it's a good idea to have your tool
follow them too -- your users will thank you for it, because it requires them to remember fewer
specific idiosyncrasies. Of course there are always exceptions, but unless there's a good reason for
one, stick to the rules. The following list is probably not complete, but should provide a starting
point.

### The rules that should be obvious, but apparently aren't always

1. The name of your command should be lowercase.
1. The name of your command should be easy to remember.
1. The name of your command should not clash with other commonly used command names.
1. There are arguments (longer, such as `--foo`), options (shorter, such as `-x`) and command names
   (such as `commit`). Sometimes there is a long argument and a short option for the same thing.
   Sometimes there are file names as arguments. Long arguments should not start with only a single
   dash (examples of commands violating this rule: `convert` and `javac`). Never _ever_ does an
   argument or switch start with a `/` (unless it's an absolute path in a file system, obviously).
1. When file names are given as arguments, absolute or relative paths (starting at the current
   working directory) are valid.

### Help me `--help` switch, you're my only hope

1. There should be a `--help` switch. It's OK when you also have `-h`.
1. If the command is started with the wrong arguments or some other error occurs, the user should
   get at least some hints. Even better is an error message that exactly states what went wrong and
   why and maybe what the user could do to solve it.

   [![Helpful ls output]({{ "/assets/cli-ls-color.png" | width=678 | prepend: site.baseurl }})]({{"/assets/cli-ls-color.png" | prepend: site.baseurl }}){:width="678px" height="324px"}

1. If there's more documentation than what `--help` gives you (e.g. `man` page or web page), there
   should be an explicit hint on where to find it (e.g. "See fooblorb(1)" or "See
   https://flooblorb.com").
1. Online documentation is fine nowadays, as are `man` pages. Don't use GNU Info pages. Everybody
   either never heard of them or hates them.

## More advanced topics, but still kinda basic

### A series of tubes

1. A big use case for CLI tools are pipelines. If the command takes a file name as input, it should also
   accept `-` as file name, meaning "read from `stdin`". If it takes a file name as output, it should
   also accept `-` as file name, meaning "write to `stdout`".
1. If the command writes textual output (i.e. not binary), and the user did not explicitly specify a
   target file, the default behavior should be to write to `stdout`, _not_ some arbitrary default
   file name. This _may_ also be the correct behavior for binary output (c.f. for example
   ImageMagick's `convert`).
1. The command will not only write to an interactive shell, but will also be piped to other commands
   or redirected to be written to files. Don't create garbled output when the command is piped for
   example into `less`.

Bad example: The result when trying `mvn dependency:tree | less`
[![Garbled output of maven]({{ "/assets/cli-maven-garbled.png" | prepend: site.baseurl }})]({{ "/assets/cli-maven-garbled.png" | prepend: site.baseurl }})

### Color me impressed

1. Colored output via ANSI escapes can help a user. However, again, be aware that your output may go
   to a pipeline where this is not appreciated, for example in a build pipeline of a tool that does
   not understand/render ANSI escapes. There are ways to detect this and react accordingly: Ideally
   the command just behaves correctly depending on the output; at the very least provide an option
   to disable colored output if you have it.

Good example: The output of `gradle app:dependencies` on the left, and the same thing piped into `less` on
the right
[![Color output]({{ "/assets/cli-gradle-color.jpg" | prepend: site.baseurl }})]({{ "/assets/cli-gradle-color.jpg" | prepend: site.baseurl }})

### You're sending the right signals

1. The command should refrain from doing magic OS signal handling, especially with SIGINT. In other
   words, it's possible to register a signal handler that catches the user's input of CTRL+C and
   just ignores it. Don't do that, CTRL+C should always stop your command. The same holds for
   SIGTERM. Fortunately, this one is rare in the Java universe, because there's no portable way to
   handle arbitrary signals.

### The right amount of output

1. It's nice to have some kind of feedback while your command is working for more than a second. Bad
   example: Old standard `cp` when copying large files, just sitting there for minutes without any
   feedback.
1. On the other hand, _please_ don't flood the user with logs, debug statements and ASCII art
   banners (I'm looking at you, Spring Boot). While logging lots of stuff might be harmless and
   actually even desirable for something like a web service starting up, you do not want that with a
   CLI tool. Output what is necesary, and only that.
1. If it's a non-trivial command, it's good to be able to change the log level, i.e. how much
   information it writes out. For example, when calling `mvn` you can pass `-X` to enable debug
   output, for `gradle` it's `-d` and in many other tools, e.g. `ssh`, you can pass `-v` for
   "verbose" and stack the switch for increasing levels of output (`-vv`, `-vvv` etc.).

### Other rules for good CLIs and Nice-To-Haves

If unsure, take a look at how other tools behave. I mean, the concept of command line tools is
really not that new. Just a few more points:

1. If building anything remotely interactive, know the basic terminology (shell, terminal, terminal
   emulator, tty etc.). There's tons of information available. It's also good to know the
   rough distinctions between command lines in Unix-land and Windows.
1. Just like with a GUI or Web UI, the CLI should not leave the user wondering if it froze or is
   still doing something. Therefore, it should react snappily: For example, starting it with
   `--help` should yield a result _instantly_, i.e. not only after a few seconds of doing ...
   something. You may know that it is starting a JVM, scanning the classpath or whatever it is
   doing, but the user should not have to care. This particular point can be tricky in Java, we'll
   come back to it later.

   Starting a Java-based CLI (symbol picture) [Author: [Rowan](https://www.flickr.com/photos/bupp/), Licenced [by-nc-nd](https://creativecommons.org/licenses/by-nc-nd/2.0/), [Source](https://www.flickr.com/photos/bupp/424464685/)]
   [![Sleeping at the keyboard]({{ "/assets/cli-sleep.jpg" | prepend: site.baseurl }})]({{ "/assets/cli-sleep.jpg" | prepend: site.baseurl }})

1. The following is just an example: The command might have some `login` functionality (think e.g.
   Microsoft Azure CLI `az` or Travis CI `travis`) and needs to locally store credentials. Do I only
   have a choice between storing credentials in plain text or to reinvent the wheel? Of course not.
   Look up for example .authinfo.gpg, how `git` is handling credential storage (auth helpers) or
   platform-specific mechanisms such as keyrings. Yes, even when you're not building a GUI, it's
   possible to use OS APIs. The more general point is: Please stick to the best practices. Chances
   are high someome already solved that problem[^1].

## How to Build it in Java

Now that we've established the rules, let's take a look at the tools we have available and patterns
that might help.

### Parsing the command line

The basic general functionality we'll need is parsing the arguments and providing corresponding
help. For this we have the following options:

1. Roll your own. This is probably not advisable for anything but the simplest of cases, so we'll
   not go into detail here.
1. Using [JCommander](https://jcommander.org/). JCommander is a library that allows you to annotate
   fields with the names of the arguments and a way to automatically parse your main function's
   arguments. The following example is taken straight from its documentation:

   ```java
   class Main {
      @Parameter(names={"--length", "-l"})
      int length;
      @Parameter(names={"--pattern", "-p"})
      int pattern;

      public static void main(String ... argv) {
          Main main = new Main();
          JCommander.newBuilder()
              .addObject(main)
              .build()
              .parse(argv);
          main.run();
      }

      public void run() {
          System.out.printf("%d %d", length, pattern);
      }
   }
   ```

   JCommander has features such as repeatable arguments, interfaces for converters (e.g. for handling
   files) and custom validation. It has basic support for subcommands (e.g. `git commit`).
1. Using [Picocli](https://picocli.info/). In its goals it's comparable to JCommander, however it is
   the more active project and provides a lot more features such as positional parameters, colored
   and configurable help output, solid support for nesting subcommands and shared parameters via
   mixins. The following example is taken from Picocli's [Quick
   Guide](https://picocli.info/quick-guide.html):

   ```java
   @Command(description = "Prints the checksum (MD5 by default) of a file to STDOUT.",
            name = "checksum", mixinStandardHelpOptions = true, version = "checksum 3.0")
   class CheckSum implements Callable<Integer> {
      @Parameters(index = "0", description = "The file whose checksum to calculate.")
      private File file;

      @Option(names = {"-a", "--algorithm"}, description = "MD5, SHA-1, SHA-256, ...")
      private String algorithm = "SHA-1";

      public static void main(String... args) throws Exception {
         int exitCode = new CommandLine(new CheckSum()).execute(args);
         System.exit(exitCode);
      }

      @Override
      public Integer call() throws Exception {
         byte[] fileContents = Files.readAllBytes(file.toPath());
         byte[] digest = MessageDigest.getInstance(algorithm).digest(fileContents);
         System.out.println(javax.xml.bind.DatatypeConverter.printHexBinary(digest));
         return 0;
      }
   }
   ```

   Picocli's documentation covers many topics that go beyond just parsing the command line but that
   could come up in building your CLI tool, such as internationalization, testing or generating tab
   completion scripts for your command for popular shells. There's a lot of
   [examples](https://github.com/remkop/picocli/tree/master/picocli-examples/src/main/java/picocli/examples)
   available.

Both projects do their job quite well, although Picocli has, apart from being more feature-rich,
some more support for different ways to start our command, as we will see in the following sections.

### Nice output and interactive TextUI

1. To generate portable colored text output from Java, you'll want to use
   [jansi](https://github.com/fusesource/jansi), which describes itself as follows: "Jansi is a
   small java library that allows you to use ANSI escape sequences to format your console output
   which works even on windows." In fact, Picocli also uses Janso to create colored output.
1. To handle interactive text input (i.e. you can input a line of text and use the arrow keys and
   backspace to edit), you'll want to use [jline3](https://github.com/jline/jline3). Getting this
   right in a portable way could otherwise be tricky. In order to make Jline work on all platforms,
   you'll need support for positioning the cursor, for which it can again use Jansi[^2]. Convenient.
1. If you need a complete text-based user interface with input forms, buttons, checkboxes etc., you
   can check out [lanterna](https://github.com/mabe02/lanterna), which is similar to
   [ncurses](https://en.wikipedia.org/wiki/Ncurses), except it's written in Java and requires no
   native libraries.

### Options for starting your Command

Let's be blunt: When you have written a cool new CLI tool called `foo`, a user wants to run `foo
--help`, not `java -jar ~/somewhere/foo-1.0.jar --help`. So what options do we have to remedy that?

Unlike virtually every other programming language environment, Java does not have a package
mechanism that allows a user to install commands directly into their PATH (think `npm install -g`,
`pip install`, etc.). The next best thing would be something like `mvn dependency:get
-Dartifact=com.foo:foo:1.0`, which is ... not really what we want. So what we can do is one of the
following:

1. Use a wrapper script. Write a shell script that optionally checks for an installed JVM, then runs
   your jar with the provided arguments[^3].
1. Use a shell alias. This would have to be set in the user's environment and basically does the
   same thing as the wrapper script.
1. Use a wrapper-compiler such as [launch4j](http://launch4j.sourceforge.net/) that creates a native
   executable that wraps your .jar and either bundles a JRE or uses an already-installed JRE on the
   user's computer. It's good because we can finally directly call `foo`, but it's not optimal
   because the command still needs to spin up a JVM.
1. Then there's [GraalVM Native Image](https://www.graalvm.org/docs/reference-manual/native-image/),
   which takes your Java application and compiles it into a standalone binary that does not require
   a JVM any more (which can be an advantage in itself). The binary includes the code from all
   necessary classes, dependencies, runtime library classes from JDK and statically linked native
   code from JDK. Unlike your regular Java application that needs to first start up a JVM, this
   standalone binary starts instantly. A CLI tool is the type of application that profits the most
   from the increased startup speed of a native binary, so this is the approach that makes the most
   sense for us: This way we can avoid the annoying delay at startup. Unfortunately, it's also the
   trickiest to make work. Additionally, keep in mind that you will have to build a separate binary
   for every platform you're going to support, and [cross-compilation is not
   supported](https://github.com/oracle/graal/issues/407).

### Building a Native Image for your CLI tool

How can GraalVM create a native image, considering there's things like reflection or annotations
that are evaluated at runtime?

1. GraalVM Native Image does a static analysis of your code and its dependencies. This covers all of
   your regular Java code, but requires all dependencies to be present at build time.
1. For features such as reflection, JNI, Classpath Resources or Dynamic Proxies, there is a
   so-called Tracing Agent: The application is built as a regular executable jar and is then
   executed with a Java agentlib provided by GraalVM which traces all calls and creates JSON files
   describing the respective features: `reflect-config.json`, `jni-config.json`,
   `resource-config.json` and `proxy-config.json`. These are then read by the native image compiler.
   There is a [dedicated
   tutorial](https://github.com/oracle/graal/blob/master/substratevm/CONFIGURE.md) on this.
1. For handling annotations with runtime retention, you can write your own JSON descriptors that
   control what should be visible at build time and how. Sometimes you get tool support for that,
   for example Picocli [provides an annotation
   processor](https://picocli.info/#_graalvm_native_image) you can plug in your build setup to have
   the JSON descriptors for Picocli's annotations automatically generated from your annotated code.
1. Scanning the class path at runtime must be changed to be done at build time instead. If you use
   [classgraph](https://github.com/classgraph/classgraph) for that, there's a [separate
   guide](https://github.com/classgraph/classgraph/wiki/Build-Time-Scanning) on that.
1. Certain things, for example CGLIB Proxies, won't work in GraalVM Native image.
1. If you intend to use Spring Boot (e.g. with `@SpringBootConsoleApplication`) with GraalVM, the
   good news is, [it's possible in
   principle](https://spring.io/blog/2020/04/16/spring-tips-the-graalvm-native-image-builder-feature).
   Some preparations need to be made: Classpath scanning must be configured to be performed at build
   time, CGLIB Proxies must be disabled, Autoconfiguration needs some hints to make it work at build
   time. All in all, it's pretty tedious;
   [here](https://blog.codecentric.de/en/2020/05/spring-boot-graalvm/) is an article that walks you
   through it. Additionally, you will still have to configure the default logging behavior and
   disable the Spring Boot Banner to not spam your user.

### Putting it all together: Frameworks

So we've determined that it's a good idea to use Picocli and GraalVM. To combine those technologies
to build a base for your command line application, you have, again, different options on how you
approach this:

1. Use just Picocli and set up GraalVM in your build. There's [an excellent
   article](https://www.infoq.com/articles/java-native-cli-graalvm-picocli/) on how to do this by
   Remko Popma, the author of Picocli.
1. The [Quarkus](https://quarkus.io) framework, "a Kubernetes Native Java stack tailored for OpenJDK
   HotSpot and GraalVM" can also be used to write a CLI tool. There is [a
   guide](https://quarkus.io/guides/picocli) to build a Quarkus Command Mode application using
   Picocli, however this is considered experimental as of now.
1. Then there's the [Micronaut](https://micronaut.io/) framework, which is targeted at "building
   modular, easily testable microservice and serverless applications." In Micronaut, Picocli is a
   first class citizen using the [Micronaut Picocli
   Configuration](https://micronaut-projects.github.io/micronaut-picocli/latest/guide/). The easiest
   way to get started here is using the [Micronaut Launcher](https://micronaut.io/launch/), which is
   comparable to the [Spring initializr](https://start.spring.io/). Be sure to change the project
   type from "Application" to "CLI Application" in the top left dropdown: This will include Picocli
   and let you download a project that can directly be compiled to a native binary using GraalVM
   Native Image.

   [![Micronaut Launcher]({{ "/assets/cli-micronaut.png" | prepend: site.baseurl }})]({{ "/assets/cli-micronaut.png" | prepend: site.baseurl }})

### Tips for building with GraalVM

Let's assume you've already set up your project using one of the options described in the previous
section and are about to build all the cool functionality of your tool. If your application depends
on third-party dependencies that fall into one of the "tricky" categories of GraalVM, you might have
to fiddle around at times. Here's some of the points I've stumpled upon:

1. If you use Picocli's annotation processor to generate GraalVM configurations and _in addition to
   that_ want to provide GraalVM configurations that you maintain yourself (either written entirely
   manually or initially generated using the Tracing Agent), use two different paths for both. For
   example, put the maintained configs into `${project.projectDir}/native-image`, then have
   `native-image` automatically merge the configs from both paths via a command line switch such as
   `-H:ConfigurationFileDirectories=${project.projectDir}/native-image,${buildDir}/classes/java/main/META-INF/native-image/picocli-generated/yourtool`.
   Otherwise configs will either be overwritten or ignored during the build.
1. GraalVM has the concept of a "fallback image": When it can't build a proper native image for any
   reason, it will try to build a "fallback image", which is an executable binary that will still
   require a JVM at runtime. This is effectively the same as using launch4j, and is not what we
   want. To suppress this behavior, add the `--no-fallback` switch to `native-image`.
1. There is the behavior to allow building an image with an incomplete class path where type
   resolution errors only occur at run time rather than at build time. The documentation suggests
   that this is not the default behavior (any more?), but to be sure to have incomplete class paths
   reported at build time, add the `-H:+AllowIncompleteClasspath` switch.
1. It's very possible that your native image successfully compiles but for some reason still fails
   at run time even though the executable jar it was compiled from works as intended. It might be a
   good idea to automatically run the compiled binary with a set of test inputs automatically in
   your build pipeline to make sure that changing the `native-image` setup or the dependencies did
   not break your application.
1. I've encountered the behavior that building the native image yields a binary that fails at
   runtime (throws some exception), then building the native image again from the same jar with the
   same arguments to `native-image` yields a binary that works. By default, `native-image` starts a
   daemon that caches certain things and that is probably involved in this behavior, although I
   don't think that's supposed to happen.

### Wrapping it up

It's possible to build a CLI tool in Java that can start instantly and follows the best practices
for CLI tools. The easiest way to get started is using the Micronaut framework that will use the
Picocli library to do the argument parsing. Resulting binaries range between 20 and 80 MB (depending
on the amount and size of your dependencies) which is, depending on your point of view, either very
large or very small. Compared to "regular" binaries build with, say Rust, C++ or Go, that's pretty
big. But compared to distributing your application together with the required JRE/JDK, it's actually
not that large. While it's sometimes a litte tricky to get GraalVM Native Image to do what you want,
especially in combination with additional dependencies, this is in part remedied by the use of a
framework. All three of the mentioned frameworks (Micronaut, Quarkus and Spring Boot) improve very
fast to make the Native Image experience as smooth as possible. We'll see how this space evolves in
the future.

* * *

[^1]: Think of this footnote as a substitute for a multiple pages long rant about how every
    programming language comes with their own package/dependency-manager where the only essential
    distinctive feature is that it is written in that particular language.

[^2]: Because moving the cursor around, at least on Unix, is done using ANSI escape sequences, just
    like producing colored output.

[^3]: You might say: You could handle _just_ the `--help` arguments and the like in the wrapper
    script to have _that_ give instant feedback to avoid the JVM startup time, and you might
    technically be right. However, I won't go into detail on how that's a bad idea.

Please go [here](https://github.com/atextor/atextor.github.com/issues/7) to
comment this article.
