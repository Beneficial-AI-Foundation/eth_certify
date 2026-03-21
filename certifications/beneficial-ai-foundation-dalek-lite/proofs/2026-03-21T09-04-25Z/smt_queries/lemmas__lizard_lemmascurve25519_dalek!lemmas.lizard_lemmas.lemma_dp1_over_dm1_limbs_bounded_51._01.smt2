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

;; MODULE 'module lemmas::lizard_lemmas'
;; curve25519-dalek/src/lemmas/lizard_lemmas.rs:113:5: 113:11 (#0)

;; query spun off because: bitvector

;; Fuel
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_self_0. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_multiples_basic. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_bound. FuelId)
(declare-const fuel%vstd!arithmetic.power2.lemma_pow2_adds. FuelId)
(declare-const fuel%vstd!arithmetic.power2.lemma_pow2_strictly_increases. FuelId)
(declare-const fuel%vstd!std_specs.option.impl&%0.is_Some. FuelId)
(declare-const fuel%vstd!std_specs.option.impl&%0.arrow_0. FuelId)
(declare-const fuel%vstd!std_specs.option.spec_unwrap. FuelId)
(declare-const fuel%vstd!array.array_view. FuelId)
(declare-const fuel%vstd!array.impl&%0.view. FuelId)
(declare-const fuel%vstd!array.impl&%2.spec_index. FuelId)
(declare-const fuel%vstd!array.lemma_array_index. FuelId)
(declare-const fuel%vstd!array.array_len_matches_n. FuelId)
(declare-const fuel%vstd!array.axiom_spec_array_as_slice. FuelId)
(declare-const fuel%vstd!array.axiom_array_ext_equal. FuelId)
(declare-const fuel%vstd!array.axiom_array_has_resolved. FuelId)
(declare-const fuel%vstd!raw_ptr.impl&%3.view. FuelId)
(declare-const fuel%vstd!raw_ptr.ptrs_mut_eq. FuelId)
(declare-const fuel%vstd!raw_ptr.ptrs_mut_eq_sized. FuelId)
(declare-const fuel%vstd!seq.impl&%0.spec_index. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_index_decreases. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_new_len. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_new_index. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_update_len. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_update_same. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_update_different. FuelId)
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
(declare-const fuel%vstd!view.impl&%10.view. FuelId)
(declare-const fuel%vstd!view.impl&%12.view. FuelId)
(declare-const fuel%vstd!view.impl&%14.view. FuelId)
(declare-const fuel%vstd!view.impl&%16.view. FuelId)
(declare-const fuel%vstd!view.impl&%22.view. FuelId)
(declare-const fuel%vstd!view.impl&%26.view. FuelId)
(declare-const fuel%vstd!view.impl&%32.view. FuelId)
(declare-const fuel%vstd!view.impl&%44.view. FuelId)
(declare-const fuel%vstd!view.impl&%46.view. FuelId)
(declare-const fuel%vstd!view.impl&%48.view. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%16.ZERO. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.constants.SQRT_AD_MINUS_ONE.
 FuelId
)
(declare-const fuel%curve25519_dalek!backend.serial.u64.constants.SQRT_M1. FuelId)
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
(declare-const fuel%curve25519_dalek!lizard.u64_constants.SQRT_ID. FuelId)
(declare-const fuel%curve25519_dalek!lizard.u64_constants.DP1_OVER_DM1. FuelId)
(declare-const fuel%curve25519_dalek!lizard.u64_constants.MDOUBLE_INVSQRT_A_MINUS_D.
 FuelId
)
(declare-const fuel%curve25519_dalek!lizard.u64_constants.MIDOUBLE_INVSQRT_A_MINUS_D.
 FuelId
)
(declare-const fuel%curve25519_dalek!lizard.u64_constants.MINVSQRT_ONE_PLUS_D. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.lizard_lemmas.is_slot_in_coset. FuelId)
(declare-const fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat_rec. FuelId)
(declare-const fuel%curve25519_dalek!specs.core_specs.spec_load8_at. FuelId)
(declare-const fuel%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_valid_edwards_point. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_add. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.u64_5_bounded. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.fe51_limbs_bounded. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.sum_of_limbs_bounded. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.fe51_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.fe51_as_canonical_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.as_bytes_post. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.from_bytes_post. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_add. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_sub. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_mul. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_neg. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_square. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_inv. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.spec_fe51_from_bytes. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.is_sqrt_ratio. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.is_sqrt_ratio_times_i. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.is_negative. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_abs. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.nat_invsqrt. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.u8_32_from_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.sqrt_m1. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.p. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.field_canonical. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.mask51. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.ristretto_specs.spec_sqrt_ad_minus_one.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.ristretto_specs.spec_elligator_ristretto_flavor.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.ristretto_specs.ristretto_coset_affine.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.ristretto_specs.elligator_intermediates.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.lizard_specs.spec_lizard_fe_bytes. FuelId)
(declare-const fuel%curve25519_dalek!specs.lizard_specs.spec_lizard_r. FuelId)
(declare-const fuel%curve25519_dalek!specs.lizard_specs.spec_lizard_encode. FuelId)
(declare-const fuel%curve25519_dalek!specs.lizard_specs.jacobi_to_edwards_affine.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.lizard_specs.sqrt_id. FuelId)
(declare-const fuel%curve25519_dalek!specs.lizard_specs.dp1_over_dm1. FuelId)
(declare-const fuel%curve25519_dalek!specs.lizard_specs.spec_elligator_inv. FuelId)
(declare-const fuel%curve25519_dalek!specs.lizard_specs.mdouble_invsqrt_a_minus_d.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.lizard_specs.minvsqrt_one_plus_d. FuelId)
(declare-const fuel%curve25519_dalek!specs.lizard_specs.midouble_invsqrt_a_minus_d.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.lizard_specs.spec_to_jacobi_quartic_ristretto.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.lizard_specs.spec_lizard_decode_candidates.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.lizard_specs.spec_candidate_sha_consistent.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.lizard_specs.spec_sha_consistent_count.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.lizard_specs.partial_sha_consistent_count.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.lizard_specs.is_lizard_preimage_coset.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.lizard_specs.lizard_ristretto_has_unique_preimage.
 FuelId
)
(declare-const fuel%curve25519_dalek!core_assumes.seq_to_array_32. FuelId)
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
 (distinct fuel%vstd!arithmetic.div_mod.lemma_mod_self_0. fuel%vstd!arithmetic.div_mod.lemma_mod_multiples_basic.
  fuel%vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish. fuel%vstd!arithmetic.div_mod.lemma_mod_bound.
  fuel%vstd!arithmetic.power2.lemma_pow2_adds. fuel%vstd!arithmetic.power2.lemma_pow2_strictly_increases.
  fuel%vstd!std_specs.option.impl&%0.is_Some. fuel%vstd!std_specs.option.impl&%0.arrow_0.
  fuel%vstd!std_specs.option.spec_unwrap. fuel%vstd!array.array_view. fuel%vstd!array.impl&%0.view.
  fuel%vstd!array.impl&%2.spec_index. fuel%vstd!array.lemma_array_index. fuel%vstd!array.array_len_matches_n.
  fuel%vstd!array.axiom_spec_array_as_slice. fuel%vstd!array.axiom_array_ext_equal.
  fuel%vstd!array.axiom_array_has_resolved. fuel%vstd!raw_ptr.impl&%3.view. fuel%vstd!raw_ptr.ptrs_mut_eq.
  fuel%vstd!raw_ptr.ptrs_mut_eq_sized. fuel%vstd!seq.impl&%0.spec_index. fuel%vstd!seq.axiom_seq_index_decreases.
  fuel%vstd!seq.axiom_seq_new_len. fuel%vstd!seq.axiom_seq_new_index. fuel%vstd!seq.axiom_seq_update_len.
  fuel%vstd!seq.axiom_seq_update_same. fuel%vstd!seq.axiom_seq_update_different. fuel%vstd!seq.axiom_seq_ext_equal.
  fuel%vstd!seq.axiom_seq_ext_equal_deep. fuel%vstd!slice.impl&%2.spec_index. fuel%vstd!slice.axiom_spec_len.
  fuel%vstd!slice.axiom_slice_ext_equal. fuel%vstd!slice.axiom_slice_has_resolved.
  fuel%vstd!view.impl&%0.view. fuel%vstd!view.impl&%2.view. fuel%vstd!view.impl&%4.view.
  fuel%vstd!view.impl&%6.view. fuel%vstd!view.impl&%10.view. fuel%vstd!view.impl&%12.view.
  fuel%vstd!view.impl&%14.view. fuel%vstd!view.impl&%16.view. fuel%vstd!view.impl&%22.view.
  fuel%vstd!view.impl&%26.view. fuel%vstd!view.impl&%32.view. fuel%vstd!view.impl&%44.view.
  fuel%vstd!view.impl&%46.view. fuel%vstd!view.impl&%48.view. fuel%curve25519_dalek!backend.serial.u64.field.impl&%16.ZERO.
  fuel%curve25519_dalek!backend.serial.u64.constants.SQRT_AD_MINUS_ONE. fuel%curve25519_dalek!backend.serial.u64.constants.SQRT_M1.
  fuel%curve25519_dalek!backend.serial.u64.constants.EDWARDS_D. fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.
  fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.
  fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.
  fuel%curve25519_dalek!lizard.u64_constants.SQRT_ID. fuel%curve25519_dalek!lizard.u64_constants.DP1_OVER_DM1.
  fuel%curve25519_dalek!lizard.u64_constants.MDOUBLE_INVSQRT_A_MINUS_D. fuel%curve25519_dalek!lizard.u64_constants.MIDOUBLE_INVSQRT_A_MINUS_D.
  fuel%curve25519_dalek!lizard.u64_constants.MINVSQRT_ONE_PLUS_D. fuel%curve25519_dalek!lemmas.lizard_lemmas.is_slot_in_coset.
  fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat. fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.
  fuel%curve25519_dalek!specs.core_specs.spec_load8_at. fuel%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.
  fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve. fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.
  fuel%curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point. fuel%curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.
  fuel%curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded. fuel%curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.
  fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_nat. fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.
  fuel%curve25519_dalek!specs.edwards_specs.edwards_add. fuel%curve25519_dalek!specs.field_specs.u64_5_bounded.
  fuel%curve25519_dalek!specs.field_specs.fe51_limbs_bounded. fuel%curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.
  fuel%curve25519_dalek!specs.field_specs.fe51_as_nat. fuel%curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.
  fuel%curve25519_dalek!specs.field_specs.as_bytes_post. fuel%curve25519_dalek!specs.field_specs.from_bytes_post.
  fuel%curve25519_dalek!specs.field_specs.field_add. fuel%curve25519_dalek!specs.field_specs.field_sub.
  fuel%curve25519_dalek!specs.field_specs.field_mul. fuel%curve25519_dalek!specs.field_specs.field_neg.
  fuel%curve25519_dalek!specs.field_specs.field_square. fuel%curve25519_dalek!specs.field_specs.field_inv.
  fuel%curve25519_dalek!specs.field_specs.spec_fe51_from_bytes. fuel%curve25519_dalek!specs.field_specs.is_sqrt_ratio.
  fuel%curve25519_dalek!specs.field_specs.is_sqrt_ratio_times_i. fuel%curve25519_dalek!specs.field_specs.is_negative.
  fuel%curve25519_dalek!specs.field_specs.field_abs. fuel%curve25519_dalek!specs.field_specs.nat_invsqrt.
  fuel%curve25519_dalek!specs.field_specs.u8_32_from_nat. fuel%curve25519_dalek!specs.field_specs.sqrt_m1.
  fuel%curve25519_dalek!specs.field_specs_u64.p. fuel%curve25519_dalek!specs.field_specs_u64.field_canonical.
  fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical. fuel%curve25519_dalek!specs.field_specs_u64.mask51.
  fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat. fuel%curve25519_dalek!specs.ristretto_specs.spec_sqrt_ad_minus_one.
  fuel%curve25519_dalek!specs.ristretto_specs.spec_elligator_ristretto_flavor. fuel%curve25519_dalek!specs.ristretto_specs.ristretto_coset_affine.
  fuel%curve25519_dalek!specs.ristretto_specs.elligator_intermediates. fuel%curve25519_dalek!specs.lizard_specs.spec_lizard_fe_bytes.
  fuel%curve25519_dalek!specs.lizard_specs.spec_lizard_r. fuel%curve25519_dalek!specs.lizard_specs.spec_lizard_encode.
  fuel%curve25519_dalek!specs.lizard_specs.jacobi_to_edwards_affine. fuel%curve25519_dalek!specs.lizard_specs.sqrt_id.
  fuel%curve25519_dalek!specs.lizard_specs.dp1_over_dm1. fuel%curve25519_dalek!specs.lizard_specs.spec_elligator_inv.
  fuel%curve25519_dalek!specs.lizard_specs.mdouble_invsqrt_a_minus_d. fuel%curve25519_dalek!specs.lizard_specs.minvsqrt_one_plus_d.
  fuel%curve25519_dalek!specs.lizard_specs.midouble_invsqrt_a_minus_d. fuel%curve25519_dalek!specs.lizard_specs.spec_to_jacobi_quartic_ristretto.
  fuel%curve25519_dalek!specs.lizard_specs.spec_lizard_decode_candidates. fuel%curve25519_dalek!specs.lizard_specs.spec_candidate_sha_consistent.
  fuel%curve25519_dalek!specs.lizard_specs.spec_sha_consistent_count. fuel%curve25519_dalek!specs.lizard_specs.partial_sha_consistent_count.
  fuel%curve25519_dalek!specs.lizard_specs.is_lizard_preimage_coset. fuel%curve25519_dalek!specs.lizard_specs.lizard_ristretto_has_unique_preimage.
  fuel%curve25519_dalek!core_assumes.seq_to_array_32. fuel%vstd!array.group_array_axioms.
  fuel%vstd!function.group_function_axioms. fuel%vstd!laws_cmp.group_laws_cmp. fuel%vstd!laws_eq.bool_laws.group_laws_eq.
  fuel%vstd!laws_eq.u8_laws.group_laws_eq. fuel%vstd!laws_eq.i8_laws.group_laws_eq.
  fuel%vstd!laws_eq.u16_laws.group_laws_eq. fuel%vstd!laws_eq.i16_laws.group_laws_eq.
  fuel%vstd!laws_eq.u32_laws.group_laws_eq. fuel%vstd!laws_eq.i32_laws.group_laws_eq.
  fuel%vstd!laws_eq.u64_laws.group_laws_eq. fuel%vstd!laws_eq.i64_laws.group_laws_eq.
  fuel%vstd!laws_eq.u128_laws.group_laws_eq. fuel%vstd!laws_eq.i128_laws.group_laws_eq.
  fuel%vstd!laws_eq.usize_laws.group_laws_eq. fuel%vstd!laws_eq.isize_laws.group_laws_eq.
  fuel%vstd!laws_eq.group_laws_eq. fuel%vstd!layout.group_layout_axioms. fuel%vstd!map.group_map_axioms.
  fuel%vstd!multiset.group_multiset_axioms. fuel%vstd!raw_ptr.group_raw_ptr_axioms.
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
   (fuel_bool_default fuel%vstd!array.axiom_spec_array_as_slice.)
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
   (fuel_bool_default fuel%vstd!seq.axiom_seq_update_len.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_update_same.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_update_different.)
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
(declare-fun tr_bound%vstd!std_specs.option.OptionAdditionalFns. (Dcr Type Dcr Type)
 Bool
)

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
(declare-sort vstd!seq.Seq<u8.>. 0)
(declare-sort slice%<u8.>. 0)
(declare-sort allocator_global%. 0)
(declare-datatypes ((core!option.Option. 0) (vstd!raw_ptr.PtrData. 0) (curve25519_dalek!backend.serial.u64.field.FieldElement51.
   0
  ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. 0) (curve25519_dalek!edwards.EdwardsPoint.
   0
  ) (tuple%0. 0) (tuple%2. 0) (tuple%3. 0) (tuple%4. 0)
 ) (((core!option.Option./None) (core!option.Option./Some (core!option.Option./Some/?0
     Poly
   ))
  ) ((vstd!raw_ptr.PtrData./PtrData (vstd!raw_ptr.PtrData./PtrData/?addr Int) (vstd!raw_ptr.PtrData./PtrData/?provenance
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
  ) ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?X
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?Y curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?Z curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?T curve25519_dalek!backend.serial.u64.field.FieldElement51.)
   )
  ) ((tuple%0./tuple%0)) ((tuple%2./tuple%2 (tuple%2./tuple%2/?0 Poly) (tuple%2./tuple%2/?1
     Poly
   ))
  ) ((tuple%3./tuple%3 (tuple%3./tuple%3/?0 Poly) (tuple%3./tuple%3/?1 Poly) (tuple%3./tuple%3/?2
     Poly
   ))
  ) ((tuple%4./tuple%4 (tuple%4./tuple%4/?0 Poly) (tuple%4./tuple%4/?1 Poly) (tuple%4./tuple%4/?2
     Poly
    ) (tuple%4./tuple%4/?3 Poly)
))))
(declare-fun core!option.Option./Some/0 (Dcr Type core!option.Option.) Poly)
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
(declare-fun tuple%3./tuple%3/0 (tuple%3.) Poly)
(declare-fun tuple%3./tuple%3/1 (tuple%3.) Poly)
(declare-fun tuple%3./tuple%3/2 (tuple%3.) Poly)
(declare-fun tuple%4./tuple%4/0 (tuple%4.) Poly)
(declare-fun tuple%4./tuple%4/1 (tuple%4.) Poly)
(declare-fun tuple%4./tuple%4/2 (tuple%4.) Poly)
(declare-fun tuple%4./tuple%4/3 (tuple%4.) Poly)
(declare-fun TYPE%fun%1. (Dcr Type Dcr Type) Type)
(declare-fun TYPE%core!option.Option. (Dcr Type) Type)
(declare-const TYPE%vstd!raw_ptr.Provenance. Type)
(declare-fun TYPE%vstd!raw_ptr.PtrData. (Dcr Type) Type)
(declare-fun TYPE%vstd!seq.Seq. (Dcr Type) Type)
(declare-const TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. Type)
(declare-const TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
 Type
)
(declare-const TYPE%curve25519_dalek!edwards.EdwardsPoint. Type)
(declare-fun TYPE%tuple%2. (Dcr Type Dcr Type) Type)
(declare-fun TYPE%tuple%3. (Dcr Type Dcr Type Dcr Type) Type)
(declare-fun TYPE%tuple%4. (Dcr Type Dcr Type Dcr Type Dcr Type) Type)
(declare-fun Poly%fun%1. (%%Function%%) Poly)
(declare-fun %Poly%fun%1. (Poly) %%Function%%)
(declare-fun Poly%array%. (%%Function%%) Poly)
(declare-fun %Poly%array%. (Poly) %%Function%%)
(declare-fun Poly%vstd!raw_ptr.Provenance. (vstd!raw_ptr.Provenance.) Poly)
(declare-fun %Poly%vstd!raw_ptr.Provenance. (Poly) vstd!raw_ptr.Provenance.)
(declare-fun Poly%vstd!seq.Seq<u8.>. (vstd!seq.Seq<u8.>.) Poly)
(declare-fun %Poly%vstd!seq.Seq<u8.>. (Poly) vstd!seq.Seq<u8.>.)
(declare-fun Poly%slice%<u8.>. (slice%<u8.>.) Poly)
(declare-fun %Poly%slice%<u8.>. (Poly) slice%<u8.>.)
(declare-fun Poly%allocator_global%. (allocator_global%.) Poly)
(declare-fun %Poly%allocator_global%. (Poly) allocator_global%.)
(declare-fun Poly%core!option.Option. (core!option.Option.) Poly)
(declare-fun %Poly%core!option.Option. (Poly) core!option.Option.)
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
(declare-fun Poly%curve25519_dalek!edwards.EdwardsPoint. (curve25519_dalek!edwards.EdwardsPoint.)
 Poly
)
(declare-fun %Poly%curve25519_dalek!edwards.EdwardsPoint. (Poly) curve25519_dalek!edwards.EdwardsPoint.)
(declare-fun Poly%tuple%0. (tuple%0.) Poly)
(declare-fun %Poly%tuple%0. (Poly) tuple%0.)
(declare-fun Poly%tuple%2. (tuple%2.) Poly)
(declare-fun %Poly%tuple%2. (Poly) tuple%2.)
(declare-fun Poly%tuple%3. (tuple%3.) Poly)
(declare-fun %Poly%tuple%3. (Poly) tuple%3.)
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
 (forall ((x vstd!seq.Seq<u8.>.)) (!
   (= x (%Poly%vstd!seq.Seq<u8.>. (Poly%vstd!seq.Seq<u8.>. x)))
   :pattern ((Poly%vstd!seq.Seq<u8.>. x))
   :qid internal_vstd__seq__Seq<u8.>_box_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<u8.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!seq.Seq. $ (UINT 8)))
    (= x (Poly%vstd!seq.Seq<u8.>. (%Poly%vstd!seq.Seq<u8.>. x)))
   )
   :pattern ((has_type x (TYPE%vstd!seq.Seq. $ (UINT 8))))
   :qid internal_vstd__seq__Seq<u8.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<u8.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!seq.Seq<u8.>.)) (!
   (has_type (Poly%vstd!seq.Seq<u8.>. x) (TYPE%vstd!seq.Seq. $ (UINT 8)))
   :pattern ((has_type (Poly%vstd!seq.Seq<u8.>. x) (TYPE%vstd!seq.Seq. $ (UINT 8))))
   :qid internal_vstd__seq__Seq<u8.>_has_type_always_definition
   :skolemid skolem_internal_vstd__seq__Seq<u8.>_has_type_always_definition
)))
(assert
 (forall ((x slice%<u8.>.)) (!
   (= x (%Poly%slice%<u8.>. (Poly%slice%<u8.>. x)))
   :pattern ((Poly%slice%<u8.>. x))
   :qid internal_crate__slice__<u8.>_box_axiom_definition
   :skolemid skolem_internal_crate__slice__<u8.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (SLICE $ (UINT 8)))
    (= x (Poly%slice%<u8.>. (%Poly%slice%<u8.>. x)))
   )
   :pattern ((has_type x (SLICE $ (UINT 8))))
   :qid internal_crate__slice__<u8.>_unbox_axiom_definition
   :skolemid skolem_internal_crate__slice__<u8.>_unbox_axiom_definition
)))
(assert
 (forall ((x slice%<u8.>.)) (!
   (has_type (Poly%slice%<u8.>. x) (SLICE $ (UINT 8)))
   :pattern ((has_type (Poly%slice%<u8.>. x) (SLICE $ (UINT 8))))
   :qid internal_crate__slice__<u8.>_has_type_always_definition
   :skolemid skolem_internal_crate__slice__<u8.>_has_type_always_definition
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
 (forall ((x core!option.Option.)) (!
   (= x (%Poly%core!option.Option. (Poly%core!option.Option. x)))
   :pattern ((Poly%core!option.Option. x))
   :qid internal_core__option__Option_box_axiom_definition
   :skolemid skolem_internal_core__option__Option_box_axiom_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%core!option.Option. V&. V&))
    (= x (Poly%core!option.Option. (%Poly%core!option.Option. x)))
   )
   :pattern ((has_type x (TYPE%core!option.Option. V&. V&)))
   :qid internal_core__option__Option_unbox_axiom_definition
   :skolemid skolem_internal_core__option__Option_unbox_axiom_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type)) (!
   (has_type (Poly%core!option.Option. core!option.Option./None) (TYPE%core!option.Option.
     V&. V&
   ))
   :pattern ((has_type (Poly%core!option.Option. core!option.Option./None) (TYPE%core!option.Option.
      V&. V&
   )))
   :qid internal_core!option.Option./None_constructor_definition
   :skolemid skolem_internal_core!option.Option./None_constructor_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (_0! Poly)) (!
   (=>
    (has_type _0! V&)
    (has_type (Poly%core!option.Option. (core!option.Option./Some _0!)) (TYPE%core!option.Option.
      V&. V&
   )))
   :pattern ((has_type (Poly%core!option.Option. (core!option.Option./Some _0!)) (TYPE%core!option.Option.
      V&. V&
   )))
   :qid internal_core!option.Option./Some_constructor_definition
   :skolemid skolem_internal_core!option.Option./Some_constructor_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (x core!option.Option.)) (!
   (=>
    (is-core!option.Option./Some x)
    (= (core!option.Option./Some/0 V&. V& x) (core!option.Option./Some/?0 x))
   )
   :pattern ((core!option.Option./Some/0 V&. V& x))
   :qid internal_core!option.Option./Some/0_accessor_definition
   :skolemid skolem_internal_core!option.Option./Some/0_accessor_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%core!option.Option. V&. V&))
    (has_type (core!option.Option./Some/0 V&. V& (%Poly%core!option.Option. x)) V&)
   )
   :pattern ((core!option.Option./Some/0 V&. V& (%Poly%core!option.Option. x)) (has_type
     x (TYPE%core!option.Option. V&. V&)
   ))
   :qid internal_core!option.Option./Some/0_invariant_definition
   :skolemid skolem_internal_core!option.Option./Some/0_invariant_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (x core!option.Option.)) (!
   (=>
    (is-core!option.Option./Some x)
    (height_lt (height (core!option.Option./Some/0 V&. V& x)) (height (Poly%core!option.Option.
       x
   ))))
   :pattern ((height (core!option.Option./Some/0 V&. V& x)))
   :qid prelude_datatype_height_core!option.Option./Some/0
   :skolemid skolem_prelude_datatype_height_core!option.Option./Some/0
)))
(assert
 (forall ((V&. Dcr) (V& Type) (deep Bool) (x Poly) (y Poly)) (!
   (=>
    (and
     (has_type x (TYPE%core!option.Option. V&. V&))
     (has_type y (TYPE%core!option.Option. V&. V&))
     (is-core!option.Option./None (%Poly%core!option.Option. x))
     (is-core!option.Option./None (%Poly%core!option.Option. y))
    )
    (ext_eq deep (TYPE%core!option.Option. V&. V&) x y)
   )
   :pattern ((ext_eq deep (TYPE%core!option.Option. V&. V&) x y))
   :qid internal_core!option.Option./None_ext_equal_definition
   :skolemid skolem_internal_core!option.Option./None_ext_equal_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (deep Bool) (x Poly) (y Poly)) (!
   (=>
    (and
     (has_type x (TYPE%core!option.Option. V&. V&))
     (has_type y (TYPE%core!option.Option. V&. V&))
     (is-core!option.Option./Some (%Poly%core!option.Option. x))
     (is-core!option.Option./Some (%Poly%core!option.Option. y))
     (ext_eq deep V& (core!option.Option./Some/0 V&. V& (%Poly%core!option.Option. x))
      (core!option.Option./Some/0 V&. V& (%Poly%core!option.Option. y))
    ))
    (ext_eq deep (TYPE%core!option.Option. V&. V&) x y)
   )
   :pattern ((ext_eq deep (TYPE%core!option.Option. V&. V&) x y))
   :qid internal_core!option.Option./Some_ext_equal_definition
   :skolemid skolem_internal_core!option.Option./Some_ext_equal_definition
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
 (forall ((x tuple%3.)) (!
   (= x (%Poly%tuple%3. (Poly%tuple%3. x)))
   :pattern ((Poly%tuple%3. x))
   :qid internal_crate__tuple__3_box_axiom_definition
   :skolemid skolem_internal_crate__tuple__3_box_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (x
    Poly
   )
  ) (!
   (=>
    (has_type x (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
    (= x (Poly%tuple%3. (%Poly%tuple%3. x)))
   )
   :pattern ((has_type x (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&)))
   :qid internal_crate__tuple__3_unbox_axiom_definition
   :skolemid skolem_internal_crate__tuple__3_unbox_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (_0!
    Poly
   ) (_1! Poly) (_2! Poly)
  ) (!
   (=>
    (and
     (has_type _0! T%0&)
     (has_type _1! T%1&)
     (has_type _2! T%2&)
    )
    (has_type (Poly%tuple%3. (tuple%3./tuple%3 _0! _1! _2!)) (TYPE%tuple%3. T%0&. T%0&
      T%1&. T%1& T%2&. T%2&
   )))
   :pattern ((has_type (Poly%tuple%3. (tuple%3./tuple%3 _0! _1! _2!)) (TYPE%tuple%3. T%0&.
      T%0& T%1&. T%1& T%2&. T%2&
   )))
   :qid internal_tuple__3./tuple__3_constructor_definition
   :skolemid skolem_internal_tuple__3./tuple__3_constructor_definition
)))
(assert
 (forall ((x tuple%3.)) (!
   (= (tuple%3./tuple%3/0 x) (tuple%3./tuple%3/?0 x))
   :pattern ((tuple%3./tuple%3/0 x))
   :qid internal_tuple__3./tuple__3/0_accessor_definition
   :skolemid skolem_internal_tuple__3./tuple__3/0_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (x
    Poly
   )
  ) (!
   (=>
    (has_type x (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
    (has_type (tuple%3./tuple%3/0 (%Poly%tuple%3. x)) T%0&)
   )
   :pattern ((tuple%3./tuple%3/0 (%Poly%tuple%3. x)) (has_type x (TYPE%tuple%3. T%0&. T%0&
      T%1&. T%1& T%2&. T%2&
   )))
   :qid internal_tuple__3./tuple__3/0_invariant_definition
   :skolemid skolem_internal_tuple__3./tuple__3/0_invariant_definition
)))
(assert
 (forall ((x tuple%3.)) (!
   (= (tuple%3./tuple%3/1 x) (tuple%3./tuple%3/?1 x))
   :pattern ((tuple%3./tuple%3/1 x))
   :qid internal_tuple__3./tuple__3/1_accessor_definition
   :skolemid skolem_internal_tuple__3./tuple__3/1_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (x
    Poly
   )
  ) (!
   (=>
    (has_type x (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
    (has_type (tuple%3./tuple%3/1 (%Poly%tuple%3. x)) T%1&)
   )
   :pattern ((tuple%3./tuple%3/1 (%Poly%tuple%3. x)) (has_type x (TYPE%tuple%3. T%0&. T%0&
      T%1&. T%1& T%2&. T%2&
   )))
   :qid internal_tuple__3./tuple__3/1_invariant_definition
   :skolemid skolem_internal_tuple__3./tuple__3/1_invariant_definition
)))
(assert
 (forall ((x tuple%3.)) (!
   (= (tuple%3./tuple%3/2 x) (tuple%3./tuple%3/?2 x))
   :pattern ((tuple%3./tuple%3/2 x))
   :qid internal_tuple__3./tuple__3/2_accessor_definition
   :skolemid skolem_internal_tuple__3./tuple__3/2_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (x
    Poly
   )
  ) (!
   (=>
    (has_type x (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
    (has_type (tuple%3./tuple%3/2 (%Poly%tuple%3. x)) T%2&)
   )
   :pattern ((tuple%3./tuple%3/2 (%Poly%tuple%3. x)) (has_type x (TYPE%tuple%3. T%0&. T%0&
      T%1&. T%1& T%2&. T%2&
   )))
   :qid internal_tuple__3./tuple__3/2_invariant_definition
   :skolemid skolem_internal_tuple__3./tuple__3/2_invariant_definition
)))
(assert
 (forall ((x tuple%3.)) (!
   (=>
    (is-tuple%3./tuple%3 x)
    (height_lt (height (tuple%3./tuple%3/0 x)) (height (Poly%tuple%3. x)))
   )
   :pattern ((height (tuple%3./tuple%3/0 x)))
   :qid prelude_datatype_height_tuple%3./tuple%3/0
   :skolemid skolem_prelude_datatype_height_tuple%3./tuple%3/0
)))
(assert
 (forall ((x tuple%3.)) (!
   (=>
    (is-tuple%3./tuple%3 x)
    (height_lt (height (tuple%3./tuple%3/1 x)) (height (Poly%tuple%3. x)))
   )
   :pattern ((height (tuple%3./tuple%3/1 x)))
   :qid prelude_datatype_height_tuple%3./tuple%3/1
   :skolemid skolem_prelude_datatype_height_tuple%3./tuple%3/1
)))
(assert
 (forall ((x tuple%3.)) (!
   (=>
    (is-tuple%3./tuple%3 x)
    (height_lt (height (tuple%3./tuple%3/2 x)) (height (Poly%tuple%3. x)))
   )
   :pattern ((height (tuple%3./tuple%3/2 x)))
   :qid prelude_datatype_height_tuple%3./tuple%3/2
   :skolemid skolem_prelude_datatype_height_tuple%3./tuple%3/2
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (deep
    Bool
   ) (x Poly) (y Poly)
  ) (!
   (=>
    (and
     (has_type x (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
     (has_type y (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
     (ext_eq deep T%0& (tuple%3./tuple%3/0 (%Poly%tuple%3. x)) (tuple%3./tuple%3/0 (%Poly%tuple%3.
        y
     )))
     (ext_eq deep T%1& (tuple%3./tuple%3/1 (%Poly%tuple%3. x)) (tuple%3./tuple%3/1 (%Poly%tuple%3.
        y
     )))
     (ext_eq deep T%2& (tuple%3./tuple%3/2 (%Poly%tuple%3. x)) (tuple%3./tuple%3/2 (%Poly%tuple%3.
        y
    ))))
    (ext_eq deep (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&) x y)
   )
   :pattern ((ext_eq deep (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&) x y))
   :qid internal_tuple__3./tuple__3_ext_equal_definition
   :skolemid skolem_internal_tuple__3./tuple__3_ext_equal_definition
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
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (tr_bound%vstd!std_specs.option.OptionAdditionalFns. Self%&. Self%& T&. T&)
    (and
     (sized Self%&.)
     (sized T&.)
   ))
   :pattern ((tr_bound%vstd!std_specs.option.OptionAdditionalFns. Self%&. Self%& T&. T&))
   :qid internal_vstd__std_specs__option__OptionAdditionalFns_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__std_specs__option__OptionAdditionalFns_trait_type_bounds_definition
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
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%%vstd!view.View./V $ (TYPE%core!option.Option. T&. T&)) $)
   :pattern ((proj%%vstd!view.View./V $ (TYPE%core!option.Option. T&. T&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%vstd!view.View./V $ (TYPE%core!option.Option. T&. T&)) (TYPE%core!option.Option.
     T&. T&
   ))
   :pattern ((proj%vstd!view.View./V $ (TYPE%core!option.Option. T&. T&)))
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
 (= (proj%%vstd!view.View./V $ (SINT 32)) $)
)
(assert
 (= (proj%vstd!view.View./V $ (SINT 32)) (SINT 32))
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
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type)) (!
   (= (proj%%vstd!view.View./V (DST A2&.) (TYPE%tuple%3. A0&. A0& A1&. A1& A2&. A2&))
    (DST (proj%%vstd!view.View./V A2&. A2&))
   )
   :pattern ((proj%%vstd!view.View./V (DST A2&.) (TYPE%tuple%3. A0&. A0& A1&. A1& A2&.
      A2&
   )))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type)) (!
   (= (proj%vstd!view.View./V (DST A2&.) (TYPE%tuple%3. A0&. A0& A1&. A1& A2&. A2&))
    (TYPE%tuple%3. (proj%%vstd!view.View./V A0&. A0&) (proj%vstd!view.View./V A0&. A0&)
     (proj%%vstd!view.View./V A1&. A1&) (proj%vstd!view.View./V A1&. A1&) (proj%%vstd!view.View./V
      A2&. A2&
     ) (proj%vstd!view.View./V A2&. A2&)
   ))
   :pattern ((proj%vstd!view.View./V (DST A2&.) (TYPE%tuple%3. A0&. A0& A1&. A1& A2&. A2&)))
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

;; Function-Decl vstd::seq::Seq::new
(declare-fun vstd!seq.Seq.new.? (Dcr Type Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::Seq::update
(declare-fun vstd!seq.Seq.update.? (Dcr Type Poly Poly Poly) Poly)

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

;; Function-Decl vstd::array::spec_array_as_slice
(declare-fun vstd!array.spec_array_as_slice.? (Dcr Type Dcr Type Poly) Poly)

;; Function-Decl vstd::raw_ptr::view_reverse_for_eq
(declare-fun vstd!raw_ptr.view_reverse_for_eq.? (Dcr Type Poly) Poly)

;; Function-Decl vstd::raw_ptr::view_reverse_for_eq_sized
(declare-fun vstd!raw_ptr.view_reverse_for_eq_sized.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::arithmetic::power::pow
(declare-fun vstd!arithmetic.power.pow.? (Poly Poly) Int)

;; Function-Decl vstd::arithmetic::power2::pow2
(declare-fun vstd!arithmetic.power2.pow2.? (Poly) Int)

;; Function-Decl vstd::std_specs::option::OptionAdditionalFns::is_Some
(declare-fun vstd!std_specs.option.OptionAdditionalFns.is_Some.? (Dcr Type Dcr Type
  Poly
 ) Poly
)
(declare-fun vstd!std_specs.option.OptionAdditionalFns.is_Some%default%.? (Dcr Type
  Dcr Type Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::option::OptionAdditionalFns::arrow_0
(declare-fun vstd!std_specs.option.OptionAdditionalFns.arrow_0.? (Dcr Type Dcr Type
  Poly
 ) Poly
)
(declare-fun vstd!std_specs.option.OptionAdditionalFns.arrow_0%default%.? (Dcr Type
  Dcr Type Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::option::spec_unwrap
(declare-fun vstd!std_specs.option.spec_unwrap.? (Dcr Type Poly) Poly)

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

;; Function-Decl curve25519_dalek::backend::serial::u64::constants::spec_eight_torsion
(declare-fun curve25519_dalek!backend.serial.u64.constants.spec_eight_torsion.? (Poly)
 %%Function%%
)

;; Function-Decl curve25519_dalek::specs::field_specs::u64_5_bounded
(declare-fun curve25519_dalek!specs.field_specs.u64_5_bounded.? (Poly Poly) Bool)

;; Function-Decl curve25519_dalek::specs::field_specs::fe51_limbs_bounded
(declare-fun curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly Poly) Bool)

;; Function-Decl curve25519_dalek::specs::field_specs::field_neg
(declare-fun curve25519_dalek!specs.field_specs.field_neg.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::mask51
(declare-fun curve25519_dalek!specs.field_specs_u64.mask51.? () Int)

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

;; Function-Decl curve25519_dalek::specs::field_specs::sum_of_limbs_bounded
(declare-fun curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? (Poly Poly Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_well_formed_edwards_point
(declare-fun curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? (
  Poly
 ) Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_add
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_add.? (Poly Poly Poly Poly)
 tuple%2.
)

;; Function-Decl curve25519_dalek::specs::core_specs::bytes_as_nat_prefix
(declare-fun curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (Poly Poly) Int)
(declare-fun curve25519_dalek!specs.core_specs.rec%bytes_as_nat_prefix.? (Poly Poly
  Fuel
 ) Int
)

;; Function-Decl curve25519_dalek::core_assumes::spec_sha256
(declare-fun curve25519_dalek!core_assumes.spec_sha256.? (Poly) vstd!seq.Seq<u8.>.)

;; Function-Decl curve25519_dalek::backend::serial::u64::field::impl&%16::ZERO
(declare-fun curve25519_dalek!backend.serial.u64.field.impl&%16.ZERO.? () curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::backend::serial::u64::constants::SQRT_AD_MINUS_ONE
(declare-fun curve25519_dalek!backend.serial.u64.constants.SQRT_AD_MINUS_ONE.? ()
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)

;; Function-Decl curve25519_dalek::backend::serial::u64::constants::SQRT_M1
(declare-fun curve25519_dalek!backend.serial.u64.constants.SQRT_M1.? () curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::lizard::u64_constants::SQRT_ID
(declare-fun curve25519_dalek!lizard.u64_constants.SQRT_ID.? () curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::lizard::u64_constants::DP1_OVER_DM1
(declare-fun curve25519_dalek!lizard.u64_constants.DP1_OVER_DM1.? () curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::lizard::u64_constants::MDOUBLE_INVSQRT_A_MINUS_D
(declare-fun curve25519_dalek!lizard.u64_constants.MDOUBLE_INVSQRT_A_MINUS_D.? ()
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)

;; Function-Decl curve25519_dalek::lizard::u64_constants::MIDOUBLE_INVSQRT_A_MINUS_D
(declare-fun curve25519_dalek!lizard.u64_constants.MIDOUBLE_INVSQRT_A_MINUS_D.? ()
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)

;; Function-Decl curve25519_dalek::lizard::u64_constants::MINVSQRT_ONE_PLUS_D
(declare-fun curve25519_dalek!lizard.u64_constants.MINVSQRT_ONE_PLUS_D.? () curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::specs::field_specs::sqrt_m1
(declare-fun curve25519_dalek!specs.field_specs.sqrt_m1.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::is_negative
(declare-fun curve25519_dalek!specs.field_specs.is_negative.? (Poly) Bool)

;; Function-Decl curve25519_dalek::specs::field_specs::nat_invsqrt
(declare-fun curve25519_dalek!specs.field_specs.nat_invsqrt.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::field_abs
(declare-fun curve25519_dalek!specs.field_specs.field_abs.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::is_sqrt_ratio
(declare-fun curve25519_dalek!specs.field_specs.is_sqrt_ratio.? (Poly Poly Poly) Bool)

;; Function-Decl curve25519_dalek::specs::ristretto_specs::elligator_intermediates
(declare-fun curve25519_dalek!specs.ristretto_specs.elligator_intermediates.? (Poly)
 tuple%3.
)

;; Function-Decl curve25519_dalek::specs::ristretto_specs::spec_sqrt_ad_minus_one
(declare-fun curve25519_dalek!specs.ristretto_specs.spec_sqrt_ad_minus_one.? (Poly)
 Int
)

;; Function-Decl curve25519_dalek::specs::ristretto_specs::spec_elligator_ristretto_flavor
(declare-fun curve25519_dalek!specs.ristretto_specs.spec_elligator_ristretto_flavor.?
 (Poly) tuple%2.
)

;; Function-Decl curve25519_dalek::lemmas::lizard_lemmas::is_slot_in_coset
(declare-fun curve25519_dalek!lemmas.lizard_lemmas.is_slot_in_coset.? (Poly Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::core_specs::u8_32_as_nat_rec
(declare-fun curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.? (Poly Poly) Int)
(declare-fun curve25519_dalek!specs.core_specs.rec%u8_32_as_nat_rec.? (Poly Poly Fuel)
 Int
)

;; Function-Decl curve25519_dalek::specs::core_specs::spec_load8_at
(declare-fun curve25519_dalek!specs.core_specs.spec_load8_at.? (Poly Poly) Int)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_on_edwards_curve
(declare-fun curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.? (Poly Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::field_specs::fe51_as_nat
(declare-fun curve25519_dalek!specs.field_specs.fe51_as_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::as_bytes_post
(declare-fun curve25519_dalek!specs.field_specs.as_bytes_post.? (Poly Poly) Bool)

;; Function-Decl curve25519_dalek::specs::field_specs::from_bytes_post
(declare-fun curve25519_dalek!specs.field_specs.from_bytes_post.? (Poly Poly) Bool)

;; Function-Decl curve25519_dalek::specs::field_specs::spec_fe51_from_bytes
(declare-fun curve25519_dalek!specs.field_specs.spec_fe51_from_bytes.? (Poly) curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::specs::field_specs::is_sqrt_ratio_times_i
(declare-fun curve25519_dalek!specs.field_specs.is_sqrt_ratio_times_i.? (Poly Poly
  Poly
 ) Bool
)

;; Function-Decl curve25519_dalek::specs::field_specs::u8_32_from_nat
(declare-fun curve25519_dalek!specs.field_specs.u8_32_from_nat.? (Poly) %%Function%%)

;; Function-Decl curve25519_dalek::specs::ristretto_specs::ristretto_coset_affine
(declare-fun curve25519_dalek!specs.ristretto_specs.ristretto_coset_affine.? (Poly
  Poly
 ) %%Function%%
)

;; Function-Decl curve25519_dalek::core_assumes::seq_to_array_32
(declare-fun curve25519_dalek!core_assumes.seq_to_array_32.? (Poly) %%Function%%)

;; Function-Decl curve25519_dalek::specs::lizard_specs::spec_lizard_fe_bytes
(declare-fun curve25519_dalek!specs.lizard_specs.spec_lizard_fe_bytes.? (Poly) %%Function%%)

;; Function-Decl curve25519_dalek::specs::lizard_specs::spec_lizard_r
(declare-fun curve25519_dalek!specs.lizard_specs.spec_lizard_r.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::lizard_specs::spec_lizard_encode
(declare-fun curve25519_dalek!specs.lizard_specs.spec_lizard_encode.? (Poly) tuple%2.)

;; Function-Decl curve25519_dalek::specs::lizard_specs::jacobi_to_edwards_affine
(declare-fun curve25519_dalek!specs.lizard_specs.jacobi_to_edwards_affine.? (Poly Poly)
 tuple%2.
)

;; Function-Decl curve25519_dalek::specs::lizard_specs::sqrt_id
(declare-fun curve25519_dalek!specs.lizard_specs.sqrt_id.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::lizard_specs::dp1_over_dm1
(declare-fun curve25519_dalek!specs.lizard_specs.dp1_over_dm1.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::lizard_specs::spec_elligator_inv
(declare-fun curve25519_dalek!specs.lizard_specs.spec_elligator_inv.? (Poly Poly)
 tuple%2.
)

;; Function-Decl curve25519_dalek::specs::lizard_specs::mdouble_invsqrt_a_minus_d
(declare-fun curve25519_dalek!specs.lizard_specs.mdouble_invsqrt_a_minus_d.? (Poly)
 Int
)

;; Function-Decl curve25519_dalek::specs::lizard_specs::minvsqrt_one_plus_d
(declare-fun curve25519_dalek!specs.lizard_specs.minvsqrt_one_plus_d.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::lizard_specs::midouble_invsqrt_a_minus_d
(declare-fun curve25519_dalek!specs.lizard_specs.midouble_invsqrt_a_minus_d.? (Poly)
 Int
)

;; Function-Decl curve25519_dalek::specs::lizard_specs::spec_to_jacobi_quartic_ristretto
(declare-fun curve25519_dalek!specs.lizard_specs.spec_to_jacobi_quartic_ristretto.?
 (Poly) %%Function%%
)

;; Function-Decl curve25519_dalek::specs::lizard_specs::spec_lizard_decode_candidates
(declare-fun curve25519_dalek!specs.lizard_specs.spec_lizard_decode_candidates.? (
  Poly
 ) %%Function%%
)

;; Function-Decl curve25519_dalek::specs::lizard_specs::spec_candidate_sha_consistent
(declare-fun curve25519_dalek!specs.lizard_specs.spec_candidate_sha_consistent.? (
  Poly
 ) Bool
)

;; Function-Decl curve25519_dalek::specs::lizard_specs::spec_sha_consistent_count
(declare-fun curve25519_dalek!specs.lizard_specs.spec_sha_consistent_count.? (Poly)
 Int
)

;; Function-Decl curve25519_dalek::specs::lizard_specs::partial_sha_consistent_count
(declare-fun curve25519_dalek!specs.lizard_specs.partial_sha_consistent_count.? (Poly
  Poly
 ) Int
)
(declare-fun curve25519_dalek!specs.lizard_specs.rec%partial_sha_consistent_count.?
 (Poly Poly Fuel) Int
)

;; Function-Decl curve25519_dalek::specs::lizard_specs::is_lizard_preimage_coset
(declare-fun curve25519_dalek!specs.lizard_specs.is_lizard_preimage_coset.? (Poly Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::lizard_specs::lizard_ristretto_has_unique_preimage
(declare-fun curve25519_dalek!specs.lizard_specs.lizard_ristretto_has_unique_preimage.?
 (Poly Poly) Bool
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

;; Function-Specs vstd::seq::Seq::update
(declare-fun req%vstd!seq.Seq.update. (Dcr Type Poly Poly Poly) Bool)
(declare-const %%global_location_label%%2 Bool)
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly) (a! Poly)) (!
   (= (req%vstd!seq.Seq.update. A&. A& self! i! a!) (=>
     %%global_location_label%%2
     (let
      ((tmp%%$ (%I i!)))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ (vstd!seq.Seq.len.? A&. A& self!))
   ))))
   :pattern ((req%vstd!seq.Seq.update. A&. A& self! i! a!))
   :qid internal_req__vstd!seq.Seq.update._definition
   :skolemid skolem_internal_req__vstd!seq.Seq.update._definition
)))

;; Function-Axioms vstd::seq::Seq::update
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly) (a! Poly)) (!
   (=>
    (and
     (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
     (has_type i! INT)
     (has_type a! A&)
    )
    (has_type (vstd!seq.Seq.update.? A&. A& self! i! a!) (TYPE%vstd!seq.Seq. A&. A&))
   )
   :pattern ((vstd!seq.Seq.update.? A&. A& self! i! a!))
   :qid internal_vstd!seq.Seq.update.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.update.?_pre_post_definition
)))

;; Broadcast vstd::seq::axiom_seq_update_len
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_update_len.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (i! Poly) (a! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type i! INT)
      (has_type a! A&)
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
      (= (vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.update.? A&. A& s! i! a!)) (vstd!seq.Seq.len.?
        A&. A& s!
    ))))
    :pattern ((vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.update.? A&. A& s! i! a!)))
    :qid user_vstd__seq__axiom_seq_update_len_3
    :skolemid skolem_user_vstd__seq__axiom_seq_update_len_3
))))

;; Broadcast vstd::seq::axiom_seq_update_same
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_update_same.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (i! Poly) (a! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type i! INT)
      (has_type a! A&)
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
      (= (vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.update.? A&. A& s! i! a!) i!) a!)
    ))
    :pattern ((vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.update.? A&. A& s! i! a!) i!))
    :qid user_vstd__seq__axiom_seq_update_same_4
    :skolemid skolem_user_vstd__seq__axiom_seq_update_same_4
))))

;; Broadcast vstd::seq::axiom_seq_update_different
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_update_different.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (i1! Poly) (i2! Poly) (a! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type i1! INT)
      (has_type i2! INT)
      (has_type a! A&)
     )
     (=>
      (and
       (and
        (and
         (sized A&.)
         (let
          ((tmp%%$ (%I i1!)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ (vstd!seq.Seq.len.? A&. A& s!))
        )))
        (let
         ((tmp%%$ (%I i2!)))
         (and
          (<= 0 tmp%%$)
          (< tmp%%$ (vstd!seq.Seq.len.? A&. A& s!))
       )))
       (not (= i1! i2!))
      )
      (= (vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.update.? A&. A& s! i2! a!) i1!) (vstd!seq.Seq.index.?
        A&. A& s! i1!
    ))))
    :pattern ((vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.update.? A&. A& s! i2! a!) i1!))
    :qid user_vstd__seq__axiom_seq_update_different_5
    :skolemid skolem_user_vstd__seq__axiom_seq_update_different_5
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
          :qid user_vstd__seq__axiom_seq_ext_equal_6
          :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_6
    ))))))
    :pattern ((ext_eq false (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_7
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_7
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
          :qid user_vstd__seq__axiom_seq_ext_equal_deep_8
          :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_8
    ))))))
    :pattern ((ext_eq true (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_deep_9
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_9
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
    :qid user_vstd__slice__axiom_spec_len_10
    :skolemid skolem_user_vstd__slice__axiom_spec_len_10
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
          :qid user_vstd__slice__axiom_slice_ext_equal_11
          :skolemid skolem_user_vstd__slice__axiom_slice_ext_equal_11
    ))))))
    :pattern ((ext_eq false (SLICE T&. T&) a1! a2!))
    :qid user_vstd__slice__axiom_slice_ext_equal_12
    :skolemid skolem_user_vstd__slice__axiom_slice_ext_equal_12
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
    :qid user_vstd__slice__axiom_slice_has_resolved_13
    :skolemid skolem_user_vstd__slice__axiom_slice_has_resolved_13
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
    :qid user_vstd__array__array_len_matches_n_14
    :skolemid skolem_user_vstd__array__array_len_matches_n_14
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
    :qid user_vstd__array__lemma_array_index_15
    :skolemid skolem_user_vstd__array__lemma_array_index_15
))))

;; Function-Axioms vstd::array::spec_array_as_slice
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (ar! Poly)) (!
   (=>
    (has_type ar! (ARRAY T&. T& N&. N&))
    (has_type (vstd!array.spec_array_as_slice.? T&. T& N&. N& ar!) (SLICE T&. T&))
   )
   :pattern ((vstd!array.spec_array_as_slice.? T&. T& N&. N& ar!))
   :qid internal_vstd!array.spec_array_as_slice.?_pre_post_definition
   :skolemid skolem_internal_vstd!array.spec_array_as_slice.?_pre_post_definition
)))

;; Broadcast vstd::array::axiom_spec_array_as_slice
(assert
 (=>
  (fuel_bool fuel%vstd!array.axiom_spec_array_as_slice.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (ar! Poly)) (!
    (=>
     (has_type ar! (ARRAY T&. T& N&. N&))
     (=>
      (and
       (sized T&.)
       (uInv SZ (const_int N&))
      )
      (= (vstd!view.View.view.? $slice (SLICE T&. T&) (vstd!array.spec_array_as_slice.? T&.
         T& N&. N& ar!
        )
       ) (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) ar!)
    )))
    :pattern ((vstd!array.spec_array_as_slice.? T&. T& N&. N& ar!))
    :qid user_vstd__array__axiom_spec_array_as_slice_16
    :skolemid skolem_user_vstd__array__axiom_spec_array_as_slice_16
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
         :qid user_vstd__array__axiom_array_ext_equal_17
         :skolemid skolem_user_vstd__array__axiom_array_ext_equal_17
    )))))
    :pattern ((ext_eq false (ARRAY T&. T& N&. N&) a1! a2!))
    :qid user_vstd__array__axiom_array_ext_equal_18
    :skolemid skolem_user_vstd__array__axiom_array_ext_equal_18
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
    :qid user_vstd__array__axiom_array_has_resolved_19
    :skolemid skolem_user_vstd__array__axiom_array_has_resolved_19
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
    :qid user_vstd__raw_ptr__ptrs_mut_eq_20
    :skolemid skolem_user_vstd__raw_ptr__ptrs_mut_eq_20
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
    :qid user_vstd__raw_ptr__ptrs_mut_eq_sized_21
    :skolemid skolem_user_vstd__raw_ptr__ptrs_mut_eq_sized_21
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

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_self_0
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_self_0. (Int) Bool)
(declare-const %%global_location_label%%7 Bool)
(assert
 (forall ((m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_self_0. m!) (=>
     %%global_location_label%%7
     (> m! 0)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mod_self_0. m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mod_self_0._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mod_self_0._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mod_self_0. (Int) Bool)
(assert
 (forall ((m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mod_self_0. m!) (= (EucMod m! m!) 0))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mod_self_0. m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mod_self_0._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mod_self_0._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mod_self_0
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mod_self_0.)
  (forall ((m! Int)) (!
    (=>
     (> m! 0)
     (= (EucMod m! m!) 0)
    )
    :pattern ((EucMod m! m!))
    :qid user_vstd__arithmetic__div_mod__lemma_mod_self_0_22
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_self_0_22
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_multiples_basic
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_multiples_basic. (Int Int) Bool)
(declare-const %%global_location_label%%8 Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_multiples_basic. x! m!) (=>
     %%global_location_label%%8
     (> m! 0)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mod_multiples_basic. x! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mod_multiples_basic._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mod_multiples_basic._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mod_multiples_basic. (Int Int) Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mod_multiples_basic. x! m!) (= (EucMod (Mul x!
       m!
      ) m!
     ) 0
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mod_multiples_basic. x! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mod_multiples_basic._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mod_multiples_basic._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mod_multiples_basic
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mod_multiples_basic.)
  (forall ((x! Int) (m! Int)) (!
    (=>
     (> m! 0)
     (= (EucMod (Mul x! m!) m!) 0)
    )
    :pattern ((EucMod (Mul x! m!) m!))
    :qid user_vstd__arithmetic__div_mod__lemma_mod_multiples_basic_23
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_multiples_basic_23
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_add_multiples_vanish
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish. (Int Int)
 Bool
)
(declare-const %%global_location_label%%9 Bool)
(assert
 (forall ((b! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish. b! m!) (=>
     %%global_location_label%%9
     (< 0 m!)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish. b! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish. (Int Int)
 Bool
)
(assert
 (forall ((b! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish. b! m!) (= (EucMod (Add
       m! b!
      ) m!
     ) (EucMod b! m!)
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish. b! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mod_add_multiples_vanish
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish.)
  (forall ((b! Int) (m! Int)) (!
    (=>
     (< 0 m!)
     (= (EucMod (Add m! b!) m!) (EucMod b! m!))
    )
    :pattern ((EucMod b! m!))
    :qid user_vstd__arithmetic__div_mod__lemma_mod_add_multiples_vanish_24
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_add_multiples_vanish_24
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_bound
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_bound. (Int Int) Bool)
(declare-const %%global_location_label%%10 Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_bound. x! m!) (=>
     %%global_location_label%%10
     (< 0 m!)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mod_bound. x! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mod_bound._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mod_bound._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mod_bound. (Int Int) Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mod_bound. x! m!) (let
     ((tmp%%$ (EucMod x! m!)))
     (and
      (<= 0 tmp%%$)
      (< tmp%%$ m!)
   )))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mod_bound. x! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mod_bound._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mod_bound._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mod_bound
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mod_bound.)
  (forall ((x! Int) (m! Int)) (!
    (=>
     (< 0 m!)
     (let
      ((tmp%%$ (EucMod x! m!)))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ m!)
    )))
    :pattern ((EucMod x! m!))
    :qid user_vstd__arithmetic__div_mod__lemma_mod_bound_25
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_bound_25
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

;; Function-Specs vstd::arithmetic::power2::lemma_pow2_adds
(declare-fun ens%vstd!arithmetic.power2.lemma_pow2_adds. (Int Int) Bool)
(assert
 (forall ((e1! Int) (e2! Int)) (!
   (= (ens%vstd!arithmetic.power2.lemma_pow2_adds. e1! e2!) (= (vstd!arithmetic.power2.pow2.?
      (I (nClip (Add e1! e2!)))
     ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I e1!)) (vstd!arithmetic.power2.pow2.?
        (I e2!)
   )))))
   :pattern ((ens%vstd!arithmetic.power2.lemma_pow2_adds. e1! e2!))
   :qid internal_ens__vstd!arithmetic.power2.lemma_pow2_adds._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.power2.lemma_pow2_adds._definition
)))

;; Broadcast vstd::arithmetic::power2::lemma_pow2_adds
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.power2.lemma_pow2_adds.)
  (forall ((e1! Int) (e2! Int)) (!
    (=>
     (and
      (<= 0 e1!)
      (<= 0 e2!)
     )
     (= (vstd!arithmetic.power2.pow2.? (I (nClip (Add e1! e2!)))) (nClip (Mul (vstd!arithmetic.power2.pow2.?
         (I e1!)
        ) (vstd!arithmetic.power2.pow2.? (I e2!))
    ))))
    :pattern ((vstd!arithmetic.power2.pow2.? (I (nClip (Add e1! e2!)))))
    :qid user_vstd__arithmetic__power2__lemma_pow2_adds_26
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_adds_26
))))

;; Function-Specs vstd::arithmetic::power2::lemma_pow2_strictly_increases
(declare-fun req%vstd!arithmetic.power2.lemma_pow2_strictly_increases. (Int Int) Bool)
(declare-const %%global_location_label%%11 Bool)
(assert
 (forall ((e1! Int) (e2! Int)) (!
   (= (req%vstd!arithmetic.power2.lemma_pow2_strictly_increases. e1! e2!) (=>
     %%global_location_label%%11
     (< e1! e2!)
   ))
   :pattern ((req%vstd!arithmetic.power2.lemma_pow2_strictly_increases. e1! e2!))
   :qid internal_req__vstd!arithmetic.power2.lemma_pow2_strictly_increases._definition
   :skolemid skolem_internal_req__vstd!arithmetic.power2.lemma_pow2_strictly_increases._definition
)))
(declare-fun ens%vstd!arithmetic.power2.lemma_pow2_strictly_increases. (Int Int) Bool)
(assert
 (forall ((e1! Int) (e2! Int)) (!
   (= (ens%vstd!arithmetic.power2.lemma_pow2_strictly_increases. e1! e2!) (< (vstd!arithmetic.power2.pow2.?
      (I e1!)
     ) (vstd!arithmetic.power2.pow2.? (I e2!))
   ))
   :pattern ((ens%vstd!arithmetic.power2.lemma_pow2_strictly_increases. e1! e2!))
   :qid internal_ens__vstd!arithmetic.power2.lemma_pow2_strictly_increases._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.power2.lemma_pow2_strictly_increases._definition
)))

;; Broadcast vstd::arithmetic::power2::lemma_pow2_strictly_increases
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.power2.lemma_pow2_strictly_increases.)
  (forall ((e1! Poly) (e2! Poly)) (!
    (=>
     (and
      (has_type e1! NAT)
      (has_type e2! NAT)
     )
     (=>
      (< (%I e1!) (%I e2!))
      (< (vstd!arithmetic.power2.pow2.? e1!) (vstd!arithmetic.power2.pow2.? e2!))
    ))
    :pattern ((vstd!arithmetic.power2.pow2.? e1!) (vstd!arithmetic.power2.pow2.? e2!))
    :qid user_vstd__arithmetic__power2__lemma_pow2_strictly_increases_27
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_strictly_increases_27
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

;; Function-Axioms vstd::std_specs::option::OptionAdditionalFns::is_Some
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly)) (!
   (=>
    (has_type self! Self%&)
    (has_type (vstd!std_specs.option.OptionAdditionalFns.is_Some.? Self%&. Self%& T&. T&
      self!
     ) BOOL
   ))
   :pattern ((vstd!std_specs.option.OptionAdditionalFns.is_Some.? Self%&. Self%& T&. T&
     self!
   ))
   :qid internal_vstd!std_specs.option.OptionAdditionalFns.is_Some.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.option.OptionAdditionalFns.is_Some.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::option::OptionAdditionalFns::arrow_0
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly)) (!
   (=>
    (has_type self! Self%&)
    (has_type (vstd!std_specs.option.OptionAdditionalFns.arrow_0.? Self%&. Self%& T&. T&
      self!
     ) T&
   ))
   :pattern ((vstd!std_specs.option.OptionAdditionalFns.arrow_0.? Self%&. Self%& T&. T&
     self!
   ))
   :qid internal_vstd!std_specs.option.OptionAdditionalFns.arrow_0.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.option.OptionAdditionalFns.arrow_0.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::option::impl&%0::arrow_0
(assert
 (fuel_bool_default fuel%vstd!std_specs.option.impl&%0.arrow_0.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.option.impl&%0.arrow_0.)
  (forall ((T&. Dcr) (T& Type) (self! Poly)) (!
    (=>
     (sized T&.)
     (= (vstd!std_specs.option.OptionAdditionalFns.arrow_0.? $ (TYPE%core!option.Option.
        T&. T&
       ) T&. T& self!
      ) (core!option.Option./Some/0 T&. T& (%Poly%core!option.Option. self!))
    ))
    :pattern ((vstd!std_specs.option.OptionAdditionalFns.arrow_0.? $ (TYPE%core!option.Option.
       T&. T&
      ) T&. T& self!
    ))
    :qid internal_vstd!std_specs.option.OptionAdditionalFns.arrow_0.?_definition
    :skolemid skolem_internal_vstd!std_specs.option.OptionAdditionalFns.arrow_0.?_definition
))))

;; Function-Axioms vstd::std_specs::option::impl&%0::is_Some
(assert
 (fuel_bool_default fuel%vstd!std_specs.option.impl&%0.is_Some.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.option.impl&%0.is_Some.)
  (forall ((T&. Dcr) (T& Type) (self! Poly)) (!
    (=>
     (sized T&.)
     (= (vstd!std_specs.option.OptionAdditionalFns.is_Some.? $ (TYPE%core!option.Option.
        T&. T&
       ) T&. T& self!
      ) (B (is-core!option.Option./Some (%Poly%core!option.Option. self!)))
    ))
    :pattern ((vstd!std_specs.option.OptionAdditionalFns.is_Some.? $ (TYPE%core!option.Option.
       T&. T&
      ) T&. T& self!
    ))
    :qid internal_vstd!std_specs.option.OptionAdditionalFns.is_Some.?_definition
    :skolemid skolem_internal_vstd!std_specs.option.OptionAdditionalFns.is_Some.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%vstd!std_specs.option.OptionAdditionalFns. $ (TYPE%core!option.Option. T&.
      T&
     ) T&. T&
   ))
   :pattern ((tr_bound%vstd!std_specs.option.OptionAdditionalFns. $ (TYPE%core!option.Option.
      T&. T&
     ) T&. T&
   ))
   :qid internal_vstd__std_specs__option__impl&__0_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__option__impl&__0_trait_impl_definition
)))

;; Function-Specs vstd::std_specs::option::spec_unwrap
(declare-fun req%vstd!std_specs.option.spec_unwrap. (Dcr Type Poly) Bool)
(declare-const %%global_location_label%%12 Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (option! Poly)) (!
   (= (req%vstd!std_specs.option.spec_unwrap. T&. T& option!) (=>
     %%global_location_label%%12
     (is-core!option.Option./Some (%Poly%core!option.Option. option!))
   ))
   :pattern ((req%vstd!std_specs.option.spec_unwrap. T&. T& option!))
   :qid internal_req__vstd!std_specs.option.spec_unwrap._definition
   :skolemid skolem_internal_req__vstd!std_specs.option.spec_unwrap._definition
)))

;; Function-Axioms vstd::std_specs::option::spec_unwrap
(assert
 (fuel_bool_default fuel%vstd!std_specs.option.spec_unwrap.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.option.spec_unwrap.)
  (forall ((T&. Dcr) (T& Type) (option! Poly)) (!
    (= (vstd!std_specs.option.spec_unwrap.? T&. T& option!) (core!option.Option./Some/0
      T&. T& (%Poly%core!option.Option. option!)
    ))
    :pattern ((vstd!std_specs.option.spec_unwrap.? T&. T& option!))
    :qid internal_vstd!std_specs.option.spec_unwrap.?_definition
    :skolemid skolem_internal_vstd!std_specs.option.spec_unwrap.?_definition
))))
(assert
 (forall ((T&. Dcr) (T& Type) (option! Poly)) (!
   (=>
    (has_type option! (TYPE%core!option.Option. T&. T&))
    (has_type (vstd!std_specs.option.spec_unwrap.? T&. T& option!) T&)
   )
   :pattern ((vstd!std_specs.option.spec_unwrap.? T&. T& option!))
   :qid internal_vstd!std_specs.option.spec_unwrap.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.option.spec_unwrap.?_pre_post_definition
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
(declare-const %%global_location_label%%13 Bool)
(declare-const %%global_location_label%%14 Bool)
(assert
 (forall ((a! Poly) (m! Poly)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.
     a! m!
    ) (and
     (=>
      %%global_location_label%%13
      (> (%I m!) 1)
     )
     (=>
      %%global_location_label%%14
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

;; Function-Axioms curve25519_dalek::backend::serial::u64::constants::spec_eight_torsion
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (has_type (Poly%array%. (curve25519_dalek!backend.serial.u64.constants.spec_eight_torsion.?
       no%param
      )
     ) (ARRAY $ TYPE%curve25519_dalek!edwards.EdwardsPoint. $ (CONST_INT 8))
   ))
   :pattern ((curve25519_dalek!backend.serial.u64.constants.spec_eight_torsion.? no%param))
   :qid internal_curve25519_dalek!backend.serial.u64.constants.spec_eight_torsion.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.u64.constants.spec_eight_torsion.?_pre_post_definition
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
       :qid user_curve25519_dalek__specs__field_specs__u64_5_bounded_28
       :skolemid skolem_user_curve25519_dalek__specs__field_specs__u64_5_bounded_28
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

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::mask51
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.mask51.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.mask51.)
  (= curve25519_dalek!specs.field_specs_u64.mask51.? 2251799813685247)
))
(assert
 (uInv 64 curve25519_dalek!specs.field_specs_u64.mask51.?)
)

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

;; Function-Axioms curve25519_dalek::specs::field_specs::sum_of_limbs_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.)
  (forall ((fe1! Poly) (fe2! Poly) (bound! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? fe1! fe2! bound!) (forall
      ((i$ Poly)) (!
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 5)
         ))
         (< (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
               $ (CONST_INT 5)
              ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe1!)
              ))
             ) i$
            )
           ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe2!)
              ))
             ) i$
           ))
          ) (%I bound!)
       )))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe1!)
          ))
         ) i$
       ))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe2!)
          ))
         ) i$
       ))
       :qid user_curve25519_dalek__specs__field_specs__sum_of_limbs_bounded_29
       :skolemid skolem_user_curve25519_dalek__specs__field_specs__sum_of_limbs_bounded_29
    )))
    :pattern ((curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? fe1! fe2! bound!))
    :qid internal_curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_well_formed_edwards_point
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? point!) (and
      (and
       (curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? point!)
       (curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.? point!)
      )
      (curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!specs.edwards_specs.edwards_y.? point!)
       ) (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.edwards_specs.edwards_x.?
         point!
        )
       ) (I 18446744073709551615)
    )))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.?_definition
))))

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

;; Function-Specs curve25519_dalek::specs::core_specs::bytes_as_nat_prefix
(declare-fun req%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix. (Poly Poly)
 Bool
)
(declare-const %%global_location_label%%15 Bool)
(assert
 (forall ((bytes! Poly) (j! Poly)) (!
   (= (req%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix. bytes! j!) (=>
     %%global_location_label%%15
     (<= (%I j!) (vstd!seq.Seq.len.? $ (UINT 8) bytes!))
   ))
   :pattern ((req%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix. bytes! j!))
   :qid internal_req__curve25519_dalek!specs.core_specs.bytes_as_nat_prefix._definition
   :skolemid skolem_internal_req__curve25519_dalek!specs.core_specs.bytes_as_nat_prefix._definition
)))

;; Function-Axioms curve25519_dalek::specs::core_specs::bytes_as_nat_prefix
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.)
)
(declare-const fuel_nat%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix. Fuel)
(assert
 (forall ((bytes! Poly) (j! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!specs.core_specs.rec%bytes_as_nat_prefix.? bytes! j! fuel%) (
     curve25519_dalek!specs.core_specs.rec%bytes_as_nat_prefix.? bytes! j! zero
   ))
   :pattern ((curve25519_dalek!specs.core_specs.rec%bytes_as_nat_prefix.? bytes! j! fuel%))
   :qid internal_curve25519_dalek!specs.core_specs.bytes_as_nat_prefix._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.bytes_as_nat_prefix._fuel_to_zero_definition
)))
(assert
 (forall ((bytes! Poly) (j! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
     (has_type j! NAT)
    )
    (= (curve25519_dalek!specs.core_specs.rec%bytes_as_nat_prefix.? bytes! j! (succ fuel%))
     (ite
      (= (%I j!) 0)
      0
      (let
       ((j1$ (nClip (Sub (%I j!) 1))))
       (nClip (Add (curve25519_dalek!specs.core_specs.rec%bytes_as_nat_prefix.? bytes! (I j1$)
          fuel%
         ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I (nClip (Mul j1$ 8)))) (%I (vstd!seq.Seq.index.?
             $ (UINT 8) bytes! (I j1$)
   ))))))))))
   :pattern ((curve25519_dalek!specs.core_specs.rec%bytes_as_nat_prefix.? bytes! j! (succ
      fuel%
   )))
   :qid internal_curve25519_dalek!specs.core_specs.bytes_as_nat_prefix._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.bytes_as_nat_prefix._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.)
  (forall ((bytes! Poly) (j! Poly)) (!
    (=>
     (and
      (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
      (has_type j! NAT)
     )
     (= (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? bytes! j!) (curve25519_dalek!specs.core_specs.rec%bytes_as_nat_prefix.?
       bytes! j! (succ fuel_nat%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.)
    )))
    :pattern ((curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? bytes! j!))
    :qid internal_curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.?_definition
))))
(assert
 (forall ((bytes! Poly) (j! Poly)) (!
   (=>
    (and
     (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
     (has_type j! NAT)
    )
    (<= 0 (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? bytes! j!))
   )
   :pattern ((curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? bytes! j!))
   :qid internal_curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.?_pre_post_definition
)))
(assert
 (forall ((bytes! Poly) (j! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
     (has_type j! NAT)
    )
    (<= 0 (curve25519_dalek!specs.core_specs.rec%bytes_as_nat_prefix.? bytes! j! fuel%))
   )
   :pattern ((curve25519_dalek!specs.core_specs.rec%bytes_as_nat_prefix.? bytes! j! fuel%))
   :qid internal_curve25519_dalek!specs.core_specs.rec__bytes_as_nat_prefix.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.rec__bytes_as_nat_prefix.?_pre_post_rec_definition
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

;; Function-Axioms vstd::view::impl&%10::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%10.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%10.view.)
  (forall ((T&. Dcr) (T& Type) (self! Poly)) (!
    (=>
     (sized T&.)
     (= (vstd!view.View.view.? $ (TYPE%core!option.Option. T&. T&) self!) self!)
    )
    :pattern ((vstd!view.View.view.? $ (TYPE%core!option.Option. T&. T&) self!))
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

;; Function-Axioms vstd::view::impl&%46::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%46.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%46.view.)
  (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type) (self! Poly))
   (!
    (=>
     (and
      (sized A0&.)
      (sized A1&.)
      (sized A2&.)
      (tr_bound%vstd!view.View. A0&. A0&)
      (tr_bound%vstd!view.View. A1&. A1&)
      (tr_bound%vstd!view.View. A2&. A2&)
     )
     (= (vstd!view.View.view.? (DST A2&.) (TYPE%tuple%3. A0&. A0& A1&. A1& A2&. A2&) self!)
      (Poly%tuple%3. (tuple%3./tuple%3 (vstd!view.View.view.? A0&. A0& (tuple%3./tuple%3/0
          (%Poly%tuple%3. self!)
         )
        ) (vstd!view.View.view.? A1&. A1& (tuple%3./tuple%3/1 (%Poly%tuple%3. self!))) (vstd!view.View.view.?
         A2&. A2& (tuple%3./tuple%3/2 (%Poly%tuple%3. self!))
    )))))
    :pattern ((vstd!view.View.view.? (DST A2&.) (TYPE%tuple%3. A0&. A0& A1&. A1& A2&. A2&)
      self!
    ))
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

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%16::ZERO
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%16.ZERO.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%16.ZERO.)
  (= curve25519_dalek!backend.serial.u64.field.impl&%16.ZERO.? (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
    (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I 0) (I 0) (I 0) (I 0) (I 0))))
))))
(assert
 (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.field.impl&%16.ZERO.?)
  TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Function-Axioms curve25519_dalek::backend::serial::u64::constants::SQRT_AD_MINUS_ONE
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.constants.SQRT_AD_MINUS_ONE.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.constants.SQRT_AD_MINUS_ONE.)
  (= curve25519_dalek!backend.serial.u64.constants.SQRT_AD_MINUS_ONE.? (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
    (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I 2241493124984347) (I 425987919032274)
       (I 2207028919301688) (I 1220490630685848) (I 974799131293748)
)))))))
(assert
 (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.constants.SQRT_AD_MINUS_ONE.?)
  TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Function-Axioms curve25519_dalek::backend::serial::u64::constants::SQRT_M1
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.constants.SQRT_M1.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.constants.SQRT_M1.)
  (= curve25519_dalek!backend.serial.u64.constants.SQRT_M1.? (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
    (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I 1718705420411056) (I 234908883556509)
       (I 2233514472574048) (I 2117202627021982) (I 765476049583133)
)))))))
(assert
 (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.constants.SQRT_M1.?)
  TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Function-Axioms curve25519_dalek::lizard::u64_constants::SQRT_ID
(assert
 (fuel_bool_default fuel%curve25519_dalek!lizard.u64_constants.SQRT_ID.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lizard.u64_constants.SQRT_ID.)
  (= curve25519_dalek!lizard.u64_constants.SQRT_ID.? (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
    (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I 2298852427963285) (I 3837146560810661)
       (I 4413131899466403) (I 3883177008057528) (I 2352084440532925)
)))))))
(assert
 (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!lizard.u64_constants.SQRT_ID.?)
  TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Function-Axioms curve25519_dalek::lizard::u64_constants::DP1_OVER_DM1
(assert
 (fuel_bool_default fuel%curve25519_dalek!lizard.u64_constants.DP1_OVER_DM1.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lizard.u64_constants.DP1_OVER_DM1.)
  (= curve25519_dalek!lizard.u64_constants.DP1_OVER_DM1.? (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
    (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I 2159851467815724) (I 1752228607624431)
       (I 1825604053920671) (I 1212587319275468) (I 253422448836237)
)))))))
(assert
 (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!lizard.u64_constants.DP1_OVER_DM1.?)
  TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Function-Axioms curve25519_dalek::lizard::u64_constants::MDOUBLE_INVSQRT_A_MINUS_D
(assert
 (fuel_bool_default fuel%curve25519_dalek!lizard.u64_constants.MDOUBLE_INVSQRT_A_MINUS_D.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lizard.u64_constants.MDOUBLE_INVSQRT_A_MINUS_D.)
  (= curve25519_dalek!lizard.u64_constants.MDOUBLE_INVSQRT_A_MINUS_D.? (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
    (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I 1693982333959686) (I 608509411481997)
       (I 2235573344831311) (I 947681270984193) (I 266558006233600)
)))))))
(assert
 (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!lizard.u64_constants.MDOUBLE_INVSQRT_A_MINUS_D.?)
  TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Function-Axioms curve25519_dalek::lizard::u64_constants::MIDOUBLE_INVSQRT_A_MINUS_D
(assert
 (fuel_bool_default fuel%curve25519_dalek!lizard.u64_constants.MIDOUBLE_INVSQRT_A_MINUS_D.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lizard.u64_constants.MIDOUBLE_INVSQRT_A_MINUS_D.)
  (= curve25519_dalek!lizard.u64_constants.MIDOUBLE_INVSQRT_A_MINUS_D.? (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
    (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I 1608655899704280) (I 1999971613377227)
       (I 49908634785720) (I 1873700692181652) (I 353702208628067)
)))))))
(assert
 (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!lizard.u64_constants.MIDOUBLE_INVSQRT_A_MINUS_D.?)
  TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Function-Axioms curve25519_dalek::lizard::u64_constants::MINVSQRT_ONE_PLUS_D
(assert
 (fuel_bool_default fuel%curve25519_dalek!lizard.u64_constants.MINVSQRT_ONE_PLUS_D.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lizard.u64_constants.MINVSQRT_ONE_PLUS_D.)
  (= curve25519_dalek!lizard.u64_constants.MINVSQRT_ONE_PLUS_D.? (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
    (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I 321571956990465) (I 1251814006996634)
       (I 2226845496292387) (I 189049560751797) (I 2074948709371214)
)))))))
(assert
 (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!lizard.u64_constants.MINVSQRT_ONE_PLUS_D.?)
  TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Function-Axioms curve25519_dalek::specs::field_specs::sqrt_m1
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.sqrt_m1.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.sqrt_m1.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!specs.field_specs.sqrt_m1.? no%param) (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
      (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.constants.SQRT_M1.?)
    ))
    :pattern ((curve25519_dalek!specs.field_specs.sqrt_m1.? no%param))
    :qid internal_curve25519_dalek!specs.field_specs.sqrt_m1.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.sqrt_m1.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (<= 0 (curve25519_dalek!specs.field_specs.sqrt_m1.? no%param))
   )
   :pattern ((curve25519_dalek!specs.field_specs.sqrt_m1.? no%param))
   :qid internal_curve25519_dalek!specs.field_specs.sqrt_m1.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.sqrt_m1.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::is_negative
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.is_negative.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.is_negative.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.is_negative.? a!) (= (EucMod (curve25519_dalek!specs.field_specs_u64.field_canonical.?
        a!
       ) 2
      ) 1
    ))
    :pattern ((curve25519_dalek!specs.field_specs.is_negative.? a!))
    :qid internal_curve25519_dalek!specs.field_specs.is_negative.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.is_negative.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs::nat_invsqrt
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.nat_invsqrt.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.nat_invsqrt.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.nat_invsqrt.? a!) (ite
      (= (EucMod (%I a!) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0)
      0
      (let
       ((a3$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_square.?
            a!
           )
          ) a!
       )))
       (let
        ((a7$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_square.?
             (I a3$)
            )
           ) a!
        )))
        (let
         ((k$ (nClip (EucDiv (Sub (curve25519_dalek!specs.field_specs_u64.p.? (I 0)) 5) 8))))
         (let
          ((r_raw$ (curve25519_dalek!specs.field_specs.field_mul.? (I a3$) (I (EucMod (nClip (vstd!arithmetic.power.pow.?
                 (I a7$) (I k$)
                )
               ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
          )))))
          (let
           ((check$ (curve25519_dalek!specs.field_specs.field_mul.? a! (I (curve25519_dalek!specs.field_specs.field_square.?
                (I r_raw$)
           )))))
           (let
            ((neg_one$ (curve25519_dalek!specs.field_specs.field_neg.? (I 1))))
            (let
             ((neg_i$ (curve25519_dalek!specs.field_specs.field_neg.? (I (curve25519_dalek!specs.field_specs.sqrt_m1.?
                  (I 0)
             )))))
             (let
              ((r_adj$ (ite
                 (or
                  (= check$ neg_one$)
                  (= check$ neg_i$)
                 )
                 (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.sqrt_m1.?
                    (I 0)
                   )
                  ) (I r_raw$)
                 )
                 r_raw$
              )))
              (ite
               (curve25519_dalek!specs.field_specs.is_negative.? (I r_adj$))
               (curve25519_dalek!specs.field_specs.field_neg.? (I r_adj$))
               r_adj$
    )))))))))))
    :pattern ((curve25519_dalek!specs.field_specs.nat_invsqrt.? a!))
    :qid internal_curve25519_dalek!specs.field_specs.nat_invsqrt.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.nat_invsqrt.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! NAT)
    (<= 0 (curve25519_dalek!specs.field_specs.nat_invsqrt.? a!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.nat_invsqrt.? a!))
   :qid internal_curve25519_dalek!specs.field_specs.nat_invsqrt.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.nat_invsqrt.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::field_abs
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_abs.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_abs.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_abs.? a!) (ite
      (curve25519_dalek!specs.field_specs.is_negative.? a!)
      (curve25519_dalek!specs.field_specs.field_neg.? a!)
      (%I a!)
    ))
    :pattern ((curve25519_dalek!specs.field_specs.field_abs.? a!))
    :qid internal_curve25519_dalek!specs.field_specs.field_abs.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_abs.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! NAT)
    (<= 0 (curve25519_dalek!specs.field_specs.field_abs.? a!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_abs.? a!))
   :qid internal_curve25519_dalek!specs.field_specs.field_abs.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_abs.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::is_sqrt_ratio
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.is_sqrt_ratio.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.is_sqrt_ratio.)
  (forall ((u! Poly) (v! Poly) (r! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.is_sqrt_ratio.? u! v! r!) (= (curve25519_dalek!specs.field_specs_u64.field_canonical.?
       (I (nClip (Mul (nClip (Mul (%I r!) (%I r!))) (%I v!))))
      ) (curve25519_dalek!specs.field_specs_u64.field_canonical.? u!)
    ))
    :pattern ((curve25519_dalek!specs.field_specs.is_sqrt_ratio.? u! v! r!))
    :qid internal_curve25519_dalek!specs.field_specs.is_sqrt_ratio.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.is_sqrt_ratio.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::ristretto_specs::elligator_intermediates
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.ristretto_specs.elligator_intermediates.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.ristretto_specs.elligator_intermediates.)
  (forall ((r_0! Poly)) (!
    (= (curve25519_dalek!specs.ristretto_specs.elligator_intermediates.? r_0!) (let
      ((i$ (curve25519_dalek!specs.field_specs.sqrt_m1.? (I 0))))
      (let
       ((d$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?
       ))))
       (let
        ((one_minus_d_sq$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_sub.?
             (I 1) (I d$)
            )
           ) (I (curve25519_dalek!specs.field_specs.field_add.? (I 1) (I d$)))
        )))
        (let
         ((d_minus_one_sq$ (curve25519_dalek!specs.field_specs.field_square.? (I (curve25519_dalek!specs.field_specs.field_sub.?
              (I d$) (I 1)
         )))))
         (let
          ((c_init$ (curve25519_dalek!specs.field_specs.field_neg.? (I 1))))
          (let
           ((r$ (curve25519_dalek!specs.field_specs.field_mul.? (I i$) (I (curve25519_dalek!specs.field_specs.field_square.?
                r_0!
           )))))
           (let
            ((n_s$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_add.?
                 (I r$) (I 1)
                )
               ) (I one_minus_d_sq$)
            )))
            (let
             ((d_val$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_sub.?
                  (I c_init$) (I (curve25519_dalek!specs.field_specs.field_mul.? (I d$) (I r$)))
                 )
                ) (I (curve25519_dalek!specs.field_specs.field_add.? (I r$) (I d$)))
             )))
             (let
              ((invsqrt_val$ (curve25519_dalek!specs.field_specs.nat_invsqrt.? (I (curve25519_dalek!specs.field_specs.field_mul.?
                   (I n_s$) (I d_val$)
              )))))
              (let
               ((s_if_square$ (curve25519_dalek!specs.field_specs.field_abs.? (I (curve25519_dalek!specs.field_specs.field_mul.?
                    (I invsqrt_val$) (I n_s$)
               )))))
               (let
                ((was_square$ (curve25519_dalek!specs.field_specs.is_sqrt_ratio.? (I n_s$) (I d_val$)
                   (I s_if_square$)
                )))
                (let
                 ((s_prime_raw$ (curve25519_dalek!specs.field_specs.field_mul.? (I s_if_square$) r_0!)))
                 (let
                  ((s_prime$ (ite
                     (not (curve25519_dalek!specs.field_specs.is_negative.? (I s_prime_raw$)))
                     (curve25519_dalek!specs.field_specs.field_neg.? (I s_prime_raw$))
                     s_prime_raw$
                  )))
                  (let
                   ((s$ (ite
                      was_square$
                      s_if_square$
                      s_prime$
                   )))
                   (let
                    ((c$ (ite
                       was_square$
                       c_init$
                       r$
                    )))
                    (let
                     ((n_t$ (curve25519_dalek!specs.field_specs.field_sub.? (I (curve25519_dalek!specs.field_specs.field_mul.?
                          (I (curve25519_dalek!specs.field_specs.field_mul.? (I c$) (I (curve25519_dalek!specs.field_specs.field_sub.?
                              (I r$) (I 1)
                           )))
                          ) (I d_minus_one_sq$)
                         )
                        ) (I d_val$)
                     )))
                     (tuple%3./tuple%3 (I s$) (I n_t$) (I d_val$))
    )))))))))))))))))
    :pattern ((curve25519_dalek!specs.ristretto_specs.elligator_intermediates.? r_0!))
    :qid internal_curve25519_dalek!specs.ristretto_specs.elligator_intermediates.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.ristretto_specs.elligator_intermediates.?_definition
))))
(assert
 (forall ((r_0! Poly)) (!
   (=>
    (has_type r_0! NAT)
    (has_type (Poly%tuple%3. (curve25519_dalek!specs.ristretto_specs.elligator_intermediates.?
       r_0!
      )
     ) (TYPE%tuple%3. $ NAT $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.ristretto_specs.elligator_intermediates.? r_0!))
   :qid internal_curve25519_dalek!specs.ristretto_specs.elligator_intermediates.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.ristretto_specs.elligator_intermediates.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::ristretto_specs::spec_sqrt_ad_minus_one
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.ristretto_specs.spec_sqrt_ad_minus_one.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.ristretto_specs.spec_sqrt_ad_minus_one.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!specs.ristretto_specs.spec_sqrt_ad_minus_one.? no%param) (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
      (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.constants.SQRT_AD_MINUS_ONE.?)
    ))
    :pattern ((curve25519_dalek!specs.ristretto_specs.spec_sqrt_ad_minus_one.? no%param))
    :qid internal_curve25519_dalek!specs.ristretto_specs.spec_sqrt_ad_minus_one.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.ristretto_specs.spec_sqrt_ad_minus_one.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (<= 0 (curve25519_dalek!specs.ristretto_specs.spec_sqrt_ad_minus_one.? no%param))
   )
   :pattern ((curve25519_dalek!specs.ristretto_specs.spec_sqrt_ad_minus_one.? no%param))
   :qid internal_curve25519_dalek!specs.ristretto_specs.spec_sqrt_ad_minus_one.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.ristretto_specs.spec_sqrt_ad_minus_one.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::ristretto_specs::spec_elligator_ristretto_flavor
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.ristretto_specs.spec_elligator_ristretto_flavor.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.ristretto_specs.spec_elligator_ristretto_flavor.)
  (forall ((r_0! Poly)) (!
    (= (curve25519_dalek!specs.ristretto_specs.spec_elligator_ristretto_flavor.? r_0!)
     (let
      ((tmp%%$ (curve25519_dalek!specs.ristretto_specs.elligator_intermediates.? r_0!)))
      (let
       ((s$ (%I (tuple%3./tuple%3/0 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
       (let
        ((n_t$ (%I (tuple%3./tuple%3/1 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
        (let
         ((d_val$ (%I (tuple%3./tuple%3/2 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
         (let
          ((s_sq$ (curve25519_dalek!specs.field_specs.field_square.? (I s$))))
          (let
           ((sqrt_ad_minus_one$ (curve25519_dalek!specs.ristretto_specs.spec_sqrt_ad_minus_one.?
              (I 0)
           )))
           (let
            ((x_completed$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_mul.?
                 (I 2) (I s$)
                )
               ) (I d_val$)
            )))
            (let
             ((z_completed$ (curve25519_dalek!specs.field_specs.field_mul.? (I n_t$) (I sqrt_ad_minus_one$))))
             (let
              ((y_completed$ (curve25519_dalek!specs.field_specs.field_sub.? (I 1) (I s_sq$))))
              (let
               ((t_completed$ (curve25519_dalek!specs.field_specs.field_add.? (I 1) (I s_sq$))))
               (let
                ((x_affine$ (curve25519_dalek!specs.field_specs.field_mul.? (I x_completed$) (I (curve25519_dalek!specs.field_specs.field_inv.?
                     (I z_completed$)
                )))))
                (let
                 ((y_affine$ (curve25519_dalek!specs.field_specs.field_mul.? (I y_completed$) (I (curve25519_dalek!specs.field_specs.field_inv.?
                      (I t_completed$)
                 )))))
                 (tuple%2./tuple%2 (I x_affine$) (I y_affine$))
    )))))))))))))
    :pattern ((curve25519_dalek!specs.ristretto_specs.spec_elligator_ristretto_flavor.?
      r_0!
    ))
    :qid internal_curve25519_dalek!specs.ristretto_specs.spec_elligator_ristretto_flavor.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.ristretto_specs.spec_elligator_ristretto_flavor.?_definition
))))
(assert
 (forall ((r_0! Poly)) (!
   (=>
    (has_type r_0! NAT)
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.ristretto_specs.spec_elligator_ristretto_flavor.?
       r_0!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.ristretto_specs.spec_elligator_ristretto_flavor.?
     r_0!
   ))
   :qid internal_curve25519_dalek!specs.ristretto_specs.spec_elligator_ristretto_flavor.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.ristretto_specs.spec_elligator_ristretto_flavor.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::lizard_lemmas::is_slot_in_coset
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.lizard_lemmas.is_slot_in_coset.)
  (forall ((fe_val! Poly) (coset! Poly)) (!
    (= (curve25519_dalek!lemmas.lizard_lemmas.is_slot_in_coset.? fe_val! coset!) (let
      ((ej$ (curve25519_dalek!specs.ristretto_specs.spec_elligator_ristretto_flavor.? fe_val!)))
      (or
       (or
        (or
         (= ej$ (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (vstd!view.View.view.?
             $ (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4)) coset!
            ) (I 0)
         )))
         (= ej$ (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (vstd!view.View.view.?
             $ (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4)) coset!
            ) (I 1)
        ))))
        (= ej$ (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (vstd!view.View.view.?
            $ (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4)) coset!
           ) (I 2)
       ))))
       (= ej$ (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (vstd!view.View.view.?
           $ (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4)) coset!
          ) (I 3)
    ))))))
    :pattern ((curve25519_dalek!lemmas.lizard_lemmas.is_slot_in_coset.? fe_val! coset!))
    :qid internal_curve25519_dalek!lemmas.lizard_lemmas.is_slot_in_coset.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.lizard_lemmas.is_slot_in_coset.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::core_specs::u8_32_as_nat_rec
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.)
)
(declare-const fuel_nat%curve25519_dalek!specs.core_specs.u8_32_as_nat_rec. Fuel)
(assert
 (forall ((bytes! Poly) (index! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!specs.core_specs.rec%u8_32_as_nat_rec.? bytes! index! fuel%)
    (curve25519_dalek!specs.core_specs.rec%u8_32_as_nat_rec.? bytes! index! zero)
   )
   :pattern ((curve25519_dalek!specs.core_specs.rec%u8_32_as_nat_rec.? bytes! index! fuel%))
   :qid internal_curve25519_dalek!specs.core_specs.u8_32_as_nat_rec._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.u8_32_as_nat_rec._fuel_to_zero_definition
)))
(assert
 (forall ((bytes! Poly) (index! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type bytes! (ARRAY $ (UINT 8) $ (CONST_INT 32)))
     (has_type index! NAT)
    )
    (= (curve25519_dalek!specs.core_specs.rec%u8_32_as_nat_rec.? bytes! index! (succ fuel%))
     (ite
      (>= (%I index!) 32)
      0
      (nClip (Add (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY
              $ (UINT 8) $ (CONST_INT 32)
             ) bytes!
            ) index!
           )
          ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul (%I index!) 8))))
         )
        ) (curve25519_dalek!specs.core_specs.rec%u8_32_as_nat_rec.? bytes! (I (nClip (Add (%I
             index!
            ) 1
          ))
         ) fuel%
   ))))))
   :pattern ((curve25519_dalek!specs.core_specs.rec%u8_32_as_nat_rec.? bytes! index! (
      succ fuel%
   )))
   :qid internal_curve25519_dalek!specs.core_specs.u8_32_as_nat_rec._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.u8_32_as_nat_rec._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.)
  (forall ((bytes! Poly) (index! Poly)) (!
    (=>
     (and
      (has_type bytes! (ARRAY $ (UINT 8) $ (CONST_INT 32)))
      (has_type index! NAT)
     )
     (= (curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.? bytes! index!) (curve25519_dalek!specs.core_specs.rec%u8_32_as_nat_rec.?
       bytes! index! (succ fuel_nat%curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.)
    )))
    :pattern ((curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.? bytes! index!))
    :qid internal_curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.?_definition
))))
(assert
 (forall ((bytes! Poly) (index! Poly)) (!
   (=>
    (and
     (has_type bytes! (ARRAY $ (UINT 8) $ (CONST_INT 32)))
     (has_type index! NAT)
    )
    (<= 0 (curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.? bytes! index!))
   )
   :pattern ((curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.? bytes! index!))
   :qid internal_curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.?_pre_post_definition
)))
(assert
 (forall ((bytes! Poly) (index! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type bytes! (ARRAY $ (UINT 8) $ (CONST_INT 32)))
     (has_type index! NAT)
    )
    (<= 0 (curve25519_dalek!specs.core_specs.rec%u8_32_as_nat_rec.? bytes! index! fuel%))
   )
   :pattern ((curve25519_dalek!specs.core_specs.rec%u8_32_as_nat_rec.? bytes! index! fuel%))
   :qid internal_curve25519_dalek!specs.core_specs.rec__u8_32_as_nat_rec.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.rec__u8_32_as_nat_rec.?_pre_post_rec_definition
)))

;; Function-Axioms curve25519_dalek::specs::core_specs::spec_load8_at
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.core_specs.spec_load8_at.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.core_specs.spec_load8_at.)
  (forall ((input! Poly) (i! Poly)) (!
    (= (curve25519_dalek!specs.core_specs.spec_load8_at.? input! i!) (nClip (Add (Add (Add
         (Add (Add (Add (Add (Mul (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 0 8)))) (%I (vstd!seq.Seq.index.?
                $ (UINT 8) (vstd!view.View.view.? $slice (SLICE $ (UINT 8)) input!) (I (Add (%I i!)
                  0
              ))))
             ) (Mul (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 1 8)))) (%I (vstd!seq.Seq.index.?
                $ (UINT 8) (vstd!view.View.view.? $slice (SLICE $ (UINT 8)) input!) (I (Add (%I i!)
                  1
             )))))
            ) (Mul (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 2 8)))) (%I (vstd!seq.Seq.index.?
               $ (UINT 8) (vstd!view.View.view.? $slice (SLICE $ (UINT 8)) input!) (I (Add (%I i!)
                 2
            )))))
           ) (Mul (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 3 8)))) (%I (vstd!seq.Seq.index.?
              $ (UINT 8) (vstd!view.View.view.? $slice (SLICE $ (UINT 8)) input!) (I (Add (%I i!)
                3
           )))))
          ) (Mul (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 4 8)))) (%I (vstd!seq.Seq.index.?
             $ (UINT 8) (vstd!view.View.view.? $slice (SLICE $ (UINT 8)) input!) (I (Add (%I i!)
               4
          )))))
         ) (Mul (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 5 8)))) (%I (vstd!seq.Seq.index.?
            $ (UINT 8) (vstd!view.View.view.? $slice (SLICE $ (UINT 8)) input!) (I (Add (%I i!)
              5
         )))))
        ) (Mul (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 6 8)))) (%I (vstd!seq.Seq.index.?
           $ (UINT 8) (vstd!view.View.view.? $slice (SLICE $ (UINT 8)) input!) (I (Add (%I i!)
             6
        )))))
       ) (Mul (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 7 8)))) (%I (vstd!seq.Seq.index.?
          $ (UINT 8) (vstd!view.View.view.? $slice (SLICE $ (UINT 8)) input!) (I (Add (%I i!)
            7
    ))))))))
    :pattern ((curve25519_dalek!specs.core_specs.spec_load8_at.? input! i!))
    :qid internal_curve25519_dalek!specs.core_specs.spec_load8_at.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.core_specs.spec_load8_at.?_definition
))))
(assert
 (forall ((input! Poly) (i! Poly)) (!
   (=>
    (and
     (has_type input! (SLICE $ (UINT 8)))
     (has_type i! USIZE)
    )
    (<= 0 (curve25519_dalek!specs.core_specs.spec_load8_at.? input! i!))
   )
   :pattern ((curve25519_dalek!specs.core_specs.spec_load8_at.? input! i!))
   :qid internal_curve25519_dalek!specs.core_specs.spec_load8_at.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.spec_load8_at.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_on_edwards_curve
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.)
  (forall ((x! Poly) (y! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.? x! y!) (let
      ((p$ (curve25519_dalek!specs.field_specs_u64.p.? (I 0))))
      (let
       ((d$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?
       ))))
       (let
        ((x2$ (curve25519_dalek!specs.field_specs.field_square.? x!)))
        (let
         ((y2$ (curve25519_dalek!specs.field_specs.field_square.? y!)))
         (let
          ((x2y2$ (curve25519_dalek!specs.field_specs.field_mul.? (I x2$) (I y2$))))
          (let
           ((lhs$ (curve25519_dalek!specs.field_specs.field_sub.? (I y2$) (I x2$))))
           (let
            ((rhs$ (curve25519_dalek!specs.field_specs.field_add.? (I 1) (I (curve25519_dalek!specs.field_specs.field_mul.?
                 (I d$) (I x2y2$)
            )))))
            (= lhs$ rhs$)
    ))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.? x! y!))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs::fe51_as_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.fe51_as_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.fe51_as_nat.)
  (forall ((fe! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.fe51_as_nat.? fe!) (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
      (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
        (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe!)
    ))))
    :pattern ((curve25519_dalek!specs.field_specs.fe51_as_nat.? fe!))
    :qid internal_curve25519_dalek!specs.field_specs.fe51_as_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.fe51_as_nat.?_definition
))))
(assert
 (forall ((fe! Poly)) (!
   (=>
    (has_type fe! TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    (<= 0 (curve25519_dalek!specs.field_specs.fe51_as_nat.? fe!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.fe51_as_nat.? fe!))
   :qid internal_curve25519_dalek!specs.field_specs.fe51_as_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.fe51_as_nat.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::as_bytes_post
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.as_bytes_post.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.as_bytes_post.)
  (forall ((fe! Poly) (bytes! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.as_bytes_post.? fe! bytes!) (= (curve25519_dalek!specs.core_specs.u8_32_as_nat.?
       bytes!
      ) (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? fe!)
    ))
    :pattern ((curve25519_dalek!specs.field_specs.as_bytes_post.? fe! bytes!))
    :qid internal_curve25519_dalek!specs.field_specs.as_bytes_post.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.as_bytes_post.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs::from_bytes_post
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.from_bytes_post.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.from_bytes_post.)
  (forall ((bytes! Poly) (fe! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.from_bytes_post.? bytes! fe!) (= (curve25519_dalek!specs.field_specs.fe51_as_nat.?
       fe!
      ) (EucMod (curve25519_dalek!specs.core_specs.u8_32_as_nat.? bytes!) (vstd!arithmetic.power2.pow2.?
        (I 255)
    ))))
    :pattern ((curve25519_dalek!specs.field_specs.from_bytes_post.? bytes! fe!))
    :qid internal_curve25519_dalek!specs.field_specs.from_bytes_post.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.from_bytes_post.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs::spec_fe51_from_bytes
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.spec_fe51_from_bytes.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.spec_fe51_from_bytes.)
  (forall ((bytes! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.spec_fe51_from_bytes.? bytes!) (let
      ((low_51_bit_mask$ curve25519_dalek!specs.field_specs_u64.mask51.?))
      (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (%Poly%array%.
        (array_new $ (UINT 64) 5 (%%array%%0 (I (uClip 64 (bitand (I (uClip 64 (curve25519_dalek!specs.core_specs.spec_load8_at.?
                (vstd!array.spec_array_as_slice.? $ (UINT 8) $ (CONST_INT 32) bytes!) (I 0)
              ))
             ) (I low_51_bit_mask$)
           ))
          ) (I (uClip 64 (bitand (I (uClip 64 (bitshr (I (uClip 64 (curve25519_dalek!specs.core_specs.spec_load8_at.?
                   (vstd!array.spec_array_as_slice.? $ (UINT 8) $ (CONST_INT 32) bytes!) (I 6)
                 ))
                ) (I 3)
              ))
             ) (I low_51_bit_mask$)
           ))
          ) (I (uClip 64 (bitand (I (uClip 64 (bitshr (I (uClip 64 (curve25519_dalek!specs.core_specs.spec_load8_at.?
                   (vstd!array.spec_array_as_slice.? $ (UINT 8) $ (CONST_INT 32) bytes!) (I 12)
                 ))
                ) (I 6)
              ))
             ) (I low_51_bit_mask$)
           ))
          ) (I (uClip 64 (bitand (I (uClip 64 (bitshr (I (uClip 64 (curve25519_dalek!specs.core_specs.spec_load8_at.?
                   (vstd!array.spec_array_as_slice.? $ (UINT 8) $ (CONST_INT 32) bytes!) (I 19)
                 ))
                ) (I 1)
              ))
             ) (I low_51_bit_mask$)
           ))
          ) (I (uClip 64 (bitand (I (uClip 64 (bitshr (I (uClip 64 (curve25519_dalek!specs.core_specs.spec_load8_at.?
                   (vstd!array.spec_array_as_slice.? $ (UINT 8) $ (CONST_INT 32) bytes!) (I 24)
                 ))
                ) (I 12)
              ))
             ) (I low_51_bit_mask$)
    )))))))))
    :pattern ((curve25519_dalek!specs.field_specs.spec_fe51_from_bytes.? bytes!))
    :qid internal_curve25519_dalek!specs.field_specs.spec_fe51_from_bytes.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.spec_fe51_from_bytes.?_definition
))))
(assert
 (forall ((bytes! Poly)) (!
   (=>
    (has_type bytes! (ARRAY $ (UINT 8) $ (CONST_INT 32)))
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.field_specs.spec_fe51_from_bytes.?
       bytes!
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!specs.field_specs.spec_fe51_from_bytes.? bytes!))
   :qid internal_curve25519_dalek!specs.field_specs.spec_fe51_from_bytes.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.spec_fe51_from_bytes.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::is_sqrt_ratio_times_i
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.is_sqrt_ratio_times_i.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.is_sqrt_ratio_times_i.)
  (forall ((u! Poly) (v! Poly) (r! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.is_sqrt_ratio_times_i.? u! v! r!) (= (curve25519_dalek!specs.field_specs_u64.field_canonical.?
       (I (nClip (Mul (nClip (Mul (%I r!) (%I r!))) (%I v!))))
      ) (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.sqrt_m1.?
         (I 0)
        )
       ) u!
    )))
    :pattern ((curve25519_dalek!specs.field_specs.is_sqrt_ratio_times_i.? u! v! r!))
    :qid internal_curve25519_dalek!specs.field_specs.is_sqrt_ratio_times_i.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.is_sqrt_ratio_times_i.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs::u8_32_from_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.u8_32_from_nat.)
)
(declare-fun %%choose%%0 (Type Int) Poly)
(assert
 (forall ((%%hole%%0 Type) (%%hole%%1 Int)) (!
   (=>
    (exists ((b$ Poly)) (!
      (and
       (has_type b$ %%hole%%0)
       (= (curve25519_dalek!specs.core_specs.u8_32_as_nat.? b$) %%hole%%1)
      )
      :pattern ((curve25519_dalek!specs.core_specs.u8_32_as_nat.? b$))
      :qid user_curve25519_dalek__specs__field_specs__u8_32_from_nat_30
      :skolemid skolem_user_curve25519_dalek__specs__field_specs__u8_32_from_nat_30
    ))
    (exists ((b$ Poly)) (!
      (and
       (and
        (has_type b$ %%hole%%0)
        (= (curve25519_dalek!specs.core_specs.u8_32_as_nat.? b$) %%hole%%1)
       )
       (= (%%choose%%0 %%hole%%0 %%hole%%1) b$)
      )
      :pattern ((curve25519_dalek!specs.core_specs.u8_32_as_nat.? b$))
   )))
   :pattern ((%%choose%%0 %%hole%%0 %%hole%%1))
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.u8_32_from_nat.)
  (forall ((n! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.u8_32_from_nat.? n!) (%Poly%array%. (as_type
       (%%choose%%0 (ARRAY $ (UINT 8) $ (CONST_INT 32)) (EucMod (%I n!) (vstd!arithmetic.power2.pow2.?
          (I 256)
        ))
       ) (ARRAY $ (UINT 8) $ (CONST_INT 32))
    )))
    :pattern ((curve25519_dalek!specs.field_specs.u8_32_from_nat.? n!))
    :qid internal_curve25519_dalek!specs.field_specs.u8_32_from_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.u8_32_from_nat.?_definition
))))
(assert
 (forall ((n! Poly)) (!
   (=>
    (has_type n! NAT)
    (has_type (Poly%array%. (curve25519_dalek!specs.field_specs.u8_32_from_nat.? n!))
     (ARRAY $ (UINT 8) $ (CONST_INT 32))
   ))
   :pattern ((curve25519_dalek!specs.field_specs.u8_32_from_nat.? n!))
   :qid internal_curve25519_dalek!specs.field_specs.u8_32_from_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.u8_32_from_nat.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::ristretto_specs::ristretto_coset_affine
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.ristretto_specs.ristretto_coset_affine.)
)
(declare-fun %%array%%1 (Poly Poly Poly Poly) %%Function%%)
(assert
 (forall ((%%hole%%0 Poly) (%%hole%%1 Poly) (%%hole%%2 Poly) (%%hole%%3 Poly)) (!
   (let
    ((%%x%% (%%array%%1 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3)))
    (and
     (= (%%apply%%1 %%x%% 0) %%hole%%0)
     (= (%%apply%%1 %%x%% 1) %%hole%%1)
     (= (%%apply%%1 %%x%% 2) %%hole%%2)
     (= (%%apply%%1 %%x%% 3) %%hole%%3)
   ))
   :pattern ((%%array%%1 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3))
   :qid __AIR_ARRAY_QID__
   :skolemid skolem___AIR_ARRAY_QID__
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.ristretto_specs.ristretto_coset_affine.)
  (forall ((x! Poly) (y! Poly)) (!
    (= (curve25519_dalek!specs.ristretto_specs.ristretto_coset_affine.? x! y!) (%Poly%array%.
      (let
       ((t2$ (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? (vstd!seq.Seq.index.?
           $ TYPE%curve25519_dalek!edwards.EdwardsPoint. (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!edwards.EdwardsPoint.
             $ (CONST_INT 8)
            ) (Poly%array%. (curve25519_dalek!backend.serial.u64.constants.spec_eight_torsion.?
              (I 0)
            ))
           ) (I 2)
       ))))
       (let
        ((t4$ (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? (vstd!seq.Seq.index.?
            $ TYPE%curve25519_dalek!edwards.EdwardsPoint. (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!edwards.EdwardsPoint.
              $ (CONST_INT 8)
             ) (Poly%array%. (curve25519_dalek!backend.serial.u64.constants.spec_eight_torsion.?
               (I 0)
             ))
            ) (I 4)
        ))))
        (let
         ((t6$ (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? (vstd!seq.Seq.index.?
             $ TYPE%curve25519_dalek!edwards.EdwardsPoint. (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!edwards.EdwardsPoint.
               $ (CONST_INT 8)
              ) (Poly%array%. (curve25519_dalek!backend.serial.u64.constants.spec_eight_torsion.?
                (I 0)
              ))
             ) (I 6)
         ))))
         (array_new (DST $) (TYPE%tuple%2. $ NAT $ NAT) 4 (%%array%%1 (Poly%tuple%2. (tuple%2./tuple%2
             x! y!
            )
           ) (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_add.? x! y! (tuple%2./tuple%2/0
              (%Poly%tuple%2. (Poly%tuple%2. t2$))
             ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. t2$)))
            )
           ) (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_add.? x! y! (tuple%2./tuple%2/0
              (%Poly%tuple%2. (Poly%tuple%2. t4$))
             ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. t4$)))
            )
           ) (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_add.? x! y! (tuple%2./tuple%2/0
              (%Poly%tuple%2. (Poly%tuple%2. t6$))
             ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. t6$)))
    )))))))))
    :pattern ((curve25519_dalek!specs.ristretto_specs.ristretto_coset_affine.? x! y!))
    :qid internal_curve25519_dalek!specs.ristretto_specs.ristretto_coset_affine.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.ristretto_specs.ristretto_coset_affine.?_definition
))))
(assert
 (forall ((x! Poly) (y! Poly)) (!
   (=>
    (and
     (has_type x! NAT)
     (has_type y! NAT)
    )
    (has_type (Poly%array%. (curve25519_dalek!specs.ristretto_specs.ristretto_coset_affine.?
       x! y!
      )
     ) (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4))
   ))
   :pattern ((curve25519_dalek!specs.ristretto_specs.ristretto_coset_affine.? x! y!))
   :qid internal_curve25519_dalek!specs.ristretto_specs.ristretto_coset_affine.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.ristretto_specs.ristretto_coset_affine.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::core_assumes::seq_to_array_32
(assert
 (fuel_bool_default fuel%curve25519_dalek!core_assumes.seq_to_array_32.)
)
(declare-fun %%array%%2 (Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly
  Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly
  Poly Poly Poly
 ) %%Function%%
)
(assert
 (forall ((%%hole%%0 Poly) (%%hole%%1 Poly) (%%hole%%2 Poly) (%%hole%%3 Poly) (%%hole%%4
    Poly
   ) (%%hole%%5 Poly) (%%hole%%6 Poly) (%%hole%%7 Poly) (%%hole%%8 Poly) (%%hole%%9 Poly)
   (%%hole%%10 Poly) (%%hole%%11 Poly) (%%hole%%12 Poly) (%%hole%%13 Poly) (%%hole%%14
    Poly
   ) (%%hole%%15 Poly) (%%hole%%16 Poly) (%%hole%%17 Poly) (%%hole%%18 Poly) (%%hole%%19
    Poly
   ) (%%hole%%20 Poly) (%%hole%%21 Poly) (%%hole%%22 Poly) (%%hole%%23 Poly) (%%hole%%24
    Poly
   ) (%%hole%%25 Poly) (%%hole%%26 Poly) (%%hole%%27 Poly) (%%hole%%28 Poly) (%%hole%%29
    Poly
   ) (%%hole%%30 Poly) (%%hole%%31 Poly)
  ) (!
   (let
    ((%%x%% (%%array%%2 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4 %%hole%%5 %%hole%%6
       %%hole%%7 %%hole%%8 %%hole%%9 %%hole%%10 %%hole%%11 %%hole%%12 %%hole%%13 %%hole%%14
       %%hole%%15 %%hole%%16 %%hole%%17 %%hole%%18 %%hole%%19 %%hole%%20 %%hole%%21 %%hole%%22
       %%hole%%23 %%hole%%24 %%hole%%25 %%hole%%26 %%hole%%27 %%hole%%28 %%hole%%29 %%hole%%30
       %%hole%%31
    )))
    (and
     (= (%%apply%%1 %%x%% 0) %%hole%%0)
     (= (%%apply%%1 %%x%% 1) %%hole%%1)
     (= (%%apply%%1 %%x%% 2) %%hole%%2)
     (= (%%apply%%1 %%x%% 3) %%hole%%3)
     (= (%%apply%%1 %%x%% 4) %%hole%%4)
     (= (%%apply%%1 %%x%% 5) %%hole%%5)
     (= (%%apply%%1 %%x%% 6) %%hole%%6)
     (= (%%apply%%1 %%x%% 7) %%hole%%7)
     (= (%%apply%%1 %%x%% 8) %%hole%%8)
     (= (%%apply%%1 %%x%% 9) %%hole%%9)
     (= (%%apply%%1 %%x%% 10) %%hole%%10)
     (= (%%apply%%1 %%x%% 11) %%hole%%11)
     (= (%%apply%%1 %%x%% 12) %%hole%%12)
     (= (%%apply%%1 %%x%% 13) %%hole%%13)
     (= (%%apply%%1 %%x%% 14) %%hole%%14)
     (= (%%apply%%1 %%x%% 15) %%hole%%15)
     (= (%%apply%%1 %%x%% 16) %%hole%%16)
     (= (%%apply%%1 %%x%% 17) %%hole%%17)
     (= (%%apply%%1 %%x%% 18) %%hole%%18)
     (= (%%apply%%1 %%x%% 19) %%hole%%19)
     (= (%%apply%%1 %%x%% 20) %%hole%%20)
     (= (%%apply%%1 %%x%% 21) %%hole%%21)
     (= (%%apply%%1 %%x%% 22) %%hole%%22)
     (= (%%apply%%1 %%x%% 23) %%hole%%23)
     (= (%%apply%%1 %%x%% 24) %%hole%%24)
     (= (%%apply%%1 %%x%% 25) %%hole%%25)
     (= (%%apply%%1 %%x%% 26) %%hole%%26)
     (= (%%apply%%1 %%x%% 27) %%hole%%27)
     (= (%%apply%%1 %%x%% 28) %%hole%%28)
     (= (%%apply%%1 %%x%% 29) %%hole%%29)
     (= (%%apply%%1 %%x%% 30) %%hole%%30)
     (= (%%apply%%1 %%x%% 31) %%hole%%31)
   ))
   :pattern ((%%array%%2 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4 %%hole%%5 %%hole%%6
     %%hole%%7 %%hole%%8 %%hole%%9 %%hole%%10 %%hole%%11 %%hole%%12 %%hole%%13 %%hole%%14
     %%hole%%15 %%hole%%16 %%hole%%17 %%hole%%18 %%hole%%19 %%hole%%20 %%hole%%21 %%hole%%22
     %%hole%%23 %%hole%%24 %%hole%%25 %%hole%%26 %%hole%%27 %%hole%%28 %%hole%%29 %%hole%%30
     %%hole%%31
   ))
   :qid __AIR_ARRAY_QID__
   :skolemid skolem___AIR_ARRAY_QID__
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!core_assumes.seq_to_array_32.)
  (forall ((s! Poly)) (!
    (= (curve25519_dalek!core_assumes.seq_to_array_32.? s!) (%Poly%array%. (array_new $
       (UINT 8) 32 (%%array%%2 (vstd!seq.Seq.index.? $ (UINT 8) s! (I 0)) (vstd!seq.Seq.index.?
         $ (UINT 8) s! (I 1)
        ) (vstd!seq.Seq.index.? $ (UINT 8) s! (I 2)) (vstd!seq.Seq.index.? $ (UINT 8) s! (
          I 3
         )
        ) (vstd!seq.Seq.index.? $ (UINT 8) s! (I 4)) (vstd!seq.Seq.index.? $ (UINT 8) s! (
          I 5
         )
        ) (vstd!seq.Seq.index.? $ (UINT 8) s! (I 6)) (vstd!seq.Seq.index.? $ (UINT 8) s! (
          I 7
         )
        ) (vstd!seq.Seq.index.? $ (UINT 8) s! (I 8)) (vstd!seq.Seq.index.? $ (UINT 8) s! (
          I 9
         )
        ) (vstd!seq.Seq.index.? $ (UINT 8) s! (I 10)) (vstd!seq.Seq.index.? $ (UINT 8) s!
         (I 11)
        ) (vstd!seq.Seq.index.? $ (UINT 8) s! (I 12)) (vstd!seq.Seq.index.? $ (UINT 8) s!
         (I 13)
        ) (vstd!seq.Seq.index.? $ (UINT 8) s! (I 14)) (vstd!seq.Seq.index.? $ (UINT 8) s!
         (I 15)
        ) (vstd!seq.Seq.index.? $ (UINT 8) s! (I 16)) (vstd!seq.Seq.index.? $ (UINT 8) s!
         (I 17)
        ) (vstd!seq.Seq.index.? $ (UINT 8) s! (I 18)) (vstd!seq.Seq.index.? $ (UINT 8) s!
         (I 19)
        ) (vstd!seq.Seq.index.? $ (UINT 8) s! (I 20)) (vstd!seq.Seq.index.? $ (UINT 8) s!
         (I 21)
        ) (vstd!seq.Seq.index.? $ (UINT 8) s! (I 22)) (vstd!seq.Seq.index.? $ (UINT 8) s!
         (I 23)
        ) (vstd!seq.Seq.index.? $ (UINT 8) s! (I 24)) (vstd!seq.Seq.index.? $ (UINT 8) s!
         (I 25)
        ) (vstd!seq.Seq.index.? $ (UINT 8) s! (I 26)) (vstd!seq.Seq.index.? $ (UINT 8) s!
         (I 27)
        ) (vstd!seq.Seq.index.? $ (UINT 8) s! (I 28)) (vstd!seq.Seq.index.? $ (UINT 8) s!
         (I 29)
        ) (vstd!seq.Seq.index.? $ (UINT 8) s! (I 30)) (vstd!seq.Seq.index.? $ (UINT 8) s!
         (I 31)
    )))))
    :pattern ((curve25519_dalek!core_assumes.seq_to_array_32.? s!))
    :qid internal_curve25519_dalek!core_assumes.seq_to_array_32.?_definition
    :skolemid skolem_internal_curve25519_dalek!core_assumes.seq_to_array_32.?_definition
))))
(assert
 (forall ((s! Poly)) (!
   (=>
    (has_type s! (TYPE%vstd!seq.Seq. $ (UINT 8)))
    (has_type (Poly%array%. (curve25519_dalek!core_assumes.seq_to_array_32.? s!)) (ARRAY
      $ (UINT 8) $ (CONST_INT 32)
   )))
   :pattern ((curve25519_dalek!core_assumes.seq_to_array_32.? s!))
   :qid internal_curve25519_dalek!core_assumes.seq_to_array_32.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!core_assumes.seq_to_array_32.?_pre_post_definition
)))

;; Function-Specs curve25519_dalek::specs::lizard_specs::spec_lizard_fe_bytes
(declare-fun req%curve25519_dalek!specs.lizard_specs.spec_lizard_fe_bytes. (Poly)
 Bool
)
(declare-const %%global_location_label%%16 Bool)
(assert
 (forall ((data! Poly)) (!
   (= (req%curve25519_dalek!specs.lizard_specs.spec_lizard_fe_bytes. data!) (=>
     %%global_location_label%%16
     (= (vstd!seq.Seq.len.? $ (UINT 8) data!) 16)
   ))
   :pattern ((req%curve25519_dalek!specs.lizard_specs.spec_lizard_fe_bytes. data!))
   :qid internal_req__curve25519_dalek!specs.lizard_specs.spec_lizard_fe_bytes._definition
   :skolemid skolem_internal_req__curve25519_dalek!specs.lizard_specs.spec_lizard_fe_bytes._definition
)))

;; Function-Axioms curve25519_dalek::specs::lizard_specs::spec_lizard_fe_bytes
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.lizard_specs.spec_lizard_fe_bytes.)
)
(declare-fun %%lambda%%1 (Int Int Int Dcr Type Poly Dcr Type Poly) %%Function%%)
(assert
 (forall ((%%hole%%0 Int) (%%hole%%1 Int) (%%hole%%2 Int) (%%hole%%3 Dcr) (%%hole%%4
    Type
   ) (%%hole%%5 Poly) (%%hole%%6 Dcr) (%%hole%%7 Type) (%%hole%%8 Poly) (i$ Poly)
  ) (!
   (= (%%apply%%0 (%%lambda%%1 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4 %%hole%%5
      %%hole%%6 %%hole%%7 %%hole%%8
     ) i$
    ) (ite
     (let
      ((tmp%%$ (%I i$)))
      (and
       (<= %%hole%%0 tmp%%$)
       (< tmp%%$ %%hole%%1)
     ))
     (vstd!seq.Seq.index.? %%hole%%3 %%hole%%4 %%hole%%5 (I (Sub (%I i$) %%hole%%2)))
     (vstd!seq.Seq.index.? %%hole%%6 %%hole%%7 %%hole%%8 i$)
   ))
   :pattern ((%%apply%%0 (%%lambda%%1 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4
      %%hole%%5 %%hole%%6 %%hole%%7 %%hole%%8
     ) i$
)))))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.lizard_specs.spec_lizard_fe_bytes.)
  (forall ((data! Poly)) (!
    (= (curve25519_dalek!specs.lizard_specs.spec_lizard_fe_bytes.? data!) (let
      ((digest$ (curve25519_dalek!core_assumes.spec_sha256.? data!)))
      (let
       ((s$ (%Poly%vstd!seq.Seq<u8.>. (vstd!seq.Seq.new.? $ (UINT 8) $ (TYPE%fun%1. $ INT $ (
             UINT 8
            )
           ) (I 32) (Poly%fun%1. (mk_fun (%%lambda%%1 8 24 8 $ (UINT 8) data! $ (UINT 8) (Poly%vstd!seq.Seq<u8.>.
               digest$
       ))))))))
       (let
        ((s$1 (%Poly%vstd!seq.Seq<u8.>. (vstd!seq.Seq.update.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>.
             s$
            ) (I 0) (I (uClip 8 (bitand (I (%I (vstd!seq.Seq.index.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>.
                   s$
                  ) (I 0)
                ))
               ) (I 254)
        )))))))
        (let
         ((s$2 (%Poly%vstd!seq.Seq<u8.>. (vstd!seq.Seq.update.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>.
              s$1
             ) (I 31) (I (uClip 8 (bitand (I (%I (vstd!seq.Seq.index.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>.
                    s$1
                   ) (I 31)
                 ))
                ) (I 63)
         )))))))
         (curve25519_dalek!core_assumes.seq_to_array_32.? (Poly%vstd!seq.Seq<u8.>. s$2))
    )))))
    :pattern ((curve25519_dalek!specs.lizard_specs.spec_lizard_fe_bytes.? data!))
    :qid internal_curve25519_dalek!specs.lizard_specs.spec_lizard_fe_bytes.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.spec_lizard_fe_bytes.?_definition
))))
(assert
 (forall ((data! Poly)) (!
   (=>
    (has_type data! (TYPE%vstd!seq.Seq. $ (UINT 8)))
    (has_type (Poly%array%. (curve25519_dalek!specs.lizard_specs.spec_lizard_fe_bytes.?
       data!
      )
     ) (ARRAY $ (UINT 8) $ (CONST_INT 32))
   ))
   :pattern ((curve25519_dalek!specs.lizard_specs.spec_lizard_fe_bytes.? data!))
   :qid internal_curve25519_dalek!specs.lizard_specs.spec_lizard_fe_bytes.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.spec_lizard_fe_bytes.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::lizard_specs::spec_lizard_r
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.lizard_specs.spec_lizard_r.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.lizard_specs.spec_lizard_r.)
  (forall ((fe_bytes! Poly)) (!
    (= (curve25519_dalek!specs.lizard_specs.spec_lizard_r.? fe_bytes!) (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
      (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.field_specs.spec_fe51_from_bytes.?
        fe_bytes!
    ))))
    :pattern ((curve25519_dalek!specs.lizard_specs.spec_lizard_r.? fe_bytes!))
    :qid internal_curve25519_dalek!specs.lizard_specs.spec_lizard_r.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.spec_lizard_r.?_definition
))))
(assert
 (forall ((fe_bytes! Poly)) (!
   (=>
    (has_type fe_bytes! (ARRAY $ (UINT 8) $ (CONST_INT 32)))
    (<= 0 (curve25519_dalek!specs.lizard_specs.spec_lizard_r.? fe_bytes!))
   )
   :pattern ((curve25519_dalek!specs.lizard_specs.spec_lizard_r.? fe_bytes!))
   :qid internal_curve25519_dalek!specs.lizard_specs.spec_lizard_r.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.spec_lizard_r.?_pre_post_definition
)))

;; Function-Specs curve25519_dalek::specs::lizard_specs::spec_lizard_encode
(declare-fun req%curve25519_dalek!specs.lizard_specs.spec_lizard_encode. (Poly) Bool)
(declare-const %%global_location_label%%17 Bool)
(assert
 (forall ((data! Poly)) (!
   (= (req%curve25519_dalek!specs.lizard_specs.spec_lizard_encode. data!) (=>
     %%global_location_label%%17
     (= (vstd!seq.Seq.len.? $ (UINT 8) data!) 16)
   ))
   :pattern ((req%curve25519_dalek!specs.lizard_specs.spec_lizard_encode. data!))
   :qid internal_req__curve25519_dalek!specs.lizard_specs.spec_lizard_encode._definition
   :skolemid skolem_internal_req__curve25519_dalek!specs.lizard_specs.spec_lizard_encode._definition
)))

;; Function-Axioms curve25519_dalek::specs::lizard_specs::spec_lizard_encode
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.lizard_specs.spec_lizard_encode.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.lizard_specs.spec_lizard_encode.)
  (forall ((data! Poly)) (!
    (= (curve25519_dalek!specs.lizard_specs.spec_lizard_encode.? data!) (curve25519_dalek!specs.ristretto_specs.spec_elligator_ristretto_flavor.?
      (I (curve25519_dalek!specs.lizard_specs.spec_lizard_r.? (Poly%array%. (curve25519_dalek!specs.lizard_specs.spec_lizard_fe_bytes.?
          data!
    ))))))
    :pattern ((curve25519_dalek!specs.lizard_specs.spec_lizard_encode.? data!))
    :qid internal_curve25519_dalek!specs.lizard_specs.spec_lizard_encode.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.spec_lizard_encode.?_definition
))))
(assert
 (forall ((data! Poly)) (!
   (=>
    (has_type data! (TYPE%vstd!seq.Seq. $ (UINT 8)))
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.lizard_specs.spec_lizard_encode.? data!))
     (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.lizard_specs.spec_lizard_encode.? data!))
   :qid internal_curve25519_dalek!specs.lizard_specs.spec_lizard_encode.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.spec_lizard_encode.?_pre_post_definition
)))

;; Function-Specs curve25519_dalek::specs::lizard_specs::jacobi_to_edwards_affine
(declare-fun req%curve25519_dalek!specs.lizard_specs.jacobi_to_edwards_affine. (Poly
  Poly
 ) Bool
)
(declare-const %%global_location_label%%18 Bool)
(declare-const %%global_location_label%%19 Bool)
(assert
 (forall ((s! Poly) (t! Poly)) (!
   (= (req%curve25519_dalek!specs.lizard_specs.jacobi_to_edwards_affine. s! t!) (and
     (=>
      %%global_location_label%%18
      (not (= (curve25519_dalek!specs.field_specs.field_add.? (I 1) (I (curve25519_dalek!specs.field_specs.field_square.?
           s!
         ))
        ) 0
     )))
     (=>
      %%global_location_label%%19
      (not (= (curve25519_dalek!specs.field_specs.field_mul.? t! (I (curve25519_dalek!specs.ristretto_specs.spec_sqrt_ad_minus_one.?
           (I 0)
         ))
        ) 0
   )))))
   :pattern ((req%curve25519_dalek!specs.lizard_specs.jacobi_to_edwards_affine. s! t!))
   :qid internal_req__curve25519_dalek!specs.lizard_specs.jacobi_to_edwards_affine._definition
   :skolemid skolem_internal_req__curve25519_dalek!specs.lizard_specs.jacobi_to_edwards_affine._definition
)))

;; Function-Axioms curve25519_dalek::specs::lizard_specs::jacobi_to_edwards_affine
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.lizard_specs.jacobi_to_edwards_affine.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.lizard_specs.jacobi_to_edwards_affine.)
  (forall ((s! Poly) (t! Poly)) (!
    (= (curve25519_dalek!specs.lizard_specs.jacobi_to_edwards_affine.? s! t!) (let
      ((s_sq$ (curve25519_dalek!specs.field_specs.field_square.? s!)))
      (let
       ((y$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_sub.?
            (I 1) (I s_sq$)
           )
          ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I (curve25519_dalek!specs.field_specs.field_add.?
              (I 1) (I s_sq$)
       )))))))
       (let
        ((sqrt_ad_m1$ (curve25519_dalek!specs.ristretto_specs.spec_sqrt_ad_minus_one.? (I 0))))
        (let
         ((x$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_mul.?
              (I 2) s!
             )
            ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I (curve25519_dalek!specs.field_specs.field_mul.?
                t! (I sqrt_ad_m1$)
         )))))))
         (tuple%2./tuple%2 (I x$) (I y$))
    )))))
    :pattern ((curve25519_dalek!specs.lizard_specs.jacobi_to_edwards_affine.? s! t!))
    :qid internal_curve25519_dalek!specs.lizard_specs.jacobi_to_edwards_affine.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.jacobi_to_edwards_affine.?_definition
))))
(assert
 (forall ((s! Poly) (t! Poly)) (!
   (=>
    (and
     (has_type s! NAT)
     (has_type t! NAT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.lizard_specs.jacobi_to_edwards_affine.?
       s! t!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.lizard_specs.jacobi_to_edwards_affine.? s! t!))
   :qid internal_curve25519_dalek!specs.lizard_specs.jacobi_to_edwards_affine.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.jacobi_to_edwards_affine.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::lizard_specs::sqrt_id
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.lizard_specs.sqrt_id.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.lizard_specs.sqrt_id.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!specs.lizard_specs.sqrt_id.? no%param) (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
      (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!lizard.u64_constants.SQRT_ID.?)
    ))
    :pattern ((curve25519_dalek!specs.lizard_specs.sqrt_id.? no%param))
    :qid internal_curve25519_dalek!specs.lizard_specs.sqrt_id.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.sqrt_id.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (<= 0 (curve25519_dalek!specs.lizard_specs.sqrt_id.? no%param))
   )
   :pattern ((curve25519_dalek!specs.lizard_specs.sqrt_id.? no%param))
   :qid internal_curve25519_dalek!specs.lizard_specs.sqrt_id.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.sqrt_id.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::lizard_specs::dp1_over_dm1
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.lizard_specs.dp1_over_dm1.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.lizard_specs.dp1_over_dm1.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!specs.lizard_specs.dp1_over_dm1.? no%param) (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
      (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!lizard.u64_constants.DP1_OVER_DM1.?)
    ))
    :pattern ((curve25519_dalek!specs.lizard_specs.dp1_over_dm1.? no%param))
    :qid internal_curve25519_dalek!specs.lizard_specs.dp1_over_dm1.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.dp1_over_dm1.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (<= 0 (curve25519_dalek!specs.lizard_specs.dp1_over_dm1.? no%param))
   )
   :pattern ((curve25519_dalek!specs.lizard_specs.dp1_over_dm1.? no%param))
   :qid internal_curve25519_dalek!specs.lizard_specs.dp1_over_dm1.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.dp1_over_dm1.?_pre_post_definition
)))

;; Function-Specs curve25519_dalek::specs::lizard_specs::spec_elligator_inv
(declare-fun req%curve25519_dalek!specs.lizard_specs.spec_elligator_inv. (Poly Poly)
 Bool
)
(declare-const %%global_location_label%%20 Bool)
(declare-const %%global_location_label%%21 Bool)
(assert
 (forall ((s! Poly) (t! Poly)) (!
   (= (req%curve25519_dalek!specs.lizard_specs.spec_elligator_inv. s! t!) (and
     (=>
      %%global_location_label%%20
      (< (%I s!) (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%21
      (< (%I t!) (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
   )))
   :pattern ((req%curve25519_dalek!specs.lizard_specs.spec_elligator_inv. s! t!))
   :qid internal_req__curve25519_dalek!specs.lizard_specs.spec_elligator_inv._definition
   :skolemid skolem_internal_req__curve25519_dalek!specs.lizard_specs.spec_elligator_inv._definition
)))

;; Function-Axioms curve25519_dalek::specs::lizard_specs::spec_elligator_inv
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.lizard_specs.spec_elligator_inv.)
  (forall ((s! Poly) (t! Poly)) (!
    (= (curve25519_dalek!specs.lizard_specs.spec_elligator_inv.? s! t!) (ite
      (= (curve25519_dalek!specs.field_specs_u64.field_canonical.? s!) 0)
      (ite
       (= (curve25519_dalek!specs.field_specs_u64.field_canonical.? t!) 1)
       (tuple%2./tuple%2 (B true) (I (curve25519_dalek!specs.lizard_specs.sqrt_id.? (I 0))))
       (tuple%2./tuple%2 (B true) (I 0))
      )
      (let
       ((a$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_add.?
            t! (I 1)
           )
          ) (I (curve25519_dalek!specs.lizard_specs.dp1_over_dm1.? (I 0)))
       )))
       (let
        ((s2$ (curve25519_dalek!specs.field_specs.field_square.? s!)))
        (let
         ((s4$ (curve25519_dalek!specs.field_specs.field_square.? (I s2$))))
         (let
          ((inv_sq_y$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_sub.?
               (I s4$) (I (curve25519_dalek!specs.field_specs.field_square.? (I a$)))
              )
             ) (I (curve25519_dalek!specs.field_specs.sqrt_m1.? (I 0)))
          )))
          (let
           ((y$ (curve25519_dalek!specs.field_specs.nat_invsqrt.? (I inv_sq_y$))))
           (let
            ((sq$ (and
               (not (= (curve25519_dalek!specs.field_specs_u64.field_canonical.? (I inv_sq_y$)) 0))
               (curve25519_dalek!specs.field_specs.is_sqrt_ratio.? (I 1) (I inv_sq_y$) (I y$))
            )))
            (ite
             (not sq$)
             (tuple%2./tuple%2 (B false) (I 0))
             (let
              ((pms2$ (ite
                 (curve25519_dalek!specs.field_specs.is_negative.? s!)
                 (curve25519_dalek!specs.field_specs.field_neg.? (I s2$))
                 s2$
              )))
              (let
               ((x$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_add.?
                    (I a$) (I pms2$)
                   )
                  ) (I y$)
               )))
               (tuple%2./tuple%2 (B true) (I (curve25519_dalek!specs.field_specs.field_abs.? (I x$))))
    )))))))))))
    :pattern ((curve25519_dalek!specs.lizard_specs.spec_elligator_inv.? s! t!))
    :qid internal_curve25519_dalek!specs.lizard_specs.spec_elligator_inv.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.spec_elligator_inv.?_definition
))))
(assert
 (forall ((s! Poly) (t! Poly)) (!
   (=>
    (and
     (has_type s! NAT)
     (has_type t! NAT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.lizard_specs.spec_elligator_inv.? s!
       t!
      )
     ) (TYPE%tuple%2. $ BOOL $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.lizard_specs.spec_elligator_inv.? s! t!))
   :qid internal_curve25519_dalek!specs.lizard_specs.spec_elligator_inv.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.spec_elligator_inv.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::lizard_specs::mdouble_invsqrt_a_minus_d
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.lizard_specs.mdouble_invsqrt_a_minus_d.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.lizard_specs.mdouble_invsqrt_a_minus_d.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!specs.lizard_specs.mdouble_invsqrt_a_minus_d.? no%param) (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
      (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!lizard.u64_constants.MDOUBLE_INVSQRT_A_MINUS_D.?)
    ))
    :pattern ((curve25519_dalek!specs.lizard_specs.mdouble_invsqrt_a_minus_d.? no%param))
    :qid internal_curve25519_dalek!specs.lizard_specs.mdouble_invsqrt_a_minus_d.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.mdouble_invsqrt_a_minus_d.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (<= 0 (curve25519_dalek!specs.lizard_specs.mdouble_invsqrt_a_minus_d.? no%param))
   )
   :pattern ((curve25519_dalek!specs.lizard_specs.mdouble_invsqrt_a_minus_d.? no%param))
   :qid internal_curve25519_dalek!specs.lizard_specs.mdouble_invsqrt_a_minus_d.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.mdouble_invsqrt_a_minus_d.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::lizard_specs::minvsqrt_one_plus_d
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.lizard_specs.minvsqrt_one_plus_d.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.lizard_specs.minvsqrt_one_plus_d.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!specs.lizard_specs.minvsqrt_one_plus_d.? no%param) (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
      (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!lizard.u64_constants.MINVSQRT_ONE_PLUS_D.?)
    ))
    :pattern ((curve25519_dalek!specs.lizard_specs.minvsqrt_one_plus_d.? no%param))
    :qid internal_curve25519_dalek!specs.lizard_specs.minvsqrt_one_plus_d.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.minvsqrt_one_plus_d.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (<= 0 (curve25519_dalek!specs.lizard_specs.minvsqrt_one_plus_d.? no%param))
   )
   :pattern ((curve25519_dalek!specs.lizard_specs.minvsqrt_one_plus_d.? no%param))
   :qid internal_curve25519_dalek!specs.lizard_specs.minvsqrt_one_plus_d.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.minvsqrt_one_plus_d.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::lizard_specs::midouble_invsqrt_a_minus_d
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.lizard_specs.midouble_invsqrt_a_minus_d.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.lizard_specs.midouble_invsqrt_a_minus_d.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!specs.lizard_specs.midouble_invsqrt_a_minus_d.? no%param) (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
      (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!lizard.u64_constants.MIDOUBLE_INVSQRT_A_MINUS_D.?)
    ))
    :pattern ((curve25519_dalek!specs.lizard_specs.midouble_invsqrt_a_minus_d.? no%param))
    :qid internal_curve25519_dalek!specs.lizard_specs.midouble_invsqrt_a_minus_d.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.midouble_invsqrt_a_minus_d.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (<= 0 (curve25519_dalek!specs.lizard_specs.midouble_invsqrt_a_minus_d.? no%param))
   )
   :pattern ((curve25519_dalek!specs.lizard_specs.midouble_invsqrt_a_minus_d.? no%param))
   :qid internal_curve25519_dalek!specs.lizard_specs.midouble_invsqrt_a_minus_d.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.midouble_invsqrt_a_minus_d.?_pre_post_definition
)))

;; Function-Specs curve25519_dalek::specs::lizard_specs::spec_to_jacobi_quartic_ristretto
(declare-fun req%curve25519_dalek!specs.lizard_specs.spec_to_jacobi_quartic_ristretto.
 (Poly) Bool
)
(declare-const %%global_location_label%%22 Bool)
(assert
 (forall ((point! Poly)) (!
   (= (req%curve25519_dalek!specs.lizard_specs.spec_to_jacobi_quartic_ristretto. point!)
    (=>
     %%global_location_label%%22
     (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? point!)
   ))
   :pattern ((req%curve25519_dalek!specs.lizard_specs.spec_to_jacobi_quartic_ristretto.
     point!
   ))
   :qid internal_req__curve25519_dalek!specs.lizard_specs.spec_to_jacobi_quartic_ristretto._definition
   :skolemid skolem_internal_req__curve25519_dalek!specs.lizard_specs.spec_to_jacobi_quartic_ristretto._definition
)))

;; Function-Axioms curve25519_dalek::specs::lizard_specs::spec_to_jacobi_quartic_ristretto
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.lizard_specs.spec_to_jacobi_quartic_ristretto.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.lizard_specs.spec_to_jacobi_quartic_ristretto.? point!)
     (%Poly%array%. (let
       ((tmp%%$ (curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.? point!)))
       (let
        ((xn$ (%I (tuple%4./tuple%4/0 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
        (let
         ((yn$ (%I (tuple%4./tuple%4/1 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
         (let
          ((zn$ (%I (tuple%4./tuple%4/2 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
          (let
           ((_tn$ (%I (tuple%4./tuple%4/3 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
           (let
            ((x2$ (curve25519_dalek!specs.field_specs.field_square.? (I xn$))))
            (let
             ((y2$ (curve25519_dalek!specs.field_specs.field_square.? (I yn$))))
             (let
              ((y4$ (curve25519_dalek!specs.field_specs.field_square.? (I y2$))))
              (let
               ((z2$ (curve25519_dalek!specs.field_specs.field_square.? (I zn$))))
               (let
                ((z_min_y$ (curve25519_dalek!specs.field_specs.field_sub.? (I zn$) (I yn$))))
                (let
                 ((z_pl_y$ (curve25519_dalek!specs.field_specs.field_add.? (I zn$) (I yn$))))
                 (let
                  ((z2_min_y2$ (curve25519_dalek!specs.field_specs.field_sub.? (I z2$) (I y2$))))
                  (let
                   ((gamma$ (curve25519_dalek!specs.field_specs.nat_invsqrt.? (I (curve25519_dalek!specs.field_specs.field_mul.?
                        (I (curve25519_dalek!specs.field_specs.field_mul.? (I y4$) (I x2$))) (I z2_min_y2$)
                   )))))
                   (let
                    ((den1$ (curve25519_dalek!specs.field_specs.field_mul.? (I gamma$) (I y2$))))
                    (let
                     ((s_over_x$ (curve25519_dalek!specs.field_specs.field_mul.? (I den1$) (I z_min_y$))))
                     (let
                      ((sp_over_xp$ (curve25519_dalek!specs.field_specs.field_mul.? (I den1$) (I z_pl_y$))))
                      (let
                       ((s0$ (curve25519_dalek!specs.field_specs.field_mul.? (I s_over_x$) (I xn$))))
                       (let
                        ((s1$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_neg.?
                             (I sp_over_xp$)
                            )
                           ) (I xn$)
                        )))
                        (let
                         ((ma$ (curve25519_dalek!specs.lizard_specs.mdouble_invsqrt_a_minus_d.? (I 0))))
                         (let
                          ((tmp1$ (curve25519_dalek!specs.field_specs.field_mul.? (I ma$) (I zn$))))
                          (let
                           ((t0_gen$ (curve25519_dalek!specs.field_specs.field_mul.? (I tmp1$) (I s_over_x$))))
                           (let
                            ((t1_gen$ (curve25519_dalek!specs.field_specs.field_mul.? (I tmp1$) (I sp_over_xp$))))
                            (let
                             ((neg_z2_min_y2$ (curve25519_dalek!specs.field_specs.field_neg.? (I z2_min_y2$))))
                             (let
                              ((mb$ (curve25519_dalek!specs.lizard_specs.minvsqrt_one_plus_d.? (I 0))))
                              (let
                               ((den2$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_mul.?
                                    (I neg_z2_min_y2$) (I mb$)
                                   )
                                  ) (I gamma$)
                               )))
                               (let
                                ((iz$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.sqrt_m1.?
                                     (I 0)
                                    )
                                   ) (I zn$)
                                )))
                                (let
                                 ((iz_min_x$ (curve25519_dalek!specs.field_specs.field_sub.? (I iz$) (I xn$))))
                                 (let
                                  ((iz_pl_x$ (curve25519_dalek!specs.field_specs.field_add.? (I iz$) (I xn$))))
                                  (let
                                   ((s_over_y$ (curve25519_dalek!specs.field_specs.field_mul.? (I den2$) (I iz_min_x$))))
                                   (let
                                    ((sp_over_yp$ (curve25519_dalek!specs.field_specs.field_mul.? (I den2$) (I iz_pl_x$))))
                                    (let
                                     ((s2_gen$ (curve25519_dalek!specs.field_specs.field_mul.? (I s_over_y$) (I yn$))))
                                     (let
                                      ((s3_gen$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_neg.?
                                           (I sp_over_yp$)
                                          )
                                         ) (I yn$)
                                      )))
                                      (let
                                       ((tmp2$ (curve25519_dalek!specs.field_specs.field_mul.? (I ma$) (I iz$))))
                                       (let
                                        ((t2_gen$ (curve25519_dalek!specs.field_specs.field_mul.? (I tmp2$) (I s_over_y$))))
                                        (let
                                         ((t3_gen$ (curve25519_dalek!specs.field_specs.field_mul.? (I tmp2$) (I sp_over_yp$))))
                                         (let
                                          ((x_or_y_zero$ (or
                                             (= xn$ 0)
                                             (= yn$ 0)
                                          )))
                                          (let
                                           ((mc$ (curve25519_dalek!specs.lizard_specs.midouble_invsqrt_a_minus_d.? (I 0))))
                                           (let
                                            ((t0$ (ite
                                               x_or_y_zero$
                                               1
                                               t0_gen$
                                            )))
                                            (let
                                             ((t1$ (ite
                                                x_or_y_zero$
                                                1
                                                t1_gen$
                                             )))
                                             (let
                                              ((t2$ (ite
                                                 x_or_y_zero$
                                                 mc$
                                                 t2_gen$
                                              )))
                                              (let
                                               ((t3$ (ite
                                                  x_or_y_zero$
                                                  mc$
                                                  t3_gen$
                                               )))
                                               (let
                                                ((s2$ (ite
                                                   x_or_y_zero$
                                                   1
                                                   s2_gen$
                                                )))
                                                (let
                                                 ((s3$ (ite
                                                    x_or_y_zero$
                                                    (curve25519_dalek!specs.field_specs.field_neg.? (I 1))
                                                    s3_gen$
                                                 )))
                                                 (array_new (DST $) (TYPE%tuple%2. $ NAT $ NAT) 4 (%%array%%1 (Poly%tuple%2. (tuple%2./tuple%2
                                                     (I s0$) (I t0$)
                                                    )
                                                   ) (Poly%tuple%2. (tuple%2./tuple%2 (I s1$) (I t1$))) (Poly%tuple%2. (tuple%2./tuple%2
                                                     (I s2$) (I t2$)
                                                    )
                                                   ) (Poly%tuple%2. (tuple%2./tuple%2 (I s3$) (I t3$)))
    )))))))))))))))))))))))))))))))))))))))))))))))
    :pattern ((curve25519_dalek!specs.lizard_specs.spec_to_jacobi_quartic_ristretto.? point!))
    :qid internal_curve25519_dalek!specs.lizard_specs.spec_to_jacobi_quartic_ristretto.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.spec_to_jacobi_quartic_ristretto.?_definition
))))
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%array%. (curve25519_dalek!specs.lizard_specs.spec_to_jacobi_quartic_ristretto.?
       point!
      )
     ) (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4))
   ))
   :pattern ((curve25519_dalek!specs.lizard_specs.spec_to_jacobi_quartic_ristretto.? point!))
   :qid internal_curve25519_dalek!specs.lizard_specs.spec_to_jacobi_quartic_ristretto.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.spec_to_jacobi_quartic_ristretto.?_pre_post_definition
)))

;; Function-Specs curve25519_dalek::specs::lizard_specs::spec_lizard_decode_candidates
(declare-fun req%curve25519_dalek!specs.lizard_specs.spec_lizard_decode_candidates.
 (Poly) Bool
)
(declare-const %%global_location_label%%23 Bool)
(assert
 (forall ((point! Poly)) (!
   (= (req%curve25519_dalek!specs.lizard_specs.spec_lizard_decode_candidates. point!)
    (=>
     %%global_location_label%%23
     (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? point!)
   ))
   :pattern ((req%curve25519_dalek!specs.lizard_specs.spec_lizard_decode_candidates. point!))
   :qid internal_req__curve25519_dalek!specs.lizard_specs.spec_lizard_decode_candidates._definition
   :skolemid skolem_internal_req__curve25519_dalek!specs.lizard_specs.spec_lizard_decode_candidates._definition
)))

;; Function-Axioms curve25519_dalek::specs::lizard_specs::spec_lizard_decode_candidates
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.lizard_specs.spec_lizard_decode_candidates.)
)
(declare-fun %%array%%3 (Poly Poly Poly Poly Poly Poly Poly Poly) %%Function%%)
(assert
 (forall ((%%hole%%0 Poly) (%%hole%%1 Poly) (%%hole%%2 Poly) (%%hole%%3 Poly) (%%hole%%4
    Poly
   ) (%%hole%%5 Poly) (%%hole%%6 Poly) (%%hole%%7 Poly)
  ) (!
   (let
    ((%%x%% (%%array%%3 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4 %%hole%%5 %%hole%%6
       %%hole%%7
    )))
    (and
     (= (%%apply%%1 %%x%% 0) %%hole%%0)
     (= (%%apply%%1 %%x%% 1) %%hole%%1)
     (= (%%apply%%1 %%x%% 2) %%hole%%2)
     (= (%%apply%%1 %%x%% 3) %%hole%%3)
     (= (%%apply%%1 %%x%% 4) %%hole%%4)
     (= (%%apply%%1 %%x%% 5) %%hole%%5)
     (= (%%apply%%1 %%x%% 6) %%hole%%6)
     (= (%%apply%%1 %%x%% 7) %%hole%%7)
   ))
   :pattern ((%%array%%3 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4 %%hole%%5 %%hole%%6
     %%hole%%7
   ))
   :qid __AIR_ARRAY_QID__
   :skolemid skolem___AIR_ARRAY_QID__
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.lizard_specs.spec_lizard_decode_candidates.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.lizard_specs.spec_lizard_decode_candidates.? point!) (%Poly%array%.
      (let
       ((jcs$ (curve25519_dalek!specs.lizard_specs.spec_to_jacobi_quartic_ristretto.? point!)))
       (array_new (DST $) (TYPE%tuple%2. $ BOOL $ NAT) 8 (%%array%%3 (Poly%tuple%2. (curve25519_dalek!specs.lizard_specs.spec_elligator_inv.?
           (tuple%2./tuple%2/0 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT
               $ NAT
              ) (vstd!view.View.view.? $ (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4))
               (Poly%array%. jcs$)
              ) (I 0)
            ))
           ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $
               NAT $ NAT
              ) (vstd!view.View.view.? $ (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4))
               (Poly%array%. jcs$)
              ) (I 0)
          ))))
         ) (Poly%tuple%2. (curve25519_dalek!specs.lizard_specs.spec_elligator_inv.? (I (curve25519_dalek!specs.field_specs.field_neg.?
             (tuple%2./tuple%2/0 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT
                 $ NAT
                ) (vstd!view.View.view.? $ (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4))
                 (Poly%array%. jcs$)
                ) (I 0)
            ))))
           ) (I (curve25519_dalek!specs.field_specs.field_neg.? (tuple%2./tuple%2/1 (%Poly%tuple%2.
               (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (vstd!view.View.view.? $
                 (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4)) (Poly%array%. jcs$)
                ) (I 0)
          ))))))
         ) (Poly%tuple%2. (curve25519_dalek!specs.lizard_specs.spec_elligator_inv.? (tuple%2./tuple%2/0
            (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (vstd!view.View.view.?
               $ (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4)) (Poly%array%. jcs$)
              ) (I 1)
            ))
           ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $
               NAT $ NAT
              ) (vstd!view.View.view.? $ (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4))
               (Poly%array%. jcs$)
              ) (I 1)
          ))))
         ) (Poly%tuple%2. (curve25519_dalek!specs.lizard_specs.spec_elligator_inv.? (I (curve25519_dalek!specs.field_specs.field_neg.?
             (tuple%2./tuple%2/0 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT
                 $ NAT
                ) (vstd!view.View.view.? $ (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4))
                 (Poly%array%. jcs$)
                ) (I 1)
            ))))
           ) (I (curve25519_dalek!specs.field_specs.field_neg.? (tuple%2./tuple%2/1 (%Poly%tuple%2.
               (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (vstd!view.View.view.? $
                 (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4)) (Poly%array%. jcs$)
                ) (I 1)
          ))))))
         ) (Poly%tuple%2. (curve25519_dalek!specs.lizard_specs.spec_elligator_inv.? (tuple%2./tuple%2/0
            (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (vstd!view.View.view.?
               $ (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4)) (Poly%array%. jcs$)
              ) (I 2)
            ))
           ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $
               NAT $ NAT
              ) (vstd!view.View.view.? $ (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4))
               (Poly%array%. jcs$)
              ) (I 2)
          ))))
         ) (Poly%tuple%2. (curve25519_dalek!specs.lizard_specs.spec_elligator_inv.? (I (curve25519_dalek!specs.field_specs.field_neg.?
             (tuple%2./tuple%2/0 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT
                 $ NAT
                ) (vstd!view.View.view.? $ (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4))
                 (Poly%array%. jcs$)
                ) (I 2)
            ))))
           ) (I (curve25519_dalek!specs.field_specs.field_neg.? (tuple%2./tuple%2/1 (%Poly%tuple%2.
               (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (vstd!view.View.view.? $
                 (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4)) (Poly%array%. jcs$)
                ) (I 2)
          ))))))
         ) (Poly%tuple%2. (curve25519_dalek!specs.lizard_specs.spec_elligator_inv.? (tuple%2./tuple%2/0
            (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (vstd!view.View.view.?
               $ (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4)) (Poly%array%. jcs$)
              ) (I 3)
            ))
           ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $
               NAT $ NAT
              ) (vstd!view.View.view.? $ (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4))
               (Poly%array%. jcs$)
              ) (I 3)
          ))))
         ) (Poly%tuple%2. (curve25519_dalek!specs.lizard_specs.spec_elligator_inv.? (I (curve25519_dalek!specs.field_specs.field_neg.?
             (tuple%2./tuple%2/0 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT
                 $ NAT
                ) (vstd!view.View.view.? $ (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4))
                 (Poly%array%. jcs$)
                ) (I 3)
            ))))
           ) (I (curve25519_dalek!specs.field_specs.field_neg.? (tuple%2./tuple%2/1 (%Poly%tuple%2.
               (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (vstd!view.View.view.? $
                 (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4)) (Poly%array%. jcs$)
                ) (I 3)
    ))))))))))))
    :pattern ((curve25519_dalek!specs.lizard_specs.spec_lizard_decode_candidates.? point!))
    :qid internal_curve25519_dalek!specs.lizard_specs.spec_lizard_decode_candidates.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.spec_lizard_decode_candidates.?_definition
))))
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%array%. (curve25519_dalek!specs.lizard_specs.spec_lizard_decode_candidates.?
       point!
      )
     ) (ARRAY (DST $) (TYPE%tuple%2. $ BOOL $ NAT) $ (CONST_INT 8))
   ))
   :pattern ((curve25519_dalek!specs.lizard_specs.spec_lizard_decode_candidates.? point!))
   :qid internal_curve25519_dalek!specs.lizard_specs.spec_lizard_decode_candidates.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.spec_lizard_decode_candidates.?_pre_post_definition
)))

;; Function-Specs curve25519_dalek::specs::lizard_specs::spec_candidate_sha_consistent
(declare-fun req%curve25519_dalek!specs.lizard_specs.spec_candidate_sha_consistent.
 (Poly) Bool
)
(declare-const %%global_location_label%%24 Bool)
(assert
 (forall ((r! Poly)) (!
   (= (req%curve25519_dalek!specs.lizard_specs.spec_candidate_sha_consistent. r!) (=>
     %%global_location_label%%24
     (< (%I r!) (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
   ))
   :pattern ((req%curve25519_dalek!specs.lizard_specs.spec_candidate_sha_consistent. r!))
   :qid internal_req__curve25519_dalek!specs.lizard_specs.spec_candidate_sha_consistent._definition
   :skolemid skolem_internal_req__curve25519_dalek!specs.lizard_specs.spec_candidate_sha_consistent._definition
)))

;; Function-Axioms curve25519_dalek::specs::lizard_specs::spec_candidate_sha_consistent
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.lizard_specs.spec_candidate_sha_consistent.)
)
(declare-fun %%lambda%%2 (Int Dcr Type Poly) %%Function%%)
(assert
 (forall ((%%hole%%0 Int) (%%hole%%1 Dcr) (%%hole%%2 Type) (%%hole%%3 Poly) (i$ Poly))
  (!
   (= (%%apply%%0 (%%lambda%%2 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3) i$) (vstd!seq.Seq.index.?
     %%hole%%1 %%hole%%2 %%hole%%3 (I (Add %%hole%%0 (%I i$)))
   ))
   :pattern ((%%apply%%0 (%%lambda%%2 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3) i$))
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.lizard_specs.spec_candidate_sha_consistent.)
  (forall ((r! Poly)) (!
    (= (curve25519_dalek!specs.lizard_specs.spec_candidate_sha_consistent.? r!) (let
      ((b$ (curve25519_dalek!specs.field_specs.u8_32_from_nat.? r!)))
      (let
       ((msg$ (%Poly%vstd!seq.Seq<u8.>. (vstd!seq.Seq.new.? $ (UINT 8) $ (TYPE%fun%1. $ INT $
            (UINT 8)
           ) (I 16) (Poly%fun%1. (mk_fun (%%lambda%%2 8 $ (UINT 8) (vstd!view.View.view.? $ (ARRAY
                $ (UINT 8) $ (CONST_INT 32)
               ) (Poly%array%. b$)
       ))))))))
       (= b$ (curve25519_dalek!specs.lizard_specs.spec_lizard_fe_bytes.? (Poly%vstd!seq.Seq<u8.>.
          msg$
    ))))))
    :pattern ((curve25519_dalek!specs.lizard_specs.spec_candidate_sha_consistent.? r!))
    :qid internal_curve25519_dalek!specs.lizard_specs.spec_candidate_sha_consistent.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.spec_candidate_sha_consistent.?_definition
))))

;; Function-Specs curve25519_dalek::specs::lizard_specs::spec_sha_consistent_count
(declare-fun req%curve25519_dalek!specs.lizard_specs.spec_sha_consistent_count. (Poly)
 Bool
)
(declare-const %%global_location_label%%25 Bool)
(assert
 (forall ((point! Poly)) (!
   (= (req%curve25519_dalek!specs.lizard_specs.spec_sha_consistent_count. point!) (=>
     %%global_location_label%%25
     (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? point!)
   ))
   :pattern ((req%curve25519_dalek!specs.lizard_specs.spec_sha_consistent_count. point!))
   :qid internal_req__curve25519_dalek!specs.lizard_specs.spec_sha_consistent_count._definition
   :skolemid skolem_internal_req__curve25519_dalek!specs.lizard_specs.spec_sha_consistent_count._definition
)))

;; Function-Axioms curve25519_dalek::specs::lizard_specs::spec_sha_consistent_count
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.lizard_specs.spec_sha_consistent_count.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.lizard_specs.spec_sha_consistent_count.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.lizard_specs.spec_sha_consistent_count.? point!) (let
      ((c$ (curve25519_dalek!specs.lizard_specs.spec_lizard_decode_candidates.? point!)))
      (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (ite
                     (and
                      (%B (tuple%2./tuple%2/0 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $
                           BOOL $ NAT
                          ) (vstd!view.View.view.? $ (ARRAY (DST $) (TYPE%tuple%2. $ BOOL $ NAT) $ (CONST_INT
                             8
                            )
                           ) (Poly%array%. c$)
                          ) (I 0)
                      ))))
                      (curve25519_dalek!specs.lizard_specs.spec_candidate_sha_consistent.? (tuple%2./tuple%2/1
                        (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ BOOL $ NAT) (vstd!view.View.view.?
                           $ (ARRAY (DST $) (TYPE%tuple%2. $ BOOL $ NAT) $ (CONST_INT 8)) (Poly%array%. c$)
                          ) (I 0)
                     )))))
                     1
                     0
                    ) (ite
                     (and
                      (%B (tuple%2./tuple%2/0 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $
                           BOOL $ NAT
                          ) (vstd!view.View.view.? $ (ARRAY (DST $) (TYPE%tuple%2. $ BOOL $ NAT) $ (CONST_INT
                             8
                            )
                           ) (Poly%array%. c$)
                          ) (I 1)
                      ))))
                      (curve25519_dalek!specs.lizard_specs.spec_candidate_sha_consistent.? (tuple%2./tuple%2/1
                        (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ BOOL $ NAT) (vstd!view.View.view.?
                           $ (ARRAY (DST $) (TYPE%tuple%2. $ BOOL $ NAT) $ (CONST_INT 8)) (Poly%array%. c$)
                          ) (I 1)
                     )))))
                     1
                     0
                   ))
                  ) (ite
                   (and
                    (%B (tuple%2./tuple%2/0 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $
                         BOOL $ NAT
                        ) (vstd!view.View.view.? $ (ARRAY (DST $) (TYPE%tuple%2. $ BOOL $ NAT) $ (CONST_INT
                           8
                          )
                         ) (Poly%array%. c$)
                        ) (I 2)
                    ))))
                    (curve25519_dalek!specs.lizard_specs.spec_candidate_sha_consistent.? (tuple%2./tuple%2/1
                      (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ BOOL $ NAT) (vstd!view.View.view.?
                         $ (ARRAY (DST $) (TYPE%tuple%2. $ BOOL $ NAT) $ (CONST_INT 8)) (Poly%array%. c$)
                        ) (I 2)
                   )))))
                   1
                   0
                 ))
                ) (ite
                 (and
                  (%B (tuple%2./tuple%2/0 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $
                       BOOL $ NAT
                      ) (vstd!view.View.view.? $ (ARRAY (DST $) (TYPE%tuple%2. $ BOOL $ NAT) $ (CONST_INT
                         8
                        )
                       ) (Poly%array%. c$)
                      ) (I 3)
                  ))))
                  (curve25519_dalek!specs.lizard_specs.spec_candidate_sha_consistent.? (tuple%2./tuple%2/1
                    (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ BOOL $ NAT) (vstd!view.View.view.?
                       $ (ARRAY (DST $) (TYPE%tuple%2. $ BOOL $ NAT) $ (CONST_INT 8)) (Poly%array%. c$)
                      ) (I 3)
                 )))))
                 1
                 0
               ))
              ) (ite
               (and
                (%B (tuple%2./tuple%2/0 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $
                     BOOL $ NAT
                    ) (vstd!view.View.view.? $ (ARRAY (DST $) (TYPE%tuple%2. $ BOOL $ NAT) $ (CONST_INT
                       8
                      )
                     ) (Poly%array%. c$)
                    ) (I 4)
                ))))
                (curve25519_dalek!specs.lizard_specs.spec_candidate_sha_consistent.? (tuple%2./tuple%2/1
                  (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ BOOL $ NAT) (vstd!view.View.view.?
                     $ (ARRAY (DST $) (TYPE%tuple%2. $ BOOL $ NAT) $ (CONST_INT 8)) (Poly%array%. c$)
                    ) (I 4)
               )))))
               1
               0
             ))
            ) (ite
             (and
              (%B (tuple%2./tuple%2/0 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $
                   BOOL $ NAT
                  ) (vstd!view.View.view.? $ (ARRAY (DST $) (TYPE%tuple%2. $ BOOL $ NAT) $ (CONST_INT
                     8
                    )
                   ) (Poly%array%. c$)
                  ) (I 5)
              ))))
              (curve25519_dalek!specs.lizard_specs.spec_candidate_sha_consistent.? (tuple%2./tuple%2/1
                (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ BOOL $ NAT) (vstd!view.View.view.?
                   $ (ARRAY (DST $) (TYPE%tuple%2. $ BOOL $ NAT) $ (CONST_INT 8)) (Poly%array%. c$)
                  ) (I 5)
             )))))
             1
             0
           ))
          ) (ite
           (and
            (%B (tuple%2./tuple%2/0 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $
                 BOOL $ NAT
                ) (vstd!view.View.view.? $ (ARRAY (DST $) (TYPE%tuple%2. $ BOOL $ NAT) $ (CONST_INT
                   8
                  )
                 ) (Poly%array%. c$)
                ) (I 6)
            ))))
            (curve25519_dalek!specs.lizard_specs.spec_candidate_sha_consistent.? (tuple%2./tuple%2/1
              (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ BOOL $ NAT) (vstd!view.View.view.?
                 $ (ARRAY (DST $) (TYPE%tuple%2. $ BOOL $ NAT) $ (CONST_INT 8)) (Poly%array%. c$)
                ) (I 6)
           )))))
           1
           0
         ))
        ) (ite
         (and
          (%B (tuple%2./tuple%2/0 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $
               BOOL $ NAT
              ) (vstd!view.View.view.? $ (ARRAY (DST $) (TYPE%tuple%2. $ BOOL $ NAT) $ (CONST_INT
                 8
                )
               ) (Poly%array%. c$)
              ) (I 7)
          ))))
          (curve25519_dalek!specs.lizard_specs.spec_candidate_sha_consistent.? (tuple%2./tuple%2/1
            (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ BOOL $ NAT) (vstd!view.View.view.?
               $ (ARRAY (DST $) (TYPE%tuple%2. $ BOOL $ NAT) $ (CONST_INT 8)) (Poly%array%. c$)
              ) (I 7)
         )))))
         1
         0
    )))))
    :pattern ((curve25519_dalek!specs.lizard_specs.spec_sha_consistent_count.? point!))
    :qid internal_curve25519_dalek!specs.lizard_specs.spec_sha_consistent_count.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.spec_sha_consistent_count.?_definition
))))
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (<= 0 (curve25519_dalek!specs.lizard_specs.spec_sha_consistent_count.? point!))
   )
   :pattern ((curve25519_dalek!specs.lizard_specs.spec_sha_consistent_count.? point!))
   :qid internal_curve25519_dalek!specs.lizard_specs.spec_sha_consistent_count.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.spec_sha_consistent_count.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::lizard_specs::partial_sha_consistent_count
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.lizard_specs.partial_sha_consistent_count.)
)
(declare-const fuel_nat%curve25519_dalek!specs.lizard_specs.partial_sha_consistent_count.
 Fuel
)
(assert
 (forall ((candidates! Poly) (j! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!specs.lizard_specs.rec%partial_sha_consistent_count.? candidates!
     j! fuel%
    ) (curve25519_dalek!specs.lizard_specs.rec%partial_sha_consistent_count.? candidates!
     j! zero
   ))
   :pattern ((curve25519_dalek!specs.lizard_specs.rec%partial_sha_consistent_count.? candidates!
     j! fuel%
   ))
   :qid internal_curve25519_dalek!specs.lizard_specs.partial_sha_consistent_count._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.partial_sha_consistent_count._fuel_to_zero_definition
)))
(assert
 (forall ((candidates! Poly) (j! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type candidates! (ARRAY (DST $) (TYPE%tuple%2. $ BOOL $ NAT) $ (CONST_INT 8)))
     (has_type j! INT)
    )
    (= (curve25519_dalek!specs.lizard_specs.rec%partial_sha_consistent_count.? candidates!
      j! (succ fuel%)
     ) (ite
      (<= (%I j!) 0)
      0
      (nClip (Add (curve25519_dalek!specs.lizard_specs.rec%partial_sha_consistent_count.?
         candidates! (I (Sub (%I j!) 1)) fuel%
        ) (ite
         (and
          (%B (tuple%2./tuple%2/0 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $
               BOOL $ NAT
              ) (vstd!view.View.view.? $ (ARRAY (DST $) (TYPE%tuple%2. $ BOOL $ NAT) $ (CONST_INT
                 8
                )
               ) candidates!
              ) (I (Sub (%I j!) 1))
          ))))
          (curve25519_dalek!specs.lizard_specs.spec_candidate_sha_consistent.? (tuple%2./tuple%2/1
            (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ BOOL $ NAT) (vstd!view.View.view.?
               $ (ARRAY (DST $) (TYPE%tuple%2. $ BOOL $ NAT) $ (CONST_INT 8)) candidates!
              ) (I (Sub (%I j!) 1))
         )))))
         1
         0
   ))))))
   :pattern ((curve25519_dalek!specs.lizard_specs.rec%partial_sha_consistent_count.? candidates!
     j! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!specs.lizard_specs.partial_sha_consistent_count._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.partial_sha_consistent_count._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.lizard_specs.partial_sha_consistent_count.)
  (forall ((candidates! Poly) (j! Poly)) (!
    (=>
     (and
      (has_type candidates! (ARRAY (DST $) (TYPE%tuple%2. $ BOOL $ NAT) $ (CONST_INT 8)))
      (has_type j! INT)
     )
     (= (curve25519_dalek!specs.lizard_specs.partial_sha_consistent_count.? candidates!
       j!
      ) (curve25519_dalek!specs.lizard_specs.rec%partial_sha_consistent_count.? candidates!
       j! (succ fuel_nat%curve25519_dalek!specs.lizard_specs.partial_sha_consistent_count.)
    )))
    :pattern ((curve25519_dalek!specs.lizard_specs.partial_sha_consistent_count.? candidates!
      j!
    ))
    :qid internal_curve25519_dalek!specs.lizard_specs.partial_sha_consistent_count.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.partial_sha_consistent_count.?_definition
))))
(assert
 (forall ((candidates! Poly) (j! Poly)) (!
   (=>
    (and
     (has_type candidates! (ARRAY (DST $) (TYPE%tuple%2. $ BOOL $ NAT) $ (CONST_INT 8)))
     (has_type j! INT)
    )
    (<= 0 (curve25519_dalek!specs.lizard_specs.partial_sha_consistent_count.? candidates!
      j!
   )))
   :pattern ((curve25519_dalek!specs.lizard_specs.partial_sha_consistent_count.? candidates!
     j!
   ))
   :qid internal_curve25519_dalek!specs.lizard_specs.partial_sha_consistent_count.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.partial_sha_consistent_count.?_pre_post_definition
)))
(assert
 (forall ((candidates! Poly) (j! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type candidates! (ARRAY (DST $) (TYPE%tuple%2. $ BOOL $ NAT) $ (CONST_INT 8)))
     (has_type j! INT)
    )
    (<= 0 (curve25519_dalek!specs.lizard_specs.rec%partial_sha_consistent_count.? candidates!
      j! fuel%
   )))
   :pattern ((curve25519_dalek!specs.lizard_specs.rec%partial_sha_consistent_count.? candidates!
     j! fuel%
   ))
   :qid internal_curve25519_dalek!specs.lizard_specs.rec__partial_sha_consistent_count.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.rec__partial_sha_consistent_count.?_pre_post_rec_definition
)))

;; Function-Specs curve25519_dalek::specs::lizard_specs::is_lizard_preimage_coset
(declare-fun req%curve25519_dalek!specs.lizard_specs.is_lizard_preimage_coset. (Poly
  Poly
 ) Bool
)
(declare-const %%global_location_label%%26 Bool)
(assert
 (forall ((data! Poly) (coset! Poly)) (!
   (= (req%curve25519_dalek!specs.lizard_specs.is_lizard_preimage_coset. data! coset!)
    (=>
     %%global_location_label%%26
     (= (vstd!seq.Seq.len.? $ (UINT 8) data!) 16)
   ))
   :pattern ((req%curve25519_dalek!specs.lizard_specs.is_lizard_preimage_coset. data!
     coset!
   ))
   :qid internal_req__curve25519_dalek!specs.lizard_specs.is_lizard_preimage_coset._definition
   :skolemid skolem_internal_req__curve25519_dalek!specs.lizard_specs.is_lizard_preimage_coset._definition
)))

;; Function-Axioms curve25519_dalek::specs::lizard_specs::is_lizard_preimage_coset
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.lizard_specs.is_lizard_preimage_coset.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.lizard_specs.is_lizard_preimage_coset.)
  (forall ((data! Poly) (coset! Poly)) (!
    (= (curve25519_dalek!specs.lizard_specs.is_lizard_preimage_coset.? data! coset!) (
      let
      ((enc$ (curve25519_dalek!specs.lizard_specs.spec_lizard_encode.? data!)))
      (or
       (or
        (or
         (= enc$ (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (vstd!view.View.view.?
             $ (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4)) coset!
            ) (I 0)
         )))
         (= enc$ (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (vstd!view.View.view.?
             $ (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4)) coset!
            ) (I 1)
        ))))
        (= enc$ (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (vstd!view.View.view.?
            $ (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4)) coset!
           ) (I 2)
       ))))
       (= enc$ (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (vstd!view.View.view.?
           $ (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4)) coset!
          ) (I 3)
    ))))))
    :pattern ((curve25519_dalek!specs.lizard_specs.is_lizard_preimage_coset.? data! coset!))
    :qid internal_curve25519_dalek!specs.lizard_specs.is_lizard_preimage_coset.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.is_lizard_preimage_coset.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::lizard_specs::lizard_ristretto_has_unique_preimage
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.lizard_specs.lizard_ristretto_has_unique_preimage.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.lizard_specs.lizard_ristretto_has_unique_preimage.)
  (forall ((x! Poly) (y! Poly)) (!
    (= (curve25519_dalek!specs.lizard_specs.lizard_ristretto_has_unique_preimage.? x! y!)
     (let
      ((coset$ (curve25519_dalek!specs.ristretto_specs.ristretto_coset_affine.? x! y!)))
      (exists ((data$ Poly)) (!
        (and
         (has_type data$ (TYPE%vstd!seq.Seq. $ (UINT 8)))
         (and
          (and
           (= (vstd!seq.Seq.len.? $ (UINT 8) data$) 16)
           (curve25519_dalek!specs.lizard_specs.is_lizard_preimage_coset.? data$ (Poly%array%.
             coset$
          )))
          (forall ((data2$ Poly)) (!
            (=>
             (has_type data2$ (TYPE%vstd!seq.Seq. $ (UINT 8)))
             (=>
              (and
               (= (vstd!seq.Seq.len.? $ (UINT 8) data2$) 16)
               (curve25519_dalek!specs.lizard_specs.is_lizard_preimage_coset.? data2$ (Poly%array%.
                 coset$
              )))
              (= data2$ data$)
            ))
            :pattern ((curve25519_dalek!specs.lizard_specs.is_lizard_preimage_coset.? data2$ (Poly%array%.
               coset$
            )))
            :qid user_curve25519_dalek__specs__lizard_specs__lizard_ristretto_has_unique_preimage_31
            :skolemid skolem_user_curve25519_dalek__specs__lizard_specs__lizard_ristretto_has_unique_preimage_31
        ))))
        :pattern ((curve25519_dalek!specs.lizard_specs.is_lizard_preimage_coset.? data$ (Poly%array%.
           coset$
        )))
        :qid user_curve25519_dalek__specs__lizard_specs__lizard_ristretto_has_unique_preimage_32
        :skolemid skolem_user_curve25519_dalek__specs__lizard_specs__lizard_ristretto_has_unique_preimage_32
    ))))
    :pattern ((curve25519_dalek!specs.lizard_specs.lizard_ristretto_has_unique_preimage.?
      x! y!
    ))
    :qid internal_curve25519_dalek!specs.lizard_specs.lizard_ristretto_has_unique_preimage.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.lizard_specs.lizard_ristretto_has_unique_preimage.?_definition
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
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%vstd!view.View. $ (TYPE%core!option.Option. T&. T&))
   )
   :pattern ((tr_bound%vstd!view.View. $ (TYPE%core!option.Option. T&. T&)))
   :qid internal_vstd__view__impl&__10_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__10_trait_impl_definition
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
 (tr_bound%vstd!view.View. $ (SINT 32))
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
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type)) (!
   (=>
    (and
     (sized A0&.)
     (sized A1&.)
     (sized A2&.)
     (tr_bound%vstd!view.View. A0&. A0&)
     (tr_bound%vstd!view.View. A1&. A1&)
     (tr_bound%vstd!view.View. A2&. A2&)
    )
    (tr_bound%vstd!view.View. (DST A2&.) (TYPE%tuple%3. A0&. A0& A1&. A1& A2&. A2&))
   )
   :pattern ((tr_bound%vstd!view.View. (DST A2&.) (TYPE%tuple%3. A0&. A0& A1&. A1& A2&.
      A2&
   )))
   :qid internal_vstd__view__impl&__46_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__46_trait_impl_definition
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

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_u8_32_as_nat_equals_rec
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_equals_rec.
 (%%Function%%) Bool
)
(assert
 (forall ((bytes! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_equals_rec.
     bytes!
    ) (= (curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly%array%. bytes!)) (curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.?
      (Poly%array%. bytes!) (I 0)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_equals_rec.
     bytes!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_equals_rec._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_equals_rec._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_decomposition_prefix_rec
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_decomposition_prefix_rec.
 (%%Function%% Int) Bool
)
(declare-const %%global_location_label%%27 Bool)
(assert
 (forall ((bytes! %%Function%%) (n! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_decomposition_prefix_rec.
     bytes! n!
    ) (=>
     %%global_location_label%%27
     (<= n! 32)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_decomposition_prefix_rec.
     bytes! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_decomposition_prefix_rec._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_decomposition_prefix_rec._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_decomposition_prefix_rec.
 (%%Function%% Int) Bool
)
(assert
 (forall ((bytes! %%Function%%) (n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_decomposition_prefix_rec.
     bytes! n!
    ) (= (curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.? (Poly%array%. bytes!) (I
       0
      )
     ) (nClip (Add (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (vstd!view.View.view.?
         $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%. bytes!)
        ) (I n!)
       ) (curve25519_dalek!specs.core_specs.u8_32_as_nat_rec.? (Poly%array%. bytes!) (I n!))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_decomposition_prefix_rec.
     bytes! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_decomposition_prefix_rec._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_decomposition_prefix_rec._definition
)))

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

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::from_bytes_lemmas::lemma_from_u8_32_as_nat
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.from_bytes_lemmas.lemma_from_u8_32_as_nat.
 (%%Function%%) Bool
)
(assert
 (forall ((bytes! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.from_bytes_lemmas.lemma_from_u8_32_as_nat.
     bytes!
    ) (= (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (array_new $ (UINT 64) 5
       (%%array%%0 (I (uClip 64 (bitand (I (uClip 64 (curve25519_dalek!specs.core_specs.spec_load8_at.?
              (vstd!array.spec_array_as_slice.? $ (UINT 8) $ (CONST_INT 32) (Poly%array%. bytes!))
              (I 0)
            ))
           ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
         ))
        ) (I (uClip 64 (bitand (I (uClip 64 (bitshr (I (uClip 64 (curve25519_dalek!specs.core_specs.spec_load8_at.?
                 (vstd!array.spec_array_as_slice.? $ (UINT 8) $ (CONST_INT 32) (Poly%array%. bytes!))
                 (I 6)
               ))
              ) (I 3)
            ))
           ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
         ))
        ) (I (uClip 64 (bitand (I (uClip 64 (bitshr (I (uClip 64 (curve25519_dalek!specs.core_specs.spec_load8_at.?
                 (vstd!array.spec_array_as_slice.? $ (UINT 8) $ (CONST_INT 32) (Poly%array%. bytes!))
                 (I 12)
               ))
              ) (I 6)
            ))
           ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
         ))
        ) (I (uClip 64 (bitand (I (uClip 64 (bitshr (I (uClip 64 (curve25519_dalek!specs.core_specs.spec_load8_at.?
                 (vstd!array.spec_array_as_slice.? $ (UINT 8) $ (CONST_INT 32) (Poly%array%. bytes!))
                 (I 19)
               ))
              ) (I 1)
            ))
           ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
         ))
        ) (I (uClip 64 (bitand (I (uClip 64 (bitshr (I (uClip 64 (curve25519_dalek!specs.core_specs.spec_load8_at.?
                 (vstd!array.spec_array_as_slice.? $ (UINT 8) $ (CONST_INT 32) (Poly%array%. bytes!))
                 (I 24)
               ))
              ) (I 12)
            ))
           ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
      )))))
     ) (Add (Add (Add (Add (Add (Add (Add (Add (Add (Add (Add (Add (Add (Add (Add (Add (Add (Add (Add (Add
                         (Add (Add (Add (Add (Add (Add (Add (Add (Add (Add (Add (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8)
                                       (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%. bytes!))
                                       (I 0)
                                      )
                                     ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 0 8))))
                                    ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                         $ (CONST_INT 32)
                                        ) (Poly%array%. bytes!)
                                       ) (I 1)
                                      )
                                     ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 1 8))))
                                    )
                                   ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                        $ (CONST_INT 32)
                                       ) (Poly%array%. bytes!)
                                      ) (I 2)
                                     )
                                    ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 2 8))))
                                   )
                                  ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                       $ (CONST_INT 32)
                                      ) (Poly%array%. bytes!)
                                     ) (I 3)
                                    )
                                   ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 3 8))))
                                  )
                                 ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                      $ (CONST_INT 32)
                                     ) (Poly%array%. bytes!)
                                    ) (I 4)
                                   )
                                  ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 4 8))))
                                 )
                                ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                     $ (CONST_INT 32)
                                    ) (Poly%array%. bytes!)
                                   ) (I 5)
                                  )
                                 ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 5 8))))
                                )
                               ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                    $ (CONST_INT 32)
                                   ) (Poly%array%. bytes!)
                                  ) (I 6)
                                 )
                                ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 6 8))))
                               )
                              ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                   $ (CONST_INT 32)
                                  ) (Poly%array%. bytes!)
                                 ) (I 7)
                                )
                               ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 7 8))))
                              )
                             ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                  $ (CONST_INT 32)
                                 ) (Poly%array%. bytes!)
                                ) (I 8)
                               )
                              ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 8 8))))
                             )
                            ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                 $ (CONST_INT 32)
                                ) (Poly%array%. bytes!)
                               ) (I 9)
                              )
                             ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 9 8))))
                            )
                           ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                $ (CONST_INT 32)
                               ) (Poly%array%. bytes!)
                              ) (I 10)
                             )
                            ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 10 8))))
                           )
                          ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                               $ (CONST_INT 32)
                              ) (Poly%array%. bytes!)
                             ) (I 11)
                            )
                           ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 11 8))))
                          )
                         ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                              $ (CONST_INT 32)
                             ) (Poly%array%. bytes!)
                            ) (I 12)
                           )
                          ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 12 8))))
                         )
                        ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                             $ (CONST_INT 32)
                            ) (Poly%array%. bytes!)
                           ) (I 13)
                          )
                         ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 13 8))))
                        )
                       ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                            $ (CONST_INT 32)
                           ) (Poly%array%. bytes!)
                          ) (I 14)
                         )
                        ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 14 8))))
                       )
                      ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                           $ (CONST_INT 32)
                          ) (Poly%array%. bytes!)
                         ) (I 15)
                        )
                       ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 15 8))))
                      )
                     ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                          $ (CONST_INT 32)
                         ) (Poly%array%. bytes!)
                        ) (I 16)
                       )
                      ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 16 8))))
                     )
                    ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                         $ (CONST_INT 32)
                        ) (Poly%array%. bytes!)
                       ) (I 17)
                      )
                     ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 17 8))))
                    )
                   ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                        $ (CONST_INT 32)
                       ) (Poly%array%. bytes!)
                      ) (I 18)
                     )
                    ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 18 8))))
                   )
                  ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                       $ (CONST_INT 32)
                      ) (Poly%array%. bytes!)
                     ) (I 19)
                    )
                   ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 19 8))))
                  )
                 ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                      $ (CONST_INT 32)
                     ) (Poly%array%. bytes!)
                    ) (I 20)
                   )
                  ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 20 8))))
                 )
                ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                     $ (CONST_INT 32)
                    ) (Poly%array%. bytes!)
                   ) (I 21)
                  )
                 ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 21 8))))
                )
               ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                    $ (CONST_INT 32)
                   ) (Poly%array%. bytes!)
                  ) (I 22)
                 )
                ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 22 8))))
               )
              ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                   $ (CONST_INT 32)
                  ) (Poly%array%. bytes!)
                 ) (I 23)
                )
               ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 23 8))))
              )
             ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                  $ (CONST_INT 32)
                 ) (Poly%array%. bytes!)
                ) (I 24)
               )
              ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 24 8))))
             )
            ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                 $ (CONST_INT 32)
                ) (Poly%array%. bytes!)
               ) (I 25)
              )
             ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 25 8))))
            )
           ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                $ (CONST_INT 32)
               ) (Poly%array%. bytes!)
              ) (I 26)
             )
            ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 26 8))))
           )
          ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
               $ (CONST_INT 32)
              ) (Poly%array%. bytes!)
             ) (I 27)
            )
           ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 27 8))))
          )
         ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
              $ (CONST_INT 32)
             ) (Poly%array%. bytes!)
            ) (I 28)
           )
          ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 28 8))))
         )
        ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
             $ (CONST_INT 32)
            ) (Poly%array%. bytes!)
           ) (I 29)
          )
         ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 29 8))))
        )
       ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
            $ (CONST_INT 32)
           ) (Poly%array%. bytes!)
          ) (I 30)
         )
        ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 30 8))))
       )
      ) (nClip (Mul (EucMod (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY
             $ (UINT 8) $ (CONST_INT 32)
            ) (Poly%array%. bytes!)
           ) (I 31)
          )
         ) (vstd!arithmetic.power2.pow2.? (I 7))
        ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 31 8))))
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.from_bytes_lemmas.lemma_from_u8_32_as_nat.
     bytes!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.from_bytes_lemmas.lemma_from_u8_32_as_nat._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.from_bytes_lemmas.lemma_from_u8_32_as_nat._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::from_bytes_lemmas::lemma_as_nat_32_mod_255
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.from_bytes_lemmas.lemma_as_nat_32_mod_255.
 (%%Function%%) Bool
)
(assert
 (forall ((bytes! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.from_bytes_lemmas.lemma_as_nat_32_mod_255.
     bytes!
    ) (= (EucMod (curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly%array%. bytes!))
      (vstd!arithmetic.power2.pow2.? (I 255))
     ) (Add (Add (Add (Add (Add (Add (Add (Add (Add (Add (Add (Add (Add (Add (Add (Add (Add (Add (Add (Add
                         (Add (Add (Add (Add (Add (Add (Add (Add (Add (Add (Add (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8)
                                       (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%. bytes!))
                                       (I 0)
                                      )
                                     ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 0 8))))
                                    ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                         $ (CONST_INT 32)
                                        ) (Poly%array%. bytes!)
                                       ) (I 1)
                                      )
                                     ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 1 8))))
                                    )
                                   ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                        $ (CONST_INT 32)
                                       ) (Poly%array%. bytes!)
                                      ) (I 2)
                                     )
                                    ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 2 8))))
                                   )
                                  ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                       $ (CONST_INT 32)
                                      ) (Poly%array%. bytes!)
                                     ) (I 3)
                                    )
                                   ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 3 8))))
                                  )
                                 ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                      $ (CONST_INT 32)
                                     ) (Poly%array%. bytes!)
                                    ) (I 4)
                                   )
                                  ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 4 8))))
                                 )
                                ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                     $ (CONST_INT 32)
                                    ) (Poly%array%. bytes!)
                                   ) (I 5)
                                  )
                                 ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 5 8))))
                                )
                               ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                    $ (CONST_INT 32)
                                   ) (Poly%array%. bytes!)
                                  ) (I 6)
                                 )
                                ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 6 8))))
                               )
                              ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                   $ (CONST_INT 32)
                                  ) (Poly%array%. bytes!)
                                 ) (I 7)
                                )
                               ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 7 8))))
                              )
                             ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                  $ (CONST_INT 32)
                                 ) (Poly%array%. bytes!)
                                ) (I 8)
                               )
                              ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 8 8))))
                             )
                            ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                 $ (CONST_INT 32)
                                ) (Poly%array%. bytes!)
                               ) (I 9)
                              )
                             ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 9 8))))
                            )
                           ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                $ (CONST_INT 32)
                               ) (Poly%array%. bytes!)
                              ) (I 10)
                             )
                            ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 10 8))))
                           )
                          ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                               $ (CONST_INT 32)
                              ) (Poly%array%. bytes!)
                             ) (I 11)
                            )
                           ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 11 8))))
                          )
                         ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                              $ (CONST_INT 32)
                             ) (Poly%array%. bytes!)
                            ) (I 12)
                           )
                          ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 12 8))))
                         )
                        ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                             $ (CONST_INT 32)
                            ) (Poly%array%. bytes!)
                           ) (I 13)
                          )
                         ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 13 8))))
                        )
                       ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                            $ (CONST_INT 32)
                           ) (Poly%array%. bytes!)
                          ) (I 14)
                         )
                        ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 14 8))))
                       )
                      ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                           $ (CONST_INT 32)
                          ) (Poly%array%. bytes!)
                         ) (I 15)
                        )
                       ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 15 8))))
                      )
                     ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                          $ (CONST_INT 32)
                         ) (Poly%array%. bytes!)
                        ) (I 16)
                       )
                      ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 16 8))))
                     )
                    ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                         $ (CONST_INT 32)
                        ) (Poly%array%. bytes!)
                       ) (I 17)
                      )
                     ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 17 8))))
                    )
                   ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                        $ (CONST_INT 32)
                       ) (Poly%array%. bytes!)
                      ) (I 18)
                     )
                    ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 18 8))))
                   )
                  ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                       $ (CONST_INT 32)
                      ) (Poly%array%. bytes!)
                     ) (I 19)
                    )
                   ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 19 8))))
                  )
                 ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                      $ (CONST_INT 32)
                     ) (Poly%array%. bytes!)
                    ) (I 20)
                   )
                  ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 20 8))))
                 )
                ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                     $ (CONST_INT 32)
                    ) (Poly%array%. bytes!)
                   ) (I 21)
                  )
                 ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 21 8))))
                )
               ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                    $ (CONST_INT 32)
                   ) (Poly%array%. bytes!)
                  ) (I 22)
                 )
                ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 22 8))))
               )
              ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                   $ (CONST_INT 32)
                  ) (Poly%array%. bytes!)
                 ) (I 23)
                )
               ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 23 8))))
              )
             ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                  $ (CONST_INT 32)
                 ) (Poly%array%. bytes!)
                ) (I 24)
               )
              ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 24 8))))
             )
            ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                 $ (CONST_INT 32)
                ) (Poly%array%. bytes!)
               ) (I 25)
              )
             ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 25 8))))
            )
           ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                $ (CONST_INT 32)
               ) (Poly%array%. bytes!)
              ) (I 26)
             )
            ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 26 8))))
           )
          ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
               $ (CONST_INT 32)
              ) (Poly%array%. bytes!)
             ) (I 27)
            )
           ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 27 8))))
          )
         ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
              $ (CONST_INT 32)
             ) (Poly%array%. bytes!)
            ) (I 28)
           )
          ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 28 8))))
         )
        ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
             $ (CONST_INT 32)
            ) (Poly%array%. bytes!)
           ) (I 29)
          )
         ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 29 8))))
        )
       ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
            $ (CONST_INT 32)
           ) (Poly%array%. bytes!)
          ) (I 30)
         )
        ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 30 8))))
       )
      ) (nClip (Mul (EucMod (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY
             $ (UINT 8) $ (CONST_INT 32)
            ) (Poly%array%. bytes!)
           ) (I 31)
          )
         ) (vstd!arithmetic.power2.pow2.? (I 7))
        ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 31 8))))
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.from_bytes_lemmas.lemma_as_nat_32_mod_255.
     bytes!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.from_bytes_lemmas.lemma_as_nat_32_mod_255._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.from_bytes_lemmas.lemma_as_nat_32_mod_255._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_bytes_as_nat_prefix_bounded
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_as_nat_prefix_bounded.
 (vstd!seq.Seq<u8.>. Int) Bool
)
(declare-const %%global_location_label%%28 Bool)
(assert
 (forall ((bytes! vstd!seq.Seq<u8.>.) (n! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_as_nat_prefix_bounded.
     bytes! n!
    ) (=>
     %%global_location_label%%28
     (<= n! (vstd!seq.Seq.len.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. bytes!)))
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_as_nat_prefix_bounded.
     bytes! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_as_nat_prefix_bounded._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_as_nat_prefix_bounded._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_as_nat_prefix_bounded.
 (vstd!seq.Seq<u8.>. Int) Bool
)
(assert
 (forall ((bytes! vstd!seq.Seq<u8.>.) (n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_as_nat_prefix_bounded.
     bytes! n!
    ) (< (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (Poly%vstd!seq.Seq<u8.>.
       bytes!
      ) (I n!)
     ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul n! 8))))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_as_nat_prefix_bounded.
     bytes! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_as_nat_prefix_bounded._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_bytes_as_nat_prefix_bounded._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_canonical_bytes_equal
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_canonical_bytes_equal.
 (%%Function%% %%Function%%) Bool
)
(declare-const %%global_location_label%%29 Bool)
(assert
 (forall ((bytes1! %%Function%%) (bytes2! %%Function%%)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_canonical_bytes_equal.
     bytes1! bytes2!
    ) (=>
     %%global_location_label%%29
     (= (curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly%array%. bytes1!)) (curve25519_dalek!specs.core_specs.u8_32_as_nat.?
       (Poly%array%. bytes2!)
   ))))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_canonical_bytes_equal.
     bytes1! bytes2!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_canonical_bytes_equal._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_canonical_bytes_equal._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_canonical_bytes_equal.
 (%%Function%% %%Function%%) Bool
)
(assert
 (forall ((bytes1! %%Function%%) (bytes2! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_canonical_bytes_equal.
     bytes1! bytes2!
    ) (forall ((i$ Poly)) (!
      (=>
       (has_type i$ INT)
       (=>
        (let
         ((tmp%%$ (%I i$)))
         (and
          (<= 0 tmp%%$)
          (< tmp%%$ 32)
        ))
        (= (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT
             32
            )
           ) (Poly%array%. bytes1!)
          ) i$
         ) (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT
             32
            )
           ) (Poly%array%. bytes2!)
          ) i$
      ))))
      :pattern ((vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
          $ (CONST_INT 32)
         ) (Poly%array%. bytes1!)
        ) i$
      ))
      :pattern ((vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
          $ (CONST_INT 32)
         ) (Poly%array%. bytes2!)
        ) i$
      ))
      :qid user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_canonical_bytes_equal_33
      :skolemid skolem_user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_canonical_bytes_equal_33
   )))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_canonical_bytes_equal.
     bytes1! bytes2!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_canonical_bytes_equal._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_canonical_bytes_equal._definition
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

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_inv_one
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_inv_one.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_inv_one.
     no%param
    ) (= (curve25519_dalek!specs.field_specs.field_inv.? (I 1)) 1)
   )
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_inv_one.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_inv_one._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_inv_one._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_mul_one_right
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_one_right.
 (Int) Bool
)
(assert
 (forall ((a! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_one_right.
     a!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I a!) (I 1)) (EucMod a! (curve25519_dalek!specs.field_specs_u64.p.?
       (I 0)
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_one_right.
     a!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_one_right._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_one_right._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_mul_zero_left
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_left.
 (Int Int) Bool
)
(declare-const %%global_location_label%%30 Bool)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_left.
     a! b!
    ) (=>
     %%global_location_label%%30
     (= (EucMod a! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0)
   ))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_left.
     a! b!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_left._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_left._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_left.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_left.
     a! b!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I a!) (I b!)) 0)
   )
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_left.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_left._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_left._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_neg_square_eq
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_neg_square_eq.
 (Int) Bool
)
(assert
 (forall ((x! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_neg_square_eq.
     x!
    ) (= (curve25519_dalek!specs.field_specs.field_square.? (I (curve25519_dalek!specs.field_specs.field_neg.?
        (I x!)
      ))
     ) (curve25519_dalek!specs.field_specs.field_square.? (I (EucMod x! (curve25519_dalek!specs.field_specs_u64.p.?
         (I 0)
   ))))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_neg_square_eq.
     x!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_neg_square_eq._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_neg_square_eq._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_square_mod_noop
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_square_mod_noop.
 (Int) Bool
)
(assert
 (forall ((x! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_square_mod_noop.
     x!
    ) (= (curve25519_dalek!specs.field_specs.field_square.? (I (EucMod x! (curve25519_dalek!specs.field_specs_u64.p.?
         (I 0)
      )))
     ) (curve25519_dalek!specs.field_specs.field_square.? (I x!))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_square_mod_noop.
     x!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_square_mod_noop._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_square_mod_noop._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_sub_self
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_self.
 (Int) Bool
)
(assert
 (forall ((x! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_self.
     x!
    ) (= (curve25519_dalek!specs.field_specs.field_sub.? (I x!) (I x!)) 0)
   )
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_self.
     x!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_self._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_self._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_mul_zero_right
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right.
 (Int Int) Bool
)
(declare-const %%global_location_label%%31 Bool)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right.
     a! b!
    ) (=>
     %%global_location_label%%31
     (= (EucMod b! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0)
   ))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right.
     a! b!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right.
     a! b!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I a!) (I b!)) 0)
   )
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right._definition
)))

;; Function-Specs curve25519_dalek::specs::field_specs::field_inv_unique
(declare-fun req%curve25519_dalek!specs.field_specs.field_inv_unique. (Int Int) Bool)
(declare-const %%global_location_label%%32 Bool)
(declare-const %%global_location_label%%33 Bool)
(declare-const %%global_location_label%%34 Bool)
(assert
 (forall ((a! Int) (w! Int)) (!
   (= (req%curve25519_dalek!specs.field_specs.field_inv_unique. a! w!) (and
     (=>
      %%global_location_label%%32
      (not (= (curve25519_dalek!specs.field_specs_u64.field_canonical.? (I a!)) 0))
     )
     (=>
      %%global_location_label%%33
      (< w! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%34
      (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs_u64.field_canonical.?
          (I a!)
         )
        ) (I w!)
       ) 1
   ))))
   :pattern ((req%curve25519_dalek!specs.field_specs.field_inv_unique. a! w!))
   :qid internal_req__curve25519_dalek!specs.field_specs.field_inv_unique._definition
   :skolemid skolem_internal_req__curve25519_dalek!specs.field_specs.field_inv_unique._definition
)))
(declare-fun ens%curve25519_dalek!specs.field_specs.field_inv_unique. (Int Int) Bool)
(assert
 (forall ((a! Int) (w! Int)) (!
   (= (ens%curve25519_dalek!specs.field_specs.field_inv_unique. a! w!) (= w! (curve25519_dalek!specs.field_specs.field_inv.?
      (I a!)
   )))
   :pattern ((ens%curve25519_dalek!specs.field_specs.field_inv_unique. a! w!))
   :qid internal_ens__curve25519_dalek!specs.field_specs.field_inv_unique._definition
   :skolemid skolem_internal_ens__curve25519_dalek!specs.field_specs.field_inv_unique._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_mul_neg
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_neg.
 (Int Int) Bool
)
(assert
 (forall ((c! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_neg.
     c! b!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I c!) (I (curve25519_dalek!specs.field_specs.field_neg.?
        (I b!)
      ))
     ) (curve25519_dalek!specs.field_specs.field_neg.? (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I c!) (I b!)
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_neg.
     c! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_neg._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_neg._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_neg_neg
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_neg_neg.
 (Int) Bool
)
(assert
 (forall ((a! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_neg_neg.
     a!
    ) (= (curve25519_dalek!specs.field_specs.field_neg.? (I (curve25519_dalek!specs.field_specs.field_neg.?
        (I a!)
      ))
     ) (EucMod a! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_neg_neg.
     a!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_neg_neg._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_neg_neg._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_neg_mul_left
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_neg_mul_left.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_neg_mul_left.
     a! b!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_neg.?
        (I a!)
       )
      ) (I b!)
     ) (curve25519_dalek!specs.field_specs.field_neg.? (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I a!) (I b!)
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_neg_mul_left.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_neg_mul_left._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_neg_mul_left._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_projective_implies_affine_on_curve
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_implies_affine_on_curve.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%35 Bool)
(declare-const %%global_location_label%%36 Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_implies_affine_on_curve.
     x! y! z!
    ) (and
     (=>
      %%global_location_label%%35
      (not (= (EucMod z! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
     )
     (=>
      %%global_location_label%%36
      (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.? (I x!) (I y!)
       (I z!)
   ))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_implies_affine_on_curve.
     x! y! z!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_implies_affine_on_curve._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_implies_affine_on_curve._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_implies_affine_on_curve.
 (Int Int Int) Bool
)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_implies_affine_on_curve.
     x! y! z!
    ) (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.? (I (curve25519_dalek!specs.field_specs.field_mul.?
       (I x!) (I (curve25519_dalek!specs.field_specs.field_inv.? (I z!)))
      )
     ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I y!) (I (curve25519_dalek!specs.field_specs.field_inv.?
         (I z!)
   ))))))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_implies_affine_on_curve.
     x! y! z!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_implies_affine_on_curve._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_implies_affine_on_curve._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::as_bytes_lemmas::lemma_from_bytes_as_bytes_roundtrip
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.as_bytes_lemmas.lemma_from_bytes_as_bytes_roundtrip.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51. %%Function%% curve25519_dalek!backend.serial.u64.field.FieldElement51.)
 Bool
)
(declare-const %%global_location_label%%37 Bool)
(declare-const %%global_location_label%%38 Bool)
(assert
 (forall ((fe_orig! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (bytes!
    %%Function%%
   ) (fe_decoded! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
  ) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.as_bytes_lemmas.lemma_from_bytes_as_bytes_roundtrip.
     fe_orig! bytes! fe_decoded!
    ) (and
     (=>
      %%global_location_label%%37
      (curve25519_dalek!specs.field_specs.as_bytes_post.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        fe_orig!
       ) (Poly%array%. bytes!)
     ))
     (=>
      %%global_location_label%%38
      (curve25519_dalek!specs.field_specs.from_bytes_post.? (Poly%array%. bytes!) (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        fe_decoded!
   )))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.as_bytes_lemmas.lemma_from_bytes_as_bytes_roundtrip.
     fe_orig! bytes! fe_decoded!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.as_bytes_lemmas.lemma_from_bytes_as_bytes_roundtrip._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.as_bytes_lemmas.lemma_from_bytes_as_bytes_roundtrip._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.as_bytes_lemmas.lemma_from_bytes_as_bytes_roundtrip.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51. %%Function%% curve25519_dalek!backend.serial.u64.field.FieldElement51.)
 Bool
)
(assert
 (forall ((fe_orig! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (bytes!
    %%Function%%
   ) (fe_decoded! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
  ) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.as_bytes_lemmas.lemma_from_bytes_as_bytes_roundtrip.
     fe_orig! bytes! fe_decoded!
    ) (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       fe_decoded!
      )
     ) (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       fe_orig!
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.as_bytes_lemmas.lemma_from_bytes_as_bytes_roundtrip.
     fe_orig! bytes! fe_decoded!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.as_bytes_lemmas.lemma_from_bytes_as_bytes_roundtrip._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.as_bytes_lemmas.lemma_from_bytes_as_bytes_roundtrip._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_one_and_neg_one_square_to_one
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_one_and_neg_one_square_to_one.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_one_and_neg_one_square_to_one.
     no%param
    ) (and
     (= (curve25519_dalek!specs.field_specs.field_square.? (I 1)) 1)
     (= (curve25519_dalek!specs.field_specs.field_square.? (I (curve25519_dalek!specs.field_specs.field_neg.?
         (I 1)
       ))
      ) 1
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_one_and_neg_one_square_to_one.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_one_and_neg_one_square_to_one._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_one_and_neg_one_square_to_one._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_affine_zero_implies_proj_zero
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_affine_zero_implies_proj_zero.
 (Int Int) Bool
)
(declare-const %%global_location_label%%39 Bool)
(declare-const %%global_location_label%%40 Bool)
(declare-const %%global_location_label%%41 Bool)
(assert
 (forall ((a! Int) (z! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_affine_zero_implies_proj_zero.
     a! z!
    ) (and
     (=>
      %%global_location_label%%39
      (not (= (EucMod z! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
     )
     (=>
      %%global_location_label%%40
      (< a! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%41
      (= (curve25519_dalek!specs.field_specs.field_mul.? (I a!) (I (curve25519_dalek!specs.field_specs.field_inv.?
          (I z!)
        ))
       ) 0
   ))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_affine_zero_implies_proj_zero.
     a! z!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_affine_zero_implies_proj_zero._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_affine_zero_implies_proj_zero._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_affine_zero_implies_proj_zero.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (z! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_affine_zero_implies_proj_zero.
     a! z!
    ) (= a! 0)
   )
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_affine_zero_implies_proj_zero.
     a! z!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_affine_zero_implies_proj_zero._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_affine_zero_implies_proj_zero._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_a_times_inv_ab_is_inv_b
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_a_times_inv_ab_is_inv_b.
 (Int Int) Bool
)
(declare-const %%global_location_label%%42 Bool)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_a_times_inv_ab_is_inv_b.
     a! b!
    ) (=>
     %%global_location_label%%42
     (not (= (EucMod a! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
   ))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_a_times_inv_ab_is_inv_b.
     a! b!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_a_times_inv_ab_is_inv_b._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_a_times_inv_ab_is_inv_b._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_a_times_inv_ab_is_inv_b.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_a_times_inv_ab_is_inv_b.
     a! b!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I a!) (I (curve25519_dalek!specs.field_specs.field_inv.?
        (I (curve25519_dalek!specs.field_specs.field_mul.? (I a!) (I b!)))
      ))
     ) (curve25519_dalek!specs.field_specs.field_inv.? (I b!))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_a_times_inv_ab_is_inv_b.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_a_times_inv_ab_is_inv_b._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_a_times_inv_ab_is_inv_b._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_inv_neg
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_inv_neg.
 (Int) Bool
)
(assert
 (forall ((a! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_inv_neg.
     a!
    ) (= (curve25519_dalek!specs.field_specs.field_inv.? (I (curve25519_dalek!specs.field_specs.field_neg.?
        (I a!)
      ))
     ) (curve25519_dalek!specs.field_specs.field_neg.? (I (curve25519_dalek!specs.field_specs.field_inv.?
        (I a!)
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_inv_neg.
     a!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_inv_neg._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_inv_neg._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_m1_lemmas::axiom_sqrt_m1_squared
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.axiom_sqrt_m1_squared.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.axiom_sqrt_m1_squared.
     no%param
    ) (= (EucMod (nClip (Mul (curve25519_dalek!specs.field_specs.sqrt_m1.? (I 0)) (curve25519_dalek!specs.field_specs.sqrt_m1.?
         (I 0)
       ))
      ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     ) (Sub (curve25519_dalek!specs.field_specs_u64.p.? (I 0)) 1)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.axiom_sqrt_m1_squared.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.axiom_sqrt_m1_squared._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.axiom_sqrt_m1_squared._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_m1_lemmas::lemma_sqrt_m1_nonzero
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_sqrt_m1_nonzero.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_sqrt_m1_nonzero.
     no%param
    ) (and
     (not (= (curve25519_dalek!specs.field_specs.sqrt_m1.? (I 0)) 0))
     (not (= (EucMod (curve25519_dalek!specs.field_specs.sqrt_m1.? (I 0)) (curve25519_dalek!specs.field_specs_u64.p.?
         (I 0)
        )
       ) 0
     ))
     (< (curve25519_dalek!specs.field_specs.sqrt_m1.? (I 0)) (curve25519_dalek!specs.field_specs_u64.p.?
       (I 0)
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_sqrt_m1_nonzero.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_sqrt_m1_nonzero._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_sqrt_m1_nonzero._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_ratio_lemmas::lemma_invsqrt_unique
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_unique.
 (Int Int) Bool
)
(declare-const %%global_location_label%%43 Bool)
(declare-const %%global_location_label%%44 Bool)
(declare-const %%global_location_label%%45 Bool)
(declare-const %%global_location_label%%46 Bool)
(assert
 (forall ((a! Int) (r! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_unique.
     a! r!
    ) (and
     (=>
      %%global_location_label%%43
      (not (= (EucMod a! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
     )
     (=>
      %%global_location_label%%44
      (< r! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%45
      (not (curve25519_dalek!specs.field_specs.is_negative.? (I r!)))
     )
     (=>
      %%global_location_label%%46
      (or
       (curve25519_dalek!specs.field_specs.is_sqrt_ratio.? (I 1) (I a!) (I r!))
       (curve25519_dalek!specs.field_specs.is_sqrt_ratio_times_i.? (I 1) (I a!) (I r!))
   ))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_unique.
     a! r!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_unique._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_unique._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_unique.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (r! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_unique.
     a! r!
    ) (= r! (curve25519_dalek!specs.field_specs.nat_invsqrt.? (I a!)))
   )
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_unique.
     a! r!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_unique._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_unique._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_ratio_lemmas::lemma_canonical_nat_lt_p
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_canonical_nat_lt_p.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51.) Bool
)
(assert
 (forall ((x! curve25519_dalek!backend.serial.u64.field.FieldElement51.)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_canonical_nat_lt_p.
     x!
    ) (< (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       x!
      )
     ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_canonical_nat_lt_p.
     x!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_canonical_nat_lt_p._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_canonical_nat_lt_p._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::torsion_lemmas::lemma_on_curve_y_zero_implies_x_sq_neg_one
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.torsion_lemmas.lemma_on_curve_y_zero_implies_x_sq_neg_one.
 (Int Int) Bool
)
(declare-const %%global_location_label%%47 Bool)
(declare-const %%global_location_label%%48 Bool)
(assert
 (forall ((x! Int) (y! Int)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.torsion_lemmas.lemma_on_curve_y_zero_implies_x_sq_neg_one.
     x! y!
    ) (and
     (=>
      %%global_location_label%%47
      (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.? (I x!) (I y!))
     )
     (=>
      %%global_location_label%%48
      (= y! 0)
   )))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.torsion_lemmas.lemma_on_curve_y_zero_implies_x_sq_neg_one.
     x! y!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.torsion_lemmas.lemma_on_curve_y_zero_implies_x_sq_neg_one._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.torsion_lemmas.lemma_on_curve_y_zero_implies_x_sq_neg_one._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.torsion_lemmas.lemma_on_curve_y_zero_implies_x_sq_neg_one.
 (Int Int) Bool
)
(assert
 (forall ((x! Int) (y! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.torsion_lemmas.lemma_on_curve_y_zero_implies_x_sq_neg_one.
     x! y!
    ) (= (curve25519_dalek!specs.field_specs.field_square.? (I x!)) (curve25519_dalek!specs.field_specs.field_neg.?
      (I 1)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.torsion_lemmas.lemma_on_curve_y_zero_implies_x_sq_neg_one.
     x! y!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.torsion_lemmas.lemma_on_curve_y_zero_implies_x_sq_neg_one._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.torsion_lemmas.lemma_on_curve_y_zero_implies_x_sq_neg_one._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::torsion_lemmas::lemma_on_curve_x_zero_implies_y_pm_one
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.torsion_lemmas.lemma_on_curve_x_zero_implies_y_pm_one.
 (Int Int) Bool
)
(declare-const %%global_location_label%%49 Bool)
(declare-const %%global_location_label%%50 Bool)
(declare-const %%global_location_label%%51 Bool)
(assert
 (forall ((x! Int) (y! Int)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.torsion_lemmas.lemma_on_curve_x_zero_implies_y_pm_one.
     x! y!
    ) (and
     (=>
      %%global_location_label%%49
      (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.? (I x!) (I y!))
     )
     (=>
      %%global_location_label%%50
      (= x! 0)
     )
     (=>
      %%global_location_label%%51
      (< y! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
   )))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.torsion_lemmas.lemma_on_curve_x_zero_implies_y_pm_one.
     x! y!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.torsion_lemmas.lemma_on_curve_x_zero_implies_y_pm_one._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.torsion_lemmas.lemma_on_curve_x_zero_implies_y_pm_one._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.torsion_lemmas.lemma_on_curve_x_zero_implies_y_pm_one.
 (Int Int) Bool
)
(assert
 (forall ((x! Int) (y! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.torsion_lemmas.lemma_on_curve_x_zero_implies_y_pm_one.
     x! y!
    ) (or
     (= y! 1)
     (= y! (curve25519_dalek!specs.field_specs.field_neg.? (I 1)))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.torsion_lemmas.lemma_on_curve_x_zero_implies_y_pm_one.
     x! y!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.torsion_lemmas.lemma_on_curve_x_zero_implies_y_pm_one._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.torsion_lemmas.lemma_on_curve_x_zero_implies_y_pm_one._definition
)))

;; Function-Specs curve25519_dalek::lemmas::ristretto_lemmas::coset_lemmas::lemma_edge_coset_contains_e4
(declare-fun req%curve25519_dalek!lemmas.ristretto_lemmas.coset_lemmas.lemma_edge_coset_contains_e4.
 (Int Int) Bool
)
(declare-const %%global_location_label%%52 Bool)
(declare-const %%global_location_label%%53 Bool)
(declare-const %%global_location_label%%54 Bool)
(declare-const %%global_location_label%%55 Bool)
(declare-const %%global_location_label%%56 Bool)
(assert
 (forall ((x! Int) (y! Int)) (!
   (= (req%curve25519_dalek!lemmas.ristretto_lemmas.coset_lemmas.lemma_edge_coset_contains_e4.
     x! y!
    ) (and
     (=>
      %%global_location_label%%52
      (or
       (= x! 0)
       (= y! 0)
     ))
     (=>
      %%global_location_label%%53
      (< x! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%54
      (< y! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%55
      (=>
       (= x! 0)
       (or
        (= y! 1)
        (= y! (curve25519_dalek!specs.field_specs.field_neg.? (I 1)))
     )))
     (=>
      %%global_location_label%%56
      (=>
       (= y! 0)
       (= (curve25519_dalek!specs.field_specs.field_square.? (I x!)) (curve25519_dalek!specs.field_specs.field_neg.?
         (I 1)
   ))))))
   :pattern ((req%curve25519_dalek!lemmas.ristretto_lemmas.coset_lemmas.lemma_edge_coset_contains_e4.
     x! y!
   ))
   :qid internal_req__curve25519_dalek!lemmas.ristretto_lemmas.coset_lemmas.lemma_edge_coset_contains_e4._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.ristretto_lemmas.coset_lemmas.lemma_edge_coset_contains_e4._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.ristretto_lemmas.coset_lemmas.lemma_edge_coset_contains_e4.
 (Int Int) Bool
)
(assert
 (forall ((x! Int) (y! Int)) (!
   (= (ens%curve25519_dalek!lemmas.ristretto_lemmas.coset_lemmas.lemma_edge_coset_contains_e4.
     x! y!
    ) (let
     ((coset$ (curve25519_dalek!specs.ristretto_specs.ristretto_coset_affine.? (I x!) (I y!))))
     (let
      ((id$ (tuple%2./tuple%2 (I 0) (I 1))))
      (let
       ((i_pt$ (tuple%2./tuple%2 (I (curve25519_dalek!specs.field_specs.sqrt_m1.? (I 0))) (
           I 0
       ))))
       (let
        ((neg1_pt$ (tuple%2./tuple%2 (I 0) (I (curve25519_dalek!specs.field_specs.field_neg.?
             (I 1)
        )))))
        (let
         ((neg_i_pt$ (tuple%2./tuple%2 (I (curve25519_dalek!specs.field_specs.field_neg.? (I (curve25519_dalek!specs.field_specs.sqrt_m1.?
                (I 0)
             )))
            ) (I 0)
         )))
         (and
          (and
           (or
            (or
             (or
              (= id$ (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (vstd!view.View.view.?
                  $ (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4)) (Poly%array%. coset$)
                 ) (I 0)
              )))
              (= id$ (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (vstd!view.View.view.?
                  $ (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4)) (Poly%array%. coset$)
                 ) (I 1)
             ))))
             (= id$ (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (vstd!view.View.view.?
                 $ (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4)) (Poly%array%. coset$)
                ) (I 2)
            ))))
            (= id$ (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (vstd!view.View.view.?
                $ (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4)) (Poly%array%. coset$)
               ) (I 3)
           ))))
           (or
            (or
             (or
              (= i_pt$ (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (
                  vstd!view.View.view.? $ (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4))
                  (Poly%array%. coset$)
                 ) (I 0)
              )))
              (= i_pt$ (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (
                  vstd!view.View.view.? $ (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4))
                  (Poly%array%. coset$)
                 ) (I 1)
             ))))
             (= i_pt$ (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (
                 vstd!view.View.view.? $ (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4))
                 (Poly%array%. coset$)
                ) (I 2)
            ))))
            (= i_pt$ (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (
                vstd!view.View.view.? $ (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4))
                (Poly%array%. coset$)
               ) (I 3)
          )))))
          (or
           (or
            (or
             (= neg_i_pt$ (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT)
                (vstd!view.View.view.? $ (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4))
                 (Poly%array%. coset$)
                ) (I 0)
             )))
             (= neg_i_pt$ (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT)
                (vstd!view.View.view.? $ (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4))
                 (Poly%array%. coset$)
                ) (I 1)
            ))))
            (= neg_i_pt$ (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT)
               (vstd!view.View.view.? $ (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4))
                (Poly%array%. coset$)
               ) (I 2)
           ))))
           (= neg_i_pt$ (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT)
              (vstd!view.View.view.? $ (ARRAY (DST $) (TYPE%tuple%2. $ NAT $ NAT) $ (CONST_INT 4))
               (Poly%array%. coset$)
              ) (I 3)
   )))))))))))
   :pattern ((ens%curve25519_dalek!lemmas.ristretto_lemmas.coset_lemmas.lemma_edge_coset_contains_e4.
     x! y!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.ristretto_lemmas.coset_lemmas.lemma_edge_coset_contains_e4._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.ristretto_lemmas.coset_lemmas.lemma_edge_coset_contains_e4._definition
)))

;; Function-Specs curve25519_dalek::lemmas::lizard_lemmas::lemma_zero_limbs_bounded
(declare-fun ens%curve25519_dalek!lemmas.lizard_lemmas.lemma_zero_limbs_bounded. (
  Int
 ) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.lizard_lemmas.lemma_zero_limbs_bounded. no%param)
    (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      curve25519_dalek!backend.serial.u64.field.impl&%16.ZERO.?
     ) (I 52)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.lizard_lemmas.lemma_zero_limbs_bounded. no%param))
   :qid internal_ens__curve25519_dalek!lemmas.lizard_lemmas.lemma_zero_limbs_bounded._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.lizard_lemmas.lemma_zero_limbs_bounded._definition
)))

;; Function-Specs curve25519_dalek::lemmas::lizard_lemmas::lemma_sqrt_id_limbs_bounded_52
(declare-fun ens%curve25519_dalek!lemmas.lizard_lemmas.lemma_sqrt_id_limbs_bounded_52.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.lizard_lemmas.lemma_sqrt_id_limbs_bounded_52. no%param)
    (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      curve25519_dalek!lizard.u64_constants.SQRT_ID.?
     ) (I 52)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.lizard_lemmas.lemma_sqrt_id_limbs_bounded_52.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.lizard_lemmas.lemma_sqrt_id_limbs_bounded_52._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.lizard_lemmas.lemma_sqrt_id_limbs_bounded_52._definition
)))

;; Function-Specs curve25519_dalek::lemmas::lizard_lemmas::lemma_dp1_over_dm1_limbs_bounded_51
(declare-fun ens%curve25519_dalek!lemmas.lizard_lemmas.lemma_dp1_over_dm1_limbs_bounded_51.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.lizard_lemmas.lemma_dp1_over_dm1_limbs_bounded_51.
     no%param
    ) (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      curve25519_dalek!lizard.u64_constants.DP1_OVER_DM1.?
     ) (I 51)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.lizard_lemmas.lemma_dp1_over_dm1_limbs_bounded_51.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.lizard_lemmas.lemma_dp1_over_dm1_limbs_bounded_51._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.lizard_lemmas.lemma_dp1_over_dm1_limbs_bounded_51._definition
)))

;; Function-Def curve25519_dalek::lemmas::lizard_lemmas::lemma_dp1_over_dm1_limbs_bounded_51
;; curve25519-dalek/src/lemmas/lizard_lemmas.rs:113:5: 113:11 (#0)
(set-option :sat.euf true)
(set-option :tactic.default_tactic sat)
(set-option :smt.ematching false)
(set-option :smt.case_split 0)
(get-info :all-statistics)
(assert
 true
)
;; bitvector assertion not satisfied
(declare-const %%location_label%%0 Bool)
(assert
 (not (=>
   %%location_label%%0
   true
)))
(get-info :version)
(set-option :rlimit 30000000)
(check-sat)
(set-option :rlimit 0)
