#!/bin/bash

PERMISSION="pull" # Can be one of: pull, push, admin, maintain, triage
ORG="sequring"
TEAM_SLUG="developers"

# Get names with `gh repo list orgname`
REPOS=($(gh repo list $ORG --limit 200 --json name --json owner -q '.[] | "\(.owner.login)/\(.name)"'))

#REPOS=("sequring/gh-tools")

for REPO in "${REPOS[@]}"; do
  echo "Adding repo ${REPO} to Org:$ORG Team:$TEAM_SLUG"

  # https://docs.github.com/en/rest/teams/teams#add-or-update-team-repository-permissions
  # (needs admin:org scope)
  # --silent added to make it less noisy
  gh api \
    --method PUT \
    -H "Accept: application/vnd.github+json" \
    --silent \
    "/orgs/$ORG/teams/$TEAM_SLUG/repos/$REPO" \
    -f permission="$PERMISSION" && echo 'Added' || echo 'Failed'

  echo "============================================================"
done

