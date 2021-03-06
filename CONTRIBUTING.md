# Contributing to Phusion Passenger

Thank you for your interest in Phusion Passenger. Phusion Passenger is open source so your contributions are very welcome. Although we also provide a [commercial version](https://www.phusionpassenger.com/enterprise) and [commercial support](https://www.phusionpassenger.com/commercial_support), the core remains open source and we remain committed to keep it that way. This guide gives you an overview of the ways with which you can contribute, as well as contribution guidelines.

You can contribute in one of the following areas:

 * Documentation (user documentation, developer documentation, contributor documentation).
 * Bug triage.
 * Community support.
 * Code.

We require contributors to sign our [contributor agreement](http://www.phusion.nl/forms/contributor_agreement) before we can merge their patches.

Please submit patches in the form of a Github pull request or as a patch on the [bug tracker](http://code.google.com/p/phusion-passenger/issues/list). Pull requests are preferred and generally get more attention because Github has better email notifications and better discussion capabilities.

## Contributing documentation

All good software should have good documentation, and we take this very seriously. However writing and maintaing quality documentation is not an easy task. If you are not skilled in C++ or programming, then writing documentation is the easiest way to contribute.

Most documentation can be located in the `doc` directory, and are either written in Markdown or in Asciidoc format. They can be compiled to HTML with `rake doc`. You need [Mizuho](https://github.com/FooBarWidget/mizuho) to compile Asciidoc and [BlueCloth](http://deveiate.org/projects/BlueCloth) to compile Markdown.

## Contributing by bug triaging

Users [fill bug reports](http://code.google.com/p/phusion-passenger/issues/list) on a regular basis, but not all bug reports are legit, not all bug reports are equally important, etc. By helping with bug triaging you make the lives of the core developers a lot easier.

To start contributing, please submit a comment on any bug report that needs triaging. This comment should contain triaging instructions, e.g. whether a report should be considered duplicate. If you contribute regularly we'll give you moderator access to the bug tracker so that you can apply triaging labels directly.

Here are some of the things that you should look for:

 * Some reports are duplicates of each other, i.e. they report the same issue. You should mark them as duplicate and note the ID of the original report.
 * Some reported problems are caused by the reporter's machine or the reporter's application. You should explain to them what the problem actually is, that it's not caused by Phusion Passenger, and then close the report.
 * Some reports need more information. At the very least, we need specific instructions on how to reproduce the problem. You should ask the reporter to provide more information. Some reporters reply slowly or not at all. If some time has passed, you should remind the reporter about the request for more information. But if too much time has passed and the issue cannot be reproduced, you should close the report and mark it as "Stale".
 * Some bug reports seem to be limited to one reporter, and it does not seem that other people suffer from the same problem. These are reports that need _confirmation_. You can help by trying to reproduce the problem and confirming the existance of the problem.
 * Some reports are important, but have been neglected for too long. Although the core developers try to minimize the number of times this happens, sometimes it happens anyway because they're so busy. You should actively ping the core developers and remind them about it. Or better: try to actively find contributors who can help solving the issue.

**Always be polite to bug reporters.** Not all reporters are fluent in English, and not everybody may be tech-savvy. But we ask you for your patience and tolerance on this. We want to stimulate a positive and ejoyable environment.

## Contributing community support

You can contribute by answering support questions on the [community discussion forum](http://groups.google.com/group/phusion-passenger) or on [Stack Overflow](http://stackoverflow.com/search?q=passenger).

## Contributing code

Phusion Passenger is mostly written in C++, but the build system and various small helper scripts are in Ruby. The loaders for each supported language is written in the respective language.

The source code is filled with inline comments, so look there if you want to understand how things work. We also have dedicated documents on some topics and for some subsystems. For example, you should read ext/common/ApplicationPool2/README.md if you're interesting in working on the ApplicationPool and Spawner subsystems.

### Compilation and build system

`passenger-install-apache2-module` and `passenger-install-nginx-module` are actually user-friendly wrappers around the build system. The build system is written in Rake, and most of it can be found in the `build/` directory.

Run the following command to compile everything:

    rake apache2
    rake nginx

### Running the unit tests

The tests need the following software installed:

 * All the usual Phusion Passenger dependencies.
 * Ruby on Rails 2.2.x
 * Ruby on Rails 2.3.x
 * Ruby on Rails 3.0.x
 * rspec >= 1.1.2
 * mime-types >= 1.15
 * sqlite3-ruby
 * json
 * daemon_controller >= 1.1.0

You also need to setup the file `test/config.json`. You can find an example in `test/config.json.example`.

Run all tests:

    rake test

Run only the unit tests for the C++ components:

    rake test:cxx
    rake test:oxt

The `test:cxx` unit test suite contains many different test groups. You can run a specific one by setting the environment variable `GROUPS` to a comma-delimited list of group names, e.g.:

    rake test:cxx GROUPS='ApplicationPool2_PoolTest,UtilsTest'

Run just the unit tests for the Ruby components:

    rake test:ruby

Run just the integration tests:

    rake test:integration            # All integration tests.
    rake test:integration:apache2    # Just integration tests for Apache 2.
    rake test:integration:nginx      # Just integration tests for Nginx.

Notes:

 * Some tests, such as the ones that test privilege lowering, require root privileges. Those will only be run if Rake is run as root.
 * Some tests will be run against multiple Rails versions in order to test compatibility. This can take a long time. If you want to test against only a single Rails version, then set the environment variable `ONLY_RAILS_VERSION` to one of the subdirectory names in `test/stub/rails_apps`, e.g. `export ONLY_RAILS_VERSION=2.3`.

### Directory structure

The most important directories are:

 * `lib/phusion_passenger` <br>
   The source code for Ruby parts of Phusion Passenger.
 * `ext/phusion_passenger` <br>
   Native extensions for Ruby, used by the spawn server.
 * `ext/apache2` <br>
   Apache 2-specific source code.
 * `ext/nginx` <br>
   Nginx-specific source code.
 * `ext/common` <br>
   Source code shared by the Apache and Nginx modules.
 * `bin` <br>
   User executables.
 * `helper-scripts` <br>
   Scripts used during runtime, but not directly executed by the user.
 * `doc` <br>
   Various documentation.
 * `test` <br>
   Unit tests and integration tests.
 * `test/support` <br>
   Support/utility code, used in the tests.
 * `test/stub` <br>
   Stubbing and mocking code, used in the tests.

Less important directories:

 * `ext/boost` <br>
   A stripped-down and customized version of the [Boost C++ library](http://www.boost.org).
 * `ext/oxt` <br>
   The "OS eXtensions for boosT" library, which provides various important functionality necessary for writing robust server software. It provides things like support for interruptable system calls and portable backtraces for C++. Boost was modified to make use of the functionality provided by OXT.
 * `dev` <br>
   Tools for Phusion Passenger developers. Not used during production.
 * `resources` <br>
   Various non-executable resource files, used during production.
 * `debian` <br>
   Debian packaging files.
 * `rpm` <br>
   RPM packaging files.
 * `man` <br>
   Man pages.
 * `build` <br>
   Source code of the build system.

### C++ coding style

 * Use 4-space tabs for indentation.
 * Wrap at approximately 80 characters. This is a recommendation, not a hard guideline. You can exceed it if you think it makes things more readable, but try to minimize it.

 * Use camelCasing for function names, variables, class/struct members and parameters:

        void frobnicate();
        void deleteFile(const char *filename, bool syncHardDisk);
        int fooBar;

   Use PascalCasing for classes, structs and namespaces:

        class ApplicationPool {
        struct HashFunction {
        namespace Passenger {

 * `if` and `while` statements must always have their body enclosed by brackets:

        if (foo) {
            ...
        }

   Not:

        if (foo)
            ...

 * When it comes to `if`, `while`, `class` and other keywords, put a space before and after the opening and closing parentheses:

        if (foo) {
        while (foo) {
        case (foo) {

   Not:

        if(foo){
        while (foo) {

 * You should generally put brackets on the same line as the statement:

        if (foo) {
            ...
        }
        while (bar) {
            ...
        }

   However, if the main statement is so long that it does not fit on a single line, then the bracket should start at the next line:

        if (very very long expression
         && another very very long expression)
        {
            ...
        }

 * Do not put a space before the opening parenthesis when calling functions.

        foo(1, 2, 3);

   Not:

        foo (1, 2, 3);

 * Seperate arguments and parts of expressions by spaces:

        foo(1, 2, foo == bar, 5 + 6);
        if (foo && bar) {

   Not:

        foo(1,2, foo==bar,5+6);
        if (foo&&bar) {

 * When declaring functions, puts as much on the same line as possible:

        void foo(int x, int y);

   When the declaration becomes too long, wrap at the beginning of an argument
   and indent with a tab:

        void aLongMethod(double longArgument, double longArgument2,
            double longArgument3);

   If the declaration already starts at a large indentation level (e.g. in a class) and the function has many arguments, or if the names are all very long, then it may be a good idea to wrap at each argument to make the declaration more readable:

        class Foo {
            void aLongLongLongLongMethod(shared_ptr<Foo> sharedFooInstance,
                shared_ptr<BarFactory> myBarFactory,
                GenerationDir::Entry directoryEntry);

 * When defining functions outside class declarations, put the return type and any function attributes on a different line than the function name. Put the opening bracket on the same line as the function name.

        static __attribute__((visibility("hidden"))) void
        foo() {
            ...
        }

        void
        Group::onSessionClose() {
            ...
        }

   But don't do that if the function is part of a class declarations:

        class Foo {
            void foo() {
                ...
            }
        };

   Other than the aforementioned rules, function definitions follow the same rules as function declarations.

### Ruby coding style

The usual Ruby coding style applies, with some exceptions:

 * Use 4-space tabs for indentation.
 * Return values explicitly with `return`.

### Prefer shared_ptrs

You should prefer `shared_ptr`s over raw pointers because they make memory leaks and memory errors less likely. There are only very limited cases in which raw pointers are justified, e.g. optimizations in very hot code paths.

### Event loop callbacks

Be careful with event loop callbacks, they are more tricky than one would expect.

 * If your event loop callback ever calls user-defined functions, either explicitly or implicitly, you should obtain a `shared_ptr` to your `this` object. This is because the user-defined function could call something that would free your object. Your class should derive from `boost::enable_shared_from_this` to make it easy for you to obtain a `shared_ptr` to yourself.

        void callback(ev::io &io, int revents) {
            shared_ptr<Foo> self = shared_from_this();
            ...
        }

 * Event loop callbacks should catch expected exceptions. Letting an exception pass will crash the program. When system call failure simulation is turned on, the code can throw arbitrary SystemExceptions, so beware of those.
