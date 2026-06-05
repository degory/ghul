# ghūl compiler

[![CI/CD](https://img.shields.io/github/actions/workflow/status/degory/ghul/ci.yml?branch=main)](https://github.com/degory/ghul/actions?query=workflow%3ACI)
[![NuGet version (ghul)](https://img.shields.io/nuget/v/ghul.compiler.svg)](https://www.nuget.org/packages/ghul.compiler/)
[![Release](https://img.shields.io/github/v/release/degory/ghul?label=release)](https://github.com/degory/ghul/releases)
[![Release Date](https://img.shields.io/github/release-date/degory/ghul)](https://github.com/degory/ghul/releases)
[![Issues](https://img.shields.io/github/issues/degory/ghul)](https://github.com/degory/ghul/issues) 
[![License](https://img.shields.io/github/license/degory/ghul)](https://github.com/degory/ghul/blob/main/LICENSE)
[![ghūl](https://img.shields.io/badge/gh%C5%ABl-100%25!-information)](https://ghul.dev)

This is the compiler for the [ghūl programming language](https://ghul.dev). It is a [self-hosting compiler](https://en.wikipedia.org/wiki/Self-hosting_(compilers)): the compiler itself is written entirely in ghūl.

![ghūl logo icon small](https://raw.githubusercontent.com/degory/ghul-dev/035cc6d3997514d03cbbd7b15133c37bf2a79f4e/src/.vuepress/public/ghul-logo-icon-128.png)

## Prerequisites

The compiler requires the [.NET 10 SDK](https://dotnet.microsoft.com/en-us/download/dotnet/10.0). The SDK includes the .NET 10 runtime that the compiler tool itself runs on, and will fetch reference packs for any target framework you build against on demand.

## Target

The compiler produces standard .NET assemblies and packages targeting .NET 10 by default. Earlier target frameworks work too — set `<TargetFramework>net8.0</TargetFramework>` (or similar) in your `.ghulproj` and pin `ghul.runtime` to a net8.0-compatible release (e.g. `3.0.19`), since the 4.x line is net10.0-only.

## Getting the compiler

There are a few different ways to get the compiler

### Use a ghūl .NET project template

If you initialize your project using one of the [ghūl .NET project templates](https://www.nuget.org/packages/ghul.templates/), the template will add the compiler to your project folder as a local .NET tool - just run `dotnet tool restore` to restore it. 

### Clone the ghūl GitHub repository template

If you create a new GitHub repo from the [ghūl repository template](https://github.com/degory/ghul-repository-template), then the compiler will be pre-configured as a local .NET tool in your project folder - run `dotnet tool restore` to restore it.

### Install the compiler as a local or global .NET tool

You can manually install the compiler from the [ghūl compiler .NET tool package](https://www.nuget.org/packages/ghul.compiler/)

## Using the compiler

### Project file

The compiler expects to be driven by MSBuild using a `.ghulproj` project file.
See the [ghūl test](https://github.com/degory/ghul-test) project for
a real-world example, or use one of the project templates to get started.

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

Applications written in ghūl require the .NET runtime matching whatever target framework you built for — the [.NET 10 runtime](https://dotnet.microsoft.com/download/dotnet/10.0) by default, or e.g. the [.NET 8 runtime](https://dotnet.microsoft.com/download/dotnet/8.0) if you targeted `net8.0`.

## Development environment

### Visual Studio Code

[Visual Studio Code](https://code.visualstudio.com) will give you rich language support via the [ghūl VSCode language extension](https://marketplace.visualstudio.com/items?itemName=degory.ghul).

### Dev container

Any dev container image with the .NET 10 SDK will do — for example [`mcr.microsoft.com/devcontainers/dotnet:10.0`](https://hub.docker.com/r/microsoft/devcontainers-dotnet). Pin `ghul.compiler` in your project's local .NET tool manifest and the compiler will be restored automatically when the container starts. A minimal worked example is in [this gist](https://gist.github.com/degory/1d6894fe1cf0bf73bb75cbf9c9176a0a).

## Basic ghūl language tutorial

For a short ghūl programming language tutorial and reference, see [GHUL.md](./GHUL.md) in this repository. For more ghūl language details, see the [the ghūl programming language website](https://ghul.dev)

## Gotchas

The ghūl language is sufficiently expressive and the compiler is stable enough for the compiler itself to be written in ghūl. Like any compiler it has [bugs](https://github.com/degory/ghul/issues?q=is%3Aissue+is%3Aopen+label%3Abug) — issue reports are welcome.
