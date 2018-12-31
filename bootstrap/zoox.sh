export WORKTREE_WORKTREE_ROOT=~/driving
#export WORKTREE_PRIMARY_PROJECT=master
export WORKTREE_BRANCH_NAME_PREFIX=user/chris/
#export WORKTREE_BRANCH_NAME_SUFFIX=""
#export WORKTREE_BASE_BRANCH=master
#export WORKTREE_REMOTE=origin
WORKTREE_ENVIRONMENT_ENTRYPOINT='builtin cd "$project_directory"'
WORKTREE_ENVIRONMENT_ENTRYPOINT+=' && tmux has-session -t "$project_name" 2>/dev/null'
WORKTREE_ENVIRONMENT_ENTRYPOINT+=' && tmux attach -t "$project_name"'
WORKTREE_ENVIRONMENT_ENTRYPOINT+=' || tmux new -s "$project_name"'
export WORKTREE_ENVIRONMENT_ENTRYPOINT
alias wt=worktree
alias wt_create=worktree_create
alias wt_resume=worktree_resume

export VLR_ROOT="$HOME"
source "$(worktree_active_project_worktree)/scripts/shell/zooxrc.sh"

function bbt() {
  bb "$@" && btest "$@"
}

function skyquery() {
  bazel query --universe_scope=//... --order_output=no "$@"
}

alias aws-mfa='oathtool --totp --base32 -w 1 "`cat ~/.aws/oathtool-mfa`"'
alias vault-auth='VAULT_ADDR=https://vault.zooxlabs.com:8200 vault auth -method=ldap username=chris'
