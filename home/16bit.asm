MACRO ___conversion_table_homecall
	; macro arguments: homecall type, function label
	; all functions clobber af and hl (except for outputs) and preserve bc and de
	; homecall types:
	; - read: index to ID conversion (in: a = 8-bit ID; out: hl = 16-bit index)
	; - write: ID to index conversion (in: hl = 16-bit index; out: a = 8-bit ID)
	; - lock: ID locking (in: a = ID (or zero to unlock), l = position; out: a = preserved)
	if strcmp("\1", "read") && strcmp("\1", "write") && strcmp("\1", "lock")
		fail "16-bit homecall: invalid call type"
	endc

	if (strcmp("\1", "write") != 0)
		ld h, a
	endc
	ldh a, [hROMBank]
	push af
	ld a, BANK(\2)
	rst Bankswitch
	if (strcmp("\1", "read") == 0)
		ld a, h
	endc
	call \2
	if (strcmp("\1", "read") != 0)
		ld l, a
	endc
	pop af
	rst Bankswitch
	if (strcmp("\1", "read") != 0)
		ld a, l
	endc
	ret
ENDM

MACRO ___conversion_table_homecall_readlocked
	; macro argument: table name
	; in: a = position
	; out: a = 8-bit index; everything else preserved
	push hl
	add a, LOW(\1LockedEntries)
	ld l, a
	ldh a, [rSVBK]
	ld h, a
	ld a, BANK(\1LockedEntries)
	ldh [rSVBK], a
	ld a, h
	ld h, HIGH(\1LockedEntries)
	ld l, [hl]
	ldh [rSVBK], a
	ld a, l
	pop hl
	ret
ENDM

; in: a = 8-bit index
; out: hl = 16-bit index; a clobbered
GetPokemonIndexFromID::
	___conversion_table_homecall read, _GetPokemonIndexFromID

; in: hl = 16-bit index
; out: a = 8-bit index, hl clobbered
GetPokemonIDFromIndex::
	___conversion_table_homecall write, _GetPokemonIDFromIndex

; in: a = 8-bit index or zero (to clear), l = position
; out: a = unchanged, hl = clobbered
LockPokemonID::
	___conversion_table_homecall lock, _LockPokemonID

; in: a = position
; out: a = 8-bit index; everything else preserved
GetLockedPokemonID::
	___conversion_table_homecall_readlocked wPokemonIndexTable

; in: a = 8-bit index
; out: hl = 16-bit index; a clobbered
GetMoveIndexFromID::
	___conversion_table_homecall read, _GetMoveIndexFromID

; in: hl = 16-bit index
; out: a = 8-bit index, hl clobbered
GetMoveIDFromIndex::
	___conversion_table_homecall write, _GetMoveIDFromIndex

; in: a = 8-bit index or zero (to clear), l = position
; out: a = unchanged, hl = clobbered
LockMoveID::
	___conversion_table_homecall lock, _LockMoveID

; in: a = position
; out: a = 8-bit index; everything else preserved
GetLockedMoveID::
	___conversion_table_homecall_readlocked wMoveIndexTable

; in: a = 8-bit index
; out: hl = 16-bit index; a clobbered
GetItemIndexFromID::
	___conversion_table_homecall read, _GetItemIndexFromID

; in: hl = 16-bit index
; out: a = 8-bit index, hl clobbered
GetItemIDFromIndex::
	___conversion_table_homecall write, _GetItemIDFromIndex

; in: a = 8-bit index or zero (to clear), l = position
; out: a = unchanged, hl = clobbered
LockItemID::
	___conversion_table_homecall lock, _LockItemID

; in: a = position
; out: a = 8-bit index; everything else preserved
GetLockedItemID::
	___conversion_table_homecall_readlocked wItemIndexTable

GetItemIDFromHL::
; in:
; 	[hl] = address of 16-bit item index
; out:
;	a  = found item ID
; preserves all registers except output
	push hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call GetItemIDFromIndex
	pop hl
	ret
