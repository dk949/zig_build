
# Thanks SO https://stackoverflow.com/a/10858332
undef_err = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $2, ($2))))

undef_info = \
    $(if $(value $1),, \
      $(info Undefined $1$(if $2, ($2))$(if $3, defaulting to $3)))
