# Security policy

## Supported versions

Only the most recent release of `ghul.compiler` is supported. Fixes go into the
next release rather than being backported, and releases are frequent, so the
answer to "which version should I be on" is always the latest one.

| Version | Supported |
|---|---|
| Latest release | Yes |
| Anything older | No |

## Reporting a vulnerability

Email **jeek@giantblob.com** with the details. Please don't open a public issue
for something you believe is a genuine vulnerability.

Include enough for the problem to be reproduced - the version you were using,
what you did, and what happened. A short program that demonstrates it is ideal.

This is a hobby project with no security team and no guaranteed response time.
You will get an acknowledgement as soon as it is seen, and an honest answer
about whether and when it will be fixed. If it turns out to be a plain bug
rather than a vulnerability, it will be moved to a public issue so it can be
tracked in the open, and you will be told before that happens.

## What counts

The compiler is a build-time tool. The things worth reporting privately are
those where using it as documented can harm the person using it:

- Compiling a project causes the compiler to execute code, read files, or make
  network requests that the project did not ask for.
- The compiler emits an assembly that does something the source did not say,
  in a way an attacker could arrange deliberately.
- A published `ghul.compiler` package contains something that is not built from
  the corresponding source in this repository.

Some things are worth knowing about but are not vulnerabilities:

- **Compiling untrusted source is not a sandboxed operation.** The compiler
  parses and analyses whatever you point it at, and MSBuild will run whatever
  the project file says. Treat compiling someone else's project the way you
  would treat running their build script, because that is what it is.
- **A crash, a hang, or an internal error on malformed input** is an ordinary
  bug. Please report it as a normal [issue](https://github.com/degory/ghul/issues) - 
  they are welcome, and public tracking gets them fixed sooner.
- **Wrong code generation** is likewise an ordinary bug unless you can show it
  being triggered deliberately.

If you are unsure which side of the line something falls on, email it. An
over-cautious private report is not a nuisance.
