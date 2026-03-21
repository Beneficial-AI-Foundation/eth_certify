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

;; MODULE 'module lemmas::ristretto_lemmas::batch_compress_lemmas'
;; curve25519-dalek/src/lemmas/ristretto_lemmas/batch_compress_lemmas.rs:169:1: 178:2 (#0)

;; query spun off because: spinoff_all

;; Fuel
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_bound. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. FuelId)
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
(declare-const fuel%vstd!view.impl&%16.view. FuelId)
(declare-const fuel%vstd!view.impl&%22.view. FuelId)
(declare-const fuel%vstd!view.impl&%26.view. FuelId)
(declare-const fuel%vstd!view.impl&%44.view. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.constants.INVSQRT_A_MINUS_D.
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
(declare-const fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_add. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_double. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.fe51_as_canonical_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_add. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_sub. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_mul. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_neg. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_square. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_inv. FuelId)
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
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.primality_specs.is_prime. FuelId)
(declare-const fuel%curve25519_dalek!specs.ristretto_specs.ristretto_compress_extended.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.ristretto_specs.ristretto_compress_affine.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.ristretto_specs.batch_compress_body. FuelId)
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
 (distinct fuel%vstd!arithmetic.div_mod.lemma_mod_bound. fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left.
  fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. fuel%vstd!array.array_view.
  fuel%vstd!array.impl&%0.view. fuel%vstd!array.impl&%2.spec_index. fuel%vstd!array.lemma_array_index.
  fuel%vstd!array.array_len_matches_n. fuel%vstd!array.axiom_array_ext_equal. fuel%vstd!array.axiom_array_has_resolved.
  fuel%vstd!raw_ptr.impl&%3.view. fuel%vstd!raw_ptr.ptrs_mut_eq. fuel%vstd!raw_ptr.ptrs_mut_eq_sized.
  fuel%vstd!seq.impl&%0.spec_index. fuel%vstd!seq.axiom_seq_index_decreases. fuel%vstd!seq.axiom_seq_new_len.
  fuel%vstd!seq.axiom_seq_new_index. fuel%vstd!seq.axiom_seq_ext_equal. fuel%vstd!seq.axiom_seq_ext_equal_deep.
  fuel%vstd!slice.impl&%2.spec_index. fuel%vstd!slice.axiom_spec_len. fuel%vstd!slice.axiom_slice_ext_equal.
  fuel%vstd!slice.axiom_slice_has_resolved. fuel%vstd!view.impl&%0.view. fuel%vstd!view.impl&%2.view.
  fuel%vstd!view.impl&%4.view. fuel%vstd!view.impl&%6.view. fuel%vstd!view.impl&%12.view.
  fuel%vstd!view.impl&%14.view. fuel%vstd!view.impl&%16.view. fuel%vstd!view.impl&%22.view.
  fuel%vstd!view.impl&%26.view. fuel%vstd!view.impl&%44.view. fuel%curve25519_dalek!backend.serial.u64.constants.INVSQRT_A_MINUS_D.
  fuel%curve25519_dalek!backend.serial.u64.constants.SQRT_M1. fuel%curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.
  fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd. fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.
  fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.
  fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat. fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.
  fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective. fuel%curve25519_dalek!specs.edwards_specs.edwards_add.
  fuel%curve25519_dalek!specs.edwards_specs.edwards_double. fuel%curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.
  fuel%curve25519_dalek!specs.field_specs.field_add. fuel%curve25519_dalek!specs.field_specs.field_sub.
  fuel%curve25519_dalek!specs.field_specs.field_mul. fuel%curve25519_dalek!specs.field_specs.field_neg.
  fuel%curve25519_dalek!specs.field_specs.field_square. fuel%curve25519_dalek!specs.field_specs.field_inv.
  fuel%curve25519_dalek!specs.field_specs.is_negative. fuel%curve25519_dalek!specs.field_specs.field_abs.
  fuel%curve25519_dalek!specs.field_specs.nat_invsqrt. fuel%curve25519_dalek!specs.field_specs.u8_32_from_nat.
  fuel%curve25519_dalek!specs.field_specs.sqrt_m1. fuel%curve25519_dalek!specs.field_specs_u64.p.
  fuel%curve25519_dalek!specs.field_specs_u64.field_canonical. fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.
  fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat. fuel%curve25519_dalek!specs.primality_specs.is_prime.
  fuel%curve25519_dalek!specs.ristretto_specs.ristretto_compress_extended. fuel%curve25519_dalek!specs.ristretto_specs.ristretto_compress_affine.
  fuel%curve25519_dalek!specs.ristretto_specs.batch_compress_body. fuel%vstd!array.group_array_axioms.
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
(declare-datatypes ((vstd!raw_ptr.PtrData. 0) (curve25519_dalek!backend.serial.u64.field.FieldElement51.
   0
  ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. 0) (tuple%0.
   0
  ) (tuple%2. 0)
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
  ) ((tuple%0./tuple%0)) ((tuple%2./tuple%2 (tuple%2./tuple%2/?0 Poly) (tuple%2./tuple%2/?1
     Poly
)))))
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
(declare-fun tuple%2./tuple%2/0 (tuple%2.) Poly)
(declare-fun tuple%2./tuple%2/1 (tuple%2.) Poly)
(declare-fun TYPE%fun%1. (Dcr Type Dcr Type) Type)
(declare-const TYPE%vstd!raw_ptr.Provenance. Type)
(declare-fun TYPE%vstd!raw_ptr.PtrData. (Dcr Type) Type)
(declare-fun TYPE%vstd!seq.Seq. (Dcr Type) Type)
(declare-const TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. Type)
(declare-const TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
 Type
)
(declare-fun TYPE%tuple%2. (Dcr Type Dcr Type) Type)
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
(declare-fun Poly%tuple%0. (tuple%0.) Poly)
(declare-fun %Poly%tuple%0. (Poly) tuple%0.)
(declare-fun Poly%tuple%2. (tuple%2.) Poly)
(declare-fun %Poly%tuple%2. (Poly) tuple%2.)
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

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_add
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_add.? (Poly Poly Poly Poly)
 tuple%2.
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_double
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_double.? (Poly Poly) tuple%2.)

;; Function-Decl curve25519_dalek::backend::serial::u64::constants::INVSQRT_A_MINUS_D
(declare-fun curve25519_dalek!backend.serial.u64.constants.INVSQRT_A_MINUS_D.? ()
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)

;; Function-Decl curve25519_dalek::backend::serial::u64::constants::SQRT_M1
(declare-fun curve25519_dalek!backend.serial.u64.constants.SQRT_M1.? () curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::specs::field_specs::sqrt_m1
(declare-fun curve25519_dalek!specs.field_specs.sqrt_m1.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::is_negative
(declare-fun curve25519_dalek!specs.field_specs.is_negative.? (Poly) Bool)

;; Function-Decl curve25519_dalek::specs::field_specs::nat_invsqrt
(declare-fun curve25519_dalek!specs.field_specs.nat_invsqrt.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::field_abs
(declare-fun curve25519_dalek!specs.field_specs.field_abs.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_on_edwards_curve
(declare-fun curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.? (Poly Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::field_specs::u8_32_from_nat
(declare-fun curve25519_dalek!specs.field_specs.u8_32_from_nat.? (Poly) %%Function%%)

;; Function-Decl curve25519_dalek::specs::primality_specs::is_prime
(declare-fun curve25519_dalek!specs.primality_specs.is_prime.? (Poly) Bool)

;; Function-Decl curve25519_dalek::specs::ristretto_specs::ristretto_compress_extended
(declare-fun curve25519_dalek!specs.ristretto_specs.ristretto_compress_extended.?
 (Poly Poly Poly Poly) %%Function%%
)

;; Function-Decl curve25519_dalek::specs::ristretto_specs::ristretto_compress_affine
(declare-fun curve25519_dalek!specs.ristretto_specs.ristretto_compress_affine.? (Poly
  Poly
 ) %%Function%%
)

;; Function-Decl curve25519_dalek::specs::ristretto_specs::batch_compress_body
(declare-fun curve25519_dalek!specs.ristretto_specs.batch_compress_body.? (Poly Poly
  Poly Poly Poly Poly Poly
 ) %%Function%%
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

;; Function-Specs vstd::arithmetic::div_mod::lemma_small_mod
(declare-fun req%vstd!arithmetic.div_mod.lemma_small_mod. (Int Int) Bool)
(declare-const %%global_location_label%%4 Bool)
(declare-const %%global_location_label%%5 Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_small_mod. x! m!) (and
     (=>
      %%global_location_label%%4
      (< x! m!)
     )
     (=>
      %%global_location_label%%5
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

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_bound
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_bound. (Int Int) Bool)
(declare-const %%global_location_label%%6 Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_bound. x! m!) (=>
     %%global_location_label%%6
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
    :qid user_vstd__arithmetic__div_mod__lemma_mod_bound_18
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_bound_18
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mul_mod_noop_left
(declare-fun req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left. (Int Int Int) Bool)
(declare-const %%global_location_label%%7 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left. x! y! m!) (=>
     %%global_location_label%%7
     (< 0 m!)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left. x! y! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mul_mod_noop_left._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mul_mod_noop_left._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left. (Int Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left. x! y! m!) (= (EucMod (Mul (EucMod
        x! m!
       ) y!
      ) m!
     ) (EucMod (Mul x! y!) m!)
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left. x! y! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mul_mod_noop_left._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mul_mod_noop_left._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mul_mod_noop_left
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left.)
  (forall ((x! Int) (y! Int) (m! Int)) (!
    (=>
     (< 0 m!)
     (= (EucMod (Mul (EucMod x! m!) y!) m!) (EucMod (Mul x! y!) m!))
    )
    :pattern ((EucMod (Mul x! y!) m!))
    :qid user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_left_19
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_left_19
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mul_mod_noop_right
(declare-fun req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. (Int Int Int) Bool)
(declare-const %%global_location_label%%8 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. x! y! m!) (=>
     %%global_location_label%%8
     (< 0 m!)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. x! y! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mul_mod_noop_right._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mul_mod_noop_right._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. (Int Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. x! y! m!) (= (EucMod (Mul x!
       (EucMod y! m!)
      ) m!
     ) (EucMod (Mul x! y!) m!)
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. x! y! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mul_mod_noop_right._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mul_mod_noop_right._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mul_mod_noop_right
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right.)
  (forall ((x! Int) (y! Int) (m! Int)) (!
    (=>
     (< 0 m!)
     (= (EucMod (Mul x! (EucMod y! m!)) m!) (EucMod (Mul x! y!) m!))
    )
    :pattern ((EucMod (Mul x! y!) m!))
    :qid user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_right_20
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_right_20
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
(declare-const %%global_location_label%%9 Bool)
(declare-const %%global_location_label%%10 Bool)
(assert
 (forall ((a! Poly) (m! Poly)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.
     a! m!
    ) (and
     (=>
      %%global_location_label%%9
      (> (%I m!) 1)
     )
     (=>
      %%global_location_label%%10
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

;; Function-Axioms curve25519_dalek::backend::serial::u64::constants::INVSQRT_A_MINUS_D
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.constants.INVSQRT_A_MINUS_D.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.constants.INVSQRT_A_MINUS_D.)
  (= curve25519_dalek!backend.serial.u64.constants.INVSQRT_A_MINUS_D.? (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
    (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I 278908739862762) (I 821645201101625)
       (I 8113234426968) (I 1777959178193151) (I 2118520810568447)
)))))))
(assert
 (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.constants.INVSQRT_A_MINUS_D.?)
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
      :qid user_curve25519_dalek__specs__field_specs__u8_32_from_nat_21
      :skolemid skolem_user_curve25519_dalek__specs__field_specs__u8_32_from_nat_21
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

;; Function-Axioms curve25519_dalek::specs::primality_specs::is_prime
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.primality_specs.is_prime.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.primality_specs.is_prime.)
  (forall ((n! Poly)) (!
    (= (curve25519_dalek!specs.primality_specs.is_prime.? n!) (and
      (> (%I n!) 1)
      (forall ((d$ Int)) (!
        (=>
         (<= 0 d$)
         (=>
          (let
           ((tmp%%$ d$))
           (and
            (< 1 tmp%%$)
            (< tmp%%$ (%I n!))
          ))
          (not (= (EucMod (%I n!) d$) 0))
        ))
        :pattern ((EucMod (%I n!) d$))
        :qid user_curve25519_dalek__specs__primality_specs__is_prime_22
        :skolemid skolem_user_curve25519_dalek__specs__primality_specs__is_prime_22
    ))))
    :pattern ((curve25519_dalek!specs.primality_specs.is_prime.? n!))
    :qid internal_curve25519_dalek!specs.primality_specs.is_prime.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.primality_specs.is_prime.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::ristretto_specs::ristretto_compress_extended
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.ristretto_specs.ristretto_compress_extended.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.ristretto_specs.ristretto_compress_extended.)
  (forall ((x! Poly) (y! Poly) (z! Poly) (t! Poly)) (!
    (= (curve25519_dalek!specs.ristretto_specs.ristretto_compress_extended.? x! y! z! t!)
     (let
      ((u1$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_add.?
           z! y!
          )
         ) (I (curve25519_dalek!specs.field_specs.field_sub.? z! y!))
      )))
      (let
       ((u2$ (curve25519_dalek!specs.field_specs.field_mul.? x! y!)))
       (let
        ((invsqrt$ (curve25519_dalek!specs.field_specs.nat_invsqrt.? (I (curve25519_dalek!specs.field_specs.field_mul.?
             (I u1$) (I (curve25519_dalek!specs.field_specs.field_square.? (I u2$)))
        )))))
        (let
         ((i1$ (curve25519_dalek!specs.field_specs.field_mul.? (I invsqrt$) (I u1$))))
         (let
          ((i2$ (curve25519_dalek!specs.field_specs.field_mul.? (I invsqrt$) (I u2$))))
          (let
           ((z_inv$ (curve25519_dalek!specs.field_specs.field_mul.? (I i1$) (I (curve25519_dalek!specs.field_specs.field_mul.?
                (I i2$) t!
           )))))
           (let
            ((den_inv$ i2$))
            (let
             ((iX$ (curve25519_dalek!specs.field_specs.field_mul.? x! (I (curve25519_dalek!specs.field_specs.sqrt_m1.?
                  (I 0)
             )))))
             (let
              ((iY$ (curve25519_dalek!specs.field_specs.field_mul.? y! (I (curve25519_dalek!specs.field_specs.sqrt_m1.?
                   (I 0)
              )))))
              (let
               ((enchanted_denominator$ (curve25519_dalek!specs.field_specs.field_mul.? (I i1$) (I (
                    curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                     curve25519_dalek!backend.serial.u64.constants.INVSQRT_A_MINUS_D.?
               ))))))
               (let
                ((rotate$ (curve25519_dalek!specs.field_specs.is_negative.? (I (curve25519_dalek!specs.field_specs.field_mul.?
                     t! (I z_inv$)
                )))))
                (let
                 ((x_rot$ (ite
                    rotate$
                    iY$
                    (%I x!)
                 )))
                 (let
                  ((y_rot$ (ite
                     rotate$
                     iX$
                     (%I y!)
                  )))
                  (let
                   ((den_inv_rot$ (ite
                      rotate$
                      enchanted_denominator$
                      den_inv$
                   )))
                   (let
                    ((y_final$ (ite
                       (curve25519_dalek!specs.field_specs.is_negative.? (I (curve25519_dalek!specs.field_specs.field_mul.?
                          (I x_rot$) (I z_inv$)
                       )))
                       (curve25519_dalek!specs.field_specs.field_neg.? (I y_rot$))
                       y_rot$
                    )))
                    (let
                     ((s$ (curve25519_dalek!specs.field_specs.field_mul.? (I den_inv_rot$) (I (curve25519_dalek!specs.field_specs.field_sub.?
                          z! (I y_final$)
                     )))))
                     (let
                      ((s_final$ (ite
                         (curve25519_dalek!specs.field_specs.is_negative.? (I s$))
                         (curve25519_dalek!specs.field_specs.field_neg.? (I s$))
                         s$
                      )))
                      (curve25519_dalek!specs.field_specs.u8_32_from_nat.? (I s_final$))
    ))))))))))))))))))
    :pattern ((curve25519_dalek!specs.ristretto_specs.ristretto_compress_extended.? x!
      y! z! t!
    ))
    :qid internal_curve25519_dalek!specs.ristretto_specs.ristretto_compress_extended.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.ristretto_specs.ristretto_compress_extended.?_definition
))))
(assert
 (forall ((x! Poly) (y! Poly) (z! Poly) (t! Poly)) (!
   (=>
    (and
     (has_type x! NAT)
     (has_type y! NAT)
     (has_type z! NAT)
     (has_type t! NAT)
    )
    (has_type (Poly%array%. (curve25519_dalek!specs.ristretto_specs.ristretto_compress_extended.?
       x! y! z! t!
      )
     ) (ARRAY $ (UINT 8) $ (CONST_INT 32))
   ))
   :pattern ((curve25519_dalek!specs.ristretto_specs.ristretto_compress_extended.? x!
     y! z! t!
   ))
   :qid internal_curve25519_dalek!specs.ristretto_specs.ristretto_compress_extended.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.ristretto_specs.ristretto_compress_extended.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::ristretto_specs::ristretto_compress_affine
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.ristretto_specs.ristretto_compress_affine.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.ristretto_specs.ristretto_compress_affine.)
  (forall ((x! Poly) (y! Poly)) (!
    (= (curve25519_dalek!specs.ristretto_specs.ristretto_compress_affine.? x! y!) (curve25519_dalek!specs.ristretto_specs.ristretto_compress_extended.?
      x! y! (I 1) (I (curve25519_dalek!specs.field_specs.field_mul.? x! y!))
    ))
    :pattern ((curve25519_dalek!specs.ristretto_specs.ristretto_compress_affine.? x! y!))
    :qid internal_curve25519_dalek!specs.ristretto_specs.ristretto_compress_affine.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.ristretto_specs.ristretto_compress_affine.?_definition
))))
(assert
 (forall ((x! Poly) (y! Poly)) (!
   (=>
    (and
     (has_type x! NAT)
     (has_type y! NAT)
    )
    (has_type (Poly%array%. (curve25519_dalek!specs.ristretto_specs.ristretto_compress_affine.?
       x! y!
      )
     ) (ARRAY $ (UINT 8) $ (CONST_INT 32))
   ))
   :pattern ((curve25519_dalek!specs.ristretto_specs.ristretto_compress_affine.? x! y!))
   :qid internal_curve25519_dalek!specs.ristretto_specs.ristretto_compress_affine.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.ristretto_specs.ristretto_compress_affine.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::ristretto_specs::batch_compress_body
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.ristretto_specs.batch_compress_body.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.ristretto_specs.batch_compress_body.)
  (forall ((e! Poly) (f! Poly) (g! Poly) (h! Poly) (eg! Poly) (fh! Poly) (inv! Poly))
   (!
    (= (curve25519_dalek!specs.ristretto_specs.batch_compress_body.? e! f! g! h! eg! fh!
      inv!
     ) (let
      ((zinv$ (curve25519_dalek!specs.field_specs.field_mul.? eg! inv!)))
      (let
       ((tinv$ (curve25519_dalek!specs.field_specs.field_mul.? fh! inv!)))
       (let
        ((invsqrt_a_minus_d$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
            curve25519_dalek!backend.serial.u64.constants.INVSQRT_A_MINUS_D.?
        ))))
        (let
         ((negcheck1$ (curve25519_dalek!specs.field_specs.is_negative.? (I (curve25519_dalek!specs.field_specs.field_mul.?
              eg! (I zinv$)
         )))))
         (let
          ((minus_e$ (curve25519_dalek!specs.field_specs.field_neg.? e!)))
          (let
           ((f_times_sqrta$ (curve25519_dalek!specs.field_specs.field_mul.? f! (I (curve25519_dalek!specs.field_specs.sqrt_m1.?
                (I 0)
           )))))
           (let
            ((e_rot$ (%I (ite
                negcheck1$
                g!
                e!
            ))))
            (let
             ((g_rot$ (ite
                negcheck1$
                minus_e$
                (%I g!)
             )))
             (let
              ((h_rot$ (ite
                 negcheck1$
                 f_times_sqrta$
                 (%I h!)
              )))
              (let
               ((magic$ (ite
                  negcheck1$
                  (curve25519_dalek!specs.field_specs.sqrt_m1.? (I 0))
                  invsqrt_a_minus_d$
               )))
               (let
                ((negcheck2$ (curve25519_dalek!specs.field_specs.is_negative.? (I (curve25519_dalek!specs.field_specs.field_mul.?
                     (I (curve25519_dalek!specs.field_specs.field_mul.? (I h_rot$) (I e_rot$))) (I zinv$)
                )))))
                (let
                 ((g_final$ (ite
                    negcheck2$
                    (curve25519_dalek!specs.field_specs.field_neg.? (I g_rot$))
                    g_rot$
                 )))
                 (let
                  ((s$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_sub.?
                       (I h_rot$) (I g_final$)
                      )
                     ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I magic$) (I (curve25519_dalek!specs.field_specs.field_mul.?
                         (I g_final$) (I tinv$)
                  )))))))
                  (let
                   ((s_final$ (ite
                      (curve25519_dalek!specs.field_specs.is_negative.? (I s$))
                      (curve25519_dalek!specs.field_specs.field_neg.? (I s$))
                      s$
                   )))
                   (curve25519_dalek!specs.field_specs.u8_32_from_nat.? (I s_final$))
    )))))))))))))))
    :pattern ((curve25519_dalek!specs.ristretto_specs.batch_compress_body.? e! f! g! h!
      eg! fh! inv!
    ))
    :qid internal_curve25519_dalek!specs.ristretto_specs.batch_compress_body.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.ristretto_specs.batch_compress_body.?_definition
))))
(assert
 (forall ((e! Poly) (f! Poly) (g! Poly) (h! Poly) (eg! Poly) (fh! Poly) (inv! Poly))
  (!
   (=>
    (and
     (has_type e! NAT)
     (has_type f! NAT)
     (has_type g! NAT)
     (has_type h! NAT)
     (has_type eg! NAT)
     (has_type fh! NAT)
     (has_type inv! NAT)
    )
    (has_type (Poly%array%. (curve25519_dalek!specs.ristretto_specs.batch_compress_body.?
       e! f! g! h! eg! fh! inv!
      )
     ) (ARRAY $ (UINT 8) $ (CONST_INT 32))
   ))
   :pattern ((curve25519_dalek!specs.ristretto_specs.batch_compress_body.? e! f! g! h!
     eg! fh! inv!
   ))
   :qid internal_curve25519_dalek!specs.ristretto_specs.batch_compress_body.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.ristretto_specs.batch_compress_body.?_pre_post_definition
)))

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

;; Function-Specs curve25519_dalek::specs::primality_specs::axiom_p_is_prime
(declare-fun ens%curve25519_dalek!specs.primality_specs.axiom_p_is_prime. (Int) Bool)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!specs.primality_specs.axiom_p_is_prime. no%param) (curve25519_dalek!specs.primality_specs.is_prime.?
     (I (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
   ))
   :pattern ((ens%curve25519_dalek!specs.primality_specs.axiom_p_is_prime. no%param))
   :qid internal_ens__curve25519_dalek!specs.primality_specs.axiom_p_is_prime._definition
   :skolemid skolem_internal_ens__curve25519_dalek!specs.primality_specs.axiom_p_is_prime._definition
)))

;; Function-Specs curve25519_dalek::specs::field_specs::field_inv_property
(declare-fun req%curve25519_dalek!specs.field_specs.field_inv_property. (Int) Bool)
(declare-const %%global_location_label%%11 Bool)
(assert
 (forall ((a! Int)) (!
   (= (req%curve25519_dalek!specs.field_specs.field_inv_property. a!) (=>
     %%global_location_label%%11
     (not (= (EucMod a! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
   ))
   :pattern ((req%curve25519_dalek!specs.field_specs.field_inv_property. a!))
   :qid internal_req__curve25519_dalek!specs.field_specs.field_inv_property._definition
   :skolemid skolem_internal_req__curve25519_dalek!specs.field_specs.field_inv_property._definition
)))
(declare-fun ens%curve25519_dalek!specs.field_specs.field_inv_property. (Int) Bool)
(assert
 (forall ((a! Int)) (!
   (= (ens%curve25519_dalek!specs.field_specs.field_inv_property. a!) (and
     (< (curve25519_dalek!specs.field_specs.field_inv.? (I a!)) (curve25519_dalek!specs.field_specs_u64.p.?
       (I 0)
     ))
     (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs_u64.field_canonical.?
         (I a!)
        )
       ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I a!)))
      ) 1
   )))
   :pattern ((ens%curve25519_dalek!specs.field_specs.field_inv_property. a!))
   :qid internal_ens__curve25519_dalek!specs.field_specs.field_inv_property._definition
   :skolemid skolem_internal_ens__curve25519_dalek!specs.field_specs.field_inv_property._definition
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
(declare-const %%global_location_label%%12 Bool)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_left.
     a! b!
    ) (=>
     %%global_location_label%%12
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

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_inv_mul_cancel
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_mul_cancel.
 (Int) Bool
)
(declare-const %%global_location_label%%13 Bool)
(assert
 (forall ((a! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_mul_cancel.
     a!
    ) (=>
     %%global_location_label%%13
     (not (= (EucMod a! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
   ))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_mul_cancel.
     a!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_mul_cancel._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_mul_cancel._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_mul_cancel.
 (Int) Bool
)
(assert
 (forall ((a! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_mul_cancel.
     a!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_inv.?
        (I a!)
       )
      ) (I a!)
     ) 1
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_mul_cancel.
     a!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_mul_cancel._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_mul_cancel._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_mul_assoc
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_assoc.
 (Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (c! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_assoc.
     a! b! c!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I a!) (I b!)
       )
      ) (I c!)
     ) (curve25519_dalek!specs.field_specs.field_mul.? (I a!) (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I b!) (I c!)
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_assoc.
     a! b! c!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_assoc._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_assoc._definition
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

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_sub_eq_add_neg
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_eq_add_neg.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_eq_add_neg.
     a! b!
    ) (= (curve25519_dalek!specs.field_specs.field_sub.? (I a!) (I b!)) (curve25519_dalek!specs.field_specs.field_add.?
      (I a!) (I (curve25519_dalek!specs.field_specs.field_neg.? (I b!)))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_eq_add_neg.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_eq_add_neg._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_eq_add_neg._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::lemma_euclid_prime
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_euclid_prime.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%14 Bool)
(declare-const %%global_location_label%%15 Bool)
(assert
 (forall ((a! Int) (b! Int) (p! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_euclid_prime.
     a! b! p!
    ) (and
     (=>
      %%global_location_label%%14
      (curve25519_dalek!specs.primality_specs.is_prime.? (I p!))
     )
     (=>
      %%global_location_label%%15
      (= (EucMod (nClip (Mul a! b!)) p!) 0)
   )))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_euclid_prime.
     a! b! p!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_euclid_prime._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_euclid_prime._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_euclid_prime.
 (Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (p! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_euclid_prime.
     a! b! p!
    ) (or
     (= (EucMod a! p!) 0)
     (= (EucMod b! p!) 0)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_euclid_prime.
     a! b! p!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_euclid_prime._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_euclid_prime._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_mul_zero_right
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right.
 (Int Int) Bool
)
(declare-const %%global_location_label%%16 Bool)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right.
     a! b!
    ) (=>
     %%global_location_label%%16
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

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_mul_comm
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_comm.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_comm.
     a! b!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I a!) (I b!)) (curve25519_dalek!specs.field_specs.field_mul.?
      (I b!) (I a!)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_comm.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_comm._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_comm._definition
)))

;; Function-Specs curve25519_dalek::specs::field_specs::field_inv_zero
(declare-fun ens%curve25519_dalek!specs.field_specs.field_inv_zero. (Int) Bool)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!specs.field_specs.field_inv_zero. no%param) (= (curve25519_dalek!specs.field_specs.field_inv.?
      (I 0)
     ) 0
   ))
   :pattern ((ens%curve25519_dalek!specs.field_specs.field_inv_zero. no%param))
   :qid internal_ens__curve25519_dalek!specs.field_specs.field_inv_zero._definition
   :skolemid skolem_internal_ens__curve25519_dalek!specs.field_specs.field_inv_zero._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_element_reduced
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_element_reduced.
 (Int) Bool
)
(declare-const %%global_location_label%%17 Bool)
(assert
 (forall ((x! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_element_reduced.
     x!
    ) (=>
     %%global_location_label%%17
     (< x! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
   ))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_element_reduced.
     x!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_element_reduced._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_element_reduced._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_element_reduced.
 (Int) Bool
)
(assert
 (forall ((x! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_element_reduced.
     x!
    ) (= (EucMod x! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) x!)
   )
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_element_reduced.
     x!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_element_reduced._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_element_reduced._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_inv_of_product
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_of_product.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_of_product.
     a! b!
    ) (= (curve25519_dalek!specs.field_specs.field_inv.? (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I a!) (I b!)
      ))
     ) (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_inv.?
        (I a!)
       )
      ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I b!)))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_of_product.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_of_product._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_of_product._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_cancel_common_factor
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_cancel_common_factor.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%18 Bool)
(declare-const %%global_location_label%%19 Bool)
(assert
 (forall ((a! Int) (b! Int) (c! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_cancel_common_factor.
     a! b! c!
    ) (and
     (=>
      %%global_location_label%%18
      (not (= (EucMod b! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
     )
     (=>
      %%global_location_label%%19
      (not (= (EucMod c! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
   )))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_cancel_common_factor.
     a! b! c!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_cancel_common_factor._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_cancel_common_factor._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_cancel_common_factor.
 (Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (c! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_cancel_common_factor.
     a! b! c!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I a!) (I c!)
       )
      ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I (curve25519_dalek!specs.field_specs.field_mul.?
          (I b!) (I c!)
      ))))
     ) (curve25519_dalek!specs.field_specs.field_mul.? (I a!) (I (curve25519_dalek!specs.field_specs.field_inv.?
        (I b!)
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_cancel_common_factor.
     a! b! c!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_cancel_common_factor._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_cancel_common_factor._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_four_factor_rearrange
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_four_factor_rearrange.
 (Int Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (c! Int) (d! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_four_factor_rearrange.
     a! b! c! d!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I a!) (I b!)
       )
      ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I c!) (I d!)))
     ) (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I a!) (I c!)
       )
      ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I b!) (I d!)))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_four_factor_rearrange.
     a! b! c! d!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_four_factor_rearrange._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_four_factor_rearrange._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_nonzero_product
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_nonzero_product.
 (Int Int) Bool
)
(declare-const %%global_location_label%%20 Bool)
(declare-const %%global_location_label%%21 Bool)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_nonzero_product.
     a! b!
    ) (and
     (=>
      %%global_location_label%%20
      (not (= (EucMod a! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
     )
     (=>
      %%global_location_label%%21
      (not (= (EucMod b! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
   )))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_nonzero_product.
     a! b!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_nonzero_product._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_nonzero_product._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_nonzero_product.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_nonzero_product.
     a! b!
    ) (not (= (curve25519_dalek!specs.field_specs.field_mul.? (I a!) (I b!)) 0))
   )
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_nonzero_product.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_nonzero_product._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_nonzero_product._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_product_of_squares_eq_square_of_product
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_product_of_squares_eq_square_of_product.
 (Int Int) Bool
)
(assert
 (forall ((x! Int) (y! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_product_of_squares_eq_square_of_product.
     x! y!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_square.?
        (I x!)
       )
      ) (I (curve25519_dalek!specs.field_specs.field_square.? (I y!)))
     ) (curve25519_dalek!specs.field_specs.field_square.? (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I x!) (I y!)
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_product_of_squares_eq_square_of_product.
     x! y!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_product_of_squares_eq_square_of_product._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_product_of_squares_eq_square_of_product._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_quotient_of_squares
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_quotient_of_squares.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_quotient_of_squares.
     a! b!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_square.?
        (I a!)
       )
      ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I (curve25519_dalek!specs.field_specs.field_square.?
          (I b!)
      ))))
     ) (curve25519_dalek!specs.field_specs.field_square.? (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I a!) (I (curve25519_dalek!specs.field_specs.field_inv.? (I b!)))
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_quotient_of_squares.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_quotient_of_squares._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_quotient_of_squares._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_mul_distributes_over_add
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_distributes_over_add.
 (Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (c! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_distributes_over_add.
     a! b! c!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I a!) (I (curve25519_dalek!specs.field_specs.field_add.?
        (I b!) (I c!)
      ))
     ) (curve25519_dalek!specs.field_specs.field_add.? (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I a!) (I b!)
       )
      ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I a!) (I c!)))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_distributes_over_add.
     a! b! c!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_distributes_over_add._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_distributes_over_add._definition
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

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_mul_distributes_over_sub_right
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_distributes_over_sub_right.
 (Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (c! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_distributes_over_sub_right.
     a! b! c!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_sub.?
        (I a!) (I b!)
       )
      ) (I c!)
     ) (curve25519_dalek!specs.field_specs.field_sub.? (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I a!) (I c!)
       )
      ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I b!) (I c!)))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_distributes_over_sub_right.
     a! b! c!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_distributes_over_sub_right._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_distributes_over_sub_right._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_mul_one_left
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_one_left.
 (Int) Bool
)
(assert
 (forall ((a! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_one_left.
     a!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I 1) (I a!)) (EucMod a! (curve25519_dalek!specs.field_specs_u64.p.?
       (I 0)
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_one_left.
     a!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_one_left._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_one_left._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::niels_addition_correctness::lemma_projective_product_factor
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.niels_addition_correctness.lemma_projective_product_factor.
 (Int Int Int Int) Bool
)
(declare-const %%global_location_label%%22 Bool)
(declare-const %%global_location_label%%23 Bool)
(declare-const %%global_location_label%%24 Bool)
(declare-const %%global_location_label%%25 Bool)
(assert
 (forall ((a_proj! Int) (z_a! Int) (b_proj! Int) (z_b! Int)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.niels_addition_correctness.lemma_projective_product_factor.
     a_proj! z_a! b_proj! z_b!
    ) (and
     (=>
      %%global_location_label%%22
      (not (= (EucMod z_a! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
     )
     (=>
      %%global_location_label%%23
      (not (= (EucMod z_b! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
     )
     (=>
      %%global_location_label%%24
      (< a_proj! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%25
      (< b_proj! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
   )))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.niels_addition_correctness.lemma_projective_product_factor.
     a_proj! z_a! b_proj! z_b!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.niels_addition_correctness.lemma_projective_product_factor._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.niels_addition_correctness.lemma_projective_product_factor._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.niels_addition_correctness.lemma_projective_product_factor.
 (Int Int Int Int) Bool
)
(assert
 (forall ((a_proj! Int) (z_a! Int) (b_proj! Int) (z_b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.niels_addition_correctness.lemma_projective_product_factor.
     a_proj! z_a! b_proj! z_b!
    ) (let
     ((a$ (curve25519_dalek!specs.field_specs.field_mul.? (I a_proj!) (I (curve25519_dalek!specs.field_specs.field_inv.?
          (I z_a!)
     )))))
     (let
      ((b$ (curve25519_dalek!specs.field_specs.field_mul.? (I b_proj!) (I (curve25519_dalek!specs.field_specs.field_inv.?
           (I z_b!)
      )))))
      (= (curve25519_dalek!specs.field_specs.field_mul.? (I a_proj!) (I b_proj!)) (curve25519_dalek!specs.field_specs.field_mul.?
        (I (curve25519_dalek!specs.field_specs.field_mul.? (I a$) (I b$))) (I (curve25519_dalek!specs.field_specs.field_mul.?
          (I z_a!) (I z_b!)
   )))))))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.niels_addition_correctness.lemma_projective_product_factor.
     a_proj! z_a! b_proj! z_b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.niels_addition_correctness.lemma_projective_product_factor._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.niels_addition_correctness.lemma_projective_product_factor._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_factor_result_component_add
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_factor_result_component_add.
 (Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (z! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_factor_result_component_add.
     a! b! z!
    ) (= (curve25519_dalek!specs.field_specs.field_add.? (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I a!) (I z!)
       )
      ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I b!) (I z!)))
     ) (curve25519_dalek!specs.field_specs.field_mul.? (I z!) (I (curve25519_dalek!specs.field_specs.field_add.?
        (I a!) (I b!)
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_factor_result_component_add.
     a! b! z!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_factor_result_component_add._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_factor_result_component_add._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_mul_left_cancel
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_left_cancel.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%26 Bool)
(declare-const %%global_location_label%%27 Bool)
(assert
 (forall ((a! Int) (b! Int) (c! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_left_cancel.
     a! b! c!
    ) (and
     (=>
      %%global_location_label%%26
      (not (= (EucMod a! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
     )
     (=>
      %%global_location_label%%27
      (= (curve25519_dalek!specs.field_specs.field_mul.? (I a!) (I b!)) (curve25519_dalek!specs.field_specs.field_mul.?
        (I a!) (I c!)
   )))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_left_cancel.
     a! b! c!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_left_cancel._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_left_cancel._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_left_cancel.
 (Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (c! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_left_cancel.
     a! b! c!
    ) (= (EucMod b! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) (EucMod c! (curve25519_dalek!specs.field_specs_u64.p.?
       (I 0)
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_left_cancel.
     a! b! c!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_left_cancel._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_left_cancel._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_add_self_eq_double
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_add_self_eq_double.
 (Int) Bool
)
(assert
 (forall ((a! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_add_self_eq_double.
     a!
    ) (= (curve25519_dalek!specs.field_specs.field_add.? (I a!) (I a!)) (curve25519_dalek!specs.field_specs.field_mul.?
      (I 2) (I a!)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_add_self_eq_double.
     a!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_add_self_eq_double._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_add_self_eq_double._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_factor_result_component_sub
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_factor_result_component_sub.
 (Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (z! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_factor_result_component_sub.
     a! b! z!
    ) (= (curve25519_dalek!specs.field_specs.field_sub.? (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I a!) (I z!)
       )
      ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I b!) (I z!)))
     ) (curve25519_dalek!specs.field_specs.field_mul.? (I z!) (I (curve25519_dalek!specs.field_specs.field_sub.?
        (I a!) (I b!)
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_factor_result_component_sub.
     a! b! z!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_factor_result_component_sub._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_factor_result_component_sub._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_reassociate_2_z_num
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_reassociate_2_z_num.
 (Int Int) Bool
)
(assert
 (forall ((z! Int) (num! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_reassociate_2_z_num.
     z! num!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I 2) (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I z!) (I num!)
      ))
     ) (curve25519_dalek!specs.field_specs.field_mul.? (I z!) (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I 2) (I num!)
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_reassociate_2_z_num.
     z! num!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_reassociate_2_z_num._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_reassociate_2_z_num._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_add_comm
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_comm.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_comm.
     a! b!
    ) (= (curve25519_dalek!specs.field_specs.field_add.? (I a!) (I b!)) (curve25519_dalek!specs.field_specs.field_add.?
      (I b!) (I a!)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_comm.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_comm._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_comm._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_mul_exchange
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_exchange.
 (Int Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (c! Int) (d! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_exchange.
     a! b! c! d!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I a!) (I b!)
       )
      ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I c!) (I d!)))
     ) (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I a!) (I c!)
       )
      ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I b!) (I d!)))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_exchange.
     a! b! c! d!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_exchange._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_exchange._definition
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

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_sub_neg_eq_add
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_sub_neg_eq_add.
 (Int Int) Bool
)
(assert
 (forall ((c! Int) (d! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_sub_neg_eq_add.
     c! d!
    ) (= (curve25519_dalek!specs.field_specs.field_sub.? (I c!) (I (curve25519_dalek!specs.field_specs.field_neg.?
        (I d!)
      ))
     ) (curve25519_dalek!specs.field_specs.field_add.? (I c!) (I d!))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_sub_neg_eq_add.
     c! d!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_sub_neg_eq_add._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_sub_neg_eq_add._definition
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

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_sub_antisymmetric
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_antisymmetric.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_antisymmetric.
     a! b!
    ) (= (curve25519_dalek!specs.field_specs.field_sub.? (I b!) (I a!)) (curve25519_dalek!specs.field_specs.field_neg.?
      (I (curve25519_dalek!specs.field_specs.field_sub.? (I a!) (I b!)))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_antisymmetric.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_antisymmetric._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_antisymmetric._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_projective_implies_affine_on_curve
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_implies_affine_on_curve.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%28 Bool)
(declare-const %%global_location_label%%29 Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_projective_implies_affine_on_curve.
     x! y! z!
    ) (and
     (=>
      %%global_location_label%%28
      (not (= (EucMod z! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
     )
     (=>
      %%global_location_label%%29
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

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::constants_lemmas::lemma_d_plus_one_nonzero
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.constants_lemmas.lemma_d_plus_one_nonzero.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.constants_lemmas.lemma_d_plus_one_nonzero.
     no%param
    ) (not (= (curve25519_dalek!specs.field_specs.field_add.? (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
         (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?)
        )
       ) (I 1)
      ) 0
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.constants_lemmas.lemma_d_plus_one_nonzero.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.constants_lemmas.lemma_d_plus_one_nonzero._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.constants_lemmas.lemma_d_plus_one_nonzero._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_add_assoc
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_assoc.
 (Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (c! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_assoc.
     a! b! c!
    ) (= (curve25519_dalek!specs.field_specs.field_add.? (I (curve25519_dalek!specs.field_specs.field_add.?
        (I a!) (I b!)
       )
      ) (I c!)
     ) (curve25519_dalek!specs.field_specs.field_add.? (I a!) (I (curve25519_dalek!specs.field_specs.field_add.?
        (I b!) (I c!)
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_assoc.
     a! b! c!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_assoc._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_assoc._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_diff_of_squares
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_diff_of_squares.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_diff_of_squares.
     a! b!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_sub.?
        (I a!) (I b!)
       )
      ) (I (curve25519_dalek!specs.field_specs.field_add.? (I a!) (I b!)))
     ) (curve25519_dalek!specs.field_specs.field_sub.? (I (curve25519_dalek!specs.field_specs.field_square.?
        (I a!)
       )
      ) (I (curve25519_dalek!specs.field_specs.field_square.? (I b!)))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_diff_of_squares.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_diff_of_squares._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_diff_of_squares._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_sub_add_cancel
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_add_cancel.
 (Int Int) Bool
)
(declare-const %%global_location_label%%30 Bool)
(declare-const %%global_location_label%%31 Bool)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_add_cancel.
     a! b!
    ) (and
     (=>
      %%global_location_label%%30
      (< a! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%31
      (< b! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
   )))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_add_cancel.
     a! b!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_add_cancel._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_add_cancel._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_add_cancel.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_add_cancel.
     a! b!
    ) (= (curve25519_dalek!specs.field_specs.field_sub.? (I (curve25519_dalek!specs.field_specs.field_add.?
        (I a!) (I b!)
       )
      ) (I b!)
     ) a!
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_add_cancel.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_add_cancel._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_add_cancel._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_add_sub_cancel
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_sub_cancel.
 (Int Int) Bool
)
(declare-const %%global_location_label%%32 Bool)
(declare-const %%global_location_label%%33 Bool)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_sub_cancel.
     a! b!
    ) (and
     (=>
      %%global_location_label%%32
      (< a! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%33
      (< b! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
   )))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_sub_cancel.
     a! b!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_sub_cancel._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_sub_cancel._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_sub_cancel.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_sub_cancel.
     a! b!
    ) (= (curve25519_dalek!specs.field_specs.field_add.? (I (curve25519_dalek!specs.field_specs.field_sub.?
        (I a!) (I b!)
       )
      ) (I b!)
     ) a!
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_sub_cancel.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_sub_cancel._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_sub_cancel._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_a_times_inv_ab_is_inv_b
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_a_times_inv_ab_is_inv_b.
 (Int Int) Bool
)
(declare-const %%global_location_label%%34 Bool)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_a_times_inv_ab_is_inv_b.
     a! b!
    ) (=>
     %%global_location_label%%34
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

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_neg_one_times_is_neg
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_neg_one_times_is_neg.
 (Int) Bool
)
(assert
 (forall ((a! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_neg_one_times_is_neg.
     a!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_neg.?
        (I 1)
       )
      ) (I a!)
     ) (curve25519_dalek!specs.field_specs.field_neg.? (I a!))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_neg_one_times_is_neg.
     a!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_neg_one_times_is_neg._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_neg_one_times_is_neg._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_neg_nonzero
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_neg_nonzero.
 (Int) Bool
)
(declare-const %%global_location_label%%35 Bool)
(assert
 (forall ((a! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_neg_nonzero.
     a!
    ) (=>
     %%global_location_label%%35
     (not (= (EucMod a! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
   ))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_neg_nonzero.
     a!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_neg_nonzero._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_neg_nonzero._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_neg_nonzero.
 (Int) Bool
)
(assert
 (forall ((a! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_neg_nonzero.
     a!
    ) (not (= (curve25519_dalek!specs.field_specs.field_neg.? (I a!)) 0))
   )
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_neg_nonzero.
     a!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_neg_nonzero._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_neg_nonzero._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_square_nonzero
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_square_nonzero.
 (Int) Bool
)
(declare-const %%global_location_label%%36 Bool)
(declare-const %%global_location_label%%37 Bool)
(assert
 (forall ((z! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_square_nonzero.
     z!
    ) (and
     (=>
      %%global_location_label%%36
      (< z! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%37
      (not (= (EucMod z! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
   )))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_square_nonzero.
     z!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_square_nonzero._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_square_nonzero._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_square_nonzero.
 (Int) Bool
)
(assert
 (forall ((z! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_square_nonzero.
     z!
    ) (not (= (EucMod (curve25519_dalek!specs.field_specs.field_square.? (I z!)) (curve25519_dalek!specs.field_specs_u64.p.?
        (I 0)
       )
      ) 0
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_square_nonzero.
     z!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_square_nonzero._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_square_nonzero._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_mul_one_identity
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_mul_one_identity.
 (Int) Bool
)
(declare-const %%global_location_label%%38 Bool)
(assert
 (forall ((a! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_mul_one_identity.
     a!
    ) (=>
     %%global_location_label%%38
     (< a! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
   ))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_mul_one_identity.
     a!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_mul_one_identity._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_mul_one_identity._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_mul_one_identity.
 (Int) Bool
)
(assert
 (forall ((a! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_mul_one_identity.
     a!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I a!) (I 1)) a!)
   )
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_mul_one_identity.
     a!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_mul_one_identity._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_mul_one_identity._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_sum_sq_minus_diff_sq
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_sum_sq_minus_diff_sq.
 (Int Int) Bool
)
(assert
 (forall ((x! Int) (y! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_sum_sq_minus_diff_sq.
     x! y!
    ) (= (curve25519_dalek!specs.field_specs.field_sub.? (I (curve25519_dalek!specs.field_specs.field_square.?
        (I (curve25519_dalek!specs.field_specs.field_add.? (I x!) (I y!)))
       )
      ) (I (curve25519_dalek!specs.field_specs.field_square.? (I (curve25519_dalek!specs.field_specs.field_sub.?
          (I x!) (I y!)
      ))))
     ) (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I 2) (I 2)
       )
      ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I x!) (I y!)))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_sum_sq_minus_diff_sq.
     x! y!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_sum_sq_minus_diff_sq._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_sum_sq_minus_diff_sq._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_abs_neg
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_abs_neg.
 (Int) Bool
)
(declare-const %%global_location_label%%39 Bool)
(assert
 (forall ((a! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_abs_neg.
     a!
    ) (=>
     %%global_location_label%%39
     (< a! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
   ))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_abs_neg.
     a!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_abs_neg._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_abs_neg._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_abs_neg.
 (Int) Bool
)
(assert
 (forall ((a! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_abs_neg.
     a!
    ) (= (curve25519_dalek!specs.field_specs.field_abs.? (I (curve25519_dalek!specs.field_specs.field_neg.?
        (I a!)
      ))
     ) (curve25519_dalek!specs.field_specs.field_abs.? (I a!))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_abs_neg.
     a!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_abs_neg._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_abs_neg._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_abs_mul_sign
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_abs_mul_sign.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%40 Bool)
(assert
 (forall ((a! Int) (b! Int) (x! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_abs_mul_sign.
     a! b! x!
    ) (=>
     %%global_location_label%%40
     (or
      (= a! b!)
      (= a! (curve25519_dalek!specs.field_specs.field_neg.? (I b!)))
   )))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_abs_mul_sign.
     a! b! x!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_abs_mul_sign._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_abs_mul_sign._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_abs_mul_sign.
 (Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (x! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_abs_mul_sign.
     a! b! x!
    ) (= (curve25519_dalek!specs.field_specs.field_abs.? (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I a!) (I x!)
      ))
     ) (curve25519_dalek!specs.field_specs.field_abs.? (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I b!) (I x!)
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_abs_mul_sign.
     a! b! x!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_abs_mul_sign._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_abs_mul_sign._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_m1_lemmas::lemma_mul_i_squared_is_neg
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_mul_i_squared_is_neg.
 (Int) Bool
)
(assert
 (forall ((a! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_mul_i_squared_is_neg.
     a!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I a!) (I (curve25519_dalek!specs.field_specs.sqrt_m1.? (I 0)))
       )
      ) (I (curve25519_dalek!specs.field_specs.sqrt_m1.? (I 0)))
     ) (curve25519_dalek!specs.field_specs.field_neg.? (I a!))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_mul_i_squared_is_neg.
     a!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_mul_i_squared_is_neg._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_mul_i_squared_is_neg._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_m1_lemmas::lemma_one_minus_x_times_i
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_one_minus_x_times_i.
 (Int Int) Bool
)
(declare-const %%global_location_label%%41 Bool)
(assert
 (forall ((e! Int) (f! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_one_minus_x_times_i.
     e! f!
    ) (=>
     %%global_location_label%%41
     (not (= (EucMod f! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
   ))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_one_minus_x_times_i.
     e! f!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_one_minus_x_times_i._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_one_minus_x_times_i._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_one_minus_x_times_i.
 (Int Int) Bool
)
(assert
 (forall ((e! Int) (f! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_one_minus_x_times_i.
     e! f!
    ) (= (curve25519_dalek!specs.field_specs.field_sub.? (I 1) (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I (curve25519_dalek!specs.field_specs.field_mul.? (I e!) (I (curve25519_dalek!specs.field_specs.field_inv.?
            (I f!)
         )))
        ) (I (curve25519_dalek!specs.field_specs.sqrt_m1.? (I 0)))
      ))
     ) (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_sub.?
        (I f!) (I (curve25519_dalek!specs.field_specs.field_mul.? (I e!) (I (curve25519_dalek!specs.field_specs.sqrt_m1.?
            (I 0)
       )))))
      ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I f!)))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_one_minus_x_times_i.
     e! f!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_one_minus_x_times_i._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_one_minus_x_times_i._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_m1_lemmas::lemma_one_plus_x_times_i
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_one_plus_x_times_i.
 (Int Int) Bool
)
(declare-const %%global_location_label%%42 Bool)
(assert
 (forall ((e! Int) (f! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_one_plus_x_times_i.
     e! f!
    ) (=>
     %%global_location_label%%42
     (not (= (EucMod f! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
   ))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_one_plus_x_times_i.
     e! f!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_one_plus_x_times_i._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_one_plus_x_times_i._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_one_plus_x_times_i.
 (Int Int) Bool
)
(assert
 (forall ((e! Int) (f! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_one_plus_x_times_i.
     e! f!
    ) (= (curve25519_dalek!specs.field_specs.field_add.? (I 1) (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I (curve25519_dalek!specs.field_specs.field_mul.? (I e!) (I (curve25519_dalek!specs.field_specs.field_inv.?
            (I f!)
         )))
        ) (I (curve25519_dalek!specs.field_specs.sqrt_m1.? (I 0)))
      ))
     ) (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_add.?
        (I f!) (I (curve25519_dalek!specs.field_specs.field_mul.? (I e!) (I (curve25519_dalek!specs.field_specs.sqrt_m1.?
            (I 0)
       )))))
      ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I f!)))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_one_plus_x_times_i.
     e! f!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_one_plus_x_times_i._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_one_plus_x_times_i._definition
)))

;; Function-Specs curve25519_dalek::lemmas::ristretto_lemmas::axioms::axiom_invsqrt_a_minus_d
(declare-fun ens%curve25519_dalek!lemmas.ristretto_lemmas.axioms.axiom_invsqrt_a_minus_d.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.ristretto_lemmas.axioms.axiom_invsqrt_a_minus_d. no%param)
    (let
     ((c_iad$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
         curve25519_dalek!backend.serial.u64.constants.INVSQRT_A_MINUS_D.?
     ))))
     (let
      ((d$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?
      ))))
      (let
       ((neg_one_minus_d$ (curve25519_dalek!specs.field_specs.field_sub.? (I (curve25519_dalek!specs.field_specs.field_neg.?
            (I 1)
           )
          ) (I d$)
       )))
       (and
        (= (curve25519_dalek!specs.field_specs.nat_invsqrt.? (I neg_one_minus_d$)) c_iad$)
        (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_square.?
            (I c_iad$)
           )
          ) (I neg_one_minus_d$)
         ) 1
   ))))))
   :pattern ((ens%curve25519_dalek!lemmas.ristretto_lemmas.axioms.axiom_invsqrt_a_minus_d.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.ristretto_lemmas.axioms.axiom_invsqrt_a_minus_d._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.ristretto_lemmas.axioms.axiom_invsqrt_a_minus_d._definition
)))

;; Function-Specs curve25519_dalek::lemmas::ristretto_lemmas::batch_compress_lemmas::lemma_segre_derives_t
(declare-fun req%curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_segre_derives_t.
 (Int Int Int Int) Bool
)
(declare-const %%global_location_label%%43 Bool)
(declare-const %%global_location_label%%44 Bool)
(declare-const %%global_location_label%%45 Bool)
(declare-const %%global_location_label%%46 Bool)
(declare-const %%global_location_label%%47 Bool)
(declare-const %%global_location_label%%48 Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int) (t! Int)) (!
   (= (req%curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_segre_derives_t.
     x! y! z! t!
    ) (and
     (=>
      %%global_location_label%%43
      (< x! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%44
      (< y! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%45
      (< z! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%46
      (< t! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%47
      (not (= (EucMod z! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
     )
     (=>
      %%global_location_label%%48
      (= (curve25519_dalek!specs.field_specs.field_mul.? (I z!) (I t!)) (curve25519_dalek!specs.field_specs.field_mul.?
        (I x!) (I y!)
   )))))
   :pattern ((req%curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_segre_derives_t.
     x! y! z! t!
   ))
   :qid internal_req__curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_segre_derives_t._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_segre_derives_t._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_segre_derives_t.
 (Int Int Int Int) Bool
)
(assert
 (forall ((x! Int) (y! Int) (z! Int) (t! Int)) (!
   (= (ens%curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_segre_derives_t.
     x! y! z! t!
    ) (let
     ((inv_z$ (curve25519_dalek!specs.field_specs.field_inv.? (I z!))))
     (let
      ((ab$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_mul.?
           (I x!) (I inv_z$)
          )
         ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I y!) (I inv_z$)))
      )))
      (= t! (curve25519_dalek!specs.field_specs.field_mul.? (I ab$) (I z!)))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_segre_derives_t.
     x! y! z! t!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_segre_derives_t._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_segre_derives_t._definition
)))

;; Function-Specs curve25519_dalek::lemmas::ristretto_lemmas::batch_compress_lemmas::lemma_dt_squared_factor
(declare-fun req%curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_dt_squared_factor.
 (Int Int Int Int Int) Bool
)
(declare-const %%global_location_label%%49 Bool)
(assert
 (forall ((d! Int) (a! Int) (b! Int) (z! Int) (t! Int)) (!
   (= (req%curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_dt_squared_factor.
     d! a! b! z! t!
    ) (=>
     %%global_location_label%%49
     (= t! (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_mul.?
         (I a!) (I b!)
        )
       ) (I z!)
   ))))
   :pattern ((req%curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_dt_squared_factor.
     d! a! b! z! t!
   ))
   :qid internal_req__curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_dt_squared_factor._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_dt_squared_factor._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_dt_squared_factor.
 (Int Int Int Int Int) Bool
)
(assert
 (forall ((d! Int) (a! Int) (b! Int) (z! Int) (t! Int)) (!
   (= (ens%curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_dt_squared_factor.
     d! a! b! z! t!
    ) (let
     ((z2$ (curve25519_dalek!specs.field_specs.field_square.? (I z!))))
     (let
      ((t_dab2$ (curve25519_dalek!specs.field_specs.field_mul.? (I d!) (I (curve25519_dalek!specs.field_specs.field_mul.?
           (I (curve25519_dalek!specs.field_specs.field_square.? (I a!))) (I (curve25519_dalek!specs.field_specs.field_square.?
             (I b!)
      )))))))
      (= (curve25519_dalek!specs.field_specs.field_mul.? (I d!) (I (curve25519_dalek!specs.field_specs.field_square.?
          (I t!)
        ))
       ) (curve25519_dalek!specs.field_specs.field_mul.? (I t_dab2$) (I z2$))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_dt_squared_factor.
     d! a! b! z! t!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_dt_squared_factor._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_dt_squared_factor._definition
)))

;; Function-Specs curve25519_dalek::lemmas::ristretto_lemmas::batch_compress_lemmas::lemma_doubled_affine_from_batch_state
(declare-fun req%curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_doubled_affine_from_batch_state.
 (Int Int Int Int Int Int Int Int) Bool
)
(declare-const %%global_location_label%%50 Bool)
(declare-const %%global_location_label%%51 Bool)
(declare-const %%global_location_label%%52 Bool)
(declare-const %%global_location_label%%53 Bool)
(declare-const %%global_location_label%%54 Bool)
(declare-const %%global_location_label%%55 Bool)
(declare-const %%global_location_label%%56 Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int) (t! Int) (e! Int) (f! Int) (g! Int) (h! Int))
  (!
   (= (req%curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_doubled_affine_from_batch_state.
     x! y! z! t! e! f! g! h!
    ) (and
     (=>
      %%global_location_label%%50
      (< x! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%51
      (< y! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%52
      (< z! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%53
      (< t! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%54
      (not (= (EucMod z! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
     )
     (=>
      %%global_location_label%%55
      (= (curve25519_dalek!specs.field_specs.field_mul.? (I z!) (I t!)) (curve25519_dalek!specs.field_specs.field_mul.?
        (I x!) (I y!)
     )))
     (=>
      %%global_location_label%%56
      (let
       ((d$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?
       ))))
       (and
        (and
         (and
          (= e! (curve25519_dalek!specs.field_specs.field_mul.? (I 2) (I (curve25519_dalek!specs.field_specs.field_mul.?
              (I x!) (I y!)
          ))))
          (= f! (curve25519_dalek!specs.field_specs.field_add.? (I (curve25519_dalek!specs.field_specs.field_square.?
              (I z!)
             )
            ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I d$) (I (curve25519_dalek!specs.field_specs.field_square.?
                (I t!)
         )))))))
         (= g! (curve25519_dalek!specs.field_specs.field_add.? (I (curve25519_dalek!specs.field_specs.field_square.?
             (I y!)
            )
           ) (I (curve25519_dalek!specs.field_specs.field_square.? (I x!)))
        )))
        (= h! (curve25519_dalek!specs.field_specs.field_sub.? (I (curve25519_dalek!specs.field_specs.field_square.?
            (I z!)
           )
          ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I d$) (I (curve25519_dalek!specs.field_specs.field_square.?
              (I t!)
   )))))))))))
   :pattern ((req%curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_doubled_affine_from_batch_state.
     x! y! z! t! e! f! g! h!
   ))
   :qid internal_req__curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_doubled_affine_from_batch_state._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_doubled_affine_from_batch_state._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_doubled_affine_from_batch_state.
 (Int Int Int Int Int Int Int Int) Bool
)
(assert
 (forall ((x! Int) (y! Int) (z! Int) (t! Int) (e! Int) (f! Int) (g! Int) (h! Int))
  (!
   (= (ens%curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_doubled_affine_from_batch_state.
     x! y! z! t! e! f! g! h!
    ) (= (curve25519_dalek!specs.edwards_specs.edwards_double.? (I (curve25519_dalek!specs.field_specs.field_mul.?
        (I x!) (I (curve25519_dalek!specs.field_specs.field_inv.? (I z!)))
       )
      ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I y!) (I (curve25519_dalek!specs.field_specs.field_inv.?
          (I z!)
      ))))
     ) (tuple%2./tuple%2 (I (curve25519_dalek!specs.field_specs.field_mul.? (I e!) (I (curve25519_dalek!specs.field_specs.field_inv.?
          (I f!)
       )))
      ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I g!) (I (curve25519_dalek!specs.field_specs.field_inv.?
          (I h!)
   )))))))
   :pattern ((ens%curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_doubled_affine_from_batch_state.
     x! y! z! t! e! f! g! h!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_doubled_affine_from_batch_state._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_doubled_affine_from_batch_state._definition
)))

;; Function-Def curve25519_dalek::lemmas::ristretto_lemmas::batch_compress_lemmas::lemma_doubled_affine_from_batch_state
;; curve25519-dalek/src/lemmas/ristretto_lemmas/batch_compress_lemmas.rs:169:1: 178:2 (#0)
(get-info :all-statistics)
(push)
 (declare-const x! Int)
 (declare-const y! Int)
 (declare-const z! Int)
 (declare-const t! Int)
 (declare-const e! Int)
 (declare-const f! Int)
 (declare-const g! Int)
 (declare-const h! Int)
 (declare-const tmp%1 Int)
 (declare-const tmp%2 Int)
 (declare-const tmp%3 Int)
 (declare-const tmp%4 Int)
 (declare-const tmp%5 Int)
 (declare-const tmp%6 Int)
 (declare-const tmp%7 Int)
 (declare-const tmp%8 Int)
 (declare-const tmp%9 Int)
 (declare-const tmp%10 Int)
 (declare-const tmp%11 Int)
 (declare-const tmp%12 Int)
 (declare-const tmp%13 Int)
 (declare-const tmp%14 Int)
 (declare-const tmp%15 Int)
 (declare-const tmp%16 Int)
 (declare-const p@ Int)
 (declare-const inv_z@ Int)
 (declare-const a@ Int)
 (declare-const b@ Int)
 (declare-const ab@ Int)
 (declare-const a2@ Int)
 (declare-const b2@ Int)
 (declare-const z2@ Int)
 (declare-const d@ Int)
 (declare-const t_dab2@ Int)
 (assert
  fuel_defaults
 )
 (assert
  (<= 0 x!)
 )
 (assert
  (<= 0 y!)
 )
 (assert
  (<= 0 z!)
 )
 (assert
  (<= 0 t!)
 )
 (assert
  (<= 0 e!)
 )
 (assert
  (<= 0 f!)
 )
 (assert
  (<= 0 g!)
 )
 (assert
  (<= 0 h!)
 )
 (assert
  (< x! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
 )
 (assert
  (< y! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
 )
 (assert
  (< z! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
 )
 (assert
  (< t! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
 )
 (assert
  (not (= (EucMod z! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
 )
 (assert
  (= (curve25519_dalek!specs.field_specs.field_mul.? (I z!) (I t!)) (curve25519_dalek!specs.field_specs.field_mul.?
    (I x!) (I y!)
 )))
 (assert
  (let
   ((d$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?
   ))))
   (and
    (and
     (and
      (= e! (curve25519_dalek!specs.field_specs.field_mul.? (I 2) (I (curve25519_dalek!specs.field_specs.field_mul.?
          (I x!) (I y!)
      ))))
      (= f! (curve25519_dalek!specs.field_specs.field_add.? (I (curve25519_dalek!specs.field_specs.field_square.?
          (I z!)
         )
        ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I d$) (I (curve25519_dalek!specs.field_specs.field_square.?
            (I t!)
     )))))))
     (= g! (curve25519_dalek!specs.field_specs.field_add.? (I (curve25519_dalek!specs.field_specs.field_square.?
         (I y!)
        )
       ) (I (curve25519_dalek!specs.field_specs.field_square.? (I x!)))
    )))
    (= h! (curve25519_dalek!specs.field_specs.field_sub.? (I (curve25519_dalek!specs.field_specs.field_square.?
        (I z!)
       )
      ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I d$) (I (curve25519_dalek!specs.field_specs.field_square.?
          (I t!)
 )))))))))
 (declare-const %%switch_label%%0 Bool)
 (declare-const %%switch_label%%1 Bool)
 ;; assertion failed
 (declare-const %%location_label%%0 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%1 Bool)
 ;; assertion failed
 (declare-const %%location_label%%2 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%3 Bool)
 ;; assertion failed
 (declare-const %%location_label%%4 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%5 Bool)
 ;; assertion failed
 (declare-const %%location_label%%6 Bool)
 ;; assertion failed
 (declare-const %%location_label%%7 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%8 Bool)
 ;; assertion failed
 (declare-const %%location_label%%9 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%10 Bool)
 ;; assertion failed
 (declare-const %%location_label%%11 Bool)
 ;; assertion failed
 (declare-const %%location_label%%12 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%13 Bool)
 ;; assertion failed
 (declare-const %%location_label%%14 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%15 Bool)
 ;; assertion failed
 (declare-const %%location_label%%16 Bool)
 ;; assertion failed
 (declare-const %%location_label%%17 Bool)
 ;; assertion failed
 (declare-const %%location_label%%18 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%19 Bool)
 ;; assertion failed
 (declare-const %%location_label%%20 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%21 Bool)
 ;; assertion failed
 (declare-const %%location_label%%22 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%23 Bool)
 ;; assertion failed
 (declare-const %%location_label%%24 Bool)
 ;; assertion failed
 (declare-const %%location_label%%25 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%26 Bool)
 ;; assertion failed
 (declare-const %%location_label%%27 Bool)
 ;; assertion failed
 (declare-const %%location_label%%28 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%29 Bool)
 ;; assertion failed
 (declare-const %%location_label%%30 Bool)
 ;; assertion failed
 (declare-const %%location_label%%31 Bool)
 ;; assertion failed
 (declare-const %%location_label%%32 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%33 Bool)
 ;; assertion failed
 (declare-const %%location_label%%34 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%35 Bool)
 ;; assertion failed
 (declare-const %%location_label%%36 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%37 Bool)
 ;; assertion failed
 (declare-const %%location_label%%38 Bool)
 ;; assertion failed
 (declare-const %%location_label%%39 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%40 Bool)
 ;; assertion failed
 (declare-const %%location_label%%41 Bool)
 ;; assertion failed
 (declare-const %%location_label%%42 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%43 Bool)
 ;; assertion failed
 (declare-const %%location_label%%44 Bool)
 ;; assertion failed
 (declare-const %%location_label%%45 Bool)
 ;; assertion failed
 (declare-const %%location_label%%46 Bool)
 ;; postcondition not satisfied
 (declare-const %%location_label%%47 Bool)
 (assert
  (not (=>
    (= p@ (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
    (and
     (=>
      (ens%curve25519_dalek!specs.field_specs_u64.p_gt_2. 0)
      (=>
       %%location_label%%0
       (> p@ 2)
     ))
     (=>
      (> p@ 2)
      (=>
       (= inv_z@ (curve25519_dalek!specs.field_specs.field_inv.? (I z!)))
       (=>
        (= a@ (curve25519_dalek!specs.field_specs.field_mul.? (I x!) (I inv_z@)))
        (=>
         (= b@ (curve25519_dalek!specs.field_specs.field_mul.? (I y!) (I inv_z@)))
         (=>
          (= ab@ (curve25519_dalek!specs.field_specs.field_mul.? (I a@) (I b@)))
          (=>
           (= a2@ (curve25519_dalek!specs.field_specs.field_square.? (I a@)))
           (=>
            (= b2@ (curve25519_dalek!specs.field_specs.field_square.? (I b@)))
            (=>
             (= z2@ (curve25519_dalek!specs.field_specs.field_square.? (I z!)))
             (=>
              (= d@ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                 curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?
              )))
              (=>
               (= t_dab2@ (curve25519_dalek!specs.field_specs.field_mul.? (I d@) (I (curve25519_dalek!specs.field_specs.field_mul.?
                   (I a2@) (I b2@)
               ))))
               (and
                (and
                 (=>
                  %%location_label%%1
                  (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_square_nonzero.
                   z!
                 ))
                 (=>
                  (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_square_nonzero.
                   z!
                  )
                  (=>
                   %%location_label%%2
                   (not (= (EucMod z2@ p@) 0))
                )))
                (=>
                 (not (= (EucMod z2@ p@) 0))
                 (and
                  (and
                   (=>
                    %%location_label%%3
                    (req%curve25519_dalek!lemmas.edwards_lemmas.niels_addition_correctness.lemma_projective_product_factor.
                     x! z! y! z!
                   ))
                   (=>
                    (ens%curve25519_dalek!lemmas.edwards_lemmas.niels_addition_correctness.lemma_projective_product_factor.
                     x! z! y! z!
                    )
                    (=>
                     %%location_label%%4
                     (= (curve25519_dalek!specs.field_specs.field_mul.? (I x!) (I y!)) (curve25519_dalek!specs.field_specs.field_mul.?
                       (I ab@) (I z2@)
                  )))))
                  (=>
                   (= (curve25519_dalek!specs.field_specs.field_mul.? (I x!) (I y!)) (curve25519_dalek!specs.field_specs.field_mul.?
                     (I ab@) (I z2@)
                   ))
                   (and
                    (=>
                     (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_one_left.
                      z2@
                     )
                     (and
                      (=>
                       %%location_label%%5
                       (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_element_reduced.
                        z2@
                      ))
                      (=>
                       (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_element_reduced.
                        z2@
                       )
                       (=>
                        %%location_label%%6
                        (= (curve25519_dalek!specs.field_specs.field_mul.? (I 1) (I z2@)) z2@)
                    ))))
                    (=>
                     (= (curve25519_dalek!specs.field_specs.field_mul.? (I 1) (I z2@)) z2@)
                     (and
                      (=>
                       (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_reassociate_2_z_num.
                        z2@ ab@
                       )
                       (=>
                        %%location_label%%7
                        (= e! (curve25519_dalek!specs.field_specs.field_mul.? (I z2@) (I (curve25519_dalek!specs.field_specs.field_mul.?
                            (I 2) (I ab@)
                      ))))))
                      (=>
                       (= e! (curve25519_dalek!specs.field_specs.field_mul.? (I z2@) (I (curve25519_dalek!specs.field_specs.field_mul.?
                           (I 2) (I ab@)
                       ))))
                       (and
                        (and
                         (and
                          (=>
                           %%location_label%%8
                           (req%curve25519_dalek!lemmas.edwards_lemmas.niels_addition_correctness.lemma_projective_product_factor.
                            x! z! x! z!
                          ))
                          (=>
                           (ens%curve25519_dalek!lemmas.edwards_lemmas.niels_addition_correctness.lemma_projective_product_factor.
                            x! z! x! z!
                           )
                           (=>
                            %%location_label%%9
                            (= (curve25519_dalek!specs.field_specs.field_square.? (I x!)) (curve25519_dalek!specs.field_specs.field_mul.?
                              (I a2@) (I z2@)
                         )))))
                         (=>
                          (= (curve25519_dalek!specs.field_specs.field_square.? (I x!)) (curve25519_dalek!specs.field_specs.field_mul.?
                            (I a2@) (I z2@)
                          ))
                          (and
                           (and
                            (=>
                             %%location_label%%10
                             (req%curve25519_dalek!lemmas.edwards_lemmas.niels_addition_correctness.lemma_projective_product_factor.
                              y! z! y! z!
                            ))
                            (=>
                             (ens%curve25519_dalek!lemmas.edwards_lemmas.niels_addition_correctness.lemma_projective_product_factor.
                              y! z! y! z!
                             )
                             (=>
                              %%location_label%%11
                              (= (curve25519_dalek!specs.field_specs.field_square.? (I y!)) (curve25519_dalek!specs.field_specs.field_mul.?
                                (I b2@) (I z2@)
                           )))))
                           (=>
                            (= (curve25519_dalek!specs.field_specs.field_square.? (I y!)) (curve25519_dalek!specs.field_specs.field_mul.?
                              (I b2@) (I z2@)
                            ))
                            (=>
                             (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_factor_result_component_add.
                              b2@ a2@ z2@
                             )
                             (=>
                              %%location_label%%12
                              (= g! (curve25519_dalek!specs.field_specs.field_mul.? (I z2@) (I (curve25519_dalek!specs.field_specs.field_add.?
                                  (I b2@) (I a2@)
                        ))))))))))
                        (=>
                         (= g! (curve25519_dalek!specs.field_specs.field_mul.? (I z2@) (I (curve25519_dalek!specs.field_specs.field_add.?
                             (I b2@) (I a2@)
                         ))))
                         (and
                          (and
                           (=>
                            %%location_label%%13
                            (req%curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_segre_derives_t.
                             x! y! z! t!
                           ))
                           (=>
                            (ens%curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_segre_derives_t.
                             x! y! z! t!
                            )
                            (=>
                             %%location_label%%14
                             (= t! (curve25519_dalek!specs.field_specs.field_mul.? (I ab@) (I z!)))
                          )))
                          (=>
                           (= t! (curve25519_dalek!specs.field_specs.field_mul.? (I ab@) (I z!)))
                           (and
                            (and
                             (=>
                              %%location_label%%15
                              (req%curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_dt_squared_factor.
                               d@ a@ b@ z! t!
                             ))
                             (=>
                              (ens%curve25519_dalek!lemmas.ristretto_lemmas.batch_compress_lemmas.lemma_dt_squared_factor.
                               d@ a@ b@ z! t!
                              )
                              (=>
                               %%location_label%%16
                               (= (curve25519_dalek!specs.field_specs.field_mul.? (I d@) (I (curve25519_dalek!specs.field_specs.field_square.?
                                   (I t!)
                                 ))
                                ) (curve25519_dalek!specs.field_specs.field_mul.? (I t_dab2@) (I z2@))
                            ))))
                            (=>
                             (= (curve25519_dalek!specs.field_specs.field_mul.? (I d@) (I (curve25519_dalek!specs.field_specs.field_square.?
                                 (I t!)
                               ))
                              ) (curve25519_dalek!specs.field_specs.field_mul.? (I t_dab2@) (I z2@))
                             )
                             (and
                              (=>
                               (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_factor_result_component_add.
                                1 t_dab2@ z2@
                               )
                               (=>
                                %%location_label%%17
                                (= f! (curve25519_dalek!specs.field_specs.field_mul.? (I z2@) (I (curve25519_dalek!specs.field_specs.field_add.?
                                    (I 1) (I t_dab2@)
                              ))))))
                              (=>
                               (= f! (curve25519_dalek!specs.field_specs.field_mul.? (I z2@) (I (curve25519_dalek!specs.field_specs.field_add.?
                                   (I 1) (I t_dab2@)
                               ))))
                               (and
                                (=>
                                 (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_factor_result_component_sub.
                                  1 t_dab2@ z2@
                                 )
                                 (=>
                                  %%location_label%%18
                                  (= h! (curve25519_dalek!specs.field_specs.field_mul.? (I z2@) (I (curve25519_dalek!specs.field_specs.field_sub.?
                                      (I 1) (I t_dab2@)
                                ))))))
                                (=>
                                 (= h! (curve25519_dalek!specs.field_specs.field_mul.? (I z2@) (I (curve25519_dalek!specs.field_specs.field_sub.?
                                     (I 1) (I t_dab2@)
                                 ))))
                                 (or
                                  (and
                                   (=>
                                    (not (= (EucMod (curve25519_dalek!specs.field_specs.field_add.? (I 1) (I t_dab2@)) p@)
                                      0
                                    ))
                                    (and
                                     (=>
                                      (= tmp%1 (curve25519_dalek!specs.field_specs.field_mul.? (I 2) (I ab@)))
                                      (=>
                                       (= tmp%2 (curve25519_dalek!specs.field_specs.field_add.? (I 1) (I t_dab2@)))
                                       (and
                                        (=>
                                         %%location_label%%19
                                         (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_cancel_common_factor.
                                          tmp%1 tmp%2 z2@
                                        ))
                                        (=>
                                         (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_cancel_common_factor.
                                          tmp%1 tmp%2 z2@
                                         )
                                         (=>
                                          %%location_label%%20
                                          (= (curve25519_dalek!specs.field_specs.field_mul.? (I e!) (I (curve25519_dalek!specs.field_specs.field_inv.?
                                              (I f!)
                                            ))
                                           ) (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_mul.?
                                              (I 2) (I ab@)
                                             )
                                            ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I (curve25519_dalek!specs.field_specs.field_add.?
                                                (I 1) (I t_dab2@)
                                     )))))))))))
                                     (=>
                                      (= (curve25519_dalek!specs.field_specs.field_mul.? (I e!) (I (curve25519_dalek!specs.field_specs.field_inv.?
                                          (I f!)
                                        ))
                                       ) (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_mul.?
                                          (I 2) (I ab@)
                                         )
                                        ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I (curve25519_dalek!specs.field_specs.field_add.?
                                            (I 1) (I t_dab2@)
                                      ))))))
                                      %%switch_label%%1
                                   )))
                                   (=>
                                    (not (not (= (EucMod (curve25519_dalek!specs.field_specs.field_add.? (I 1) (I t_dab2@))
                                        p@
                                       ) 0
                                    )))
                                    (and
                                     (and
                                      (and
                                       (=>
                                        (= tmp%3 (curve25519_dalek!specs.field_specs.field_add.? (I 1) (I t_dab2@)))
                                        (and
                                         (=>
                                          %%location_label%%21
                                          (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_element_reduced.
                                           tmp%3
                                         ))
                                         (=>
                                          (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_element_reduced.
                                           tmp%3
                                          )
                                          (=>
                                           %%location_label%%22
                                           (= (curve25519_dalek!specs.field_specs.field_add.? (I 1) (I t_dab2@)) 0)
                                       ))))
                                       (=>
                                        (= (curve25519_dalek!specs.field_specs.field_add.? (I 1) (I t_dab2@)) 0)
                                        (=>
                                         (= tmp%4 (curve25519_dalek!specs.field_specs.field_add.? (I 1) (I t_dab2@)))
                                         (and
                                          (=>
                                           %%location_label%%23
                                           (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right.
                                            z2@ tmp%4
                                          ))
                                          (=>
                                           (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right.
                                            z2@ tmp%4
                                           )
                                           (=>
                                            %%location_label%%24
                                            (= f! 0)
                                      ))))))
                                      (=>
                                       (= f! 0)
                                       (and
                                        (=>
                                         (ens%curve25519_dalek!specs.field_specs.field_inv_zero. 0)
                                         (=>
                                          %%location_label%%25
                                          (= (curve25519_dalek!specs.field_specs.field_inv.? (I f!)) 0)
                                        ))
                                        (=>
                                         (= (curve25519_dalek!specs.field_specs.field_inv.? (I f!)) 0)
                                         (=>
                                          (= tmp%5 (curve25519_dalek!specs.field_specs.field_inv.? (I f!)))
                                          (and
                                           (=>
                                            %%location_label%%26
                                            (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right.
                                             e! tmp%5
                                           ))
                                           (=>
                                            (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right.
                                             e! tmp%5
                                            )
                                            (=>
                                             %%location_label%%27
                                             (= (curve25519_dalek!specs.field_specs.field_mul.? (I e!) (I (curve25519_dalek!specs.field_specs.field_inv.?
                                                 (I f!)
                                               ))
                                              ) 0
                                     )))))))))
                                     (=>
                                      (= (curve25519_dalek!specs.field_specs.field_mul.? (I e!) (I (curve25519_dalek!specs.field_specs.field_inv.?
                                          (I f!)
                                        ))
                                       ) 0
                                      )
                                      (and
                                       (and
                                        (=>
                                         (ens%curve25519_dalek!specs.field_specs.field_inv_zero. 0)
                                         (=>
                                          %%location_label%%28
                                          (= (curve25519_dalek!specs.field_specs.field_inv.? (I (curve25519_dalek!specs.field_specs.field_add.?
                                              (I 1) (I t_dab2@)
                                            ))
                                           ) 0
                                        )))
                                        (=>
                                         (= (curve25519_dalek!specs.field_specs.field_inv.? (I (curve25519_dalek!specs.field_specs.field_add.?
                                             (I 1) (I t_dab2@)
                                           ))
                                          ) 0
                                         )
                                         (=>
                                          (= tmp%6 (curve25519_dalek!specs.field_specs.field_mul.? (I 2) (I ab@)))
                                          (=>
                                           (= tmp%7 (curve25519_dalek!specs.field_specs.field_inv.? (I (curve25519_dalek!specs.field_specs.field_add.?
                                               (I 1) (I t_dab2@)
                                           ))))
                                           (and
                                            (=>
                                             %%location_label%%29
                                             (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right.
                                              tmp%6 tmp%7
                                            ))
                                            (=>
                                             (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right.
                                              tmp%6 tmp%7
                                             )
                                             (=>
                                              %%location_label%%30
                                              (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_mul.?
                                                  (I 2) (I ab@)
                                                 )
                                                ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I (curve25519_dalek!specs.field_specs.field_add.?
                                                    (I 1) (I t_dab2@)
                                                ))))
                                               ) 0
                                       ))))))))
                                       (=>
                                        (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_mul.?
                                            (I 2) (I ab@)
                                           )
                                          ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I (curve25519_dalek!specs.field_specs.field_add.?
                                              (I 1) (I t_dab2@)
                                          ))))
                                         ) 0
                                        )
                                        %%switch_label%%1
                                  ))))))
                                  (and
                                   (not %%switch_label%%1)
                                   (and
                                    (=>
                                     (= tmp%8 (curve25519_dalek!specs.field_specs.field_add.? (I b2@) (I a2@)))
                                     (=>
                                      (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_comm.
                                       z2@ tmp%8
                                      )
                                      (=>
                                       %%location_label%%31
                                       (= g! (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_add.?
                                           (I b2@) (I a2@)
                                          )
                                         ) (I z2@)
                                    )))))
                                    (=>
                                     (= g! (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_add.?
                                         (I b2@) (I a2@)
                                        )
                                       ) (I z2@)
                                     ))
                                     (and
                                      (=>
                                       (= tmp%9 (curve25519_dalek!specs.field_specs.field_sub.? (I 1) (I t_dab2@)))
                                       (=>
                                        (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_comm.
                                         z2@ tmp%9
                                        )
                                        (=>
                                         %%location_label%%32
                                         (= h! (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_sub.?
                                             (I 1) (I t_dab2@)
                                            )
                                           ) (I z2@)
                                      )))))
                                      (=>
                                       (= h! (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_sub.?
                                           (I 1) (I t_dab2@)
                                          )
                                         ) (I z2@)
                                       ))
                                       (or
                                        (and
                                         (=>
                                          (not (= (EucMod (curve25519_dalek!specs.field_specs.field_sub.? (I 1) (I t_dab2@)) p@)
                                            0
                                          ))
                                          (and
                                           (=>
                                            (= tmp%10 (curve25519_dalek!specs.field_specs.field_add.? (I b2@) (I a2@)))
                                            (=>
                                             (= tmp%11 (curve25519_dalek!specs.field_specs.field_sub.? (I 1) (I t_dab2@)))
                                             (and
                                              (=>
                                               %%location_label%%33
                                               (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_cancel_common_factor.
                                                tmp%10 tmp%11 z2@
                                              ))
                                              (=>
                                               (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_cancel_common_factor.
                                                tmp%10 tmp%11 z2@
                                               )
                                               (=>
                                                %%location_label%%34
                                                (= (curve25519_dalek!specs.field_specs.field_mul.? (I g!) (I (curve25519_dalek!specs.field_specs.field_inv.?
                                                    (I h!)
                                                  ))
                                                 ) (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_add.?
                                                    (I b2@) (I a2@)
                                                   )
                                                  ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I (curve25519_dalek!specs.field_specs.field_sub.?
                                                      (I 1) (I t_dab2@)
                                           )))))))))))
                                           (=>
                                            (= (curve25519_dalek!specs.field_specs.field_mul.? (I g!) (I (curve25519_dalek!specs.field_specs.field_inv.?
                                                (I h!)
                                              ))
                                             ) (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_add.?
                                                (I b2@) (I a2@)
                                               )
                                              ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I (curve25519_dalek!specs.field_specs.field_sub.?
                                                  (I 1) (I t_dab2@)
                                            ))))))
                                            %%switch_label%%0
                                         )))
                                         (=>
                                          (not (not (= (EucMod (curve25519_dalek!specs.field_specs.field_sub.? (I 1) (I t_dab2@))
                                              p@
                                             ) 0
                                          )))
                                          (and
                                           (and
                                            (and
                                             (=>
                                              (= tmp%12 (curve25519_dalek!specs.field_specs.field_sub.? (I 1) (I t_dab2@)))
                                              (and
                                               (=>
                                                %%location_label%%35
                                                (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_element_reduced.
                                                 tmp%12
                                               ))
                                               (=>
                                                (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_element_reduced.
                                                 tmp%12
                                                )
                                                (=>
                                                 %%location_label%%36
                                                 (= (curve25519_dalek!specs.field_specs.field_sub.? (I 1) (I t_dab2@)) 0)
                                             ))))
                                             (=>
                                              (= (curve25519_dalek!specs.field_specs.field_sub.? (I 1) (I t_dab2@)) 0)
                                              (=>
                                               (= tmp%13 (curve25519_dalek!specs.field_specs.field_sub.? (I 1) (I t_dab2@)))
                                               (and
                                                (=>
                                                 %%location_label%%37
                                                 (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right.
                                                  z2@ tmp%13
                                                ))
                                                (=>
                                                 (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right.
                                                  z2@ tmp%13
                                                 )
                                                 (=>
                                                  %%location_label%%38
                                                  (= h! 0)
                                            ))))))
                                            (=>
                                             (= h! 0)
                                             (and
                                              (=>
                                               (ens%curve25519_dalek!specs.field_specs.field_inv_zero. 0)
                                               (=>
                                                %%location_label%%39
                                                (= (curve25519_dalek!specs.field_specs.field_inv.? (I h!)) 0)
                                              ))
                                              (=>
                                               (= (curve25519_dalek!specs.field_specs.field_inv.? (I h!)) 0)
                                               (=>
                                                (= tmp%14 (curve25519_dalek!specs.field_specs.field_inv.? (I h!)))
                                                (and
                                                 (=>
                                                  %%location_label%%40
                                                  (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right.
                                                   g! tmp%14
                                                 ))
                                                 (=>
                                                  (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right.
                                                   g! tmp%14
                                                  )
                                                  (=>
                                                   %%location_label%%41
                                                   (= (curve25519_dalek!specs.field_specs.field_mul.? (I g!) (I (curve25519_dalek!specs.field_specs.field_inv.?
                                                       (I h!)
                                                     ))
                                                    ) 0
                                           )))))))))
                                           (=>
                                            (= (curve25519_dalek!specs.field_specs.field_mul.? (I g!) (I (curve25519_dalek!specs.field_specs.field_inv.?
                                                (I h!)
                                              ))
                                             ) 0
                                            )
                                            (and
                                             (and
                                              (=>
                                               (ens%curve25519_dalek!specs.field_specs.field_inv_zero. 0)
                                               (=>
                                                %%location_label%%42
                                                (= (curve25519_dalek!specs.field_specs.field_inv.? (I (curve25519_dalek!specs.field_specs.field_sub.?
                                                    (I 1) (I t_dab2@)
                                                  ))
                                                 ) 0
                                              )))
                                              (=>
                                               (= (curve25519_dalek!specs.field_specs.field_inv.? (I (curve25519_dalek!specs.field_specs.field_sub.?
                                                   (I 1) (I t_dab2@)
                                                 ))
                                                ) 0
                                               )
                                               (=>
                                                (= tmp%15 (curve25519_dalek!specs.field_specs.field_add.? (I b2@) (I a2@)))
                                                (=>
                                                 (= tmp%16 (curve25519_dalek!specs.field_specs.field_inv.? (I (curve25519_dalek!specs.field_specs.field_sub.?
                                                     (I 1) (I t_dab2@)
                                                 ))))
                                                 (and
                                                  (=>
                                                   %%location_label%%43
                                                   (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right.
                                                    tmp%15 tmp%16
                                                  ))
                                                  (=>
                                                   (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right.
                                                    tmp%15 tmp%16
                                                   )
                                                   (=>
                                                    %%location_label%%44
                                                    (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_add.?
                                                        (I b2@) (I a2@)
                                                       )
                                                      ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I (curve25519_dalek!specs.field_specs.field_sub.?
                                                          (I 1) (I t_dab2@)
                                                      ))))
                                                     ) 0
                                             ))))))))
                                             (=>
                                              (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_add.?
                                                  (I b2@) (I a2@)
                                                 )
                                                ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I (curve25519_dalek!specs.field_specs.field_sub.?
                                                    (I 1) (I t_dab2@)
                                                ))))
                                               ) 0
                                              )
                                              %%switch_label%%0
                                        ))))))
                                        (and
                                         (not %%switch_label%%0)
                                         (and
                                          (=>
                                           (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_comm.
                                            b@ a@
                                           )
                                           (=>
                                            %%location_label%%45
                                            (= (curve25519_dalek!specs.field_specs.field_mul.? (I b@) (I a@)) ab@)
                                          ))
                                          (=>
                                           (= (curve25519_dalek!specs.field_specs.field_mul.? (I b@) (I a@)) ab@)
                                           (and
                                            (=>
                                             (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_add_self_eq_double.
                                              ab@
                                             )
                                             (=>
                                              %%location_label%%46
                                              (= (curve25519_dalek!specs.field_specs.field_add.? (I ab@) (I ab@)) (curve25519_dalek!specs.field_specs.field_mul.?
                                                (I 2) (I ab@)
                                            ))))
                                            (=>
                                             (= (curve25519_dalek!specs.field_specs.field_add.? (I ab@) (I ab@)) (curve25519_dalek!specs.field_specs.field_mul.?
                                               (I 2) (I ab@)
                                             ))
                                             (=>
                                              %%location_label%%47
                                              (ext_eq false (TYPE%tuple%2. $ NAT $ NAT) (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_double.?
                                                 (I (curve25519_dalek!specs.field_specs.field_mul.? (I x!) (I (curve25519_dalek!specs.field_specs.field_inv.?
                                                     (I z!)
                                                  )))
                                                 ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I y!) (I (curve25519_dalek!specs.field_specs.field_inv.?
                                                     (I z!)
                                                )))))
                                               ) (Poly%tuple%2. (tuple%2./tuple%2 (I (curve25519_dalek!specs.field_specs.field_mul.?
                                                   (I e!) (I (curve25519_dalek!specs.field_specs.field_inv.? (I f!)))
                                                  )
                                                 ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I g!) (I (curve25519_dalek!specs.field_specs.field_inv.?
                                                     (I h!)
 ))))))))))))))))))))))))))))))))))))))))))))))))))))
 (get-info :version)
 (set-option :rlimit 30000000)
 (check-sat)
 (set-option :rlimit 0)
(pop)
