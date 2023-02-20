import { invoke } from "@tauri-apps/api/tauri";

function invokeRust<T>(cmd: string, args: string): Promise<T> {
    return invoke(cmd, JSON.parse(args));
}

function evalJs(js: string): any {
    return eval(js);
}

declare global {
    interface Window {
        invokeRust: typeof invokeRust;
        evalJs: typeof evalJs;
    }
}

window.invokeRust = invokeRust;
window.evalJs = evalJs;
