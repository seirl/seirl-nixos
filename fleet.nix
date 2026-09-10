{
  network = {
    domain = "seirl.local";
    wireguard = {
      server = "hyjal";
      port = 51820;
      subnet4 = "10.100.0";
      subnet6 = "fdd2:cdae:f4b4:ad0d";
      mask4 = 24;
      mask6 = 64;
    };
  };

  hosts = {
    hyjal = {
      publicHost = "hyjal.koin.fr";
      ageKey = "age1rw8ytzzha6q7fjac9szv572u8fc2589e25w5x8cata4dksan5p7q2g4q4m";
      wireguard = {
        id = 1;
        externalIp = "95.216.87.10";
        publicKey = "BmectuKYQgE0CHyfU8OlKyxfwXSds6JustGUEJCnYUs=";
      };
    };

    dalaran = {
      ageKey = "age1x3gfv5dan28lkdp2x4cmddt0y7ecftn4s5ns44t6cjftl944tgrqsnjnez";
      wireguard = {
        id = 2;
        publicKey = "DTAFYlb1QnIbEl22j3PiA2JBnwLunqiyR9jJ4R3Bmzw=";
      };
    };

    redridge = {
      ageKey = "age1lwz2vr0gcjkpa4au60fjllu8zusc60aqsvp3rqy0req2597gtsdsurp0s9";
      wireguard = {
        id = 3;
        publicKey = "WjYll9aqjlQGc9x1Pqs0ieLjBA6fc4+jWDQIzo3qdzE=";
      };
    };

    buzzard = {
      # legacy armv6l node
    };

    corplaptop = {
      wireguard = {
        id = 4;
        publicKey = "ZdOiH8yr7BgxNumDplU6/Yn+uqQzSnSolAfqn/NG1mo=";
      };
    };
  };
}
