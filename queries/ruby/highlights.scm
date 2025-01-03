(identifier) @variable

; Keywords

[
  "alias"
  "begin"
  "class"
  "do"
  "end"
  "module"
  "then"
  "BEGIN"
  "END"
 ] @keyword

[
  "return"
  "yield"
 ] @keyword.return

[
  "and"
  "in"
  "not"
  "or"
 ] @keyword.operator

[
  "def"
  "undef"
  "defined?"
 ] @keyword.function

(method
  "end" @keyword.function)

[
  "case"
  "else"
  "elsif"
  "if"
  "unless"
  "when"
 ] @keyword.conditional

(if
  "end" @keyword.conditional)

[
  "break"
  "for"
  "next"
  "redo"
  "retry"
  "until"
  "while"
 ] @keyword.repeat

[
  "rescue"
  "ensure"
 ] @keyword.exception

((identifier) @keyword.exception
  (#any-of? @keyword.exception "fail" "raise"))

; Function calls

(call method: [(identifier) (constant)] @function)

((call
  !receiver
  method: (identifier) @keyword.import)
  (#any-of? @keyword.import "require" "require_relative" "load" "autoload"))

((identifier) @view_helper.ruby
 (#any-of? @view_helper.ruby "turbo_frame_tag" "content_for" "link_to" "form_for" "form_with"))

((identifier) @keyword
 (#any-of? @keyword
    "private" "protected" "public" "abort"
    "using" "define_method" "module_function" "proc" "lambda" "caller" "callcc"
    "define_singleton_method" "remove_method" "undef_method" "class_eval"
    "instance_eval" "module_eval" "block_given\?" "iterator\?" "alias_method"
    "loop" "attr_reader" "attr_writer" "attr_accessor" "exit" "at_exit" "fork"))

((call
  !receiver
  method: (identifier) @keyword)
  (#any-of? @keyword "include" "extend" "prepend" "refine" "using"))

(call . method: (identifier) @model_macro.ruby
 (#any-of? @model_macro.ruby
    "belongs_to" "has_many" "has_one" "accepts_nested_attributes_for" "normalizes"
    "attr_readonly" "attribute" "enum" "serialize" "store" "store_accessor"
    "default_scope" "scope" "has_rich_text" "has_secure_password"
    "has_secure_token" "has_one_attached" "has_many_attached" "delegated_type"
    "with_options" "delegate" "delegate_missing_to" "composed_of"))

(call . method: (identifier) @model_callback.ruby
 (#any-of? @model_callback.ruby
     "before_validation" "after_validation" "before_create" "before_destroy"
     "before_save" "before_update" "after_create" "after_destroy" "after_save"
     "after_update" "around_create" "around_destroy" "around_save"
     "around_update" "after_commit" "after_create_commit" "after_update_commit"
     "after_save_commit" "after_destroy_commit" "after_rollback" "after_find"
     "after_initialize" "after_touch"))

(call . method: (identifier) @model_validations.ruby
 (#any-of? @model_validations.ruby
     "validates" "validates_acceptance_of" "validates_associated"
     "validates_confirmation_of" "validates_each" "validates_exclusion_of"
     "validates_format_of" "validates_inclusion_of" "validates_length_of"
     "validates_numericality_of" "validates_presence_of" "validates_absence_of"
     "validates_size_of" "validates_with" "validates_associated"
     "validates_uniqueness_of" "validate"))

; Function definitions

(alias (identifier) @function)
(setter (identifier) @function)

(method name: [(identifier) (constant)] @method)
(singleton_method name: [(identifier) (constant)] @method)

; (class name: (constant) @type)
; (module name: (constant) @type)
; (superclass (constant) @type)

; Identifiers
[
 (class_variable)
 (instance_variable)
 ] @label

((identifier) @variable.builtin
 (#any-of? @variable.builtin
    "__callee__" "__dir__" "__id__" "__method__" "__send__" "__ENCODING__" "__FILE__" "__LINE__"))

((constant) @type
 (#not-lua-match? @type "^[A-Z0-9_]+$"))

(constant) @constructor
[
 (self)
 (super)
 ] @variable.builtin

(global_variable) @variable.global

(block_parameters (identifier) @parameter)
(block_parameter  (identifier) @parameter)
(destructured_parameter (identifier) @parameter)
(hash_splat_parameter (identifier) @parameter)
(lambda_parameters (identifier) @parameter)
(method_parameters (identifier) @parameter)
(splat_parameter (identifier) @parameter)

(optional_parameter name: (identifier) @parameter)
(block_parameter (identifier) @parameter)
(keyword_parameter name: (identifier) @symbol)

; TODO: Re-enable this once it is supported
; ((identifier) @function (#is-not? local))

; Literals

[
 (string)
 (bare_string)
 (subshell)
 (heredoc_body)
 (heredoc_beginning)
 (heredoc_end)
 ] @string

[
 (bare_symbol)
 (simple_symbol)
 (delimited_symbol)
 (hash_key_symbol)
 ] @symbol

(pair key: (hash_key_symbol) ":" @symbol)
(regex) @string.regex
(escape_sequence) @string.escape
(integer) @number
(float) @float

[
 (true)
 (false)
 (nil)
 ] @boolean

(comment) @comment @spell

((program
  .
  (comment) @keyword.directive @nospell)
  (#lua-match? @keyword.directive "^#!/"))

(program
  (comment)+ @comment.documentation
  (class))

(module
  (comment)+ @comment.documentation
  (body_statement (class)))

(class
  (comment)+ @comment.documentation
  (body_statement (method)))

(body_statement
  (comment)+ @comment.documentation
  (method))

; Operators

[
 "="
 "=>"
 "->"
 "+"
 "-"
 "*"
 "/"
 "||"
 "&&"
 "||="
 "!="
 "=="
 ">"
 "<"
 "<="
 ">="
 "+="
 "-="
 "*="
 "/="
 "<<="
 "%="
 "&="
 "&&="
 "|="
 "**="
 "**"
 "^="
 "<=>"
 "==="
 "=~"
 "!~"
 "!"
 "^"
 "&"
 "%"
 "<<"
 ] @operator

[
 ","
 ";"
 "."
 "&."
 "::"
 ] @punctuation.delimiter

[
 "("
 ")"
 "["
 "]"
 "{"
 "}"
 ] @punctuation.bracket

(string_array) @string
(string_array ")" @string)
(symbol_array) @symbol
(symbol_array ")" @symbol)

(ERROR) @error

(interpolation
  "#{" @punctuation.special
  "}" @punctuation.special) @none
