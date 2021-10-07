
SegmentLED:
        sbi	  DataPort,DataPort2
        Pause100ms
        sbi   ControlPort,ControlPort2
        Pause100ms
        SBI   ControlPort,ControlPort3
        rjmp  SegmentLED
