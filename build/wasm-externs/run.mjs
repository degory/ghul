// Runs a wasm program that declares functions extern, supplying them.
// usage: node run.mjs <loader.mjs>
const { run } = await import(process.argv[2]);

const code = await run({
    stdout: (text) => process.stdout.write(text),
    stderr: (text) => process.stdout.write(text),
    externs: {
        host_add: (a, b) => a + b,
        host_scale: (value, by) => value * by,
        host_shout: (text) => text.toUpperCase() + "!",
        host_big: (value) => value + 1n,
        host_log: (text) => process.stdout.write(`host_log: ${text}\n`),
    },
});

process.exit(code);
