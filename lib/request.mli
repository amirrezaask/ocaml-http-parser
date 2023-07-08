type t = {
    meth: string option;
    url: string option;
    headers: (string * string) list option;
    body: string option;
};; 

val from_string: string -> (t, string) result

val meth: t -> string option

val url: t -> string option

val headers: t -> (string * string) list option

val body: t -> string option

val pp: Format.formatter -> t -> unit
val show: t -> string

