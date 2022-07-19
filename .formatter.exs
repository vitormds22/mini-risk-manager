[
  import_deps: [:ecto, :phoenix],
  line_length: 100,
  inputs: ["*.{ex,exs}", "priv/*/seeds.exs", "{config,lib,test}/**/*.{ex,exs}"],
  subdirectories: ["priv/*/migrations"],
  locals_without_parens: [assert_is_nil: 1, refute_is_nil: 1]
]
