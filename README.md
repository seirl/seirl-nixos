# seirl's NixOS configuration

## Usage

Apply locally:

    colmena apply-local --sudo

Apply on remote machines:

    colmena apply --on hyjal


## Secrets

Setup:

    nix develop
    setup-age-private-key

Edit secret:

    sops secrets/default.yaml

Get key of new machine:

    cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age
