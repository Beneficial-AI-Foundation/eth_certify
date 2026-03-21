(set-option :auto_config false)
(set-option :smt.mbqi false)
(set-option :smt.case_split 3)
(set-option :smt.qi.eager_threshold 100.0)
(set-option :smt.delay_units true)
(set-option :smt.arith.solver 2)
(set-option :smt.arith.nl false)
(set-option :pi.enabled false)
(set-option :rewriter.sort_disjunctions false)

;; Prelude

;; AIR prelude
(declare-sort %%Function%% 0)

(declare-sort FuelId 0)
(declare-sort Fuel 0)
(declare-const zero Fuel)
(declare-fun succ (Fuel) Fuel)
(declare-fun fuel_bool (FuelId) Bool)
(declare-fun fuel_bool_default (FuelId) Bool)
(declare-const fuel_defaults Bool)
(assert
 (=>
  fuel_defaults
  (forall ((id FuelId)) (!
    (= (fuel_bool id) (fuel_bool_default id))
    :pattern ((fuel_bool id))
    :qid prelude_fuel_defaults
    :skolemid skolem_prelude_fuel_defaults
))))
(declare-datatypes ((fndef 0)) (((fndef_singleton))))
(declare-sort Poly 0)
(declare-sort Height 0)
(declare-fun I (Int) Poly)
(declare-fun B (Bool) Poly)
(declare-fun R (Real) Poly)
(declare-fun F (fndef) Poly)
(declare-fun %I (Poly) Int)
(declare-fun %B (Poly) Bool)
(declare-fun %R (Poly) Real)
(declare-fun %F (Poly) fndef)
(declare-sort Type 0)
(declare-const BOOL Type)
(declare-const INT Type)
(declare-const NAT Type)
(declare-const REAL Type)
(declare-const CHAR Type)
(declare-const USIZE Type)
(declare-const ISIZE Type)
(declare-const TYPE%tuple%0. Type)
(declare-fun UINT (Int) Type)
(declare-fun SINT (Int) Type)
(declare-fun FLOAT (Int) Type)
(declare-fun CONST_INT (Int) Type)
(declare-fun CONST_BOOL (Bool) Type)
(declare-sort Dcr 0)
(declare-const $ Dcr)
(declare-const $slice Dcr)
(declare-const $dyn Dcr)
(declare-fun DST (Dcr) Dcr)
(declare-fun REF (Dcr) Dcr)
(declare-fun MUT_REF (Dcr) Dcr)
(declare-fun BOX (Dcr Type Dcr) Dcr)
(declare-fun RC (Dcr Type Dcr) Dcr)
(declare-fun ARC (Dcr Type Dcr) Dcr)
(declare-fun GHOST (Dcr) Dcr)
(declare-fun TRACKED (Dcr) Dcr)
(declare-fun NEVER (Dcr) Dcr)
(declare-fun CONST_PTR (Dcr) Dcr)
(declare-fun ARRAY (Dcr Type Dcr Type) Type)
(declare-fun MUTREF (Dcr Type) Type)
(declare-fun SLICE (Dcr Type) Type)
(declare-const STRSLICE Type)
(declare-const ALLOCATOR_GLOBAL Type)
(declare-fun PTR (Dcr Type) Type)
(declare-fun has_type (Poly Type) Bool)
(declare-fun sized (Dcr) Bool)
(declare-fun as_type (Poly Type) Poly)
(declare-fun mk_fun (%%Function%%) %%Function%%)
(declare-fun const_int (Type) Int)
(declare-fun const_bool (Type) Bool)
(declare-fun mut_ref_current% (Poly) Poly)
(declare-fun mut_ref_future% (Poly) Poly)
(declare-fun mut_ref_update_current% (Poly Poly) Poly)
(assert
 (forall ((m Poly) (arg Poly)) (!
   (= (mut_ref_current% (mut_ref_update_current% m arg)) arg)
   :pattern ((mut_ref_update_current% m arg))
   :qid prelude_mut_ref_update_current_current
   :skolemid skolem_prelude_mut_ref_update_current_current
)))
(assert
 (forall ((m Poly) (arg Poly)) (!
   (= (mut_ref_future% (mut_ref_update_current% m arg)) (mut_ref_future% m))
   :pattern ((mut_ref_update_current% m arg))
   :qid prelude_mut_ref_update_current_future
   :skolemid skolem_prelude_mut_ref_update_current_future
)))
(assert
 (forall ((m Poly) (d Dcr) (t Type)) (!
   (=>
    (has_type m (MUTREF d t))
    (has_type (mut_ref_current% m) t)
   )
   :pattern ((has_type m (MUTREF d t)) (mut_ref_current% m))
   :qid prelude_mut_ref_current_has_type
   :skolemid skolem_prelude_mut_ref_current_has_type
)))
(assert
 (forall ((m Poly) (d Dcr) (t Type)) (!
   (=>
    (has_type m (MUTREF d t))
    (has_type (mut_ref_future% m) t)
   )
   :pattern ((has_type m (MUTREF d t)) (mut_ref_future% m))
   :qid prelude_mut_ref_current_has_type
   :skolemid skolem_prelude_mut_ref_current_has_type
)))
(assert
 (forall ((m Poly) (d Dcr) (t Type) (arg Poly)) (!
   (=>
    (and
     (has_type m (MUTREF d t))
     (has_type arg t)
    )
    (has_type (mut_ref_update_current% m arg) (MUTREF d t))
   )
   :pattern ((has_type m (MUTREF d t)) (mut_ref_update_current% m arg))
   :qid prelude_mut_ref_update_has_type
   :skolemid skolem_prelude_mut_ref_update_has_type
)))
(assert
 (forall ((d Dcr)) (!
   (=>
    (sized d)
    (sized (DST d))
   )
   :pattern ((sized (DST d)))
   :qid prelude_sized_decorate_struct_inherit
   :skolemid skolem_prelude_sized_decorate_struct_inherit
)))
(assert
 (forall ((d Dcr)) (!
   (sized (REF d))
   :pattern ((sized (REF d)))
   :qid prelude_sized_decorate_ref
   :skolemid skolem_prelude_sized_decorate_ref
)))
(assert
 (forall ((d Dcr)) (!
   (sized (MUT_REF d))
   :pattern ((sized (MUT_REF d)))
   :qid prelude_sized_decorate_mut_ref
   :skolemid skolem_prelude_sized_decorate_mut_ref
)))
(assert
 (forall ((d Dcr) (t Type) (d2 Dcr)) (!
   (sized (BOX d t d2))
   :pattern ((sized (BOX d t d2)))
   :qid prelude_sized_decorate_box
   :skolemid skolem_prelude_sized_decorate_box
)))
(assert
 (forall ((d Dcr) (t Type) (d2 Dcr)) (!
   (sized (RC d t d2))
   :pattern ((sized (RC d t d2)))
   :qid prelude_sized_decorate_rc
   :skolemid skolem_prelude_sized_decorate_rc
)))
(assert
 (forall ((d Dcr) (t Type) (d2 Dcr)) (!
   (sized (ARC d t d2))
   :pattern ((sized (ARC d t d2)))
   :qid prelude_sized_decorate_arc
   :skolemid skolem_prelude_sized_decorate_arc
)))
(assert
 (forall ((d Dcr)) (!
   (sized (GHOST d))
   :pattern ((sized (GHOST d)))
   :qid prelude_sized_decorate_ghost
   :skolemid skolem_prelude_sized_decorate_ghost
)))
(assert
 (forall ((d Dcr)) (!
   (sized (TRACKED d))
   :pattern ((sized (TRACKED d)))
   :qid prelude_sized_decorate_tracked
   :skolemid skolem_prelude_sized_decorate_tracked
)))
(assert
 (forall ((d Dcr)) (!
   (sized (NEVER d))
   :pattern ((sized (NEVER d)))
   :qid prelude_sized_decorate_never
   :skolemid skolem_prelude_sized_decorate_never
)))
(assert
 (forall ((d Dcr)) (!
   (sized (CONST_PTR d))
   :pattern ((sized (CONST_PTR d)))
   :qid prelude_sized_decorate_const_ptr
   :skolemid skolem_prelude_sized_decorate_const_ptr
)))
(assert
 (sized $)
)
(assert
 (forall ((i Int)) (!
   (= i (const_int (CONST_INT i)))
   :pattern ((CONST_INT i))
   :qid prelude_type_id_const_int
   :skolemid skolem_prelude_type_id_const_int
)))
(assert
 (forall ((b Bool)) (!
   (= b (const_bool (CONST_BOOL b)))
   :pattern ((CONST_BOOL b))
   :qid prelude_type_id_const_bool
   :skolemid skolem_prelude_type_id_const_bool
)))
(assert
 (forall ((b Bool)) (!
   (has_type (B b) BOOL)
   :pattern ((has_type (B b) BOOL))
   :qid prelude_has_type_bool
   :skolemid skolem_prelude_has_type_bool
)))
(assert
 (forall ((r Real)) (!
   (has_type (R r) REAL)
   :pattern ((has_type (R r) REAL))
   :qid prelude_has_type_real
   :skolemid skolem_prelude_has_type_real
)))
(assert
 (forall ((x Poly) (t Type)) (!
   (and
    (has_type (as_type x t) t)
    (=>
     (has_type x t)
     (= x (as_type x t))
   ))
   :pattern ((as_type x t))
   :qid prelude_as_type
   :skolemid skolem_prelude_as_type
)))
(assert
 (forall ((x %%Function%%)) (!
   (= (mk_fun x) x)
   :pattern ((mk_fun x))
   :qid prelude_mk_fun
   :skolemid skolem_prelude_mk_fun
)))
(assert
 (forall ((x Bool)) (!
   (= x (%B (B x)))
   :pattern ((B x))
   :qid prelude_unbox_box_bool
   :skolemid skolem_prelude_unbox_box_bool
)))
(assert
 (forall ((x Int)) (!
   (= x (%I (I x)))
   :pattern ((I x))
   :qid prelude_unbox_box_int
   :skolemid skolem_prelude_unbox_box_int
)))
(assert
 (forall ((x Real)) (!
   (= x (%R (R x)))
   :pattern ((R x))
   :qid prelude_unbox_box_real
   :skolemid skolem_prelude_unbox_box_real
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x BOOL)
    (= x (B (%B x)))
   )
   :pattern ((has_type x BOOL))
   :qid prelude_box_unbox_bool
   :skolemid skolem_prelude_box_unbox_bool
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x INT)
    (= x (I (%I x)))
   )
   :pattern ((has_type x INT))
   :qid prelude_box_unbox_int
   :skolemid skolem_prelude_box_unbox_int
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x NAT)
    (= x (I (%I x)))
   )
   :pattern ((has_type x NAT))
   :qid prelude_box_unbox_nat
   :skolemid skolem_prelude_box_unbox_nat
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x USIZE)
    (= x (I (%I x)))
   )
   :pattern ((has_type x USIZE))
   :qid prelude_box_unbox_usize
   :skolemid skolem_prelude_box_unbox_usize
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x ISIZE)
    (= x (I (%I x)))
   )
   :pattern ((has_type x ISIZE))
   :qid prelude_box_unbox_isize
   :skolemid skolem_prelude_box_unbox_isize
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (UINT bits))
    (= x (I (%I x)))
   )
   :pattern ((has_type x (UINT bits)))
   :qid prelude_box_unbox_uint
   :skolemid skolem_prelude_box_unbox_uint
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (SINT bits))
    (= x (I (%I x)))
   )
   :pattern ((has_type x (SINT bits)))
   :qid prelude_box_unbox_sint
   :skolemid skolem_prelude_box_unbox_sint
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (FLOAT bits))
    (= x (I (%I x)))
   )
   :pattern ((has_type x (FLOAT bits)))
   :qid prelude_box_unbox_sint
   :skolemid skolem_prelude_box_unbox_sint
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x CHAR)
    (= x (I (%I x)))
   )
   :pattern ((has_type x CHAR))
   :qid prelude_box_unbox_char
   :skolemid skolem_prelude_box_unbox_char
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x REAL)
    (= x (R (%R x)))
   )
   :pattern ((has_type x REAL))
   :qid prelude_box_unbox_real
   :skolemid skolem_prelude_box_unbox_real
)))
(declare-fun ext_eq (Bool Type Poly Poly) Bool)
(assert
 (forall ((deep Bool) (t Type) (x Poly) (y Poly)) (!
   (= (= x y) (ext_eq deep t x y))
   :pattern ((ext_eq deep t x y))
   :qid prelude_ext_eq
   :skolemid skolem_prelude_ext_eq
)))
(declare-const SZ Int)
(assert
 (or
  (= SZ 32)
  (= SZ 64)
))
(declare-fun uHi (Int) Int)
(declare-fun iLo (Int) Int)
(declare-fun iHi (Int) Int)
(assert
 (= (uHi 8) 256)
)
(assert
 (= (uHi 16) 65536)
)
(assert
 (= (uHi 32) 4294967296)
)
(assert
 (= (uHi 64) 18446744073709551616)
)
(assert
 (= (uHi 128) (+ 1 340282366920938463463374607431768211455))
)
(assert
 (= (iLo 8) (- 128))
)
(assert
 (= (iLo 16) (- 32768))
)
(assert
 (= (iLo 32) (- 2147483648))
)
(assert
 (= (iLo 64) (- 9223372036854775808))
)
(assert
 (= (iLo 128) (- 170141183460469231731687303715884105728))
)
(assert
 (= (iHi 8) 128)
)
(assert
 (= (iHi 16) 32768)
)
(assert
 (= (iHi 32) 2147483648)
)
(assert
 (= (iHi 64) 9223372036854775808)
)
(assert
 (= (iHi 128) 170141183460469231731687303715884105728)
)
(declare-fun nClip (Int) Int)
(declare-fun uClip (Int Int) Int)
(declare-fun iClip (Int Int) Int)
(declare-fun charClip (Int) Int)
(assert
 (forall ((i Int)) (!
   (and
    (<= 0 (nClip i))
    (=>
     (<= 0 i)
     (= i (nClip i))
   ))
   :pattern ((nClip i))
   :qid prelude_nat_clip
   :skolemid skolem_prelude_nat_clip
)))
(assert
 (forall ((bits Int) (i Int)) (!
   (and
    (<= 0 (uClip bits i))
    (< (uClip bits i) (uHi bits))
    (=>
     (and
      (<= 0 i)
      (< i (uHi bits))
     )
     (= i (uClip bits i))
   ))
   :pattern ((uClip bits i))
   :qid prelude_u_clip
   :skolemid skolem_prelude_u_clip
)))
(assert
 (forall ((bits Int) (i Int)) (!
   (and
    (<= (iLo bits) (iClip bits i))
    (< (iClip bits i) (iHi bits))
    (=>
     (and
      (<= (iLo bits) i)
      (< i (iHi bits))
     )
     (= i (iClip bits i))
   ))
   :pattern ((iClip bits i))
   :qid prelude_i_clip
   :skolemid skolem_prelude_i_clip
)))
(assert
 (forall ((i Int)) (!
   (and
    (or
     (and
      (<= 0 (charClip i))
      (<= (charClip i) 55295)
     )
     (and
      (<= 57344 (charClip i))
      (<= (charClip i) 1114111)
    ))
    (=>
     (or
      (and
       (<= 0 i)
       (<= i 55295)
      )
      (and
       (<= 57344 i)
       (<= i 1114111)
     ))
     (= i (charClip i))
   ))
   :pattern ((charClip i))
   :qid prelude_char_clip
   :skolemid skolem_prelude_char_clip
)))
(declare-fun uInv (Int Int) Bool)
(declare-fun iInv (Int Int) Bool)
(declare-fun charInv (Int) Bool)
(assert
 (forall ((bits Int) (i Int)) (!
   (= (uInv bits i) (and
     (<= 0 i)
     (< i (uHi bits))
   ))
   :pattern ((uInv bits i))
   :qid prelude_u_inv
   :skolemid skolem_prelude_u_inv
)))
(assert
 (forall ((bits Int) (i Int)) (!
   (= (iInv bits i) (and
     (<= (iLo bits) i)
     (< i (iHi bits))
   ))
   :pattern ((iInv bits i))
   :qid prelude_i_inv
   :skolemid skolem_prelude_i_inv
)))
(assert
 (forall ((i Int)) (!
   (= (charInv i) (or
     (and
      (<= 0 i)
      (<= i 55295)
     )
     (and
      (<= 57344 i)
      (<= i 1114111)
   )))
   :pattern ((charInv i))
   :qid prelude_char_inv
   :skolemid skolem_prelude_char_inv
)))
(assert
 (forall ((x Int)) (!
   (has_type (I x) INT)
   :pattern ((has_type (I x) INT))
   :qid prelude_has_type_int
   :skolemid skolem_prelude_has_type_int
)))
(assert
 (forall ((x Int)) (!
   (=>
    (<= 0 x)
    (has_type (I x) NAT)
   )
   :pattern ((has_type (I x) NAT))
   :qid prelude_has_type_nat
   :skolemid skolem_prelude_has_type_nat
)))
(assert
 (forall ((x Int)) (!
   (=>
    (uInv SZ x)
    (has_type (I x) USIZE)
   )
   :pattern ((has_type (I x) USIZE))
   :qid prelude_has_type_usize
   :skolemid skolem_prelude_has_type_usize
)))
(assert
 (forall ((x Int)) (!
   (=>
    (iInv SZ x)
    (has_type (I x) ISIZE)
   )
   :pattern ((has_type (I x) ISIZE))
   :qid prelude_has_type_isize
   :skolemid skolem_prelude_has_type_isize
)))
(assert
 (forall ((bits Int) (x Int)) (!
   (=>
    (uInv bits x)
    (has_type (I x) (UINT bits))
   )
   :pattern ((has_type (I x) (UINT bits)))
   :qid prelude_has_type_uint
   :skolemid skolem_prelude_has_type_uint
)))
(assert
 (forall ((bits Int) (x Int)) (!
   (=>
    (iInv bits x)
    (has_type (I x) (SINT bits))
   )
   :pattern ((has_type (I x) (SINT bits)))
   :qid prelude_has_type_sint
   :skolemid skolem_prelude_has_type_sint
)))
(assert
 (forall ((bits Int) (x Int)) (!
   (=>
    (uInv bits x)
    (has_type (I x) (FLOAT bits))
   )
   :pattern ((has_type (I x) (FLOAT bits)))
   :qid prelude_has_type_sint
   :skolemid skolem_prelude_has_type_sint
)))
(assert
 (forall ((x Int)) (!
   (=>
    (charInv x)
    (has_type (I x) CHAR)
   )
   :pattern ((has_type (I x) CHAR))
   :qid prelude_has_type_char
   :skolemid skolem_prelude_has_type_char
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x NAT)
    (<= 0 (%I x))
   )
   :pattern ((has_type x NAT))
   :qid prelude_unbox_int
   :skolemid skolem_prelude_unbox_int
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x USIZE)
    (uInv SZ (%I x))
   )
   :pattern ((has_type x USIZE))
   :qid prelude_unbox_usize
   :skolemid skolem_prelude_unbox_usize
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x ISIZE)
    (iInv SZ (%I x))
   )
   :pattern ((has_type x ISIZE))
   :qid prelude_unbox_isize
   :skolemid skolem_prelude_unbox_isize
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (UINT bits))
    (uInv bits (%I x))
   )
   :pattern ((has_type x (UINT bits)))
   :qid prelude_unbox_uint
   :skolemid skolem_prelude_unbox_uint
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (SINT bits))
    (iInv bits (%I x))
   )
   :pattern ((has_type x (SINT bits)))
   :qid prelude_unbox_sint
   :skolemid skolem_prelude_unbox_sint
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (FLOAT bits))
    (uInv bits (%I x))
   )
   :pattern ((has_type x (FLOAT bits)))
   :qid prelude_unbox_sint
   :skolemid skolem_prelude_unbox_sint
)))
(declare-fun Add (Int Int) Int)
(declare-fun Sub (Int Int) Int)
(declare-fun Mul (Int Int) Int)
(declare-fun EucDiv (Int Int) Int)
(declare-fun EucMod (Int Int) Int)
(declare-fun RAdd (Real Real) Real)
(declare-fun RSub (Real Real) Real)
(declare-fun RMul (Real Real) Real)
(declare-fun RDiv (Real Real) Real)
(assert
 (forall ((x Int) (y Int)) (!
   (= (Add x y) (+ x y))
   :pattern ((Add x y))
   :qid prelude_add
   :skolemid skolem_prelude_add
)))
(assert
 (forall ((x Int) (y Int)) (!
   (= (Sub x y) (- x y))
   :pattern ((Sub x y))
   :qid prelude_sub
   :skolemid skolem_prelude_sub
)))
(assert
 (forall ((x Int) (y Int)) (!
   (= (Mul x y) (* x y))
   :pattern ((Mul x y))
   :qid prelude_mul
   :skolemid skolem_prelude_mul
)))
(assert
 (forall ((x Int) (y Int)) (!
   (= (EucDiv x y) (div x y))
   :pattern ((EucDiv x y))
   :qid prelude_eucdiv
   :skolemid skolem_prelude_eucdiv
)))
(assert
 (forall ((x Int) (y Int)) (!
   (= (EucMod x y) (mod x y))
   :pattern ((EucMod x y))
   :qid prelude_eucmod
   :skolemid skolem_prelude_eucmod
)))
(assert
 (forall ((x Real) (y Real)) (!
   (= (RAdd x y) (+ x y))
   :pattern ((RAdd x y))
   :qid prelude_radd
   :skolemid skolem_prelude_radd
)))
(assert
 (forall ((x Real) (y Real)) (!
   (= (RSub x y) (- x y))
   :pattern ((RSub x y))
   :qid prelude_rsub
   :skolemid skolem_prelude_rsub
)))
(assert
 (forall ((x Real) (y Real)) (!
   (= (RMul x y) (* x y))
   :pattern ((RMul x y))
   :qid prelude_rmul
   :skolemid skolem_prelude_rmul
)))
(assert
 (forall ((x Real) (y Real)) (!
   (= (RDiv x y) (/ x y))
   :pattern ((RDiv x y))
   :qid prelude_rdiv
   :skolemid skolem_prelude_rdiv
)))
(assert
 (forall ((x Int) (y Int)) (!
   (=>
    (and
     (<= 0 x)
     (<= 0 y)
    )
    (<= 0 (Mul x y))
   )
   :pattern ((Mul x y))
   :qid prelude_mul_nats
   :skolemid skolem_prelude_mul_nats
)))
(assert
 (forall ((x Int) (y Int)) (!
   (=>
    (and
     (<= 0 x)
     (< 0 y)
    )
    (and
     (<= 0 (EucDiv x y))
     (<= (EucDiv x y) x)
   ))
   :pattern ((EucDiv x y))
   :qid prelude_div_unsigned_in_bounds
   :skolemid skolem_prelude_div_unsigned_in_bounds
)))
(assert
 (forall ((x Int) (y Int)) (!
   (=>
    (and
     (<= 0 x)
     (< 0 y)
    )
    (and
     (<= 0 (EucMod x y))
     (< (EucMod x y) y)
   ))
   :pattern ((EucMod x y))
   :qid prelude_mod_unsigned_in_bounds
   :skolemid skolem_prelude_mod_unsigned_in_bounds
)))
(declare-fun bitxor (Poly Poly) Int)
(declare-fun bitand (Poly Poly) Int)
(declare-fun bitor (Poly Poly) Int)
(declare-fun bitshr (Poly Poly) Int)
(declare-fun bitshl (Poly Poly) Int)
(declare-fun bitnot (Poly) Int)
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (uInv bits (%I x))
     (uInv bits (%I y))
    )
    (uInv bits (bitxor x y))
   )
   :pattern ((uClip bits (bitxor x y)))
   :qid prelude_bit_xor_u_inv
   :skolemid skolem_prelude_bit_xor_u_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (iInv bits (%I x))
     (iInv bits (%I y))
    )
    (iInv bits (bitxor x y))
   )
   :pattern ((iClip bits (bitxor x y)))
   :qid prelude_bit_xor_i_inv
   :skolemid skolem_prelude_bit_xor_i_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (uInv bits (%I x))
     (uInv bits (%I y))
    )
    (uInv bits (bitor x y))
   )
   :pattern ((uClip bits (bitor x y)))
   :qid prelude_bit_or_u_inv
   :skolemid skolem_prelude_bit_or_u_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (iInv bits (%I x))
     (iInv bits (%I y))
    )
    (iInv bits (bitor x y))
   )
   :pattern ((iClip bits (bitor x y)))
   :qid prelude_bit_or_i_inv
   :skolemid skolem_prelude_bit_or_i_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (uInv bits (%I x))
     (uInv bits (%I y))
    )
    (uInv bits (bitand x y))
   )
   :pattern ((uClip bits (bitand x y)))
   :qid prelude_bit_and_u_inv
   :skolemid skolem_prelude_bit_and_u_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (iInv bits (%I x))
     (iInv bits (%I y))
    )
    (iInv bits (bitand x y))
   )
   :pattern ((iClip bits (bitand x y)))
   :qid prelude_bit_and_i_inv
   :skolemid skolem_prelude_bit_and_i_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (uInv bits (%I x))
     (<= 0 (%I y))
    )
    (uInv bits (bitshr x y))
   )
   :pattern ((uClip bits (bitshr x y)))
   :qid prelude_bit_shr_u_inv
   :skolemid skolem_prelude_bit_shr_u_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (iInv bits (%I x))
     (<= 0 (%I y))
    )
    (iInv bits (bitshr x y))
   )
   :pattern ((iClip bits (bitshr x y)))
   :qid prelude_bit_shr_i_inv
   :skolemid skolem_prelude_bit_shr_i_inv
)))
(declare-fun singular_mod (Int Int) Int)
(assert
 (forall ((x Int) (y Int)) (!
   (=>
    (not (= y 0))
    (= (EucMod x y) (singular_mod x y))
   )
   :pattern ((singular_mod x y))
   :qid prelude_singularmod
   :skolemid skolem_prelude_singularmod
)))
(declare-fun has_resolved (Dcr Type Poly) Bool)
(declare-fun closure_req (Type Dcr Type Poly Poly) Bool)
(declare-fun closure_ens (Type Dcr Type Poly Poly Poly) Bool)
(declare-fun default_ens (Type Dcr Type Poly Poly Poly) Bool)
(declare-fun height (Poly) Height)
(declare-fun height_lt (Height Height) Bool)
(declare-fun fun_from_recursive_field (Poly) Poly)
(declare-fun check_decrease_int (Int Int Bool) Bool)
(assert
 (forall ((cur Int) (prev Int) (otherwise Bool)) (!
   (= (check_decrease_int cur prev otherwise) (or
     (and
      (<= 0 cur)
      (< cur prev)
     )
     (and
      (= cur prev)
      otherwise
   )))
   :pattern ((check_decrease_int cur prev otherwise))
   :qid prelude_check_decrease_int
   :skolemid skolem_prelude_check_decrease_int
)))
(declare-fun check_decrease_height (Poly Poly Bool) Bool)
(assert
 (forall ((cur Poly) (prev Poly) (otherwise Bool)) (!
   (= (check_decrease_height cur prev otherwise) (or
     (height_lt (height cur) (height prev))
     (and
      (= (height cur) (height prev))
      otherwise
   )))
   :pattern ((check_decrease_height cur prev otherwise))
   :qid prelude_check_decrease_height
   :skolemid skolem_prelude_check_decrease_height
)))
(assert
 (forall ((x Height) (y Height)) (!
   (= (height_lt x y) (and
     ((_ partial-order 0) x y)
     (not (= x y))
   ))
   :pattern ((height_lt x y))
   :qid prelude_height_lt
   :skolemid skolem_prelude_height_lt
)))

;; MODULE 'module lemmas::edwards_lemmas::pippenger_lemmas'
;; curve25519-dalek/src/lemmas/edwards_lemmas/pippenger_lemmas.rs:344:1: 344:98 (#0)

;; query spun off because: spinoff_all

;; Fuel
(declare-const fuel%vstd!array.array_view. FuelId)
(declare-const fuel%vstd!array.impl&%0.view. FuelId)
(declare-const fuel%vstd!array.impl&%2.spec_index. FuelId)
(declare-const fuel%vstd!array.lemma_array_index. FuelId)
(declare-const fuel%vstd!array.array_len_matches_n. FuelId)
(declare-const fuel%vstd!array.axiom_array_ext_equal. FuelId)
(declare-const fuel%vstd!array.axiom_array_has_resolved. FuelId)
(declare-const fuel%vstd!raw_ptr.impl&%3.view. FuelId)
(declare-const fuel%vstd!raw_ptr.ptrs_mut_eq. FuelId)
(declare-const fuel%vstd!raw_ptr.ptrs_mut_eq_sized. FuelId)
(declare-const fuel%vstd!seq.impl&%0.spec_index. FuelId)
(declare-const fuel%vstd!seq.impl&%0.take. FuelId)
(declare-const fuel%vstd!seq.impl&%0.skip. FuelId)
(declare-const fuel%vstd!seq.Seq.last. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_index_decreases. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_subrange_decreases. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_empty. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_new_len. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_new_index. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_push_len. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_push_index_same. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_push_index_different. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_ext_equal. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_ext_equal_deep. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_subrange_len. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_subrange_index. FuelId)
(declare-const fuel%vstd!seq.lemma_seq_two_subranges_index. FuelId)
(declare-const fuel%vstd!seq_lib.impl&%0.drop_last. FuelId)
(declare-const fuel%vstd!slice.impl&%2.spec_index. FuelId)
(declare-const fuel%vstd!slice.axiom_spec_len. FuelId)
(declare-const fuel%vstd!slice.axiom_slice_ext_equal. FuelId)
(declare-const fuel%vstd!slice.axiom_slice_has_resolved. FuelId)
(declare-const fuel%vstd!view.impl&%0.view. FuelId)
(declare-const fuel%vstd!view.impl&%2.view. FuelId)
(declare-const fuel%vstd!view.impl&%4.view. FuelId)
(declare-const fuel%vstd!view.impl&%6.view. FuelId)
(declare-const fuel%vstd!view.impl&%12.view. FuelId)
(declare-const fuel%vstd!view.impl&%14.view. FuelId)
(declare-const fuel%vstd!view.impl&%16.view. FuelId)
(declare-const fuel%vstd!view.impl&%22.view. FuelId)
(declare-const fuel%vstd!view.impl&%26.view. FuelId)
(declare-const fuel%vstd!view.impl&%28.view. FuelId)
(declare-const fuel%vstd!view.impl&%44.view. FuelId)
(declare-const fuel%vstd!view.impl&%48.view. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.constants.EDWARDS_D. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.sp_points_affine.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.sp_digits_seqs.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.sp_digit_count.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_input_valid.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_bucket_contents.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_bucket_sum.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_intermediate_sum.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_running_sum.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_horner.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_from.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_identity. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_valid_edwards_point. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_add. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_double. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_neg. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_sub. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.u64_5_bounded. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.fe51_limbs_bounded. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.fe51_as_canonical_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_add. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_sub. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_mul. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_neg. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_square. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_inv. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.p. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.field_canonical. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar_specs.scalar_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar_specs.is_valid_radix_2w. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w_from.
 FuelId
)
(declare-const fuel%vstd!array.group_array_axioms. FuelId)
(declare-const fuel%vstd!function.group_function_axioms. FuelId)
(declare-const fuel%vstd!laws_cmp.group_laws_cmp. FuelId)
(declare-const fuel%vstd!laws_eq.bool_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.u8_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.i8_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.u16_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.i16_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.u32_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.i32_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.u64_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.i64_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.u128_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.i128_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.usize_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.isize_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.group_laws_eq. FuelId)
(declare-const fuel%vstd!layout.group_layout_axioms. FuelId)
(declare-const fuel%vstd!map.group_map_axioms. FuelId)
(declare-const fuel%vstd!multiset.group_multiset_axioms. FuelId)
(declare-const fuel%vstd!raw_ptr.group_raw_ptr_axioms. FuelId)
(declare-const fuel%vstd!seq.group_seq_axioms. FuelId)
(declare-const fuel%vstd!seq_lib.group_filter_ensures. FuelId)
(declare-const fuel%vstd!seq_lib.group_seq_lib_default. FuelId)
(declare-const fuel%vstd!set.group_set_axioms. FuelId)
(declare-const fuel%vstd!set_lib.group_set_lib_default. FuelId)
(declare-const fuel%vstd!slice.group_slice_axioms. FuelId)
(declare-const fuel%vstd!string.group_string_axioms. FuelId)
(declare-const fuel%vstd!std_specs.bits.group_bits_axioms. FuelId)
(declare-const fuel%vstd!std_specs.control_flow.group_control_flow_axioms. FuelId)
(declare-const fuel%vstd!std_specs.manually_drop.group_manually_drop_axioms. FuelId)
(declare-const fuel%vstd!std_specs.hash.group_hash_axioms. FuelId)
(declare-const fuel%vstd!std_specs.range.group_range_axioms. FuelId)
(declare-const fuel%vstd!std_specs.slice.group_slice_axioms. FuelId)
(declare-const fuel%vstd!std_specs.vec.group_vec_axioms. FuelId)
(declare-const fuel%vstd!std_specs.vecdeque.group_vec_dequeue_axioms. FuelId)
(declare-const fuel%vstd!group_vstd_default. FuelId)
(assert
 (distinct fuel%vstd!array.array_view. fuel%vstd!array.impl&%0.view. fuel%vstd!array.impl&%2.spec_index.
  fuel%vstd!array.lemma_array_index. fuel%vstd!array.array_len_matches_n. fuel%vstd!array.axiom_array_ext_equal.
  fuel%vstd!array.axiom_array_has_resolved. fuel%vstd!raw_ptr.impl&%3.view. fuel%vstd!raw_ptr.ptrs_mut_eq.
  fuel%vstd!raw_ptr.ptrs_mut_eq_sized. fuel%vstd!seq.impl&%0.spec_index. fuel%vstd!seq.impl&%0.take.
  fuel%vstd!seq.impl&%0.skip. fuel%vstd!seq.Seq.last. fuel%vstd!seq.axiom_seq_index_decreases.
  fuel%vstd!seq.axiom_seq_subrange_decreases. fuel%vstd!seq.axiom_seq_empty. fuel%vstd!seq.axiom_seq_new_len.
  fuel%vstd!seq.axiom_seq_new_index. fuel%vstd!seq.axiom_seq_push_len. fuel%vstd!seq.axiom_seq_push_index_same.
  fuel%vstd!seq.axiom_seq_push_index_different. fuel%vstd!seq.axiom_seq_ext_equal.
  fuel%vstd!seq.axiom_seq_ext_equal_deep. fuel%vstd!seq.axiom_seq_subrange_len. fuel%vstd!seq.axiom_seq_subrange_index.
  fuel%vstd!seq.lemma_seq_two_subranges_index. fuel%vstd!seq_lib.impl&%0.drop_last.
  fuel%vstd!slice.impl&%2.spec_index. fuel%vstd!slice.axiom_spec_len. fuel%vstd!slice.axiom_slice_ext_equal.
  fuel%vstd!slice.axiom_slice_has_resolved. fuel%vstd!view.impl&%0.view. fuel%vstd!view.impl&%2.view.
  fuel%vstd!view.impl&%4.view. fuel%vstd!view.impl&%6.view. fuel%vstd!view.impl&%12.view.
  fuel%vstd!view.impl&%14.view. fuel%vstd!view.impl&%16.view. fuel%vstd!view.impl&%22.view.
  fuel%vstd!view.impl&%26.view. fuel%vstd!view.impl&%28.view. fuel%vstd!view.impl&%44.view.
  fuel%vstd!view.impl&%48.view. fuel%curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.
  fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd. fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.
  fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.
  fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.sp_points_affine. fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.sp_digits_seqs.
  fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.sp_digit_count. fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_input_valid.
  fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_bucket_contents.
  fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_bucket_sum.
  fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_intermediate_sum.
  fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_running_sum.
  fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_horner. fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_from.
  fuel%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum. fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat.
  fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective. fuel%curve25519_dalek!specs.edwards_specs.edwards_identity.
  fuel%curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point. fuel%curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.
  fuel%curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded. fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.
  fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_affine. fuel%curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.
  fuel%curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point. fuel%curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.
  fuel%curve25519_dalek!specs.edwards_specs.edwards_add. fuel%curve25519_dalek!specs.edwards_specs.edwards_double.
  fuel%curve25519_dalek!specs.edwards_specs.edwards_neg. fuel%curve25519_dalek!specs.edwards_specs.edwards_sub.
  fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul. fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.
  fuel%curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls. fuel%curve25519_dalek!specs.field_specs.u64_5_bounded.
  fuel%curve25519_dalek!specs.field_specs.fe51_limbs_bounded. fuel%curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.
  fuel%curve25519_dalek!specs.field_specs.field_add. fuel%curve25519_dalek!specs.field_specs.field_sub.
  fuel%curve25519_dalek!specs.field_specs.field_mul. fuel%curve25519_dalek!specs.field_specs.field_neg.
  fuel%curve25519_dalek!specs.field_specs.field_square. fuel%curve25519_dalek!specs.field_specs.field_inv.
  fuel%curve25519_dalek!specs.field_specs_u64.p. fuel%curve25519_dalek!specs.field_specs_u64.field_canonical.
  fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical. fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.
  fuel%curve25519_dalek!specs.scalar_specs.scalar_as_nat. fuel%curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w.
  fuel%curve25519_dalek!specs.scalar_specs.is_valid_radix_2w. fuel%curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w_from.
  fuel%vstd!array.group_array_axioms. fuel%vstd!function.group_function_axioms. fuel%vstd!laws_cmp.group_laws_cmp.
  fuel%vstd!laws_eq.bool_laws.group_laws_eq. fuel%vstd!laws_eq.u8_laws.group_laws_eq.
  fuel%vstd!laws_eq.i8_laws.group_laws_eq. fuel%vstd!laws_eq.u16_laws.group_laws_eq.
  fuel%vstd!laws_eq.i16_laws.group_laws_eq. fuel%vstd!laws_eq.u32_laws.group_laws_eq.
  fuel%vstd!laws_eq.i32_laws.group_laws_eq. fuel%vstd!laws_eq.u64_laws.group_laws_eq.
  fuel%vstd!laws_eq.i64_laws.group_laws_eq. fuel%vstd!laws_eq.u128_laws.group_laws_eq.
  fuel%vstd!laws_eq.i128_laws.group_laws_eq. fuel%vstd!laws_eq.usize_laws.group_laws_eq.
  fuel%vstd!laws_eq.isize_laws.group_laws_eq. fuel%vstd!laws_eq.group_laws_eq. fuel%vstd!layout.group_layout_axioms.
  fuel%vstd!map.group_map_axioms. fuel%vstd!multiset.group_multiset_axioms. fuel%vstd!raw_ptr.group_raw_ptr_axioms.
  fuel%vstd!seq.group_seq_axioms. fuel%vstd!seq_lib.group_filter_ensures. fuel%vstd!seq_lib.group_seq_lib_default.
  fuel%vstd!set.group_set_axioms. fuel%vstd!set_lib.group_set_lib_default. fuel%vstd!slice.group_slice_axioms.
  fuel%vstd!string.group_string_axioms. fuel%vstd!std_specs.bits.group_bits_axioms.
  fuel%vstd!std_specs.control_flow.group_control_flow_axioms. fuel%vstd!std_specs.manually_drop.group_manually_drop_axioms.
  fuel%vstd!std_specs.hash.group_hash_axioms. fuel%vstd!std_specs.range.group_range_axioms.
  fuel%vstd!std_specs.slice.group_slice_axioms. fuel%vstd!std_specs.vec.group_vec_axioms.
  fuel%vstd!std_specs.vecdeque.group_vec_dequeue_axioms. fuel%vstd!group_vstd_default.
))
(assert
 (=>
  (fuel_bool_default fuel%vstd!array.group_array_axioms.)
  (and
   (fuel_bool_default fuel%vstd!array.array_len_matches_n.)
   (fuel_bool_default fuel%vstd!array.lemma_array_index.)
   (fuel_bool_default fuel%vstd!array.axiom_array_ext_equal.)
   (fuel_bool_default fuel%vstd!array.axiom_array_has_resolved.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!laws_eq.group_laws_eq.)
  (and
   (fuel_bool_default fuel%vstd!laws_eq.bool_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.u8_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.i8_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.u16_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.i16_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.u32_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.i32_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.u64_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.i64_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.u128_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.i128_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.usize_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.isize_laws.group_laws_eq.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!raw_ptr.group_raw_ptr_axioms.)
  (and
   (fuel_bool_default fuel%vstd!raw_ptr.ptrs_mut_eq.)
   (fuel_bool_default fuel%vstd!raw_ptr.ptrs_mut_eq_sized.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!seq.group_seq_axioms.)
  (and
   (fuel_bool_default fuel%vstd!seq.axiom_seq_index_decreases.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_subrange_decreases.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_empty.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_new_len.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_new_index.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_push_len.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_push_index_same.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_push_index_different.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_ext_equal.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_ext_equal_deep.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_subrange_len.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_subrange_index.)
   (fuel_bool_default fuel%vstd!seq.lemma_seq_two_subranges_index.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!seq_lib.group_seq_lib_default.)
  (fuel_bool_default fuel%vstd!seq_lib.group_filter_ensures.)
))
(assert
 (=>
  (fuel_bool_default fuel%vstd!slice.group_slice_axioms.)
  (and
   (fuel_bool_default fuel%vstd!slice.axiom_spec_len.)
   (fuel_bool_default fuel%vstd!slice.axiom_slice_ext_equal.)
   (fuel_bool_default fuel%vstd!slice.axiom_slice_has_resolved.)
)))
(assert
 (fuel_bool_default fuel%vstd!group_vstd_default.)
)
(assert
 (=>
  (fuel_bool_default fuel%vstd!group_vstd_default.)
  (and
   (fuel_bool_default fuel%vstd!seq.group_seq_axioms.)
   (fuel_bool_default fuel%vstd!seq_lib.group_seq_lib_default.)
   (fuel_bool_default fuel%vstd!map.group_map_axioms.)
   (fuel_bool_default fuel%vstd!set.group_set_axioms.)
   (fuel_bool_default fuel%vstd!set_lib.group_set_lib_default.)
   (fuel_bool_default fuel%vstd!multiset.group_multiset_axioms.)
   (fuel_bool_default fuel%vstd!function.group_function_axioms.)
   (fuel_bool_default fuel%vstd!laws_eq.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_cmp.group_laws_cmp.)
   (fuel_bool_default fuel%vstd!slice.group_slice_axioms.)
   (fuel_bool_default fuel%vstd!array.group_array_axioms.)
   (fuel_bool_default fuel%vstd!string.group_string_axioms.)
   (fuel_bool_default fuel%vstd!raw_ptr.group_raw_ptr_axioms.)
   (fuel_bool_default fuel%vstd!layout.group_layout_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.range.group_range_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.bits.group_bits_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.control_flow.group_control_flow_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.slice.group_slice_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.manually_drop.group_manually_drop_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.vec.group_vec_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.vecdeque.group_vec_dequeue_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.hash.group_hash_axioms.)
)))

;; Trait-Decls
(declare-fun tr_bound%vstd!array.ArrayAdditionalSpecFns. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%vstd!slice.SliceAdditionalSpecFns. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%vstd!view.View. (Dcr Type) Bool)

;; Associated-Type-Decls
(declare-fun proj%%vstd!view.View./V (Dcr Type) Dcr)
(declare-fun proj%vstd!view.View./V (Dcr Type) Type)

;; Datatypes
(declare-fun pointee_metadata% (Dcr) Type)
(declare-fun pointee_metadata%% (Dcr) Dcr)
(assert
 (forall ((d Dcr)) (!
   (=>
    (sized d)
    (= (pointee_metadata% d) TYPE%tuple%0.)
   )
   :pattern ((pointee_metadata% d))
   :qid prelude_project_pointee_metadata_sized
   :skolemid skolem_prelude_project_pointee_metadata_sized
)))
(assert
 (forall ((d Dcr)) (!
   (=>
    (sized d)
    (= (pointee_metadata%% d) $)
   )
   :pattern ((pointee_metadata%% d))
   :qid prelude_project_pointee_metadata_decoration_sized
   :skolemid skolem_prelude_project_pointee_metadata_decoration_sized
)))
(assert
 (= (pointee_metadata% $slice) USIZE)
)
(assert
 (= (pointee_metadata%% $slice) $)
)
(assert
 (forall ((d Dcr)) (!
   (= (pointee_metadata% (DST d)) (pointee_metadata% d))
   :pattern ((pointee_metadata% (DST d)))
   :qid prelude_project_pointee_metadata_decorate_struct_inherit
   :skolemid skolem_prelude_project_pointee_metadata_decorate_struct_inherit
)))
(assert
 (forall ((d Dcr)) (!
   (= (pointee_metadata%% (DST d)) (pointee_metadata%% d))
   :pattern ((pointee_metadata%% (DST d)))
   :qid prelude_project_pointee_metadata_decoration_decorate_struct_inherit
   :skolemid skolem_prelude_project_pointee_metadata_decoration_decorate_struct_inherit
)))
(declare-sort vstd!raw_ptr.Provenance. 0)
(declare-sort vstd!seq.Seq<i8.>. 0)
(declare-sort vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>. 0)
(declare-sort vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>. 0)
(declare-sort vstd!seq.Seq<vstd!seq.Seq<i8.>.>. 0)
(declare-sort vstd!seq.Seq<tuple%2<nat./nat.>.>. 0)
(declare-sort allocator_global%. 0)
(declare-datatypes ((vstd!raw_ptr.PtrData. 0) (curve25519_dalek!backend.serial.u64.field.FieldElement51.
   0
  ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. 0) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
   0
  ) (curve25519_dalek!scalar.Scalar. 0) (curve25519_dalek!edwards.EdwardsPoint. 0)
  (tuple%0. 0) (tuple%2. 0) (tuple%4. 0)
 ) (((vstd!raw_ptr.PtrData./PtrData (vstd!raw_ptr.PtrData./PtrData/?addr Int) (vstd!raw_ptr.PtrData./PtrData/?provenance
     vstd!raw_ptr.Provenance.
    ) (vstd!raw_ptr.PtrData./PtrData/?metadata Poly)
   )
  ) ((curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/?limbs
     %%Function%%
   ))
  ) ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult
    (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/?gcd
     Int
    ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/?x
     Int
    ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/?y
     Int
   ))
  ) ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint
    (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/?Y_plus_X
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/?Y_minus_X
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/?Z
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/?T2d
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
  ) ((curve25519_dalek!scalar.Scalar./Scalar (curve25519_dalek!scalar.Scalar./Scalar/?bytes
     %%Function%%
   ))
  ) ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?X
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?Y curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?Z curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?T curve25519_dalek!backend.serial.u64.field.FieldElement51.)
   )
  ) ((tuple%0./tuple%0)) ((tuple%2./tuple%2 (tuple%2./tuple%2/?0 Poly) (tuple%2./tuple%2/?1
     Poly
   ))
  ) ((tuple%4./tuple%4 (tuple%4./tuple%4/?0 Poly) (tuple%4./tuple%4/?1 Poly) (tuple%4./tuple%4/?2
     Poly
    ) (tuple%4./tuple%4/?3 Poly)
))))
(declare-fun vstd!raw_ptr.PtrData./PtrData/addr (vstd!raw_ptr.PtrData.) Int)
(declare-fun vstd!raw_ptr.PtrData./PtrData/provenance (vstd!raw_ptr.PtrData.) vstd!raw_ptr.Provenance.)
(declare-fun vstd!raw_ptr.PtrData./PtrData/metadata (vstd!raw_ptr.PtrData.) Poly)
(declare-fun curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
 (curve25519_dalek!backend.serial.u64.field.FieldElement51.) %%Function%%
)
(declare-fun curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd
 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.) Int
)
(declare-fun curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/x
 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.) Int
)
(declare-fun curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/y
 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.) Int
)
(declare-fun curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!scalar.Scalar./Scalar/bytes (curve25519_dalek!scalar.Scalar.)
 %%Function%%
)
(declare-fun curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X (curve25519_dalek!edwards.EdwardsPoint.)
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y (curve25519_dalek!edwards.EdwardsPoint.)
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z (curve25519_dalek!edwards.EdwardsPoint.)
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T (curve25519_dalek!edwards.EdwardsPoint.)
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun tuple%2./tuple%2/0 (tuple%2.) Poly)
(declare-fun tuple%2./tuple%2/1 (tuple%2.) Poly)
(declare-fun tuple%4./tuple%4/0 (tuple%4.) Poly)
(declare-fun tuple%4./tuple%4/1 (tuple%4.) Poly)
(declare-fun tuple%4./tuple%4/2 (tuple%4.) Poly)
(declare-fun tuple%4./tuple%4/3 (tuple%4.) Poly)
(declare-fun TYPE%fun%1. (Dcr Type Dcr Type) Type)
(declare-const TYPE%vstd!raw_ptr.Provenance. Type)
(declare-fun TYPE%vstd!raw_ptr.PtrData. (Dcr Type) Type)
(declare-fun TYPE%vstd!seq.Seq. (Dcr Type) Type)
(declare-const TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. Type)
(declare-const TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
 Type
)
(declare-const TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
 Type
)
(declare-const TYPE%curve25519_dalek!scalar.Scalar. Type)
(declare-const TYPE%curve25519_dalek!edwards.EdwardsPoint. Type)
(declare-fun TYPE%tuple%2. (Dcr Type Dcr Type) Type)
(declare-fun TYPE%tuple%4. (Dcr Type Dcr Type Dcr Type Dcr Type) Type)
(declare-fun Poly%fun%1. (%%Function%%) Poly)
(declare-fun %Poly%fun%1. (Poly) %%Function%%)
(declare-fun Poly%array%. (%%Function%%) Poly)
(declare-fun %Poly%array%. (Poly) %%Function%%)
(declare-fun Poly%vstd!raw_ptr.Provenance. (vstd!raw_ptr.Provenance.) Poly)
(declare-fun %Poly%vstd!raw_ptr.Provenance. (Poly) vstd!raw_ptr.Provenance.)
(declare-fun Poly%vstd!seq.Seq<i8.>. (vstd!seq.Seq<i8.>.) Poly)
(declare-fun %Poly%vstd!seq.Seq<i8.>. (Poly) vstd!seq.Seq<i8.>.)
(declare-fun Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>. (vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.)
 Poly
)
(declare-fun %Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>. (Poly) vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.)
(declare-fun Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>. (vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>.)
 Poly
)
(declare-fun %Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>. (Poly) vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>.)
(declare-fun Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. (vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)
 Poly
)
(declare-fun %Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. (Poly) vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)
(declare-fun Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. (vstd!seq.Seq<tuple%2<nat./nat.>.>.)
 Poly
)
(declare-fun %Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. (Poly) vstd!seq.Seq<tuple%2<nat./nat.>.>.)
(declare-fun Poly%allocator_global%. (allocator_global%.) Poly)
(declare-fun %Poly%allocator_global%. (Poly) allocator_global%.)
(declare-fun Poly%vstd!raw_ptr.PtrData. (vstd!raw_ptr.PtrData.) Poly)
(declare-fun %Poly%vstd!raw_ptr.PtrData. (Poly) vstd!raw_ptr.PtrData.)
(declare-fun Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.u64.field.FieldElement51.)
 Poly
)
(declare-fun %Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly)
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.) Poly
)
(declare-fun %Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
 (Poly) curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
)
(declare-fun Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.) Poly
)
(declare-fun %Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
 (Poly) curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
)
(declare-fun Poly%curve25519_dalek!scalar.Scalar. (curve25519_dalek!scalar.Scalar.)
 Poly
)
(declare-fun %Poly%curve25519_dalek!scalar.Scalar. (Poly) curve25519_dalek!scalar.Scalar.)
(declare-fun Poly%curve25519_dalek!edwards.EdwardsPoint. (curve25519_dalek!edwards.EdwardsPoint.)
 Poly
)
(declare-fun %Poly%curve25519_dalek!edwards.EdwardsPoint. (Poly) curve25519_dalek!edwards.EdwardsPoint.)
(declare-fun Poly%tuple%0. (tuple%0.) Poly)
(declare-fun %Poly%tuple%0. (Poly) tuple%0.)
(declare-fun Poly%tuple%2. (tuple%2.) Poly)
(declare-fun %Poly%tuple%2. (Poly) tuple%2.)
(declare-fun Poly%tuple%4. (tuple%4.) Poly)
(declare-fun %Poly%tuple%4. (Poly) tuple%4.)
(assert
 (forall ((x %%Function%%)) (!
   (= x (%Poly%fun%1. (Poly%fun%1. x)))
   :pattern ((Poly%fun%1. x))
   :qid internal_crate__fun__1_box_axiom_definition
   :skolemid skolem_internal_crate__fun__1_box_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
    (= x (Poly%fun%1. (%Poly%fun%1. x)))
   )
   :pattern ((has_type x (TYPE%fun%1. T%0&. T%0& T%1&. T%1&)))
   :qid internal_crate__fun__1_unbox_axiom_definition
   :skolemid skolem_internal_crate__fun__1_unbox_axiom_definition
)))
(declare-fun %%apply%%0 (%%Function%% Poly) Poly)
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x %%Function%%)) (!
   (=>
    (forall ((T%0 Poly)) (!
      (=>
       (has_type T%0 T%0&)
       (has_type (%%apply%%0 x T%0) T%1&)
      )
      :pattern ((has_type (%%apply%%0 x T%0) T%1&))
      :qid internal_crate__fun__1_constructor_inner_definition
      :skolemid skolem_internal_crate__fun__1_constructor_inner_definition
    ))
    (has_type (Poly%fun%1. (mk_fun x)) (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
   )
   :pattern ((has_type (Poly%fun%1. (mk_fun x)) (TYPE%fun%1. T%0&. T%0& T%1&. T%1&)))
   :qid internal_crate__fun__1_constructor_definition
   :skolemid skolem_internal_crate__fun__1_constructor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%0 Poly) (x %%Function%%))
  (!
   (=>
    (and
     (has_type (Poly%fun%1. x) (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
     (has_type T%0 T%0&)
    )
    (has_type (%%apply%%0 x T%0) T%1&)
   )
   :pattern ((%%apply%%0 x T%0) (has_type (Poly%fun%1. x) (TYPE%fun%1. T%0&. T%0& T%1&.
      T%1&
   )))
   :qid internal_crate__fun__1_apply_definition
   :skolemid skolem_internal_crate__fun__1_apply_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%0 Poly) (x %%Function%%))
  (!
   (=>
    (and
     (has_type (Poly%fun%1. x) (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
     (has_type T%0 T%0&)
    )
    (height_lt (height (%%apply%%0 x T%0)) (height (fun_from_recursive_field (Poly%fun%1.
        (mk_fun x)
   )))))
   :pattern ((height (%%apply%%0 x T%0)) (has_type (Poly%fun%1. x) (TYPE%fun%1. T%0&. T%0&
      T%1&. T%1&
   )))
   :qid internal_crate__fun__1_height_apply_definition
   :skolemid skolem_internal_crate__fun__1_height_apply_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (deep Bool) (x Poly) (y Poly))
  (!
   (=>
    (and
     (has_type x (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
     (has_type y (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
     (forall ((T%0 Poly)) (!
       (=>
        (has_type T%0 T%0&)
        (ext_eq deep T%1& (%%apply%%0 (%Poly%fun%1. x) T%0) (%%apply%%0 (%Poly%fun%1. y) T%0))
       )
       :pattern ((ext_eq deep T%1& (%%apply%%0 (%Poly%fun%1. x) T%0) (%%apply%%0 (%Poly%fun%1.
           y
          ) T%0
       )))
       :qid internal_crate__fun__1_inner_ext_equal_definition
       :skolemid skolem_internal_crate__fun__1_inner_ext_equal_definition
    )))
    (ext_eq deep (TYPE%fun%1. T%0&. T%0& T%1&. T%1&) x y)
   )
   :pattern ((ext_eq deep (TYPE%fun%1. T%0&. T%0& T%1&. T%1&) x y))
   :qid internal_crate__fun__1_ext_equal_definition
   :skolemid skolem_internal_crate__fun__1_ext_equal_definition
)))
(assert
 (forall ((x %%Function%%)) (!
   (= x (%Poly%array%. (Poly%array%. x)))
   :pattern ((Poly%array%. x))
   :qid internal_crate__array___box_axiom_definition
   :skolemid skolem_internal_crate__array___box_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (x Poly)) (!
   (=>
    (has_type x (ARRAY T&. T& N&. N&))
    (= x (Poly%array%. (%Poly%array%. x)))
   )
   :pattern ((has_type x (ARRAY T&. T& N&. N&)))
   :qid internal_crate__array___unbox_axiom_definition
   :skolemid skolem_internal_crate__array___unbox_axiom_definition
)))
(assert
 (forall ((x vstd!raw_ptr.Provenance.)) (!
   (= x (%Poly%vstd!raw_ptr.Provenance. (Poly%vstd!raw_ptr.Provenance. x)))
   :pattern ((Poly%vstd!raw_ptr.Provenance. x))
   :qid internal_vstd__raw_ptr__Provenance_box_axiom_definition
   :skolemid skolem_internal_vstd__raw_ptr__Provenance_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%vstd!raw_ptr.Provenance.)
    (= x (Poly%vstd!raw_ptr.Provenance. (%Poly%vstd!raw_ptr.Provenance. x)))
   )
   :pattern ((has_type x TYPE%vstd!raw_ptr.Provenance.))
   :qid internal_vstd__raw_ptr__Provenance_unbox_axiom_definition
   :skolemid skolem_internal_vstd__raw_ptr__Provenance_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!raw_ptr.Provenance.)) (!
   (has_type (Poly%vstd!raw_ptr.Provenance. x) TYPE%vstd!raw_ptr.Provenance.)
   :pattern ((has_type (Poly%vstd!raw_ptr.Provenance. x) TYPE%vstd!raw_ptr.Provenance.))
   :qid internal_vstd__raw_ptr__Provenance_has_type_always_definition
   :skolemid skolem_internal_vstd__raw_ptr__Provenance_has_type_always_definition
)))
(assert
 (forall ((x vstd!seq.Seq<i8.>.)) (!
   (= x (%Poly%vstd!seq.Seq<i8.>. (Poly%vstd!seq.Seq<i8.>. x)))
   :pattern ((Poly%vstd!seq.Seq<i8.>. x))
   :qid internal_vstd__seq__Seq<i8.>_box_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<i8.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!seq.Seq. $ (SINT 8)))
    (= x (Poly%vstd!seq.Seq<i8.>. (%Poly%vstd!seq.Seq<i8.>. x)))
   )
   :pattern ((has_type x (TYPE%vstd!seq.Seq. $ (SINT 8))))
   :qid internal_vstd__seq__Seq<i8.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<i8.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!seq.Seq<i8.>.)) (!
   (has_type (Poly%vstd!seq.Seq<i8.>. x) (TYPE%vstd!seq.Seq. $ (SINT 8)))
   :pattern ((has_type (Poly%vstd!seq.Seq<i8.>. x) (TYPE%vstd!seq.Seq. $ (SINT 8))))
   :qid internal_vstd__seq__Seq<i8.>_has_type_always_definition
   :skolemid skolem_internal_vstd__seq__Seq<i8.>_has_type_always_definition
)))
(assert
 (forall ((x vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.)) (!
   (= x (%Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>. (Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.
      x
   )))
   :pattern ((Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>. x))
   :qid internal_vstd__seq__Seq<curve25519_dalek!edwards.EdwardsPoint.>_box_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<curve25519_dalek!edwards.EdwardsPoint.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!seq.Seq. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.))
    (= x (Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>. (%Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.
       x
   ))))
   :pattern ((has_type x (TYPE%vstd!seq.Seq. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)))
   :qid internal_vstd__seq__Seq<curve25519_dalek!edwards.EdwardsPoint.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<curve25519_dalek!edwards.EdwardsPoint.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.)) (!
   (has_type (Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>. x) (TYPE%vstd!seq.Seq.
     $ TYPE%curve25519_dalek!edwards.EdwardsPoint.
   ))
   :pattern ((has_type (Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>. x)
     (TYPE%vstd!seq.Seq. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
   ))
   :qid internal_vstd__seq__Seq<curve25519_dalek!edwards.EdwardsPoint.>_has_type_always_definition
   :skolemid skolem_internal_vstd__seq__Seq<curve25519_dalek!edwards.EdwardsPoint.>_has_type_always_definition
)))
(assert
 (forall ((x vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>.)) (!
   (= x (%Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>. (Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>.
      x
   )))
   :pattern ((Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>. x))
   :qid internal_vstd__seq__Seq<curve25519_dalek!scalar.Scalar.>_box_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<curve25519_dalek!scalar.Scalar.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!seq.Seq. $ TYPE%curve25519_dalek!scalar.Scalar.))
    (= x (Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>. (%Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>.
       x
   ))))
   :pattern ((has_type x (TYPE%vstd!seq.Seq. $ TYPE%curve25519_dalek!scalar.Scalar.)))
   :qid internal_vstd__seq__Seq<curve25519_dalek!scalar.Scalar.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<curve25519_dalek!scalar.Scalar.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>.)) (!
   (has_type (Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>. x) (TYPE%vstd!seq.Seq.
     $ TYPE%curve25519_dalek!scalar.Scalar.
   ))
   :pattern ((has_type (Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>. x) (TYPE%vstd!seq.Seq.
      $ TYPE%curve25519_dalek!scalar.Scalar.
   )))
   :qid internal_vstd__seq__Seq<curve25519_dalek!scalar.Scalar.>_has_type_always_definition
   :skolemid skolem_internal_vstd__seq__Seq<curve25519_dalek!scalar.Scalar.>_has_type_always_definition
)))
(assert
 (forall ((x vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)) (!
   (= x (%Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
      x
   )))
   :pattern ((Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. x))
   :qid internal_vstd__seq__Seq<vstd!seq.Seq<i8.>.>_box_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<vstd!seq.Seq<i8.>.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!seq.Seq. $ (TYPE%vstd!seq.Seq. $ (SINT 8))))
    (= x (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. (%Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
       x
   ))))
   :pattern ((has_type x (TYPE%vstd!seq.Seq. $ (TYPE%vstd!seq.Seq. $ (SINT 8)))))
   :qid internal_vstd__seq__Seq<vstd!seq.Seq<i8.>.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<vstd!seq.Seq<i8.>.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)) (!
   (has_type (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. x) (TYPE%vstd!seq.Seq. $ (TYPE%vstd!seq.Seq.
      $ (SINT 8)
   )))
   :pattern ((has_type (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. x) (TYPE%vstd!seq.Seq. $
      (TYPE%vstd!seq.Seq. $ (SINT 8))
   )))
   :qid internal_vstd__seq__Seq<vstd!seq.Seq<i8.>.>_has_type_always_definition
   :skolemid skolem_internal_vstd__seq__Seq<vstd!seq.Seq<i8.>.>_has_type_always_definition
)))
(assert
 (forall ((x vstd!seq.Seq<tuple%2<nat./nat.>.>.)) (!
   (= x (%Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
      x
   )))
   :pattern ((Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. x))
   :qid internal_vstd__seq__Seq<tuple__2<nat./nat.>.>_box_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<tuple__2<nat./nat.>.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
    (= x (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. (%Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
       x
   ))))
   :pattern ((has_type x (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT))))
   :qid internal_vstd__seq__Seq<tuple__2<nat./nat.>.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<tuple__2<nat./nat.>.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!seq.Seq<tuple%2<nat./nat.>.>.)) (!
   (has_type (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. x) (TYPE%vstd!seq.Seq. (DST $) (
      TYPE%tuple%2. $ NAT $ NAT
   )))
   :pattern ((has_type (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. x) (TYPE%vstd!seq.Seq.
      (DST $) (TYPE%tuple%2. $ NAT $ NAT)
   )))
   :qid internal_vstd__seq__Seq<tuple__2<nat./nat.>.>_has_type_always_definition
   :skolemid skolem_internal_vstd__seq__Seq<tuple__2<nat./nat.>.>_has_type_always_definition
)))
(assert
 (forall ((x allocator_global%.)) (!
   (= x (%Poly%allocator_global%. (Poly%allocator_global%. x)))
   :pattern ((Poly%allocator_global%. x))
   :qid internal_crate__allocator_global___box_axiom_definition
   :skolemid skolem_internal_crate__allocator_global___box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x ALLOCATOR_GLOBAL)
    (= x (Poly%allocator_global%. (%Poly%allocator_global%. x)))
   )
   :pattern ((has_type x ALLOCATOR_GLOBAL))
   :qid internal_crate__allocator_global___unbox_axiom_definition
   :skolemid skolem_internal_crate__allocator_global___unbox_axiom_definition
)))
(assert
 (forall ((x allocator_global%.)) (!
   (has_type (Poly%allocator_global%. x) ALLOCATOR_GLOBAL)
   :pattern ((has_type (Poly%allocator_global%. x) ALLOCATOR_GLOBAL))
   :qid internal_crate__allocator_global___has_type_always_definition
   :skolemid skolem_internal_crate__allocator_global___has_type_always_definition
)))
(assert
 (forall ((x vstd!raw_ptr.PtrData.)) (!
   (= x (%Poly%vstd!raw_ptr.PtrData. (Poly%vstd!raw_ptr.PtrData. x)))
   :pattern ((Poly%vstd!raw_ptr.PtrData. x))
   :qid internal_vstd__raw_ptr__PtrData_box_axiom_definition
   :skolemid skolem_internal_vstd__raw_ptr__PtrData_box_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!raw_ptr.PtrData. T&. T&))
    (= x (Poly%vstd!raw_ptr.PtrData. (%Poly%vstd!raw_ptr.PtrData. x)))
   )
   :pattern ((has_type x (TYPE%vstd!raw_ptr.PtrData. T&. T&)))
   :qid internal_vstd__raw_ptr__PtrData_unbox_axiom_definition
   :skolemid skolem_internal_vstd__raw_ptr__PtrData_unbox_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (_addr! Int) (_provenance! vstd!raw_ptr.Provenance.) (
    _metadata! Poly
   )
  ) (!
   (=>
    (and
     (uInv SZ _addr!)
     (has_type _metadata! (pointee_metadata% T&.))
    )
    (has_type (Poly%vstd!raw_ptr.PtrData. (vstd!raw_ptr.PtrData./PtrData _addr! _provenance!
       _metadata!
      )
     ) (TYPE%vstd!raw_ptr.PtrData. T&. T&)
   ))
   :pattern ((has_type (Poly%vstd!raw_ptr.PtrData. (vstd!raw_ptr.PtrData./PtrData _addr!
       _provenance! _metadata!
      )
     ) (TYPE%vstd!raw_ptr.PtrData. T&. T&)
   ))
   :qid internal_vstd!raw_ptr.PtrData./PtrData_constructor_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData_constructor_definition
)))
(assert
 (forall ((x vstd!raw_ptr.PtrData.)) (!
   (= (vstd!raw_ptr.PtrData./PtrData/addr x) (vstd!raw_ptr.PtrData./PtrData/?addr x))
   :pattern ((vstd!raw_ptr.PtrData./PtrData/addr x))
   :qid internal_vstd!raw_ptr.PtrData./PtrData/addr_accessor_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData/addr_accessor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!raw_ptr.PtrData. T&. T&))
    (uInv SZ (vstd!raw_ptr.PtrData./PtrData/addr (%Poly%vstd!raw_ptr.PtrData. x)))
   )
   :pattern ((vstd!raw_ptr.PtrData./PtrData/addr (%Poly%vstd!raw_ptr.PtrData. x)) (has_type
     x (TYPE%vstd!raw_ptr.PtrData. T&. T&)
   ))
   :qid internal_vstd!raw_ptr.PtrData./PtrData/addr_invariant_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData/addr_invariant_definition
)))
(assert
 (forall ((x vstd!raw_ptr.PtrData.)) (!
   (= (vstd!raw_ptr.PtrData./PtrData/provenance x) (vstd!raw_ptr.PtrData./PtrData/?provenance
     x
   ))
   :pattern ((vstd!raw_ptr.PtrData./PtrData/provenance x))
   :qid internal_vstd!raw_ptr.PtrData./PtrData/provenance_accessor_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData/provenance_accessor_definition
)))
(assert
 (forall ((x vstd!raw_ptr.PtrData.)) (!
   (= (vstd!raw_ptr.PtrData./PtrData/metadata x) (vstd!raw_ptr.PtrData./PtrData/?metadata
     x
   ))
   :pattern ((vstd!raw_ptr.PtrData./PtrData/metadata x))
   :qid internal_vstd!raw_ptr.PtrData./PtrData/metadata_accessor_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData/metadata_accessor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!raw_ptr.PtrData. T&. T&))
    (has_type (vstd!raw_ptr.PtrData./PtrData/metadata (%Poly%vstd!raw_ptr.PtrData. x))
     (pointee_metadata% T&.)
   ))
   :pattern ((vstd!raw_ptr.PtrData./PtrData/metadata (%Poly%vstd!raw_ptr.PtrData. x))
    (has_type x (TYPE%vstd!raw_ptr.PtrData. T&. T&))
   )
   :qid internal_vstd!raw_ptr.PtrData./PtrData/metadata_invariant_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData/metadata_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.u64.field.FieldElement51.)) (!
   (= x (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      x
   )))
   :pattern ((Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. x))
   :qid internal_curve25519_dalek__backend__serial__u64__field__FieldElement51_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__u64__field__FieldElement51_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    (= x (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       x
   ))))
   :pattern ((has_type x TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.))
   :qid internal_curve25519_dalek__backend__serial__u64__field__FieldElement51_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__u64__field__FieldElement51_unbox_axiom_definition
)))
(assert
 (forall ((_limbs! %%Function%%)) (!
   (=>
    (has_type (Poly%array%. _limbs!) (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
       _limbs!
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 _limbs!)
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :qid internal_curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.u64.field.FieldElement51.)) (!
   (= (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
     x
    ) (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/?limbs
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    (has_type (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
       (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. x)
      )
     ) (ARRAY $ (UINT 64) $ (CONST_INT 5))
   ))
   :pattern ((curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
     (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
   )
   :qid internal_curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.))
  (!
   (= x (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
     (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. x)
   ))
   :pattern ((Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
     x
   ))
   :qid internal_curve25519_dalek__lemmas__common_lemmas__number_theory_lemmas__ExtGcdResult_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__lemmas__common_lemmas__number_theory_lemmas__ExtGcdResult_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.)
    (= x (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
      (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. x)
   )))
   :pattern ((has_type x TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.))
   :qid internal_curve25519_dalek__lemmas__common_lemmas__number_theory_lemmas__ExtGcdResult_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__lemmas__common_lemmas__number_theory_lemmas__ExtGcdResult_unbox_axiom_definition
)))
(assert
 (forall ((_gcd! Int) (_x! Int) (_y! Int)) (!
   (=>
    (<= 0 _gcd!)
    (has_type (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
      (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult
       _gcd! _x! _y!
      )
     ) TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
      (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult
       _gcd! _x! _y!
      )
     ) TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.))
  (!
   (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd
     x
    ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/?gcd
     x
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd
     x
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.)
    (<= 0 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd
      (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. x)
   )))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd
     (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. x)
    ) (has_type x TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.)
   )
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.))
  (!
   (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/x
     x
    ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/?x
     x
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/x
     x
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/x_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/x_accessor_definition
)))
(assert
 (forall ((x curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.))
  (!
   (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/y
     x
    ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/?y
     x
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/y
     x
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/y_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/y_accessor_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)) (
   !
   (= x (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      x
   )))
   :pattern ((Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
     x
   ))
   :qid internal_curve25519_dalek__backend__serial__curve_models__ProjectiveNielsPoint_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__curve_models__ProjectiveNielsPoint_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
    (= x (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
       x
   ))))
   :pattern ((has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.))
   :qid internal_curve25519_dalek__backend__serial__curve_models__ProjectiveNielsPoint_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__curve_models__ProjectiveNielsPoint_unbox_axiom_definition
)))
(assert
 (forall ((_Y_plus_X! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (_Y_minus_X!
    curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ) (_Z! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (_T2d! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
  ) (!
   (=>
    (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _Y_plus_X!)
      TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
     )
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _Y_minus_X!)
      TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
     )
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _Z!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _T2d!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    )
    (has_type (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint
       _Y_plus_X! _Y_minus_X! _Z! _T2d!
      )
     ) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint
       _Y_plus_X! _Y_minus_X! _Z! _T2d!
      )
     ) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)) (
   !
   (= (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
     x
    ) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/?Y_plus_X
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
       (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
     (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)) (
   !
   (= (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
     x
    ) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/?Y_minus_X
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
       (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
     (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)) (
   !
   (= (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
     x
    ) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/?Z
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
       (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
     (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)) (
   !
   (= (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
     x
    ) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/?T2d
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
       (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
     (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!scalar.Scalar.)) (!
   (= x (%Poly%curve25519_dalek!scalar.Scalar. (Poly%curve25519_dalek!scalar.Scalar. x)))
   :pattern ((Poly%curve25519_dalek!scalar.Scalar. x))
   :qid internal_curve25519_dalek__scalar__Scalar_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__scalar__Scalar_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!scalar.Scalar.)
    (= x (Poly%curve25519_dalek!scalar.Scalar. (%Poly%curve25519_dalek!scalar.Scalar. x)))
   )
   :pattern ((has_type x TYPE%curve25519_dalek!scalar.Scalar.))
   :qid internal_curve25519_dalek__scalar__Scalar_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__scalar__Scalar_unbox_axiom_definition
)))
(assert
 (forall ((_bytes! %%Function%%)) (!
   (=>
    (has_type (Poly%array%. _bytes!) (ARRAY $ (UINT 8) $ (CONST_INT 32)))
    (has_type (Poly%curve25519_dalek!scalar.Scalar. (curve25519_dalek!scalar.Scalar./Scalar
       _bytes!
      )
     ) TYPE%curve25519_dalek!scalar.Scalar.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!scalar.Scalar. (curve25519_dalek!scalar.Scalar./Scalar
       _bytes!
      )
     ) TYPE%curve25519_dalek!scalar.Scalar.
   ))
   :qid internal_curve25519_dalek!scalar.Scalar./Scalar_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!scalar.Scalar./Scalar_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!scalar.Scalar.)) (!
   (= (curve25519_dalek!scalar.Scalar./Scalar/bytes x) (curve25519_dalek!scalar.Scalar./Scalar/?bytes
     x
   ))
   :pattern ((curve25519_dalek!scalar.Scalar./Scalar/bytes x))
   :qid internal_curve25519_dalek!scalar.Scalar./Scalar/bytes_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!scalar.Scalar./Scalar/bytes_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!scalar.Scalar.)
    (has_type (Poly%array%. (curve25519_dalek!scalar.Scalar./Scalar/bytes (%Poly%curve25519_dalek!scalar.Scalar.
        x
      ))
     ) (ARRAY $ (UINT 8) $ (CONST_INT 32))
   ))
   :pattern ((curve25519_dalek!scalar.Scalar./Scalar/bytes (%Poly%curve25519_dalek!scalar.Scalar.
      x
     )
    ) (has_type x TYPE%curve25519_dalek!scalar.Scalar.)
   )
   :qid internal_curve25519_dalek!scalar.Scalar./Scalar/bytes_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!scalar.Scalar./Scalar/bytes_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!edwards.EdwardsPoint.)) (!
   (= x (%Poly%curve25519_dalek!edwards.EdwardsPoint. (Poly%curve25519_dalek!edwards.EdwardsPoint.
      x
   )))
   :pattern ((Poly%curve25519_dalek!edwards.EdwardsPoint. x))
   :qid internal_curve25519_dalek__edwards__EdwardsPoint_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__edwards__EdwardsPoint_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (= x (Poly%curve25519_dalek!edwards.EdwardsPoint. (%Poly%curve25519_dalek!edwards.EdwardsPoint.
       x
   ))))
   :pattern ((has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.))
   :qid internal_curve25519_dalek__edwards__EdwardsPoint_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__edwards__EdwardsPoint_unbox_axiom_definition
)))
(assert
 (forall ((_X! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (_Y! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
   (_Z! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (_T! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
  ) (!
   (=>
    (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _X!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _Y!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _Z!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _T!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    )
    (has_type (Poly%curve25519_dalek!edwards.EdwardsPoint. (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint
       _X! _Y! _Z! _T!
      )
     ) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!edwards.EdwardsPoint. (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint
       _X! _Y! _Z! _T!
      )
     ) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   ))
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!edwards.EdwardsPoint.)) (!
   (= (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X x) (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?X
     x
   ))
   :pattern ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X x))
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X
       (%Poly%curve25519_dalek!edwards.EdwardsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X (%Poly%curve25519_dalek!edwards.EdwardsPoint.
      x
     )
    ) (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
   )
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!edwards.EdwardsPoint.)) (!
   (= (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y x) (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?Y
     x
   ))
   :pattern ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y x))
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y
       (%Poly%curve25519_dalek!edwards.EdwardsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y (%Poly%curve25519_dalek!edwards.EdwardsPoint.
      x
     )
    ) (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
   )
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!edwards.EdwardsPoint.)) (!
   (= (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z x) (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?Z
     x
   ))
   :pattern ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z x))
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z
       (%Poly%curve25519_dalek!edwards.EdwardsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z (%Poly%curve25519_dalek!edwards.EdwardsPoint.
      x
     )
    ) (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
   )
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!edwards.EdwardsPoint.)) (!
   (= (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T x) (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?T
     x
   ))
   :pattern ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T x))
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T
       (%Poly%curve25519_dalek!edwards.EdwardsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T (%Poly%curve25519_dalek!edwards.EdwardsPoint.
      x
     )
    ) (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
   )
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T_invariant_definition
)))
(assert
 (forall ((x tuple%0.)) (!
   (= x (%Poly%tuple%0. (Poly%tuple%0. x)))
   :pattern ((Poly%tuple%0. x))
   :qid internal_crate__tuple__0_box_axiom_definition
   :skolemid skolem_internal_crate__tuple__0_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%tuple%0.)
    (= x (Poly%tuple%0. (%Poly%tuple%0. x)))
   )
   :pattern ((has_type x TYPE%tuple%0.))
   :qid internal_crate__tuple__0_unbox_axiom_definition
   :skolemid skolem_internal_crate__tuple__0_unbox_axiom_definition
)))
(assert
 (forall ((x tuple%0.)) (!
   (has_type (Poly%tuple%0. x) TYPE%tuple%0.)
   :pattern ((has_type (Poly%tuple%0. x) TYPE%tuple%0.))
   :qid internal_crate__tuple__0_has_type_always_definition
   :skolemid skolem_internal_crate__tuple__0_has_type_always_definition
)))
(assert
 (forall ((x tuple%2.)) (!
   (= x (%Poly%tuple%2. (Poly%tuple%2. x)))
   :pattern ((Poly%tuple%2. x))
   :qid internal_crate__tuple__2_box_axiom_definition
   :skolemid skolem_internal_crate__tuple__2_box_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
    (= x (Poly%tuple%2. (%Poly%tuple%2. x)))
   )
   :pattern ((has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&)))
   :qid internal_crate__tuple__2_unbox_axiom_definition
   :skolemid skolem_internal_crate__tuple__2_unbox_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (_0! Poly) (_1! Poly)) (!
   (=>
    (and
     (has_type _0! T%0&)
     (has_type _1! T%1&)
    )
    (has_type (Poly%tuple%2. (tuple%2./tuple%2 _0! _1!)) (TYPE%tuple%2. T%0&. T%0& T%1&.
      T%1&
   )))
   :pattern ((has_type (Poly%tuple%2. (tuple%2./tuple%2 _0! _1!)) (TYPE%tuple%2. T%0&.
      T%0& T%1&. T%1&
   )))
   :qid internal_tuple__2./tuple__2_constructor_definition
   :skolemid skolem_internal_tuple__2./tuple__2_constructor_definition
)))
(assert
 (forall ((x tuple%2.)) (!
   (= (tuple%2./tuple%2/0 x) (tuple%2./tuple%2/?0 x))
   :pattern ((tuple%2./tuple%2/0 x))
   :qid internal_tuple__2./tuple__2/0_accessor_definition
   :skolemid skolem_internal_tuple__2./tuple__2/0_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
    (has_type (tuple%2./tuple%2/0 (%Poly%tuple%2. x)) T%0&)
   )
   :pattern ((tuple%2./tuple%2/0 (%Poly%tuple%2. x)) (has_type x (TYPE%tuple%2. T%0&. T%0&
      T%1&. T%1&
   )))
   :qid internal_tuple__2./tuple__2/0_invariant_definition
   :skolemid skolem_internal_tuple__2./tuple__2/0_invariant_definition
)))
(assert
 (forall ((x tuple%2.)) (!
   (= (tuple%2./tuple%2/1 x) (tuple%2./tuple%2/?1 x))
   :pattern ((tuple%2./tuple%2/1 x))
   :qid internal_tuple__2./tuple__2/1_accessor_definition
   :skolemid skolem_internal_tuple__2./tuple__2/1_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
    (has_type (tuple%2./tuple%2/1 (%Poly%tuple%2. x)) T%1&)
   )
   :pattern ((tuple%2./tuple%2/1 (%Poly%tuple%2. x)) (has_type x (TYPE%tuple%2. T%0&. T%0&
      T%1&. T%1&
   )))
   :qid internal_tuple__2./tuple__2/1_invariant_definition
   :skolemid skolem_internal_tuple__2./tuple__2/1_invariant_definition
)))
(assert
 (forall ((x tuple%2.)) (!
   (=>
    (is-tuple%2./tuple%2 x)
    (height_lt (height (tuple%2./tuple%2/0 x)) (height (Poly%tuple%2. x)))
   )
   :pattern ((height (tuple%2./tuple%2/0 x)))
   :qid prelude_datatype_height_tuple%2./tuple%2/0
   :skolemid skolem_prelude_datatype_height_tuple%2./tuple%2/0
)))
(assert
 (forall ((x tuple%2.)) (!
   (=>
    (is-tuple%2./tuple%2 x)
    (height_lt (height (tuple%2./tuple%2/1 x)) (height (Poly%tuple%2. x)))
   )
   :pattern ((height (tuple%2./tuple%2/1 x)))
   :qid prelude_datatype_height_tuple%2./tuple%2/1
   :skolemid skolem_prelude_datatype_height_tuple%2./tuple%2/1
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (deep Bool) (x Poly) (y Poly))
  (!
   (=>
    (and
     (has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
     (has_type y (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
     (ext_eq deep T%0& (tuple%2./tuple%2/0 (%Poly%tuple%2. x)) (tuple%2./tuple%2/0 (%Poly%tuple%2.
        y
     )))
     (ext_eq deep T%1& (tuple%2./tuple%2/1 (%Poly%tuple%2. x)) (tuple%2./tuple%2/1 (%Poly%tuple%2.
        y
    ))))
    (ext_eq deep (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&) x y)
   )
   :pattern ((ext_eq deep (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&) x y))
   :qid internal_tuple__2./tuple__2_ext_equal_definition
   :skolemid skolem_internal_tuple__2./tuple__2_ext_equal_definition
)))
(assert
 (forall ((x tuple%4.)) (!
   (= x (%Poly%tuple%4. (Poly%tuple%4. x)))
   :pattern ((Poly%tuple%4. x))
   :qid internal_crate__tuple__4_box_axiom_definition
   :skolemid skolem_internal_crate__tuple__4_box_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (T%3&.
    Dcr
   ) (T%3& Type) (x Poly)
  ) (!
   (=>
    (has_type x (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&))
    (= x (Poly%tuple%4. (%Poly%tuple%4. x)))
   )
   :pattern ((has_type x (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&)))
   :qid internal_crate__tuple__4_unbox_axiom_definition
   :skolemid skolem_internal_crate__tuple__4_unbox_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (T%3&.
    Dcr
   ) (T%3& Type) (_0! Poly) (_1! Poly) (_2! Poly) (_3! Poly)
  ) (!
   (=>
    (and
     (has_type _0! T%0&)
     (has_type _1! T%1&)
     (has_type _2! T%2&)
     (has_type _3! T%3&)
    )
    (has_type (Poly%tuple%4. (tuple%4./tuple%4 _0! _1! _2! _3!)) (TYPE%tuple%4. T%0&. T%0&
      T%1&. T%1& T%2&. T%2& T%3&. T%3&
   )))
   :pattern ((has_type (Poly%tuple%4. (tuple%4./tuple%4 _0! _1! _2! _3!)) (TYPE%tuple%4.
      T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&
   )))
   :qid internal_tuple__4./tuple__4_constructor_definition
   :skolemid skolem_internal_tuple__4./tuple__4_constructor_definition
)))
(assert
 (forall ((x tuple%4.)) (!
   (= (tuple%4./tuple%4/0 x) (tuple%4./tuple%4/?0 x))
   :pattern ((tuple%4./tuple%4/0 x))
   :qid internal_tuple__4./tuple__4/0_accessor_definition
   :skolemid skolem_internal_tuple__4./tuple__4/0_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (T%3&.
    Dcr
   ) (T%3& Type) (x Poly)
  ) (!
   (=>
    (has_type x (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&))
    (has_type (tuple%4./tuple%4/0 (%Poly%tuple%4. x)) T%0&)
   )
   :pattern ((tuple%4./tuple%4/0 (%Poly%tuple%4. x)) (has_type x (TYPE%tuple%4. T%0&. T%0&
      T%1&. T%1& T%2&. T%2& T%3&. T%3&
   )))
   :qid internal_tuple__4./tuple__4/0_invariant_definition
   :skolemid skolem_internal_tuple__4./tuple__4/0_invariant_definition
)))
(assert
 (forall ((x tuple%4.)) (!
   (= (tuple%4./tuple%4/1 x) (tuple%4./tuple%4/?1 x))
   :pattern ((tuple%4./tuple%4/1 x))
   :qid internal_tuple__4./tuple__4/1_accessor_definition
   :skolemid skolem_internal_tuple__4./tuple__4/1_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (T%3&.
    Dcr
   ) (T%3& Type) (x Poly)
  ) (!
   (=>
    (has_type x (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&))
    (has_type (tuple%4./tuple%4/1 (%Poly%tuple%4. x)) T%1&)
   )
   :pattern ((tuple%4./tuple%4/1 (%Poly%tuple%4. x)) (has_type x (TYPE%tuple%4. T%0&. T%0&
      T%1&. T%1& T%2&. T%2& T%3&. T%3&
   )))
   :qid internal_tuple__4./tuple__4/1_invariant_definition
   :skolemid skolem_internal_tuple__4./tuple__4/1_invariant_definition
)))
(assert
 (forall ((x tuple%4.)) (!
   (= (tuple%4./tuple%4/2 x) (tuple%4./tuple%4/?2 x))
   :pattern ((tuple%4./tuple%4/2 x))
   :qid internal_tuple__4./tuple__4/2_accessor_definition
   :skolemid skolem_internal_tuple__4./tuple__4/2_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (T%3&.
    Dcr
   ) (T%3& Type) (x Poly)
  ) (!
   (=>
    (has_type x (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&))
    (has_type (tuple%4./tuple%4/2 (%Poly%tuple%4. x)) T%2&)
   )
   :pattern ((tuple%4./tuple%4/2 (%Poly%tuple%4. x)) (has_type x (TYPE%tuple%4. T%0&. T%0&
      T%1&. T%1& T%2&. T%2& T%3&. T%3&
   )))
   :qid internal_tuple__4./tuple__4/2_invariant_definition
   :skolemid skolem_internal_tuple__4./tuple__4/2_invariant_definition
)))
(assert
 (forall ((x tuple%4.)) (!
   (= (tuple%4./tuple%4/3 x) (tuple%4./tuple%4/?3 x))
   :pattern ((tuple%4./tuple%4/3 x))
   :qid internal_tuple__4./tuple__4/3_accessor_definition
   :skolemid skolem_internal_tuple__4./tuple__4/3_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (T%3&.
    Dcr
   ) (T%3& Type) (x Poly)
  ) (!
   (=>
    (has_type x (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&))
    (has_type (tuple%4./tuple%4/3 (%Poly%tuple%4. x)) T%3&)
   )
   :pattern ((tuple%4./tuple%4/3 (%Poly%tuple%4. x)) (has_type x (TYPE%tuple%4. T%0&. T%0&
      T%1&. T%1& T%2&. T%2& T%3&. T%3&
   )))
   :qid internal_tuple__4./tuple__4/3_invariant_definition
   :skolemid skolem_internal_tuple__4./tuple__4/3_invariant_definition
)))
(assert
 (forall ((x tuple%4.)) (!
   (=>
    (is-tuple%4./tuple%4 x)
    (height_lt (height (tuple%4./tuple%4/0 x)) (height (Poly%tuple%4. x)))
   )
   :pattern ((height (tuple%4./tuple%4/0 x)))
   :qid prelude_datatype_height_tuple%4./tuple%4/0
   :skolemid skolem_prelude_datatype_height_tuple%4./tuple%4/0
)))
(assert
 (forall ((x tuple%4.)) (!
   (=>
    (is-tuple%4./tuple%4 x)
    (height_lt (height (tuple%4./tuple%4/1 x)) (height (Poly%tuple%4. x)))
   )
   :pattern ((height (tuple%4./tuple%4/1 x)))
   :qid prelude_datatype_height_tuple%4./tuple%4/1
   :skolemid skolem_prelude_datatype_height_tuple%4./tuple%4/1
)))
(assert
 (forall ((x tuple%4.)) (!
   (=>
    (is-tuple%4./tuple%4 x)
    (height_lt (height (tuple%4./tuple%4/2 x)) (height (Poly%tuple%4. x)))
   )
   :pattern ((height (tuple%4./tuple%4/2 x)))
   :qid prelude_datatype_height_tuple%4./tuple%4/2
   :skolemid skolem_prelude_datatype_height_tuple%4./tuple%4/2
)))
(assert
 (forall ((x tuple%4.)) (!
   (=>
    (is-tuple%4./tuple%4 x)
    (height_lt (height (tuple%4./tuple%4/3 x)) (height (Poly%tuple%4. x)))
   )
   :pattern ((height (tuple%4./tuple%4/3 x)))
   :qid prelude_datatype_height_tuple%4./tuple%4/3
   :skolemid skolem_prelude_datatype_height_tuple%4./tuple%4/3
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (T%3&.
    Dcr
   ) (T%3& Type) (deep Bool) (x Poly) (y Poly)
  ) (!
   (=>
    (and
     (has_type x (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&))
     (has_type y (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&))
     (ext_eq deep T%0& (tuple%4./tuple%4/0 (%Poly%tuple%4. x)) (tuple%4./tuple%4/0 (%Poly%tuple%4.
        y
     )))
     (ext_eq deep T%1& (tuple%4./tuple%4/1 (%Poly%tuple%4. x)) (tuple%4./tuple%4/1 (%Poly%tuple%4.
        y
     )))
     (ext_eq deep T%2& (tuple%4./tuple%4/2 (%Poly%tuple%4. x)) (tuple%4./tuple%4/2 (%Poly%tuple%4.
        y
     )))
     (ext_eq deep T%3& (tuple%4./tuple%4/3 (%Poly%tuple%4. x)) (tuple%4./tuple%4/3 (%Poly%tuple%4.
        y
    ))))
    (ext_eq deep (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&) x y)
   )
   :pattern ((ext_eq deep (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&)
     x y
   ))
   :qid internal_tuple__4./tuple__4_ext_equal_definition
   :skolemid skolem_internal_tuple__4./tuple__4_ext_equal_definition
)))
(declare-fun array_new (Dcr Type Int %%Function%%) Poly)
(declare-fun array_index (Dcr Type Dcr Type %%Function%% Poly) Poly)
(assert
 (forall ((Tdcr Dcr) (T Type) (N Int) (Fn %%Function%%)) (!
   (= (array_new Tdcr T N Fn) (Poly%array%. Fn))
   :pattern ((array_new Tdcr T N Fn))
   :qid prelude_array_new
   :skolemid skolem_prelude_array_new
)))
(declare-fun %%apply%%1 (%%Function%% Int) Poly)
(assert
 (forall ((Tdcr Dcr) (T Type) (N Int) (Fn %%Function%%)) (!
   (=>
    (forall ((i Int)) (!
      (=>
       (and
        (<= 0 i)
        (< i N)
       )
       (has_type (%%apply%%1 Fn i) T)
      )
      :pattern ((has_type (%%apply%%1 Fn i) T))
      :qid prelude_has_type_array_elts
      :skolemid skolem_prelude_has_type_array_elts
    ))
    (has_type (array_new Tdcr T N Fn) (ARRAY Tdcr T $ (CONST_INT N)))
   )
   :pattern ((array_new Tdcr T N Fn))
   :qid prelude_has_type_array_new
   :skolemid skolem_prelude_has_type_array_new
)))
(assert
 (forall ((Tdcr Dcr) (T Type) (Ndcr Dcr) (N Type) (Fn %%Function%%) (i Poly)) (!
   (=>
    (and
     (has_type (Poly%array%. Fn) (ARRAY Tdcr T Ndcr N))
     (has_type i INT)
    )
    (has_type (array_index Tdcr T $ N Fn i) T)
   )
   :pattern ((array_index Tdcr T $ N Fn i) (has_type (Poly%array%. Fn) (ARRAY Tdcr T Ndcr
      N
   )))
   :qid prelude_has_type_array_index
   :skolemid skolem_prelude_has_type_array_index
)))
(assert
 (!
  (forall ((Tdcr Dcr) (T Type) (N Int) (Fn %%Function%%) (i Int)) (!
    (= (array_index Tdcr T $ (CONST_INT N) Fn (I i)) (%%apply%%1 Fn i))
    :pattern ((array_new Tdcr T N Fn) (%%apply%%1 Fn i))
    :qid prelude_array_index_trigger
    :skolemid skolem_prelude_array_index_trigger
  ))
  :named
  prelude_axiom_array_index
))

;; Trait-Bounds
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (tr_bound%vstd!array.ArrayAdditionalSpecFns. Self%&. Self%& T&. T&)
    (and
     (tr_bound%vstd!view.View. Self%&. Self%&)
     (and
      (= $ (proj%%vstd!view.View./V Self%&. Self%&))
      (= (TYPE%vstd!seq.Seq. T&. T&) (proj%vstd!view.View./V Self%&. Self%&))
     )
     (sized T&.)
   ))
   :pattern ((tr_bound%vstd!array.ArrayAdditionalSpecFns. Self%&. Self%& T&. T&))
   :qid internal_vstd__array__ArrayAdditionalSpecFns_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__array__ArrayAdditionalSpecFns_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (tr_bound%vstd!slice.SliceAdditionalSpecFns. Self%&. Self%& T&. T&)
    (and
     (tr_bound%vstd!view.View. Self%&. Self%&)
     (and
      (= $ (proj%%vstd!view.View./V Self%&. Self%&))
      (= (TYPE%vstd!seq.Seq. T&. T&) (proj%vstd!view.View./V Self%&. Self%&))
     )
     (sized T&.)
   ))
   :pattern ((tr_bound%vstd!slice.SliceAdditionalSpecFns. Self%&. Self%& T&. T&))
   :qid internal_vstd__slice__SliceAdditionalSpecFns_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__slice__SliceAdditionalSpecFns_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (=>
    (tr_bound%vstd!view.View. Self%&. Self%&)
    (sized (proj%%vstd!view.View./V Self%&. Self%&))
   )
   :pattern ((tr_bound%vstd!view.View. Self%&. Self%&))
   :qid internal_vstd__view__View_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__view__View_trait_type_bounds_definition
)))

;; Associated-Type-Impls
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (= (proj%%vstd!view.View./V $ (ARRAY T&. T& N&. N&)) $)
   :pattern ((proj%%vstd!view.View./V $ (ARRAY T&. T& N&. N&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (= (proj%vstd!view.View./V $ (ARRAY T&. T& N&. N&)) (TYPE%vstd!seq.Seq. T&. T&))
   :pattern ((proj%vstd!view.View./V $ (ARRAY T&. T& N&. N&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%%vstd!view.View./V $ (PTR T&. T&)) $)
   :pattern ((proj%%vstd!view.View./V $ (PTR T&. T&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%vstd!view.View./V $ (PTR T&. T&)) (TYPE%vstd!raw_ptr.PtrData. T&. T&))
   :pattern ((proj%vstd!view.View./V $ (PTR T&. T&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%%vstd!view.View./V (CONST_PTR $) (PTR T&. T&)) $)
   :pattern ((proj%%vstd!view.View./V (CONST_PTR $) (PTR T&. T&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%vstd!view.View./V (CONST_PTR $) (PTR T&. T&)) (TYPE%vstd!raw_ptr.PtrData.
     T&. T&
   ))
   :pattern ((proj%vstd!view.View./V (CONST_PTR $) (PTR T&. T&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%%vstd!view.View./V $slice (SLICE T&. T&)) $)
   :pattern ((proj%%vstd!view.View./V $slice (SLICE T&. T&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%vstd!view.View./V $slice (SLICE T&. T&)) (TYPE%vstd!seq.Seq. T&. T&))
   :pattern ((proj%vstd!view.View./V $slice (SLICE T&. T&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!view.View./V (REF A&.) A&) (proj%%vstd!view.View./V A&. A&))
   :pattern ((proj%%vstd!view.View./V (REF A&.) A&))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!view.View./V (REF A&.) A&) (proj%vstd!view.View./V A&. A&))
   :pattern ((proj%vstd!view.View./V (REF A&.) A&))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!view.View./V (BOX $ ALLOCATOR_GLOBAL A&.) A&) (proj%%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%%vstd!view.View./V (BOX $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!view.View./V (BOX $ ALLOCATOR_GLOBAL A&.) A&) (proj%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%vstd!view.View./V (BOX $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!view.View./V (RC $ ALLOCATOR_GLOBAL A&.) A&) (proj%%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%%vstd!view.View./V (RC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!view.View./V (RC $ ALLOCATOR_GLOBAL A&.) A&) (proj%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%vstd!view.View./V (RC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!view.View./V (ARC $ ALLOCATOR_GLOBAL A&.) A&) (proj%%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%%vstd!view.View./V (ARC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!view.View./V (ARC $ ALLOCATOR_GLOBAL A&.) A&) (proj%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%vstd!view.View./V (ARC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (= (proj%%vstd!view.View./V $ TYPE%tuple%0.) $)
)
(assert
 (= (proj%vstd!view.View./V $ TYPE%tuple%0.) TYPE%tuple%0.)
)
(assert
 (= (proj%%vstd!view.View./V $ BOOL) $)
)
(assert
 (= (proj%vstd!view.View./V $ BOOL) BOOL)
)
(assert
 (= (proj%%vstd!view.View./V $ (UINT 8)) $)
)
(assert
 (= (proj%vstd!view.View./V $ (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%vstd!view.View./V $ (UINT 64)) $)
)
(assert
 (= (proj%vstd!view.View./V $ (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%vstd!view.View./V $ USIZE) $)
)
(assert
 (= (proj%vstd!view.View./V $ USIZE) USIZE)
)
(assert
 (= (proj%%vstd!view.View./V $ (SINT 8)) $)
)
(assert
 (= (proj%vstd!view.View./V $ (SINT 8)) (SINT 8))
)
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type)) (!
   (= (proj%%vstd!view.View./V (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&)) (DST (proj%%vstd!view.View./V
      A1&. A1&
   )))
   :pattern ((proj%%vstd!view.View./V (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type)) (!
   (= (proj%vstd!view.View./V (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&)) (TYPE%tuple%2.
     (proj%%vstd!view.View./V A0&. A0&) (proj%vstd!view.View./V A0&. A0&) (proj%%vstd!view.View./V
      A1&. A1&
     ) (proj%vstd!view.View./V A1&. A1&)
   ))
   :pattern ((proj%vstd!view.View./V (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type) (A3&. Dcr)
   (A3& Type)
  ) (!
   (= (proj%%vstd!view.View./V (DST A3&.) (TYPE%tuple%4. A0&. A0& A1&. A1& A2&. A2& A3&.
      A3&
     )
    ) (DST (proj%%vstd!view.View./V A3&. A3&))
   )
   :pattern ((proj%%vstd!view.View./V (DST A3&.) (TYPE%tuple%4. A0&. A0& A1&. A1& A2&.
      A2& A3&. A3&
   )))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type) (A3&. Dcr)
   (A3& Type)
  ) (!
   (= (proj%vstd!view.View./V (DST A3&.) (TYPE%tuple%4. A0&. A0& A1&. A1& A2&. A2& A3&.
      A3&
     )
    ) (TYPE%tuple%4. (proj%%vstd!view.View./V A0&. A0&) (proj%vstd!view.View./V A0&. A0&)
     (proj%%vstd!view.View./V A1&. A1&) (proj%vstd!view.View./V A1&. A1&) (proj%%vstd!view.View./V
      A2&. A2&
     ) (proj%vstd!view.View./V A2&. A2&) (proj%%vstd!view.View./V A3&. A3&) (proj%vstd!view.View./V
      A3&. A3&
   )))
   :pattern ((proj%vstd!view.View./V (DST A3&.) (TYPE%tuple%4. A0&. A0& A1&. A1& A2&. A2&
      A3&. A3&
   )))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))

;; Function-Decl vstd::seq::Seq::len
(declare-fun vstd!seq.Seq.len.? (Dcr Type Poly) Int)

;; Function-Decl vstd::seq::Seq::index
(declare-fun vstd!seq.Seq.index.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::impl&%0::spec_index
(declare-fun vstd!seq.impl&%0.spec_index.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::Seq::subrange
(declare-fun vstd!seq.Seq.subrange.? (Dcr Type Poly Poly Poly) Poly)

;; Function-Decl vstd::seq::Seq::empty
(declare-fun vstd!seq.Seq.empty.? (Dcr Type) Poly)

;; Function-Decl vstd::seq::Seq::new
(declare-fun vstd!seq.Seq.new.? (Dcr Type Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::Seq::push
(declare-fun vstd!seq.Seq.push.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::slice::spec_slice_len
(declare-fun vstd!slice.spec_slice_len.? (Dcr Type Poly) Int)

;; Function-Decl vstd::view::View::view
(declare-fun vstd!view.View.view.? (Dcr Type Poly) Poly)
(declare-fun vstd!view.View.view%default%.? (Dcr Type Poly) Poly)

;; Function-Decl vstd::slice::SliceAdditionalSpecFns::spec_index
(declare-fun vstd!slice.SliceAdditionalSpecFns.spec_index.? (Dcr Type Dcr Type Poly
  Poly
 ) Poly
)
(declare-fun vstd!slice.SliceAdditionalSpecFns.spec_index%default%.? (Dcr Type Dcr
  Type Poly Poly
 ) Poly
)

;; Function-Decl vstd::array::array_view
(declare-fun vstd!array.array_view.? (Dcr Type Dcr Type Poly) Poly)

;; Function-Decl vstd::array::ArrayAdditionalSpecFns::spec_index
(declare-fun vstd!array.ArrayAdditionalSpecFns.spec_index.? (Dcr Type Dcr Type Poly
  Poly
 ) Poly
)
(declare-fun vstd!array.ArrayAdditionalSpecFns.spec_index%default%.? (Dcr Type Dcr
  Type Poly Poly
 ) Poly
)

;; Function-Decl vstd::raw_ptr::view_reverse_for_eq
(declare-fun vstd!raw_ptr.view_reverse_for_eq.? (Dcr Type Poly) Poly)

;; Function-Decl vstd::raw_ptr::view_reverse_for_eq_sized
(declare-fun vstd!raw_ptr.view_reverse_for_eq_sized.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::arithmetic::power2::pow2
(declare-fun vstd!arithmetic.power2.pow2.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::p
(declare-fun curve25519_dalek!specs.field_specs_u64.p.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::field_canonical
(declare-fun curve25519_dalek!specs.field_specs_u64.field_canonical.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::u64_5_as_nat
(declare-fun curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::u64_5_as_field_canonical
(declare-fun curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.? (Poly)
 Int
)

;; Function-Decl curve25519_dalek::specs::field_specs::fe51_as_canonical_nat
(declare-fun curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_x
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_x.? (Poly) curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_y
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_y.? (Poly) curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_z
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_z.? (Poly) curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_t
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_t.? (Poly) curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_point_as_nat
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.? (Poly) tuple%4.)

;; Function-Decl curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::spec_gcd
(declare-fun curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.?
 (Poly Poly) Int
)
(declare-fun curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.?
 (Poly Poly Fuel) Int
)

;; Function-Decl curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::spec_extended_gcd
(declare-fun curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?
 (Poly Poly) curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
)
(declare-fun curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
 (Poly Poly Fuel) curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
)

;; Function-Decl curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::spec_mod_inverse
(declare-fun curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?
 (Poly Poly) Int
)

;; Function-Decl curve25519_dalek::specs::field_specs::field_inv
(declare-fun curve25519_dalek!specs.field_specs.field_inv.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::field_mul
(declare-fun curve25519_dalek!specs.field_specs.field_mul.? (Poly Poly) Int)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_point_as_affine
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? (Poly)
 tuple%2.
)

;; Function-Decl curve25519_dalek::specs::field_specs::u64_5_bounded
(declare-fun curve25519_dalek!specs.field_specs.u64_5_bounded.? (Poly Poly) Bool)

;; Function-Decl curve25519_dalek::specs::field_specs::fe51_limbs_bounded
(declare-fun curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly Poly) Bool)

;; Function-Decl curve25519_dalek::specs::field_specs::field_neg
(declare-fun curve25519_dalek!specs.field_specs.field_neg.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::core_specs::u8_32_as_nat
(declare-fun curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::backend::serial::u64::constants::EDWARDS_D
(declare-fun curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.? () curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::specs::field_specs::field_square
(declare-fun curve25519_dalek!specs.field_specs.field_square.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::field_sub
(declare-fun curve25519_dalek!specs.field_specs.field_sub.? (Poly Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::field_add
(declare-fun curve25519_dalek!specs.field_specs.field_add.? (Poly Poly) Int)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_on_edwards_curve_projective
(declare-fun curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.?
 (Poly Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_valid_extended_edwards_point
(declare-fun curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.?
 (Poly Poly Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_valid_edwards_point
(declare-fun curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? (Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_point_limbs_bounded
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.? (Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_identity
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_identity.? (Poly) tuple%2.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_add
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_add.? (Poly Poly Poly Poly)
 tuple%2.
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_double
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_double.? (Poly Poly) tuple%2.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_scalar_mul
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly Poly)
 tuple%2.
)
(declare-fun curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? (Poly Poly
  Fuel
 ) tuple%2.
)

;; Function-Decl vstd::seq::impl&%0::take
(declare-fun vstd!seq.impl&%0.take.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::impl&%0::skip
(declare-fun vstd!seq.impl&%0.skip.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::Seq::last
(declare-fun vstd!seq.Seq.last.? (Dcr Type Poly) Poly)

;; Function-Decl vstd::seq_lib::impl&%0::drop_last
(declare-fun vstd!seq_lib.impl&%0.drop_last.? (Dcr Type Poly) Poly)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_scalar_mul_signed
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? (Poly
  Poly
 ) tuple%2.
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::projective_niels_point_as_affine_edwards
(declare-fun curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
 (Poly) tuple%2.
)

;; Function-Decl curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::sp_points_affine
(declare-fun curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.sp_points_affine.?
 (Poly) vstd!seq.Seq<tuple%2<nat./nat.>.>.
)

;; Function-Decl curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::sp_digits_seqs
(declare-fun curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.sp_digits_seqs.?
 (Poly) vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
)

;; Function-Decl curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::sp_digit_count
(declare-fun curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.sp_digit_count.?
 (Poly) Int
)

;; Function-Decl curve25519_dalek::specs::scalar_specs::is_valid_radix_2w
(declare-fun curve25519_dalek!specs.scalar_specs.is_valid_radix_2w.? (Poly Poly Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::projective_niels_corresponds_to_edwards
(declare-fun curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.?
 (Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_valid_projective_niels_point
(declare-fun curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.?
 (Poly) Bool
)

;; Function-Decl curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::pippenger_input_valid
(declare-fun curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_input_valid.?
 (Poly Poly Poly Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_sub
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_sub.? (Poly Poly Poly Poly)
 tuple%2.
)

;; Function-Decl curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::pippenger_bucket_contents
(declare-fun curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_bucket_contents.?
 (Poly Poly Poly Poly Poly) tuple%2.
)
(declare-fun curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_bucket_contents.?
 (Poly Poly Poly Poly Poly Fuel) tuple%2.
)

;; Function-Decl curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::pippenger_weighted_bucket_sum
(declare-fun curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_bucket_sum.?
 (Poly Poly) tuple%2.
)
(declare-fun curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_weighted_bucket_sum.?
 (Poly Poly Fuel) tuple%2.
)

;; Function-Decl curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::pippenger_intermediate_sum
(declare-fun curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_intermediate_sum.?
 (Poly Poly Poly) tuple%2.
)
(declare-fun curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_intermediate_sum.?
 (Poly Poly Poly Fuel) tuple%2.
)

;; Function-Decl curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::pippenger_running_sum
(declare-fun curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_running_sum.?
 (Poly Poly Poly) tuple%2.
)
(declare-fun curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_running_sum.?
 (Poly Poly Poly Fuel) tuple%2.
)

;; Function-Decl curve25519_dalek::lemmas::edwards_lemmas::straus_lemmas::straus_column_sum
(declare-fun curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.?
 (Poly Poly Poly Poly) tuple%2.
)
(declare-fun curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.rec%straus_column_sum.?
 (Poly Poly Poly Poly Fuel) tuple%2.
)

;; Function-Decl curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::pippenger_horner
(declare-fun curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_horner.?
 (Poly Poly Poly Poly Poly) tuple%2.
)
(declare-fun curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_horner.?
 (Poly Poly Poly Poly Poly Fuel) tuple%2.
)

;; Function-Decl curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::pippenger_weighted_from
(declare-fun curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_from.?
 (Poly Poly Poly) tuple%2.
)
(declare-fun curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_weighted_from.?
 (Poly Poly Poly Fuel) tuple%2.
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_neg
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_neg.? (Poly) tuple%2.)

;; Function-Decl curve25519_dalek::specs::scalar_specs::scalar_as_nat
(declare-fun curve25519_dalek!specs.scalar_specs.scalar_as_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::edwards_specs::sum_of_scalar_muls
(declare-fun curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls.? (Poly Poly)
 tuple%2.
)
(declare-fun curve25519_dalek!specs.edwards_specs.rec%sum_of_scalar_muls.? (Poly Poly
  Fuel
 ) tuple%2.
)

;; Function-Decl curve25519_dalek::specs::scalar_specs::reconstruct_radix_2w
(declare-fun curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w.? (Poly Poly)
 Int
)
(declare-fun curve25519_dalek!specs.scalar_specs.rec%reconstruct_radix_2w.? (Poly Poly
  Fuel
 ) Int
)

;; Function-Decl curve25519_dalek::specs::scalar_specs::reconstruct_radix_2w_from
(declare-fun curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w_from.? (Poly
  Poly Poly Poly
 ) Int
)
(declare-fun curve25519_dalek!specs.scalar_specs.rec%reconstruct_radix_2w_from.? (
  Poly Poly Poly Poly Fuel
 ) Int
)

;; Function-Axioms vstd::seq::Seq::len
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
   (=>
    (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
    (<= 0 (vstd!seq.Seq.len.? A&. A& self!))
   )
   :pattern ((vstd!seq.Seq.len.? A&. A& self!))
   :qid internal_vstd!seq.Seq.len.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.len.?_pre_post_definition
)))

;; Function-Specs vstd::seq::Seq::index
(declare-fun req%vstd!seq.Seq.index. (Dcr Type Poly Poly) Bool)
(declare-const %%global_location_label%%0 Bool)
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
   (= (req%vstd!seq.Seq.index. A&. A& self! i!) (=>
     %%global_location_label%%0
     (let
      ((tmp%%$ (%I i!)))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ (vstd!seq.Seq.len.? A&. A& self!))
   ))))
   :pattern ((req%vstd!seq.Seq.index. A&. A& self! i!))
   :qid internal_req__vstd!seq.Seq.index._definition
   :skolemid skolem_internal_req__vstd!seq.Seq.index._definition
)))

;; Function-Axioms vstd::seq::Seq::index
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
   (=>
    (and
     (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
     (has_type i! INT)
    )
    (has_type (vstd!seq.Seq.index.? A&. A& self! i!) A&)
   )
   :pattern ((vstd!seq.Seq.index.? A&. A& self! i!))
   :qid internal_vstd!seq.Seq.index.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.index.?_pre_post_definition
)))

;; Function-Specs vstd::seq::impl&%0::spec_index
(declare-fun req%vstd!seq.impl&%0.spec_index. (Dcr Type Poly Poly) Bool)
(declare-const %%global_location_label%%1 Bool)
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
   (= (req%vstd!seq.impl&%0.spec_index. A&. A& self! i!) (=>
     %%global_location_label%%1
     (let
      ((tmp%%$ (%I i!)))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ (vstd!seq.Seq.len.? A&. A& self!))
   ))))
   :pattern ((req%vstd!seq.impl&%0.spec_index. A&. A& self! i!))
   :qid internal_req__vstd!seq.impl&__0.spec_index._definition
   :skolemid skolem_internal_req__vstd!seq.impl&__0.spec_index._definition
)))

;; Function-Axioms vstd::seq::impl&%0::spec_index
(assert
 (fuel_bool_default fuel%vstd!seq.impl&%0.spec_index.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!seq.impl&%0.spec_index.)
  (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
    (= (vstd!seq.impl&%0.spec_index.? A&. A& self! i!) (vstd!seq.Seq.index.? A&. A& self!
      i!
    ))
    :pattern ((vstd!seq.impl&%0.spec_index.? A&. A& self! i!))
    :qid internal_vstd!seq.impl&__0.spec_index.?_definition
    :skolemid skolem_internal_vstd!seq.impl&__0.spec_index.?_definition
))))
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
   (=>
    (and
     (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
     (has_type i! INT)
    )
    (has_type (vstd!seq.impl&%0.spec_index.? A&. A& self! i!) A&)
   )
   :pattern ((vstd!seq.impl&%0.spec_index.? A&. A& self! i!))
   :qid internal_vstd!seq.impl&__0.spec_index.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.impl&__0.spec_index.?_pre_post_definition
)))

;; Broadcast vstd::seq::axiom_seq_index_decreases
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_index_decreases.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type i! INT)
     )
     (=>
      (and
       (sized A&.)
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (vstd!seq.Seq.len.? A&. A& s!))
      )))
      (height_lt (height (vstd!seq.Seq.index.? A&. A& s! i!)) (height s!))
    ))
    :pattern ((height (vstd!seq.Seq.index.? A&. A& s! i!)))
    :qid user_vstd__seq__axiom_seq_index_decreases_0
    :skolemid skolem_user_vstd__seq__axiom_seq_index_decreases_0
))))

;; Function-Specs vstd::seq::Seq::subrange
(declare-fun req%vstd!seq.Seq.subrange. (Dcr Type Poly Poly Poly) Bool)
(declare-const %%global_location_label%%2 Bool)
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (start_inclusive! Poly) (end_exclusive! Poly))
  (!
   (= (req%vstd!seq.Seq.subrange. A&. A& self! start_inclusive! end_exclusive!) (=>
     %%global_location_label%%2
     (let
      ((tmp%%$ (%I start_inclusive!)))
      (let
       ((tmp%%$1 (%I end_exclusive!)))
       (and
        (and
         (<= 0 tmp%%$)
         (<= tmp%%$ tmp%%$1)
        )
        (<= tmp%%$1 (vstd!seq.Seq.len.? A&. A& self!))
   )))))
   :pattern ((req%vstd!seq.Seq.subrange. A&. A& self! start_inclusive! end_exclusive!))
   :qid internal_req__vstd!seq.Seq.subrange._definition
   :skolemid skolem_internal_req__vstd!seq.Seq.subrange._definition
)))

;; Function-Axioms vstd::seq::Seq::subrange
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (start_inclusive! Poly) (end_exclusive! Poly))
  (!
   (=>
    (and
     (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
     (has_type start_inclusive! INT)
     (has_type end_exclusive! INT)
    )
    (has_type (vstd!seq.Seq.subrange.? A&. A& self! start_inclusive! end_exclusive!) (
      TYPE%vstd!seq.Seq. A&. A&
   )))
   :pattern ((vstd!seq.Seq.subrange.? A&. A& self! start_inclusive! end_exclusive!))
   :qid internal_vstd!seq.Seq.subrange.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.subrange.?_pre_post_definition
)))

;; Broadcast vstd::seq::axiom_seq_subrange_decreases
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_subrange_decreases.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (i! Poly) (j! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type i! INT)
      (has_type j! INT)
     )
     (=>
      (and
       (and
        (sized A&.)
        (let
         ((tmp%%$ (%I i!)))
         (let
          ((tmp%%$1 (%I j!)))
          (and
           (and
            (<= 0 tmp%%$)
            (<= tmp%%$ tmp%%$1)
           )
           (<= tmp%%$1 (vstd!seq.Seq.len.? A&. A& s!))
       ))))
       (< (vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.subrange.? A&. A& s! i! j!)) (vstd!seq.Seq.len.?
         A&. A& s!
      )))
      (height_lt (height (vstd!seq.Seq.subrange.? A&. A& s! i! j!)) (height s!))
    ))
    :pattern ((height (vstd!seq.Seq.subrange.? A&. A& s! i! j!)))
    :qid user_vstd__seq__axiom_seq_subrange_decreases_1
    :skolemid skolem_user_vstd__seq__axiom_seq_subrange_decreases_1
))))

;; Function-Axioms vstd::seq::Seq::empty
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (has_type (vstd!seq.Seq.empty.? A&. A&) (TYPE%vstd!seq.Seq. A&. A&))
   :pattern ((vstd!seq.Seq.empty.? A&. A&))
   :qid internal_vstd!seq.Seq.empty.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.empty.?_pre_post_definition
)))

;; Broadcast vstd::seq::axiom_seq_empty
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_empty.)
  (forall ((A&. Dcr) (A& Type)) (!
    (=>
     (sized A&.)
     (= (vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.empty.? A&. A&)) 0)
    )
    :pattern ((vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.empty.? A&. A&)))
    :qid user_vstd__seq__axiom_seq_empty_2
    :skolemid skolem_user_vstd__seq__axiom_seq_empty_2
))))

;; Function-Axioms vstd::seq::Seq::new
(assert
 (forall ((A&. Dcr) (A& Type) (impl%1&. Dcr) (impl%1& Type) (len! Poly) (f! Poly))
  (!
   (=>
    (and
     (has_type len! NAT)
     (has_type f! impl%1&)
    )
    (has_type (vstd!seq.Seq.new.? A&. A& impl%1&. impl%1& len! f!) (TYPE%vstd!seq.Seq.
      A&. A&
   )))
   :pattern ((vstd!seq.Seq.new.? A&. A& impl%1&. impl%1& len! f!))
   :qid internal_vstd!seq.Seq.new.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.new.?_pre_post_definition
)))

;; Broadcast vstd::seq::axiom_seq_new_len
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_new_len.)
  (forall ((A&. Dcr) (A& Type) (len! Poly) (f! Poly)) (!
    (=>
     (and
      (has_type len! NAT)
      (has_type f! (TYPE%fun%1. $ INT A&. A&))
     )
     (=>
      (sized A&.)
      (= (vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.new.? A&. A& $ (TYPE%fun%1. $ INT A&. A&)
         len! f!
        )
       ) (%I len!)
    )))
    :pattern ((vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.new.? A&. A& $ (TYPE%fun%1. $ INT
        A&. A&
       ) len! f!
    )))
    :qid user_vstd__seq__axiom_seq_new_len_3
    :skolemid skolem_user_vstd__seq__axiom_seq_new_len_3
))))

;; Broadcast vstd::seq::axiom_seq_new_index
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_new_index.)
  (forall ((A&. Dcr) (A& Type) (len! Poly) (f! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type len! NAT)
      (has_type f! (TYPE%fun%1. $ INT A&. A&))
      (has_type i! INT)
     )
     (=>
      (and
       (sized A&.)
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (%I len!))
      )))
      (= (vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.new.? A&. A& $ (TYPE%fun%1. $ INT A&. A&)
         len! f!
        ) i!
       ) (%%apply%%0 (%Poly%fun%1. f!) i!)
    )))
    :pattern ((vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.new.? A&. A& $ (TYPE%fun%1. $ INT
        A&. A&
       ) len! f!
      ) i!
    ))
    :qid user_vstd__seq__axiom_seq_new_index_4
    :skolemid skolem_user_vstd__seq__axiom_seq_new_index_4
))))

;; Function-Axioms vstd::seq::Seq::push
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (a! Poly)) (!
   (=>
    (and
     (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
     (has_type a! A&)
    )
    (has_type (vstd!seq.Seq.push.? A&. A& self! a!) (TYPE%vstd!seq.Seq. A&. A&))
   )
   :pattern ((vstd!seq.Seq.push.? A&. A& self! a!))
   :qid internal_vstd!seq.Seq.push.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.push.?_pre_post_definition
)))

;; Broadcast vstd::seq::axiom_seq_push_len
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_push_len.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (a! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type a! A&)
     )
     (=>
      (sized A&.)
      (= (vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.push.? A&. A& s! a!)) (nClip (Add (vstd!seq.Seq.len.?
          A&. A& s!
         ) 1
    )))))
    :pattern ((vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.push.? A&. A& s! a!)))
    :qid user_vstd__seq__axiom_seq_push_len_5
    :skolemid skolem_user_vstd__seq__axiom_seq_push_len_5
))))

;; Broadcast vstd::seq::axiom_seq_push_index_same
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_push_index_same.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (a! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type a! A&)
      (has_type i! INT)
     )
     (=>
      (and
       (sized A&.)
       (= (%I i!) (vstd!seq.Seq.len.? A&. A& s!))
      )
      (= (vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.push.? A&. A& s! a!) i!) a!)
    ))
    :pattern ((vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.push.? A&. A& s! a!) i!))
    :qid user_vstd__seq__axiom_seq_push_index_same_6
    :skolemid skolem_user_vstd__seq__axiom_seq_push_index_same_6
))))

;; Broadcast vstd::seq::axiom_seq_push_index_different
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_push_index_different.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (a! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type a! A&)
      (has_type i! INT)
     )
     (=>
      (and
       (sized A&.)
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (vstd!seq.Seq.len.? A&. A& s!))
      )))
      (= (vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.push.? A&. A& s! a!) i!) (vstd!seq.Seq.index.?
        A&. A& s! i!
    ))))
    :pattern ((vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.push.? A&. A& s! a!) i!))
    :qid user_vstd__seq__axiom_seq_push_index_different_7
    :skolemid skolem_user_vstd__seq__axiom_seq_push_index_different_7
))))

;; Broadcast vstd::seq::axiom_seq_ext_equal
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_ext_equal.)
  (forall ((A&. Dcr) (A& Type) (s1! Poly) (s2! Poly)) (!
    (=>
     (and
      (has_type s1! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type s2! (TYPE%vstd!seq.Seq. A&. A&))
     )
     (=>
      (sized A&.)
      (= (ext_eq false (TYPE%vstd!seq.Seq. A&. A&) s1! s2!) (and
        (= (vstd!seq.Seq.len.? A&. A& s1!) (vstd!seq.Seq.len.? A&. A& s2!))
        (forall ((i$ Poly)) (!
          (=>
           (has_type i$ INT)
           (=>
            (let
             ((tmp%%$ (%I i$)))
             (and
              (<= 0 tmp%%$)
              (< tmp%%$ (vstd!seq.Seq.len.? A&. A& s1!))
            ))
            (= (vstd!seq.Seq.index.? A&. A& s1! i$) (vstd!seq.Seq.index.? A&. A& s2! i$))
          ))
          :pattern ((vstd!seq.Seq.index.? A&. A& s1! i$))
          :pattern ((vstd!seq.Seq.index.? A&. A& s2! i$))
          :qid user_vstd__seq__axiom_seq_ext_equal_8
          :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_8
    ))))))
    :pattern ((ext_eq false (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_9
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_9
))))

;; Broadcast vstd::seq::axiom_seq_ext_equal_deep
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_ext_equal_deep.)
  (forall ((A&. Dcr) (A& Type) (s1! Poly) (s2! Poly)) (!
    (=>
     (and
      (has_type s1! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type s2! (TYPE%vstd!seq.Seq. A&. A&))
     )
     (=>
      (sized A&.)
      (= (ext_eq true (TYPE%vstd!seq.Seq. A&. A&) s1! s2!) (and
        (= (vstd!seq.Seq.len.? A&. A& s1!) (vstd!seq.Seq.len.? A&. A& s2!))
        (forall ((i$ Poly)) (!
          (=>
           (has_type i$ INT)
           (=>
            (let
             ((tmp%%$ (%I i$)))
             (and
              (<= 0 tmp%%$)
              (< tmp%%$ (vstd!seq.Seq.len.? A&. A& s1!))
            ))
            (ext_eq true A& (vstd!seq.Seq.index.? A&. A& s1! i$) (vstd!seq.Seq.index.? A&. A& s2!
              i$
          ))))
          :pattern ((vstd!seq.Seq.index.? A&. A& s1! i$))
          :pattern ((vstd!seq.Seq.index.? A&. A& s2! i$))
          :qid user_vstd__seq__axiom_seq_ext_equal_deep_10
          :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_10
    ))))))
    :pattern ((ext_eq true (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_deep_11
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_11
))))

;; Broadcast vstd::seq::axiom_seq_subrange_len
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_subrange_len.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (j! Poly) (k! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type j! INT)
      (has_type k! INT)
     )
     (=>
      (and
       (sized A&.)
       (let
        ((tmp%%$ (%I j!)))
        (let
         ((tmp%%$1 (%I k!)))
         (and
          (and
           (<= 0 tmp%%$)
           (<= tmp%%$ tmp%%$1)
          )
          (<= tmp%%$1 (vstd!seq.Seq.len.? A&. A& s!))
      ))))
      (= (vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.subrange.? A&. A& s! j! k!)) (Sub (%I k!)
        (%I j!)
    ))))
    :pattern ((vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.subrange.? A&. A& s! j! k!)))
    :qid user_vstd__seq__axiom_seq_subrange_len_12
    :skolemid skolem_user_vstd__seq__axiom_seq_subrange_len_12
))))

;; Broadcast vstd::seq::axiom_seq_subrange_index
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_subrange_index.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (j! Poly) (k! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type j! INT)
      (has_type k! INT)
      (has_type i! INT)
     )
     (=>
      (and
       (and
        (sized A&.)
        (let
         ((tmp%%$ (%I j!)))
         (let
          ((tmp%%$1 (%I k!)))
          (and
           (and
            (<= 0 tmp%%$)
            (<= tmp%%$ tmp%%$1)
           )
           (<= tmp%%$1 (vstd!seq.Seq.len.? A&. A& s!))
       ))))
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (Sub (%I k!) (%I j!)))
      )))
      (= (vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.subrange.? A&. A& s! j! k!) i!) (vstd!seq.Seq.index.?
        A&. A& s! (I (Add (%I i!) (%I j!)))
    ))))
    :pattern ((vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.subrange.? A&. A& s! j! k!) i!))
    :qid user_vstd__seq__axiom_seq_subrange_index_13
    :skolemid skolem_user_vstd__seq__axiom_seq_subrange_index_13
))))

;; Broadcast vstd::seq::lemma_seq_two_subranges_index
(assert
 (=>
  (fuel_bool fuel%vstd!seq.lemma_seq_two_subranges_index.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (j! Poly) (k1! Poly) (k2! Poly) (i! Poly))
   (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type j! INT)
      (has_type k1! INT)
      (has_type k2! INT)
      (has_type i! INT)
     )
     (=>
      (and
       (and
        (and
         (and
          (sized A&.)
          (let
           ((tmp%%$ (%I j!)))
           (let
            ((tmp%%$1 (%I k1!)))
            (and
             (and
              (<= 0 tmp%%$)
              (<= tmp%%$ tmp%%$1)
             )
             (<= tmp%%$1 (vstd!seq.Seq.len.? A&. A& s!))
         ))))
         (let
          ((tmp%%$ (%I j!)))
          (let
           ((tmp%%$3 (%I k2!)))
           (and
            (and
             (<= 0 tmp%%$)
             (<= tmp%%$ tmp%%$3)
            )
            (<= tmp%%$3 (vstd!seq.Seq.len.? A&. A& s!))
        ))))
        (let
         ((tmp%%$ (%I i!)))
         (and
          (<= 0 tmp%%$)
          (< tmp%%$ (Sub (%I k1!) (%I j!)))
       )))
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (Sub (%I k2!) (%I j!)))
      )))
      (= (vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.subrange.? A&. A& s! j! k1!) i!) (vstd!seq.Seq.index.?
        A&. A& (vstd!seq.Seq.subrange.? A&. A& s! j! k2!) i!
    ))))
    :pattern ((vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.subrange.? A&. A& s! j! k1!) i!)
     (vstd!seq.Seq.subrange.? A&. A& s! j! k2!)
    )
    :qid user_vstd__seq__lemma_seq_two_subranges_index_14
    :skolemid skolem_user_vstd__seq__lemma_seq_two_subranges_index_14
))))

;; Function-Axioms vstd::slice::spec_slice_len
(assert
 (forall ((T&. Dcr) (T& Type) (slice! Poly)) (!
   (=>
    (has_type slice! (SLICE T&. T&))
    (uInv SZ (vstd!slice.spec_slice_len.? T&. T& slice!))
   )
   :pattern ((vstd!slice.spec_slice_len.? T&. T& slice!))
   :qid internal_vstd!slice.spec_slice_len.?_pre_post_definition
   :skolemid skolem_internal_vstd!slice.spec_slice_len.?_pre_post_definition
)))

;; Function-Axioms vstd::view::View::view
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly)) (!
   (=>
    (has_type self! Self%&)
    (has_type (vstd!view.View.view.? Self%&. Self%& self!) (proj%vstd!view.View./V Self%&.
      Self%&
   )))
   :pattern ((vstd!view.View.view.? Self%&. Self%& self!))
   :qid internal_vstd!view.View.view.?_pre_post_definition
   :skolemid skolem_internal_vstd!view.View.view.?_pre_post_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%vstd!view.View. $slice (SLICE T&. T&))
   )
   :pattern ((tr_bound%vstd!view.View. $slice (SLICE T&. T&)))
   :qid internal_vstd__slice__impl&__0_trait_impl_definition
   :skolemid skolem_internal_vstd__slice__impl&__0_trait_impl_definition
)))

;; Broadcast vstd::slice::axiom_spec_len
(assert
 (=>
  (fuel_bool fuel%vstd!slice.axiom_spec_len.)
  (forall ((T&. Dcr) (T& Type) (slice! Poly)) (!
    (=>
     (has_type slice! (SLICE T&. T&))
     (=>
      (sized T&.)
      (= (vstd!slice.spec_slice_len.? T&. T& slice!) (vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.?
         $slice (SLICE T&. T&) slice!
    )))))
    :pattern ((vstd!slice.spec_slice_len.? T&. T& slice!))
    :qid user_vstd__slice__axiom_spec_len_15
    :skolemid skolem_user_vstd__slice__axiom_spec_len_15
))))

;; Function-Specs vstd::slice::SliceAdditionalSpecFns::spec_index
(declare-fun req%vstd!slice.SliceAdditionalSpecFns.spec_index. (Dcr Type Dcr Type Poly
  Poly
 ) Bool
)
(declare-const %%global_location_label%%3 Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (
   !
   (= (req%vstd!slice.SliceAdditionalSpecFns.spec_index. Self%&. Self%& T&. T& self! i!)
    (=>
     %%global_location_label%%3
     (let
      ((tmp%%$ (%I i!)))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ (vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.? Self%&. Self%& self!)))
   ))))
   :pattern ((req%vstd!slice.SliceAdditionalSpecFns.spec_index. Self%&. Self%& T&. T&
     self! i!
   ))
   :qid internal_req__vstd!slice.SliceAdditionalSpecFns.spec_index._definition
   :skolemid skolem_internal_req__vstd!slice.SliceAdditionalSpecFns.spec_index._definition
)))

;; Function-Axioms vstd::slice::SliceAdditionalSpecFns::spec_index
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (
   !
   (=>
    (and
     (has_type self! Self%&)
     (has_type i! INT)
    )
    (has_type (vstd!slice.SliceAdditionalSpecFns.spec_index.? Self%&. Self%& T&. T& self!
      i!
     ) T&
   ))
   :pattern ((vstd!slice.SliceAdditionalSpecFns.spec_index.? Self%&. Self%& T&. T& self!
     i!
   ))
   :qid internal_vstd!slice.SliceAdditionalSpecFns.spec_index.?_pre_post_definition
   :skolemid skolem_internal_vstd!slice.SliceAdditionalSpecFns.spec_index.?_pre_post_definition
)))

;; Function-Axioms vstd::slice::impl&%2::spec_index
(assert
 (fuel_bool_default fuel%vstd!slice.impl&%2.spec_index.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!slice.impl&%2.spec_index.)
  (forall ((T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (!
    (=>
     (sized T&.)
     (= (vstd!slice.SliceAdditionalSpecFns.spec_index.? $slice (SLICE T&. T&) T&. T& self!
       i!
      ) (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&) self!)
       i!
    )))
    :pattern ((vstd!slice.SliceAdditionalSpecFns.spec_index.? $slice (SLICE T&. T&) T&.
      T& self! i!
    ))
    :qid internal_vstd!slice.SliceAdditionalSpecFns.spec_index.?_definition
    :skolemid skolem_internal_vstd!slice.SliceAdditionalSpecFns.spec_index.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%vstd!slice.SliceAdditionalSpecFns. $slice (SLICE T&. T&) T&. T&)
   )
   :pattern ((tr_bound%vstd!slice.SliceAdditionalSpecFns. $slice (SLICE T&. T&) T&. T&))
   :qid internal_vstd__slice__impl&__2_trait_impl_definition
   :skolemid skolem_internal_vstd__slice__impl&__2_trait_impl_definition
)))

;; Broadcast vstd::slice::axiom_slice_ext_equal
(assert
 (=>
  (fuel_bool fuel%vstd!slice.axiom_slice_ext_equal.)
  (forall ((T&. Dcr) (T& Type) (a1! Poly) (a2! Poly)) (!
    (=>
     (and
      (has_type a1! (SLICE T&. T&))
      (has_type a2! (SLICE T&. T&))
     )
     (=>
      (sized T&.)
      (= (ext_eq false (SLICE T&. T&) a1! a2!) (and
        (= (vstd!slice.spec_slice_len.? T&. T& a1!) (vstd!slice.spec_slice_len.? T&. T& a2!))
        (forall ((i$ Poly)) (!
          (=>
           (has_type i$ INT)
           (=>
            (let
             ((tmp%%$ (%I i$)))
             (and
              (<= 0 tmp%%$)
              (< tmp%%$ (vstd!slice.spec_slice_len.? T&. T& a1!))
            ))
            (= (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&) a1!) i$)
             (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&) a2!) i$)
          )))
          :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&)
             a1!
            ) i$
          ))
          :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&)
             a2!
            ) i$
          ))
          :qid user_vstd__slice__axiom_slice_ext_equal_16
          :skolemid skolem_user_vstd__slice__axiom_slice_ext_equal_16
    ))))))
    :pattern ((ext_eq false (SLICE T&. T&) a1! a2!))
    :qid user_vstd__slice__axiom_slice_ext_equal_17
    :skolemid skolem_user_vstd__slice__axiom_slice_ext_equal_17
))))

;; Broadcast vstd::slice::axiom_slice_has_resolved
(assert
 (=>
  (fuel_bool fuel%vstd!slice.axiom_slice_has_resolved.)
  (forall ((T&. Dcr) (T& Type) (slice! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type slice! (SLICE T&. T&))
      (has_type i! INT)
     )
     (=>
      (sized T&.)
      (=>
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (vstd!slice.spec_slice_len.? T&. T& slice!))
       ))
       (=>
        (has_resolved $slice (SLICE T&. T&) slice!)
        (has_resolved T&. T& (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE
            T&. T&
           ) slice!
          ) i!
    ))))))
    :pattern ((has_resolved $slice (SLICE T&. T&) slice!) (vstd!seq.Seq.index.? T&. T&
      (vstd!view.View.view.? $slice (SLICE T&. T&) slice!) i!
    ))
    :qid user_vstd__slice__axiom_slice_has_resolved_18
    :skolemid skolem_user_vstd__slice__axiom_slice_has_resolved_18
))))

;; Function-Axioms vstd::array::array_view
(assert
 (fuel_bool_default fuel%vstd!array.array_view.)
)
(declare-fun %%lambda%%0 (Dcr Type Dcr Type %%Function%%) %%Function%%)
(assert
 (forall ((%%hole%%0 Dcr) (%%hole%%1 Type) (%%hole%%2 Dcr) (%%hole%%3 Type) (%%hole%%4
    %%Function%%
   ) (i$ Poly)
  ) (!
   (= (%%apply%%0 (%%lambda%%0 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4) i$)
    (array_index %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4 i$)
   )
   :pattern ((%%apply%%0 (%%lambda%%0 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4)
     i$
)))))
(assert
 (=>
  (fuel_bool fuel%vstd!array.array_view.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (a! Poly)) (!
    (= (vstd!array.array_view.? T&. T& N&. N& a!) (vstd!seq.Seq.new.? T&. T& $ (TYPE%fun%1.
       $ INT T&. T&
      ) (I (const_int N&)) (Poly%fun%1. (mk_fun (%%lambda%%0 T&. T& N&. N& (%Poly%array%. a!))))
    ))
    :pattern ((vstd!array.array_view.? T&. T& N&. N& a!))
    :qid internal_vstd!array.array_view.?_definition
    :skolemid skolem_internal_vstd!array.array_view.?_definition
))))
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (a! Poly)) (!
   (=>
    (has_type a! (ARRAY T&. T& N&. N&))
    (has_type (vstd!array.array_view.? T&. T& N&. N& a!) (TYPE%vstd!seq.Seq. T&. T&))
   )
   :pattern ((vstd!array.array_view.? T&. T& N&. N& a!))
   :qid internal_vstd!array.array_view.?_pre_post_definition
   :skolemid skolem_internal_vstd!array.array_view.?_pre_post_definition
)))

;; Function-Axioms vstd::array::impl&%0::view
(assert
 (fuel_bool_default fuel%vstd!array.impl&%0.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!array.impl&%0.view.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (self! Poly)) (!
    (=>
     (and
      (sized T&.)
      (uInv SZ (const_int N&))
     )
     (= (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) self!) (vstd!array.array_view.? T&.
       T& N&. N& self!
    )))
    :pattern ((vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (uInv SZ (const_int N&))
    )
    (tr_bound%vstd!view.View. $ (ARRAY T&. T& N&. N&))
   )
   :pattern ((tr_bound%vstd!view.View. $ (ARRAY T&. T& N&. N&)))
   :qid internal_vstd__array__impl&__0_trait_impl_definition
   :skolemid skolem_internal_vstd__array__impl&__0_trait_impl_definition
)))

;; Broadcast vstd::array::array_len_matches_n
(assert
 (=>
  (fuel_bool fuel%vstd!array.array_len_matches_n.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (ar! Poly)) (!
    (=>
     (has_type ar! (ARRAY T&. T& N&. N&))
     (=>
      (and
       (sized T&.)
       (uInv SZ (const_int N&))
      )
      (= (vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) ar!))
       (const_int N&)
    )))
    :pattern ((vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
       ar!
    )))
    :qid user_vstd__array__array_len_matches_n_19
    :skolemid skolem_user_vstd__array__array_len_matches_n_19
))))

;; Function-Specs vstd::array::ArrayAdditionalSpecFns::spec_index
(declare-fun req%vstd!array.ArrayAdditionalSpecFns.spec_index. (Dcr Type Dcr Type Poly
  Poly
 ) Bool
)
(declare-const %%global_location_label%%4 Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (
   !
   (= (req%vstd!array.ArrayAdditionalSpecFns.spec_index. Self%&. Self%& T&. T& self! i!)
    (=>
     %%global_location_label%%4
     (let
      ((tmp%%$ (%I i!)))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ (vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.? Self%&. Self%& self!)))
   ))))
   :pattern ((req%vstd!array.ArrayAdditionalSpecFns.spec_index. Self%&. Self%& T&. T&
     self! i!
   ))
   :qid internal_req__vstd!array.ArrayAdditionalSpecFns.spec_index._definition
   :skolemid skolem_internal_req__vstd!array.ArrayAdditionalSpecFns.spec_index._definition
)))

;; Function-Axioms vstd::array::ArrayAdditionalSpecFns::spec_index
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (
   !
   (=>
    (and
     (has_type self! Self%&)
     (has_type i! INT)
    )
    (has_type (vstd!array.ArrayAdditionalSpecFns.spec_index.? Self%&. Self%& T&. T& self!
      i!
     ) T&
   ))
   :pattern ((vstd!array.ArrayAdditionalSpecFns.spec_index.? Self%&. Self%& T&. T& self!
     i!
   ))
   :qid internal_vstd!array.ArrayAdditionalSpecFns.spec_index.?_pre_post_definition
   :skolemid skolem_internal_vstd!array.ArrayAdditionalSpecFns.spec_index.?_pre_post_definition
)))

;; Function-Axioms vstd::array::impl&%2::spec_index
(assert
 (fuel_bool_default fuel%vstd!array.impl&%2.spec_index.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!array.impl&%2.spec_index.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (self! Poly) (i! Poly)) (!
    (=>
     (and
      (sized T&.)
      (uInv SZ (const_int N&))
     )
     (= (vstd!array.ArrayAdditionalSpecFns.spec_index.? $ (ARRAY T&. T& N&. N&) T&. T& self!
       i!
      ) (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) self!)
       i!
    )))
    :pattern ((vstd!array.ArrayAdditionalSpecFns.spec_index.? $ (ARRAY T&. T& N&. N&) T&.
      T& self! i!
    ))
    :qid internal_vstd!array.ArrayAdditionalSpecFns.spec_index.?_definition
    :skolemid skolem_internal_vstd!array.ArrayAdditionalSpecFns.spec_index.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (uInv SZ (const_int N&))
    )
    (tr_bound%vstd!array.ArrayAdditionalSpecFns. $ (ARRAY T&. T& N&. N&) T&. T&)
   )
   :pattern ((tr_bound%vstd!array.ArrayAdditionalSpecFns. $ (ARRAY T&. T& N&. N&) T&.
     T&
   ))
   :qid internal_vstd__array__impl&__2_trait_impl_definition
   :skolemid skolem_internal_vstd__array__impl&__2_trait_impl_definition
)))

;; Broadcast vstd::array::lemma_array_index
(assert
 (=>
  (fuel_bool fuel%vstd!array.lemma_array_index.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (a! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type a! (ARRAY T&. T& N&. N&))
      (has_type i! INT)
     )
     (=>
      (and
       (and
        (sized T&.)
        (uInv SZ (const_int N&))
       )
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (const_int N&))
      )))
      (= (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) a!)
        i!
       ) (vstd!seq.Seq.index.? T&. T& (vstd!array.array_view.? T&. T& N&. N& a!) i!)
    )))
    :pattern ((array_index T&. T& N&. N& (%Poly%array%. a!) i!))
    :qid user_vstd__array__lemma_array_index_20
    :skolemid skolem_user_vstd__array__lemma_array_index_20
))))

;; Broadcast vstd::array::axiom_array_ext_equal
(assert
 (=>
  (fuel_bool fuel%vstd!array.axiom_array_ext_equal.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (a1! Poly) (a2! Poly)) (!
    (=>
     (and
      (has_type a1! (ARRAY T&. T& N&. N&))
      (has_type a2! (ARRAY T&. T& N&. N&))
     )
     (=>
      (and
       (sized T&.)
       (uInv SZ (const_int N&))
      )
      (= (ext_eq false (ARRAY T&. T& N&. N&) a1! a2!) (forall ((i$ Poly)) (!
         (=>
          (has_type i$ INT)
          (=>
           (let
            ((tmp%%$ (%I i$)))
            (and
             (<= 0 tmp%%$)
             (< tmp%%$ (const_int N&))
           ))
           (= (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) a1!)
             i$
            ) (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) a2!)
             i$
         ))))
         :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
            a1!
           ) i$
         ))
         :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
            a2!
           ) i$
         ))
         :qid user_vstd__array__axiom_array_ext_equal_21
         :skolemid skolem_user_vstd__array__axiom_array_ext_equal_21
    )))))
    :pattern ((ext_eq false (ARRAY T&. T& N&. N&) a1! a2!))
    :qid user_vstd__array__axiom_array_ext_equal_22
    :skolemid skolem_user_vstd__array__axiom_array_ext_equal_22
))))

;; Broadcast vstd::array::axiom_array_has_resolved
(assert
 (=>
  (fuel_bool fuel%vstd!array.axiom_array_has_resolved.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (array! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type array! (ARRAY T&. T& N&. N&))
      (has_type i! INT)
     )
     (=>
      (and
       (sized T&.)
       (uInv SZ (const_int N&))
      )
      (=>
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (const_int N&))
       ))
       (=>
        (has_resolved $ (ARRAY T&. T& N&. N&) array!)
        (has_resolved T&. T& (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&.
            T& N&. N&
           ) array!
          ) i!
    ))))))
    :pattern ((has_resolved $ (ARRAY T&. T& N&. N&) array!) (vstd!seq.Seq.index.? T&. T&
      (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) array!) i!
    ))
    :qid user_vstd__array__axiom_array_has_resolved_23
    :skolemid skolem_user_vstd__array__axiom_array_has_resolved_23
))))

;; Function-Axioms vstd::raw_ptr::view_reverse_for_eq
(assert
 (forall ((T&. Dcr) (T& Type) (data! Poly)) (!
   (=>
    (has_type data! (TYPE%vstd!raw_ptr.PtrData. T&. T&))
    (has_type (vstd!raw_ptr.view_reverse_for_eq.? T&. T& data!) (PTR T&. T&))
   )
   :pattern ((vstd!raw_ptr.view_reverse_for_eq.? T&. T& data!))
   :qid internal_vstd!raw_ptr.view_reverse_for_eq.?_pre_post_definition
   :skolemid skolem_internal_vstd!raw_ptr.view_reverse_for_eq.?_pre_post_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%vstd!view.View. $ (PTR T&. T&))
   :pattern ((tr_bound%vstd!view.View. $ (PTR T&. T&)))
   :qid internal_vstd__raw_ptr__impl&__2_trait_impl_definition
   :skolemid skolem_internal_vstd__raw_ptr__impl&__2_trait_impl_definition
)))

;; Broadcast vstd::raw_ptr::ptrs_mut_eq
(assert
 (=>
  (fuel_bool fuel%vstd!raw_ptr.ptrs_mut_eq.)
  (forall ((T&. Dcr) (T& Type) (a! Poly)) (!
    (=>
     (has_type a! (PTR T&. T&))
     (= (vstd!raw_ptr.view_reverse_for_eq.? T&. T& (vstd!view.View.view.? $ (PTR T&. T&)
        a!
       )
      ) a!
    ))
    :pattern ((vstd!view.View.view.? $ (PTR T&. T&) a!))
    :qid user_vstd__raw_ptr__ptrs_mut_eq_24
    :skolemid skolem_user_vstd__raw_ptr__ptrs_mut_eq_24
))))

;; Function-Axioms vstd::raw_ptr::view_reverse_for_eq_sized
(assert
 (forall ((T&. Dcr) (T& Type) (addr! Poly) (provenance! Poly)) (!
   (=>
    (and
     (has_type addr! USIZE)
     (has_type provenance! TYPE%vstd!raw_ptr.Provenance.)
    )
    (has_type (vstd!raw_ptr.view_reverse_for_eq_sized.? T&. T& addr! provenance!) (PTR
      T&. T&
   )))
   :pattern ((vstd!raw_ptr.view_reverse_for_eq_sized.? T&. T& addr! provenance!))
   :qid internal_vstd!raw_ptr.view_reverse_for_eq_sized.?_pre_post_definition
   :skolemid skolem_internal_vstd!raw_ptr.view_reverse_for_eq_sized.?_pre_post_definition
)))

;; Broadcast vstd::raw_ptr::ptrs_mut_eq_sized
(assert
 (=>
  (fuel_bool fuel%vstd!raw_ptr.ptrs_mut_eq_sized.)
  (forall ((T&. Dcr) (T& Type) (a! Poly)) (!
    (=>
     (has_type a! (PTR T&. T&))
     (=>
      (sized T&.)
      (= (vstd!raw_ptr.view_reverse_for_eq_sized.? T&. T& (I (vstd!raw_ptr.PtrData./PtrData/addr
          (%Poly%vstd!raw_ptr.PtrData. (vstd!view.View.view.? $ (PTR T&. T&) a!))
         )
        ) (Poly%vstd!raw_ptr.Provenance. (vstd!raw_ptr.PtrData./PtrData/provenance (%Poly%vstd!raw_ptr.PtrData.
           (vstd!view.View.view.? $ (PTR T&. T&) a!)
        )))
       ) a!
    )))
    :pattern ((vstd!view.View.view.? $ (PTR T&. T&) a!))
    :qid user_vstd__raw_ptr__ptrs_mut_eq_sized_25
    :skolemid skolem_user_vstd__raw_ptr__ptrs_mut_eq_sized_25
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_small_mod
(declare-fun req%vstd!arithmetic.div_mod.lemma_small_mod. (Int Int) Bool)
(declare-const %%global_location_label%%5 Bool)
(declare-const %%global_location_label%%6 Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_small_mod. x! m!) (and
     (=>
      %%global_location_label%%5
      (< x! m!)
     )
     (=>
      %%global_location_label%%6
      (< 0 m!)
   )))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_small_mod. x! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_small_mod._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_small_mod._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_small_mod. (Int Int) Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_small_mod. x! m!) (= (EucMod x! m!) x!))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_small_mod. x! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_small_mod._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_small_mod._definition
)))

;; Function-Axioms vstd::arithmetic::power2::pow2
(assert
 (forall ((e! Poly)) (!
   (=>
    (has_type e! NAT)
    (<= 0 (vstd!arithmetic.power2.pow2.? e!))
   )
   :pattern ((vstd!arithmetic.power2.pow2.? e!))
   :qid internal_vstd!arithmetic.power2.pow2.?_pre_post_definition
   :skolemid skolem_internal_vstd!arithmetic.power2.pow2.?_pre_post_definition
)))

;; Function-Axioms vstd::raw_ptr::impl&%3::view
(assert
 (fuel_bool_default fuel%vstd!raw_ptr.impl&%3.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!raw_ptr.impl&%3.view.)
  (forall ((T&. Dcr) (T& Type) (self! Poly)) (!
    (= (vstd!view.View.view.? (CONST_PTR $) (PTR T&. T&) self!) (vstd!view.View.view.?
      $ (PTR T&. T&) self!
    ))
    :pattern ((vstd!view.View.view.? (CONST_PTR $) (PTR T&. T&) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%vstd!view.View. (CONST_PTR $) (PTR T&. T&))
   :pattern ((tr_bound%vstd!view.View. (CONST_PTR $) (PTR T&. T&)))
   :qid internal_vstd__raw_ptr__impl&__3_trait_impl_definition
   :skolemid skolem_internal_vstd__raw_ptr__impl&__3_trait_impl_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::p
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.p.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.p.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.p.? no%param) (nClip (Sub (vstd!arithmetic.power2.pow2.?
        (I 255)
       ) 19
    )))
    :pattern ((curve25519_dalek!specs.field_specs_u64.p.? no%param))
    :qid internal_curve25519_dalek!specs.field_specs_u64.p.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.p.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (<= 0 (curve25519_dalek!specs.field_specs_u64.p.? no%param))
   )
   :pattern ((curve25519_dalek!specs.field_specs_u64.p.? no%param))
   :qid internal_curve25519_dalek!specs.field_specs_u64.p.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.p.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::field_canonical
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.field_canonical.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.field_canonical.)
  (forall ((n! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.field_canonical.? n!) (EucMod (%I n!) (curve25519_dalek!specs.field_specs_u64.p.?
       (I 0)
    )))
    :pattern ((curve25519_dalek!specs.field_specs_u64.field_canonical.? n!))
    :qid internal_curve25519_dalek!specs.field_specs_u64.field_canonical.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.field_canonical.?_definition
))))
(assert
 (forall ((n! Poly)) (!
   (=>
    (has_type n! NAT)
    (<= 0 (curve25519_dalek!specs.field_specs_u64.field_canonical.? n!))
   )
   :pattern ((curve25519_dalek!specs.field_specs_u64.field_canonical.? n!))
   :qid internal_curve25519_dalek!specs.field_specs_u64.field_canonical.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.field_canonical.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::u64_5_as_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? limbs!) (nClip (Add (nClip
        (Add (nClip (Add (nClip (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
               ) (I 0)
              )
             ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 51)) (%I (vstd!seq.Seq.index.? $ (UINT
                  64
                 ) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 1)
            )))))
           ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 102)) (%I (vstd!seq.Seq.index.? $ (UINT
                64
               ) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 2)
          )))))
         ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 153)) (%I (vstd!seq.Seq.index.? $ (UINT
              64
             ) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 3)
        )))))
       ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 204)) (%I (vstd!seq.Seq.index.? $ (UINT
            64
           ) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 4)
    )))))))
    :pattern ((curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? limbs!))
    :qid internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (<= 0 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? limbs!))
   )
   :pattern ((curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? limbs!))
   :qid internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::u64_5_as_field_canonical
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.? limbs!) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
      (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? limbs!))
    ))
    :pattern ((curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.? limbs!))
    :qid internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (<= 0 (curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.? limbs!))
   )
   :pattern ((curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.? limbs!))
   :qid internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::fe51_as_canonical_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.)
  (forall ((fe! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? fe!) (curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.?
      (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
        (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe!)
    ))))
    :pattern ((curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? fe!))
    :qid internal_curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?_definition
))))
(assert
 (forall ((fe! Poly)) (!
   (=>
    (has_type fe! TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    (<= 0 (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? fe!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? fe!))
   :qid internal_curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_x
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.edwards_specs.edwards_x.?
       point!
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_x.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_x.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_x.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_y
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.edwards_specs.edwards_y.?
       point!
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_y.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_y.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_y.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_z
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.edwards_specs.edwards_z.?
       point!
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_z.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_z.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_z.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_t
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.edwards_specs.edwards_t.?
       point!
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_t.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_t.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_t.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_point_as_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.? point!) (let
      ((x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!specs.edwards_specs.edwards_x.? point!)
      ))))
      (let
       ((y$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!specs.edwards_specs.edwards_y.? point!)
       ))))
       (let
        ((z$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
            (curve25519_dalek!specs.edwards_specs.edwards_z.? point!)
        ))))
        (let
         ((t$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             (curve25519_dalek!specs.edwards_specs.edwards_t.? point!)
         ))))
         (tuple%4./tuple%4 (I x$) (I y$) (I z$) (I t$))
    )))))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.?_definition
))))
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%tuple%4. (curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.?
       point!
      )
     ) (TYPE%tuple%4. $ NAT $ NAT $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::spec_gcd
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.)
)
(declare-const fuel_nat%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.
 Fuel
)
(assert
 (forall ((a! Poly) (b! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.? a! b!
     fuel%
    ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.? a! b!
     zero
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.?
     a! b! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd._fuel_to_zero_definition
)))
(assert
 (forall ((a! Poly) (b! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.? a! b!
      (succ fuel%)
     ) (ite
      (= (%I b!) 0)
      (%I a!)
      (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.? b! (I (EucMod
         (%I a!) (%I b!)
        )
       ) fuel%
   ))))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.?
     a! b! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.)
  (forall ((a! Poly) (b! Poly)) (!
    (=>
     (and
      (has_type a! NAT)
      (has_type b! NAT)
     )
     (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.? a! b!) (
       curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.? a! b! (
        succ fuel_nat%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.
    ))))
    :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.? a!
      b!
    ))
    :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (<= 0 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.? a! b!))
   )
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.? a!
     b!
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.?_pre_post_definition
)))
(assert
 (forall ((a! Poly) (b! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (<= 0 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.? a!
      b! fuel%
   )))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.?
     a! b! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec__spec_gcd.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec__spec_gcd.?_pre_post_rec_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::spec_extended_gcd
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.)
)
(declare-const fuel_nat%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.
 Fuel
)
(assert
 (forall ((a! Poly) (b! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
     a! b! fuel%
    ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
     a! b! zero
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
     a! b! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd._fuel_to_zero_definition
)))
(assert
 (forall ((a! Poly) (b! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
      a! b! (succ fuel%)
     ) (ite
      (= (%I b!) 0)
      (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult
       (%I a!) (%I (I 1)) (%I (I 0))
      )
      (let
       ((r$ (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
          b! (I (EucMod (%I a!) (%I b!))) fuel%
       )))
       (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult
        (%I (I (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd
           (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
             r$
         ))))
        ) (%I (I (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/y
           (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
             r$
         ))))
        ) (%I (I (Sub (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/x
            (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
              r$
            ))
           ) (Mul (EucDiv (%I a!) (%I b!)) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/y
             (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
               r$
   ))))))))))))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
     a! b! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.)
  (forall ((a! Poly) (b! Poly)) (!
    (=>
     (and
      (has_type a! NAT)
      (has_type b! NAT)
     )
     (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?
       a! b!
      ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
       a! b! (succ fuel_nat%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.)
    )))
    :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?
      a! b!
    ))
    :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (has_type (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
      (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.? a!
       b!
      )
     ) TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?
     a! b!
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?_pre_post_definition
)))
(assert
 (forall ((a! Poly) (b! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (has_type (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
      (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
       a! b! fuel%
      )
     ) TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
     a! b! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec__spec_extended_gcd.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec__spec_extended_gcd.?_pre_post_rec_definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::spec_mod_inverse
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.
 (Poly Poly) Bool
)
(declare-const %%global_location_label%%7 Bool)
(declare-const %%global_location_label%%8 Bool)
(assert
 (forall ((a! Poly) (m! Poly)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.
     a! m!
    ) (and
     (=>
      %%global_location_label%%7
      (> (%I m!) 1)
     )
     (=>
      %%global_location_label%%8
      (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.? (I (EucMod
          (%I a!) (%I m!)
         )
        ) m!
       ) 1
   ))))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.
     a! m!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse._definition
)))

;; Function-Axioms curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::spec_mod_inverse
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.)
  (forall ((a! Poly) (m! Poly)) (!
    (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.? a!
      m!
     ) (ite
      (or
       (<= (%I m!) 1)
       (not (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.? (I (EucMod
            (%I a!) (%I m!)
           )
          ) m!
         ) 1
      )))
      0
      (let
       ((r$ (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?
          (I (EucMod (%I a!) (%I m!))) m!
       )))
       (nClip (EucMod (Add (EucMod (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/x
            (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
              r$
            ))
           ) (%I m!)
          ) (%I m!)
         ) (%I m!)
    )))))
    :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?
      a! m!
    ))
    :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?_definition
))))
(assert
 (forall ((a! Poly) (m! Poly)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type m! NAT)
    )
    (<= 0 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?
      a! m!
   )))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?
     a! m!
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::field_inv
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_inv.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_inv.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_inv.? a!) (ite
      (= (EucMod (%I a!) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0)
      0
      (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.? a!
       (I (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
    )))
    :pattern ((curve25519_dalek!specs.field_specs.field_inv.? a!))
    :qid internal_curve25519_dalek!specs.field_specs.field_inv.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_inv.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! NAT)
    (<= 0 (curve25519_dalek!specs.field_specs.field_inv.? a!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_inv.? a!))
   :qid internal_curve25519_dalek!specs.field_specs.field_inv.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_inv.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::field_mul
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_mul.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_mul.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_mul.? a! b!) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
      (I (nClip (Mul (%I a!) (%I b!))))
    ))
    :pattern ((curve25519_dalek!specs.field_specs.field_mul.? a! b!))
    :qid internal_curve25519_dalek!specs.field_specs.field_mul.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_mul.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (<= 0 (curve25519_dalek!specs.field_specs.field_mul.? a! b!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_mul.? a! b!))
   :qid internal_curve25519_dalek!specs.field_specs.field_mul.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_mul.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_point_as_affine
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? point!) (let
      ((tmp%%$ (curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.? point!)))
      (let
       ((x$ (%I (tuple%4./tuple%4/0 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
       (let
        ((y$ (%I (tuple%4./tuple%4/1 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
        (let
         ((z$ (%I (tuple%4./tuple%4/2 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
         (let
          ((_t$ (%I (tuple%4./tuple%4/3 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
          (let
           ((z_inv$ (curve25519_dalek!specs.field_specs.field_inv.? (I z$))))
           (tuple%2./tuple%2 (I (curve25519_dalek!specs.field_specs.field_mul.? (I x$) (I z_inv$)))
            (I (curve25519_dalek!specs.field_specs.field_mul.? (I y$) (I z_inv$)))
    ))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?_definition
))))
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?
       point!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::u64_5_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.u64_5_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.u64_5_bounded.)
  (forall ((limbs! Poly) (bit_limit! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.u64_5_bounded.? limbs! bit_limit!) (forall (
       (i$ Poly)
      ) (!
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 5)
         ))
         (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) limbs!
            ) i$
           )
          ) (uClip 64 (bitshl (I 1) (I (%I bit_limit!))))
       )))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) limbs!
         ) i$
       ))
       :qid user_curve25519_dalek__specs__field_specs__u64_5_bounded_26
       :skolemid skolem_user_curve25519_dalek__specs__field_specs__u64_5_bounded_26
    )))
    :pattern ((curve25519_dalek!specs.field_specs.u64_5_bounded.? limbs! bit_limit!))
    :qid internal_curve25519_dalek!specs.field_specs.u64_5_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.u64_5_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs::fe51_limbs_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.fe51_limbs_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.fe51_limbs_bounded.)
  (forall ((fe! Poly) (bit_limit! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? fe! bit_limit!) (curve25519_dalek!specs.field_specs.u64_5_bounded.?
      (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
        (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe!)
       )
      ) bit_limit!
    ))
    :pattern ((curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? fe! bit_limit!))
    :qid internal_curve25519_dalek!specs.field_specs.fe51_limbs_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.fe51_limbs_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs::field_neg
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_neg.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_neg.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_neg.? a!) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
      (I (nClip (Sub (curve25519_dalek!specs.field_specs_u64.p.? (I 0)) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
          a!
    ))))))
    :pattern ((curve25519_dalek!specs.field_specs.field_neg.? a!))
    :qid internal_curve25519_dalek!specs.field_specs.field_neg.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_neg.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! NAT)
    (<= 0 (curve25519_dalek!specs.field_specs.field_neg.? a!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_neg.? a!))
   :qid internal_curve25519_dalek!specs.field_specs.field_neg.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_neg.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::core_specs::u8_32_as_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat.)
  (forall ((bytes! Poly)) (!
    (= (curve25519_dalek!specs.core_specs.u8_32_as_nat.? bytes!) (nClip (Add (nClip (Add (
          nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (
                          nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (
                                          nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (
                                                          nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Mul (%I (vstd!seq.Seq.index.?
                                                                       $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) bytes!) (
                                                                        I 0
                                                                      ))
                                                                     ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 0 8))))
                                                                    )
                                                                   ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                                          8
                                                                         ) $ (CONST_INT 32)
                                                                        ) bytes!
                                                                       ) (I 1)
                                                                      )
                                                                     ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 1 8))))
                                                                  )))
                                                                 ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                                        8
                                                                       ) $ (CONST_INT 32)
                                                                      ) bytes!
                                                                     ) (I 2)
                                                                    )
                                                                   ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 2 8))))
                                                                )))
                                                               ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                                      8
                                                                     ) $ (CONST_INT 32)
                                                                    ) bytes!
                                                                   ) (I 3)
                                                                  )
                                                                 ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 3 8))))
                                                              )))
                                                             ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                                    8
                                                                   ) $ (CONST_INT 32)
                                                                  ) bytes!
                                                                 ) (I 4)
                                                                )
                                                               ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 4 8))))
                                                            )))
                                                           ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                                  8
                                                                 ) $ (CONST_INT 32)
                                                                ) bytes!
                                                               ) (I 5)
                                                              )
                                                             ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 5 8))))
                                                          )))
                                                         ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                                8
                                                               ) $ (CONST_INT 32)
                                                              ) bytes!
                                                             ) (I 6)
                                                            )
                                                           ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 6 8))))
                                                        )))
                                                       ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                              8
                                                             ) $ (CONST_INT 32)
                                                            ) bytes!
                                                           ) (I 7)
                                                          )
                                                         ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 7 8))))
                                                      )))
                                                     ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                            8
                                                           ) $ (CONST_INT 32)
                                                          ) bytes!
                                                         ) (I 8)
                                                        )
                                                       ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 8 8))))
                                                    )))
                                                   ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                          8
                                                         ) $ (CONST_INT 32)
                                                        ) bytes!
                                                       ) (I 9)
                                                      )
                                                     ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 9 8))))
                                                  )))
                                                 ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                        8
                                                       ) $ (CONST_INT 32)
                                                      ) bytes!
                                                     ) (I 10)
                                                    )
                                                   ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 10 8))))
                                                )))
                                               ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                      8
                                                     ) $ (CONST_INT 32)
                                                    ) bytes!
                                                   ) (I 11)
                                                  )
                                                 ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 11 8))))
                                              )))
                                             ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                    8
                                                   ) $ (CONST_INT 32)
                                                  ) bytes!
                                                 ) (I 12)
                                                )
                                               ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 12 8))))
                                            )))
                                           ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                  8
                                                 ) $ (CONST_INT 32)
                                                ) bytes!
                                               ) (I 13)
                                              )
                                             ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 13 8))))
                                          )))
                                         ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                8
                                               ) $ (CONST_INT 32)
                                              ) bytes!
                                             ) (I 14)
                                            )
                                           ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 14 8))))
                                        )))
                                       ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                              8
                                             ) $ (CONST_INT 32)
                                            ) bytes!
                                           ) (I 15)
                                          )
                                         ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 15 8))))
                                      )))
                                     ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                            8
                                           ) $ (CONST_INT 32)
                                          ) bytes!
                                         ) (I 16)
                                        )
                                       ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 16 8))))
                                    )))
                                   ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                          8
                                         ) $ (CONST_INT 32)
                                        ) bytes!
                                       ) (I 17)
                                      )
                                     ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 17 8))))
                                  )))
                                 ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                        8
                                       ) $ (CONST_INT 32)
                                      ) bytes!
                                     ) (I 18)
                                    )
                                   ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 18 8))))
                                )))
                               ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                      8
                                     ) $ (CONST_INT 32)
                                    ) bytes!
                                   ) (I 19)
                                  )
                                 ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 19 8))))
                              )))
                             ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                    8
                                   ) $ (CONST_INT 32)
                                  ) bytes!
                                 ) (I 20)
                                )
                               ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 20 8))))
                            )))
                           ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                  8
                                 ) $ (CONST_INT 32)
                                ) bytes!
                               ) (I 21)
                              )
                             ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 21 8))))
                          )))
                         ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                8
                               ) $ (CONST_INT 32)
                              ) bytes!
                             ) (I 22)
                            )
                           ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 22 8))))
                        )))
                       ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                              8
                             ) $ (CONST_INT 32)
                            ) bytes!
                           ) (I 23)
                          )
                         ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 23 8))))
                      )))
                     ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                            8
                           ) $ (CONST_INT 32)
                          ) bytes!
                         ) (I 24)
                        )
                       ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 24 8))))
                    )))
                   ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                          8
                         ) $ (CONST_INT 32)
                        ) bytes!
                       ) (I 25)
                      )
                     ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 25 8))))
                  )))
                 ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                        8
                       ) $ (CONST_INT 32)
                      ) bytes!
                     ) (I 26)
                    )
                   ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 26 8))))
                )))
               ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                      8
                     ) $ (CONST_INT 32)
                    ) bytes!
                   ) (I 27)
                  )
                 ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 27 8))))
              )))
             ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                    8
                   ) $ (CONST_INT 32)
                  ) bytes!
                 ) (I 28)
                )
               ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 28 8))))
            )))
           ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                  8
                 ) $ (CONST_INT 32)
                ) bytes!
               ) (I 29)
              )
             ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 29 8))))
          )))
         ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                8
               ) $ (CONST_INT 32)
              ) bytes!
             ) (I 30)
            )
           ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 30 8))))
        )))
       ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
              8
             ) $ (CONST_INT 32)
            ) bytes!
           ) (I 31)
          )
         ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 31 8))))
    )))))
    :pattern ((curve25519_dalek!specs.core_specs.u8_32_as_nat.? bytes!))
    :qid internal_curve25519_dalek!specs.core_specs.u8_32_as_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.core_specs.u8_32_as_nat.?_definition
))))
(assert
 (forall ((bytes! Poly)) (!
   (=>
    (has_type bytes! (ARRAY $ (UINT 8) $ (CONST_INT 32)))
    (<= 0 (curve25519_dalek!specs.core_specs.u8_32_as_nat.? bytes!))
   )
   :pattern ((curve25519_dalek!specs.core_specs.u8_32_as_nat.? bytes!))
   :qid internal_curve25519_dalek!specs.core_specs.u8_32_as_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.u8_32_as_nat.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::backend::serial::u64::constants::EDWARDS_D
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.)
)
(declare-fun %%array%%0 (Poly Poly Poly Poly Poly) %%Function%%)
(assert
 (forall ((%%hole%%0 Poly) (%%hole%%1 Poly) (%%hole%%2 Poly) (%%hole%%3 Poly) (%%hole%%4
    Poly
   )
  ) (!
   (let
    ((%%x%% (%%array%%0 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4)))
    (and
     (= (%%apply%%1 %%x%% 0) %%hole%%0)
     (= (%%apply%%1 %%x%% 1) %%hole%%1)
     (= (%%apply%%1 %%x%% 2) %%hole%%2)
     (= (%%apply%%1 %%x%% 3) %%hole%%3)
     (= (%%apply%%1 %%x%% 4) %%hole%%4)
   ))
   :pattern ((%%array%%0 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4))
   :qid __AIR_ARRAY_QID__
   :skolemid skolem___AIR_ARRAY_QID__
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.)
  (= curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.? (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
    (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I 929955233495203) (I 466365720129213)
       (I 1662059464998953) (I 2033849074728123) (I 1442794654840575)
)))))))
(assert
 (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?)
  TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Function-Axioms curve25519_dalek::specs::field_specs::field_square
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_square.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_square.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_square.? a!) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
      (I (nClip (Mul (%I a!) (%I a!))))
    ))
    :pattern ((curve25519_dalek!specs.field_specs.field_square.? a!))
    :qid internal_curve25519_dalek!specs.field_specs.field_square.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_square.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! NAT)
    (<= 0 (curve25519_dalek!specs.field_specs.field_square.? a!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_square.? a!))
   :qid internal_curve25519_dalek!specs.field_specs.field_square.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_square.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::field_sub
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_sub.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_sub.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_sub.? a! b!) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
      (I (nClip (Sub (nClip (Add (curve25519_dalek!specs.field_specs_u64.field_canonical.? a!)
           (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
          )
         ) (curve25519_dalek!specs.field_specs_u64.field_canonical.? b!)
    )))))
    :pattern ((curve25519_dalek!specs.field_specs.field_sub.? a! b!))
    :qid internal_curve25519_dalek!specs.field_specs.field_sub.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_sub.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (<= 0 (curve25519_dalek!specs.field_specs.field_sub.? a! b!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_sub.? a! b!))
   :qid internal_curve25519_dalek!specs.field_specs.field_sub.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_sub.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::field_add
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_add.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_add.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_add.? a! b!) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
      (I (nClip (Add (%I a!) (%I b!))))
    ))
    :pattern ((curve25519_dalek!specs.field_specs.field_add.? a! b!))
    :qid internal_curve25519_dalek!specs.field_specs.field_add.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_add.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (<= 0 (curve25519_dalek!specs.field_specs.field_add.? a! b!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_add.? a! b!))
   :qid internal_curve25519_dalek!specs.field_specs.field_add.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_add.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_on_edwards_curve_projective
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.)
  (forall ((x! Poly) (y! Poly) (z! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.? x! y! z!)
     (let
      ((d$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?
      ))))
      (let
       ((x2$ (curve25519_dalek!specs.field_specs.field_square.? x!)))
       (let
        ((y2$ (curve25519_dalek!specs.field_specs.field_square.? y!)))
        (let
         ((z2$ (curve25519_dalek!specs.field_specs.field_square.? z!)))
         (let
          ((z4$ (curve25519_dalek!specs.field_specs.field_square.? (I z2$))))
          (let
           ((lhs$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_sub.?
                (I y2$) (I x2$)
               )
              ) (I z2$)
           )))
           (let
            ((rhs$ (curve25519_dalek!specs.field_specs.field_add.? (I z4$) (I (curve25519_dalek!specs.field_specs.field_mul.?
                 (I d$) (I (curve25519_dalek!specs.field_specs.field_mul.? (I x2$) (I y2$)))
            )))))
            (= lhs$ rhs$)
    ))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.? x!
      y! z!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_valid_extended_edwards_point
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.)
  (forall ((x! Poly) (y! Poly) (z! Poly) (t! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.? x! y! z!
      t!
     ) (and
      (and
       (not (= (curve25519_dalek!specs.field_specs_u64.field_canonical.? z!) 0))
       (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.? x! y! z!)
      )
      (= (curve25519_dalek!specs.field_specs.field_mul.? x! y!) (curve25519_dalek!specs.field_specs.field_mul.?
        z! t!
    ))))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.? x!
      y! z! t!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_valid_edwards_point
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? point!) (let
      ((x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!specs.edwards_specs.edwards_x.? point!)
      ))))
      (let
       ((y$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!specs.edwards_specs.edwards_y.? point!)
       ))))
       (let
        ((z$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
            (curve25519_dalek!specs.edwards_specs.edwards_z.? point!)
        ))))
        (let
         ((t$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             (curve25519_dalek!specs.edwards_specs.edwards_t.? point!)
         ))))
         (curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.? (I x$) (I y$)
          (I z$) (I t$)
    ))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_point_limbs_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.? point!) (and
      (and
       (and
        (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!specs.edwards_specs.edwards_x.? point!)
         ) (I 52)
        )
        (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!specs.edwards_specs.edwards_y.? point!)
         ) (I 52)
       ))
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
         (curve25519_dalek!specs.edwards_specs.edwards_z.? point!)
        ) (I 52)
      ))
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!specs.edwards_specs.edwards_t.? point!)
       ) (I 52)
    )))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_identity
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_identity.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_identity.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_identity.? no%param) (tuple%2./tuple%2
      (I 0) (I 1)
    ))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_identity.? no%param))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_identity.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_identity.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_identity.? no%param))
     (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_identity.? no%param))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_identity.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_identity.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_add
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_add.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_add.)
  (forall ((x1! Poly) (y1! Poly) (x2! Poly) (y2! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_add.? x1! y1! x2! y2!) (let
      ((d$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?
      ))))
      (let
       ((x1x2$ (curve25519_dalek!specs.field_specs.field_mul.? x1! x2!)))
       (let
        ((y1y2$ (curve25519_dalek!specs.field_specs.field_mul.? y1! y2!)))
        (let
         ((x1y2$ (curve25519_dalek!specs.field_specs.field_mul.? x1! y2!)))
         (let
          ((y1x2$ (curve25519_dalek!specs.field_specs.field_mul.? y1! x2!)))
          (let
           ((t$ (curve25519_dalek!specs.field_specs.field_mul.? (I d$) (I (curve25519_dalek!specs.field_specs.field_mul.?
                (I x1x2$) (I y1y2$)
           )))))
           (let
            ((denom_x$ (curve25519_dalek!specs.field_specs.field_add.? (I 1) (I t$))))
            (let
             ((denom_y$ (curve25519_dalek!specs.field_specs.field_sub.? (I 1) (I t$))))
             (let
              ((x3$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_add.?
                   (I x1y2$) (I y1x2$)
                  )
                 ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I denom_x$)))
              )))
              (let
               ((y3$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_add.?
                    (I y1y2$) (I x1x2$)
                   )
                  ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I denom_y$)))
               )))
               (tuple%2./tuple%2 (I x3$) (I y3$))
    )))))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_add.? x1! y1! x2! y2!))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_add.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_add.?_definition
))))
(assert
 (forall ((x1! Poly) (y1! Poly) (x2! Poly) (y2! Poly)) (!
   (=>
    (and
     (has_type x1! NAT)
     (has_type y1! NAT)
     (has_type x2! NAT)
     (has_type y2! NAT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_add.? x1! y1!
       x2! y2!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_add.? x1! y1! x2! y2!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_add.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_add.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_double
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_double.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_double.)
  (forall ((x! Poly) (y! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_double.? x! y!) (curve25519_dalek!specs.edwards_specs.edwards_add.?
      x! y! x! y!
    ))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_double.? x! y!))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_double.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_double.?_definition
))))
(assert
 (forall ((x! Poly) (y! Poly)) (!
   (=>
    (and
     (has_type x! NAT)
     (has_type y! NAT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_double.? x! y!))
     (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_double.? x! y!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_double.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_double.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_scalar_mul
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.)
)
(declare-const fuel_nat%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul. Fuel)
(assert
 (forall ((point_affine! Poly) (n! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? point_affine! n!
     fuel%
    ) (curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? point_affine! n!
     zero
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? point_affine!
     n! fuel%
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul._fuel_to_zero_definition
)))
(assert
 (forall ((point_affine! Poly) (n! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type point_affine! (TYPE%tuple%2. $ NAT $ NAT))
     (has_type n! NAT)
    )
    (= (curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? point_affine! n!
      (succ fuel%)
     ) (ite
      (= (%I n!) 0)
      (curve25519_dalek!specs.edwards_specs.edwards_identity.? (I 0))
      (ite
       (= (%I n!) 1)
       (%Poly%tuple%2. point_affine!)
       (ite
        (= (EucMod (%I n!) 2) 0)
        (let
         ((half$ (curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? point_affine!
            (I (EucDiv (%I n!) 2)) fuel%
         )))
         (curve25519_dalek!specs.edwards_specs.edwards_double.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
            (Poly%tuple%2. half$)
           )
          ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. half$)))
        ))
        (let
         ((prev$ (curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? point_affine!
            (I (nClip (Sub (%I n!) 1))) fuel%
         )))
         (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
            (Poly%tuple%2. prev$)
           )
          ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. prev$))) (tuple%2./tuple%2/0
           (%Poly%tuple%2. point_affine!)
          ) (tuple%2./tuple%2/1 (%Poly%tuple%2. point_affine!))
   )))))))
   :pattern ((curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? point_affine!
     n! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.)
  (forall ((point_affine! Poly) (n! Poly)) (!
    (=>
     (and
      (has_type point_affine! (TYPE%tuple%2. $ NAT $ NAT))
      (has_type n! NAT)
     )
     (= (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? point_affine! n!) (curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.?
       point_affine! n! (succ fuel_nat%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.)
    )))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? point_affine!
      n!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.?_definition
))))
(assert
 (forall ((point_affine! Poly) (n! Poly)) (!
   (=>
    (and
     (has_type point_affine! (TYPE%tuple%2. $ NAT $ NAT))
     (has_type n! NAT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.?
       point_affine! n!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? point_affine!
     n!
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.?_pre_post_definition
)))
(assert
 (forall ((point_affine! Poly) (n! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type point_affine! (TYPE%tuple%2. $ NAT $ NAT))
     (has_type n! NAT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.?
       point_affine! n! fuel%
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? point_affine!
     n! fuel%
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.rec__edwards_scalar_mul.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.rec__edwards_scalar_mul.?_pre_post_rec_definition
)))

;; Function-Axioms vstd::seq::impl&%0::take
(assert
 (fuel_bool_default fuel%vstd!seq.impl&%0.take.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!seq.impl&%0.take.)
  (forall ((A&. Dcr) (A& Type) (self! Poly) (n! Poly)) (!
    (= (vstd!seq.impl&%0.take.? A&. A& self! n!) (vstd!seq.Seq.subrange.? A&. A& self!
      (I 0) n!
    ))
    :pattern ((vstd!seq.impl&%0.take.? A&. A& self! n!))
    :qid internal_vstd!seq.impl&__0.take.?_definition
    :skolemid skolem_internal_vstd!seq.impl&__0.take.?_definition
))))
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (n! Poly)) (!
   (=>
    (and
     (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
     (has_type n! INT)
    )
    (has_type (vstd!seq.impl&%0.take.? A&. A& self! n!) (TYPE%vstd!seq.Seq. A&. A&))
   )
   :pattern ((vstd!seq.impl&%0.take.? A&. A& self! n!))
   :qid internal_vstd!seq.impl&__0.take.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.impl&__0.take.?_pre_post_definition
)))

;; Function-Axioms vstd::seq::impl&%0::skip
(assert
 (fuel_bool_default fuel%vstd!seq.impl&%0.skip.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!seq.impl&%0.skip.)
  (forall ((A&. Dcr) (A& Type) (self! Poly) (n! Poly)) (!
    (= (vstd!seq.impl&%0.skip.? A&. A& self! n!) (vstd!seq.Seq.subrange.? A&. A& self!
      n! (I (vstd!seq.Seq.len.? A&. A& self!))
    ))
    :pattern ((vstd!seq.impl&%0.skip.? A&. A& self! n!))
    :qid internal_vstd!seq.impl&__0.skip.?_definition
    :skolemid skolem_internal_vstd!seq.impl&__0.skip.?_definition
))))
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (n! Poly)) (!
   (=>
    (and
     (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
     (has_type n! INT)
    )
    (has_type (vstd!seq.impl&%0.skip.? A&. A& self! n!) (TYPE%vstd!seq.Seq. A&. A&))
   )
   :pattern ((vstd!seq.impl&%0.skip.? A&. A& self! n!))
   :qid internal_vstd!seq.impl&__0.skip.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.impl&__0.skip.?_pre_post_definition
)))

;; Function-Specs vstd::seq::Seq::last
(declare-fun req%vstd!seq.Seq.last. (Dcr Type Poly) Bool)
(declare-const %%global_location_label%%9 Bool)
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
   (= (req%vstd!seq.Seq.last. A&. A& self!) (=>
     %%global_location_label%%9
     (< 0 (vstd!seq.Seq.len.? A&. A& self!))
   ))
   :pattern ((req%vstd!seq.Seq.last. A&. A& self!))
   :qid internal_req__vstd!seq.Seq.last._definition
   :skolemid skolem_internal_req__vstd!seq.Seq.last._definition
)))

;; Function-Axioms vstd::seq::Seq::last
(assert
 (fuel_bool_default fuel%vstd!seq.Seq.last.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!seq.Seq.last.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (= (vstd!seq.Seq.last.? A&. A& self!) (vstd!seq.Seq.index.? A&. A& self! (I (Sub (vstd!seq.Seq.len.?
         A&. A& self!
        ) 1
    ))))
    :pattern ((vstd!seq.Seq.last.? A&. A& self!))
    :qid internal_vstd!seq.Seq.last.?_definition
    :skolemid skolem_internal_vstd!seq.Seq.last.?_definition
))))
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
   (=>
    (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
    (has_type (vstd!seq.Seq.last.? A&. A& self!) A&)
   )
   :pattern ((vstd!seq.Seq.last.? A&. A& self!))
   :qid internal_vstd!seq.Seq.last.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.last.?_pre_post_definition
)))

;; Function-Specs vstd::seq_lib::impl&%0::drop_last
(declare-fun req%vstd!seq_lib.impl&%0.drop_last. (Dcr Type Poly) Bool)
(declare-const %%global_location_label%%10 Bool)
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
   (= (req%vstd!seq_lib.impl&%0.drop_last. A&. A& self!) (=>
     %%global_location_label%%10
     (>= (vstd!seq.Seq.len.? A&. A& self!) 1)
   ))
   :pattern ((req%vstd!seq_lib.impl&%0.drop_last. A&. A& self!))
   :qid internal_req__vstd!seq_lib.impl&__0.drop_last._definition
   :skolemid skolem_internal_req__vstd!seq_lib.impl&__0.drop_last._definition
)))

;; Function-Axioms vstd::seq_lib::impl&%0::drop_last
(assert
 (fuel_bool_default fuel%vstd!seq_lib.impl&%0.drop_last.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!seq_lib.impl&%0.drop_last.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (= (vstd!seq_lib.impl&%0.drop_last.? A&. A& self!) (vstd!seq.Seq.subrange.? A&. A&
      self! (I 0) (I (Sub (vstd!seq.Seq.len.? A&. A& self!) 1))
    ))
    :pattern ((vstd!seq_lib.impl&%0.drop_last.? A&. A& self!))
    :qid internal_vstd!seq_lib.impl&__0.drop_last.?_definition
    :skolemid skolem_internal_vstd!seq_lib.impl&__0.drop_last.?_definition
))))
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
   (=>
    (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
    (has_type (vstd!seq_lib.impl&%0.drop_last.? A&. A& self!) (TYPE%vstd!seq.Seq. A&. A&))
   )
   :pattern ((vstd!seq_lib.impl&%0.drop_last.? A&. A& self!))
   :qid internal_vstd!seq_lib.impl&__0.drop_last.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq_lib.impl&__0.drop_last.?_pre_post_definition
)))

;; Function-Axioms vstd::view::impl&%0::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%0.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%0.view.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (tr_bound%vstd!view.View. A&. A&)
     (= (vstd!view.View.view.? (REF A&.) A& self!) (vstd!view.View.view.? A&. A& self!))
    )
    :pattern ((vstd!view.View.view.? (REF A&.) A& self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%2::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%2.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%2.view.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (tr_bound%vstd!view.View. A&. A&)
     (= (vstd!view.View.view.? (BOX $ ALLOCATOR_GLOBAL A&.) A& self!) (vstd!view.View.view.?
       A&. A& self!
    )))
    :pattern ((vstd!view.View.view.? (BOX $ ALLOCATOR_GLOBAL A&.) A& self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%4::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%4.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%4.view.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!view.View. A&. A&)
     )
     (= (vstd!view.View.view.? (RC $ ALLOCATOR_GLOBAL A&.) A& self!) (vstd!view.View.view.?
       A&. A& self!
    )))
    :pattern ((vstd!view.View.view.? (RC $ ALLOCATOR_GLOBAL A&.) A& self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%6::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%6.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%6.view.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!view.View. A&. A&)
     )
     (= (vstd!view.View.view.? (ARC $ ALLOCATOR_GLOBAL A&.) A& self!) (vstd!view.View.view.?
       A&. A& self!
    )))
    :pattern ((vstd!view.View.view.? (ARC $ ALLOCATOR_GLOBAL A&.) A& self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%12::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%12.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%12.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ TYPE%tuple%0. self!) self!)
    :pattern ((vstd!view.View.view.? $ TYPE%tuple%0. self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%14::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%14.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%14.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ BOOL self!) self!)
    :pattern ((vstd!view.View.view.? $ BOOL self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%16::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%16.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%16.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ (UINT 8) self!) self!)
    :pattern ((vstd!view.View.view.? $ (UINT 8) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%22::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%22.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%22.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ (UINT 64) self!) self!)
    :pattern ((vstd!view.View.view.? $ (UINT 64) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%26::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%26.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%26.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ USIZE self!) self!)
    :pattern ((vstd!view.View.view.? $ USIZE self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%28::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%28.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%28.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ (SINT 8) self!) self!)
    :pattern ((vstd!view.View.view.? $ (SINT 8) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%44::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%44.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%44.view.)
  (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (self! Poly)) (!
    (=>
     (and
      (sized A0&.)
      (sized A1&.)
      (tr_bound%vstd!view.View. A0&. A0&)
      (tr_bound%vstd!view.View. A1&. A1&)
     )
     (= (vstd!view.View.view.? (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&) self!) (Poly%tuple%2.
       (tuple%2./tuple%2 (vstd!view.View.view.? A0&. A0& (tuple%2./tuple%2/0 (%Poly%tuple%2.
           self!
         ))
        ) (vstd!view.View.view.? A1&. A1& (tuple%2./tuple%2/1 (%Poly%tuple%2. self!)))
    ))))
    :pattern ((vstd!view.View.view.? (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%48::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%48.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%48.view.)
  (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type) (A3&. Dcr)
    (A3& Type) (self! Poly)
   ) (!
    (=>
     (and
      (sized A0&.)
      (sized A1&.)
      (sized A2&.)
      (sized A3&.)
      (tr_bound%vstd!view.View. A0&. A0&)
      (tr_bound%vstd!view.View. A1&. A1&)
      (tr_bound%vstd!view.View. A2&. A2&)
      (tr_bound%vstd!view.View. A3&. A3&)
     )
     (= (vstd!view.View.view.? (DST A3&.) (TYPE%tuple%4. A0&. A0& A1&. A1& A2&. A2& A3&.
        A3&
       ) self!
      ) (Poly%tuple%4. (tuple%4./tuple%4 (vstd!view.View.view.? A0&. A0& (tuple%4./tuple%4/0
          (%Poly%tuple%4. self!)
         )
        ) (vstd!view.View.view.? A1&. A1& (tuple%4./tuple%4/1 (%Poly%tuple%4. self!))) (vstd!view.View.view.?
         A2&. A2& (tuple%4./tuple%4/2 (%Poly%tuple%4. self!))
        ) (vstd!view.View.view.? A3&. A3& (tuple%4./tuple%4/3 (%Poly%tuple%4. self!)))
    ))))
    :pattern ((vstd!view.View.view.? (DST A3&.) (TYPE%tuple%4. A0&. A0& A1&. A1& A2&. A2&
       A3&. A3&
      ) self!
    ))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_scalar_mul_signed
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.)
  (forall ((point_affine! Poly) (n! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? point_affine!
      n!
     ) (ite
      (>= (%I n!) 0)
      (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? point_affine! (I (nClip (
          %I n!
      ))))
      (let
       ((tmp%%$ (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? point_affine! (I
           (nClip (Sub 0 (%I n!)))
       ))))
       (let
        ((x$ (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$))))))
        (let
         ((y$ (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$))))))
         (tuple%2./tuple%2 (I (curve25519_dalek!specs.field_specs.field_neg.? (I x$))) (I y$))
    )))))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? point_affine!
      n!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.?_definition
))))
(assert
 (forall ((point_affine! Poly) (n! Poly)) (!
   (=>
    (and
     (has_type point_affine! (TYPE%tuple%2. $ NAT $ NAT))
     (has_type n! INT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.?
       point_affine! n!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? point_affine!
     n!
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::projective_niels_point_as_affine_edwards
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.)
  (forall ((niels! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
      niels!
     ) (let
      ((y_plus_x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
           (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. niels!)
      )))))
      (let
       ((y_minus_x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
            (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. niels!)
       )))))
       (let
        ((z$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
            (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
             (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. niels!)
        )))))
        (let
         ((x_proj$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_sub.?
              (I y_plus_x$) (I y_minus_x$)
             )
            ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I 2)))
         )))
         (let
          ((y_proj$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_add.?
               (I y_plus_x$) (I y_minus_x$)
              )
             ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I 2)))
          )))
          (let
           ((z_inv$ (curve25519_dalek!specs.field_specs.field_inv.? (I z$))))
           (let
            ((x$ (curve25519_dalek!specs.field_specs.field_mul.? (I x_proj$) (I z_inv$))))
            (let
             ((y$ (curve25519_dalek!specs.field_specs.field_mul.? (I y_proj$) (I z_inv$))))
             (tuple%2./tuple%2 (I x$) (I y$))
    )))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
      niels!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?_definition
))))
(assert
 (forall ((niels! Poly)) (!
   (=>
    (has_type niels! TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
       niels!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
     niels!
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::sp_points_affine
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.sp_points_affine.)
)
(declare-fun %%lambda%%1 (Dcr Type Poly) %%Function%%)
(assert
 (forall ((%%hole%%0 Dcr) (%%hole%%1 Type) (%%hole%%2 Poly) (i$ Poly)) (!
   (= (%%apply%%0 (%%lambda%%1 %%hole%%0 %%hole%%1 %%hole%%2) i$) (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
      (tuple%2./tuple%2/1 (%Poly%tuple%2. (vstd!seq.Seq.index.? %%hole%%0 %%hole%%1 %%hole%%2
         i$
   ))))))
   :pattern ((%%apply%%0 (%%lambda%%1 %%hole%%0 %%hole%%1 %%hole%%2) i$))
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.sp_points_affine.)
  (forall ((sp! Poly)) (!
    (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.sp_points_affine.? sp!)
     (%Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. (vstd!seq.Seq.new.? (DST $) (TYPE%tuple%2.
        $ NAT $ NAT
       ) $ (TYPE%fun%1. $ INT (DST $) (TYPE%tuple%2. $ NAT $ NAT)) (I (vstd!seq.Seq.len.?
         (DST $) (TYPE%tuple%2. $ (ARRAY $ (SINT 8) $ (CONST_INT 64)) $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
         sp!
        )
       ) (Poly%fun%1. (mk_fun (%%lambda%%1 (DST $) (TYPE%tuple%2. $ (ARRAY $ (SINT 8) $ (CONST_INT
             64
            )
           ) $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
          ) sp!
    ))))))
    :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.sp_points_affine.?
      sp!
    ))
    :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.sp_points_affine.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.sp_points_affine.?_definition
))))

;; Function-Axioms curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::sp_digits_seqs
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.sp_digits_seqs.)
)
(declare-fun %%lambda%%2 (Dcr Type Poly Dcr Type) %%Function%%)
(assert
 (forall ((%%hole%%0 Dcr) (%%hole%%1 Type) (%%hole%%2 Poly) (%%hole%%3 Dcr) (%%hole%%4
    Type
   ) (i$ Poly)
  ) (!
   (= (%%apply%%0 (%%lambda%%2 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4) i$)
    (vstd!view.View.view.? %%hole%%3 %%hole%%4 (tuple%2./tuple%2/0 (%Poly%tuple%2. (vstd!seq.Seq.index.?
        %%hole%%0 %%hole%%1 %%hole%%2 i$
   )))))
   :pattern ((%%apply%%0 (%%lambda%%2 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4)
     i$
)))))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.sp_digits_seqs.)
  (forall ((sp! Poly)) (!
    (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.sp_digits_seqs.? sp!)
     (%Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. (vstd!seq.Seq.new.? $ (TYPE%vstd!seq.Seq. $
        (SINT 8)
       ) $ (TYPE%fun%1. $ INT $ (TYPE%vstd!seq.Seq. $ (SINT 8))) (I (vstd!seq.Seq.len.? (DST
          $
         ) (TYPE%tuple%2. $ (ARRAY $ (SINT 8) $ (CONST_INT 64)) $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
         sp!
        )
       ) (Poly%fun%1. (mk_fun (%%lambda%%2 (DST $) (TYPE%tuple%2. $ (ARRAY $ (SINT 8) $ (CONST_INT
             64
            )
           ) $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
          ) sp! $ (ARRAY $ (SINT 8) $ (CONST_INT 64))
    ))))))
    :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.sp_digits_seqs.?
      sp!
    ))
    :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.sp_digits_seqs.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.sp_digits_seqs.?_definition
))))

;; Function-Axioms curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::sp_digit_count
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.sp_digit_count.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.sp_digit_count.)
  (forall ((w! Poly)) (!
    (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.sp_digit_count.? w!) (
      ite
      (< (%I w!) 8)
      (nClip (EucDiv (Sub (Add 256 (%I w!)) 1) (%I w!)))
      (nClip (Add (EucDiv (Sub (Add 256 (%I w!)) 1) (%I w!)) 1))
    ))
    :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.sp_digit_count.?
      w!
    ))
    :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.sp_digit_count.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.sp_digit_count.?_definition
))))
(assert
 (forall ((w! Poly)) (!
   (=>
    (has_type w! NAT)
    (<= 0 (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.sp_digit_count.? w!))
   )
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.sp_digit_count.?
     w!
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.sp_digit_count.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.sp_digit_count.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::scalar_specs::is_valid_radix_2w
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar_specs.is_valid_radix_2w.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar_specs.is_valid_radix_2w.)
  (forall ((digits! Poly) (w! Poly) (digits_count! Poly)) (!
    (= (curve25519_dalek!specs.scalar_specs.is_valid_radix_2w.? digits! w! digits_count!)
     (and
      (and
       (let
        ((tmp%%$ (%I w!)))
        (and
         (<= 4 tmp%%$)
         (<= tmp%%$ 8)
       ))
       (<= (%I digits_count!) 64)
      )
      (forall ((i$ Poly)) (!
        (=>
         (has_type i$ INT)
         (=>
          (let
           ((tmp%%$ (%I i$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ (%I digits_count!))
          ))
          (let
           ((bound$ (vstd!arithmetic.power2.pow2.? (I (nClip (Sub (%I w!) 1))))))
           (ite
            (< (%I i$) (Sub (%I digits_count!) 1))
            (and
             (<= (Sub 0 bound$) (%I (vstd!seq.Seq.index.? $ (SINT 8) (vstd!view.View.view.? $ (ARRAY
                  $ (SINT 8) $ (CONST_INT 64)
                 ) digits!
                ) i$
             )))
             (< (%I (vstd!seq.Seq.index.? $ (SINT 8) (vstd!view.View.view.? $ (ARRAY $ (SINT 8) $ (
                   CONST_INT 64
                  )
                 ) digits!
                ) i$
               )
              ) bound$
            ))
            (and
             (<= (Sub 0 bound$) (%I (vstd!seq.Seq.index.? $ (SINT 8) (vstd!view.View.view.? $ (ARRAY
                  $ (SINT 8) $ (CONST_INT 64)
                 ) digits!
                ) i$
             )))
             (<= (%I (vstd!seq.Seq.index.? $ (SINT 8) (vstd!view.View.view.? $ (ARRAY $ (SINT 8) $
                  (CONST_INT 64)
                 ) digits!
                ) i$
               )
              ) bound$
        ))))))
        :pattern ((vstd!seq.Seq.index.? $ (SINT 8) (vstd!view.View.view.? $ (ARRAY $ (SINT 8)
            $ (CONST_INT 64)
           ) digits!
          ) i$
         ) (vstd!seq.Seq.index.? $ (SINT 8) (vstd!view.View.view.? $ (ARRAY $ (SINT 8) $ (CONST_INT
             64
            )
           ) digits!
          ) i$
         ) (vstd!seq.Seq.index.? $ (SINT 8) (vstd!view.View.view.? $ (ARRAY $ (SINT 8) $ (CONST_INT
             64
            )
           ) digits!
          ) i$
         ) (vstd!seq.Seq.index.? $ (SINT 8) (vstd!view.View.view.? $ (ARRAY $ (SINT 8) $ (CONST_INT
             64
            )
           ) digits!
          ) i$
        ))
        :qid user_curve25519_dalek__specs__scalar_specs__is_valid_radix_2w_27
        :skolemid skolem_user_curve25519_dalek__specs__scalar_specs__is_valid_radix_2w_27
    ))))
    :pattern ((curve25519_dalek!specs.scalar_specs.is_valid_radix_2w.? digits! w! digits_count!))
    :qid internal_curve25519_dalek!specs.scalar_specs.is_valid_radix_2w.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar_specs.is_valid_radix_2w.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::projective_niels_corresponds_to_edwards
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.)
  (forall ((niels! Poly) (point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.?
      niels! point!
     ) (let
      ((tmp%%$ (curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.? point!)))
      (let
       ((x$ (%I (tuple%4./tuple%4/0 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
       (let
        ((y$ (%I (tuple%4./tuple%4/1 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
        (let
         ((z$ (%I (tuple%4./tuple%4/2 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
         (let
          ((t$ (%I (tuple%4./tuple%4/3 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
          (let
           ((d$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
               curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?
           ))))
           (let
            ((y_plus_x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
                 (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. niels!)
            )))))
            (let
             ((y_minus_x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
                  (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. niels!)
             )))))
             (let
              ((niels_z$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                  (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
                   (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. niels!)
              )))))
              (let
               ((t2d$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                   (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
                    (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. niels!)
               )))))
               (and
                (and
                 (and
                  (= y_plus_x$ (curve25519_dalek!specs.field_specs.field_add.? (I y$) (I x$)))
                  (= y_minus_x$ (curve25519_dalek!specs.field_specs.field_sub.? (I y$) (I x$)))
                 )
                 (= niels_z$ z$)
                )
                (= t2d$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_mul.?
                    (I 2) (I d$)
                   )
                  ) (I t$)
    ))))))))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.?
      niels! point!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_valid_projective_niels_point
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.)
  (forall ((niels! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? niels!)
     (exists ((point$ Poly)) (!
       (and
        (has_type point$ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
        (and
         (and
          (curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? point$)
          (curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.? point$)
         )
         (curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.? niels!
          point$
       )))
       :pattern ((curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.?
         niels! point$
       ))
       :qid user_curve25519_dalek__specs__edwards_specs__is_valid_projective_niels_point_28
       :skolemid skolem_user_curve25519_dalek__specs__edwards_specs__is_valid_projective_niels_point_28
    )))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? niels!))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.?_definition
))))

;; Function-Axioms curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::pippenger_input_valid
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_input_valid.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_input_valid.)
  (forall ((scalars_points! Poly) (pts_affine! Poly) (digits_seqs! Poly) (w! Poly) (dc!
     Poly
    )
   ) (!
    (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_input_valid.?
      scalars_points! pts_affine! digits_seqs! w! dc!
     ) (let
      ((n$ (vstd!seq.Seq.len.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) pts_affine!)))
      (and
       (and
        (and
         (and
          (and
           (and
            (and
             (and
              (and
               (and
                (= (vstd!seq.Seq.len.? (DST $) (TYPE%tuple%2. $ (ARRAY $ (SINT 8) $ (CONST_INT 64))
                   $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                  ) scalars_points!
                 ) n$
                )
                (= (vstd!seq.Seq.len.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) digits_seqs!) n$)
               )
               (forall ((k$ Poly)) (!
                 (=>
                  (has_type k$ INT)
                  (=>
                   (let
                    ((tmp%%$ (%I k$)))
                    (and
                     (<= 0 tmp%%$)
                     (< tmp%%$ n$)
                   ))
                   (curve25519_dalek!specs.scalar_specs.is_valid_radix_2w.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
                      (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ (ARRAY $ (SINT 8) $ (CONST_INT 64))
                        $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                       ) scalars_points! k$
                     ))
                    ) w! dc!
                 )))
                 :pattern ((vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ (ARRAY $ (SINT 8) $ (CONST_INT
                      64
                     )
                    ) $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                   ) scalars_points! k$
                 ))
                 :qid user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__pippenger_input_valid_29
                 :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__pippenger_input_valid_29
              )))
              (forall ((k$ Poly)) (!
                (=>
                 (has_type k$ INT)
                 (=>
                  (let
                   ((tmp%%$ (%I k$)))
                   (and
                    (<= 0 tmp%%$)
                    (< tmp%%$ n$)
                  ))
                  (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? (tuple%2./tuple%2/1
                    (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ (ARRAY $ (SINT 8) $ (CONST_INT
                         64
                        )
                       ) $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                      ) scalars_points! k$
                ))))))
                :pattern ((vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ (ARRAY $ (SINT 8) $ (CONST_INT
                     64
                    )
                   ) $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                  ) scalars_points! k$
                ))
                :qid user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__pippenger_input_valid_30
                :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__pippenger_input_valid_30
             )))
             (forall ((k$ Poly)) (!
               (=>
                (has_type k$ INT)
                (=>
                 (let
                  ((tmp%%$ (%I k$)))
                  (and
                   (<= 0 tmp%%$)
                   (< tmp%%$ n$)
                 ))
                 (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                   (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
                    (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (tuple%2./tuple%2/1
                      (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ (ARRAY $ (SINT 8) $ (CONST_INT
                           64
                          )
                         ) $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                        ) scalars_points! k$
                   )))))
                  ) (I 54)
               )))
               :pattern ((vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ (ARRAY $ (SINT 8) $ (CONST_INT
                    64
                   )
                  ) $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                 ) scalars_points! k$
               ))
               :qid user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__pippenger_input_valid_31
               :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__pippenger_input_valid_31
            )))
            (forall ((k$ Poly)) (!
              (=>
               (has_type k$ INT)
               (=>
                (let
                 ((tmp%%$ (%I k$)))
                 (and
                  (<= 0 tmp%%$)
                  (< tmp%%$ n$)
                ))
                (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                  (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
                   (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (tuple%2./tuple%2/1
                     (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ (ARRAY $ (SINT 8) $ (CONST_INT
                          64
                         )
                        ) $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                       ) scalars_points! k$
                  )))))
                 ) (I 54)
              )))
              :pattern ((vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ (ARRAY $ (SINT 8) $ (CONST_INT
                   64
                  )
                 ) $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                ) scalars_points! k$
              ))
              :qid user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__pippenger_input_valid_32
              :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__pippenger_input_valid_32
           )))
           (forall ((k$ Poly)) (!
             (=>
              (has_type k$ INT)
              (=>
               (let
                ((tmp%%$ (%I k$)))
                (and
                 (<= 0 tmp%%$)
                 (< tmp%%$ n$)
               ))
               (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
                  (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (tuple%2./tuple%2/1
                    (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ (ARRAY $ (SINT 8) $ (CONST_INT
                         64
                        )
                       ) $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                      ) scalars_points! k$
                 )))))
                ) (I 54)
             )))
             :pattern ((vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ (ARRAY $ (SINT 8) $ (CONST_INT
                  64
                 )
                ) $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
               ) scalars_points! k$
             ))
             :qid user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__pippenger_input_valid_33
             :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__pippenger_input_valid_33
          )))
          (forall ((k$ Poly)) (!
            (=>
             (has_type k$ INT)
             (=>
              (let
               ((tmp%%$ (%I k$)))
               (and
                (<= 0 tmp%%$)
                (< tmp%%$ n$)
              ))
              (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
                 (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (tuple%2./tuple%2/1
                   (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ (ARRAY $ (SINT 8) $ (CONST_INT
                        64
                       )
                      ) $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                     ) scalars_points! k$
                )))))
               ) (I 54)
            )))
            :pattern ((vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ (ARRAY $ (SINT 8) $ (CONST_INT
                 64
                )
               ) $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
              ) scalars_points! k$
            ))
            :qid user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__pippenger_input_valid_34
            :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__pippenger_input_valid_34
         )))
         (forall ((k$ Poly)) (!
           (=>
            (has_type k$ INT)
            (=>
             (let
              ((tmp%%$ (%I k$)))
              (and
               (<= 0 tmp%%$)
               (< tmp%%$ n$)
             ))
             (= (curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
               (tuple%2./tuple%2/1 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ (ARRAY
                    $ (SINT 8) $ (CONST_INT 64)
                   ) $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                  ) scalars_points! k$
               )))
              ) (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) pts_affine!
                k$
           )))))
           :pattern ((vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ (ARRAY $ (SINT 8) $ (CONST_INT
                64
               )
              ) $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
             ) scalars_points! k$
           ))
           :qid user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__pippenger_input_valid_35
           :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__pippenger_input_valid_35
        )))
        (forall ((k$ Poly)) (!
          (=>
           (has_type k$ INT)
           (=>
            (let
             ((tmp%%$ (%I k$)))
             (and
              (<= 0 tmp%%$)
              (< tmp%%$ n$)
            ))
            (and
             (< (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2.
                   $ NAT $ NAT
                  ) pts_affine! k$
               )))
              ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
             )
             (< (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2.
                   $ NAT $ NAT
                  ) pts_affine! k$
               )))
              ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
          ))))
          :pattern ((vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) pts_affine! k$))
          :qid user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__pippenger_input_valid_36
          :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__pippenger_input_valid_36
       )))
       (forall ((k$ Poly)) (!
         (=>
          (has_type k$ INT)
          (=>
           (let
            ((tmp%%$ (%I k$)))
            (and
             (<= 0 tmp%%$)
             (< tmp%%$ n$)
           ))
           (= (vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) digits_seqs! k$) (vstd!view.View.view.?
             $ (ARRAY $ (SINT 8) $ (CONST_INT 64)) (tuple%2./tuple%2/0 (%Poly%tuple%2. (vstd!seq.Seq.index.?
                (DST $) (TYPE%tuple%2. $ (ARRAY $ (SINT 8) $ (CONST_INT 64)) $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
                scalars_points! k$
         )))))))
         :pattern ((vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) digits_seqs! k$))
         :qid user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__pippenger_input_valid_37
         :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__pippenger_input_valid_37
    )))))
    :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_input_valid.?
      scalars_points! pts_affine! digits_seqs! w! dc!
    ))
    :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_input_valid.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_input_valid.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_sub
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_sub.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_sub.)
  (forall ((x1! Poly) (y1! Poly) (x2! Poly) (y2! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_sub.? x1! y1! x2! y2!) (curve25519_dalek!specs.edwards_specs.edwards_add.?
      x1! y1! (I (curve25519_dalek!specs.field_specs.field_neg.? x2!)) y2!
    ))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_sub.? x1! y1! x2! y2!))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_sub.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_sub.?_definition
))))
(assert
 (forall ((x1! Poly) (y1! Poly) (x2! Poly) (y2! Poly)) (!
   (=>
    (and
     (has_type x1! NAT)
     (has_type y1! NAT)
     (has_type x2! NAT)
     (has_type y2! NAT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_sub.? x1! y1!
       x2! y2!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_sub.? x1! y1! x2! y2!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_sub.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_sub.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::pippenger_bucket_contents
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_bucket_contents.)
)
(declare-const fuel_nat%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_bucket_contents.
 Fuel
)
(assert
 (forall ((points_affine! Poly) (all_digits! Poly) (col! Poly) (n! Poly) (b! Poly) (
    fuel% Fuel
   )
  ) (!
   (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_bucket_contents.?
     points_affine! all_digits! col! n! b! fuel%
    ) (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_bucket_contents.?
     points_affine! all_digits! col! n! b! zero
   ))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_bucket_contents.?
     points_affine! all_digits! col! n! b! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_bucket_contents._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_bucket_contents._fuel_to_zero_definition
)))
(assert
 (forall ((points_affine! Poly) (all_digits! Poly) (col! Poly) (n! Poly) (b! Poly) (
    fuel% Fuel
   )
  ) (!
   (=>
    (and
     (has_type points_affine! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
     (has_type all_digits! (TYPE%vstd!seq.Seq. $ (TYPE%vstd!seq.Seq. $ (SINT 8))))
     (has_type col! INT)
     (has_type n! INT)
     (has_type b! INT)
    )
    (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_bucket_contents.?
      points_affine! all_digits! col! n! b! (succ fuel%)
     ) (ite
      (<= (%I n!) 0)
      (curve25519_dalek!specs.edwards_specs.edwards_identity.? (I 0))
      (let
       ((prev$ (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_bucket_contents.?
          points_affine! all_digits! col! (I (Sub (%I n!) 1)) b! fuel%
       )))
       (let
        ((d$ (%I (vstd!seq.Seq.index.? $ (SINT 8) (vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq. $
              (SINT 8)
             ) all_digits! (I (Sub (%I n!) 1))
            ) col!
        ))))
        (let
         ((pt$ (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) points_affine!
             (I (Sub (%I n!) 1))
         ))))
         (ite
          (= d$ (Add (%I b!) 1))
          (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
             (Poly%tuple%2. prev$)
            )
           ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. prev$))) (tuple%2./tuple%2/0
            (%Poly%tuple%2. (Poly%tuple%2. pt$))
           ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. pt$)))
          )
          (ite
           (= d$ (Sub 0 (Add (%I b!) 1)))
           (curve25519_dalek!specs.edwards_specs.edwards_sub.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
              (Poly%tuple%2. prev$)
             )
            ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. prev$))) (tuple%2./tuple%2/0
             (%Poly%tuple%2. (Poly%tuple%2. pt$))
            ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. pt$)))
           )
           prev$
   ))))))))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_bucket_contents.?
     points_affine! all_digits! col! n! b! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_bucket_contents._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_bucket_contents._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_bucket_contents.)
  (forall ((points_affine! Poly) (all_digits! Poly) (col! Poly) (n! Poly) (b! Poly))
   (!
    (=>
     (and
      (has_type points_affine! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
      (has_type all_digits! (TYPE%vstd!seq.Seq. $ (TYPE%vstd!seq.Seq. $ (SINT 8))))
      (has_type col! INT)
      (has_type n! INT)
      (has_type b! INT)
     )
     (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_bucket_contents.?
       points_affine! all_digits! col! n! b!
      ) (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_bucket_contents.?
       points_affine! all_digits! col! n! b! (succ fuel_nat%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_bucket_contents.)
    )))
    :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_bucket_contents.?
      points_affine! all_digits! col! n! b!
    ))
    :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_bucket_contents.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_bucket_contents.?_definition
))))
(assert
 (forall ((points_affine! Poly) (all_digits! Poly) (col! Poly) (n! Poly) (b! Poly))
  (!
   (=>
    (and
     (has_type points_affine! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
     (has_type all_digits! (TYPE%vstd!seq.Seq. $ (TYPE%vstd!seq.Seq. $ (SINT 8))))
     (has_type col! INT)
     (has_type n! INT)
     (has_type b! INT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_bucket_contents.?
       points_affine! all_digits! col! n! b!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_bucket_contents.?
     points_affine! all_digits! col! n! b!
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_bucket_contents.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_bucket_contents.?_pre_post_definition
)))
(assert
 (forall ((points_affine! Poly) (all_digits! Poly) (col! Poly) (n! Poly) (b! Poly) (
    fuel% Fuel
   )
  ) (!
   (=>
    (and
     (has_type points_affine! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
     (has_type all_digits! (TYPE%vstd!seq.Seq. $ (TYPE%vstd!seq.Seq. $ (SINT 8))))
     (has_type col! INT)
     (has_type n! INT)
     (has_type b! INT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_bucket_contents.?
       points_affine! all_digits! col! n! b! fuel%
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_bucket_contents.?
     points_affine! all_digits! col! n! b! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec__pippenger_bucket_contents.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec__pippenger_bucket_contents.?_pre_post_rec_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::pippenger_weighted_bucket_sum
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_bucket_sum.)
)
(declare-const fuel_nat%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_bucket_sum.
 Fuel
)
(assert
 (forall ((buckets_affine! Poly) (num_buckets! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_weighted_bucket_sum.?
     buckets_affine! num_buckets! fuel%
    ) (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_weighted_bucket_sum.?
     buckets_affine! num_buckets! zero
   ))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_weighted_bucket_sum.?
     buckets_affine! num_buckets! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_bucket_sum._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_bucket_sum._fuel_to_zero_definition
)))
(assert
 (forall ((buckets_affine! Poly) (num_buckets! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type buckets_affine! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
     (has_type num_buckets! INT)
    )
    (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_weighted_bucket_sum.?
      buckets_affine! num_buckets! (succ fuel%)
     ) (ite
      (<= (%I num_buckets!) 0)
      (curve25519_dalek!specs.edwards_specs.edwards_identity.? (I 0))
      (let
       ((prev$ (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_weighted_bucket_sum.?
          buckets_affine! (I (Sub (%I num_buckets!) 1)) fuel%
       )))
       (let
        ((bucket$ (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) buckets_affine!
            (I (Sub (%I num_buckets!) 1))
        ))))
        (let
         ((weighted$ (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2.
             bucket$
            ) (I (nClip (%I num_buckets!)))
         )))
         (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
            (Poly%tuple%2. prev$)
           )
          ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. prev$))) (tuple%2./tuple%2/0
           (%Poly%tuple%2. (Poly%tuple%2. weighted$))
          ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. weighted$)))
   )))))))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_weighted_bucket_sum.?
     buckets_affine! num_buckets! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_bucket_sum._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_bucket_sum._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_bucket_sum.)
  (forall ((buckets_affine! Poly) (num_buckets! Poly)) (!
    (=>
     (and
      (has_type buckets_affine! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
      (has_type num_buckets! INT)
     )
     (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_bucket_sum.?
       buckets_affine! num_buckets!
      ) (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_weighted_bucket_sum.?
       buckets_affine! num_buckets! (succ fuel_nat%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_bucket_sum.)
    )))
    :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_bucket_sum.?
      buckets_affine! num_buckets!
    ))
    :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_bucket_sum.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_bucket_sum.?_definition
))))
(assert
 (forall ((buckets_affine! Poly) (num_buckets! Poly)) (!
   (=>
    (and
     (has_type buckets_affine! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
     (has_type num_buckets! INT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_bucket_sum.?
       buckets_affine! num_buckets!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_bucket_sum.?
     buckets_affine! num_buckets!
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_bucket_sum.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_bucket_sum.?_pre_post_definition
)))
(assert
 (forall ((buckets_affine! Poly) (num_buckets! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type buckets_affine! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
     (has_type num_buckets! INT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_weighted_bucket_sum.?
       buckets_affine! num_buckets! fuel%
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_weighted_bucket_sum.?
     buckets_affine! num_buckets! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec__pippenger_weighted_bucket_sum.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec__pippenger_weighted_bucket_sum.?_pre_post_rec_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::pippenger_intermediate_sum
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_intermediate_sum.)
)
(declare-const fuel_nat%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_intermediate_sum.
 Fuel
)
(assert
 (forall ((buckets_affine! Poly) (b! Poly) (B! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_intermediate_sum.?
     buckets_affine! b! B! fuel%
    ) (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_intermediate_sum.?
     buckets_affine! b! B! zero
   ))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_intermediate_sum.?
     buckets_affine! b! B! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_intermediate_sum._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_intermediate_sum._fuel_to_zero_definition
)))
(assert
 (forall ((buckets_affine! Poly) (b! Poly) (B! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type buckets_affine! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
     (has_type b! INT)
     (has_type B! INT)
    )
    (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_intermediate_sum.?
      buckets_affine! b! B! (succ fuel%)
     ) (ite
      (>= (%I b!) (%I B!))
      (curve25519_dalek!specs.edwards_specs.edwards_identity.? (I 0))
      (ite
       (= (%I b!) (Sub (%I B!) 1))
       (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) buckets_affine!
         b!
       ))
       (let
        ((next$ (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_intermediate_sum.?
           buckets_affine! (I (Add (%I b!) 1)) B! fuel%
        )))
        (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
           (Poly%tuple%2. next$)
          )
         ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. next$))) (tuple%2./tuple%2/0
          (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) buckets_affine!
            b!
          ))
         ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $
             NAT $ NAT
            ) buckets_affine! b!
   )))))))))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_intermediate_sum.?
     buckets_affine! b! B! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_intermediate_sum._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_intermediate_sum._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_intermediate_sum.)
  (forall ((buckets_affine! Poly) (b! Poly) (B! Poly)) (!
    (=>
     (and
      (has_type buckets_affine! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
      (has_type b! INT)
      (has_type B! INT)
     )
     (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_intermediate_sum.?
       buckets_affine! b! B!
      ) (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_intermediate_sum.?
       buckets_affine! b! B! (succ fuel_nat%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_intermediate_sum.)
    )))
    :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_intermediate_sum.?
      buckets_affine! b! B!
    ))
    :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_intermediate_sum.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_intermediate_sum.?_definition
))))
(assert
 (forall ((buckets_affine! Poly) (b! Poly) (B! Poly)) (!
   (=>
    (and
     (has_type buckets_affine! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
     (has_type b! INT)
     (has_type B! INT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_intermediate_sum.?
       buckets_affine! b! B!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_intermediate_sum.?
     buckets_affine! b! B!
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_intermediate_sum.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_intermediate_sum.?_pre_post_definition
)))
(assert
 (forall ((buckets_affine! Poly) (b! Poly) (B! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type buckets_affine! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
     (has_type b! INT)
     (has_type B! INT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_intermediate_sum.?
       buckets_affine! b! B! fuel%
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_intermediate_sum.?
     buckets_affine! b! B! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec__pippenger_intermediate_sum.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec__pippenger_intermediate_sum.?_pre_post_rec_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::pippenger_running_sum
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_running_sum.)
)
(declare-const fuel_nat%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_running_sum.
 Fuel
)
(assert
 (forall ((buckets_affine! Poly) (b! Poly) (B! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_running_sum.?
     buckets_affine! b! B! fuel%
    ) (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_running_sum.?
     buckets_affine! b! B! zero
   ))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_running_sum.?
     buckets_affine! b! B! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_running_sum._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_running_sum._fuel_to_zero_definition
)))
(assert
 (forall ((buckets_affine! Poly) (b! Poly) (B! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type buckets_affine! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
     (has_type b! INT)
     (has_type B! INT)
    )
    (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_running_sum.?
      buckets_affine! b! B! (succ fuel%)
     ) (ite
      (>= (%I b!) (%I B!))
      (curve25519_dalek!specs.edwards_specs.edwards_identity.? (I 0))
      (ite
       (= (%I b!) (Sub (%I B!) 1))
       (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) buckets_affine!
         b!
       ))
       (let
        ((rest$ (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_running_sum.?
           buckets_affine! (I (Add (%I b!) 1)) B! fuel%
        )))
        (let
         ((inter$ (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_intermediate_sum.?
            buckets_affine! b! B!
         )))
         (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
            (Poly%tuple%2. rest$)
           )
          ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. rest$))) (tuple%2./tuple%2/0
           (%Poly%tuple%2. (Poly%tuple%2. inter$))
          ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. inter$)))
   )))))))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_running_sum.?
     buckets_affine! b! B! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_running_sum._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_running_sum._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_running_sum.)
  (forall ((buckets_affine! Poly) (b! Poly) (B! Poly)) (!
    (=>
     (and
      (has_type buckets_affine! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
      (has_type b! INT)
      (has_type B! INT)
     )
     (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_running_sum.?
       buckets_affine! b! B!
      ) (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_running_sum.?
       buckets_affine! b! B! (succ fuel_nat%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_running_sum.)
    )))
    :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_running_sum.?
      buckets_affine! b! B!
    ))
    :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_running_sum.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_running_sum.?_definition
))))
(assert
 (forall ((buckets_affine! Poly) (b! Poly) (B! Poly)) (!
   (=>
    (and
     (has_type buckets_affine! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
     (has_type b! INT)
     (has_type B! INT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_running_sum.?
       buckets_affine! b! B!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_running_sum.?
     buckets_affine! b! B!
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_running_sum.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_running_sum.?_pre_post_definition
)))
(assert
 (forall ((buckets_affine! Poly) (b! Poly) (B! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type buckets_affine! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
     (has_type b! INT)
     (has_type B! INT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_running_sum.?
       buckets_affine! b! B! fuel%
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_running_sum.?
     buckets_affine! b! B! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec__pippenger_running_sum.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec__pippenger_running_sum.?_pre_post_rec_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::edwards_lemmas::straus_lemmas::straus_column_sum
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.)
)
(declare-const fuel_nat%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.
 Fuel
)
(assert
 (forall ((points_affine! Poly) (digits! Poly) (j! Poly) (n! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.rec%straus_column_sum.? points_affine!
     digits! j! n! fuel%
    ) (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.rec%straus_column_sum.? points_affine!
     digits! j! n! zero
   ))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.rec%straus_column_sum.?
     points_affine! digits! j! n! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum._fuel_to_zero_definition
)))
(assert
 (forall ((points_affine! Poly) (digits! Poly) (j! Poly) (n! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type points_affine! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
     (has_type digits! (TYPE%vstd!seq.Seq. $ (TYPE%vstd!seq.Seq. $ (SINT 8))))
     (has_type j! INT)
     (has_type n! INT)
    )
    (= (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.rec%straus_column_sum.? points_affine!
      digits! j! n! (succ fuel%)
     ) (ite
      (<= (%I n!) 0)
      (curve25519_dalek!specs.edwards_specs.edwards_identity.? (I 0))
      (let
       ((prev$ (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.rec%straus_column_sum.?
          points_affine! digits! j! (I (Sub (%I n!) 1)) fuel%
       )))
       (let
        ((term$ (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? (vstd!seq.Seq.index.?
            (DST $) (TYPE%tuple%2. $ NAT $ NAT) points_affine! (I (Sub (%I n!) 1))
           ) (vstd!seq.Seq.index.? $ (SINT 8) (vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq. $ (SINT
               8
              )
             ) digits! (I (Sub (%I n!) 1))
            ) j!
        ))))
        (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
           (Poly%tuple%2. prev$)
          )
         ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. prev$))) (tuple%2./tuple%2/0
          (%Poly%tuple%2. (Poly%tuple%2. term$))
         ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. term$)))
   ))))))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.rec%straus_column_sum.?
     points_affine! digits! j! n! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.)
  (forall ((points_affine! Poly) (digits! Poly) (j! Poly) (n! Poly)) (!
    (=>
     (and
      (has_type points_affine! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
      (has_type digits! (TYPE%vstd!seq.Seq. $ (TYPE%vstd!seq.Seq. $ (SINT 8))))
      (has_type j! INT)
      (has_type n! INT)
     )
     (= (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.? points_affine!
       digits! j! n!
      ) (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.rec%straus_column_sum.? points_affine!
       digits! j! n! (succ fuel_nat%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.)
    )))
    :pattern ((curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.?
      points_affine! digits! j! n!
    ))
    :qid internal_curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.?_definition
))))
(assert
 (forall ((points_affine! Poly) (digits! Poly) (j! Poly) (n! Poly)) (!
   (=>
    (and
     (has_type points_affine! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
     (has_type digits! (TYPE%vstd!seq.Seq. $ (TYPE%vstd!seq.Seq. $ (SINT 8))))
     (has_type j! INT)
     (has_type n! INT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.?
       points_affine! digits! j! n!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.?
     points_affine! digits! j! n!
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.?_pre_post_definition
)))
(assert
 (forall ((points_affine! Poly) (digits! Poly) (j! Poly) (n! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type points_affine! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
     (has_type digits! (TYPE%vstd!seq.Seq. $ (TYPE%vstd!seq.Seq. $ (SINT 8))))
     (has_type j! INT)
     (has_type n! INT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.rec%straus_column_sum.?
       points_affine! digits! j! n! fuel%
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.rec%straus_column_sum.?
     points_affine! digits! j! n! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.rec__straus_column_sum.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.rec__straus_column_sum.?_pre_post_rec_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::pippenger_horner
(declare-const fuel_nat%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_horner.
 Fuel
)
(assert
 (forall ((points_affine! Poly) (digits! Poly) (from_col! Poly) (w! Poly) (digits_count!
    Poly
   ) (fuel% Fuel)
  ) (!
   (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_horner.?
     points_affine! digits! from_col! w! digits_count! fuel%
    ) (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_horner.?
     points_affine! digits! from_col! w! digits_count! zero
   ))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_horner.?
     points_affine! digits! from_col! w! digits_count! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_horner._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_horner._fuel_to_zero_definition
)))
(assert
 (forall ((points_affine! Poly) (digits! Poly) (from_col! Poly) (w! Poly) (digits_count!
    Poly
   ) (fuel% Fuel)
  ) (!
   (=>
    (and
     (has_type points_affine! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
     (has_type digits! (TYPE%vstd!seq.Seq. $ (TYPE%vstd!seq.Seq. $ (SINT 8))))
     (has_type from_col! INT)
     (has_type w! NAT)
     (has_type digits_count! NAT)
    )
    (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_horner.?
      points_affine! digits! from_col! w! digits_count! (succ fuel%)
     ) (ite
      (>= (%I from_col!) (%I digits_count!))
      (curve25519_dalek!specs.edwards_specs.edwards_identity.? (I 0))
      (let
       ((prev$ (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_horner.?
          points_affine! digits! (I (Add (%I from_col!) 1)) w! digits_count! fuel%
       )))
       (let
        ((scaled$ (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. prev$)
           (I (vstd!arithmetic.power2.pow2.? w!))
        )))
        (let
         ((col$ (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.? points_affine!
            digits! from_col! (I (vstd!seq.Seq.len.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) points_affine!))
         )))
         (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
            (Poly%tuple%2. scaled$)
           )
          ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. scaled$))) (tuple%2./tuple%2/0
           (%Poly%tuple%2. (Poly%tuple%2. col$))
          ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. col$)))
   )))))))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_horner.?
     points_affine! digits! from_col! w! digits_count! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_horner._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_horner._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_horner.)
  (forall ((points_affine! Poly) (digits! Poly) (from_col! Poly) (w! Poly) (digits_count!
     Poly
    )
   ) (!
    (=>
     (and
      (has_type points_affine! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
      (has_type digits! (TYPE%vstd!seq.Seq. $ (TYPE%vstd!seq.Seq. $ (SINT 8))))
      (has_type from_col! INT)
      (has_type w! NAT)
      (has_type digits_count! NAT)
     )
     (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_horner.? points_affine!
       digits! from_col! w! digits_count!
      ) (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_horner.?
       points_affine! digits! from_col! w! digits_count! (succ fuel_nat%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_horner.)
    )))
    :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_horner.?
      points_affine! digits! from_col! w! digits_count!
    ))
    :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_horner.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_horner.?_definition
))))
(assert
 (forall ((points_affine! Poly) (digits! Poly) (from_col! Poly) (w! Poly) (digits_count!
    Poly
   )
  ) (!
   (=>
    (and
     (has_type points_affine! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
     (has_type digits! (TYPE%vstd!seq.Seq. $ (TYPE%vstd!seq.Seq. $ (SINT 8))))
     (has_type from_col! INT)
     (has_type w! NAT)
     (has_type digits_count! NAT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_horner.?
       points_affine! digits! from_col! w! digits_count!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_horner.?
     points_affine! digits! from_col! w! digits_count!
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_horner.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_horner.?_pre_post_definition
)))
(assert
 (forall ((points_affine! Poly) (digits! Poly) (from_col! Poly) (w! Poly) (digits_count!
    Poly
   ) (fuel% Fuel)
  ) (!
   (=>
    (and
     (has_type points_affine! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
     (has_type digits! (TYPE%vstd!seq.Seq. $ (TYPE%vstd!seq.Seq. $ (SINT 8))))
     (has_type from_col! INT)
     (has_type w! NAT)
     (has_type digits_count! NAT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_horner.?
       points_affine! digits! from_col! w! digits_count! fuel%
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_horner.?
     points_affine! digits! from_col! w! digits_count! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec__pippenger_horner.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec__pippenger_horner.?_pre_post_rec_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::pippenger_weighted_from
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_from.)
)
(declare-const fuel_nat%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_from.
 Fuel
)
(assert
 (forall ((buckets! Poly) (b! Poly) (B! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_weighted_from.?
     buckets! b! B! fuel%
    ) (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_weighted_from.?
     buckets! b! B! zero
   ))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_weighted_from.?
     buckets! b! B! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_from._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_from._fuel_to_zero_definition
)))
(assert
 (forall ((buckets! Poly) (b! Poly) (B! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type buckets! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
     (has_type b! INT)
     (has_type B! INT)
    )
    (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_weighted_from.?
      buckets! b! B! (succ fuel%)
     ) (ite
      (<= (%I B!) (%I b!))
      (curve25519_dalek!specs.edwards_specs.edwards_identity.? (I 0))
      (let
       ((rest$ (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_weighted_from.?
          buckets! b! (I (Sub (%I B!) 1)) fuel%
       )))
       (let
        ((weight$ (nClip (Sub (%I B!) (%I b!)))))
        (let
         ((weighted$ (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (vstd!seq.Seq.index.?
             (DST $) (TYPE%tuple%2. $ NAT $ NAT) buckets! (I (Sub (%I B!) 1))
            ) (I weight$)
         )))
         (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
            (Poly%tuple%2. rest$)
           )
          ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. rest$))) (tuple%2./tuple%2/0
           (%Poly%tuple%2. (Poly%tuple%2. weighted$))
          ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. weighted$)))
   )))))))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_weighted_from.?
     buckets! b! B! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_from._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_from._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_from.)
  (forall ((buckets! Poly) (b! Poly) (B! Poly)) (!
    (=>
     (and
      (has_type buckets! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
      (has_type b! INT)
      (has_type B! INT)
     )
     (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_from.?
       buckets! b! B!
      ) (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_weighted_from.?
       buckets! b! B! (succ fuel_nat%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_from.)
    )))
    :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_from.?
      buckets! b! B!
    ))
    :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_from.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_from.?_definition
))))
(assert
 (forall ((buckets! Poly) (b! Poly) (B! Poly)) (!
   (=>
    (and
     (has_type buckets! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
     (has_type b! INT)
     (has_type B! INT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_from.?
       buckets! b! B!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_from.?
     buckets! b! B!
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_from.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_from.?_pre_post_definition
)))
(assert
 (forall ((buckets! Poly) (b! Poly) (B! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type buckets! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
     (has_type b! INT)
     (has_type B! INT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_weighted_from.?
       buckets! b! B! fuel%
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec%pippenger_weighted_from.?
     buckets! b! B! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec__pippenger_weighted_from.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.rec__pippenger_weighted_from.?_pre_post_rec_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_neg
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_neg.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_neg.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_neg.? point!) (tuple%2./tuple%2 (I
       (curve25519_dalek!specs.field_specs.field_neg.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
          point!
       )))
      ) (tuple%2./tuple%2/1 (%Poly%tuple%2. point!))
    ))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_neg.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_neg.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_neg.?_definition
))))
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! (TYPE%tuple%2. $ NAT $ NAT))
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_neg.? point!))
     (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_neg.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_neg.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_neg.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::scalar_specs::scalar_as_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar_specs.scalar_as_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar_specs.scalar_as_nat.)
  (forall ((s! Poly)) (!
    (= (curve25519_dalek!specs.scalar_specs.scalar_as_nat.? s!) (curve25519_dalek!specs.core_specs.u8_32_as_nat.?
      (Poly%array%. (curve25519_dalek!scalar.Scalar./Scalar/bytes (%Poly%curve25519_dalek!scalar.Scalar.
         s!
    )))))
    :pattern ((curve25519_dalek!specs.scalar_specs.scalar_as_nat.? s!))
    :qid internal_curve25519_dalek!specs.scalar_specs.scalar_as_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar_specs.scalar_as_nat.?_definition
))))
(assert
 (forall ((s! Poly)) (!
   (=>
    (has_type s! TYPE%curve25519_dalek!scalar.Scalar.)
    (<= 0 (curve25519_dalek!specs.scalar_specs.scalar_as_nat.? s!))
   )
   :pattern ((curve25519_dalek!specs.scalar_specs.scalar_as_nat.? s!))
   :qid internal_curve25519_dalek!specs.scalar_specs.scalar_as_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.scalar_specs.scalar_as_nat.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::sum_of_scalar_muls
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls.)
)
(declare-const fuel_nat%curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls. Fuel)
(assert
 (forall ((scalars! Poly) (points! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!specs.edwards_specs.rec%sum_of_scalar_muls.? scalars! points!
     fuel%
    ) (curve25519_dalek!specs.edwards_specs.rec%sum_of_scalar_muls.? scalars! points!
     zero
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.rec%sum_of_scalar_muls.? scalars! points!
     fuel%
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls._fuel_to_zero_definition
)))
(assert
 (forall ((scalars! Poly) (points! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type scalars! (TYPE%vstd!seq.Seq. $ TYPE%curve25519_dalek!scalar.Scalar.))
     (has_type points! (TYPE%vstd!seq.Seq. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.))
    )
    (= (curve25519_dalek!specs.edwards_specs.rec%sum_of_scalar_muls.? scalars! points!
      (succ fuel%)
     ) (let
      ((len$ (ite
         (<= (vstd!seq.Seq.len.? $ TYPE%curve25519_dalek!scalar.Scalar. scalars!) (vstd!seq.Seq.len.?
           $ TYPE%curve25519_dalek!edwards.EdwardsPoint. points!
         ))
         (vstd!seq.Seq.len.? $ TYPE%curve25519_dalek!scalar.Scalar. scalars!)
         (vstd!seq.Seq.len.? $ TYPE%curve25519_dalek!edwards.EdwardsPoint. points!)
      )))
      (ite
       (= len$ 0)
       (tuple%2./tuple%2 (I 0) (I 1))
       (let
        ((last$ (Sub len$ 1)))
        (let
         ((prev$ (curve25519_dalek!specs.edwards_specs.rec%sum_of_scalar_muls.? (vstd!seq.Seq.subrange.?
             $ TYPE%curve25519_dalek!scalar.Scalar. scalars! (I 0) (I last$)
            ) (vstd!seq.Seq.subrange.? $ TYPE%curve25519_dalek!edwards.EdwardsPoint. points! (
              I 0
             ) (I last$)
            ) fuel%
         )))
         (let
          ((point_affine$ (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? (vstd!seq.Seq.index.?
              $ TYPE%curve25519_dalek!edwards.EdwardsPoint. points! (I last$)
          ))))
          (let
           ((scalar_nat$ (curve25519_dalek!specs.scalar_specs.scalar_as_nat.? (vstd!seq.Seq.index.?
               $ TYPE%curve25519_dalek!scalar.Scalar. scalars! (I last$)
           ))))
           (let
            ((scaled$ (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. point_affine$)
               (I scalar_nat$)
            )))
            (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
               (Poly%tuple%2. prev$)
              )
             ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. prev$))) (tuple%2./tuple%2/0
              (%Poly%tuple%2. (Poly%tuple%2. scaled$))
             ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. scaled$)))
   ))))))))))
   :pattern ((curve25519_dalek!specs.edwards_specs.rec%sum_of_scalar_muls.? scalars! points!
     (succ fuel%)
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls.)
  (forall ((scalars! Poly) (points! Poly)) (!
    (=>
     (and
      (has_type scalars! (TYPE%vstd!seq.Seq. $ TYPE%curve25519_dalek!scalar.Scalar.))
      (has_type points! (TYPE%vstd!seq.Seq. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.))
     )
     (= (curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls.? scalars! points!) (curve25519_dalek!specs.edwards_specs.rec%sum_of_scalar_muls.?
       scalars! points! (succ fuel_nat%curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls.)
    )))
    :pattern ((curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls.? scalars! points!))
    :qid internal_curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls.?_definition
))))
(assert
 (forall ((scalars! Poly) (points! Poly)) (!
   (=>
    (and
     (has_type scalars! (TYPE%vstd!seq.Seq. $ TYPE%curve25519_dalek!scalar.Scalar.))
     (has_type points! (TYPE%vstd!seq.Seq. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.))
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls.?
       scalars! points!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls.? scalars! points!))
   :qid internal_curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls.?_pre_post_definition
)))
(assert
 (forall ((scalars! Poly) (points! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type scalars! (TYPE%vstd!seq.Seq. $ TYPE%curve25519_dalek!scalar.Scalar.))
     (has_type points! (TYPE%vstd!seq.Seq. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.))
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.rec%sum_of_scalar_muls.?
       scalars! points! fuel%
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.rec%sum_of_scalar_muls.? scalars! points!
     fuel%
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.rec__sum_of_scalar_muls.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.rec__sum_of_scalar_muls.?_pre_post_rec_definition
)))

;; Function-Axioms curve25519_dalek::specs::scalar_specs::reconstruct_radix_2w
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w.)
)
(declare-const fuel_nat%curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w.
 Fuel
)
(assert
 (forall ((digits! Poly) (w! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!specs.scalar_specs.rec%reconstruct_radix_2w.? digits! w! fuel%)
    (curve25519_dalek!specs.scalar_specs.rec%reconstruct_radix_2w.? digits! w! zero)
   )
   :pattern ((curve25519_dalek!specs.scalar_specs.rec%reconstruct_radix_2w.? digits! w!
     fuel%
   ))
   :qid internal_curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w._fuel_to_zero_definition
)))
(assert
 (forall ((digits! Poly) (w! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type digits! (TYPE%vstd!seq.Seq. $ (SINT 8)))
     (has_type w! NAT)
    )
    (= (curve25519_dalek!specs.scalar_specs.rec%reconstruct_radix_2w.? digits! w! (succ
       fuel%
      )
     ) (ite
      (= (vstd!seq.Seq.len.? $ (SINT 8) digits!) 0)
      0
      (Add (%I (vstd!seq.Seq.index.? $ (SINT 8) digits! (I 0))) (Mul (vstd!arithmetic.power2.pow2.?
         w!
        ) (curve25519_dalek!specs.scalar_specs.rec%reconstruct_radix_2w.? (vstd!seq.Seq.subrange.?
          $ (SINT 8) digits! (I 1) (I (vstd!seq.Seq.len.? $ (SINT 8) digits!))
         ) w! fuel%
   ))))))
   :pattern ((curve25519_dalek!specs.scalar_specs.rec%reconstruct_radix_2w.? digits! w!
     (succ fuel%)
   ))
   :qid internal_curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w.)
  (forall ((digits! Poly) (w! Poly)) (!
    (=>
     (and
      (has_type digits! (TYPE%vstd!seq.Seq. $ (SINT 8)))
      (has_type w! NAT)
     )
     (= (curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w.? digits! w!) (curve25519_dalek!specs.scalar_specs.rec%reconstruct_radix_2w.?
       digits! w! (succ fuel_nat%curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w.)
    )))
    :pattern ((curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w.? digits! w!))
    :qid internal_curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::scalar_specs::reconstruct_radix_2w_from
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w_from.)
)
(declare-const fuel_nat%curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w_from.
 Fuel
)
(assert
 (forall ((digits! Poly) (w! Poly) (from_j! Poly) (digits_count! Poly) (fuel% Fuel))
  (!
   (= (curve25519_dalek!specs.scalar_specs.rec%reconstruct_radix_2w_from.? digits! w!
     from_j! digits_count! fuel%
    ) (curve25519_dalek!specs.scalar_specs.rec%reconstruct_radix_2w_from.? digits! w!
     from_j! digits_count! zero
   ))
   :pattern ((curve25519_dalek!specs.scalar_specs.rec%reconstruct_radix_2w_from.? digits!
     w! from_j! digits_count! fuel%
   ))
   :qid internal_curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w_from._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w_from._fuel_to_zero_definition
)))
(assert
 (forall ((digits! Poly) (w! Poly) (from_j! Poly) (digits_count! Poly) (fuel% Fuel))
  (!
   (=>
    (and
     (has_type digits! (TYPE%vstd!seq.Seq. $ (SINT 8)))
     (has_type w! NAT)
     (has_type from_j! INT)
     (has_type digits_count! NAT)
    )
    (= (curve25519_dalek!specs.scalar_specs.rec%reconstruct_radix_2w_from.? digits! w!
      from_j! digits_count! (succ fuel%)
     ) (ite
      (or
       (>= (%I from_j!) (%I digits_count!))
       (< (%I from_j!) 0)
      )
      0
      (Add (%I (vstd!seq.Seq.index.? $ (SINT 8) digits! from_j!)) (Mul (vstd!arithmetic.power2.pow2.?
         w!
        ) (curve25519_dalek!specs.scalar_specs.rec%reconstruct_radix_2w_from.? digits! w!
         (I (Add (%I from_j!) 1)) digits_count! fuel%
   ))))))
   :pattern ((curve25519_dalek!specs.scalar_specs.rec%reconstruct_radix_2w_from.? digits!
     w! from_j! digits_count! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w_from._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w_from._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w_from.)
  (forall ((digits! Poly) (w! Poly) (from_j! Poly) (digits_count! Poly)) (!
    (=>
     (and
      (has_type digits! (TYPE%vstd!seq.Seq. $ (SINT 8)))
      (has_type w! NAT)
      (has_type from_j! INT)
      (has_type digits_count! NAT)
     )
     (= (curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w_from.? digits! w! from_j!
       digits_count!
      ) (curve25519_dalek!specs.scalar_specs.rec%reconstruct_radix_2w_from.? digits! w!
       from_j! digits_count! (succ fuel_nat%curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w_from.)
    )))
    :pattern ((curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w_from.? digits!
      w! from_j! digits_count!
    ))
    :qid internal_curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w_from.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w_from.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (tr_bound%vstd!view.View. A&. A&)
    (tr_bound%vstd!view.View. (REF A&.) A&)
   )
   :pattern ((tr_bound%vstd!view.View. (REF A&.) A&))
   :qid internal_vstd__view__impl&__0_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__0_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (tr_bound%vstd!view.View. A&. A&)
    (tr_bound%vstd!view.View. (BOX $ ALLOCATOR_GLOBAL A&.) A&)
   )
   :pattern ((tr_bound%vstd!view.View. (BOX $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_vstd__view__impl&__2_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__2_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized A&.)
     (tr_bound%vstd!view.View. A&. A&)
    )
    (tr_bound%vstd!view.View. (RC $ ALLOCATOR_GLOBAL A&.) A&)
   )
   :pattern ((tr_bound%vstd!view.View. (RC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_vstd__view__impl&__4_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__4_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized A&.)
     (tr_bound%vstd!view.View. A&. A&)
    )
    (tr_bound%vstd!view.View. (ARC $ ALLOCATOR_GLOBAL A&.) A&)
   )
   :pattern ((tr_bound%vstd!view.View. (ARC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_vstd__view__impl&__6_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__6_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ TYPE%tuple%0.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type)) (!
   (=>
    (and
     (sized A0&.)
     (sized A1&.)
     (tr_bound%vstd!view.View. A0&. A0&)
     (tr_bound%vstd!view.View. A1&. A1&)
    )
    (tr_bound%vstd!view.View. (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&))
   )
   :pattern ((tr_bound%vstd!view.View. (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&)))
   :qid internal_vstd__view__impl&__44_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__44_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type) (A3&. Dcr)
   (A3& Type)
  ) (!
   (=>
    (and
     (sized A0&.)
     (sized A1&.)
     (sized A2&.)
     (sized A3&.)
     (tr_bound%vstd!view.View. A0&. A0&)
     (tr_bound%vstd!view.View. A1&. A1&)
     (tr_bound%vstd!view.View. A2&. A2&)
     (tr_bound%vstd!view.View. A3&. A3&)
    )
    (tr_bound%vstd!view.View. (DST A3&.) (TYPE%tuple%4. A0&. A0& A1&. A1& A2&. A2& A3&.
      A3&
   )))
   :pattern ((tr_bound%vstd!view.View. (DST A3&.) (TYPE%tuple%4. A0&. A0& A1&. A1& A2&.
      A2& A3&. A3&
   )))
   :qid internal_vstd__view__impl&__48_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__48_trait_impl_definition
)))

;; Function-Specs curve25519_dalek::specs::field_specs_u64::p_gt_2
(declare-fun ens%curve25519_dalek!specs.field_specs_u64.p_gt_2. (Int) Bool)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!specs.field_specs_u64.p_gt_2. no%param) (and
     (> (curve25519_dalek!specs.field_specs_u64.p.? (I 0)) 2)
     (> (Sub (curve25519_dalek!specs.field_specs_u64.p.? (I 0)) 2) 0)
   ))
   :pattern ((ens%curve25519_dalek!specs.field_specs_u64.p_gt_2. no%param))
   :qid internal_ens__curve25519_dalek!specs.field_specs_u64.p_gt_2._definition
   :skolemid skolem_internal_ens__curve25519_dalek!specs.field_specs_u64.p_gt_2._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_edwards_add_commutative
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_commutative.
 (Int Int Int Int) Bool
)
(assert
 (forall ((x1! Int) (y1! Int) (x2! Int) (y2! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_commutative.
     x1! y1! x2! y2!
    ) (= (curve25519_dalek!specs.edwards_specs.edwards_add.? (I x1!) (I y1!) (I x2!) (I
       y2!
      )
     ) (curve25519_dalek!specs.edwards_specs.edwards_add.? (I x2!) (I y2!) (I x1!) (I y1!))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_commutative.
     x1! y1! x2! y2!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_commutative._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_commutative._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::axiom_edwards_add_associative
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_add_associative.
 (Int Int Int Int Int Int) Bool
)
(assert
 (forall ((x1! Int) (y1! Int) (x2! Int) (y2! Int) (x3! Int) (y3! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_add_associative.
     x1! y1! x2! y2! x3! y3!
    ) (= (let
      ((ab$ (curve25519_dalek!specs.edwards_specs.edwards_add.? (I x1!) (I y1!) (I x2!) (I
          y2!
      ))))
      (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
         (Poly%tuple%2. ab$)
        )
       ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. ab$))) (I x3!) (I y3!)
      )
     ) (let
      ((bc$ (curve25519_dalek!specs.edwards_specs.edwards_add.? (I x2!) (I y2!) (I x3!) (I
          y3!
      ))))
      (curve25519_dalek!specs.edwards_specs.edwards_add.? (I x1!) (I y1!) (tuple%2./tuple%2/0
        (%Poly%tuple%2. (Poly%tuple%2. bc$))
       ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. bc$)))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_add_associative.
     x1! y1! x2! y2! x3! y3!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_add_associative._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_add_associative._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_edwards_scalar_mul_succ
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_succ.
 (tuple%2. Int) Bool
)
(declare-const %%global_location_label%%11 Bool)
(assert
 (forall ((point_affine! tuple%2.) (n! Int)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_succ.
     point_affine! n!
    ) (=>
     %%global_location_label%%11
     (>= n! 1)
   ))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_succ.
     point_affine! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_succ._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_succ._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_succ.
 (tuple%2. Int) Bool
)
(assert
 (forall ((point_affine! tuple%2.) (n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_succ.
     point_affine! n!
    ) (= (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. point_affine!)
      (I (nClip (Add n! 1)))
     ) (let
      ((prev$ (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. point_affine!)
         (I n!)
      )))
      (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
         (Poly%tuple%2. prev$)
        )
       ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. prev$))) (tuple%2./tuple%2/0
        (%Poly%tuple%2. (Poly%tuple%2. point_affine!))
       ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. point_affine!)))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_succ.
     point_affine! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_succ._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_succ._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_edwards_add_identity_left
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_left.
 (Int Int) Bool
)
(assert
 (forall ((x! Int) (y! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_left.
     x! y!
    ) (= (curve25519_dalek!specs.edwards_specs.edwards_add.? (I 0) (I 1) (I x!) (I y!))
     (tuple%2./tuple%2 (I (EucMod x! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))))
      (I (EucMod y! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_left.
     x! y!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_left._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_left._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_scalar_mul_distributes_over_neg
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_scalar_mul_distributes_over_neg.
 (tuple%2. Int) Bool
)
(assert
 (forall ((P! tuple%2.) (n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_scalar_mul_distributes_over_neg.
     P! n!
    ) (= (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_neg.?
        (Poly%tuple%2. P!)
       )
      ) (I n!)
     ) (curve25519_dalek!specs.edwards_specs.edwards_neg.? (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.?
        (Poly%tuple%2. P!) (I n!)
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_scalar_mul_distributes_over_neg.
     P! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_scalar_mul_distributes_over_neg._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_scalar_mul_distributes_over_neg._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_edwards_scalar_mul_signed_composition
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_signed_composition.
 (tuple%2. Int Int) Bool
)
(assert
 (forall ((P! tuple%2.) (a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_signed_composition.
     P! a! b!
    ) (= (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.?
        (Poly%tuple%2. P!) (I a!)
       )
      ) (I b!)
     ) (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? (Poly%tuple%2.
       P!
      ) (I (Mul a! b!))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_signed_composition.
     P! a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_signed_composition._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_signed_composition._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::axiom_edwards_scalar_mul_signed_additive
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_scalar_mul_signed_additive.
 (tuple%2. Int Int) Bool
)
(assert
 (forall ((P! tuple%2.) (a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_scalar_mul_signed_additive.
     P! a! b!
    ) (= (let
      ((pa$ (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? (Poly%tuple%2.
          P!
         ) (I a!)
      )))
      (let
       ((pb$ (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? (Poly%tuple%2.
           P!
          ) (I b!)
       )))
       (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
          (Poly%tuple%2. pa$)
         )
        ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. pa$))) (tuple%2./tuple%2/0 (%Poly%tuple%2.
          (Poly%tuple%2. pb$)
         )
        ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. pb$)))
      ))
     ) (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? (Poly%tuple%2.
       P!
      ) (I (Add a! b!))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_scalar_mul_signed_additive.
     P! a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_scalar_mul_signed_additive._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_scalar_mul_signed_additive._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_edwards_add_identity_right_canonical
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_right_canonical.
 (tuple%2.) Bool
)
(declare-const %%global_location_label%%12 Bool)
(declare-const %%global_location_label%%13 Bool)
(assert
 (forall ((P! tuple%2.)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_right_canonical.
     P!
    ) (and
     (=>
      %%global_location_label%%12
      (< (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. P!)))) (curve25519_dalek!specs.field_specs_u64.p.?
        (I 0)
     )))
     (=>
      %%global_location_label%%13
      (< (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. P!)))) (curve25519_dalek!specs.field_specs_u64.p.?
        (I 0)
   )))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_right_canonical.
     P!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_right_canonical._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_right_canonical._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_right_canonical.
 (tuple%2.) Bool
)
(assert
 (forall ((P! tuple%2.)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_right_canonical.
     P!
    ) (= (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
        (Poly%tuple%2. P!)
       )
      ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. P!))) (I 0) (I 1)
     ) P!
   ))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_right_canonical.
     P!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_right_canonical._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_right_canonical._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_edwards_scalar_mul_identity
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_identity.
 (Int) Bool
)
(assert
 (forall ((n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_identity.
     n!
    ) (= (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_identity.?
        (I 0)
       )
      ) (I n!)
     ) (curve25519_dalek!specs.edwards_specs.edwards_identity.? (I 0))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_identity.
     n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_identity._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_identity._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::straus_lemmas::lemma_edwards_point_as_affine_canonical
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_edwards_point_as_affine_canonical.
 (curve25519_dalek!edwards.EdwardsPoint.) Bool
)
(assert
 (forall ((point! curve25519_dalek!edwards.EdwardsPoint.)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_edwards_point_as_affine_canonical.
     point!
    ) (and
     (< (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?
           (Poly%curve25519_dalek!edwards.EdwardsPoint. point!)
       ))))
      ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     )
     (< (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?
           (Poly%curve25519_dalek!edwards.EdwardsPoint. point!)
       ))))
      ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_edwards_point_as_affine_canonical.
     point!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_edwards_point_as_affine_canonical._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_edwards_point_as_affine_canonical._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::straus_lemmas::lemma_column_sum_canonical
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_canonical.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. vstd!seq.Seq<vstd!seq.Seq<i8.>.>. Int Int) Bool
)
(declare-const %%global_location_label%%14 Bool)
(declare-const %%global_location_label%%15 Bool)
(declare-const %%global_location_label%%16 Bool)
(declare-const %%global_location_label%%17 Bool)
(declare-const %%global_location_label%%18 Bool)
(declare-const %%global_location_label%%19 Bool)
(assert
 (forall ((points_affine! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (digits! vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)
   (j! Int) (n! Int)
  ) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_canonical.
     points_affine! digits! j! n!
    ) (and
     (=>
      %%global_location_label%%14
      (>= n! 0)
     )
     (=>
      %%global_location_label%%15
      (<= n! (vstd!seq.Seq.len.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
         points_affine!
     ))))
     (=>
      %%global_location_label%%16
      (<= n! (vstd!seq.Seq.len.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
         digits!
     ))))
     (=>
      %%global_location_label%%17
      (<= 0 j!)
     )
     (=>
      %%global_location_label%%18
      (forall ((k$ Poly)) (!
        (=>
         (has_type k$ INT)
         (=>
          (let
           ((tmp%%$ (%I k$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ n!)
          ))
          (< j! (vstd!seq.Seq.len.? $ (SINT 8) (vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq. $ (SINT
               8
              )
             ) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. digits!) k$
        )))))
        :pattern ((vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
           digits!
          ) k$
        ))
        :qid user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__lemma_column_sum_canonical_38
        :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__lemma_column_sum_canonical_38
     )))
     (=>
      %%global_location_label%%19
      (forall ((k$ Poly)) (!
        (=>
         (has_type k$ INT)
         (=>
          (let
           ((tmp%%$ (%I k$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ n!)
          ))
          (and
           (< (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2.
                 $ NAT $ NAT
                ) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. points_affine!) k$
             )))
            ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
           )
           (< (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2.
                 $ NAT $ NAT
                ) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. points_affine!) k$
             )))
            ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
        ))))
        :pattern ((vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
           points_affine!
          ) k$
        ))
        :qid user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__lemma_column_sum_canonical_39
        :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__lemma_column_sum_canonical_39
   )))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_canonical.
     points_affine! digits! j! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_canonical._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_canonical._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_canonical.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. vstd!seq.Seq<vstd!seq.Seq<i8.>.>. Int Int) Bool
)
(assert
 (forall ((points_affine! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (digits! vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)
   (j! Int) (n! Int)
  ) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_canonical.
     points_affine! digits! j! n!
    ) (and
     (< (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.?
           (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. points_affine!) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
            digits!
           ) (I j!) (I n!)
       ))))
      ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     )
     (< (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.?
           (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. points_affine!) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
            digits!
           ) (I j!) (I n!)
       ))))
      ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_canonical.
     points_affine! digits! j! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_canonical._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_canonical._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::straus_lemmas::lemma_column_sum_single
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_single.
 (tuple%2. vstd!seq.Seq<i8.>. Int) Bool
)
(declare-const %%global_location_label%%20 Bool)
(declare-const %%global_location_label%%21 Bool)
(declare-const %%global_location_label%%22 Bool)
(assert
 (forall ((P! tuple%2.) (d! vstd!seq.Seq<i8.>.) (j! Int)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_single.
     P! d! j!
    ) (and
     (=>
      %%global_location_label%%20
      (let
       ((tmp%%$ j!))
       (and
        (<= 0 tmp%%$)
        (< tmp%%$ (vstd!seq.Seq.len.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. d!)))
     )))
     (=>
      %%global_location_label%%21
      (< (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. P!)))) (curve25519_dalek!specs.field_specs_u64.p.?
        (I 0)
     )))
     (=>
      %%global_location_label%%22
      (< (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. P!)))) (curve25519_dalek!specs.field_specs_u64.p.?
        (I 0)
   )))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_single.
     P! d! j!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_single._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_single._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_single.
 (tuple%2. vstd!seq.Seq<i8.>. Int) Bool
)
(assert
 (forall ((P! tuple%2.) (d! vstd!seq.Seq<i8.>.) (j! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_single.
     P! d! j!
    ) (= (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.? (vstd!seq.Seq.push.?
       (DST $) (TYPE%tuple%2. $ NAT $ NAT) (vstd!seq.Seq.empty.? (DST $) (TYPE%tuple%2. $
         NAT $ NAT
        )
       ) (Poly%tuple%2. P!)
      ) (vstd!seq.Seq.push.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (vstd!seq.Seq.empty.? $ (TYPE%vstd!seq.Seq.
         $ (SINT 8)
        )
       ) (Poly%vstd!seq.Seq<i8.>. d!)
      ) (I j!) (I 1)
     ) (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? (Poly%tuple%2.
       P!
      ) (vstd!seq.Seq.index.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. d!) (I j!))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_single.
     P! d! j!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_single._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_single._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::straus_lemmas::lemma_column_sum_prefix_eq
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_prefix_eq.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. vstd!seq.Seq<vstd!seq.Seq<i8.>.>. vstd!seq.Seq<tuple%2<nat./nat.>.>.
  vstd!seq.Seq<vstd!seq.Seq<i8.>.>. Int Int
 ) Bool
)
(declare-const %%global_location_label%%23 Bool)
(declare-const %%global_location_label%%24 Bool)
(declare-const %%global_location_label%%25 Bool)
(declare-const %%global_location_label%%26 Bool)
(declare-const %%global_location_label%%27 Bool)
(declare-const %%global_location_label%%28 Bool)
(declare-const %%global_location_label%%29 Bool)
(assert
 (forall ((pts1! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (digs1! vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)
   (pts2! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (digs2! vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)
   (j! Int) (n! Int)
  ) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_prefix_eq.
     pts1! digs1! pts2! digs2! j! n!
    ) (and
     (=>
      %%global_location_label%%23
      (>= n! 0)
     )
     (=>
      %%global_location_label%%24
      (<= n! (vstd!seq.Seq.len.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
         pts1!
     ))))
     (=>
      %%global_location_label%%25
      (<= n! (vstd!seq.Seq.len.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
         pts2!
     ))))
     (=>
      %%global_location_label%%26
      (<= n! (vstd!seq.Seq.len.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
         digs1!
     ))))
     (=>
      %%global_location_label%%27
      (<= n! (vstd!seq.Seq.len.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
         digs2!
     ))))
     (=>
      %%global_location_label%%28
      (forall ((k$ Poly)) (!
        (=>
         (has_type k$ INT)
         (=>
          (let
           ((tmp%%$ (%I k$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ n!)
          ))
          (= (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
             pts1!
            ) k$
           ) (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
             pts2!
            ) k$
        ))))
        :pattern ((vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
           pts1!
          ) k$
        ))
        :qid user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__lemma_column_sum_prefix_eq_40
        :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__lemma_column_sum_prefix_eq_40
     )))
     (=>
      %%global_location_label%%29
      (forall ((k$ Poly)) (!
        (=>
         (has_type k$ INT)
         (=>
          (let
           ((tmp%%$ (%I k$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ n!)
          ))
          (= (vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
             digs1!
            ) k$
           ) (vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
             digs2!
            ) k$
        ))))
        :pattern ((vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
           digs1!
          ) k$
        ))
        :qid user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__lemma_column_sum_prefix_eq_41
        :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__lemma_column_sum_prefix_eq_41
   )))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_prefix_eq.
     pts1! digs1! pts2! digs2! j! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_prefix_eq._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_prefix_eq._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_prefix_eq.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. vstd!seq.Seq<vstd!seq.Seq<i8.>.>. vstd!seq.Seq<tuple%2<nat./nat.>.>.
  vstd!seq.Seq<vstd!seq.Seq<i8.>.>. Int Int
 ) Bool
)
(assert
 (forall ((pts1! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (digs1! vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)
   (pts2! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (digs2! vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)
   (j! Int) (n! Int)
  ) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_prefix_eq.
     pts1! digs1! pts2! digs2! j! n!
    ) (= (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.? (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
       pts1!
      ) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. digs1!) (I j!) (I n!)
     ) (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.? (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
       pts2!
      ) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. digs2!) (I j!) (I n!)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_prefix_eq.
     pts1! digs1! pts2! digs2! j! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_prefix_eq._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_prefix_eq._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::axiom_edwards_scalar_mul_distributive
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_scalar_mul_distributive.
 (tuple%2. tuple%2. Int) Bool
)
(assert
 (forall ((a! tuple%2.) (b! tuple%2.) (n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_scalar_mul_distributive.
     a! b! n!
    ) (= (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_add.?
        (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. a!))) (tuple%2./tuple%2/1 (%Poly%tuple%2.
          (Poly%tuple%2. a!)
         )
        ) (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. b!))) (tuple%2./tuple%2/1 (%Poly%tuple%2.
          (Poly%tuple%2. b!)
       )))
      ) (I n!)
     ) (let
      ((na$ (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. a!)
         (I n!)
      )))
      (let
       ((nb$ (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. b!)
          (I n!)
       )))
       (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
          (Poly%tuple%2. na$)
         )
        ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. na$))) (tuple%2./tuple%2/0 (%Poly%tuple%2.
          (Poly%tuple%2. nb$)
         )
        ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. nb$)))
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_scalar_mul_distributive.
     a! b! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_scalar_mul_distributive._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_scalar_mul_distributive._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::lemma_intermediate_sum_extend
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_intermediate_sum_extend.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. Int Int) Bool
)
(declare-const %%global_location_label%%30 Bool)
(declare-const %%global_location_label%%31 Bool)
(declare-const %%global_location_label%%32 Bool)
(assert
 (forall ((buckets! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (b! Int) (B! Int)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_intermediate_sum_extend.
     buckets! b! B!
    ) (and
     (=>
      %%global_location_label%%30
      (<= 0 b!)
     )
     (=>
      %%global_location_label%%31
      (< b! (Sub B! 1))
     )
     (=>
      %%global_location_label%%32
      (<= B! (vstd!seq.Seq.len.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
         buckets!
   ))))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_intermediate_sum_extend.
     buckets! b! B!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_intermediate_sum_extend._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_intermediate_sum_extend._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_intermediate_sum_extend.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. Int Int) Bool
)
(assert
 (forall ((buckets! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (b! Int) (B! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_intermediate_sum_extend.
     buckets! b! B!
    ) (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_intermediate_sum.?
      (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. buckets!) (I b!) (I B!)
     ) (let
      ((prev$ (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_intermediate_sum.?
         (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. buckets!) (I b!) (I (Sub B! 1))
      )))
      (let
       ((top$ (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
            buckets!
           ) (I (Sub B! 1))
       ))))
       (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
          (Poly%tuple%2. prev$)
         )
        ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. prev$))) (tuple%2./tuple%2/0
         (%Poly%tuple%2. (Poly%tuple%2. top$))
        ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. top$)))
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_intermediate_sum_extend.
     buckets! b! B!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_intermediate_sum_extend._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_intermediate_sum_extend._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::lemma_weighted_from_decompose
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_from_decompose.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. Int Int) Bool
)
(declare-const %%global_location_label%%33 Bool)
(declare-const %%global_location_label%%34 Bool)
(declare-const %%global_location_label%%35 Bool)
(declare-const %%global_location_label%%36 Bool)
(assert
 (forall ((buckets! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (b! Int) (B! Int)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_from_decompose.
     buckets! b! B!
    ) (and
     (=>
      %%global_location_label%%33
      (<= 0 b!)
     )
     (=>
      %%global_location_label%%34
      (< b! B!)
     )
     (=>
      %%global_location_label%%35
      (<= B! (vstd!seq.Seq.len.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
         buckets!
     ))))
     (=>
      %%global_location_label%%36
      (forall ((j$ Poly)) (!
        (=>
         (has_type j$ INT)
         (=>
          (let
           ((tmp%%$ (%I j$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ B!)
          ))
          (and
           (< (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2.
                 $ NAT $ NAT
                ) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. buckets!) j$
             )))
            ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
           )
           (< (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2.
                 $ NAT $ NAT
                ) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. buckets!) j$
             )))
            ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
        ))))
        :pattern ((vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
           buckets!
          ) j$
        ))
        :qid user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__lemma_weighted_from_decompose_45
        :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__lemma_weighted_from_decompose_45
   )))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_from_decompose.
     buckets! b! B!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_from_decompose._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_from_decompose._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_from_decompose.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. Int Int) Bool
)
(assert
 (forall ((buckets! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (b! Int) (B! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_from_decompose.
     buckets! b! B!
    ) (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_from.?
      (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. buckets!) (I b!) (I B!)
     ) (let
      ((w$ (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_from.?
         (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. buckets!) (I (Add b! 1)) (I B!)
      )))
      (let
       ((is$ (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_intermediate_sum.?
          (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. buckets!) (I b!) (I B!)
       )))
       (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
          (Poly%tuple%2. w$)
         )
        ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. w$))) (tuple%2./tuple%2/0 (%Poly%tuple%2.
          (Poly%tuple%2. is$)
         )
        ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. is$)))
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_from_decompose.
     buckets! b! B!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_from_decompose._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_from_decompose._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::lemma_running_sum_eq_weighted_from
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_running_sum_eq_weighted_from.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. Int Int) Bool
)
(declare-const %%global_location_label%%37 Bool)
(declare-const %%global_location_label%%38 Bool)
(declare-const %%global_location_label%%39 Bool)
(declare-const %%global_location_label%%40 Bool)
(assert
 (forall ((buckets! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (b! Int) (B! Int)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_running_sum_eq_weighted_from.
     buckets! b! B!
    ) (and
     (=>
      %%global_location_label%%37
      (<= 0 b!)
     )
     (=>
      %%global_location_label%%38
      (<= b! B!)
     )
     (=>
      %%global_location_label%%39
      (<= B! (vstd!seq.Seq.len.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
         buckets!
     ))))
     (=>
      %%global_location_label%%40
      (forall ((j$ Poly)) (!
        (=>
         (has_type j$ INT)
         (=>
          (let
           ((tmp%%$ (%I j$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ B!)
          ))
          (and
           (< (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2.
                 $ NAT $ NAT
                ) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. buckets!) j$
             )))
            ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
           )
           (< (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2.
                 $ NAT $ NAT
                ) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. buckets!) j$
             )))
            ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
        ))))
        :pattern ((vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
           buckets!
          ) j$
        ))
        :qid user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__lemma_running_sum_eq_weighted_from_51
        :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__lemma_running_sum_eq_weighted_from_51
   )))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_running_sum_eq_weighted_from.
     buckets! b! B!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_running_sum_eq_weighted_from._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_running_sum_eq_weighted_from._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_running_sum_eq_weighted_from.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. Int Int) Bool
)
(assert
 (forall ((buckets! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (b! Int) (B! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_running_sum_eq_weighted_from.
     buckets! b! B!
    ) (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_running_sum.?
      (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. buckets!) (I b!) (I B!)
     ) (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_from.?
      (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. buckets!) (I b!) (I B!)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_running_sum_eq_weighted_from.
     buckets! b! B!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_running_sum_eq_weighted_from._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_running_sum_eq_weighted_from._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::lemma_weighted_from_eq_weighted_bucket_sum
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_from_eq_weighted_bucket_sum.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. Int) Bool
)
(declare-const %%global_location_label%%41 Bool)
(declare-const %%global_location_label%%42 Bool)
(assert
 (forall ((buckets! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (B! Int)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_from_eq_weighted_bucket_sum.
     buckets! B!
    ) (and
     (=>
      %%global_location_label%%41
      (>= B! 0)
     )
     (=>
      %%global_location_label%%42
      (>= (vstd!seq.Seq.len.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
         buckets!
        )
       ) B!
   ))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_from_eq_weighted_bucket_sum.
     buckets! B!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_from_eq_weighted_bucket_sum._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_from_eq_weighted_bucket_sum._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_from_eq_weighted_bucket_sum.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. Int) Bool
)
(assert
 (forall ((buckets! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (B! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_from_eq_weighted_bucket_sum.
     buckets! B!
    ) (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_from.?
      (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. buckets!) (I 0) (I B!)
     ) (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_bucket_sum.?
      (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. buckets!) (I B!)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_from_eq_weighted_bucket_sum.
     buckets! B!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_from_eq_weighted_bucket_sum._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_from_eq_weighted_bucket_sum._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::lemma_running_sum_equals_weighted
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_running_sum_equals_weighted.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. Int) Bool
)
(declare-const %%global_location_label%%43 Bool)
(declare-const %%global_location_label%%44 Bool)
(declare-const %%global_location_label%%45 Bool)
(assert
 (forall ((buckets_affine! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (B! Int)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_running_sum_equals_weighted.
     buckets_affine! B!
    ) (and
     (=>
      %%global_location_label%%43
      (> B! 0)
     )
     (=>
      %%global_location_label%%44
      (= (vstd!seq.Seq.len.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
         buckets_affine!
        )
       ) B!
     ))
     (=>
      %%global_location_label%%45
      (forall ((j$ Poly)) (!
        (=>
         (has_type j$ INT)
         (=>
          (let
           ((tmp%%$ (%I j$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ B!)
          ))
          (and
           (< (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2.
                 $ NAT $ NAT
                ) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. buckets_affine!) j$
             )))
            ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
           )
           (< (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2.
                 $ NAT $ NAT
                ) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. buckets_affine!) j$
             )))
            ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
        ))))
        :pattern ((vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
           buckets_affine!
          ) j$
        ))
        :qid user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__lemma_running_sum_equals_weighted_59
        :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__lemma_running_sum_equals_weighted_59
   )))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_running_sum_equals_weighted.
     buckets_affine! B!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_running_sum_equals_weighted._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_running_sum_equals_weighted._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_running_sum_equals_weighted.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. Int) Bool
)
(assert
 (forall ((buckets_affine! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (B! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_running_sum_equals_weighted.
     buckets_affine! B!
    ) (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_running_sum.?
      (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. buckets_affine!) (I 0) (I B!)
     ) (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_bucket_sum.?
      (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. buckets_affine!) (I B!)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_running_sum_equals_weighted.
     buckets_affine! B!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_running_sum_equals_weighted._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_running_sum_equals_weighted._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::lemma_weighted_bucket_sum_all_identity
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_bucket_sum_all_identity.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. Int) Bool
)
(declare-const %%global_location_label%%46 Bool)
(declare-const %%global_location_label%%47 Bool)
(declare-const %%global_location_label%%48 Bool)
(assert
 (forall ((buckets! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (B! Int)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_bucket_sum_all_identity.
     buckets! B!
    ) (and
     (=>
      %%global_location_label%%46
      (>= B! 0)
     )
     (=>
      %%global_location_label%%47
      (>= (vstd!seq.Seq.len.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
         buckets!
        )
       ) B!
     ))
     (=>
      %%global_location_label%%48
      (forall ((j$ Poly)) (!
        (=>
         (has_type j$ INT)
         (=>
          (let
           ((tmp%%$ (%I j$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ B!)
          ))
          (= (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
              buckets!
             ) j$
            )
           ) (curve25519_dalek!specs.edwards_specs.edwards_identity.? (I 0))
        )))
        :pattern ((vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
           buckets!
          ) j$
        ))
        :qid user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__lemma_weighted_bucket_sum_all_identity_63
        :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__lemma_weighted_bucket_sum_all_identity_63
   )))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_bucket_sum_all_identity.
     buckets! B!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_bucket_sum_all_identity._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_bucket_sum_all_identity._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_bucket_sum_all_identity.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. Int) Bool
)
(assert
 (forall ((buckets! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (B! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_bucket_sum_all_identity.
     buckets! B!
    ) (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_bucket_sum.?
      (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. buckets!) (I B!)
     ) (curve25519_dalek!specs.edwards_specs.edwards_identity.? (I 0))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_bucket_sum_all_identity.
     buckets! B!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_bucket_sum_all_identity._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_bucket_sum_all_identity._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::lemma_weighted_bucket_sum_agree
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_bucket_sum_agree.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. vstd!seq.Seq<tuple%2<nat./nat.>.>. Int) Bool
)
(declare-const %%global_location_label%%49 Bool)
(declare-const %%global_location_label%%50 Bool)
(declare-const %%global_location_label%%51 Bool)
(declare-const %%global_location_label%%52 Bool)
(assert
 (forall ((a! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (b! vstd!seq.Seq<tuple%2<nat./nat.>.>.)
   (B! Int)
  ) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_bucket_sum_agree.
     a! b! B!
    ) (and
     (=>
      %%global_location_label%%49
      (>= B! 0)
     )
     (=>
      %%global_location_label%%50
      (>= (vstd!seq.Seq.len.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
         a!
        )
       ) B!
     ))
     (=>
      %%global_location_label%%51
      (>= (vstd!seq.Seq.len.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
         b!
        )
       ) B!
     ))
     (=>
      %%global_location_label%%52
      (forall ((j$ Poly)) (!
        (=>
         (has_type j$ INT)
         (=>
          (let
           ((tmp%%$ (%I j$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ B!)
          ))
          (= (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
             a!
            ) j$
           ) (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
             b!
            ) j$
        ))))
        :pattern ((vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
           a!
          ) j$
        ))
        :qid user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__lemma_weighted_bucket_sum_agree_68
        :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__lemma_weighted_bucket_sum_agree_68
   )))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_bucket_sum_agree.
     a! b! B!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_bucket_sum_agree._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_bucket_sum_agree._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_bucket_sum_agree.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. vstd!seq.Seq<tuple%2<nat./nat.>.>. Int) Bool
)
(assert
 (forall ((a! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (b! vstd!seq.Seq<tuple%2<nat./nat.>.>.)
   (B! Int)
  ) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_bucket_sum_agree.
     a! b! B!
    ) (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_bucket_sum.?
      (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. a!) (I B!)
     ) (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_bucket_sum.?
      (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. b!) (I B!)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_bucket_sum_agree.
     a! b! B!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_bucket_sum_agree._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_bucket_sum_agree._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::lemma_weighted_bucket_sum_add_to_bucket
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_bucket_sum_add_to_bucket.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. vstd!seq.Seq<tuple%2<nat./nat.>.>. Int tuple%2.
  Int
 ) Bool
)
(declare-const %%global_location_label%%53 Bool)
(declare-const %%global_location_label%%54 Bool)
(declare-const %%global_location_label%%55 Bool)
(declare-const %%global_location_label%%56 Bool)
(declare-const %%global_location_label%%57 Bool)
(assert
 (forall ((buckets_old! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (buckets_new! vstd!seq.Seq<tuple%2<nat./nat.>.>.)
   (idx! Int) (P! tuple%2.) (B! Int)
  ) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_bucket_sum_add_to_bucket.
     buckets_old! buckets_new! idx! P! B!
    ) (and
     (=>
      %%global_location_label%%53
      (let
       ((tmp%%$ idx!))
       (and
        (<= 0 tmp%%$)
        (< tmp%%$ B!)
     )))
     (=>
      %%global_location_label%%54
      (<= B! (vstd!seq.Seq.len.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
         buckets_old!
     ))))
     (=>
      %%global_location_label%%55
      (<= B! (vstd!seq.Seq.len.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
         buckets_new!
     ))))
     (=>
      %%global_location_label%%56
      (= (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
          buckets_new!
         ) (I idx!)
        )
       ) (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
          (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
            buckets_old!
           ) (I idx!)
         ))
        ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $
            NAT $ NAT
           ) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. buckets_old!) (I idx!)
         ))
        ) (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. P!))) (tuple%2./tuple%2/1 (%Poly%tuple%2.
          (Poly%tuple%2. P!)
     )))))
     (=>
      %%global_location_label%%57
      (forall ((j$ Poly)) (!
        (=>
         (has_type j$ INT)
         (=>
          (and
           (let
            ((tmp%%$ (%I j$)))
            (and
             (<= 0 tmp%%$)
             (< tmp%%$ B!)
           ))
           (not (= (%I j$) idx!))
          )
          (= (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
             buckets_new!
            ) j$
           ) (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
             buckets_old!
            ) j$
        ))))
        :pattern ((vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
           buckets_new!
          ) j$
        ))
        :qid user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__lemma_weighted_bucket_sum_add_to_bucket_71
        :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__lemma_weighted_bucket_sum_add_to_bucket_71
   )))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_bucket_sum_add_to_bucket.
     buckets_old! buckets_new! idx! P! B!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_bucket_sum_add_to_bucket._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_bucket_sum_add_to_bucket._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_bucket_sum_add_to_bucket.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. vstd!seq.Seq<tuple%2<nat./nat.>.>. Int tuple%2.
  Int
 ) Bool
)
(assert
 (forall ((buckets_old! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (buckets_new! vstd!seq.Seq<tuple%2<nat./nat.>.>.)
   (idx! Int) (P! tuple%2.) (B! Int)
  ) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_bucket_sum_add_to_bucket.
     buckets_old! buckets_new! idx! P! B!
    ) (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_bucket_sum.?
      (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. buckets_new!) (I B!)
     ) (let
      ((prev$ (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_bucket_sum.?
         (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. buckets_old!) (I B!)
      )))
      (let
       ((delta$ (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. P!)
          (I (nClip (Add idx! 1)))
       )))
       (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
          (Poly%tuple%2. prev$)
         )
        ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. prev$))) (tuple%2./tuple%2/0
         (%Poly%tuple%2. (Poly%tuple%2. delta$))
        ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. delta$)))
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_bucket_sum_add_to_bucket.
     buckets_old! buckets_new! idx! P! B!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_bucket_sum_add_to_bucket._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_weighted_bucket_sum_add_to_bucket._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::lemma_bucket_weighted_sum_equals_column_sum
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_bucket_weighted_sum_equals_column_sum.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. vstd!seq.Seq<vstd!seq.Seq<i8.>.>. Int Int Int)
 Bool
)
(declare-const %%global_location_label%%58 Bool)
(declare-const %%global_location_label%%59 Bool)
(declare-const %%global_location_label%%60 Bool)
(declare-const %%global_location_label%%61 Bool)
(declare-const %%global_location_label%%62 Bool)
(declare-const %%global_location_label%%63 Bool)
(declare-const %%global_location_label%%64 Bool)
(assert
 (forall ((points_affine! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (all_digits! vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)
   (col! Int) (n! Int) (num_buckets! Int)
  ) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_bucket_weighted_sum_equals_column_sum.
     points_affine! all_digits! col! n! num_buckets!
    ) (and
     (=>
      %%global_location_label%%58
      (<= 0 col!)
     )
     (=>
      %%global_location_label%%59
      (let
       ((tmp%%$ n!))
       (and
        (<= 0 tmp%%$)
        (<= tmp%%$ (vstd!seq.Seq.len.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
           points_affine!
     ))))))
     (=>
      %%global_location_label%%60
      (<= n! (vstd!seq.Seq.len.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
         all_digits!
     ))))
     (=>
      %%global_location_label%%61
      (> num_buckets! 0)
     )
     (=>
      %%global_location_label%%62
      (forall ((k$ Poly)) (!
        (=>
         (has_type k$ INT)
         (=>
          (let
           ((tmp%%$ (%I k$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ n!)
          ))
          (< col! (vstd!seq.Seq.len.? $ (SINT 8) (vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq. $
              (SINT 8)
             ) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. all_digits!) k$
        )))))
        :pattern ((vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
           all_digits!
          ) k$
        ))
        :qid user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__lemma_bucket_weighted_sum_equals_column_sum_78
        :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__lemma_bucket_weighted_sum_equals_column_sum_78
     )))
     (=>
      %%global_location_label%%63
      (forall ((k$ Poly)) (!
        (=>
         (has_type k$ INT)
         (=>
          (let
           ((tmp%%$ (%I k$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ n!)
          ))
          (let
           ((tmp%%$ (%I (vstd!seq.Seq.index.? $ (SINT 8) (vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq.
                 $ (SINT 8)
                ) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. all_digits!) k$
               ) (I col!)
           ))))
           (and
            (<= (Sub 0 num_buckets!) tmp%%$)
            (<= tmp%%$ num_buckets!)
        ))))
        :pattern ((vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
           all_digits!
          ) k$
        ))
        :qid user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__lemma_bucket_weighted_sum_equals_column_sum_79
        :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__lemma_bucket_weighted_sum_equals_column_sum_79
     )))
     (=>
      %%global_location_label%%64
      (forall ((k$ Poly)) (!
        (=>
         (has_type k$ INT)
         (=>
          (let
           ((tmp%%$ (%I k$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ n!)
          ))
          (and
           (< (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2.
                 $ NAT $ NAT
                ) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. points_affine!) k$
             )))
            ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
           )
           (< (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2.
                 $ NAT $ NAT
                ) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. points_affine!) k$
             )))
            ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
        ))))
        :pattern ((vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
           points_affine!
          ) k$
        ))
        :qid user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__lemma_bucket_weighted_sum_equals_column_sum_80
        :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__lemma_bucket_weighted_sum_equals_column_sum_80
   )))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_bucket_weighted_sum_equals_column_sum.
     points_affine! all_digits! col! n! num_buckets!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_bucket_weighted_sum_equals_column_sum._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_bucket_weighted_sum_equals_column_sum._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_bucket_weighted_sum_equals_column_sum.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. vstd!seq.Seq<vstd!seq.Seq<i8.>.>. Int Int Int)
 Bool
)
(declare-fun %%lambda%%3 (Poly Poly Poly Poly) %%Function%%)
(assert
 (forall ((%%hole%%0 Poly) (%%hole%%1 Poly) (%%hole%%2 Poly) (%%hole%%3 Poly) (b$ Poly))
  (!
   (= (%%apply%%0 (%%lambda%%3 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3) b$) (Poly%tuple%2.
     (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_bucket_contents.?
      %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 b$
   )))
   :pattern ((%%apply%%0 (%%lambda%%3 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3) b$))
)))
(assert
 (forall ((points_affine! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (all_digits! vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)
   (col! Int) (n! Int) (num_buckets! Int)
  ) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_bucket_weighted_sum_equals_column_sum.
     points_affine! all_digits! col! n! num_buckets!
    ) (= (let
      ((buckets$ (%Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. (vstd!seq.Seq.new.? (DST $) (TYPE%tuple%2.
           $ NAT $ NAT
          ) $ (TYPE%fun%1. $ INT (DST $) (TYPE%tuple%2. $ NAT $ NAT)) (I (nClip num_buckets!))
          (Poly%fun%1. (mk_fun (%%lambda%%3 (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. points_affine!)
             (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. all_digits!) (I col!) (I n!)
      )))))))
      (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_weighted_bucket_sum.?
       (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. buckets$) (I num_buckets!)
      )
     ) (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.? (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
       points_affine!
      ) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. all_digits!) (I col!) (I n!)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_bucket_weighted_sum_equals_column_sum.
     points_affine! all_digits! col! n! num_buckets!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_bucket_weighted_sum_equals_column_sum._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_bucket_weighted_sum_equals_column_sum._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::lemma_reconstruct_radix_2w_from_eq_helper
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_reconstruct_radix_2w_from_eq_helper.
 (vstd!seq.Seq<i8.>. Int Int Int) Bool
)
(declare-const %%global_location_label%%65 Bool)
(declare-const %%global_location_label%%66 Bool)
(assert
 (forall ((d! vstd!seq.Seq<i8.>.) (w! Int) (k! Int) (digits_count! Int)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_reconstruct_radix_2w_from_eq_helper.
     d! w! k! digits_count!
    ) (and
     (=>
      %%global_location_label%%65
      (>= (vstd!seq.Seq.len.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. d!)) digits_count!)
     )
     (=>
      %%global_location_label%%66
      (let
       ((tmp%%$ k!))
       (and
        (<= 0 tmp%%$)
        (<= tmp%%$ digits_count!)
   )))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_reconstruct_radix_2w_from_eq_helper.
     d! w! k! digits_count!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_reconstruct_radix_2w_from_eq_helper._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_reconstruct_radix_2w_from_eq_helper._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_reconstruct_radix_2w_from_eq_helper.
 (vstd!seq.Seq<i8.>. Int Int Int) Bool
)
(assert
 (forall ((d! vstd!seq.Seq<i8.>.) (w! Int) (k! Int) (digits_count! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_reconstruct_radix_2w_from_eq_helper.
     d! w! k! digits_count!
    ) (= (curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w_from.? (Poly%vstd!seq.Seq<i8.>.
       d!
      ) (I w!) (I k!) (I digits_count!)
     ) (curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w.? (vstd!seq.Seq.subrange.?
       $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. d!) (I k!) (I digits_count!)
      ) (I w!)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_reconstruct_radix_2w_from_eq_helper.
     d! w! k! digits_count!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_reconstruct_radix_2w_from_eq_helper._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_reconstruct_radix_2w_from_eq_helper._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::lemma_reconstruct_radix_2w_from_equals_reconstruct
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_reconstruct_radix_2w_from_equals_reconstruct.
 (vstd!seq.Seq<i8.>. Int Int) Bool
)
(declare-const %%global_location_label%%67 Bool)
(assert
 (forall ((d! vstd!seq.Seq<i8.>.) (w! Int) (digits_count! Int)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_reconstruct_radix_2w_from_equals_reconstruct.
     d! w! digits_count!
    ) (=>
     %%global_location_label%%67
     (>= (vstd!seq.Seq.len.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. d!)) digits_count!)
   ))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_reconstruct_radix_2w_from_equals_reconstruct.
     d! w! digits_count!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_reconstruct_radix_2w_from_equals_reconstruct._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_reconstruct_radix_2w_from_equals_reconstruct._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_reconstruct_radix_2w_from_equals_reconstruct.
 (vstd!seq.Seq<i8.>. Int Int) Bool
)
(assert
 (forall ((d! vstd!seq.Seq<i8.>.) (w! Int) (digits_count! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_reconstruct_radix_2w_from_equals_reconstruct.
     d! w! digits_count!
    ) (= (curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w_from.? (Poly%vstd!seq.Seq<i8.>.
       d!
      ) (I w!) (I 0) (I digits_count!)
     ) (curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w.? (vstd!seq.Seq.subrange.?
       $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. d!) (I 0) (I digits_count!)
      ) (I w!)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_reconstruct_radix_2w_from_equals_reconstruct.
     d! w! digits_count!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_reconstruct_radix_2w_from_equals_reconstruct._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_reconstruct_radix_2w_from_equals_reconstruct._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::lemma_pippenger_zero_points_from
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_pippenger_zero_points_from.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. vstd!seq.Seq<vstd!seq.Seq<i8.>.>. Int Int Int)
 Bool
)
(declare-const %%global_location_label%%68 Bool)
(declare-const %%global_location_label%%69 Bool)
(declare-const %%global_location_label%%70 Bool)
(assert
 (forall ((pts! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (digs! vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)
   (j! Int) (w! Int) (digits_count! Int)
  ) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_pippenger_zero_points_from.
     pts! digs! j! w! digits_count!
    ) (and
     (=>
      %%global_location_label%%68
      (= (vstd!seq.Seq.len.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
         pts!
        )
       ) 0
     ))
     (=>
      %%global_location_label%%69
      (= (vstd!seq.Seq.len.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
         digs!
        )
       ) 0
     ))
     (=>
      %%global_location_label%%70
      (let
       ((tmp%%$ j!))
       (and
        (<= 0 tmp%%$)
        (<= tmp%%$ digits_count!)
   )))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_pippenger_zero_points_from.
     pts! digs! j! w! digits_count!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_pippenger_zero_points_from._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_pippenger_zero_points_from._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_pippenger_zero_points_from.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. vstd!seq.Seq<vstd!seq.Seq<i8.>.>. Int Int Int)
 Bool
)
(assert
 (forall ((pts! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (digs! vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)
   (j! Int) (w! Int) (digits_count! Int)
  ) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_pippenger_zero_points_from.
     pts! digs! j! w! digits_count!
    ) (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_horner.? (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
       pts!
      ) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. digs!) (I j!) (I w!) (I digits_count!)
     ) (curve25519_dalek!specs.edwards_specs.edwards_identity.? (I 0))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_pippenger_zero_points_from.
     pts! digs! j! w! digits_count!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_pippenger_zero_points_from._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_pippenger_zero_points_from._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::lemma_pippenger_peel_last
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_pippenger_peel_last.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. vstd!seq.Seq<vstd!seq.Seq<i8.>.>. Int Int Int)
 Bool
)
(declare-const %%global_location_label%%71 Bool)
(declare-const %%global_location_label%%72 Bool)
(declare-const %%global_location_label%%73 Bool)
(declare-const %%global_location_label%%74 Bool)
(declare-const %%global_location_label%%75 Bool)
(assert
 (forall ((pts! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (digs! vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)
   (j! Int) (w! Int) (digits_count! Int)
  ) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_pippenger_peel_last.
     pts! digs! j! w! digits_count!
    ) (and
     (=>
      %%global_location_label%%71
      (>= (vstd!seq.Seq.len.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
         pts!
        )
       ) 1
     ))
     (=>
      %%global_location_label%%72
      (= (vstd!seq.Seq.len.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
         digs!
        )
       ) (vstd!seq.Seq.len.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
         pts!
     ))))
     (=>
      %%global_location_label%%73
      (let
       ((tmp%%$ j!))
       (and
        (<= 0 tmp%%$)
        (<= tmp%%$ digits_count!)
     )))
     (=>
      %%global_location_label%%74
      (forall ((k$ Poly)) (!
        (=>
         (has_type k$ INT)
         (=>
          (let
           ((tmp%%$ (%I k$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ (vstd!seq.Seq.len.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
               digs!
          )))))
          (>= (vstd!seq.Seq.len.? $ (SINT 8) (vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq. $ (SINT
               8
              )
             ) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. digs!) k$
            )
           ) digits_count!
        )))
        :pattern ((vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
           digs!
          ) k$
        ))
        :qid user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__lemma_pippenger_peel_last_101
        :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__lemma_pippenger_peel_last_101
     )))
     (=>
      %%global_location_label%%75
      (forall ((k$ Poly)) (!
        (=>
         (has_type k$ INT)
         (=>
          (let
           ((tmp%%$ (%I k$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ (vstd!seq.Seq.len.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
               pts!
          )))))
          (and
           (< (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2.
                 $ NAT $ NAT
                ) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. pts!) k$
             )))
            ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
           )
           (< (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2.
                 $ NAT $ NAT
                ) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. pts!) k$
             )))
            ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
        ))))
        :pattern ((vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
           pts!
          ) k$
        ))
        :qid user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__lemma_pippenger_peel_last_102
        :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__pippenger_lemmas__lemma_pippenger_peel_last_102
   )))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_pippenger_peel_last.
     pts! digs! j! w! digits_count!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_pippenger_peel_last._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_pippenger_peel_last._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_pippenger_peel_last.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. vstd!seq.Seq<vstd!seq.Seq<i8.>.>. Int Int Int)
 Bool
)
(assert
 (forall ((pts! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (digs! vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)
   (j! Int) (w! Int) (digits_count! Int)
  ) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_pippenger_peel_last.
     pts! digs! j! w! digits_count!
    ) (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_horner.? (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
       pts!
      ) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. digs!) (I j!) (I w!) (I digits_count!)
     ) (let
      ((prefix_result$ (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_horner.?
         (vstd!seq_lib.impl&%0.drop_last.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
           pts!
          )
         ) (vstd!seq_lib.impl&%0.drop_last.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
           digs!
          )
         ) (I j!) (I w!) (I digits_count!)
      )))
      (let
       ((single_result$ (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_horner.?
          (vstd!seq.Seq.push.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (vstd!seq.Seq.empty.? (DST
             $
            ) (TYPE%tuple%2. $ NAT $ NAT)
           ) (vstd!seq.Seq.last.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
             pts!
           ))
          ) (vstd!seq.Seq.push.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (vstd!seq.Seq.empty.? $ (TYPE%vstd!seq.Seq.
             $ (SINT 8)
            )
           ) (vstd!seq.Seq.last.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
             digs!
           ))
          ) (I j!) (I w!) (I digits_count!)
       )))
       (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
          (Poly%tuple%2. prefix_result$)
         )
        ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. prefix_result$))) (tuple%2./tuple%2/0
         (%Poly%tuple%2. (Poly%tuple%2. single_result$))
        ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. single_result$)))
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_pippenger_peel_last.
     pts! digs! j! w! digits_count!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_pippenger_peel_last._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_pippenger_peel_last._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::lemma_pippenger_single
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_pippenger_single.
 (tuple%2. vstd!seq.Seq<i8.>. Int Int Int) Bool
)
(declare-const %%global_location_label%%76 Bool)
(declare-const %%global_location_label%%77 Bool)
(declare-const %%global_location_label%%78 Bool)
(declare-const %%global_location_label%%79 Bool)
(declare-const %%global_location_label%%80 Bool)
(assert
 (forall ((P! tuple%2.) (d! vstd!seq.Seq<i8.>.) (j! Int) (w! Int) (digits_count! Int))
  (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_pippenger_single.
     P! d! j! w! digits_count!
    ) (and
     (=>
      %%global_location_label%%76
      (>= (vstd!seq.Seq.len.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. d!)) digits_count!)
     )
     (=>
      %%global_location_label%%77
      (< (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. P!)))) (curve25519_dalek!specs.field_specs_u64.p.?
        (I 0)
     )))
     (=>
      %%global_location_label%%78
      (< (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. P!)))) (curve25519_dalek!specs.field_specs_u64.p.?
        (I 0)
     )))
     (=>
      %%global_location_label%%79
      (let
       ((tmp%%$ j!))
       (and
        (<= 0 tmp%%$)
        (<= tmp%%$ digits_count!)
     )))
     (=>
      %%global_location_label%%80
      (>= w! 1)
   )))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_pippenger_single.
     P! d! j! w! digits_count!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_pippenger_single._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_pippenger_single._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_pippenger_single.
 (tuple%2. vstd!seq.Seq<i8.>. Int Int Int) Bool
)
(assert
 (forall ((P! tuple%2.) (d! vstd!seq.Seq<i8.>.) (j! Int) (w! Int) (digits_count! Int))
  (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_pippenger_single.
     P! d! j! w! digits_count!
    ) (= (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_horner.? (vstd!seq.Seq.push.?
       (DST $) (TYPE%tuple%2. $ NAT $ NAT) (vstd!seq.Seq.empty.? (DST $) (TYPE%tuple%2. $
         NAT $ NAT
        )
       ) (Poly%tuple%2. P!)
      ) (vstd!seq.Seq.push.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (vstd!seq.Seq.empty.? $ (TYPE%vstd!seq.Seq.
         $ (SINT 8)
        )
       ) (Poly%vstd!seq.Seq<i8.>. d!)
      ) (I j!) (I w!) (I digits_count!)
     ) (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? (Poly%tuple%2.
       P!
      ) (I (curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w_from.? (Poly%vstd!seq.Seq<i8.>.
         d!
        ) (I w!) (I j!) (I digits_count!)
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_pippenger_single.
     P! d! j! w! digits_count!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_pippenger_single._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_pippenger_single._definition
)))

;; Function-Def curve25519_dalek::lemmas::edwards_lemmas::pippenger_lemmas::lemma_pippenger_single
;; curve25519-dalek/src/lemmas/edwards_lemmas/pippenger_lemmas.rs:344:1: 344:98 (#0)
(get-info :all-statistics)
(push)
 (declare-const P! tuple%2.)
 (declare-const d! vstd!seq.Seq<i8.>.)
 (declare-const j! Int)
 (declare-const w! Int)
 (declare-const digits_count! Int)
 (declare-const tmp%1 Int)
 (declare-const tmp%2 Int)
 (declare-const tmp%3 Int)
 (declare-const tmp%4 Int)
 (declare-const tmp%5 Bool)
 (declare-const r_next@ Int)
 (declare-const decrease%init0 Int)
 (assert
  fuel_defaults
 )
 (assert
  (has_type (Poly%tuple%2. P!) (TYPE%tuple%2. $ NAT $ NAT))
 )
 (assert
  (<= 0 w!)
 )
 (assert
  (<= 0 digits_count!)
 )
 (assert
  (>= (vstd!seq.Seq.len.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. d!)) digits_count!)
 )
 (assert
  (< (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. P!)))) (curve25519_dalek!specs.field_specs_u64.p.?
    (I 0)
 )))
 (assert
  (< (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. P!)))) (curve25519_dalek!specs.field_specs_u64.p.?
    (I 0)
 )))
 (assert
  (let
   ((tmp%%$ j!))
   (and
    (<= 0 tmp%%$)
    (<= tmp%%$ digits_count!)
 )))
 (assert
  (>= w! 1)
 )
 (declare-const %%switch_label%%0 Bool)
 ;; could not prove termination
 (declare-const %%location_label%%0 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%1 Bool)
 ;; assertion failed
 (declare-const %%location_label%%2 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%3 Bool)
 ;; assertion failed
 (declare-const %%location_label%%4 Bool)
 ;; assertion failed
 (declare-const %%location_label%%5 Bool)
 ;; assertion failed
 (declare-const %%location_label%%6 Bool)
 ;; postcondition not satisfied
 (declare-const %%location_label%%7 Bool)
 (assert
  (not (=>
    (= decrease%init0 (Sub digits_count! j!))
    (=>
     (fuel_bool fuel%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_horner.)
     (or
      (and
       (=>
        (>= j! digits_count!)
        (=>
         (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.)
         (=>
          (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.)
          %%switch_label%%0
       )))
       (=>
        (not (>= j! digits_count!))
        (=>
         (= tmp%1 (Add j! 1))
         (and
          (=>
           %%location_label%%0
           (check_decrease_int (let
             ((P!$0 P!) (d!$1 d!) (j!$2 tmp%1) (w!$3 w!) (digits_count!$4 digits_count!))
             (Sub digits_count!$4 j!$2)
            ) decrease%init0 false
          ))
          (and
           (=>
            %%location_label%%1
            (req%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_pippenger_single.
             P! d! tmp%1 w! digits_count!
           ))
           (=>
            (ens%curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.lemma_pippenger_single.
             P! d! tmp%1 w! digits_count!
            )
            (=>
             (= r_next@ (curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w_from.? (Poly%vstd!seq.Seq<i8.>.
                d!
               ) (I w!) (I (Add j! 1)) (I digits_count!)
             ))
             (and
              (=>
               (= tmp%2 (vstd!arithmetic.power2.pow2.? (I w!)))
               (=>
                (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_scalar_mul_signed_composition.
                 P! r_next@ tmp%2
                )
                (=>
                 %%location_label%%2
                 (ext_eq false (TYPE%tuple%2. $ NAT $ NAT) (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.?
                    (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? (Poly%tuple%2.
                       P!
                      ) (I r_next@)
                     )
                    ) (I (vstd!arithmetic.power2.pow2.? (I w!)))
                   )
                  ) (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.?
                    (Poly%tuple%2. P!) (I (Mul r_next@ (vstd!arithmetic.power2.pow2.? (I w!))))
              ))))))
              (=>
               (= (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.?
                   (Poly%tuple%2. P!) (I r_next@)
                  )
                 ) (I (vstd!arithmetic.power2.pow2.? (I w!)))
                ) (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? (Poly%tuple%2.
                  P!
                 ) (I (Mul r_next@ (vstd!arithmetic.power2.pow2.? (I w!))))
               ))
               (and
                (and
                 (=>
                  %%location_label%%3
                  (req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_single.
                   P! d! j!
                 ))
                 (=>
                  (ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_single.
                   P! d! j!
                  )
                  (=>
                   %%location_label%%4
                   (ext_eq false (TYPE%tuple%2. $ NAT $ NAT) (Poly%tuple%2. (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.?
                      (vstd!seq.Seq.push.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (vstd!seq.Seq.empty.? (DST
                         $
                        ) (TYPE%tuple%2. $ NAT $ NAT)
                       ) (Poly%tuple%2. P!)
                      ) (vstd!seq.Seq.push.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (vstd!seq.Seq.empty.? $ (TYPE%vstd!seq.Seq.
                         $ (SINT 8)
                        )
                       ) (Poly%vstd!seq.Seq<i8.>. d!)
                      ) (I j!) (I 1)
                     )
                    ) (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.?
                      (Poly%tuple%2. P!) (vstd!seq.Seq.index.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. d!) (
                        I j!
                ))))))))
                (=>
                 (= (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.? (vstd!seq.Seq.push.?
                    (DST $) (TYPE%tuple%2. $ NAT $ NAT) (vstd!seq.Seq.empty.? (DST $) (TYPE%tuple%2. $
                      NAT $ NAT
                     )
                    ) (Poly%tuple%2. P!)
                   ) (vstd!seq.Seq.push.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (vstd!seq.Seq.empty.? $ (TYPE%vstd!seq.Seq.
                      $ (SINT 8)
                     )
                    ) (Poly%vstd!seq.Seq<i8.>. d!)
                   ) (I j!) (I 1)
                  ) (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? (Poly%tuple%2.
                    P!
                   ) (vstd!seq.Seq.index.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. d!) (I j!))
                 ))
                 (and
                  (=>
                   (= tmp%3 (Mul (vstd!arithmetic.power2.pow2.? (I w!)) r_next@))
                   (=>
                    (= tmp%4 (%I (vstd!seq.Seq.index.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. d!) (I j!))))
                    (=>
                     (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_scalar_mul_signed_additive.
                      P! tmp%3 tmp%4
                     )
                     (=>
                      %%location_label%%5
                      (ext_eq false (TYPE%tuple%2. $ NAT $ NAT) (Poly%tuple%2. (let
                         ((pa$ (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? (Poly%tuple%2.
                             P!
                            ) (I (Mul (vstd!arithmetic.power2.pow2.? (I w!)) r_next@))
                         )))
                         (let
                          ((pb$ (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? (Poly%tuple%2.
                              P!
                             ) (vstd!seq.Seq.index.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. d!) (I j!))
                          )))
                          (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
                             (Poly%tuple%2. pa$)
                            )
                           ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. pa$))) (tuple%2./tuple%2/0 (%Poly%tuple%2.
                             (Poly%tuple%2. pb$)
                            )
                           ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. pb$)))
                        )))
                       ) (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.?
                         (Poly%tuple%2. P!) (I (Add (Mul (vstd!arithmetic.power2.pow2.? (I w!)) r_next@) (%I
                            (vstd!seq.Seq.index.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. d!) (I j!))
                  ))))))))))
                  (=>
                   (= (let
                     ((pa$ (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? (Poly%tuple%2.
                         P!
                        ) (I (Mul (vstd!arithmetic.power2.pow2.? (I w!)) r_next@))
                     )))
                     (let
                      ((pb$ (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? (Poly%tuple%2.
                          P!
                         ) (vstd!seq.Seq.index.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. d!) (I j!))
                      )))
                      (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
                         (Poly%tuple%2. pa$)
                        )
                       ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. pa$))) (tuple%2./tuple%2/0 (%Poly%tuple%2.
                         (Poly%tuple%2. pb$)
                        )
                       ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. pb$)))
                     ))
                    ) (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? (Poly%tuple%2.
                      P!
                     ) (I (Add (Mul (vstd!arithmetic.power2.pow2.? (I w!)) r_next@) (%I (vstd!seq.Seq.index.?
                         $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. d!) (I j!)
                   ))))))
                   (=>
                    (= tmp%5 (= (Add (%I (vstd!seq.Seq.index.? $ (SINT 8) (Poly%vstd!seq.Seq<i8.>. d!) (I j!)))
                       (Mul (vstd!arithmetic.power2.pow2.? (I w!)) r_next@)
                      ) (curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w_from.? (Poly%vstd!seq.Seq<i8.>.
                        d!
                       ) (I w!) (I j!) (I digits_count!)
                    )))
                    (and
                     (=>
                      %%location_label%%6
                      tmp%5
                     )
                     (=>
                      tmp%5
                      %%switch_label%%0
      ))))))))))))))))
      (and
       (not %%switch_label%%0)
       (=>
        %%location_label%%7
        (ext_eq false (TYPE%tuple%2. $ NAT $ NAT) (Poly%tuple%2. (curve25519_dalek!lemmas.edwards_lemmas.pippenger_lemmas.pippenger_horner.?
           (vstd!seq.Seq.push.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (vstd!seq.Seq.empty.? (DST
              $
             ) (TYPE%tuple%2. $ NAT $ NAT)
            ) (Poly%tuple%2. P!)
           ) (vstd!seq.Seq.push.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (vstd!seq.Seq.empty.? $ (TYPE%vstd!seq.Seq.
              $ (SINT 8)
             )
            ) (Poly%vstd!seq.Seq<i8.>. d!)
           ) (I j!) (I w!) (I digits_count!)
          )
         ) (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.?
           (Poly%tuple%2. P!) (I (curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w_from.?
             (Poly%vstd!seq.Seq<i8.>. d!) (I w!) (I j!) (I digits_count!)
 ))))))))))))
 (get-info :version)
 (set-option :rlimit 30000000)
 (check-sat)
 (set-option :rlimit 0)
(pop)
