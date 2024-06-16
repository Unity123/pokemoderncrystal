GetMoveCategoryName:
; Copy the category name of move b to wStringBuffer1.

    ld a, b
    ld l, a
    ld a, MOVE_TYPE
    call GetMoveAttribute

; get category
    and ~TYPE_MASK
; move to range 0-2 by rotating left twice (1-3) and then decrementing
    rlc a
    rlc a
    dec a

    ld hl, CategoryNames
    ld e, a
    ld d, 0
    add hl, de
    add hl, de
    ld a, [hli]
    ld h, [hl]
    ld l, a
    ld de, wStringBuffer1
    ld bc, MOVE_NAME_LENGTH
    jp CopyBytes

INCLUDE "data/types/category_names.asm"