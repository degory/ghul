# ghūl compiler

[![CI/CD](https://img.shields.io/github/workflow/status/degory/ghul/CI)](https://github.com/degory/ghul/actions?query=workflow%3ACI)
[![NuGet version (ghul.targets)](https://img.shields.io/nuget/v/ghul.compiler.svg)](https://www.nuget.org/packages/ghul.compiler/)
[![Release](https://img.shields.io/github/v/release/degory/ghul?label=release)](https://github.com/degory/ghul/releases)
[![Release Date](https://img.shields.io/github/release-date/degory/ghul)](https://github.com/degory/ghul/releases)
[![Issues](https://img.shields.io/github/issues/degory/ghul)](https://github.com/degory/ghul/issues) 
[![License](https://img.shields.io/github/license/degory/ghul)](https://github.com/degory/ghul/blob/main/LICENSE)
[![ghūl](https://img.shields.io/badge/gh%C5%ABl-100%25!-information)](https://ghul.io)

This package contains the [ghūl programming language](https://ghul.io) [compiler](https://github.com/degory/ghul) packaged as a [.NET tool](https://docs.microsoft.com/en-us/dotnet/core/tools/global-tools)

## Prerequisites

The compiler requires the [.NET 6.0 SDK](https://dotnet.microsoft.com/en-us/download/dotnet/6.0)

## Target

The compiler produces standard .NET assemblies and packages targeting .NET 6.0

## Getting the compiler

There are a few different ways to get the compiler - you might not need to use this package directly.

### Use a ghūl .NET project template

If you initialize your project using one of the [ghūl .NET project templates](https://www.nuget.org/packages/ghul.templates/), the template will add the compiler to your project folder as a local .NET tool - just run `dotnet tool restore` to restore it. 

### Clone the ghūl GitHub repository template

If you create a new GitHub repo from the [ghūl repository template](https://github.com/degory/ghul-repository-template), then the compiler will be pre-configured as a local .NET tool in your project folder - run `dotnet tool restore` to restore it.

### Use the ghūl development container image

The compiler is pre-installed globally in the [ghūl development container](https://hub.docker.com/r/ghul/devcontainer)

### Install the compiler as a local or global .NET tool

If none of the above options suits, you can manually install the compiler from this package - see below for details.

## Using the compiler

### Project file

The compiler expects to be driven by MSBuild using a `.ghulproj` project file.
See the [ghūl targets](https://www.nuget.org/packages/ghul.targets/) package for
a minimal example, or use one of the project templates to get started.

### Source files

You'll need some ghūl source files. By convention ghūl source files have the extension `.ghul`, and the standard MSBuild targets will include `**/*.ghul` when building.

### Building and running

Once you have a project file and some ghūl source files, you can use the normal
.NET SDK commands to build, pack, and run your project:

```sh
dotnet build
```

```sh
dotnet pack
```

```sh
dotnet run
```

### Runtime dependencies for ghūl applications

Applications written in ghūl require the [.NET 6.0](https://dotnet.microsoft.com/download/dotnet/6.0) runtime

## Development environment

[Visual Studio Code](https://code.visualstudio.com) will give you rich language support via the [ghūl VSCode language extension](https://marketplace.visualstudio.com/items?itemName=degory.ghul).


## Manual compiler install

### Local tool install
To install the compiler locally in your project folder:

```sh
dotnet new tool-manifest # if you don't already have a tool manifest file
```
```sh
dotnet tool install ghul.compiler # install the latest release of the compiler locally
```
```sh
dotnet ghul-compiler # run the compiler
```

A local tool install means you get a predictable compiler version on every build, provided you check in the tool manifest. It also means you can easily use different versions of the compiler for different projects on the same machine. 

### Global tool install

To install the compiler globally for the current user:

```sh
dotnet tool install --global ghul.compiler # install the latest release of the compiler globally
```
```sh
ghul-compiler # run the compiler
```

## Gotchas

The ghūl language is sufficiently expressive and the compiler is stable enough for the [compiler itself to be written in ghūl](https://github.com/degory/ghul). However, this is an _incomplete compiler_ for an _experimental programming language_: there will be [compiler bugs](https://github.com/degory/ghul/issues?q=is%3Aissue+is%3Aopen+label%3Abug)!
