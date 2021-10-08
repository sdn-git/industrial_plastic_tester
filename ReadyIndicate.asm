ReadyIndicate:
        push_all
        ldi tmp, _spc
        sts S_D1,tmp
        ldi tmp, _Eb
        sts S_D2,tmp
        ldi tmp,_Ns
        sts S_D3,tmp
        ldi tmp,_Ob
        sts S_D4,tmp
        ldi tmp,_Ds
        sts S_D5,tmp
        pop_all
ret
