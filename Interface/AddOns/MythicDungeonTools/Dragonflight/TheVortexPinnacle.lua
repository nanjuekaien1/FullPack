local MDT = MDT
local L = MDT.L

local dungeonIndex = 77
MDT.dungeonList[dungeonIndex] = L["The Vortex Pinnacle"]
MDT.mapInfo[dungeonIndex] = {
  --  viewportPositionOverrides =
  --  {
  --    [1] = {
  --      zoomScale = 1.2999999523163;
  --      horizontalPan = 102.41712541524;
  --      verticalPan = 87.49594729527;
  --    };
  --  }
};

MDT.dungeonMaps[dungeonIndex] = {
  [0] = "skywall",
  [1] = "skywall1_",
}

MDT.dungeonSubLevels[dungeonIndex] = {
  [1] = L["Cyclone Summit"],
}

MDT.dungeonTotalCount[dungeonIndex] = { normal = 420, teeming = 1000, teemingEnabled = true }

MDT.mapPOIs[dungeonIndex] = {
};

MDT.dungeonEnemies[dungeonIndex] = {
  [1] = {
    ["name"] = "Temple Adept";
    ["id"] = 45935;
    ["count"] = 5;
    ["health"] = 790706;
    ["scale"] = 1;
    ["displayId"] = 34736;
    ["creatureType"] = "Humanoid";
    ["level"] = 70;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Fear"] = true;
      ["Disorient"] = true;
      ["Stun"] = true;
    };
    ["spells"] = {
      [87779] = {
      };
      [87780] = {
      };
      [88959] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 259.37214408095;
        ["y"] = -410.76519746633;
        ["g"] = 16;
        ["sublevel"] = 1;
      };
      [2] = {
        ["x"] = 256.78000843115;
        ["y"] = -367.57114284032;
        ["g"] = 17;
        ["sublevel"] = 1;
        ["patrol"] = {
          [1] = {
            ["x"] = 249.8;
            ["y"] = -361.6;
          };
          [2] = {
            ["x"] = 263.8;
            ["y"] = -373.6;
          };
          [3] = {
            ["x"] = 264.8;
            ["y"] = -372.7;
          };
          [4] = {
            ["x"] = 251.4;
            ["y"] = -360.8;
          };
          [5] = {
            ["x"] = 249.8;
            ["y"] = -361.6;
          };
        };
      };
      [3] = {
        ["x"] = 251.90704439848;
        ["y"] = -315.13515297424;
        ["g"] = 19;
        ["sublevel"] = 1;
      };
      [4] = {
        ["x"] = 245.31194897361;
        ["y"] = -308.1068835315;
        ["g"] = 19;
        ["sublevel"] = 1;
      };
    };
  };
  [2] = {
    ["name"] = "Skyfall Star";
    ["id"] = 45932;
    ["count"] = 1;
    ["health"] = 98839;
    ["scale"] = 0.8;
    ["displayId"] = 37225;
    ["creatureType"] = "Elemental";
    ["level"] = 70;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Fear"] = true;
      ["Stun"] = true;
    };
    ["spells"] = {
      [411019] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 214.1831454089;
        ["y"] = -341.56187571071;
        ["g"] = 18;
        ["sublevel"] = 1;
      };
      [2] = {
        ["x"] = 222.99969265884;
        ["y"] = -341.17188339628;
        ["g"] = 18;
        ["sublevel"] = 1;
      };
      [3] = {
        ["x"] = 230.85342969337;
        ["y"] = -341.38999855503;
        ["g"] = 18;
        ["sublevel"] = 1;
      };
      [4] = {
        ["x"] = 218.80124184586;
        ["y"] = -335.72687475786;
        ["g"] = 18;
        ["sublevel"] = 1;
      };
      [5] = {
        ["x"] = 219.6;
        ["y"] = -330.1;
        ["g"] = 18;
        ["sublevel"] = 1;
      };
      [6] = {
        ["x"] = 245.3;
        ["y"] = -237.6;
        ["g"] = 21;
        ["sublevel"] = 1;
      };
      [7] = {
        ["x"] = 242.03377366643;
        ["y"] = -243.06276343371;
        ["g"] = 21;
        ["sublevel"] = 1;
      };
      [8] = {
        ["x"] = 247.7;
        ["y"] = -245;
        ["g"] = 21;
        ["sublevel"] = 1;
      };
      [9] = {
        ["x"] = 256.77309704386;
        ["y"] = -246.2831062806;
        ["g"] = 21;
        ["sublevel"] = 1;
      };
      [10] = {
        ["x"] = 261.85789690041;
        ["y"] = -241.73895768695;
        ["g"] = 21;
        ["sublevel"] = 1;
      };
      [11] = {
        ["x"] = 258.11034049633;
        ["y"] = -236.79656464485;
        ["g"] = 21;
        ["sublevel"] = 1;
      };
      [12] = {
        ["x"] = 250.5;
        ["y"] = -235.6;
        ["g"] = 21;
        ["sublevel"] = 1;
      };
      [13] = {
        ["x"] = 252.42551309506;
        ["y"] = -241.36276343371;
        ["g"] = 21;
        ["sublevel"] = 1;
      };
      [14] = {
        ["x"] = 233.42592777198;
        ["y"] = -334.85438291985;
        ["g"] = 18;
        ["sublevel"] = 1;
      };
      [15] = {
        ["x"] = 226.68186611945;
        ["y"] = -335.8168670723;
        ["g"] = 18;
        ["sublevel"] = 1;
      };
      [16] = {
        ["x"] = 226.41749423583;
        ["y"] = -329.99062571856;
        ["g"] = 18;
        ["sublevel"] = 1;
      };
      [17] = {
        ["x"] = 225.54151553692;
        ["y"] = -346.52717954545;
        ["g"] = 18;
        ["sublevel"] = 1;
      };
      [18] = {
        ["x"] = 219.43402898666;
        ["y"] = -346.52717954545;
        ["g"] = 18;
        ["sublevel"] = 1;
      };
      [19] = {
        ["x"] = 211.14529723988;
        ["y"] = -335.83906872159;
        ["g"] = 18;
        ["sublevel"] = 1;
      };
      [20] = {
        ["x"] = 211.79966143794;
        ["y"] = -330.82220164929;
        ["g"] = 18;
        ["sublevel"] = 1;
      };
      [21] = {
        ["x"] = 214.30810121468;
        ["y"] = -325.36908553769;
        ["g"] = 18;
        ["sublevel"] = 1;
      };
      [22] = {
        ["x"] = 218.56153090805;
        ["y"] = -322.86065200154;
        ["g"] = 18;
        ["sublevel"] = 1;
      };
      [23] = {
        ["x"] = 226.19590469738;
        ["y"] = -322.42440920283;
        ["g"] = 18;
        ["sublevel"] = 1;
      };
      [24] = {
        ["x"] = 232.73964652754;
        ["y"] = -327.22312991338;
        ["g"] = 18;
        ["sublevel"] = 1;
      };
      [25] = {
        ["x"] = 235.99575060473;
        ["y"] = -241.83340997273;
        ["g"] = 21;
        ["sublevel"] = 1;
      };
      [26] = {
        ["x"] = 251.39984159285;
        ["y"] = -250.25753320671;
        ["g"] = 21;
        ["sublevel"] = 1;
      };
      [27] = {
        ["x"] = 245.26227376698;
        ["y"] = -250.37786916742;
        ["g"] = 21;
        ["sublevel"] = 1;
      };
      [28] = {
        ["x"] = 238.52296416192;
        ["y"] = -248.21165660622;
        ["g"] = 21;
        ["sublevel"] = 1;
      };
      [29] = {
        ["x"] = 239.12471971347;
        ["y"] = -236.05685691519;
        ["g"] = 21;
        ["sublevel"] = 1;
      };
      [30] = {
        ["x"] = 243.69778921261;
        ["y"] = -231.00236093904;
        ["g"] = 21;
        ["sublevel"] = 1;
      };
      [31] = {
        ["x"] = 249.59467134469;
        ["y"] = -229.67859650935;
        ["g"] = 21;
        ["sublevel"] = 1;
      };
      [32] = {
        ["x"] = 256.93569518424;
        ["y"] = -231.00238159757;
        ["g"] = 21;
        ["sublevel"] = 1;
      };
    };
  };
  [3] = {
    ["name"] = "Minister of Air";
    ["id"] = 45930;
    ["count"] = 15;
    ["health"] = 2174442;
    ["scale"] = 1;
    ["displayId"] = 34790;
    ["creatureType"] = "Humanoid";
    ["level"] = 70;
    ["characteristics"] = {
      ["Taunt"] = true;
    };
    ["spells"] = {
      [87762] = {
      };
      [88963] = {
      };
      [413385] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 248.79194288742;
        ["y"] = -360.47384390599;
        ["g"] = 17;
        ["sublevel"] = 1;
      };
      [2] = {
        ["x"] = 264.60045020834;
        ["y"] = -296.288147198;
        ["g"] = 20;
        ["sublevel"] = 1;
      };
    };
  };
  [4] = {
    ["name"] = "Executor of the Caliph";
    ["id"] = 45928;
    ["count"] = 8;
    ["health"] = 1581412;
    ["scale"] = 1;
    ["displayId"] = 34735;
    ["creatureType"] = "Humanoid";
    ["level"] = 70;
    ["characteristics"] = {
      ["Taunt"] = true;
    };
    ["spells"] = {
      [87761] = {
      };
      [413387] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 258.62346568319;
        ["y"] = -420.00695529719;
        ["g"] = 16;
        ["sublevel"] = 1;
        ["patrol"] = {
          [1] = {
            ["x"] = 264.9;
            ["y"] = -418.8;
          };
          [2] = {
            ["x"] = 255.8;
            ["y"] = -418.3;
          };
          [3] = {
            ["x"] = 255.8;
            ["y"] = -419.2;
          };
          [4] = {
            ["x"] = 264.8;
            ["y"] = -419.8;
          };
          [5] = {
            ["x"] = 264.9;
            ["y"] = -418.3;
          };
        };
      };
      [2] = {
        ["x"] = 264.92116892084;
        ["y"] = -287.73332099412;
        ["g"] = 20;
        ["sublevel"] = 1;
      };
      [3] = {
        ["x"] = 243.40706479817;
        ["y"] = -316.96796619756;
        ["g"] = 19;
        ["sublevel"] = 1;
      };
      [4] = {
        ["x"] = 273.6449690617;
        ["y"] = -294.01171698703;
        ["g"] = 20;
        ["sublevel"] = 1;
      };
    };
  };
  [5] = {
    ["name"] = "Servant of Asaad";
    ["id"] = 45926;
    ["count"] = 4;
    ["health"] = 1186059;
    ["scale"] = 1;
    ["displayId"] = 34745;
    ["creatureType"] = "Humanoid";
    ["level"] = 70;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Fear"] = true;
      ["Disorient"] = true;
      ["Imprison"] = true;
      ["Stun"] = true;
      ["Slow"] = true;
    };
    ["spells"] = {
      [87771] = {
      };
      [411770] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 249.97521970199;
        ["y"] = -414.11046333479;
        ["g"] = 16;
        ["sublevel"] = 1;
      };
      [2] = {
        ["x"] = 250.36403154229;
        ["y"] = -322.66215336745;
        ["g"] = 19;
        ["sublevel"] = 1;
      };
      [3] = {
        ["x"] = 267.81004570456;
        ["y"] = -414.8930506464;
        ["g"] = 16;
        ["sublevel"] = 1;
      };
      [4] = {
        ["x"] = 257.42274195668;
        ["y"] = -359.50809200842;
        ["g"] = 17;
        ["sublevel"] = 1;
      };
      [5] = {
        ["x"] = 249.10041712193;
        ["y"] = -368.90424538768;
        ["g"] = 17;
        ["sublevel"] = 1;
      };
      [6] = {
        ["x"] = 236.75259541647;
        ["y"] = -310.8346092226;
        ["g"] = 19;
        ["sublevel"] = 1;
      };
      [7] = {
        ["x"] = 257.84445904282;
        ["y"] = -290.5768100558;
        ["g"] = 20;
        ["sublevel"] = 1;
      };
      [8] = {
        ["x"] = 271.37209574484;
        ["y"] = -302.31162417738;
        ["g"] = 20;
        ["sublevel"] = 1;
      };
    };
  };
  [6] = {
    ["name"] = "Altairus";
    ["id"] = 43873;
    ["count"] = 0;
    ["health"] = 8892045;
    ["scale"] = 1.6;
    ["displayId"] = 34265;
    ["creatureType"] = "Dragonkin";
    ["level"] = 70;
    ["isBoss"] = true;
    ["characteristics"] = {
      ["Taunt"] = true;
    };
    ["spells"] = {
      [88282] = {
      };
      [88286] = {
      };
      [88308] = {
      };
      [181089] = {
      };
      [413271] = {
      };
      [413295] = {
      };
      [413296] = {
      };
      [413319] = {
      };
      [413331] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 431.97456648307;
        ["y"] = -466.64431915394;
        ["sublevel"] = 1;
      };
    };
  };
  [7] = {
    ["name"] = "Turbulent Squall";
    ["id"] = 45924;
    ["count"] = 3;
    ["health"] = 889205;
    ["scale"] = 1;
    ["displayId"] = 35383;
    ["creatureType"] = "Elemental";
    ["level"] = 70;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Stun"] = true;
    };
    ["spells"] = {
      [88170] = {
      };
      [411743] = {
      };
      [411744] = {
      };
    };
    ["clones"] = {
      [2] = {
        ["x"] = 454.4;
        ["y"] = -441.9;
        ["g"] = 15;
        ["sublevel"] = 1;
      };
      [3] = {
        ["x"] = 448.7;
        ["y"] = -436.4;
        ["g"] = 15;
        ["sublevel"] = 1;
      };
      [5] = {
        ["x"] = 433.4;
        ["y"] = -432;
        ["g"] = 15;
        ["sublevel"] = 1;
      };
      [6] = {
        ["x"] = 441.2;
        ["y"] = -432.7;
        ["g"] = 15;
        ["sublevel"] = 1;
      };
      [7] = {
        ["x"] = 532.9;
        ["y"] = -370.1;
        ["g"] = 9;
        ["sublevel"] = 1;
      };
      [8] = {
        ["x"] = 531.7;
        ["y"] = -376.8;
        ["g"] = 9;
        ["sublevel"] = 1;
      };
      [9] = {
        ["x"] = 532.5;
        ["y"] = -363.1;
        ["g"] = 9;
        ["sublevel"] = 1;
      };
      [10] = {
        ["x"] = 530.6;
        ["y"] = -356.6;
        ["g"] = 9;
        ["sublevel"] = 1;
      };
      [11] = {
        ["x"] = 500;
        ["y"] = -342.3;
        ["g"] = 8;
        ["sublevel"] = 1;
      };
      [12] = {
        ["x"] = 506.3;
        ["y"] = -341.5;
        ["g"] = 8;
        ["sublevel"] = 1;
      };
      [13] = {
        ["x"] = 512.6;
        ["y"] = -342.2;
        ["g"] = 8;
        ["sublevel"] = 1;
      };
      [14] = {
        ["x"] = 518;
        ["y"] = -343.9;
        ["g"] = 8;
        ["sublevel"] = 1;
      };
      [15] = {
        ["x"] = 481.13436126557;
        ["y"] = -389.02020366471;
        ["g"] = 12;
        ["sublevel"] = 1;
      };
      [16] = {
        ["x"] = 489.82977877418;
        ["y"] = -396.54176225668;
        ["g"] = 12;
        ["sublevel"] = 1;
      };
    };
  };
  [8] = {
    ["name"] = "Young Storm Dragon";
    ["id"] = 45919;
    ["count"] = 20;
    ["health"] = 2372119;
    ["scale"] = 1;
    ["displayId"] = 34771;
    ["creatureType"] = "Dragonkin";
    ["level"] = 70;
    ["characteristics"] = {
      ["Taunt"] = true;
    };
    ["spells"] = {
      [88194] = {
      };
      [411012] = {
      };
      [411910] = {
      };
      [411911] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 453.3367879417;
        ["y"] = -423.1043148787;
        ["sublevel"] = 1;
        ["scale"] = 1.8;
      };
      [2] = {
        ["x"] = 510.87607755387;
        ["y"] = -365.29934376293;
        ["sublevel"] = 1;
        ["scale"] = 1.8;
      };
    };
  };
  [9] = {
    ["name"] = "Empyrean Assassin";
    ["id"] = 45922;
    ["count"] = 5;
    ["health"] = 988383;
    ["scale"] = 1;
    ["displayId"] = 19673;
    ["creatureType"] = "Elemental";
    ["level"] = 70;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Silence"] = true;
      ["Fear"] = true;
      ["Disorient"] = true;
      ["Stun"] = true;
    };
    ["spells"] = {
      [88186] = {
      };
      [411073] = {
      };
      [411083] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 434.7;
        ["y"] = -417.7;
        ["g"] = 13;
        ["sublevel"] = 1;
        ["patrol"] = {
          [1] = {
            ["x"] = 432.4;
            ["y"] = -413.4;
          };
          [2] = {
            ["x"] = 438.5;
            ["y"] = -408.5;
          };
          [3] = {
            ["x"] = 447.8;
            ["y"] = -407.2;
          };
          [4] = {
            ["x"] = 456.1;
            ["y"] = -408.8;
          };
          [5] = {
            ["x"] = 462.8;
            ["y"] = -413.2;
          };
          [6] = {
            ["x"] = 467;
            ["y"] = -420.5;
          };
          [7] = {
            ["x"] = 469.3;
            ["y"] = -427.6;
          };
          [8] = {
            ["x"] = 468.6;
            ["y"] = -434.9;
          };
          [9] = {
            ["x"] = 466.6;
            ["y"] = -433.7;
          };
          [10] = {
            ["x"] = 467;
            ["y"] = -425.5;
          };
          [11] = {
            ["x"] = 464.4;
            ["y"] = -419.5;
          };
          [12] = {
            ["x"] = 460.6;
            ["y"] = -413.4;
          };
          [13] = {
            ["x"] = 454.3;
            ["y"] = -410;
          };
          [14] = {
            ["x"] = 447.2;
            ["y"] = -408.9;
          };
          [15] = {
            ["x"] = 438.9;
            ["y"] = -410.4;
          };
          [16] = {
            ["x"] = 433.9;
            ["y"] = -414.7;
          };
          [17] = {
            ["x"] = 431.9;
            ["y"] = -412.9;
          };
        };
      };
      [2] = {
        ["x"] = 431.6;
        ["y"] = -415.7;
        ["g"] = 13;
        ["sublevel"] = 1;
      };
      [3] = {
        ["x"] = 466.6;
        ["y"] = -436.6;
        ["g"] = 14;
        ["sublevel"] = 1;
        ["patrol"] = {
          [1] = {
            ["x"] = 465.1;
            ["y"] = -432.8;
          };
          [2] = {
            ["x"] = 462.9;
            ["y"] = -432;
          };
          [3] = {
            ["x"] = 463.4;
            ["y"] = -424.8;
          };
          [4] = {
            ["x"] = 460.7;
            ["y"] = -417.5;
          };
          [5] = {
            ["x"] = 455.6;
            ["y"] = -413.7;
          };
          [6] = {
            ["x"] = 449.5;
            ["y"] = -411.5;
          };
          [7] = {
            ["x"] = 444;
            ["y"] = -411.2;
          };
          [8] = {
            ["x"] = 438.4;
            ["y"] = -413.4;
          };
          [9] = {
            ["x"] = 435;
            ["y"] = -415.5;
          };
          [10] = {
            ["x"] = 434.3;
            ["y"] = -414.7;
          };
          [11] = {
            ["x"] = 440.1;
            ["y"] = -410.8;
          };
          [12] = {
            ["x"] = 444.7;
            ["y"] = -410;
          };
          [13] = {
            ["x"] = 449.2;
            ["y"] = -409.9;
          };
          [14] = {
            ["x"] = 455.1;
            ["y"] = -411.3;
          };
          [15] = {
            ["x"] = 457.7;
            ["y"] = -413;
          };
          [16] = {
            ["x"] = 460.8;
            ["y"] = -415.2;
          };
          [17] = {
            ["x"] = 462.9;
            ["y"] = -418.6;
          };
          [18] = {
            ["x"] = 465;
            ["y"] = -424;
          };
          [19] = {
            ["x"] = 465.3;
            ["y"] = -428;
          };
          [20] = {
            ["x"] = 465.1;
            ["y"] = -433.2;
          };
        };
      };
      [4] = {
        ["x"] = 462.5;
        ["y"] = -434.9;
        ["g"] = 14;
        ["sublevel"] = 1;
      };
      [5] = {
        ["x"] = 491.6174773472;
        ["y"] = -365.77449715849;
        ["g"] = 10;
        ["sublevel"] = 1;
        ["patrol"] = {
          [1] = {
            ["x"] = 483.8;
            ["y"] = -364.3;
          };
          [2] = {
            ["x"] = 485.1;
            ["y"] = -356.5;
          };
          [3] = {
            ["x"] = 488.3;
            ["y"] = -350.6;
          };
          [4] = {
            ["x"] = 493.7;
            ["y"] = -345.6;
          };
          [5] = {
            ["x"] = 495.9;
            ["y"] = -348.2;
          };
          [6] = {
            ["x"] = 491;
            ["y"] = -352.1;
          };
          [7] = {
            ["x"] = 488.4;
            ["y"] = -357.7;
          };
          [8] = {
            ["x"] = 487.7;
            ["y"] = -364.4;
          };
          [9] = {
            ["x"] = 483.2;
            ["y"] = -364.1;
          };
        };
      };
      [6] = {
        ["x"] = 484.5;
        ["y"] = -366.2;
        ["g"] = 10;
        ["sublevel"] = 1;
      };
      [7] = {
        ["x"] = 509.2;
        ["y"] = -391.9;
        ["g"] = 11;
        ["sublevel"] = 1;
        ["patrol"] = {
          [1] = {
            ["x"] = 511.6;
            ["y"] = -387.4;
          };
          [2] = {
            ["x"] = 517.2;
            ["y"] = -385.9;
          };
          [3] = {
            ["x"] = 521.9;
            ["y"] = -383.1;
          };
          [4] = {
            ["x"] = 525.8;
            ["y"] = -379.2;
          };
          [5] = {
            ["x"] = 529;
            ["y"] = -382.4;
          };
          [6] = {
            ["x"] = 524;
            ["y"] = -386.2;
          };
          [7] = {
            ["x"] = 518.9;
            ["y"] = -388.7;
          };
          [8] = {
            ["x"] = 511.3;
            ["y"] = -391.1;
          };
          [9] = {
            ["x"] = 511.2;
            ["y"] = -387.3;
          };
        };
      };
      [8] = {
        ["x"] = 509.27449715849;
        ["y"] = -383.48449407902;
        ["g"] = 11;
        ["sublevel"] = 1;
      };
      [9] = {
        ["x"] = 456.06814813777;
        ["y"] = -448.17731273955;
        ["g"] = 15;
        ["sublevel"] = 1;
      };
      [10] = {
        ["x"] = 426.4;
        ["y"] = -433.3;
        ["g"] = 15;
        ["sublevel"] = 1;
      };
    };
  };
  [10] = {
    ["name"] = "Asaad";
    ["id"] = 43875;
    ["count"] = 0;
    ["health"] = 7904040;
    ["scale"] = 1.6;
    ["displayId"] = 35388;
    ["creatureType"] = "Elemental";
    ["level"] = 70;
    ["isBoss"] = true;
    ["characteristics"] = {
      ["Taunt"] = true;
    };
    ["spells"] = {
      [86911] = {
      };
      [86930] = {
      };
      [87553] = {
      };
      [87618] = {
      };
      [87622] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 251.38157125948;
        ["y"] = -202.93877641521;
        ["sublevel"] = 1;
      };
    };
  };
  [11] = {
    ["name"] = "Wild Vortex";
    ["id"] = 45912;
    ["count"] = 4;
    ["health"] = 889545;
    ["scale"] = 1;
    ["displayId"] = 36060;
    ["creatureType"] = "Elemental";
    ["level"] = 70;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Incapacitate"] = true;
      ["Fear"] = true;
      ["Disorient"] = true;
      ["Stun"] = true;
    };
    ["spells"] = {
      [410760] = {
      };
      [410870] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 505.5;
        ["y"] = -199.4;
        ["g"] = 6;
        ["sublevel"] = 1;
      };
      [2] = {
        ["x"] = 532.99904269193;
        ["y"] = -184.30656290582;
        ["g"] = 5;
        ["sublevel"] = 1;
      };
      [3] = {
        ["x"] = 536.79312860816;
        ["y"] = -198.39442386606;
        ["g"] = 5;
        ["sublevel"] = 1;
      };
      [4] = {
        ["x"] = 558.09344364169;
        ["y"] = -172.28459215858;
        ["g"] = 4;
        ["sublevel"] = 1;
      };
      [5] = {
        ["x"] = 511.9;
        ["y"] = -206;
        ["g"] = 6;
        ["sublevel"] = 1;
      };
      [6] = {
        ["x"] = 539.3288486866;
        ["y"] = -160.37410835529;
        ["g"] = 3;
        ["sublevel"] = 1;
      };
      [7] = {
        ["x"] = 542.91438505822;
        ["y"] = -154.10753985643;
        ["g"] = 3;
        ["sublevel"] = 1;
      };
      [8] = {
        ["x"] = 494.14499615722;
        ["y"] = -121.10062092293;
        ["g"] = 1;
        ["sublevel"] = 1;
      };
      [9] = {
        ["x"] = 482.12645607771;
        ["y"] = -405.22004535505;
        ["g"] = 12;
        ["sublevel"] = 1;
      };
      [10] = {
        ["x"] = 473.03776902866;
        ["y"] = -398.14208674114;
        ["g"] = 12;
        ["sublevel"] = 1;
      };
    };
  };
  [12] = {
    ["name"] = "Cloud Prince";
    ["id"] = 45917;
    ["count"] = 12;
    ["health"] = 1581412;
    ["scale"] = 1;
    ["displayId"] = 36061;
    ["creatureType"] = "Elemental";
    ["level"] = 70;
    ["characteristics"] = {
      ["Taunt"] = true;
    };
    ["spells"] = {
      [411002] = {
      };
      [411003] = {
      };
      [411004] = {
      };
      [411005] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 504.61197259036;
        ["y"] = -206.88802740964;
        ["g"] = 6;
        ["sublevel"] = 1;
      };
      [2] = {
        ["x"] = 480.1;
        ["y"] = -235.7;
        ["g"] = 7;
        ["sublevel"] = 1;
      };
      [3] = {
        ["x"] = 473.2;
        ["y"] = -228.3;
        ["g"] = 7;
        ["sublevel"] = 1;
      };
    };
  };
  [13] = {
    ["name"] = "Lurking Tempest";
    ["id"] = 45704;
    ["count"] = 0;
    ["health"] = 2372119;
    ["scale"] = 1;
    ["displayId"] = 13629;
    ["creatureType"] = "Elemental";
    ["level"] = 70;
    ["spells"] = {
      [85467] = {
      };
      [411001] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 517.6;
        ["y"] = -187.7;
        ["sublevel"] = 1;
      };
      [2] = {
        ["x"] = 522;
        ["y"] = -167.3;
        ["sublevel"] = 1;
      };
      [3] = {
        ["x"] = 485.3;
        ["y"] = -227;
        ["g"] = 7;
        ["sublevel"] = 1;
      };
    };
  };
  [14] = {
    ["name"] = "Gust Soldier";
    ["id"] = 45477;
    ["count"] = 5;
    ["health"] = 988383;
    ["scale"] = 1;
    ["displayId"] = 37224;
    ["creatureType"] = "Elemental";
    ["level"] = 70;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Fear"] = true;
      ["Disorient"] = true;
      ["Stun"] = true;
      ["Slow"] = true;
    };
    ["spells"] = {
      [410873] = {
      };
      [410997] = {
      };
      [410998] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 544.95112791986;
        ["y"] = -200.78096337834;
        ["g"] = 5;
        ["sublevel"] = 1;
      };
      [2] = {
        ["x"] = 538.78651986974;
        ["y"] = -180.79114851689;
        ["g"] = 5;
        ["sublevel"] = 1;
      };
      [3] = {
        ["x"] = 555.07799651519;
        ["y"] = -180.72885523411;
        ["g"] = 4;
        ["sublevel"] = 1;
      };
      [4] = {
        ["x"] = 562.7740072017;
        ["y"] = -179.37507875838;
        ["g"] = 4;
        ["sublevel"] = 1;
      };
      [5] = {
        ["x"] = 534.28069745116;
        ["y"] = -155.0046090046;
        ["g"] = 3;
        ["sublevel"] = 1;
      };
      [6] = {
        ["x"] = 482.31873608168;
        ["y"] = -132.26312379717;
        ["g"] = 1;
        ["sublevel"] = 1;
      };
      [7] = {
        ["x"] = 480.65011387942;
        ["y"] = -395.78814232376;
        ["g"] = 12;
        ["sublevel"] = 1;
      };
    };
  };
  [15] = {
    ["name"] = "Armored Mistral";
    ["id"] = 45915;
    ["count"] = 15;
    ["health"] = 1779089;
    ["scale"] = 1;
    ["displayId"] = 33828;
    ["creatureType"] = "Elemental";
    ["level"] = 70;
    ["characteristics"] = {
      ["Taunt"] = true;
    };
    ["spells"] = {
      [410999] = {
      };
      [411000] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 507.69729893433;
        ["y"] = -152.78730314991;
        ["g"] = 2;
        ["sublevel"] = 1;
        ["patrol"] = {
          [1] = {
            ["x"] = 500.7;
            ["y"] = -141.9;
          };
          [2] = {
            ["x"] = 514.6;
            ["y"] = -155.2;
          };
          [3] = {
            ["x"] = 516.7;
            ["y"] = -152.9;
          };
          [4] = {
            ["x"] = 502.5;
            ["y"] = -139.7;
          };
          [5] = {
            ["x"] = 500.7;
            ["y"] = -141.9;
          };
        };
      };
      [2] = {
        ["x"] = 513.51883065231;
        ["y"] = -146.363078047;
        ["g"] = 2;
        ["sublevel"] = 1;
      };
      [3] = {
        ["x"] = 491.58125143712;
        ["y"] = -129.63593545754;
        ["g"] = 1;
        ["sublevel"] = 1;
      };
      [4] = {
        ["x"] = 533.45194832047;
        ["y"] = -191.78967283806;
        ["g"] = 5;
        ["sublevel"] = 1;
      };
    };
  };
  [16] = {
    ["name"] = "Grand Vizier Ertan";
    ["id"] = 43878;
    ["count"] = 0;
    ["health"] = 6916035;
    ["scale"] = 1.6;
    ["displayId"] = 35181;
    ["creatureType"] = "Elemental";
    ["level"] = 70;
    ["isBoss"] = true;
    ["characteristics"] = {
      ["Taunt"] = true;
    };
    ["spells"] = {
      [86292] = {
      };
      [86295] = {
      };
      [86310] = {
      };
      [86331] = {
      };
      [413151] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 458.3;
        ["y"] = -250.8;
        ["sublevel"] = 1;
      };
    };
  };
};
