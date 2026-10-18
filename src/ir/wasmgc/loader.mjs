// Runs a ghūl program compiled for the wasm target.
//
// The compiler writes this file beside the module it builds, naming the
// module below. Run directly by Node (`node program.mjs args...`) it runs
// the program with the process's arguments, environment and console, and
// leaves the program's exit status as the process's. A web page imports
// it and calls `run` with the same things as options.

const MODULE_FILE = "__GHUL_MODULE_FILE__";

// .NET's exit status when a program ends on an unhandled exception: the
// runtime aborts, which a shell sees as 128 + SIGABRT.
const UNHANDLED_EXCEPTION_EXIT_CODE = 134;

const is_node = typeof process !== "undefined" && process.versions?.node !== undefined;

const node_fs = is_node ? await import("node:fs") : null;
const node_path = is_node ? await import("node:path") : null;
const node_child_process = is_node ? await import("node:child_process") : null;
const node_os = is_node ? await import("node:os") : null;

class Exit extends Error {
    constructor(code) {
        super(`exit ${code}`);
        this.code = code;
    }
}

// Runs the program.
//
// - options.module: the module's bytes, a Response, or a URL to fetch;
//   by default the module beside this file
// - options.args: the program's command-line arguments
// - options.env: the program's environment, as an object of strings
// - options.stdin: the program's standard input, as a string, or as a
//   function answering the next piece of it each time it is called, and
//   null once there is no more; by default the program reads no input
// - options.stdout, options.stderr: called with each piece of text the
//   program writes to that stream
// - options.files: the files the program starts with, as an object from
//   path to content, each content text, which is read as UTF-8, or bytes;
//   by default it starts with none. A path is relative to the program's
//   root directory, which is also its current directory
// - options.onfile: called with the path and the whole content, as a
//   Uint8Array, each time the program writes a file; without it a program
//   run by Node has the file written relative to the working directory,
//   and one run anywhere else has its files discarded
// - options.file_system: whether the program reads and writes the real
//   file system rather than files in memory; by default it does when run
//   by Node with neither options.files nor options.onfile given, and never
//   anywhere else, which has no file system to reach
//
// Answers the program's exit status.
export async function run(options = {}) {
    const args = options.args ?? [];
    const env = options.env ?? {};
    const stdout = options.stdout ?? (() => {});
    const stderr = options.stderr ?? (() => {});

    const sinks = [null, stdout, stderr];
    const onfile = options.onfile ?? (is_node ? node_file_writer(stderr) : () => {});
    const input = input_reader(options.stdin);
    const input_files = Object.entries(options.files ?? {}).map(([path, content]) => [path, file_bytes(content)]);
    const files = (options.file_system ?? (options.files === undefined && options.onfile === undefined)) && is_node ? node_files() : no_files;
    const processes = is_node ? node_processes() : no_processes;

    const started = performance.now();

    let instance = null;
    const callbacks = (id) => instance.exports._run_callback(id);

    // A WasmGC reference has no address to hash, so each object is given a
    // number the first time its identity is hashed, held for as long as the
    // object lives.
    const identities = new WeakMap();
    let next_identity = 0;

    const host = {
        // A null string writes nothing, as it does on .NET.
        write(text, stream) {
            (sinks[stream] ?? stdout)(text === null ? "" : String(text));
        },
        flush(_stream) {},

        // Constructed here rather than thrown by the module, so the
        // exception records the stack it was thrown from.
        throw(exception) {
            const limit = Error.stackTraceLimit;
            Error.stackTraceLimit = FRAME_LIMIT;

            try {
                throw new WebAssembly.Exception(instance.exports._exception, [exception], { traceStack: true });
            } finally {
                Error.stackTraceLimit = limit;
            }
        },

        identity_hash(value) {
            let hash = identities.get(value);

            if (hash === undefined) {
                hash = Math.imul(++next_identity, 0x9E3779B1);
                identities.set(value, hash);
            }

            return hash;
        },

        file_written(path, content) {
            onfile(String(path), base64_bytes(String(content)));
        },

        ...files,
        ...processes,

        input_file_count: () => input_files.length,
        input_file_path: (index) => input_files[index][0],
        input_file_content: (index) => byte_text(input_files[index][1]),

        stdin_read_line: () => input.read_line(),
        stdin_read: () => input.read(),
        stdin_peek: () => input.peek(),
        stdin_read_to_end: () => input.read_to_end(),

        argument_count: () => args.length,
        argument: (index) => args[index],

        environment_lookup: (name) => env[name] ?? null,
        environment_count: () => Object.keys(env).length,
        environment_name: (index) => Object.keys(env)[index],

        exit(code) {
            throw new Exit(code);
        },

        wall_clock_milliseconds: () => Date.now(),
        monotonic_milliseconds: () => performance.now() - started,

        random_u32: () => crypto.getRandomValues(new Uint32Array(1))[0] | 0,

        // The floating-point functions the core library's Math does not
        // compute in ghūl, each taking and answering doubles.
        math_sqrt: Math.sqrt,
        math_cbrt: Math.cbrt,
        math_floor: Math.floor,
        math_ceiling: Math.ceil,
        math_truncate: Math.trunc,
        math_sin: Math.sin,
        math_cos: Math.cos,
        math_tan: Math.tan,
        math_asin: Math.asin,
        math_acos: Math.acos,
        math_atan: Math.atan,
        math_atan2: Math.atan2,
        math_sinh: Math.sinh,
        math_cosh: Math.cosh,
        math_tanh: Math.tanh,
        math_exp: Math.exp,
        math_log: Math.log,
        math_log10: Math.log10,
        math_log2: Math.log2,
        math_pow: Math.pow,

        // The arbitrary-precision integer bigint is a box around, with the
        // semantics of .NET's BigInteger: division truncates, a remainder
        // takes the dividend's sign, and shifts are arithmetic.
        bigint_is_integer_text: (text) => /^\s*[+-]?[0-9]+\s*$/.test(text),
        bigint_parse: (text) => BigInt(text.trim()),
        bigint_from_int: (value) => BigInt(value),
        bigint_from_long: (value) => value,
        bigint_from_ulong: (value) => BigInt.asUintN(64, value),
        bigint_from_double: (value) => BigInt(Math.trunc(value)),
        bigint_to_long: (value) => BigInt.asIntN(64, value),
        bigint_fits_long: (value) => BigInt.asIntN(64, value) === value,
        bigint_to_double,
        bigint_to_string: (value) => value.toString(),
        bigint_add: (a, b) => a + b,
        bigint_subtract: (a, b) => a - b,
        bigint_multiply: (a, b) => a * b,
        bigint_divide: (a, b) => a / b,
        bigint_remainder: (a, b) => a % b,
        bigint_negate: (a) => -a,
        bigint_compare: (a, b) => (a < b ? -1 : a > b ? 1 : 0),
        bigint_equals: (a, b) => a === b,
        bigint_hash: (a) => Number(BigInt.asIntN(32, a ^ (a >> 32n))),
        bigint_pow: (a, exponent) => a ** BigInt(exponent),
        bigint_mod_pow(value, exponent, modulus) {
            let result = 1n % modulus;
            let base = value % modulus;
            let rest = exponent;

            while (rest > 0n) {
                if (rest & 1n) {
                    result = (result * base) % modulus;
                }

                base = (base * base) % modulus;
                rest >>= 1n;
            }

            return result;
        },
        bigint_gcd(a, b) {
            let x = a < 0n ? -a : a;
            let y = b < 0n ? -b : b;

            while (y !== 0n) {
                [x, y] = [y, x % y];
            }

            return x;
        },
        bigint_shift_left: (a, places) => a << BigInt(places),
        bigint_shift_right: (a, places) => a >> BigInt(places),
        bigint_and: (a, b) => a & b,
        bigint_or: (a, b) => a | b,
        bigint_xor: (a, b) => a ^ b,
        bigint_not: (a) => ~a,
        // Two's complement in as few hex digits as hold the value and its
        // sign, as .NET writes a BigInteger under `X`.
        bigint_to_hex(value, upper) {
            let digits = (value < 0n ? ~value : value).toString(16).length;
            let text = value < 0n ? ((1n << (4n * BigInt(digits))) + value).toString(16).padStart(digits, "0") : value.toString(16);

            if (value === 0n) {
                text = "0";
            } else if (parseInt(text[0], 16) >= 8 && value > 0n) {
                text = "0" + text;
            } else if (parseInt(text[0], 16) < 8 && value < 0n) {
                text = "f" + text;
            }

            return upper ? text.toUpperCase() : text;
        },
        bigint_bit_length: (a) => (a < 0n ? ~a : a) === 0n ? 0 : (a < 0n ? ~a : a).toString(2).length,

        schedule_timer(delay_milliseconds, id) {
            setTimeout(() => callbacks(id), delay_milliseconds);
        },
        queue_microtask(id) {
            queueMicrotask(() => callbacks(id));
        },
    };

    const imports = { "ghul:host": host };
    const compile_options = { builtins: ["js-string"] };

    const source = await load(options.module ?? new URL(MODULE_FILE, import.meta.url));
    ({ instance } = await WebAssembly.instantiate(source, imports, compile_options));

    try {
        instance.exports._start();

        return instance.exports._exit_code();
    } catch (error) {
        if (error instanceof Exit) {
            return error.code;
        }

        stderr(`Unhandled exception. ${describe(error, instance)}\n${frames(error)}`);

        return UNHANDLED_EXCEPTION_EXIT_CODE;
    }
}

// Standard input, read as the program asks for it: a line, a character,
// or everything left. Text is pulled from `source` a piece at a time, so a
// program reading a line at a time from a terminal gets each line as it is
// typed rather than waiting for the end of the input. Lines end at \n,
// \r\n or \r, as .NET's ReadLine ends them, and a character is a UTF-16
// code unit, as .NET's Read answers one.
function input_reader(source) {
    let pull;

    if (typeof source === "function") {
        pull = source;
    } else {
        let rest = source ?? null;

        pull = () => {
            const piece = rest;
            rest = null;
            return piece;
        };
    }

    let text = "";
    let at = 0;
    let ended = false;

    // Adds the next piece of input to what is buffered, answering whether
    // there was one.
    const more = () => {
        while (!ended) {
            const piece = pull();

            if (piece === null || piece === undefined) {
                ended = true;
                break;
            }

            if (piece.length > 0) {
                text = text.slice(at) + piece;
                at = 0;
                return true;
            }
        }

        return false;
    };

    return {
        read_line() {
            let from = at;

            for (;;) {
                let end = -1;

                for (let i = from; i < text.length; i++) {
                    const c = text.charCodeAt(i);

                    if (c === 10 || c === 13) {
                        end = i;
                        break;
                    }
                }

                if (end >= 0) {
                    // A \r at the end of what is buffered may be the first
                    // half of a \r\n, so the next piece decides.
                    if (text.charCodeAt(end) === 13 && end + 1 === text.length && !ended) {
                        const offset = end - at;

                        more();
                        end = at + offset;
                    }

                    const line = text.slice(at, end);
                    const crlf = text.charCodeAt(end) === 13 && text.charCodeAt(end + 1) === 10;

                    at = end + (crlf ? 2 : 1);

                    return line;
                }

                const scanned = text.length - at;

                if (!more()) {
                    if (at < text.length) {
                        const line = text.slice(at);
                        at = text.length;
                        return line;
                    }

                    return null;
                }

                from = at + scanned;
            }
        },

        read() {
            if (at >= text.length && !more()) {
                return -1;
            }

            return text.charCodeAt(at++);
        },

        peek() {
            if (at >= text.length && !more()) {
                return -1;
            }

            return text.charCodeAt(at);
        },

        read_to_end() {
            while (more()) {}

            const rest = text.slice(at);
            at = text.length;

            return rest;
        },
    };
}

// The double a bigint converts to, as .NET converts one: the magnitude
// truncated to the 53 bits a double holds, rather than rounded to the
// nearest, and infinity only from 2^1024 up. Number() rounds to the nearest,
// so where it lands above the magnitude the double below is the truncation.
function bigint_to_double(value) {
    const magnitude = value < 0n ? -value : value;
    let result = Number(magnitude);

    if (result === Infinity ? magnitude < DOUBLE_LIMIT : BigInt(result) > magnitude) {
        double_bits[0] = result;
        double_words[0] -= 1n;
        result = double_bits[0];
    }

    return value < 0n ? -result : result;
}

const DOUBLE_LIMIT = 2n ** 1024n;
const double_bits = new Float64Array(1);
const double_words = new BigUint64Array(double_bits.buffer);

// The bytes a file's content stands for: text is UTF-8, and bytes are as
// they are.
function file_bytes(content) {
    if (typeof content === "string") {
        return new TextEncoder().encode(content);
    }

    if (content instanceof ArrayBuffer) {
        return new Uint8Array(content);
    }

    return new Uint8Array(content.buffer, content.byteOffset, content.byteLength);
}

// Text with one code unit for each of `bytes`, which is how the program is
// handed a file's content.
function byte_text(bytes) {
    let text = "";

    for (let at = 0; at < bytes.length; at += 8192) {
        text += String.fromCharCode.apply(null, bytes.subarray(at, at + 8192));
    }

    return text;
}

// The bytes standard, padded base64 text stands for.
function base64_bytes(text) {
    if (is_node) {
        return new Uint8Array(Buffer.from(text, "base64"));
    }

    if (typeof Uint8Array.fromBase64 === "function") {
        return Uint8Array.fromBase64(text);
    }

    const binary = atob(text);
    const bytes = new Uint8Array(binary.length);

    for (let i = 0; i < binary.length; i++) {
        bytes[i] = binary.charCodeAt(i);
    }

    return bytes;
}

// Writes each file the program writes under the working directory,
// creating the directories it names. A path that is absolute or climbs
// with `..` would reach outside it, so it is reported on standard error
// and not written, and the program carries on.
function node_file_writer(stderr) {
    return (path, bytes) => {
        const segments = path.split(/[\\/]/);

        if (node_path.isAbsolute(path) || /^[A-Za-z]:/.test(path) || segments.includes("..")) {
            stderr(`file ${path} not written: only a path within the working directory can be written\n`);

            return;
        }

        node_fs.mkdirSync(node_path.dirname(path), { recursive: true });
        node_fs.writeFileSync(path, bytes);
    };
}

// The host's file operations over Node's file system, each answering 0
// or one of core's failure codes as libghul's do: 1 for a missing file, 2
// for a missing directory, 3 for access denied and 4 for any other
// failure. A file's bytes cross as a string holding one code unit for
// each byte.
function node_files() {
    let last_error = 0;
    let entries = [];

    const code_for = (error, path) => {
        switch (error?.code) {
        case "ENOENT":
            return node_fs.existsSync(node_path.dirname(path)) ? 1 : 2;
        case "ENOTDIR":
            return 2;
        case "EACCES":
        case "EPERM":
        case "EISDIR":
        case "EROFS":
            return 3;
        default:
            return 4;
        }
    };

    const attempt = (path, action) => {
        try {
            action();
            return 0;
        } catch (error) {
            return code_for(error, path);
        }
    };

    const is_directory = (path) => node_fs.statSync(path, { throwIfNoEntry: false })?.isDirectory() ?? false;

    return {
        file_system: () => 1,
        file_current_directory: () => process.cwd(),

        file_kind(path) {
            const status = node_fs.statSync(String(path), { throwIfNoEntry: false });

            return status === undefined ? 0 : status.isDirectory() ? 2 : 1;
        },

        file_read_text(path) {
            try {
                return node_fs.readFileSync(String(path)).toString("latin1");
            } catch (error) {
                last_error = code_for(error, String(path));
                return null;
            }
        },

        file_last_error: () => last_error,

        file_write_text(path, content, append) {
            const bytes = Buffer.from(String(content), "latin1");

            return attempt(String(path), () =>
                append ? node_fs.appendFileSync(String(path), bytes) : node_fs.writeFileSync(String(path), bytes));
        },

        // A file that is not there is no failure, as .NET's File.Delete
        // does nothing for one, unless its directory is not there either.
        file_delete(path) {
            const code = attempt(String(path), () => node_fs.unlinkSync(String(path)));

            return code === 1 ? 0 : code;
        },

        file_rename: (from, to) => attempt(String(from), () => node_fs.renameSync(String(from), String(to))),

        // When `path` was last written, in milliseconds since the Unix
        // epoch, or -1 where there is nothing there.
        file_modified_milliseconds: (path) => node_fs.statSync(String(path), { throwIfNoEntry: false })?.mtimeMs ?? -1,

        // The permission bits of `path`, or -1 where there is nothing there.
        file_mode: (path) => {
            const status = node_fs.statSync(String(path), { throwIfNoEntry: false });

            return status === undefined ? -1 : status.mode & 0o7777;
        },

        file_set_mode: (path, mode) => attempt(String(path), () => node_fs.chmodSync(String(path), mode & 0o7777)),
        directory_set_current: (path) => attempt(String(path), () => process.chdir(String(path))),
        directory_create: (path) => attempt(String(path), () => node_fs.mkdirSync(String(path), { recursive: true })),

        directory_delete: (path, recursive) =>
            attempt(String(path), () => recursive ? node_fs.rmSync(String(path), { recursive: true }) : node_fs.rmdirSync(String(path))),

        // The files, or the directories, directly in `path`, held for
        // directory_entry to answer one at a time; a link counts as what
        // it leads to.
        directory_entries(path, directories) {
            try {
                entries = node_fs.readdirSync(String(path), { withFileTypes: true })
                    .filter((entry) => (entry.isDirectory() || (entry.isSymbolicLink() && is_directory(node_path.join(String(path), entry.name)))) === Boolean(directories))
                    .map((entry) => entry.name);

                return entries.length;
            } catch (error) {
                return -code_for(error, String(path));
            }
        },

        directory_entry: (index) => entries[index],
    };
}

// The host's process operations, as libghul's are: a program is named, its
// arguments added one at a time, and then run to completion sharing this
// process's standard input, its output and error captured. A run answers
// the exit status, a program killed by a signal 128 plus its number, or -1
// where it could not be started, process_failure then saying why: 1 for
// no such program, 2 for anything else.
function node_processes() {
    let file = "";
    let args = [];
    let result = null;
    let failure = 0;

    return {
        process_begin(file_name) {
            file = String(file_name);
            args = [];
            result = null;
            failure = 0;
        },

        process_add_argument(argument) {
            args.push(String(argument));
        },

        process_run() {
            result = node_child_process.spawnSync(file, args, { stdio: ["inherit", "pipe", "pipe"], maxBuffer: 1 << 30 });

            if (result.error !== undefined) {
                failure = result.error.code === "ENOENT" ? 1 : 2;
                return -1;
            }

            if (result.status === null) {
                return 128 + (node_os.constants.signals[result.signal] ?? 0);
            }

            return result.status;
        },

        process_failure: () => failure,
        process_output: () => result?.stdout?.toString("utf8") ?? null,
        process_error: () => result?.stderr?.toString("utf8") ?? null,

        // The machine in Node's own words: `linux`, `darwin` or `win32`,
        // and `x64` or `arm64`.
        os_platform: () => process.platform,
        os_architecture: () => process.arch,
        process_id: () => process.pid,
        home_directory: () => node_os.homedir(),

        // Blocks the program for `milliseconds`, as Thread.Sleep does.
        sleep: (milliseconds) => Atomics.wait(new Int32Array(new SharedArrayBuffer(4)), 0, 0, Math.max(0, milliseconds)),
    };
}

// What a program that cannot start another one is told: that it could not.
// The machine's name for itself is the engine's, since a page has no other.
const no_processes = {
    process_begin: () => {},
    process_add_argument: () => {},
    process_run: () => -1,
    process_failure: () => 2,
    process_output: () => null,
    process_error: () => null,
    os_platform: () => "browser",
    os_architecture: () => "wasm",
    process_id: () => 0,
    home_directory: () => "/",
    sleep: () => {},
};

// What a program that reads no real file system is told: that there is
// none to read. Core asks before using any other operation, but the module
// imports each one it can reach, so each is here, failing.
const no_files = {
    file_system: () => 0,
    file_current_directory: () => "/",
    file_kind: () => 0,
    file_read_text: () => null,
    file_last_error: () => 4,
    file_write_text: () => 4,
    file_delete: () => 4,
    file_rename: () => 4,
    file_modified_milliseconds: () => -1,
    file_mode: () => -1,
    file_set_mode: () => 4,
    directory_set_current: () => 4,
    directory_create: () => 4,
    directory_delete: () => 4,
    directory_entries: () => -4,
    directory_entry: () => "",
};

// Node's standard input as pieces of text, read synchronously so the
// program can block on it. Input arriving on a non-blocking descriptor is
// waited for rather than taken as the end.
function node_stdin(readSync) {
    const buffer = Buffer.alloc(65536);
    const decoder = new TextDecoder();
    const pause = new Int32Array(new SharedArrayBuffer(4));
    let done = false;

    return () => {
        while (!done) {
            let count;

            try {
                count = readSync(0, buffer, 0, buffer.length, null);
            } catch (error) {
                if (error.code === "EAGAIN") {
                    Atomics.wait(pause, 0, 0, 5);
                    continue;
                }

                if (error.code === "EOF") {
                    count = 0;
                } else {
                    throw error;
                }
            }

            if (count === 0) {
                done = true;
                const rest = decoder.decode();
                return rest.length > 0 ? rest : null;
            }

            const piece = decoder.decode(buffer.subarray(0, count), { stream: true });

            if (piece.length > 0) {
                return piece;
            }
        }

        return null;
    };
}

async function load(module) {
    if (module instanceof ArrayBuffer || ArrayBuffer.isView(module)) {
        return module;
    }

    if (is_node && module instanceof URL && module.protocol === "file:") {
        const { readFile } = await import("node:fs/promises");

        return readFile(module);
    }

    const response = module instanceof Response ? module : await fetch(module);

    return response.arrayBuffer();
}

// How many frames an exception the program throws records.
const FRAME_LIMIT = 100;

// The module's frames the error was thrown through, innermost first, one
// "   at <name>" line each, as the native target writes them. The engine's
// own and the loader's frames, and _start, which calls the entry, are
// left out.
function frames(error) {
    const stack = typeof error?.stack === "string" ? error.stack : "";
    let text = "";

    for (const line of stack.split("\n")) {
        const frame = /^\s*at (.*?) \(wasm:\/\/.*\)$/.exec(line) ?? /^\s*at (wasm:\/\/.*)$/.exec(line);

        if (frame && frame[1] !== "_start") {
            text += `   at ${frame[1]}\n`;
        }
    }

    return text;
}

// The first line .NET prints for an unhandled exception, after its
// "Unhandled exception. " prefix: the exception's type and message. An
// exception the program threw carries the module's exception tag, and
// its one argument is the exception itself, which `_describe_exception`
// describes where the module exports it.
function describe(error, instance) {
    const tag = instance?.exports._exception;

    if (tag && error instanceof WebAssembly.Exception && error.is(tag)) {
        const describe_exception = instance.exports._describe_exception;

        return describe_exception ? describe_exception(error.getArg(tag, 0)) : "an exception the program threw";
    }

    return `${error?.name ?? "Error"}: ${error?.message ?? String(error)}`;
}

if (is_node && process.argv[1] && import.meta.url === (await import("node:url")).pathToFileURL(process.argv[1]).href) {
    const { readSync } = await import("node:fs");

    process.exitCode = await run({
        args: process.argv.slice(2),
        env: { ...process.env },
        stdin: node_stdin(readSync),
        stdout: (text) => process.stdout.write(text),
        stderr: (text) => process.stderr.write(text),
    });
}
