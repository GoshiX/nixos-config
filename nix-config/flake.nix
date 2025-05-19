{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      # System types to support
      supportedSystems = [ "x86_64-linux" ];
      
      # Helper function to generate a set of attributes for each supported system
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      
      # Import nixpkgs for each system
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
      
      # Configurations for each host
      mkHost = { hostName, system ? "x86_64-linux" }: 
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            # Point to the new configuration.nix file inside the host directory
            (./hosts + "/${hostName}/configuration.nix")
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                useGlobalPkgs = true;
                users.egrapa = import ./home/home.nix;
                extraSpecialArgs = { inherit inputs hostName; };
              };
            }
          ];
          specialArgs = { inherit inputs hostName; };
        };
    in {
      # NixOS configuration entry points
      nixosConfigurations = {
        # Laptop configuration
        laptop = mkHost {
          hostName = "laptop";
        };
        
        # VirtualBox configuration
        virtualbox = mkHost {
          hostName = "virtualbox";
        };
      };
      
      # Optional: Development shells for maintaining this configuration
      devShells = forAllSystems (system:
        let pkgs = nixpkgsFor.${system}; in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              nixpkgs-fmt  # Formatter for Nix files
              nil          # Nix language server
            ];
          };
        }
      );
    };
}