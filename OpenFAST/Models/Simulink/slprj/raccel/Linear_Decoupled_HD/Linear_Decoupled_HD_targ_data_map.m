    function targMap = targDataMap(),

    ;%***********************
    ;% Create Parameter Map *
    ;%***********************
    
        nTotData      = 0; %add to this count as we go
        nTotSects     = 1;
        sectIdxOffset = 0;

        ;%
        ;% Define dummy sections & preallocate arrays
        ;%
        dumSection.nData = -1;
        dumSection.data  = [];

        dumData.logicalSrcIdx = -1;
        dumData.dtTransOffset = -1;

        ;%
        ;% Init/prealloc paramMap
        ;%
        paramMap.nSections           = nTotSects;
        paramMap.sectIdxOffset       = sectIdxOffset;
            paramMap.sections(nTotSects) = dumSection; %prealloc
        paramMap.nTotData            = -1;

        ;%
        ;% Auto data (rtP)
        ;%
            section.nData     = 14;
            section.data(14)  = dumData; %prealloc

                    ;% rtP.A_HD
                    section.data(1).logicalSrcIdx = 0;
                    section.data(1).dtTransOffset = 0;

                    ;% rtP.A_platform
                    section.data(2).logicalSrcIdx = 1;
                    section.data(2).dtTransOffset = 97969;

                    ;% rtP.B_HD
                    section.data(3).logicalSrcIdx = 2;
                    section.data(3).dtTransOffset = 98369;

                    ;% rtP.B_platform
                    section.data(4).logicalSrcIdx = 3;
                    section.data(4).dtTransOffset = 98682;

                    ;% rtP.C_HD
                    section.data(5).logicalSrcIdx = 4;
                    section.data(5).dtTransOffset = 103382;

                    ;% rtP.C_platform
                    section.data(6).logicalSrcIdx = 5;
                    section.data(6).dtTransOffset = 105260;

                    ;% rtP.HydroDynStateSpaceInputs_Time0
                    section.data(7).logicalSrcIdx = 6;
                    section.data(7).dtTransOffset = 106460;

                    ;% rtP.HydroDynStateSpaceInputs_Data0
                    section.data(8).logicalSrcIdx = 7;
                    section.data(8).dtTransOffset = 178172;

                    ;% rtP.FromWorkspace_Time0
                    section.data(9).logicalSrcIdx = 8;
                    section.data(9).dtTransOffset = 249884;

                    ;% rtP.FromWorkspace_Data0
                    section.data(10).logicalSrcIdx = 9;
                    section.data(10).dtTransOffset = 249885;

                    ;% rtP.Integrator1_IC
                    section.data(11).logicalSrcIdx = 10;
                    section.data(11).dtTransOffset = 249905;

                    ;% rtP.Integrator_IC
                    section.data(12).logicalSrcIdx = 11;
                    section.data(12).dtTransOffset = 249906;

                    ;% rtP.Constant_Value
                    section.data(13).logicalSrcIdx = 12;
                    section.data(13).dtTransOffset = 249907;

                    ;% rtP.Constant1_Value
                    section.data(14).logicalSrcIdx = 13;
                    section.data(14).dtTransOffset = 249946;

            nTotData = nTotData + section.nData;
            paramMap.sections(1) = section;
            clear section


            ;%
            ;% Non-auto Data (parameter)
            ;%


        ;%
        ;% Add final counts to struct.
        ;%
        paramMap.nTotData = nTotData;



    ;%**************************
    ;% Create Block Output Map *
    ;%**************************
    
        nTotData      = 0; %add to this count as we go
        nTotSects     = 1;
        sectIdxOffset = 0;

        ;%
        ;% Define dummy sections & preallocate arrays
        ;%
        dumSection.nData = -1;
        dumSection.data  = [];

        dumData.logicalSrcIdx = -1;
        dumData.dtTransOffset = -1;

        ;%
        ;% Init/prealloc sigMap
        ;%
        sigMap.nSections           = nTotSects;
        sigMap.sectIdxOffset       = sectIdxOffset;
            sigMap.sections(nTotSects) = dumSection; %prealloc
        sigMap.nTotData            = -1;

        ;%
        ;% Auto data (rtB)
        ;%
            section.nData     = 11;
            section.data(11)  = dumData; %prealloc

                    ;% rtB.g0vm3uynhb
                    section.data(1).logicalSrcIdx = 0;
                    section.data(1).dtTransOffset = 0;

                    ;% rtB.gdscea3t3s
                    section.data(2).logicalSrcIdx = 1;
                    section.data(2).dtTransOffset = 1;

                    ;% rtB.ltbm5hkgir
                    section.data(3).logicalSrcIdx = 2;
                    section.data(3).dtTransOffset = 21;

                    ;% rtB.cpljaqsgck
                    section.data(4).logicalSrcIdx = 3;
                    section.data(4).dtTransOffset = 41;

                    ;% rtB.mtjk1hrcqk
                    section.data(5).logicalSrcIdx = 4;
                    section.data(5).dtTransOffset = 354;

                    ;% rtB.cnutujturz
                    section.data(6).logicalSrcIdx = 5;
                    section.data(6).dtTransOffset = 667;

                    ;% rtB.e15osh5iil
                    section.data(7).logicalSrcIdx = 6;
                    section.data(7).dtTransOffset = 687;

                    ;% rtB.fql2je0s4g
                    section.data(8).logicalSrcIdx = 7;
                    section.data(8).dtTransOffset = 1000;

                    ;% rtB.gn4npwrlyj
                    section.data(9).logicalSrcIdx = 8;
                    section.data(9).dtTransOffset = 1235;

                    ;% rtB.jlczdjbm4r
                    section.data(10).logicalSrcIdx = 9;
                    section.data(10).dtTransOffset = 1255;

                    ;% rtB.knee2kaf1d
                    section.data(11).logicalSrcIdx = 10;
                    section.data(11).dtTransOffset = 1568;

            nTotData = nTotData + section.nData;
            sigMap.sections(1) = section;
            clear section


            ;%
            ;% Non-auto Data (signal)
            ;%


        ;%
        ;% Add final counts to struct.
        ;%
        sigMap.nTotData = nTotData;



    ;%*******************
    ;% Create DWork Map *
    ;%*******************
    
        nTotData      = 0; %add to this count as we go
        nTotSects     = 2;
        sectIdxOffset = 1;

        ;%
        ;% Define dummy sections & preallocate arrays
        ;%
        dumSection.nData = -1;
        dumSection.data  = [];

        dumData.logicalSrcIdx = -1;
        dumData.dtTransOffset = -1;

        ;%
        ;% Init/prealloc dworkMap
        ;%
        dworkMap.nSections           = nTotSects;
        dworkMap.sectIdxOffset       = sectIdxOffset;
            dworkMap.sections(nTotSects) = dumSection; %prealloc
        dworkMap.nTotData            = -1;

        ;%
        ;% Auto data (rtDW)
        ;%
            section.nData     = 4;
            section.data(4)  = dumData; %prealloc

                    ;% rtDW.f2zlgn55dr.TimePtr
                    section.data(1).logicalSrcIdx = 0;
                    section.data(1).dtTransOffset = 0;

                    ;% rtDW.jf35i0x0s3.LoggedData
                    section.data(2).logicalSrcIdx = 1;
                    section.data(2).dtTransOffset = 1;

                    ;% rtDW.nb1ss4nxop.TimePtr
                    section.data(3).logicalSrcIdx = 2;
                    section.data(3).dtTransOffset = 2;

                    ;% rtDW.a2ve2sd04u.AQHandles
                    section.data(4).logicalSrcIdx = 3;
                    section.data(4).dtTransOffset = 3;

            nTotData = nTotData + section.nData;
            dworkMap.sections(1) = section;
            clear section

            section.nData     = 2;
            section.data(2)  = dumData; %prealloc

                    ;% rtDW.awuffzesc2.PrevIndex
                    section.data(1).logicalSrcIdx = 4;
                    section.data(1).dtTransOffset = 0;

                    ;% rtDW.cycgrsoo3r.PrevIndex
                    section.data(2).logicalSrcIdx = 5;
                    section.data(2).dtTransOffset = 1;

            nTotData = nTotData + section.nData;
            dworkMap.sections(2) = section;
            clear section


            ;%
            ;% Non-auto Data (dwork)
            ;%


        ;%
        ;% Add final counts to struct.
        ;%
        dworkMap.nTotData = nTotData;



    ;%
    ;% Add individual maps to base struct.
    ;%

    targMap.paramMap  = paramMap;
    targMap.signalMap = sigMap;
    targMap.dworkMap  = dworkMap;

    ;%
    ;% Add checksums to base struct.
    ;%


    targMap.checksum0 = 2219643579;
    targMap.checksum1 = 1250443361;
    targMap.checksum2 = 3258463862;
    targMap.checksum3 = 1037043963;

