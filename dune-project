(lang dune 3.16)

(name tunein_tui)

(generate_opam_files true)

(source
 (github RyanBlaney/tunein_tui))

(authors "Ryan Blaney")

(maintainers "Ryan Blaney")

(license MIT License)

(documentation https://url/to/documentation)

(package
 (name tunein_tui)
 (synopsis "Unofficial crossplatform desktop app for Tunein with a terminal UI.")
 (description "Unofficial crossplatform desktop app for Tunein with a terminal UI.")
 (depends 
   ocaml 
   dune
   cohttp-lwt-unix
   xmlm
   lwt
   str
   lambda-term)
 (tags
  (topics "to describe" your project)))
