# https://discourse.nixos.org/t/setting-up-wireguard-in-a-network-namespace-for-selectively-routing-traffic-through-vpn/10252/8
{ config, pkgs, ... }:

{
  systemd.services."netns@" = {
    description = "%I network namespace";
    before = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.iproute}/bin/ip netns add %I";
      ExecStop = "${pkgs.iproute}/bin/ip netns del %I";
    };
  };

  systemd.services.wg = {
    description = "wg network interface";
    bindsTo = [ "netns@wg.service" ];
    requires = [ "network-online.target" ];
    after = [ "netns@wg.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = with pkgs; writers.writeBash "wg-up" ''
        set -e
        ${iproute}/bin/ip link add wg0 type wireguard
        ${iproute}/bin/ip link set wg0 netns wg
        ${iproute}/bin/ip -n wg address add <ipv4 VPN addr/cidr> dev wg0
        ${iproute}/bin/ip -n wg -6 address add <ipv6 VPN addr/cidr> dev wg0
        ${iproute}/bin/ip netns exec wg \
          ${wireguard}/bin/wg setconf wg0 /root/myVPNprovider.conf
        ${iproute}/bin/ip -n wg link set wg0 up
        ${iproute}/bin/ip -n wg route add default dev wg0
        ${iproute}/bin/ip -n wg -6 route add default dev wg0
      '';
      ExecStop = with pkgs; writers.writeBash "wg-down" ''
        ${iproute}/bin/ip -n wg route del default dev wg0
        ${iproute}/bin/ip -n wg -6 route del default dev wg0
        ${iproute}/bin/ip -n wg link del wg0
      '';
    };
  };
}
