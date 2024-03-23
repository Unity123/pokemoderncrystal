CategoryNames:
    dw .Physical
    dw .Special
    dw .Unused
    dw .Status

.Physical: db "PHYSICAL@"
.Special: db "SPECIAL@"
.Unused: db "@" ; This is a placeholder because of weird bugs
.Status: db "STATUS@"