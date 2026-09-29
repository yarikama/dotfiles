# Read by every zsh, including the non-interactive ones that do not load
# .zshrc.

# Claude Code runs commands from a shell snapshot that restores functions but
# not hook arrays or this variable, so zoxide's cd() sees an empty
# chpwd_functions and warns on every call. The hook really is absent there
# (agent cd's stay out of the database, which is fine), so silence the check
# in that environment only. It lives here, not in .zshrc, because the
# snapshot does not keep variables exported by .zshrc.
[[ -n ${CLAUDECODE:-} ]] && export _ZO_DOCTOR=0
