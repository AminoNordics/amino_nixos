{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15; # or whatever version

    ensureDatabases = [ "app1db" "app2db" ];

    ensureUsers = [
      {
        name = "app1user";
        ensureDBOwnership = true;
        # Avoid hardcoding secrets in config — use agenix or a script
        password = "super-secret-password"; 
      }
      {
        name = "app2user";
        ensureDBOwnership = true;
        password = "other-secret";
      }
    ];
  };
}