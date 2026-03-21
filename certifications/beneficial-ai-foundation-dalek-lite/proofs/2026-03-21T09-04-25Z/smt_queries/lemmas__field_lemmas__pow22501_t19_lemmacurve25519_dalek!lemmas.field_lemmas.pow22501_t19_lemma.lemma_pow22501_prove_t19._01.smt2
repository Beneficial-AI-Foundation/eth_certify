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

;; MODULE 'module lemmas::field_lemmas::pow22501_t19_lemma'
;; curve25519-dalek/src/lemmas/field_lemmas/pow22501_t19_lemma.rs:66:1: 88:2 (#0)

;; query spun off because: spinoff_all

;; Fuel
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_general. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_nonnegative. FuelId)
(declare-const fuel%vstd!arithmetic.power.lemma_pow_adds. FuelId)
(declare-const fuel%vstd!arithmetic.power.lemma_pow_multiplies. FuelId)
(declare-const fuel%vstd!arithmetic.power2.lemma_pow2_pos. FuelId)
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
(declare-const fuel%vstd!seq.axiom_seq_index_decreases. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_new_len. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_new_index. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_ext_equal. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_ext_equal_deep. FuelId)
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
(declare-const fuel%vstd!view.impl&%22.view. FuelId)
(declare-const fuel%vstd!view.impl&%26.view. FuelId)
(declare-const fuel%vstd!view.impl&%32.view. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.p. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat. FuelId)
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
 (distinct fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_general. fuel%vstd!arithmetic.mul.lemma_mul_nonnegative.
  fuel%vstd!arithmetic.power.lemma_pow_adds. fuel%vstd!arithmetic.power.lemma_pow_multiplies.
  fuel%vstd!arithmetic.power2.lemma_pow2_pos. fuel%vstd!array.array_view. fuel%vstd!array.impl&%0.view.
  fuel%vstd!array.impl&%2.spec_index. fuel%vstd!array.lemma_array_index. fuel%vstd!array.array_len_matches_n.
  fuel%vstd!array.axiom_array_ext_equal. fuel%vstd!array.axiom_array_has_resolved.
  fuel%vstd!raw_ptr.impl&%3.view. fuel%vstd!raw_ptr.ptrs_mut_eq. fuel%vstd!raw_ptr.ptrs_mut_eq_sized.
  fuel%vstd!seq.impl&%0.spec_index. fuel%vstd!seq.axiom_seq_index_decreases. fuel%vstd!seq.axiom_seq_new_len.
  fuel%vstd!seq.axiom_seq_new_index. fuel%vstd!seq.axiom_seq_ext_equal. fuel%vstd!seq.axiom_seq_ext_equal_deep.
  fuel%vstd!slice.impl&%2.spec_index. fuel%vstd!slice.axiom_spec_len. fuel%vstd!slice.axiom_slice_ext_equal.
  fuel%vstd!slice.axiom_slice_has_resolved. fuel%vstd!view.impl&%0.view. fuel%vstd!view.impl&%2.view.
  fuel%vstd!view.impl&%4.view. fuel%vstd!view.impl&%6.view. fuel%vstd!view.impl&%12.view.
  fuel%vstd!view.impl&%14.view. fuel%vstd!view.impl&%22.view. fuel%vstd!view.impl&%26.view.
  fuel%vstd!view.impl&%32.view. fuel%curve25519_dalek!specs.field_specs_u64.p. fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.
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
   (fuel_bool_default fuel%vstd!seq.axiom_seq_new_len.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_new_index.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_ext_equal.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_ext_equal_deep.)
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
(declare-sort allocator_global%. 0)
(declare-datatypes ((vstd!raw_ptr.PtrData. 0) (tuple%0. 0)) (((vstd!raw_ptr.PtrData./PtrData
    (vstd!raw_ptr.PtrData./PtrData/?addr Int) (vstd!raw_ptr.PtrData./PtrData/?provenance
     vstd!raw_ptr.Provenance.
    ) (vstd!raw_ptr.PtrData./PtrData/?metadata Poly)
   )
  ) ((tuple%0./tuple%0))
))
(declare-fun vstd!raw_ptr.PtrData./PtrData/addr (vstd!raw_ptr.PtrData.) Int)
(declare-fun vstd!raw_ptr.PtrData./PtrData/provenance (vstd!raw_ptr.PtrData.) vstd!raw_ptr.Provenance.)
(declare-fun vstd!raw_ptr.PtrData./PtrData/metadata (vstd!raw_ptr.PtrData.) Poly)
(declare-fun TYPE%fun%1. (Dcr Type Dcr Type) Type)
(declare-const TYPE%vstd!raw_ptr.Provenance. Type)
(declare-fun TYPE%vstd!raw_ptr.PtrData. (Dcr Type) Type)
(declare-fun TYPE%vstd!seq.Seq. (Dcr Type) Type)
(declare-fun Poly%fun%1. (%%Function%%) Poly)
(declare-fun %Poly%fun%1. (Poly) %%Function%%)
(declare-fun Poly%array%. (%%Function%%) Poly)
(declare-fun %Poly%array%. (Poly) %%Function%%)
(declare-fun Poly%vstd!raw_ptr.Provenance. (vstd!raw_ptr.Provenance.) Poly)
(declare-fun %Poly%vstd!raw_ptr.Provenance. (Poly) vstd!raw_ptr.Provenance.)
(declare-fun Poly%allocator_global%. (allocator_global%.) Poly)
(declare-fun %Poly%allocator_global%. (Poly) allocator_global%.)
(declare-fun Poly%vstd!raw_ptr.PtrData. (vstd!raw_ptr.PtrData.) Poly)
(declare-fun %Poly%vstd!raw_ptr.PtrData. (Poly) vstd!raw_ptr.PtrData.)
(declare-fun Poly%tuple%0. (tuple%0.) Poly)
(declare-fun %Poly%tuple%0. (Poly) tuple%0.)
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
 (= (proj%%vstd!view.View./V $ (SINT 32)) $)
)
(assert
 (= (proj%vstd!view.View./V $ (SINT 32)) (SINT 32))
)

;; Function-Decl vstd::seq::Seq::len
(declare-fun vstd!seq.Seq.len.? (Dcr Type Poly) Int)

;; Function-Decl vstd::seq::Seq::index
(declare-fun vstd!seq.Seq.index.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::impl&%0::spec_index
(declare-fun vstd!seq.impl&%0.spec_index.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::Seq::new
(declare-fun vstd!seq.Seq.new.? (Dcr Type Dcr Type Poly Poly) Poly)

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

;; Function-Decl vstd::arithmetic::power::pow
(declare-fun vstd!arithmetic.power.pow.? (Poly Poly) Int)

;; Function-Decl vstd::arithmetic::power2::pow2
(declare-fun vstd!arithmetic.power2.pow2.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::p
(declare-fun curve25519_dalek!specs.field_specs_u64.p.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::u64_5_as_nat
(declare-fun curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly) Int)

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
    :qid user_vstd__seq__axiom_seq_new_len_1
    :skolemid skolem_user_vstd__seq__axiom_seq_new_len_1
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
    :qid user_vstd__seq__axiom_seq_new_index_2
    :skolemid skolem_user_vstd__seq__axiom_seq_new_index_2
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
          :qid user_vstd__seq__axiom_seq_ext_equal_3
          :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_3
    ))))))
    :pattern ((ext_eq false (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_4
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_4
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
          :qid user_vstd__seq__axiom_seq_ext_equal_deep_5
          :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_5
    ))))))
    :pattern ((ext_eq true (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_deep_6
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_6
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
    :qid user_vstd__slice__axiom_spec_len_7
    :skolemid skolem_user_vstd__slice__axiom_spec_len_7
))))

;; Function-Specs vstd::slice::SliceAdditionalSpecFns::spec_index
(declare-fun req%vstd!slice.SliceAdditionalSpecFns.spec_index. (Dcr Type Dcr Type Poly
  Poly
 ) Bool
)
(declare-const %%global_location_label%%2 Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (
   !
   (= (req%vstd!slice.SliceAdditionalSpecFns.spec_index. Self%&. Self%& T&. T& self! i!)
    (=>
     %%global_location_label%%2
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
          :qid user_vstd__slice__axiom_slice_ext_equal_8
          :skolemid skolem_user_vstd__slice__axiom_slice_ext_equal_8
    ))))))
    :pattern ((ext_eq false (SLICE T&. T&) a1! a2!))
    :qid user_vstd__slice__axiom_slice_ext_equal_9
    :skolemid skolem_user_vstd__slice__axiom_slice_ext_equal_9
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
    :qid user_vstd__slice__axiom_slice_has_resolved_10
    :skolemid skolem_user_vstd__slice__axiom_slice_has_resolved_10
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
    :qid user_vstd__array__array_len_matches_n_11
    :skolemid skolem_user_vstd__array__array_len_matches_n_11
))))

;; Function-Specs vstd::array::ArrayAdditionalSpecFns::spec_index
(declare-fun req%vstd!array.ArrayAdditionalSpecFns.spec_index. (Dcr Type Dcr Type Poly
  Poly
 ) Bool
)
(declare-const %%global_location_label%%3 Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (
   !
   (= (req%vstd!array.ArrayAdditionalSpecFns.spec_index. Self%&. Self%& T&. T& self! i!)
    (=>
     %%global_location_label%%3
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
    :qid user_vstd__array__lemma_array_index_12
    :skolemid skolem_user_vstd__array__lemma_array_index_12
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
         :qid user_vstd__array__axiom_array_ext_equal_13
         :skolemid skolem_user_vstd__array__axiom_array_ext_equal_13
    )))))
    :pattern ((ext_eq false (ARRAY T&. T& N&. N&) a1! a2!))
    :qid user_vstd__array__axiom_array_ext_equal_14
    :skolemid skolem_user_vstd__array__axiom_array_ext_equal_14
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
    :qid user_vstd__array__axiom_array_has_resolved_15
    :skolemid skolem_user_vstd__array__axiom_array_has_resolved_15
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
    :qid user_vstd__raw_ptr__ptrs_mut_eq_16
    :skolemid skolem_user_vstd__raw_ptr__ptrs_mut_eq_16
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
    :qid user_vstd__raw_ptr__ptrs_mut_eq_sized_17
    :skolemid skolem_user_vstd__raw_ptr__ptrs_mut_eq_sized_17
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mul_mod_noop_general
(declare-fun req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_general. (Int Int Int)
 Bool
)
(declare-const %%global_location_label%%4 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_general. x! y! m!) (=>
     %%global_location_label%%4
     (< 0 m!)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_general. x! y! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mul_mod_noop_general._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mul_mod_noop_general._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mul_mod_noop_general. (Int Int Int)
 Bool
)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mul_mod_noop_general. x! y! m!) (and
     (= (EucMod (Mul (EucMod x! m!) y!) m!) (EucMod (Mul x! y!) m!))
     (= (EucMod (Mul x! (EucMod y! m!)) m!) (EucMod (Mul x! y!) m!))
     (= (EucMod (Mul (EucMod x! m!) (EucMod y! m!)) m!) (EucMod (Mul x! y!) m!))
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mul_mod_noop_general. x! y! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mul_mod_noop_general._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mul_mod_noop_general._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mul_mod_noop_general
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_general.)
  (forall ((x! Int) (y! Int) (m! Int)) (!
    (=>
     (< 0 m!)
     (and
      (and
       (= (EucMod (Mul (EucMod x! m!) y!) m!) (EucMod (Mul x! y!) m!))
       (= (EucMod (Mul x! (EucMod y! m!)) m!) (EucMod (Mul x! y!) m!))
      )
      (= (EucMod (Mul (EucMod x! m!) (EucMod y! m!)) m!) (EucMod (Mul x! y!) m!))
    ))
    :pattern ((EucMod (Mul x! y!) m!))
    :qid user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_general_18
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_general_18
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_nonnegative
(declare-fun req%vstd!arithmetic.mul.lemma_mul_nonnegative. (Int Int) Bool)
(declare-const %%global_location_label%%5 Bool)
(declare-const %%global_location_label%%6 Bool)
(assert
 (forall ((x! Int) (y! Int)) (!
   (= (req%vstd!arithmetic.mul.lemma_mul_nonnegative. x! y!) (and
     (=>
      %%global_location_label%%5
      (<= 0 x!)
     )
     (=>
      %%global_location_label%%6
      (<= 0 y!)
   )))
   :pattern ((req%vstd!arithmetic.mul.lemma_mul_nonnegative. x! y!))
   :qid internal_req__vstd!arithmetic.mul.lemma_mul_nonnegative._definition
   :skolemid skolem_internal_req__vstd!arithmetic.mul.lemma_mul_nonnegative._definition
)))
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_nonnegative. (Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_nonnegative. x! y!) (<= 0 (Mul x! y!)))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_nonnegative. x! y!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_nonnegative._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_nonnegative._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_nonnegative
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_nonnegative.)
  (forall ((x! Int) (y! Int)) (!
    (=>
     (and
      (<= 0 x!)
      (<= 0 y!)
     )
     (<= 0 (Mul x! y!))
    )
    :pattern ((Mul x! y!))
    :qid user_vstd__arithmetic__mul__lemma_mul_nonnegative_19
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_nonnegative_19
))))

;; Function-Specs vstd::arithmetic::power::lemma_pow_adds
(declare-fun ens%vstd!arithmetic.power.lemma_pow_adds. (Int Int Int) Bool)
(assert
 (forall ((b! Int) (e1! Int) (e2! Int)) (!
   (= (ens%vstd!arithmetic.power.lemma_pow_adds. b! e1! e2!) (= (vstd!arithmetic.power.pow.?
      (I b!) (I (nClip (Add e1! e2!)))
     ) (Mul (vstd!arithmetic.power.pow.? (I b!) (I e1!)) (vstd!arithmetic.power.pow.? (I
        b!
       ) (I e2!)
   ))))
   :pattern ((ens%vstd!arithmetic.power.lemma_pow_adds. b! e1! e2!))
   :qid internal_ens__vstd!arithmetic.power.lemma_pow_adds._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.power.lemma_pow_adds._definition
)))

;; Broadcast vstd::arithmetic::power::lemma_pow_adds
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.power.lemma_pow_adds.)
  (forall ((b! Poly) (e1! Int) (e2! Int)) (!
    (=>
     (and
      (has_type b! INT)
      (<= 0 e1!)
      (<= 0 e2!)
     )
     (= (vstd!arithmetic.power.pow.? b! (I (nClip (Add e1! e2!)))) (Mul (vstd!arithmetic.power.pow.?
        b! (I e1!)
       ) (vstd!arithmetic.power.pow.? b! (I e2!))
    )))
    :pattern ((vstd!arithmetic.power.pow.? b! (I (nClip (Add e1! e2!)))))
    :qid user_vstd__arithmetic__power__lemma_pow_adds_20
    :skolemid skolem_user_vstd__arithmetic__power__lemma_pow_adds_20
))))

;; Function-Specs vstd::arithmetic::power::lemma_pow_multiplies
(declare-fun ens%vstd!arithmetic.power.lemma_pow_multiplies. (Int Int Int) Bool)
(assert
 (forall ((a! Int) (b! Int) (c! Int)) (!
   (= (ens%vstd!arithmetic.power.lemma_pow_multiplies. a! b! c!) (and
     (<= 0 (nClip (Mul b! c!)))
     (= (vstd!arithmetic.power.pow.? (I (vstd!arithmetic.power.pow.? (I a!) (I b!))) (I c!))
      (vstd!arithmetic.power.pow.? (I a!) (I (nClip (Mul b! c!))))
   )))
   :pattern ((ens%vstd!arithmetic.power.lemma_pow_multiplies. a! b! c!))
   :qid internal_ens__vstd!arithmetic.power.lemma_pow_multiplies._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.power.lemma_pow_multiplies._definition
)))

;; Broadcast vstd::arithmetic::power::lemma_pow_multiplies
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.power.lemma_pow_multiplies.)
  (forall ((a! Poly) (b! Poly) (c! Poly)) (!
    (=>
     (and
      (has_type a! INT)
      (has_type b! NAT)
      (has_type c! NAT)
     )
     (and
      (<= 0 (nClip (Mul (%I b!) (%I c!))))
      (= (vstd!arithmetic.power.pow.? (I (vstd!arithmetic.power.pow.? a! b!)) c!) (vstd!arithmetic.power.pow.?
        a! (I (nClip (Mul (%I b!) (%I c!))))
    ))))
    :pattern ((vstd!arithmetic.power.pow.? (I (vstd!arithmetic.power.pow.? a! b!)) c!))
    :qid user_vstd__arithmetic__power__lemma_pow_multiplies_21
    :skolemid skolem_user_vstd__arithmetic__power__lemma_pow_multiplies_21
))))

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

;; Function-Specs vstd::arithmetic::power2::lemma_pow2_pos
(declare-fun ens%vstd!arithmetic.power2.lemma_pow2_pos. (Int) Bool)
(assert
 (forall ((e! Int)) (!
   (= (ens%vstd!arithmetic.power2.lemma_pow2_pos. e!) (> (vstd!arithmetic.power2.pow2.?
      (I e!)
     ) 0
   ))
   :pattern ((ens%vstd!arithmetic.power2.lemma_pow2_pos. e!))
   :qid internal_ens__vstd!arithmetic.power2.lemma_pow2_pos._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.power2.lemma_pow2_pos._definition
)))

;; Broadcast vstd::arithmetic::power2::lemma_pow2_pos
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.power2.lemma_pow2_pos.)
  (forall ((e! Poly)) (!
    (=>
     (has_type e! NAT)
     (> (vstd!arithmetic.power2.pow2.? e!) 0)
    )
    :pattern ((vstd!arithmetic.power2.pow2.? e!))
    :qid user_vstd__arithmetic__power2__lemma_pow2_pos_22
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_pos_22
))))

;; Function-Specs vstd::arithmetic::power2::lemma2_to64
(declare-fun ens%vstd!arithmetic.power2.lemma2_to64. (Int) Bool)
(assert
 (forall ((no%param Int)) (!
   (= (ens%vstd!arithmetic.power2.lemma2_to64. no%param) (and
     (= (vstd!arithmetic.power2.pow2.? (I 0)) 1)
     (= (vstd!arithmetic.power2.pow2.? (I 1)) 2)
     (= (vstd!arithmetic.power2.pow2.? (I 2)) 4)
     (= (vstd!arithmetic.power2.pow2.? (I 3)) 8)
     (= (vstd!arithmetic.power2.pow2.? (I 4)) 16)
     (= (vstd!arithmetic.power2.pow2.? (I 5)) 32)
     (= (vstd!arithmetic.power2.pow2.? (I 6)) 64)
     (= (vstd!arithmetic.power2.pow2.? (I 7)) 128)
     (= (vstd!arithmetic.power2.pow2.? (I 8)) 256)
     (= (vstd!arithmetic.power2.pow2.? (I 9)) 512)
     (= (vstd!arithmetic.power2.pow2.? (I 10)) 1024)
     (= (vstd!arithmetic.power2.pow2.? (I 11)) 2048)
     (= (vstd!arithmetic.power2.pow2.? (I 12)) 4096)
     (= (vstd!arithmetic.power2.pow2.? (I 13)) 8192)
     (= (vstd!arithmetic.power2.pow2.? (I 14)) 16384)
     (= (vstd!arithmetic.power2.pow2.? (I 15)) 32768)
     (= (vstd!arithmetic.power2.pow2.? (I 16)) 65536)
     (= (vstd!arithmetic.power2.pow2.? (I 17)) 131072)
     (= (vstd!arithmetic.power2.pow2.? (I 18)) 262144)
     (= (vstd!arithmetic.power2.pow2.? (I 19)) 524288)
     (= (vstd!arithmetic.power2.pow2.? (I 20)) 1048576)
     (= (vstd!arithmetic.power2.pow2.? (I 21)) 2097152)
     (= (vstd!arithmetic.power2.pow2.? (I 22)) 4194304)
     (= (vstd!arithmetic.power2.pow2.? (I 23)) 8388608)
     (= (vstd!arithmetic.power2.pow2.? (I 24)) 16777216)
     (= (vstd!arithmetic.power2.pow2.? (I 25)) 33554432)
     (= (vstd!arithmetic.power2.pow2.? (I 26)) 67108864)
     (= (vstd!arithmetic.power2.pow2.? (I 27)) 134217728)
     (= (vstd!arithmetic.power2.pow2.? (I 28)) 268435456)
     (= (vstd!arithmetic.power2.pow2.? (I 29)) 536870912)
     (= (vstd!arithmetic.power2.pow2.? (I 30)) 1073741824)
     (= (vstd!arithmetic.power2.pow2.? (I 31)) 2147483648)
     (= (vstd!arithmetic.power2.pow2.? (I 32)) 4294967296)
     (= (vstd!arithmetic.power2.pow2.? (I 64)) 18446744073709551616)
   ))
   :pattern ((ens%vstd!arithmetic.power2.lemma2_to64. no%param))
   :qid internal_ens__vstd!arithmetic.power2.lemma2_to64._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.power2.lemma2_to64._definition
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

;; Function-Axioms vstd::view::impl&%32::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%32.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%32.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ (SINT 32) self!) self!)
    :pattern ((vstd!view.View.view.? $ (SINT 32) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
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
 (tr_bound%vstd!view.View. $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ (SINT 32))
)

;; Function-Specs curve25519_dalek::specs::field_specs_u64::pow255_gt_19
(declare-fun ens%curve25519_dalek!specs.field_specs_u64.pow255_gt_19. (Int) Bool)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!specs.field_specs_u64.pow255_gt_19. no%param) (> (vstd!arithmetic.power2.pow2.?
      (I 255)
     ) 19
   ))
   :pattern ((ens%curve25519_dalek!specs.field_specs_u64.pow255_gt_19. no%param))
   :qid internal_ens__curve25519_dalek!specs.field_specs_u64.pow255_gt_19._definition
   :skolemid skolem_internal_ens__curve25519_dalek!specs.field_specs_u64.pow255_gt_19._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_pow_nonnegative
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nonnegative.
 (Int Int) Bool
)
(declare-const %%global_location_label%%7 Bool)
(assert
 (forall ((base! Int) (n! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nonnegative. base!
     n!
    ) (=>
     %%global_location_label%%7
     (>= base! 0)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nonnegative.
     base! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nonnegative._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nonnegative._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nonnegative.
 (Int Int) Bool
)
(assert
 (forall ((base! Int) (n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nonnegative. base!
     n!
    ) (>= (vstd!arithmetic.power.pow.? (I base!) (I n!)) 0)
   )
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nonnegative.
     base! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nonnegative._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nonnegative._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_pow_mod_congruent
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_mod_congruent.
 (Int Int Int Int) Bool
)
(declare-const %%global_location_label%%8 Bool)
(declare-const %%global_location_label%%9 Bool)
(assert
 (forall ((a! Int) (b! Int) (n! Int) (m! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_mod_congruent. a!
     b! n! m!
    ) (and
     (=>
      %%global_location_label%%8
      (> m! 0)
     )
     (=>
      %%global_location_label%%9
      (= (EucMod a! m!) (EucMod b! m!))
   )))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_mod_congruent.
     a! b! n! m!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_mod_congruent._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_mod_congruent._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_mod_congruent.
 (Int Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (n! Int) (m! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_mod_congruent. a!
     b! n! m!
    ) (= (EucMod (vstd!arithmetic.power.pow.? (I a!) (I n!)) m!) (EucMod (vstd!arithmetic.power.pow.?
       (I b!) (I n!)
      ) m!
   )))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_mod_congruent.
     a! b! n! m!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_mod_congruent._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_mod_congruent._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::pow_chain_lemmas::lemma_prove_pow2k_step
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_pow2k_step.
 (Int Int Int Int Int) Bool
)
(declare-const %%global_location_label%%10 Bool)
(declare-const %%global_location_label%%11 Bool)
(declare-const %%global_location_label%%12 Bool)
(declare-const %%global_location_label%%13 Bool)
(declare-const %%global_location_label%%14 Bool)
(assert
 (forall ((base! Int) (val_in! Int) (val_out! Int) (exp_in! Int) (exp_power! Int))
  (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_pow2k_step.
     base! val_in! val_out! exp_in! exp_power!
    ) (and
     (=>
      %%global_location_label%%10
      (>= base! 0)
     )
     (=>
      %%global_location_label%%11
      (> (curve25519_dalek!specs.field_specs_u64.p.? (I 0)) 0)
     )
     (=>
      %%global_location_label%%12
      (> exp_power! 0)
     )
     (=>
      %%global_location_label%%13
      (= (EucMod val_in! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) (EucMod (nClip
         (vstd!arithmetic.power.pow.? (I base!) (I exp_in!))
        ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     )))
     (=>
      %%global_location_label%%14
      (= (EucMod val_out! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) (EucMod (nClip
         (vstd!arithmetic.power.pow.? (I val_in!) (I exp_power!))
        ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   )))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_pow2k_step.
     base! val_in! val_out! exp_in! exp_power!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_pow2k_step._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_pow2k_step._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_pow2k_step.
 (Int Int Int Int Int) Bool
)
(assert
 (forall ((base! Int) (val_in! Int) (val_out! Int) (exp_in! Int) (exp_power! Int))
  (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_pow2k_step.
     base! val_in! val_out! exp_in! exp_power!
    ) (= (EucMod val_out! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) (EucMod (
       nClip (vstd!arithmetic.power.pow.? (I base!) (I (nClip (Mul exp_in! exp_power!))))
      ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_pow2k_step.
     base! val_in! val_out! exp_in! exp_power!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_pow2k_step._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_pow2k_step._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::pow_chain_lemmas::lemma_prove_geometric_mul_step
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_geometric_mul_step.
 (Int Int Int Int Int Int) Bool
)
(declare-const %%global_location_label%%15 Bool)
(declare-const %%global_location_label%%16 Bool)
(declare-const %%global_location_label%%17 Bool)
(declare-const %%global_location_label%%18 Bool)
(declare-const %%global_location_label%%19 Bool)
(assert
 (forall ((base! Int) (val_a! Int) (val_b! Int) (val_result! Int) (exp_a! Int) (exp_b!
    Int
   )
  ) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_geometric_mul_step.
     base! val_a! val_b! val_result! exp_a! exp_b!
    ) (and
     (=>
      %%global_location_label%%15
      (>= base! 0)
     )
     (=>
      %%global_location_label%%16
      (> (curve25519_dalek!specs.field_specs_u64.p.? (I 0)) 0)
     )
     (=>
      %%global_location_label%%17
      (= (EucMod val_a! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) (EucMod (nClip
         (vstd!arithmetic.power.pow.? (I base!) (I exp_a!))
        ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     )))
     (=>
      %%global_location_label%%18
      (= (EucMod val_b! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) (EucMod (nClip
         (vstd!arithmetic.power.pow.? (I base!) (I exp_b!))
        ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     )))
     (=>
      %%global_location_label%%19
      (= (EucMod val_result! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) (EucMod
        (nClip (Mul val_a! val_b!)) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   )))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_geometric_mul_step.
     base! val_a! val_b! val_result! exp_a! exp_b!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_geometric_mul_step._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_geometric_mul_step._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_geometric_mul_step.
 (Int Int Int Int Int Int) Bool
)
(assert
 (forall ((base! Int) (val_a! Int) (val_b! Int) (val_result! Int) (exp_a! Int) (exp_b!
    Int
   )
  ) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_geometric_mul_step.
     base! val_a! val_b! val_result! exp_a! exp_b!
    ) (= (EucMod val_result! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) (EucMod
      (nClip (vstd!arithmetic.power.pow.? (I base!) (I (nClip (Add exp_a! exp_b!))))) (
       curve25519_dalek!specs.field_specs_u64.p.? (I 0)
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_geometric_mul_step.
     base! val_a! val_b! val_result! exp_a! exp_b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_geometric_mul_step._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_geometric_mul_step._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_pow2_geometric
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_geometric.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_geometric. a! b!)
    (= (Add (Mul (Sub (vstd!arithmetic.power2.pow2.? (I a!)) 1) (vstd!arithmetic.power2.pow2.?
        (I b!)
       )
      ) (Sub (vstd!arithmetic.power2.pow2.? (I b!)) 1)
     ) (Sub (vstd!arithmetic.power2.pow2.? (I (nClip (Add a! b!)))) 1)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_geometric.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_geometric._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_geometric._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::pow22501_t19_lemma::lemma_pow22501_prove_t19
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.pow22501_t19_lemma.lemma_pow22501_prove_t19.
 (%%Function%% %%Function%% %%Function%% %%Function%% %%Function%% %%Function%% %%Function%%
  %%Function%% %%Function%% %%Function%% %%Function%% %%Function%% %%Function%% %%Function%%
  %%Function%% %%Function%% %%Function%% %%Function%% %%Function%% %%Function%% %%Function%%
 ) Bool
)
(declare-const %%global_location_label%%20 Bool)
(declare-const %%global_location_label%%21 Bool)
(declare-const %%global_location_label%%22 Bool)
(declare-const %%global_location_label%%23 Bool)
(declare-const %%global_location_label%%24 Bool)
(declare-const %%global_location_label%%25 Bool)
(declare-const %%global_location_label%%26 Bool)
(declare-const %%global_location_label%%27 Bool)
(declare-const %%global_location_label%%28 Bool)
(declare-const %%global_location_label%%29 Bool)
(declare-const %%global_location_label%%30 Bool)
(declare-const %%global_location_label%%31 Bool)
(declare-const %%global_location_label%%32 Bool)
(declare-const %%global_location_label%%33 Bool)
(declare-const %%global_location_label%%34 Bool)
(declare-const %%global_location_label%%35 Bool)
(declare-const %%global_location_label%%36 Bool)
(declare-const %%global_location_label%%37 Bool)
(declare-const %%global_location_label%%38 Bool)
(declare-const %%global_location_label%%39 Bool)
(declare-const %%global_location_label%%40 Bool)
(assert
 (forall ((self_limbs! %%Function%%) (t0_limbs! %%Function%%) (t1_limbs! %%Function%%)
   (t2_limbs! %%Function%%) (t3_limbs! %%Function%%) (t4_limbs! %%Function%%) (t5_limbs!
    %%Function%%
   ) (t6_limbs! %%Function%%) (t7_limbs! %%Function%%) (t8_limbs! %%Function%%) (t9_limbs!
    %%Function%%
   ) (t10_limbs! %%Function%%) (t11_limbs! %%Function%%) (t12_limbs! %%Function%%) (
    t13_limbs! %%Function%%
   ) (t14_limbs! %%Function%%) (t15_limbs! %%Function%%) (t16_limbs! %%Function%%) (
    t17_limbs! %%Function%%
   ) (t18_limbs! %%Function%%) (t19_limbs! %%Function%%)
  ) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.pow22501_t19_lemma.lemma_pow22501_prove_t19.
     self_limbs! t0_limbs! t1_limbs! t2_limbs! t3_limbs! t4_limbs! t5_limbs! t6_limbs!
     t7_limbs! t8_limbs! t9_limbs! t10_limbs! t11_limbs! t12_limbs! t13_limbs! t14_limbs!
     t15_limbs! t16_limbs! t17_limbs! t18_limbs! t19_limbs!
    ) (and
     (=>
      %%global_location_label%%20
      (forall ((i$ Poly)) (!
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
              ) (Poly%array%. self_limbs!)
             ) i$
            )
           ) (uClip 64 (bitshl (I 1) (I 54)))
        )))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) (Poly%array%. self_limbs!)
          ) i$
        ))
        :qid user_curve25519_dalek__lemmas__field_lemmas__pow22501_t19_lemma__lemma_pow22501_prove_t19_23
        :skolemid skolem_user_curve25519_dalek__lemmas__field_lemmas__pow22501_t19_lemma__lemma_pow22501_prove_t19_23
     )))
     (=>
      %%global_location_label%%21
      (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t2_limbs!))
        (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
       ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
            (Poly%array%. self_limbs!)
           )
          ) (I 9)
         )
        ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     )))
     (=>
      %%global_location_label%%22
      (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t3_limbs!))
        (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
       ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
            (Poly%array%. self_limbs!)
           )
          ) (I 11)
         )
        ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     )))
     (=>
      %%global_location_label%%23
      (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t0_limbs!))
        (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
       ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
            (Poly%array%. self_limbs!)
           )
          ) (I 2)
         )
        ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     )))
     (=>
      %%global_location_label%%24
      (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t1_limbs!))
        (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
       ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
            (Poly%array%. self_limbs!)
           )
          ) (I 8)
         )
        ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     )))
     (=>
      %%global_location_label%%25
      (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t4_limbs!))
        (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
       ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
            (Poly%array%. t3_limbs!)
           )
          ) (I 2)
         )
        ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     )))
     (=>
      %%global_location_label%%26
      (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t6_limbs!))
        (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
       ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
            (Poly%array%. t5_limbs!)
           )
          ) (I (vstd!arithmetic.power2.pow2.? (I 5)))
         )
        ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     )))
     (=>
      %%global_location_label%%27
      (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t8_limbs!))
        (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
       ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
            (Poly%array%. t7_limbs!)
           )
          ) (I (vstd!arithmetic.power2.pow2.? (I 10)))
         )
        ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     )))
     (=>
      %%global_location_label%%28
      (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t10_limbs!))
        (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
       ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
            (Poly%array%. t9_limbs!)
           )
          ) (I (vstd!arithmetic.power2.pow2.? (I 20)))
         )
        ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     )))
     (=>
      %%global_location_label%%29
      (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t12_limbs!))
        (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
       ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
            (Poly%array%. t11_limbs!)
           )
          ) (I (vstd!arithmetic.power2.pow2.? (I 10)))
         )
        ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     )))
     (=>
      %%global_location_label%%30
      (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t14_limbs!))
        (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
       ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
            (Poly%array%. t13_limbs!)
           )
          ) (I (vstd!arithmetic.power2.pow2.? (I 50)))
         )
        ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     )))
     (=>
      %%global_location_label%%31
      (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t16_limbs!))
        (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
       ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
            (Poly%array%. t15_limbs!)
           )
          ) (I (vstd!arithmetic.power2.pow2.? (I 100)))
         )
        ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     )))
     (=>
      %%global_location_label%%32
      (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t18_limbs!))
        (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
       ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
            (Poly%array%. t17_limbs!)
           )
          ) (I (vstd!arithmetic.power2.pow2.? (I 50)))
         )
        ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     )))
     (=>
      %%global_location_label%%33
      (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t5_limbs!))
        (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
       ) (EucMod (nClip (Mul (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%.
            t2_limbs!
           )
          ) (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t4_limbs!))
         )
        ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     )))
     (=>
      %%global_location_label%%34
      (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t7_limbs!))
        (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
       ) (EucMod (nClip (Mul (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%.
            t6_limbs!
           )
          ) (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t5_limbs!))
         )
        ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     )))
     (=>
      %%global_location_label%%35
      (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t9_limbs!))
        (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
       ) (EucMod (nClip (Mul (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%.
            t8_limbs!
           )
          ) (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t7_limbs!))
         )
        ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     )))
     (=>
      %%global_location_label%%36
      (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t11_limbs!))
        (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
       ) (EucMod (nClip (Mul (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%.
            t10_limbs!
           )
          ) (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t9_limbs!))
         )
        ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     )))
     (=>
      %%global_location_label%%37
      (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t13_limbs!))
        (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
       ) (EucMod (nClip (Mul (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%.
            t12_limbs!
           )
          ) (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t7_limbs!))
         )
        ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     )))
     (=>
      %%global_location_label%%38
      (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t15_limbs!))
        (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
       ) (EucMod (nClip (Mul (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%.
            t14_limbs!
           )
          ) (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t13_limbs!))
         )
        ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     )))
     (=>
      %%global_location_label%%39
      (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t17_limbs!))
        (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
       ) (EucMod (nClip (Mul (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%.
            t16_limbs!
           )
          ) (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t15_limbs!))
         )
        ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     )))
     (=>
      %%global_location_label%%40
      (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t19_limbs!))
        (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
       ) (EucMod (nClip (Mul (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%.
            t18_limbs!
           )
          ) (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t13_limbs!))
         )
        ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   )))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.pow22501_t19_lemma.lemma_pow22501_prove_t19.
     self_limbs! t0_limbs! t1_limbs! t2_limbs! t3_limbs! t4_limbs! t5_limbs! t6_limbs!
     t7_limbs! t8_limbs! t9_limbs! t10_limbs! t11_limbs! t12_limbs! t13_limbs! t14_limbs!
     t15_limbs! t16_limbs! t17_limbs! t18_limbs! t19_limbs!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.pow22501_t19_lemma.lemma_pow22501_prove_t19._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.pow22501_t19_lemma.lemma_pow22501_prove_t19._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.pow22501_t19_lemma.lemma_pow22501_prove_t19.
 (%%Function%% %%Function%% %%Function%% %%Function%% %%Function%% %%Function%% %%Function%%
  %%Function%% %%Function%% %%Function%% %%Function%% %%Function%% %%Function%% %%Function%%
  %%Function%% %%Function%% %%Function%% %%Function%% %%Function%% %%Function%% %%Function%%
 ) Bool
)
(assert
 (forall ((self_limbs! %%Function%%) (t0_limbs! %%Function%%) (t1_limbs! %%Function%%)
   (t2_limbs! %%Function%%) (t3_limbs! %%Function%%) (t4_limbs! %%Function%%) (t5_limbs!
    %%Function%%
   ) (t6_limbs! %%Function%%) (t7_limbs! %%Function%%) (t8_limbs! %%Function%%) (t9_limbs!
    %%Function%%
   ) (t10_limbs! %%Function%%) (t11_limbs! %%Function%%) (t12_limbs! %%Function%%) (
    t13_limbs! %%Function%%
   ) (t14_limbs! %%Function%%) (t15_limbs! %%Function%%) (t16_limbs! %%Function%%) (
    t17_limbs! %%Function%%
   ) (t18_limbs! %%Function%%) (t19_limbs! %%Function%%)
  ) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.pow22501_t19_lemma.lemma_pow22501_prove_t19.
     self_limbs! t0_limbs! t1_limbs! t2_limbs! t3_limbs! t4_limbs! t5_limbs! t6_limbs!
     t7_limbs! t8_limbs! t9_limbs! t10_limbs! t11_limbs! t12_limbs! t13_limbs! t14_limbs!
     t15_limbs! t16_limbs! t17_limbs! t18_limbs! t19_limbs!
    ) (and
     (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t19_limbs!))
       (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
      ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
           (Poly%array%. self_limbs!)
          )
         ) (I (nClip (Sub (vstd!arithmetic.power2.pow2.? (I 250)) 1)))
        )
       ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     ))
     (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t2_limbs!))
       (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
      ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
           (Poly%array%. self_limbs!)
          )
         ) (I 9)
        )
       ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     ))
     (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t3_limbs!))
       (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
      ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
           (Poly%array%. self_limbs!)
          )
         ) (I 11)
        )
       ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     ))
     (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t4_limbs!))
       (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
      ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
           (Poly%array%. self_limbs!)
          )
         ) (I 22)
        )
       ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     ))
     (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t5_limbs!))
       (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
      ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
           (Poly%array%. self_limbs!)
          )
         ) (I (nClip (Sub (vstd!arithmetic.power2.pow2.? (I 5)) 1)))
        )
       ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     ))
     (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t7_limbs!))
       (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
      ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
           (Poly%array%. self_limbs!)
          )
         ) (I (nClip (Sub (vstd!arithmetic.power2.pow2.? (I 10)) 1)))
        )
       ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     ))
     (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t9_limbs!))
       (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
      ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
           (Poly%array%. self_limbs!)
          )
         ) (I (nClip (Sub (vstd!arithmetic.power2.pow2.? (I 20)) 1)))
        )
       ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     ))
     (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t11_limbs!))
       (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
      ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
           (Poly%array%. self_limbs!)
          )
         ) (I (nClip (Sub (vstd!arithmetic.power2.pow2.? (I 40)) 1)))
        )
       ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     ))
     (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t13_limbs!))
       (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
      ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
           (Poly%array%. self_limbs!)
          )
         ) (I (nClip (Sub (vstd!arithmetic.power2.pow2.? (I 50)) 1)))
        )
       ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     ))
     (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t15_limbs!))
       (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
      ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
           (Poly%array%. self_limbs!)
          )
         ) (I (nClip (Sub (vstd!arithmetic.power2.pow2.? (I 100)) 1)))
        )
       ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     ))
     (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t17_limbs!))
       (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
      ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
           (Poly%array%. self_limbs!)
          )
         ) (I (nClip (Sub (vstd!arithmetic.power2.pow2.? (I 200)) 1)))
        )
       ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.pow22501_t19_lemma.lemma_pow22501_prove_t19.
     self_limbs! t0_limbs! t1_limbs! t2_limbs! t3_limbs! t4_limbs! t5_limbs! t6_limbs!
     t7_limbs! t8_limbs! t9_limbs! t10_limbs! t11_limbs! t12_limbs! t13_limbs! t14_limbs!
     t15_limbs! t16_limbs! t17_limbs! t18_limbs! t19_limbs!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.pow22501_t19_lemma.lemma_pow22501_prove_t19._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.pow22501_t19_lemma.lemma_pow22501_prove_t19._definition
)))

;; Function-Def curve25519_dalek::lemmas::field_lemmas::pow22501_t19_lemma::lemma_pow22501_prove_t19
;; curve25519-dalek/src/lemmas/field_lemmas/pow22501_t19_lemma.rs:66:1: 88:2 (#0)
(get-info :all-statistics)
(push)
 (declare-const self_limbs! %%Function%%)
 (declare-const t0_limbs! %%Function%%)
 (declare-const t1_limbs! %%Function%%)
 (declare-const t2_limbs! %%Function%%)
 (declare-const t3_limbs! %%Function%%)
 (declare-const t4_limbs! %%Function%%)
 (declare-const t5_limbs! %%Function%%)
 (declare-const t6_limbs! %%Function%%)
 (declare-const t7_limbs! %%Function%%)
 (declare-const t8_limbs! %%Function%%)
 (declare-const t9_limbs! %%Function%%)
 (declare-const t10_limbs! %%Function%%)
 (declare-const t11_limbs! %%Function%%)
 (declare-const t12_limbs! %%Function%%)
 (declare-const t13_limbs! %%Function%%)
 (declare-const t14_limbs! %%Function%%)
 (declare-const t15_limbs! %%Function%%)
 (declare-const t16_limbs! %%Function%%)
 (declare-const t17_limbs! %%Function%%)
 (declare-const t18_limbs! %%Function%%)
 (declare-const t19_limbs! %%Function%%)
 (declare-const tmp%1 Bool)
 (declare-const tmp%2 Bool)
 (declare-const tmp%3 Bool)
 (declare-const tmp%4 Bool)
 (declare-const tmp%5 Int)
 (declare-const tmp%6 Int)
 (declare-const tmp%7 Int)
 (declare-const tmp%8 Bool)
 (declare-const tmp%9 Int)
 (declare-const tmp%10 Int)
 (declare-const tmp%11 Int)
 (declare-const tmp%12 Bool)
 (declare-const tmp%13 Int)
 (declare-const tmp%14 Int)
 (declare-const tmp%15 Int)
 (declare-const tmp%16 Bool)
 (declare-const tmp%17 Int)
 (declare-const tmp%18 Int)
 (declare-const tmp%19 Bool)
 (declare-const tmp%20 Bool)
 (declare-const tmp%21 Bool)
 (declare-const tmp%22 Int)
 (declare-const tmp%23 Int)
 (declare-const tmp%24 Int)
 (declare-const tmp%25 Int)
 (declare-const tmp%26 Int)
 (declare-const tmp%27 Int)
 (declare-const tmp%28 Int)
 (declare-const tmp%29 Int)
 (declare-const tmp%30 Int)
 (declare-const tmp%31 Int)
 (declare-const tmp%32 Int)
 (declare-const tmp%33 Int)
 (declare-const tmp%34 Int)
 (declare-const tmp%35 Int)
 (declare-const tmp%36 Int)
 (declare-const tmp%37 Int)
 (declare-const tmp%38 Int)
 (declare-const tmp%39 Int)
 (declare-const tmp%40 Int)
 (declare-const tmp%41 Int)
 (declare-const tmp%42 Int)
 (declare-const tmp%43 Int)
 (declare-const tmp%44 Int)
 (declare-const tmp%45 Int)
 (declare-const tmp%46 Int)
 (declare-const tmp%47 Int)
 (declare-const tmp%48 Int)
 (declare-const tmp%49 Int)
 (declare-const tmp%50 Int)
 (declare-const tmp%51 Int)
 (declare-const tmp%52 Int)
 (declare-const tmp%53 Int)
 (declare-const tmp%54 Int)
 (declare-const tmp%55 Int)
 (declare-const tmp%56 Int)
 (declare-const tmp%57 Int)
 (declare-const tmp%58 Int)
 (declare-const tmp%59 Int)
 (declare-const tmp%60 Int)
 (declare-const tmp%61 Int)
 (declare-const tmp%62 Int)
 (declare-const tmp%63 Int)
 (declare-const tmp%64 Int)
 (declare-const tmp%65 Int)
 (declare-const tmp%66 Int)
 (declare-const tmp%67 Int)
 (declare-const tmp%68 Int)
 (declare-const tmp%69 Int)
 (declare-const tmp%70 Int)
 (declare-const tmp%71 Int)
 (declare-const tmp%72 Int)
 (declare-const tmp%73 Int)
 (declare-const tmp%74 Int)
 (declare-const tmp%75 Int)
 (declare-const tmp%76 Int)
 (declare-const tmp%77 Int)
 (declare-const tmp%78 Int)
 (declare-const tmp%79 Int)
 (declare-const tmp%80 Int)
 (declare-const tmp%81 Int)
 (declare-const tmp%82 Int)
 (declare-const tmp%83 Int)
 (declare-const tmp%84 Int)
 (declare-const base@ Int)
 (declare-const t3_val@ Int)
 (assert
  fuel_defaults
 )
 (assert
  (has_type (Poly%array%. self_limbs!) (ARRAY $ (UINT 64) $ (CONST_INT 5)))
 )
 (assert
  (has_type (Poly%array%. t0_limbs!) (ARRAY $ (UINT 64) $ (CONST_INT 5)))
 )
 (assert
  (has_type (Poly%array%. t1_limbs!) (ARRAY $ (UINT 64) $ (CONST_INT 5)))
 )
 (assert
  (has_type (Poly%array%. t2_limbs!) (ARRAY $ (UINT 64) $ (CONST_INT 5)))
 )
 (assert
  (has_type (Poly%array%. t3_limbs!) (ARRAY $ (UINT 64) $ (CONST_INT 5)))
 )
 (assert
  (has_type (Poly%array%. t4_limbs!) (ARRAY $ (UINT 64) $ (CONST_INT 5)))
 )
 (assert
  (has_type (Poly%array%. t5_limbs!) (ARRAY $ (UINT 64) $ (CONST_INT 5)))
 )
 (assert
  (has_type (Poly%array%. t6_limbs!) (ARRAY $ (UINT 64) $ (CONST_INT 5)))
 )
 (assert
  (has_type (Poly%array%. t7_limbs!) (ARRAY $ (UINT 64) $ (CONST_INT 5)))
 )
 (assert
  (has_type (Poly%array%. t8_limbs!) (ARRAY $ (UINT 64) $ (CONST_INT 5)))
 )
 (assert
  (has_type (Poly%array%. t9_limbs!) (ARRAY $ (UINT 64) $ (CONST_INT 5)))
 )
 (assert
  (has_type (Poly%array%. t10_limbs!) (ARRAY $ (UINT 64) $ (CONST_INT 5)))
 )
 (assert
  (has_type (Poly%array%. t11_limbs!) (ARRAY $ (UINT 64) $ (CONST_INT 5)))
 )
 (assert
  (has_type (Poly%array%. t12_limbs!) (ARRAY $ (UINT 64) $ (CONST_INT 5)))
 )
 (assert
  (has_type (Poly%array%. t13_limbs!) (ARRAY $ (UINT 64) $ (CONST_INT 5)))
 )
 (assert
  (has_type (Poly%array%. t14_limbs!) (ARRAY $ (UINT 64) $ (CONST_INT 5)))
 )
 (assert
  (has_type (Poly%array%. t15_limbs!) (ARRAY $ (UINT 64) $ (CONST_INT 5)))
 )
 (assert
  (has_type (Poly%array%. t16_limbs!) (ARRAY $ (UINT 64) $ (CONST_INT 5)))
 )
 (assert
  (has_type (Poly%array%. t17_limbs!) (ARRAY $ (UINT 64) $ (CONST_INT 5)))
 )
 (assert
  (has_type (Poly%array%. t18_limbs!) (ARRAY $ (UINT 64) $ (CONST_INT 5)))
 )
 (assert
  (has_type (Poly%array%. t19_limbs!) (ARRAY $ (UINT 64) $ (CONST_INT 5)))
 )
 (assert
  (forall ((i$ Poly)) (!
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
          ) (Poly%array%. self_limbs!)
         ) i$
        )
       ) (uClip 64 (bitshl (I 1) (I 54)))
    )))
    :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
        $ (CONST_INT 5)
       ) (Poly%array%. self_limbs!)
      ) i$
    ))
    :qid user_curve25519_dalek__lemmas__field_lemmas__pow22501_t19_lemma__lemma_pow22501_prove_t19_43
    :skolemid skolem_user_curve25519_dalek__lemmas__field_lemmas__pow22501_t19_lemma__lemma_pow22501_prove_t19_43
 )))
 (assert
  (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t2_limbs!))
    (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
        (Poly%array%. self_limbs!)
       )
      ) (I 9)
     )
    ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
 )))
 (assert
  (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t3_limbs!))
    (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
        (Poly%array%. self_limbs!)
       )
      ) (I 11)
     )
    ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
 )))
 (assert
  (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t0_limbs!))
    (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
        (Poly%array%. self_limbs!)
       )
      ) (I 2)
     )
    ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
 )))
 (assert
  (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t1_limbs!))
    (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
        (Poly%array%. self_limbs!)
       )
      ) (I 8)
     )
    ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
 )))
 (assert
  (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t4_limbs!))
    (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
        (Poly%array%. t3_limbs!)
       )
      ) (I 2)
     )
    ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
 )))
 (assert
  (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t6_limbs!))
    (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
        (Poly%array%. t5_limbs!)
       )
      ) (I (vstd!arithmetic.power2.pow2.? (I 5)))
     )
    ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
 )))
 (assert
  (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t8_limbs!))
    (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
        (Poly%array%. t7_limbs!)
       )
      ) (I (vstd!arithmetic.power2.pow2.? (I 10)))
     )
    ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
 )))
 (assert
  (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t10_limbs!))
    (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
        (Poly%array%. t9_limbs!)
       )
      ) (I (vstd!arithmetic.power2.pow2.? (I 20)))
     )
    ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
 )))
 (assert
  (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t12_limbs!))
    (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
        (Poly%array%. t11_limbs!)
       )
      ) (I (vstd!arithmetic.power2.pow2.? (I 10)))
     )
    ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
 )))
 (assert
  (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t14_limbs!))
    (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
        (Poly%array%. t13_limbs!)
       )
      ) (I (vstd!arithmetic.power2.pow2.? (I 50)))
     )
    ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
 )))
 (assert
  (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t16_limbs!))
    (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
        (Poly%array%. t15_limbs!)
       )
      ) (I (vstd!arithmetic.power2.pow2.? (I 100)))
     )
    ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
 )))
 (assert
  (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t18_limbs!))
    (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
        (Poly%array%. t17_limbs!)
       )
      ) (I (vstd!arithmetic.power2.pow2.? (I 50)))
     )
    ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
 )))
 (assert
  (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t5_limbs!))
    (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   ) (EucMod (nClip (Mul (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%.
        t2_limbs!
       )
      ) (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t4_limbs!))
     )
    ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
 )))
 (assert
  (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t7_limbs!))
    (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   ) (EucMod (nClip (Mul (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%.
        t6_limbs!
       )
      ) (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t5_limbs!))
     )
    ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
 )))
 (assert
  (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t9_limbs!))
    (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   ) (EucMod (nClip (Mul (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%.
        t8_limbs!
       )
      ) (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t7_limbs!))
     )
    ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
 )))
 (assert
  (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t11_limbs!))
    (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   ) (EucMod (nClip (Mul (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%.
        t10_limbs!
       )
      ) (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t9_limbs!))
     )
    ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
 )))
 (assert
  (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t13_limbs!))
    (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   ) (EucMod (nClip (Mul (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%.
        t12_limbs!
       )
      ) (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t7_limbs!))
     )
    ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
 )))
 (assert
  (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t15_limbs!))
    (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   ) (EucMod (nClip (Mul (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%.
        t14_limbs!
       )
      ) (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t13_limbs!))
     )
    ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
 )))
 (assert
  (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t17_limbs!))
    (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   ) (EucMod (nClip (Mul (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%.
        t16_limbs!
       )
      ) (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t15_limbs!))
     )
    ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
 )))
 (assert
  (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t19_limbs!))
    (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   ) (EucMod (nClip (Mul (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%.
        t18_limbs!
       )
      ) (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t13_limbs!))
     )
    ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
 )))
 ;; assertion failed
 (declare-const %%location_label%%0 Bool)
 ;; assertion failed
 (declare-const %%location_label%%1 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%2 Bool)
 ;; assertion failed
 (declare-const %%location_label%%3 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%4 Bool)
 ;; assertion failed
 (declare-const %%location_label%%5 Bool)
 ;; assertion failed
 (declare-const %%location_label%%6 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%7 Bool)
 ;; assertion failed
 (declare-const %%location_label%%8 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%9 Bool)
 ;; assertion failed
 (declare-const %%location_label%%10 Bool)
 ;; assertion failed
 (declare-const %%location_label%%11 Bool)
 ;; assertion failed
 (declare-const %%location_label%%12 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%13 Bool)
 ;; assertion failed
 (declare-const %%location_label%%14 Bool)
 ;; assertion failed
 (declare-const %%location_label%%15 Bool)
 ;; assertion failed
 (declare-const %%location_label%%16 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%17 Bool)
 ;; assertion failed
 (declare-const %%location_label%%18 Bool)
 ;; assertion failed
 (declare-const %%location_label%%19 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%20 Bool)
 ;; assertion failed
 (declare-const %%location_label%%21 Bool)
 ;; assertion failed
 (declare-const %%location_label%%22 Bool)
 ;; assertion failed
 (declare-const %%location_label%%23 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%24 Bool)
 ;; assertion failed
 (declare-const %%location_label%%25 Bool)
 ;; assertion failed
 (declare-const %%location_label%%26 Bool)
 ;; assertion failed
 (declare-const %%location_label%%27 Bool)
 ;; assertion failed
 (declare-const %%location_label%%28 Bool)
 ;; assertion failed
 (declare-const %%location_label%%29 Bool)
 ;; assertion failed
 (declare-const %%location_label%%30 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%31 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%32 Bool)
 ;; assertion failed
 (declare-const %%location_label%%33 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%34 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%35 Bool)
 ;; assertion failed
 (declare-const %%location_label%%36 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%37 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%38 Bool)
 ;; assertion failed
 (declare-const %%location_label%%39 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%40 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%41 Bool)
 ;; assertion failed
 (declare-const %%location_label%%42 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%43 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%44 Bool)
 ;; assertion failed
 (declare-const %%location_label%%45 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%46 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%47 Bool)
 ;; assertion failed
 (declare-const %%location_label%%48 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%49 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%50 Bool)
 ;; postcondition not satisfied
 (declare-const %%location_label%%51 Bool)
 ;; postcondition not satisfied
 (declare-const %%location_label%%52 Bool)
 ;; postcondition not satisfied
 (declare-const %%location_label%%53 Bool)
 ;; postcondition not satisfied
 (declare-const %%location_label%%54 Bool)
 ;; postcondition not satisfied
 (declare-const %%location_label%%55 Bool)
 ;; postcondition not satisfied
 (declare-const %%location_label%%56 Bool)
 ;; postcondition not satisfied
 (declare-const %%location_label%%57 Bool)
 ;; postcondition not satisfied
 (declare-const %%location_label%%58 Bool)
 ;; postcondition not satisfied
 (declare-const %%location_label%%59 Bool)
 ;; postcondition not satisfied
 (declare-const %%location_label%%60 Bool)
 ;; postcondition not satisfied
 (declare-const %%location_label%%61 Bool)
 (assert
  (not (=>
    (= base@ (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. self_limbs!)))
    (and
     (=>
      (ens%curve25519_dalek!specs.field_specs_u64.pow255_gt_19. 0)
      (=>
       %%location_label%%0
       (> (curve25519_dalek!specs.field_specs_u64.p.? (I 0)) 0)
     ))
     (=>
      (> (curve25519_dalek!specs.field_specs_u64.p.? (I 0)) 0)
      (=>
       (= tmp%1 (>= base@ 0))
       (and
        (=>
         %%location_label%%1
         tmp%1
        )
        (=>
         tmp%1
         (and
          (and
           (=>
            %%location_label%%2
            (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nonnegative. base@
             9
           ))
           (=>
            (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nonnegative. base@
             9
            )
            (=>
             %%location_label%%3
             (>= (vstd!arithmetic.power.pow.? (I base@) (I 9)) 0)
          )))
          (=>
           (>= (vstd!arithmetic.power.pow.? (I base@) (I 9)) 0)
           (and
            (and
             (=>
              %%location_label%%4
              (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nonnegative. base@
               11
             ))
             (=>
              (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nonnegative. base@
               11
              )
              (=>
               %%location_label%%5
               (>= (vstd!arithmetic.power.pow.? (I base@) (I 11)) 0)
            )))
            (=>
             (>= (vstd!arithmetic.power.pow.? (I base@) (I 11)) 0)
             (=>
              (= t3_val@ (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t3_limbs!)))
              (=>
               (= tmp%2 (>= t3_val@ 0))
               (and
                (=>
                 %%location_label%%6
                 tmp%2
                )
                (=>
                 tmp%2
                 (and
                  (and
                   (=>
                    %%location_label%%7
                    (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nonnegative. t3_val@
                     2
                   ))
                   (=>
                    (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nonnegative. t3_val@
                     2
                    )
                    (=>
                     %%location_label%%8
                     (>= (vstd!arithmetic.power.pow.? (I t3_val@) (I 2)) 0)
                  )))
                  (=>
                   (>= (vstd!arithmetic.power.pow.? (I t3_val@) (I 2)) 0)
                   (and
                    (and
                     (=>
                      %%location_label%%9
                      (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nonnegative. base@
                       22
                     ))
                     (=>
                      (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nonnegative. base@
                       22
                      )
                      (=>
                       %%location_label%%10
                       (>= (vstd!arithmetic.power.pow.? (I base@) (I 22)) 0)
                    )))
                    (=>
                     (>= (vstd!arithmetic.power.pow.? (I base@) (I 22)) 0)
                     (=>
                      (= tmp%3 (= (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
                             (Poly%array%. t3_limbs!)
                            )
                           ) (I 2)
                          )
                         ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                        ) (nClip (EucMod (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
                             (Poly%array%. t3_limbs!)
                            )
                           ) (I 2)
                          ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                      ))))
                      (and
                       (=>
                        %%location_label%%11
                        tmp%3
                       )
                       (=>
                        tmp%3
                        (=>
                         (= tmp%4 (= (EucMod (nClip (vstd!arithmetic.power.pow.? (I base@) (I 22))) (curve25519_dalek!specs.field_specs_u64.p.?
                             (I 0)
                            )
                           ) (nClip (EucMod (vstd!arithmetic.power.pow.? (I base@) (I 22)) (curve25519_dalek!specs.field_specs_u64.p.?
                              (I 0)
                         )))))
                         (and
                          (=>
                           %%location_label%%12
                           tmp%4
                          )
                          (=>
                           tmp%4
                           (and
                            (=>
                             (= tmp%5 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t3_limbs!)))
                             (=>
                              (= tmp%6 (vstd!arithmetic.power.pow.? (I base@) (I 11)))
                              (=>
                               (= tmp%7 (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
                               (and
                                (=>
                                 %%location_label%%13
                                 (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_mod_congruent. tmp%5
                                  tmp%6 2 tmp%7
                                ))
                                (=>
                                 (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_mod_congruent. tmp%5
                                  tmp%6 2 tmp%7
                                 )
                                 (=>
                                  %%location_label%%14
                                  (= (nClip (EucMod (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
                                        (Poly%array%. t3_limbs!)
                                       )
                                      ) (I 2)
                                     ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                    )
                                   ) (nClip (EucMod (vstd!arithmetic.power.pow.? (I (vstd!arithmetic.power.pow.? (I base@)
                                        (I 11)
                                       )
                                      ) (I 2)
                                     ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                            )))))))))
                            (=>
                             (= (nClip (EucMod (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
                                   (Poly%array%. t3_limbs!)
                                  )
                                 ) (I 2)
                                ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                               )
                              ) (nClip (EucMod (vstd!arithmetic.power.pow.? (I (vstd!arithmetic.power.pow.? (I base@)
                                   (I 11)
                                  )
                                 ) (I 2)
                                ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                             )))
                             (and
                              (=>
                               (ens%vstd!arithmetic.power.lemma_pow_multiplies. base@ 11 2)
                               (=>
                                %%location_label%%15
                                (= (vstd!arithmetic.power.pow.? (I (vstd!arithmetic.power.pow.? (I base@) (I 11)))
                                  (I 2)
                                 ) (vstd!arithmetic.power.pow.? (I base@) (I 22))
                              )))
                              (=>
                               (= (vstd!arithmetic.power.pow.? (I (vstd!arithmetic.power.pow.? (I base@) (I 11)))
                                 (I 2)
                                ) (vstd!arithmetic.power.pow.? (I base@) (I 22))
                               )
                               (=>
                                (= tmp%8 (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%.
                                     t4_limbs!
                                    )
                                   ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                  ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I base@) (I 22))) (curve25519_dalek!specs.field_specs_u64.p.?
                                    (I 0)
                                ))))
                                (and
                                 (=>
                                  %%location_label%%16
                                  tmp%8
                                 )
                                 (=>
                                  tmp%8
                                  (and
                                   (=>
                                    (= tmp%9 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t2_limbs!)))
                                    (=>
                                     (= tmp%10 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t4_limbs!)))
                                     (=>
                                      (= tmp%11 (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
                                      (and
                                       (=>
                                        %%location_label%%17
                                        (req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_general. tmp%9 tmp%10 tmp%11)
                                       )
                                       (=>
                                        (ens%vstd!arithmetic.div_mod.lemma_mul_mod_noop_general. tmp%9 tmp%10 tmp%11)
                                        (=>
                                         %%location_label%%18
                                         (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t5_limbs!))
                                           (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                          ) (EucMod (nClip (Mul (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (
                                                Poly%array%. t2_limbs!
                                               )
                                              ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                             ) (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t4_limbs!))
                                              (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                            ))
                                           ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                   ))))))))
                                   (=>
                                    (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t5_limbs!))
                                      (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                     ) (EucMod (nClip (Mul (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (
                                           Poly%array%. t2_limbs!
                                          )
                                         ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                        ) (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t4_limbs!))
                                         (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                       ))
                                      ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                    ))
                                    (=>
                                     (= tmp%12 (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%.
                                          t5_limbs!
                                         )
                                        ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                       ) (EucMod (nClip (Mul (EucMod (nClip (vstd!arithmetic.power.pow.? (I base@) (I 9))) (
                                            curve25519_dalek!specs.field_specs_u64.p.? (I 0)
                                           )
                                          ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I base@) (I 22))) (curve25519_dalek!specs.field_specs_u64.p.?
                                            (I 0)
                                         )))
                                        ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                     )))
                                     (and
                                      (=>
                                       %%location_label%%19
                                       tmp%12
                                      )
                                      (=>
                                       tmp%12
                                       (and
                                        (=>
                                         (= tmp%13 (nClip (vstd!arithmetic.power.pow.? (I base@) (I 9))))
                                         (=>
                                          (= tmp%14 (nClip (vstd!arithmetic.power.pow.? (I base@) (I 22))))
                                          (=>
                                           (= tmp%15 (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
                                           (and
                                            (=>
                                             %%location_label%%20
                                             (req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_general. tmp%13 tmp%14 tmp%15)
                                            )
                                            (=>
                                             (ens%vstd!arithmetic.div_mod.lemma_mul_mod_noop_general. tmp%13 tmp%14 tmp%15)
                                             (=>
                                              %%location_label%%21
                                              (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t5_limbs!))
                                                (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                               ) (EucMod (nClip (Mul (nClip (vstd!arithmetic.power.pow.? (I base@) (I 9))) (nClip (vstd!arithmetic.power.pow.?
                                                    (I base@) (I 22)
                                                 )))
                                                ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                        ))))))))
                                        (=>
                                         (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t5_limbs!))
                                           (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                          ) (EucMod (nClip (Mul (nClip (vstd!arithmetic.power.pow.? (I base@) (I 9))) (nClip (vstd!arithmetic.power.pow.?
                                               (I base@) (I 22)
                                            )))
                                           ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                         ))
                                         (and
                                          (=>
                                           (ens%vstd!arithmetic.power.lemma_pow_adds. base@ 9 22)
                                           (=>
                                            %%location_label%%22
                                            (= (Mul (vstd!arithmetic.power.pow.? (I base@) (I 9)) (vstd!arithmetic.power.pow.? (
                                                I base@
                                               ) (I 22)
                                              )
                                             ) (vstd!arithmetic.power.pow.? (I base@) (I 31))
                                          )))
                                          (=>
                                           (= (Mul (vstd!arithmetic.power.pow.? (I base@) (I 9)) (vstd!arithmetic.power.pow.? (
                                               I base@
                                              ) (I 22)
                                             )
                                            ) (vstd!arithmetic.power.pow.? (I base@) (I 31))
                                           )
                                           (=>
                                            (= tmp%16 (>= (vstd!arithmetic.power.pow.? (I base@) (I 22)) 0))
                                            (and
                                             (=>
                                              %%location_label%%23
                                              tmp%16
                                             )
                                             (=>
                                              tmp%16
                                              (and
                                               (=>
                                                (= tmp%17 (vstd!arithmetic.power.pow.? (I base@) (I 9)))
                                                (=>
                                                 (= tmp%18 (vstd!arithmetic.power.pow.? (I base@) (I 22)))
                                                 (and
                                                  (=>
                                                   %%location_label%%24
                                                   (req%vstd!arithmetic.mul.lemma_mul_nonnegative. tmp%17 tmp%18)
                                                  )
                                                  (=>
                                                   (ens%vstd!arithmetic.mul.lemma_mul_nonnegative. tmp%17 tmp%18)
                                                   (=>
                                                    %%location_label%%25
                                                    (>= (Mul (vstd!arithmetic.power.pow.? (I base@) (I 9)) (vstd!arithmetic.power.pow.?
                                                       (I base@) (I 22)
                                                      )
                                                     ) 0
                                               ))))))
                                               (=>
                                                (>= (Mul (vstd!arithmetic.power.pow.? (I base@) (I 9)) (vstd!arithmetic.power.pow.?
                                                   (I base@) (I 22)
                                                  )
                                                 ) 0
                                                )
                                                (=>
                                                 (= tmp%19 (= (nClip (Mul (nClip (vstd!arithmetic.power.pow.? (I base@) (I 9))) (nClip
                                                      (vstd!arithmetic.power.pow.? (I base@) (I 22))
                                                    ))
                                                   ) (nClip (Mul (vstd!arithmetic.power.pow.? (I base@) (I 9)) (vstd!arithmetic.power.pow.?
                                                      (I base@) (I 22)
                                                 )))))
                                                 (and
                                                  (=>
                                                   %%location_label%%26
                                                   tmp%19
                                                  )
                                                  (=>
                                                   tmp%19
                                                   (=>
                                                    (= tmp%20 (= (nClip (Mul (nClip (vstd!arithmetic.power.pow.? (I base@) (I 9))) (nClip
                                                         (vstd!arithmetic.power.pow.? (I base@) (I 22))
                                                       ))
                                                      ) (nClip (vstd!arithmetic.power.pow.? (I base@) (I 31)))
                                                    ))
                                                    (and
                                                     (=>
                                                      %%location_label%%27
                                                      tmp%20
                                                     )
                                                     (=>
                                                      tmp%20
                                                      (and
                                                       (=>
                                                        (ens%vstd!arithmetic.power2.lemma2_to64. 0)
                                                        (=>
                                                         %%location_label%%28
                                                         (= 31 (Sub (vstd!arithmetic.power2.pow2.? (I 5)) 1))
                                                       ))
                                                       (=>
                                                        (= 31 (Sub (vstd!arithmetic.power2.pow2.? (I 5)) 1))
                                                        (=>
                                                         (= tmp%21 (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%.
                                                              t5_limbs!
                                                             )
                                                            ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                                           ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I base@) (I (nClip (Sub (vstd!arithmetic.power2.pow2.?
                                                                  (I 5)
                                                                 ) 1
                                                             ))))
                                                            ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                                         )))
                                                         (and
                                                          (=>
                                                           %%location_label%%29
                                                           tmp%21
                                                          )
                                                          (=>
                                                           tmp%21
                                                           (and
                                                            (=>
                                                             (ens%vstd!arithmetic.power2.lemma_pow2_pos. 5)
                                                             (=>
                                                              %%location_label%%30
                                                              (> (vstd!arithmetic.power2.pow2.? (I 5)) 0)
                                                            ))
                                                            (=>
                                                             (> (vstd!arithmetic.power2.pow2.? (I 5)) 0)
                                                             (=>
                                                              (= tmp%22 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t5_limbs!)))
                                                              (=>
                                                               (= tmp%23 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t6_limbs!)))
                                                               (=>
                                                                (= tmp%24 (nClip (Sub (vstd!arithmetic.power2.pow2.? (I 5)) 1)))
                                                                (=>
                                                                 (= tmp%25 (vstd!arithmetic.power2.pow2.? (I 5)))
                                                                 (and
                                                                  (=>
                                                                   %%location_label%%31
                                                                   (req%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_pow2k_step.
                                                                    base@ tmp%22 tmp%23 tmp%24 tmp%25
                                                                  ))
                                                                  (=>
                                                                   (ens%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_pow2k_step.
                                                                    base@ tmp%22 tmp%23 tmp%24 tmp%25
                                                                   )
                                                                   (=>
                                                                    (= tmp%26 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t6_limbs!)))
                                                                    (=>
                                                                     (= tmp%27 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t5_limbs!)))
                                                                     (=>
                                                                      (= tmp%28 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t7_limbs!)))
                                                                      (=>
                                                                       (= tmp%29 (nClip (Mul (Sub (vstd!arithmetic.power2.pow2.? (I 5)) 1) (vstd!arithmetic.power2.pow2.?
                                                                           (I 5)
                                                                       ))))
                                                                       (=>
                                                                        (= tmp%30 (nClip (Sub (vstd!arithmetic.power2.pow2.? (I 5)) 1)))
                                                                        (and
                                                                         (=>
                                                                          %%location_label%%32
                                                                          (req%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_geometric_mul_step.
                                                                           base@ tmp%26 tmp%27 tmp%28 tmp%29 tmp%30
                                                                         ))
                                                                         (=>
                                                                          (ens%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_geometric_mul_step.
                                                                           base@ tmp%26 tmp%27 tmp%28 tmp%29 tmp%30
                                                                          )
                                                                          (=>
                                                                           (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_geometric. 5 5)
                                                                           (and
                                                                            (=>
                                                                             (ens%vstd!arithmetic.power2.lemma_pow2_pos. 10)
                                                                             (=>
                                                                              %%location_label%%33
                                                                              (> (vstd!arithmetic.power2.pow2.? (I 10)) 0)
                                                                            ))
                                                                            (=>
                                                                             (> (vstd!arithmetic.power2.pow2.? (I 10)) 0)
                                                                             (=>
                                                                              (= tmp%31 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t7_limbs!)))
                                                                              (=>
                                                                               (= tmp%32 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t8_limbs!)))
                                                                               (=>
                                                                                (= tmp%33 (nClip (Sub (vstd!arithmetic.power2.pow2.? (I 10)) 1)))
                                                                                (=>
                                                                                 (= tmp%34 (vstd!arithmetic.power2.pow2.? (I 10)))
                                                                                 (and
                                                                                  (=>
                                                                                   %%location_label%%34
                                                                                   (req%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_pow2k_step.
                                                                                    base@ tmp%31 tmp%32 tmp%33 tmp%34
                                                                                  ))
                                                                                  (=>
                                                                                   (ens%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_pow2k_step.
                                                                                    base@ tmp%31 tmp%32 tmp%33 tmp%34
                                                                                   )
                                                                                   (=>
                                                                                    (= tmp%35 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t8_limbs!)))
                                                                                    (=>
                                                                                     (= tmp%36 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t7_limbs!)))
                                                                                     (=>
                                                                                      (= tmp%37 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t9_limbs!)))
                                                                                      (=>
                                                                                       (= tmp%38 (nClip (Mul (Sub (vstd!arithmetic.power2.pow2.? (I 10)) 1) (vstd!arithmetic.power2.pow2.?
                                                                                           (I 10)
                                                                                       ))))
                                                                                       (=>
                                                                                        (= tmp%39 (nClip (Sub (vstd!arithmetic.power2.pow2.? (I 10)) 1)))
                                                                                        (and
                                                                                         (=>
                                                                                          %%location_label%%35
                                                                                          (req%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_geometric_mul_step.
                                                                                           base@ tmp%35 tmp%36 tmp%37 tmp%38 tmp%39
                                                                                         ))
                                                                                         (=>
                                                                                          (ens%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_geometric_mul_step.
                                                                                           base@ tmp%35 tmp%36 tmp%37 tmp%38 tmp%39
                                                                                          )
                                                                                          (=>
                                                                                           (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_geometric. 10 10)
                                                                                           (and
                                                                                            (=>
                                                                                             (ens%vstd!arithmetic.power2.lemma_pow2_pos. 20)
                                                                                             (=>
                                                                                              %%location_label%%36
                                                                                              (> (vstd!arithmetic.power2.pow2.? (I 20)) 0)
                                                                                            ))
                                                                                            (=>
                                                                                             (> (vstd!arithmetic.power2.pow2.? (I 20)) 0)
                                                                                             (=>
                                                                                              (= tmp%40 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t9_limbs!)))
                                                                                              (=>
                                                                                               (= tmp%41 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t10_limbs!)))
                                                                                               (=>
                                                                                                (= tmp%42 (nClip (Sub (vstd!arithmetic.power2.pow2.? (I 20)) 1)))
                                                                                                (=>
                                                                                                 (= tmp%43 (vstd!arithmetic.power2.pow2.? (I 20)))
                                                                                                 (and
                                                                                                  (=>
                                                                                                   %%location_label%%37
                                                                                                   (req%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_pow2k_step.
                                                                                                    base@ tmp%40 tmp%41 tmp%42 tmp%43
                                                                                                  ))
                                                                                                  (=>
                                                                                                   (ens%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_pow2k_step.
                                                                                                    base@ tmp%40 tmp%41 tmp%42 tmp%43
                                                                                                   )
                                                                                                   (=>
                                                                                                    (= tmp%44 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t10_limbs!)))
                                                                                                    (=>
                                                                                                     (= tmp%45 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t9_limbs!)))
                                                                                                     (=>
                                                                                                      (= tmp%46 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t11_limbs!)))
                                                                                                      (=>
                                                                                                       (= tmp%47 (nClip (Mul (Sub (vstd!arithmetic.power2.pow2.? (I 20)) 1) (vstd!arithmetic.power2.pow2.?
                                                                                                           (I 20)
                                                                                                       ))))
                                                                                                       (=>
                                                                                                        (= tmp%48 (nClip (Sub (vstd!arithmetic.power2.pow2.? (I 20)) 1)))
                                                                                                        (and
                                                                                                         (=>
                                                                                                          %%location_label%%38
                                                                                                          (req%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_geometric_mul_step.
                                                                                                           base@ tmp%44 tmp%45 tmp%46 tmp%47 tmp%48
                                                                                                         ))
                                                                                                         (=>
                                                                                                          (ens%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_geometric_mul_step.
                                                                                                           base@ tmp%44 tmp%45 tmp%46 tmp%47 tmp%48
                                                                                                          )
                                                                                                          (=>
                                                                                                           (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_geometric. 20 20)
                                                                                                           (and
                                                                                                            (=>
                                                                                                             (ens%vstd!arithmetic.power2.lemma_pow2_pos. 10)
                                                                                                             (=>
                                                                                                              %%location_label%%39
                                                                                                              (> (vstd!arithmetic.power2.pow2.? (I 10)) 0)
                                                                                                            ))
                                                                                                            (=>
                                                                                                             (> (vstd!arithmetic.power2.pow2.? (I 10)) 0)
                                                                                                             (=>
                                                                                                              (= tmp%49 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t11_limbs!)))
                                                                                                              (=>
                                                                                                               (= tmp%50 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t12_limbs!)))
                                                                                                               (=>
                                                                                                                (= tmp%51 (nClip (Sub (vstd!arithmetic.power2.pow2.? (I 40)) 1)))
                                                                                                                (=>
                                                                                                                 (= tmp%52 (vstd!arithmetic.power2.pow2.? (I 10)))
                                                                                                                 (and
                                                                                                                  (=>
                                                                                                                   %%location_label%%40
                                                                                                                   (req%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_pow2k_step.
                                                                                                                    base@ tmp%49 tmp%50 tmp%51 tmp%52
                                                                                                                  ))
                                                                                                                  (=>
                                                                                                                   (ens%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_pow2k_step.
                                                                                                                    base@ tmp%49 tmp%50 tmp%51 tmp%52
                                                                                                                   )
                                                                                                                   (=>
                                                                                                                    (= tmp%53 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t12_limbs!)))
                                                                                                                    (=>
                                                                                                                     (= tmp%54 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t7_limbs!)))
                                                                                                                     (=>
                                                                                                                      (= tmp%55 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t13_limbs!)))
                                                                                                                      (=>
                                                                                                                       (= tmp%56 (nClip (Mul (Sub (vstd!arithmetic.power2.pow2.? (I 40)) 1) (vstd!arithmetic.power2.pow2.?
                                                                                                                           (I 10)
                                                                                                                       ))))
                                                                                                                       (=>
                                                                                                                        (= tmp%57 (nClip (Sub (vstd!arithmetic.power2.pow2.? (I 10)) 1)))
                                                                                                                        (and
                                                                                                                         (=>
                                                                                                                          %%location_label%%41
                                                                                                                          (req%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_geometric_mul_step.
                                                                                                                           base@ tmp%53 tmp%54 tmp%55 tmp%56 tmp%57
                                                                                                                         ))
                                                                                                                         (=>
                                                                                                                          (ens%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_geometric_mul_step.
                                                                                                                           base@ tmp%53 tmp%54 tmp%55 tmp%56 tmp%57
                                                                                                                          )
                                                                                                                          (=>
                                                                                                                           (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_geometric. 40 10)
                                                                                                                           (and
                                                                                                                            (=>
                                                                                                                             (ens%vstd!arithmetic.power2.lemma_pow2_pos. 50)
                                                                                                                             (=>
                                                                                                                              %%location_label%%42
                                                                                                                              (> (vstd!arithmetic.power2.pow2.? (I 50)) 0)
                                                                                                                            ))
                                                                                                                            (=>
                                                                                                                             (> (vstd!arithmetic.power2.pow2.? (I 50)) 0)
                                                                                                                             (=>
                                                                                                                              (= tmp%58 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t13_limbs!)))
                                                                                                                              (=>
                                                                                                                               (= tmp%59 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t14_limbs!)))
                                                                                                                               (=>
                                                                                                                                (= tmp%60 (nClip (Sub (vstd!arithmetic.power2.pow2.? (I 50)) 1)))
                                                                                                                                (=>
                                                                                                                                 (= tmp%61 (vstd!arithmetic.power2.pow2.? (I 50)))
                                                                                                                                 (and
                                                                                                                                  (=>
                                                                                                                                   %%location_label%%43
                                                                                                                                   (req%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_pow2k_step.
                                                                                                                                    base@ tmp%58 tmp%59 tmp%60 tmp%61
                                                                                                                                  ))
                                                                                                                                  (=>
                                                                                                                                   (ens%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_pow2k_step.
                                                                                                                                    base@ tmp%58 tmp%59 tmp%60 tmp%61
                                                                                                                                   )
                                                                                                                                   (=>
                                                                                                                                    (= tmp%62 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t14_limbs!)))
                                                                                                                                    (=>
                                                                                                                                     (= tmp%63 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t13_limbs!)))
                                                                                                                                     (=>
                                                                                                                                      (= tmp%64 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t15_limbs!)))
                                                                                                                                      (=>
                                                                                                                                       (= tmp%65 (nClip (Mul (Sub (vstd!arithmetic.power2.pow2.? (I 50)) 1) (vstd!arithmetic.power2.pow2.?
                                                                                                                                           (I 50)
                                                                                                                                       ))))
                                                                                                                                       (=>
                                                                                                                                        (= tmp%66 (nClip (Sub (vstd!arithmetic.power2.pow2.? (I 50)) 1)))
                                                                                                                                        (and
                                                                                                                                         (=>
                                                                                                                                          %%location_label%%44
                                                                                                                                          (req%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_geometric_mul_step.
                                                                                                                                           base@ tmp%62 tmp%63 tmp%64 tmp%65 tmp%66
                                                                                                                                         ))
                                                                                                                                         (=>
                                                                                                                                          (ens%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_geometric_mul_step.
                                                                                                                                           base@ tmp%62 tmp%63 tmp%64 tmp%65 tmp%66
                                                                                                                                          )
                                                                                                                                          (=>
                                                                                                                                           (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_geometric. 50 50)
                                                                                                                                           (and
                                                                                                                                            (=>
                                                                                                                                             (ens%vstd!arithmetic.power2.lemma_pow2_pos. 100)
                                                                                                                                             (=>
                                                                                                                                              %%location_label%%45
                                                                                                                                              (> (vstd!arithmetic.power2.pow2.? (I 100)) 0)
                                                                                                                                            ))
                                                                                                                                            (=>
                                                                                                                                             (> (vstd!arithmetic.power2.pow2.? (I 100)) 0)
                                                                                                                                             (=>
                                                                                                                                              (= tmp%67 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t15_limbs!)))
                                                                                                                                              (=>
                                                                                                                                               (= tmp%68 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t16_limbs!)))
                                                                                                                                               (=>
                                                                                                                                                (= tmp%69 (nClip (Sub (vstd!arithmetic.power2.pow2.? (I 100)) 1)))
                                                                                                                                                (=>
                                                                                                                                                 (= tmp%70 (vstd!arithmetic.power2.pow2.? (I 100)))
                                                                                                                                                 (and
                                                                                                                                                  (=>
                                                                                                                                                   %%location_label%%46
                                                                                                                                                   (req%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_pow2k_step.
                                                                                                                                                    base@ tmp%67 tmp%68 tmp%69 tmp%70
                                                                                                                                                  ))
                                                                                                                                                  (=>
                                                                                                                                                   (ens%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_pow2k_step.
                                                                                                                                                    base@ tmp%67 tmp%68 tmp%69 tmp%70
                                                                                                                                                   )
                                                                                                                                                   (=>
                                                                                                                                                    (= tmp%71 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t16_limbs!)))
                                                                                                                                                    (=>
                                                                                                                                                     (= tmp%72 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t15_limbs!)))
                                                                                                                                                     (=>
                                                                                                                                                      (= tmp%73 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t17_limbs!)))
                                                                                                                                                      (=>
                                                                                                                                                       (= tmp%74 (nClip (Mul (Sub (vstd!arithmetic.power2.pow2.? (I 100)) 1) (vstd!arithmetic.power2.pow2.?
                                                                                                                                                           (I 100)
                                                                                                                                                       ))))
                                                                                                                                                       (=>
                                                                                                                                                        (= tmp%75 (nClip (Sub (vstd!arithmetic.power2.pow2.? (I 100)) 1)))
                                                                                                                                                        (and
                                                                                                                                                         (=>
                                                                                                                                                          %%location_label%%47
                                                                                                                                                          (req%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_geometric_mul_step.
                                                                                                                                                           base@ tmp%71 tmp%72 tmp%73 tmp%74 tmp%75
                                                                                                                                                         ))
                                                                                                                                                         (=>
                                                                                                                                                          (ens%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_geometric_mul_step.
                                                                                                                                                           base@ tmp%71 tmp%72 tmp%73 tmp%74 tmp%75
                                                                                                                                                          )
                                                                                                                                                          (=>
                                                                                                                                                           (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_geometric. 100 100)
                                                                                                                                                           (and
                                                                                                                                                            (=>
                                                                                                                                                             (ens%vstd!arithmetic.power2.lemma_pow2_pos. 50)
                                                                                                                                                             (=>
                                                                                                                                                              %%location_label%%48
                                                                                                                                                              (> (vstd!arithmetic.power2.pow2.? (I 50)) 0)
                                                                                                                                                            ))
                                                                                                                                                            (=>
                                                                                                                                                             (> (vstd!arithmetic.power2.pow2.? (I 50)) 0)
                                                                                                                                                             (=>
                                                                                                                                                              (= tmp%76 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t17_limbs!)))
                                                                                                                                                              (=>
                                                                                                                                                               (= tmp%77 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t18_limbs!)))
                                                                                                                                                               (=>
                                                                                                                                                                (= tmp%78 (nClip (Sub (vstd!arithmetic.power2.pow2.? (I 200)) 1)))
                                                                                                                                                                (=>
                                                                                                                                                                 (= tmp%79 (vstd!arithmetic.power2.pow2.? (I 50)))
                                                                                                                                                                 (and
                                                                                                                                                                  (=>
                                                                                                                                                                   %%location_label%%49
                                                                                                                                                                   (req%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_pow2k_step.
                                                                                                                                                                    base@ tmp%76 tmp%77 tmp%78 tmp%79
                                                                                                                                                                  ))
                                                                                                                                                                  (=>
                                                                                                                                                                   (ens%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_pow2k_step.
                                                                                                                                                                    base@ tmp%76 tmp%77 tmp%78 tmp%79
                                                                                                                                                                   )
                                                                                                                                                                   (=>
                                                                                                                                                                    (= tmp%80 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t18_limbs!)))
                                                                                                                                                                    (=>
                                                                                                                                                                     (= tmp%81 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t13_limbs!)))
                                                                                                                                                                     (=>
                                                                                                                                                                      (= tmp%82 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t19_limbs!)))
                                                                                                                                                                      (=>
                                                                                                                                                                       (= tmp%83 (nClip (Mul (Sub (vstd!arithmetic.power2.pow2.? (I 200)) 1) (vstd!arithmetic.power2.pow2.?
                                                                                                                                                                           (I 50)
                                                                                                                                                                       ))))
                                                                                                                                                                       (=>
                                                                                                                                                                        (= tmp%84 (nClip (Sub (vstd!arithmetic.power2.pow2.? (I 50)) 1)))
                                                                                                                                                                        (and
                                                                                                                                                                         (=>
                                                                                                                                                                          %%location_label%%50
                                                                                                                                                                          (req%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_geometric_mul_step.
                                                                                                                                                                           base@ tmp%80 tmp%81 tmp%82 tmp%83 tmp%84
                                                                                                                                                                         ))
                                                                                                                                                                         (=>
                                                                                                                                                                          (ens%curve25519_dalek!lemmas.field_lemmas.pow_chain_lemmas.lemma_prove_geometric_mul_step.
                                                                                                                                                                           base@ tmp%80 tmp%81 tmp%82 tmp%83 tmp%84
                                                                                                                                                                          )
                                                                                                                                                                          (=>
                                                                                                                                                                           (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_geometric. 200 50)
                                                                                                                                                                           (and
                                                                                                                                                                            (=>
                                                                                                                                                                             %%location_label%%51
                                                                                                                                                                             (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t19_limbs!))
                                                                                                                                                                               (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                                                                                                                                                              ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
                                                                                                                                                                                   (Poly%array%. self_limbs!)
                                                                                                                                                                                  )
                                                                                                                                                                                 ) (I (nClip (Sub (vstd!arithmetic.power2.pow2.? (I 250)) 1)))
                                                                                                                                                                                )
                                                                                                                                                                               ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                                                                                                                                                            )))
                                                                                                                                                                            (and
                                                                                                                                                                             (=>
                                                                                                                                                                              %%location_label%%52
                                                                                                                                                                              (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t2_limbs!))
                                                                                                                                                                                (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                                                                                                                                                               ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
                                                                                                                                                                                    (Poly%array%. self_limbs!)
                                                                                                                                                                                   )
                                                                                                                                                                                  ) (I 9)
                                                                                                                                                                                 )
                                                                                                                                                                                ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                                                                                                                                                             )))
                                                                                                                                                                             (and
                                                                                                                                                                              (=>
                                                                                                                                                                               %%location_label%%53
                                                                                                                                                                               (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t3_limbs!))
                                                                                                                                                                                 (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                                                                                                                                                                ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
                                                                                                                                                                                     (Poly%array%. self_limbs!)
                                                                                                                                                                                    )
                                                                                                                                                                                   ) (I 11)
                                                                                                                                                                                  )
                                                                                                                                                                                 ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                                                                                                                                                              )))
                                                                                                                                                                              (and
                                                                                                                                                                               (=>
                                                                                                                                                                                %%location_label%%54
                                                                                                                                                                                (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t4_limbs!))
                                                                                                                                                                                  (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                                                                                                                                                                 ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
                                                                                                                                                                                      (Poly%array%. self_limbs!)
                                                                                                                                                                                     )
                                                                                                                                                                                    ) (I 22)
                                                                                                                                                                                   )
                                                                                                                                                                                  ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                                                                                                                                                               )))
                                                                                                                                                                               (and
                                                                                                                                                                                (=>
                                                                                                                                                                                 %%location_label%%55
                                                                                                                                                                                 (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t5_limbs!))
                                                                                                                                                                                   (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                                                                                                                                                                  ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
                                                                                                                                                                                       (Poly%array%. self_limbs!)
                                                                                                                                                                                      )
                                                                                                                                                                                     ) (I (nClip (Sub (vstd!arithmetic.power2.pow2.? (I 5)) 1)))
                                                                                                                                                                                    )
                                                                                                                                                                                   ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                                                                                                                                                                )))
                                                                                                                                                                                (and
                                                                                                                                                                                 (=>
                                                                                                                                                                                  %%location_label%%56
                                                                                                                                                                                  (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t7_limbs!))
                                                                                                                                                                                    (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                                                                                                                                                                   ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
                                                                                                                                                                                        (Poly%array%. self_limbs!)
                                                                                                                                                                                       )
                                                                                                                                                                                      ) (I (nClip (Sub (vstd!arithmetic.power2.pow2.? (I 10)) 1)))
                                                                                                                                                                                     )
                                                                                                                                                                                    ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                                                                                                                                                                 )))
                                                                                                                                                                                 (and
                                                                                                                                                                                  (=>
                                                                                                                                                                                   %%location_label%%57
                                                                                                                                                                                   (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t9_limbs!))
                                                                                                                                                                                     (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                                                                                                                                                                    ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
                                                                                                                                                                                         (Poly%array%. self_limbs!)
                                                                                                                                                                                        )
                                                                                                                                                                                       ) (I (nClip (Sub (vstd!arithmetic.power2.pow2.? (I 20)) 1)))
                                                                                                                                                                                      )
                                                                                                                                                                                     ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                                                                                                                                                                  )))
                                                                                                                                                                                  (and
                                                                                                                                                                                   (=>
                                                                                                                                                                                    %%location_label%%58
                                                                                                                                                                                    (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t11_limbs!))
                                                                                                                                                                                      (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                                                                                                                                                                     ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
                                                                                                                                                                                          (Poly%array%. self_limbs!)
                                                                                                                                                                                         )
                                                                                                                                                                                        ) (I (nClip (Sub (vstd!arithmetic.power2.pow2.? (I 40)) 1)))
                                                                                                                                                                                       )
                                                                                                                                                                                      ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                                                                                                                                                                   )))
                                                                                                                                                                                   (and
                                                                                                                                                                                    (=>
                                                                                                                                                                                     %%location_label%%59
                                                                                                                                                                                     (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t13_limbs!))
                                                                                                                                                                                       (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                                                                                                                                                                      ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
                                                                                                                                                                                           (Poly%array%. self_limbs!)
                                                                                                                                                                                          )
                                                                                                                                                                                         ) (I (nClip (Sub (vstd!arithmetic.power2.pow2.? (I 50)) 1)))
                                                                                                                                                                                        )
                                                                                                                                                                                       ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                                                                                                                                                                    )))
                                                                                                                                                                                    (and
                                                                                                                                                                                     (=>
                                                                                                                                                                                      %%location_label%%60
                                                                                                                                                                                      (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t15_limbs!))
                                                                                                                                                                                        (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                                                                                                                                                                       ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
                                                                                                                                                                                            (Poly%array%. self_limbs!)
                                                                                                                                                                                           )
                                                                                                                                                                                          ) (I (nClip (Sub (vstd!arithmetic.power2.pow2.? (I 100)) 1)))
                                                                                                                                                                                         )
                                                                                                                                                                                        ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                                                                                                                                                                     )))
                                                                                                                                                                                     (=>
                                                                                                                                                                                      %%location_label%%61
                                                                                                                                                                                      (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. t17_limbs!))
                                                                                                                                                                                        (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
                                                                                                                                                                                       ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
                                                                                                                                                                                            (Poly%array%. self_limbs!)
                                                                                                                                                                                           )
                                                                                                                                                                                          ) (I (nClip (Sub (vstd!arithmetic.power2.pow2.? (I 200)) 1)))
                                                                                                                                                                                         )
                                                                                                                                                                                        ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
 )))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))
 (get-info :version)
 (set-option :rlimit 30000000)
 (check-sat)
 (set-option :rlimit 0)
(pop)
