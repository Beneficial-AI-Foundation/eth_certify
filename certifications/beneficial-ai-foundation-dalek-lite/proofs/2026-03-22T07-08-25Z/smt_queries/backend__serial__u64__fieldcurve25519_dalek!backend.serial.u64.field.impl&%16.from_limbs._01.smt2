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

;; MODULE 'module backend::serial::u64::field'
;; curve25519-dalek/src/backend/serial/u64/field.rs:777:5: 777:79 (#0)

;; query spun off because: spinoff_all

;; Fuel
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_twice. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_sub_mod_noop. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_general. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_strict_inequality. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_left_inequality. FuelId)
(declare-const fuel%vstd!arithmetic.power.lemma_pow1. FuelId)
(declare-const fuel%vstd!std_specs.core.iter_into_iter_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%15.obeys_neg_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%15.neg_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%15.neg_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%31.obeys_add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%31.add_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%31.add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%32.obeys_add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%32.add_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%32.add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%34.obeys_add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%34.add_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%34.add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%35.obeys_add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%35.add_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%35.add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%36.obeys_add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%36.add_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%36.add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%40.obeys_add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%40.add_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%40.add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%43.obeys_sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%43.sub_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%43.sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%44.obeys_sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%44.sub_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%44.sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%46.obeys_sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%46.sub_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%46.sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%47.obeys_sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%47.sub_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%47.sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%48.obeys_sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%48.sub_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%48.sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%52.obeys_sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%52.sub_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%52.sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%55.obeys_mul_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%55.mul_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%55.mul_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%56.obeys_mul_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%56.mul_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%56.mul_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%58.obeys_mul_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%58.mul_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%58.mul_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%59.obeys_mul_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%59.mul_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%59.mul_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%60.obeys_mul_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%60.mul_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%60.mul_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%64.obeys_mul_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%64.mul_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%64.mul_spec. FuelId)
(declare-const fuel%vstd!std_specs.option.impl&%0.arrow_0. FuelId)
(declare-const fuel%vstd!std_specs.option.is_some. FuelId)
(declare-const fuel%vstd!std_specs.option.is_none. FuelId)
(declare-const fuel%vstd!std_specs.option.spec_unwrap. FuelId)
(declare-const fuel%vstd!std_specs.option.spec_unwrap_or. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%3.ghost_iter. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%4.exec_invariant. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%4.ghost_invariant. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%4.ghost_ensures. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%4.ghost_decrease. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%4.ghost_peek_next. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%4.ghost_advance. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%5.view. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%6.spec_is_lt. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%6.spec_steps_between_int. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%6.spec_forward_checked. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%6.spec_forward_checked_int. FuelId)
(declare-const fuel%vstd!std_specs.range.axiom_spec_range_next_u8. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%8.spec_is_lt. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%8.spec_steps_between_int. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%8.spec_forward_checked. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%8.spec_forward_checked_int. FuelId)
(declare-const fuel%vstd!std_specs.range.axiom_spec_range_next_u32. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%9.spec_is_lt. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%9.spec_steps_between_int. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%9.spec_forward_checked. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%9.spec_forward_checked_int. FuelId)
(declare-const fuel%vstd!std_specs.range.axiom_spec_range_next_u64. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%10.spec_is_lt. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%10.spec_steps_between_int. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%10.spec_forward_checked. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%10.spec_forward_checked_int. FuelId)
(declare-const fuel%vstd!std_specs.range.axiom_spec_range_next_u128. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%11.spec_is_lt. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%11.spec_steps_between_int. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%11.spec_forward_checked. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%11.spec_forward_checked_int. FuelId)
(declare-const fuel%vstd!std_specs.range.axiom_spec_range_next_usize. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%14.spec_is_lt. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%14.spec_steps_between_int. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%14.spec_forward_checked. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%14.spec_forward_checked_int. FuelId)
(declare-const fuel%vstd!std_specs.range.axiom_spec_range_next_i32. FuelId)
(declare-const fuel%vstd!std_specs.slice.impl&%1.spec_index_set_requires. FuelId)
(declare-const fuel%vstd!std_specs.slice.impl&%1.spec_index_set_ensures. FuelId)
(declare-const fuel%vstd!std_specs.slice.impl&%3.spec_index_set_requires. FuelId)
(declare-const fuel%vstd!std_specs.slice.impl&%3.spec_index_set_ensures. FuelId)
(declare-const fuel%vstd!array.array_view. FuelId)
(declare-const fuel%vstd!array.impl&%0.view. FuelId)
(declare-const fuel%vstd!array.impl&%2.spec_index. FuelId)
(declare-const fuel%vstd!array.lemma_array_index. FuelId)
(declare-const fuel%vstd!array.array_len_matches_n. FuelId)
(declare-const fuel%vstd!array.axiom_spec_array_as_slice. FuelId)
(declare-const fuel%vstd!array.axiom_spec_array_fill_for_copy_type. FuelId)
(declare-const fuel%vstd!array.axiom_array_ext_equal. FuelId)
(declare-const fuel%vstd!array.axiom_array_has_resolved. FuelId)
(declare-const fuel%vstd!pervasive.strictly_cloned. FuelId)
(declare-const fuel%vstd!pervasive.cloned. FuelId)
(declare-const fuel%vstd!raw_ptr.impl&%3.view. FuelId)
(declare-const fuel%vstd!raw_ptr.ptrs_mut_eq. FuelId)
(declare-const fuel%vstd!raw_ptr.ptrs_mut_eq_sized. FuelId)
(declare-const fuel%vstd!seq.impl&%0.spec_index. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_index_decreases. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_empty. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_new_len. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_new_index. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_push_len. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_push_index_same. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_push_index_different. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_update_len. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_update_same. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_update_different. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_ext_equal. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_ext_equal_deep. FuelId)
(declare-const fuel%vstd!slice.impl&%2.spec_index. FuelId)
(declare-const fuel%vstd!slice.axiom_spec_len. FuelId)
(declare-const fuel%vstd!slice.axiom_slice_ext_equal. FuelId)
(declare-const fuel%vstd!slice.axiom_slice_has_resolved. FuelId)
(declare-const fuel%vstd!string.axiom_str_literal_len. FuelId)
(declare-const fuel%vstd!string.axiom_str_literal_get_char. FuelId)
(declare-const fuel%vstd!view.impl&%0.view. FuelId)
(declare-const fuel%vstd!view.impl&%2.view. FuelId)
(declare-const fuel%vstd!view.impl&%4.view. FuelId)
(declare-const fuel%vstd!view.impl&%6.view. FuelId)
(declare-const fuel%vstd!view.impl&%10.view. FuelId)
(declare-const fuel%vstd!view.impl&%12.view. FuelId)
(declare-const fuel%vstd!view.impl&%14.view. FuelId)
(declare-const fuel%vstd!view.impl&%16.view. FuelId)
(declare-const fuel%vstd!view.impl&%20.view. FuelId)
(declare-const fuel%vstd!view.impl&%22.view. FuelId)
(declare-const fuel%vstd!view.impl&%24.view. FuelId)
(declare-const fuel%vstd!view.impl&%26.view. FuelId)
(declare-const fuel%vstd!view.impl&%32.view. FuelId)
(declare-const fuel%vstd!view.impl&%40.view. FuelId)
(declare-const fuel%vstd!view.impl&%42.view. FuelId)
(declare-const fuel%vstd!view.impl&%44.view. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.LOW_51_BIT_MASK. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.obeys_add_spec.
 FuelId
)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.add_req. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.add_spec. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.obeys_sub_spec.
 FuelId
)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.sub_req. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.sub_spec. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%11.obeys_mul_spec.
 FuelId
)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%11.mul_req. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%11.mul_spec. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%13.obeys_neg_spec.
 FuelId
)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%13.neg_req. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%13.neg_spec. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%16.ZERO. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%16.ONE. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%16.MINUS_ONE.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.all_neg_limbs_positive.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_0_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_0_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_0_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_0_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_0_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.carry_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_0_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_0_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a2_0_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a3_0_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a4_0_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_1_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_1_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_2_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.term_product_bounds_spec.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_0_val_boundaries.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_val_boundaries.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ai_val_boundaries.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_boundary_spec.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c0_0_val.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c1_0_val.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c2_0_val.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c3_0_val.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c4_0_val.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c0_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c1_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c2_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c3_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c4_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_return. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_term_product_bounds_spec.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_ci_0_val_boundaries.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_ci_val_boundaries.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_out_val_boundaries.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_boundary_spec.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_or_version_rec.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_plus_version_rec.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.limbs_to_bytes_lemmas.bytes_match_limbs_packing.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.core_specs.spec_load8_at. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.u64_5_bounded. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.fe51_limbs_bounded. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.sum_of_limbs_bounded. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.spec_add_fe51_limbs. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.spec_sub_limbs. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.fe51_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.fe51_as_canonical_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_add. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_sub. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_mul. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_neg. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.p. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.field_canonical. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.mask51. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.spec_reduce. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.sixteen_p_vec. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.spec_negate. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.compute_q_arr. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.compute_q_spec. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.compute_unmasked_limbs.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.reduce_with_q_spec. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.bit_arrange. FuelId)
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
 (distinct fuel%vstd!arithmetic.div_mod.lemma_mod_twice. fuel%vstd!arithmetic.div_mod.lemma_sub_mod_noop.
  fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_general. fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop.
  fuel%vstd!arithmetic.mul.lemma_mul_strict_inequality. fuel%vstd!arithmetic.mul.lemma_mul_left_inequality.
  fuel%vstd!arithmetic.power.lemma_pow1. fuel%vstd!std_specs.core.iter_into_iter_spec.
  fuel%vstd!std_specs.ops.impl&%15.obeys_neg_spec. fuel%vstd!std_specs.ops.impl&%15.neg_req.
  fuel%vstd!std_specs.ops.impl&%15.neg_spec. fuel%vstd!std_specs.ops.impl&%31.obeys_add_spec.
  fuel%vstd!std_specs.ops.impl&%31.add_req. fuel%vstd!std_specs.ops.impl&%31.add_spec.
  fuel%vstd!std_specs.ops.impl&%32.obeys_add_spec. fuel%vstd!std_specs.ops.impl&%32.add_req.
  fuel%vstd!std_specs.ops.impl&%32.add_spec. fuel%vstd!std_specs.ops.impl&%34.obeys_add_spec.
  fuel%vstd!std_specs.ops.impl&%34.add_req. fuel%vstd!std_specs.ops.impl&%34.add_spec.
  fuel%vstd!std_specs.ops.impl&%35.obeys_add_spec. fuel%vstd!std_specs.ops.impl&%35.add_req.
  fuel%vstd!std_specs.ops.impl&%35.add_spec. fuel%vstd!std_specs.ops.impl&%36.obeys_add_spec.
  fuel%vstd!std_specs.ops.impl&%36.add_req. fuel%vstd!std_specs.ops.impl&%36.add_spec.
  fuel%vstd!std_specs.ops.impl&%40.obeys_add_spec. fuel%vstd!std_specs.ops.impl&%40.add_req.
  fuel%vstd!std_specs.ops.impl&%40.add_spec. fuel%vstd!std_specs.ops.impl&%43.obeys_sub_spec.
  fuel%vstd!std_specs.ops.impl&%43.sub_req. fuel%vstd!std_specs.ops.impl&%43.sub_spec.
  fuel%vstd!std_specs.ops.impl&%44.obeys_sub_spec. fuel%vstd!std_specs.ops.impl&%44.sub_req.
  fuel%vstd!std_specs.ops.impl&%44.sub_spec. fuel%vstd!std_specs.ops.impl&%46.obeys_sub_spec.
  fuel%vstd!std_specs.ops.impl&%46.sub_req. fuel%vstd!std_specs.ops.impl&%46.sub_spec.
  fuel%vstd!std_specs.ops.impl&%47.obeys_sub_spec. fuel%vstd!std_specs.ops.impl&%47.sub_req.
  fuel%vstd!std_specs.ops.impl&%47.sub_spec. fuel%vstd!std_specs.ops.impl&%48.obeys_sub_spec.
  fuel%vstd!std_specs.ops.impl&%48.sub_req. fuel%vstd!std_specs.ops.impl&%48.sub_spec.
  fuel%vstd!std_specs.ops.impl&%52.obeys_sub_spec. fuel%vstd!std_specs.ops.impl&%52.sub_req.
  fuel%vstd!std_specs.ops.impl&%52.sub_spec. fuel%vstd!std_specs.ops.impl&%55.obeys_mul_spec.
  fuel%vstd!std_specs.ops.impl&%55.mul_req. fuel%vstd!std_specs.ops.impl&%55.mul_spec.
  fuel%vstd!std_specs.ops.impl&%56.obeys_mul_spec. fuel%vstd!std_specs.ops.impl&%56.mul_req.
  fuel%vstd!std_specs.ops.impl&%56.mul_spec. fuel%vstd!std_specs.ops.impl&%58.obeys_mul_spec.
  fuel%vstd!std_specs.ops.impl&%58.mul_req. fuel%vstd!std_specs.ops.impl&%58.mul_spec.
  fuel%vstd!std_specs.ops.impl&%59.obeys_mul_spec. fuel%vstd!std_specs.ops.impl&%59.mul_req.
  fuel%vstd!std_specs.ops.impl&%59.mul_spec. fuel%vstd!std_specs.ops.impl&%60.obeys_mul_spec.
  fuel%vstd!std_specs.ops.impl&%60.mul_req. fuel%vstd!std_specs.ops.impl&%60.mul_spec.
  fuel%vstd!std_specs.ops.impl&%64.obeys_mul_spec. fuel%vstd!std_specs.ops.impl&%64.mul_req.
  fuel%vstd!std_specs.ops.impl&%64.mul_spec. fuel%vstd!std_specs.option.impl&%0.arrow_0.
  fuel%vstd!std_specs.option.is_some. fuel%vstd!std_specs.option.is_none. fuel%vstd!std_specs.option.spec_unwrap.
  fuel%vstd!std_specs.option.spec_unwrap_or. fuel%vstd!std_specs.range.impl&%3.ghost_iter.
  fuel%vstd!std_specs.range.impl&%4.exec_invariant. fuel%vstd!std_specs.range.impl&%4.ghost_invariant.
  fuel%vstd!std_specs.range.impl&%4.ghost_ensures. fuel%vstd!std_specs.range.impl&%4.ghost_decrease.
  fuel%vstd!std_specs.range.impl&%4.ghost_peek_next. fuel%vstd!std_specs.range.impl&%4.ghost_advance.
  fuel%vstd!std_specs.range.impl&%5.view. fuel%vstd!std_specs.range.impl&%6.spec_is_lt.
  fuel%vstd!std_specs.range.impl&%6.spec_steps_between_int. fuel%vstd!std_specs.range.impl&%6.spec_forward_checked.
  fuel%vstd!std_specs.range.impl&%6.spec_forward_checked_int. fuel%vstd!std_specs.range.axiom_spec_range_next_u8.
  fuel%vstd!std_specs.range.impl&%8.spec_is_lt. fuel%vstd!std_specs.range.impl&%8.spec_steps_between_int.
  fuel%vstd!std_specs.range.impl&%8.spec_forward_checked. fuel%vstd!std_specs.range.impl&%8.spec_forward_checked_int.
  fuel%vstd!std_specs.range.axiom_spec_range_next_u32. fuel%vstd!std_specs.range.impl&%9.spec_is_lt.
  fuel%vstd!std_specs.range.impl&%9.spec_steps_between_int. fuel%vstd!std_specs.range.impl&%9.spec_forward_checked.
  fuel%vstd!std_specs.range.impl&%9.spec_forward_checked_int. fuel%vstd!std_specs.range.axiom_spec_range_next_u64.
  fuel%vstd!std_specs.range.impl&%10.spec_is_lt. fuel%vstd!std_specs.range.impl&%10.spec_steps_between_int.
  fuel%vstd!std_specs.range.impl&%10.spec_forward_checked. fuel%vstd!std_specs.range.impl&%10.spec_forward_checked_int.
  fuel%vstd!std_specs.range.axiom_spec_range_next_u128. fuel%vstd!std_specs.range.impl&%11.spec_is_lt.
  fuel%vstd!std_specs.range.impl&%11.spec_steps_between_int. fuel%vstd!std_specs.range.impl&%11.spec_forward_checked.
  fuel%vstd!std_specs.range.impl&%11.spec_forward_checked_int. fuel%vstd!std_specs.range.axiom_spec_range_next_usize.
  fuel%vstd!std_specs.range.impl&%14.spec_is_lt. fuel%vstd!std_specs.range.impl&%14.spec_steps_between_int.
  fuel%vstd!std_specs.range.impl&%14.spec_forward_checked. fuel%vstd!std_specs.range.impl&%14.spec_forward_checked_int.
  fuel%vstd!std_specs.range.axiom_spec_range_next_i32. fuel%vstd!std_specs.slice.impl&%1.spec_index_set_requires.
  fuel%vstd!std_specs.slice.impl&%1.spec_index_set_ensures. fuel%vstd!std_specs.slice.impl&%3.spec_index_set_requires.
  fuel%vstd!std_specs.slice.impl&%3.spec_index_set_ensures. fuel%vstd!array.array_view.
  fuel%vstd!array.impl&%0.view. fuel%vstd!array.impl&%2.spec_index. fuel%vstd!array.lemma_array_index.
  fuel%vstd!array.array_len_matches_n. fuel%vstd!array.axiom_spec_array_as_slice. fuel%vstd!array.axiom_spec_array_fill_for_copy_type.
  fuel%vstd!array.axiom_array_ext_equal. fuel%vstd!array.axiom_array_has_resolved.
  fuel%vstd!pervasive.strictly_cloned. fuel%vstd!pervasive.cloned. fuel%vstd!raw_ptr.impl&%3.view.
  fuel%vstd!raw_ptr.ptrs_mut_eq. fuel%vstd!raw_ptr.ptrs_mut_eq_sized. fuel%vstd!seq.impl&%0.spec_index.
  fuel%vstd!seq.axiom_seq_index_decreases. fuel%vstd!seq.axiom_seq_empty. fuel%vstd!seq.axiom_seq_new_len.
  fuel%vstd!seq.axiom_seq_new_index. fuel%vstd!seq.axiom_seq_push_len. fuel%vstd!seq.axiom_seq_push_index_same.
  fuel%vstd!seq.axiom_seq_push_index_different. fuel%vstd!seq.axiom_seq_update_len.
  fuel%vstd!seq.axiom_seq_update_same. fuel%vstd!seq.axiom_seq_update_different. fuel%vstd!seq.axiom_seq_ext_equal.
  fuel%vstd!seq.axiom_seq_ext_equal_deep. fuel%vstd!slice.impl&%2.spec_index. fuel%vstd!slice.axiom_spec_len.
  fuel%vstd!slice.axiom_slice_ext_equal. fuel%vstd!slice.axiom_slice_has_resolved.
  fuel%vstd!string.axiom_str_literal_len. fuel%vstd!string.axiom_str_literal_get_char.
  fuel%vstd!view.impl&%0.view. fuel%vstd!view.impl&%2.view. fuel%vstd!view.impl&%4.view.
  fuel%vstd!view.impl&%6.view. fuel%vstd!view.impl&%10.view. fuel%vstd!view.impl&%12.view.
  fuel%vstd!view.impl&%14.view. fuel%vstd!view.impl&%16.view. fuel%vstd!view.impl&%20.view.
  fuel%vstd!view.impl&%22.view. fuel%vstd!view.impl&%24.view. fuel%vstd!view.impl&%26.view.
  fuel%vstd!view.impl&%32.view. fuel%vstd!view.impl&%40.view. fuel%vstd!view.impl&%42.view.
  fuel%vstd!view.impl&%44.view. fuel%curve25519_dalek!backend.serial.u64.field.LOW_51_BIT_MASK.
  fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.obeys_add_spec. fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.add_req.
  fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.add_spec. fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.obeys_sub_spec.
  fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.sub_req. fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.sub_spec.
  fuel%curve25519_dalek!backend.serial.u64.field.impl&%11.obeys_mul_spec. fuel%curve25519_dalek!backend.serial.u64.field.impl&%11.mul_req.
  fuel%curve25519_dalek!backend.serial.u64.field.impl&%11.mul_spec. fuel%curve25519_dalek!backend.serial.u64.field.impl&%13.obeys_neg_spec.
  fuel%curve25519_dalek!backend.serial.u64.field.impl&%13.neg_req. fuel%curve25519_dalek!backend.serial.u64.field.impl&%13.neg_spec.
  fuel%curve25519_dalek!backend.serial.u64.field.impl&%16.ZERO. fuel%curve25519_dalek!backend.serial.u64.field.impl&%16.ONE.
  fuel%curve25519_dalek!backend.serial.u64.field.impl&%16.MINUS_ONE. fuel%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.all_neg_limbs_positive.
  fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_0_val. fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_0_val.
  fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_0_val. fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_0_val.
  fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_0_val. fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_val.
  fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_val. fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_val.
  fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_val. fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_val.
  fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.carry_val. fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_0_val.
  fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_0_val. fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a2_0_val.
  fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a3_0_val. fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a4_0_val.
  fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_1_val. fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_1_val.
  fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_2_val. fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.term_product_bounds_spec.
  fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_0_val_boundaries. fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_val_boundaries.
  fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ai_val_boundaries. fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.
  fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_boundary_spec.
  fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c0_0_val. fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c1_0_val.
  fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c2_0_val. fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c3_0_val.
  fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c4_0_val. fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c0_val.
  fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c1_val. fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c2_val.
  fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c3_val. fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c4_val.
  fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_return. fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_term_product_bounds_spec.
  fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_ci_0_val_boundaries. fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_ci_val_boundaries.
  fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_out_val_boundaries. fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_boundary_spec.
  fuel%curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_or_version_rec. fuel%curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_plus_version_rec.
  fuel%curve25519_dalek!lemmas.field_lemmas.limbs_to_bytes_lemmas.bytes_match_limbs_packing.
  fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat. fuel%curve25519_dalek!specs.core_specs.spec_load8_at.
  fuel%curve25519_dalek!specs.field_specs.u64_5_bounded. fuel%curve25519_dalek!specs.field_specs.fe51_limbs_bounded.
  fuel%curve25519_dalek!specs.field_specs.sum_of_limbs_bounded. fuel%curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.
  fuel%curve25519_dalek!specs.field_specs.spec_sub_limbs. fuel%curve25519_dalek!specs.field_specs.fe51_as_nat.
  fuel%curve25519_dalek!specs.field_specs.fe51_as_canonical_nat. fuel%curve25519_dalek!specs.field_specs.field_add.
  fuel%curve25519_dalek!specs.field_specs.field_sub. fuel%curve25519_dalek!specs.field_specs.field_mul.
  fuel%curve25519_dalek!specs.field_specs.field_neg. fuel%curve25519_dalek!specs.field_specs_u64.p.
  fuel%curve25519_dalek!specs.field_specs_u64.field_canonical. fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.
  fuel%curve25519_dalek!specs.field_specs_u64.mask51. fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.
  fuel%curve25519_dalek!specs.field_specs_u64.spec_reduce. fuel%curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.
  fuel%curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs. fuel%curve25519_dalek!specs.field_specs_u64.spec_negate.
  fuel%curve25519_dalek!specs.field_specs_u64.compute_q_arr. fuel%curve25519_dalek!specs.field_specs_u64.compute_q_spec.
  fuel%curve25519_dalek!specs.field_specs_u64.compute_unmasked_limbs. fuel%curve25519_dalek!specs.field_specs_u64.reduce_with_q_spec.
  fuel%curve25519_dalek!specs.field_specs_u64.bit_arrange. fuel%vstd!array.group_array_axioms.
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
   (fuel_bool_default fuel%vstd!array.axiom_spec_array_fill_for_copy_type.)
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
   (fuel_bool_default fuel%vstd!seq.axiom_seq_empty.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_new_len.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_new_index.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_push_len.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_push_index_same.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_push_index_different.)
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
 (=>
  (fuel_bool_default fuel%vstd!string.group_string_axioms.)
  (and
   (fuel_bool_default fuel%vstd!string.axiom_str_literal_len.)
   (fuel_bool_default fuel%vstd!string.axiom_str_literal_get_char.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!std_specs.range.group_range_axioms.)
  (and
   (fuel_bool_default fuel%vstd!std_specs.range.axiom_spec_range_next_u8.)
   (fuel_bool_default fuel%vstd!std_specs.range.axiom_spec_range_next_u32.)
   (fuel_bool_default fuel%vstd!std_specs.range.axiom_spec_range_next_u64.)
   (fuel_bool_default fuel%vstd!std_specs.range.axiom_spec_range_next_u128.)
   (fuel_bool_default fuel%vstd!std_specs.range.axiom_spec_range_next_usize.)
   (fuel_bool_default fuel%vstd!std_specs.range.axiom_spec_range_next_i32.)
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
(declare-fun tr_bound%vstd!pervasive.ForLoopGhostIterator. (Dcr Type) Bool)
(declare-fun tr_bound%vstd!pervasive.ForLoopGhostIteratorNew. (Dcr Type) Bool)
(declare-fun tr_bound%vstd!slice.SliceAdditionalSpecFns. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%core!slice.index.SliceIndex. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%vstd!view.View. (Dcr Type) Bool)
(declare-fun tr_bound%core!clone.Clone. (Dcr Type) Bool)
(declare-fun tr_bound%core!cmp.PartialEq. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%core!cmp.PartialOrd. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%core!ops.index.Index. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%core!ops.index.IndexMut. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%core!alloc.Allocator. (Dcr Type) Bool)
(declare-fun tr_bound%core!iter.traits.iterator.Iterator. (Dcr Type) Bool)
(declare-fun tr_bound%core!iter.range.Step. (Dcr Type) Bool)
(declare-fun tr_bound%vstd!std_specs.core.TrustedSpecSealed. (Dcr Type) Bool)
(declare-fun tr_bound%vstd!std_specs.core.IndexSetTrustedSpec. (Dcr Type Dcr Type)
 Bool
)
(declare-fun tr_bound%core!ops.arith.Neg. (Dcr Type) Bool)
(declare-fun tr_bound%vstd!std_specs.ops.NegSpec. (Dcr Type) Bool)
(declare-fun tr_bound%core!ops.arith.Add. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%vstd!std_specs.ops.AddSpec. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%core!ops.arith.Sub. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%vstd!std_specs.ops.SubSpec. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%core!ops.arith.Mul. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%vstd!std_specs.ops.MulSpec. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%vstd!std_specs.option.OptionAdditionalFns. (Dcr Type Dcr Type)
 Bool
)
(declare-fun tr_bound%vstd!std_specs.range.StepSpec. (Dcr Type) Bool)

;; Associated-Type-Decls
(declare-fun proj%%vstd!pervasive.ForLoopGhostIterator./ExecIter (Dcr Type) Dcr)
(declare-fun proj%vstd!pervasive.ForLoopGhostIterator./ExecIter (Dcr Type) Type)
(declare-fun proj%%vstd!pervasive.ForLoopGhostIterator./Item (Dcr Type) Dcr)
(declare-fun proj%vstd!pervasive.ForLoopGhostIterator./Item (Dcr Type) Type)
(declare-fun proj%%vstd!pervasive.ForLoopGhostIterator./Decrease (Dcr Type) Dcr)
(declare-fun proj%vstd!pervasive.ForLoopGhostIterator./Decrease (Dcr Type) Type)
(declare-fun proj%%vstd!pervasive.ForLoopGhostIteratorNew./GhostIter (Dcr Type) Dcr)
(declare-fun proj%vstd!pervasive.ForLoopGhostIteratorNew./GhostIter (Dcr Type) Type)
(declare-fun proj%%core!slice.index.SliceIndex./Output (Dcr Type Dcr Type) Dcr)
(declare-fun proj%core!slice.index.SliceIndex./Output (Dcr Type Dcr Type) Type)
(declare-fun proj%%vstd!view.View./V (Dcr Type) Dcr)
(declare-fun proj%vstd!view.View./V (Dcr Type) Type)
(declare-fun proj%%core!ops.index.Index./Output (Dcr Type Dcr Type) Dcr)
(declare-fun proj%core!ops.index.Index./Output (Dcr Type Dcr Type) Type)
(declare-fun proj%%core!iter.traits.iterator.Iterator./Item (Dcr Type) Dcr)
(declare-fun proj%core!iter.traits.iterator.Iterator./Item (Dcr Type) Type)
(declare-fun proj%%core!ops.arith.Neg./Output (Dcr Type) Dcr)
(declare-fun proj%core!ops.arith.Neg./Output (Dcr Type) Type)
(declare-fun proj%%core!ops.arith.Add./Output (Dcr Type Dcr Type) Dcr)
(declare-fun proj%core!ops.arith.Add./Output (Dcr Type Dcr Type) Type)
(declare-fun proj%%core!ops.arith.Sub./Output (Dcr Type Dcr Type) Dcr)
(declare-fun proj%core!ops.arith.Sub./Output (Dcr Type Dcr Type) Type)
(declare-fun proj%%core!ops.arith.Mul./Output (Dcr Type Dcr Type) Dcr)
(declare-fun proj%core!ops.arith.Mul./Output (Dcr Type Dcr Type) Type)

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
(declare-sort core!fmt.Error. 0)
(declare-sort core!fmt.Formatter. 0)
(declare-sort core!time.Duration. 0)
(declare-sort subtle!Choice. 0)
(declare-sort vstd!raw_ptr.Provenance. 0)
(declare-sort vstd!seq.Seq<char.>. 0)
(declare-sort slice%<u8.>. 0)
(declare-sort strslice%. 0)
(declare-sort allocator_global%. 0)
(declare-datatypes ((core!option.Option. 0) (core!result.Result. 0) (core!ops.range.Range.
   0
  ) (vstd!std_specs.range.RangeGhostIterator. 0) (vstd!raw_ptr.PtrData. 0) (curve25519_dalek!backend.serial.u64.field.FieldElement51.
   0
  ) (tuple%0. 0) (tuple%1. 0) (tuple%2. 0)
 ) (((core!option.Option./None) (core!option.Option./Some (core!option.Option./Some/?0
     Poly
   ))
  ) ((core!result.Result./Ok (core!result.Result./Ok/?0 Poly)) (core!result.Result./Err
    (core!result.Result./Err/?0 Poly)
   )
  ) ((core!ops.range.Range./Range (core!ops.range.Range./Range/?start Poly) (core!ops.range.Range./Range/?end
     Poly
   ))
  ) ((vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/?start
     Poly
    ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/?cur Poly) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/?end
     Poly
   ))
  ) ((vstd!raw_ptr.PtrData./PtrData (vstd!raw_ptr.PtrData./PtrData/?addr Int) (vstd!raw_ptr.PtrData./PtrData/?provenance
     vstd!raw_ptr.Provenance.
    ) (vstd!raw_ptr.PtrData./PtrData/?metadata Poly)
   )
  ) ((curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/?limbs
     %%Function%%
   ))
  ) ((tuple%0./tuple%0)) ((tuple%1./tuple%1 (tuple%1./tuple%1/?0 Poly))) ((tuple%2./tuple%2
    (tuple%2./tuple%2/?0 Poly) (tuple%2./tuple%2/?1 Poly)
))))
(declare-fun core!option.Option./Some/0 (Dcr Type core!option.Option.) Poly)
(declare-fun core!result.Result./Ok/0 (Dcr Type Dcr Type core!result.Result.) Poly)
(declare-fun core!result.Result./Err/0 (Dcr Type Dcr Type core!result.Result.) Poly)
(declare-fun core!ops.range.Range./Range/start (core!ops.range.Range.) Poly)
(declare-fun core!ops.range.Range./Range/end (core!ops.range.Range.) Poly)
(declare-fun vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start (vstd!std_specs.range.RangeGhostIterator.)
 Poly
)
(declare-fun vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (vstd!std_specs.range.RangeGhostIterator.)
 Poly
)
(declare-fun vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (vstd!std_specs.range.RangeGhostIterator.)
 Poly
)
(declare-fun vstd!raw_ptr.PtrData./PtrData/addr (vstd!raw_ptr.PtrData.) Int)
(declare-fun vstd!raw_ptr.PtrData./PtrData/provenance (vstd!raw_ptr.PtrData.) vstd!raw_ptr.Provenance.)
(declare-fun vstd!raw_ptr.PtrData./PtrData/metadata (vstd!raw_ptr.PtrData.) Poly)
(declare-fun curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
 (curve25519_dalek!backend.serial.u64.field.FieldElement51.) %%Function%%
)
(declare-fun tuple%1./tuple%1/0 (tuple%1.) Poly)
(declare-fun tuple%2./tuple%2/0 (tuple%2.) Poly)
(declare-fun tuple%2./tuple%2/1 (tuple%2.) Poly)
(declare-fun TYPE%fun%1. (Dcr Type Dcr Type) Type)
(declare-fun TYPE%core!option.Option. (Dcr Type) Type)
(declare-fun TYPE%core!result.Result. (Dcr Type Dcr Type) Type)
(declare-const TYPE%core!time.Duration. Type)
(declare-fun TYPE%core!ops.range.Range. (Dcr Type) Type)
(declare-fun TYPE%vstd!std_specs.range.RangeGhostIterator. (Dcr Type) Type)
(declare-const TYPE%vstd!raw_ptr.Provenance. Type)
(declare-fun TYPE%vstd!raw_ptr.PtrData. (Dcr Type) Type)
(declare-fun TYPE%vstd!seq.Seq. (Dcr Type) Type)
(declare-const TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. Type)
(declare-const TYPE%subtle!Choice. Type)
(declare-const TYPE%core!fmt.Formatter. Type)
(declare-const TYPE%core!fmt.Error. Type)
(declare-fun TYPE%tuple%1. (Dcr Type) Type)
(declare-fun TYPE%tuple%2. (Dcr Type Dcr Type) Type)
(declare-fun FNDEF%core!clone.Clone.clone. (Dcr Type) Type)
(declare-fun Poly%fun%1. (%%Function%%) Poly)
(declare-fun %Poly%fun%1. (Poly) %%Function%%)
(declare-fun Poly%array%. (%%Function%%) Poly)
(declare-fun %Poly%array%. (Poly) %%Function%%)
(declare-fun Poly%core!fmt.Error. (core!fmt.Error.) Poly)
(declare-fun %Poly%core!fmt.Error. (Poly) core!fmt.Error.)
(declare-fun Poly%core!fmt.Formatter. (core!fmt.Formatter.) Poly)
(declare-fun %Poly%core!fmt.Formatter. (Poly) core!fmt.Formatter.)
(declare-fun Poly%core!time.Duration. (core!time.Duration.) Poly)
(declare-fun %Poly%core!time.Duration. (Poly) core!time.Duration.)
(declare-fun Poly%subtle!Choice. (subtle!Choice.) Poly)
(declare-fun %Poly%subtle!Choice. (Poly) subtle!Choice.)
(declare-fun Poly%vstd!raw_ptr.Provenance. (vstd!raw_ptr.Provenance.) Poly)
(declare-fun %Poly%vstd!raw_ptr.Provenance. (Poly) vstd!raw_ptr.Provenance.)
(declare-fun Poly%vstd!seq.Seq<char.>. (vstd!seq.Seq<char.>.) Poly)
(declare-fun %Poly%vstd!seq.Seq<char.>. (Poly) vstd!seq.Seq<char.>.)
(declare-fun Poly%slice%<u8.>. (slice%<u8.>.) Poly)
(declare-fun %Poly%slice%<u8.>. (Poly) slice%<u8.>.)
(declare-fun Poly%strslice%. (strslice%.) Poly)
(declare-fun %Poly%strslice%. (Poly) strslice%.)
(declare-fun Poly%allocator_global%. (allocator_global%.) Poly)
(declare-fun %Poly%allocator_global%. (Poly) allocator_global%.)
(declare-fun Poly%core!option.Option. (core!option.Option.) Poly)
(declare-fun %Poly%core!option.Option. (Poly) core!option.Option.)
(declare-fun Poly%core!result.Result. (core!result.Result.) Poly)
(declare-fun %Poly%core!result.Result. (Poly) core!result.Result.)
(declare-fun Poly%core!ops.range.Range. (core!ops.range.Range.) Poly)
(declare-fun %Poly%core!ops.range.Range. (Poly) core!ops.range.Range.)
(declare-fun Poly%vstd!std_specs.range.RangeGhostIterator. (vstd!std_specs.range.RangeGhostIterator.)
 Poly
)
(declare-fun %Poly%vstd!std_specs.range.RangeGhostIterator. (Poly) vstd!std_specs.range.RangeGhostIterator.)
(declare-fun Poly%vstd!raw_ptr.PtrData. (vstd!raw_ptr.PtrData.) Poly)
(declare-fun %Poly%vstd!raw_ptr.PtrData. (Poly) vstd!raw_ptr.PtrData.)
(declare-fun Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.u64.field.FieldElement51.)
 Poly
)
(declare-fun %Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly)
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun Poly%tuple%0. (tuple%0.) Poly)
(declare-fun %Poly%tuple%0. (Poly) tuple%0.)
(declare-fun Poly%tuple%1. (tuple%1.) Poly)
(declare-fun %Poly%tuple%1. (Poly) tuple%1.)
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
 (forall ((x core!fmt.Error.)) (!
   (= x (%Poly%core!fmt.Error. (Poly%core!fmt.Error. x)))
   :pattern ((Poly%core!fmt.Error. x))
   :qid internal_core__fmt__Error_box_axiom_definition
   :skolemid skolem_internal_core__fmt__Error_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%core!fmt.Error.)
    (= x (Poly%core!fmt.Error. (%Poly%core!fmt.Error. x)))
   )
   :pattern ((has_type x TYPE%core!fmt.Error.))
   :qid internal_core__fmt__Error_unbox_axiom_definition
   :skolemid skolem_internal_core__fmt__Error_unbox_axiom_definition
)))
(assert
 (forall ((x core!fmt.Error.)) (!
   (has_type (Poly%core!fmt.Error. x) TYPE%core!fmt.Error.)
   :pattern ((has_type (Poly%core!fmt.Error. x) TYPE%core!fmt.Error.))
   :qid internal_core__fmt__Error_has_type_always_definition
   :skolemid skolem_internal_core__fmt__Error_has_type_always_definition
)))
(assert
 (forall ((x core!fmt.Formatter.)) (!
   (= x (%Poly%core!fmt.Formatter. (Poly%core!fmt.Formatter. x)))
   :pattern ((Poly%core!fmt.Formatter. x))
   :qid internal_core__fmt__Formatter_box_axiom_definition
   :skolemid skolem_internal_core__fmt__Formatter_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%core!fmt.Formatter.)
    (= x (Poly%core!fmt.Formatter. (%Poly%core!fmt.Formatter. x)))
   )
   :pattern ((has_type x TYPE%core!fmt.Formatter.))
   :qid internal_core__fmt__Formatter_unbox_axiom_definition
   :skolemid skolem_internal_core__fmt__Formatter_unbox_axiom_definition
)))
(assert
 (forall ((x core!fmt.Formatter.)) (!
   (has_type (Poly%core!fmt.Formatter. x) TYPE%core!fmt.Formatter.)
   :pattern ((has_type (Poly%core!fmt.Formatter. x) TYPE%core!fmt.Formatter.))
   :qid internal_core__fmt__Formatter_has_type_always_definition
   :skolemid skolem_internal_core__fmt__Formatter_has_type_always_definition
)))
(assert
 (forall ((x core!time.Duration.)) (!
   (= x (%Poly%core!time.Duration. (Poly%core!time.Duration. x)))
   :pattern ((Poly%core!time.Duration. x))
   :qid internal_core__time__Duration_box_axiom_definition
   :skolemid skolem_internal_core__time__Duration_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%core!time.Duration.)
    (= x (Poly%core!time.Duration. (%Poly%core!time.Duration. x)))
   )
   :pattern ((has_type x TYPE%core!time.Duration.))
   :qid internal_core__time__Duration_unbox_axiom_definition
   :skolemid skolem_internal_core__time__Duration_unbox_axiom_definition
)))
(assert
 (forall ((x core!time.Duration.)) (!
   (has_type (Poly%core!time.Duration. x) TYPE%core!time.Duration.)
   :pattern ((has_type (Poly%core!time.Duration. x) TYPE%core!time.Duration.))
   :qid internal_core__time__Duration_has_type_always_definition
   :skolemid skolem_internal_core__time__Duration_has_type_always_definition
)))
(assert
 (forall ((x subtle!Choice.)) (!
   (= x (%Poly%subtle!Choice. (Poly%subtle!Choice. x)))
   :pattern ((Poly%subtle!Choice. x))
   :qid internal_subtle__Choice_box_axiom_definition
   :skolemid skolem_internal_subtle__Choice_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%subtle!Choice.)
    (= x (Poly%subtle!Choice. (%Poly%subtle!Choice. x)))
   )
   :pattern ((has_type x TYPE%subtle!Choice.))
   :qid internal_subtle__Choice_unbox_axiom_definition
   :skolemid skolem_internal_subtle__Choice_unbox_axiom_definition
)))
(assert
 (forall ((x subtle!Choice.)) (!
   (has_type (Poly%subtle!Choice. x) TYPE%subtle!Choice.)
   :pattern ((has_type (Poly%subtle!Choice. x) TYPE%subtle!Choice.))
   :qid internal_subtle__Choice_has_type_always_definition
   :skolemid skolem_internal_subtle__Choice_has_type_always_definition
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
 (forall ((x vstd!seq.Seq<char.>.)) (!
   (= x (%Poly%vstd!seq.Seq<char.>. (Poly%vstd!seq.Seq<char.>. x)))
   :pattern ((Poly%vstd!seq.Seq<char.>. x))
   :qid internal_vstd__seq__Seq<char.>_box_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<char.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!seq.Seq. $ CHAR))
    (= x (Poly%vstd!seq.Seq<char.>. (%Poly%vstd!seq.Seq<char.>. x)))
   )
   :pattern ((has_type x (TYPE%vstd!seq.Seq. $ CHAR)))
   :qid internal_vstd__seq__Seq<char.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<char.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!seq.Seq<char.>.)) (!
   (has_type (Poly%vstd!seq.Seq<char.>. x) (TYPE%vstd!seq.Seq. $ CHAR))
   :pattern ((has_type (Poly%vstd!seq.Seq<char.>. x) (TYPE%vstd!seq.Seq. $ CHAR)))
   :qid internal_vstd__seq__Seq<char.>_has_type_always_definition
   :skolemid skolem_internal_vstd__seq__Seq<char.>_has_type_always_definition
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
 (forall ((x strslice%.)) (!
   (= x (%Poly%strslice%. (Poly%strslice%. x)))
   :pattern ((Poly%strslice%. x))
   :qid internal_crate__strslice___box_axiom_definition
   :skolemid skolem_internal_crate__strslice___box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x STRSLICE)
    (= x (Poly%strslice%. (%Poly%strslice%. x)))
   )
   :pattern ((has_type x STRSLICE))
   :qid internal_crate__strslice___unbox_axiom_definition
   :skolemid skolem_internal_crate__strslice___unbox_axiom_definition
)))
(assert
 (forall ((x strslice%.)) (!
   (has_type (Poly%strslice%. x) STRSLICE)
   :pattern ((has_type (Poly%strslice%. x) STRSLICE))
   :qid internal_crate__strslice___has_type_always_definition
   :skolemid skolem_internal_crate__strslice___has_type_always_definition
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
 (forall ((x core!result.Result.)) (!
   (= x (%Poly%core!result.Result. (Poly%core!result.Result. x)))
   :pattern ((Poly%core!result.Result. x))
   :qid internal_core__result__Result_box_axiom_definition
   :skolemid skolem_internal_core__result__Result_box_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%core!result.Result. T&. T& E&. E&))
    (= x (Poly%core!result.Result. (%Poly%core!result.Result. x)))
   )
   :pattern ((has_type x (TYPE%core!result.Result. T&. T& E&. E&)))
   :qid internal_core__result__Result_unbox_axiom_definition
   :skolemid skolem_internal_core__result__Result_unbox_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (_0! Poly)) (!
   (=>
    (has_type _0! T&)
    (has_type (Poly%core!result.Result. (core!result.Result./Ok _0!)) (TYPE%core!result.Result.
      T&. T& E&. E&
   )))
   :pattern ((has_type (Poly%core!result.Result. (core!result.Result./Ok _0!)) (TYPE%core!result.Result.
      T&. T& E&. E&
   )))
   :qid internal_core!result.Result./Ok_constructor_definition
   :skolemid skolem_internal_core!result.Result./Ok_constructor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (x core!result.Result.)) (!
   (=>
    (is-core!result.Result./Ok x)
    (= (core!result.Result./Ok/0 T&. T& E&. E& x) (core!result.Result./Ok/?0 x))
   )
   :pattern ((core!result.Result./Ok/0 T&. T& E&. E& x))
   :qid internal_core!result.Result./Ok/0_accessor_definition
   :skolemid skolem_internal_core!result.Result./Ok/0_accessor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%core!result.Result. T&. T& E&. E&))
    (has_type (core!result.Result./Ok/0 T&. T& E&. E& (%Poly%core!result.Result. x)) T&)
   )
   :pattern ((core!result.Result./Ok/0 T&. T& E&. E& (%Poly%core!result.Result. x)) (
     has_type x (TYPE%core!result.Result. T&. T& E&. E&)
   ))
   :qid internal_core!result.Result./Ok/0_invariant_definition
   :skolemid skolem_internal_core!result.Result./Ok/0_invariant_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (_0! Poly)) (!
   (=>
    (has_type _0! E&)
    (has_type (Poly%core!result.Result. (core!result.Result./Err _0!)) (TYPE%core!result.Result.
      T&. T& E&. E&
   )))
   :pattern ((has_type (Poly%core!result.Result. (core!result.Result./Err _0!)) (TYPE%core!result.Result.
      T&. T& E&. E&
   )))
   :qid internal_core!result.Result./Err_constructor_definition
   :skolemid skolem_internal_core!result.Result./Err_constructor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (x core!result.Result.)) (!
   (=>
    (is-core!result.Result./Err x)
    (= (core!result.Result./Err/0 T&. T& E&. E& x) (core!result.Result./Err/?0 x))
   )
   :pattern ((core!result.Result./Err/0 T&. T& E&. E& x))
   :qid internal_core!result.Result./Err/0_accessor_definition
   :skolemid skolem_internal_core!result.Result./Err/0_accessor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%core!result.Result. T&. T& E&. E&))
    (has_type (core!result.Result./Err/0 T&. T& E&. E& (%Poly%core!result.Result. x))
     E&
   ))
   :pattern ((core!result.Result./Err/0 T&. T& E&. E& (%Poly%core!result.Result. x))
    (has_type x (TYPE%core!result.Result. T&. T& E&. E&))
   )
   :qid internal_core!result.Result./Err/0_invariant_definition
   :skolemid skolem_internal_core!result.Result./Err/0_invariant_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (x core!result.Result.)) (!
   (=>
    (is-core!result.Result./Ok x)
    (height_lt (height (core!result.Result./Ok/0 T&. T& E&. E& x)) (height (Poly%core!result.Result.
       x
   ))))
   :pattern ((height (core!result.Result./Ok/0 T&. T& E&. E& x)))
   :qid prelude_datatype_height_core!result.Result./Ok/0
   :skolemid skolem_prelude_datatype_height_core!result.Result./Ok/0
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (x core!result.Result.)) (!
   (=>
    (is-core!result.Result./Err x)
    (height_lt (height (core!result.Result./Err/0 T&. T& E&. E& x)) (height (Poly%core!result.Result.
       x
   ))))
   :pattern ((height (core!result.Result./Err/0 T&. T& E&. E& x)))
   :qid prelude_datatype_height_core!result.Result./Err/0
   :skolemid skolem_prelude_datatype_height_core!result.Result./Err/0
)))
(assert
 (forall ((x core!ops.range.Range.)) (!
   (= x (%Poly%core!ops.range.Range. (Poly%core!ops.range.Range. x)))
   :pattern ((Poly%core!ops.range.Range. x))
   :qid internal_core__ops__range__Range_box_axiom_definition
   :skolemid skolem_internal_core__ops__range__Range_box_axiom_definition
)))
(assert
 (forall ((Idx&. Dcr) (Idx& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%core!ops.range.Range. Idx&. Idx&))
    (= x (Poly%core!ops.range.Range. (%Poly%core!ops.range.Range. x)))
   )
   :pattern ((has_type x (TYPE%core!ops.range.Range. Idx&. Idx&)))
   :qid internal_core__ops__range__Range_unbox_axiom_definition
   :skolemid skolem_internal_core__ops__range__Range_unbox_axiom_definition
)))
(assert
 (forall ((Idx&. Dcr) (Idx& Type) (_start! Poly) (_end! Poly)) (!
   (=>
    (and
     (has_type _start! Idx&)
     (has_type _end! Idx&)
    )
    (has_type (Poly%core!ops.range.Range. (core!ops.range.Range./Range _start! _end!))
     (TYPE%core!ops.range.Range. Idx&. Idx&)
   ))
   :pattern ((has_type (Poly%core!ops.range.Range. (core!ops.range.Range./Range _start!
       _end!
      )
     ) (TYPE%core!ops.range.Range. Idx&. Idx&)
   ))
   :qid internal_core!ops.range.Range./Range_constructor_definition
   :skolemid skolem_internal_core!ops.range.Range./Range_constructor_definition
)))
(assert
 (forall ((x core!ops.range.Range.)) (!
   (= (core!ops.range.Range./Range/start x) (core!ops.range.Range./Range/?start x))
   :pattern ((core!ops.range.Range./Range/start x))
   :qid internal_core!ops.range.Range./Range/start_accessor_definition
   :skolemid skolem_internal_core!ops.range.Range./Range/start_accessor_definition
)))
(assert
 (forall ((Idx&. Dcr) (Idx& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%core!ops.range.Range. Idx&. Idx&))
    (has_type (core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. x)) Idx&)
   )
   :pattern ((core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. x)) (has_type
     x (TYPE%core!ops.range.Range. Idx&. Idx&)
   ))
   :qid internal_core!ops.range.Range./Range/start_invariant_definition
   :skolemid skolem_internal_core!ops.range.Range./Range/start_invariant_definition
)))
(assert
 (forall ((x core!ops.range.Range.)) (!
   (= (core!ops.range.Range./Range/end x) (core!ops.range.Range./Range/?end x))
   :pattern ((core!ops.range.Range./Range/end x))
   :qid internal_core!ops.range.Range./Range/end_accessor_definition
   :skolemid skolem_internal_core!ops.range.Range./Range/end_accessor_definition
)))
(assert
 (forall ((Idx&. Dcr) (Idx& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%core!ops.range.Range. Idx&. Idx&))
    (has_type (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. x)) Idx&)
   )
   :pattern ((core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. x)) (has_type
     x (TYPE%core!ops.range.Range. Idx&. Idx&)
   ))
   :qid internal_core!ops.range.Range./Range/end_invariant_definition
   :skolemid skolem_internal_core!ops.range.Range./Range/end_invariant_definition
)))
(assert
 (forall ((x core!ops.range.Range.)) (!
   (=>
    (is-core!ops.range.Range./Range x)
    (height_lt (height (core!ops.range.Range./Range/start x)) (height (Poly%core!ops.range.Range.
       x
   ))))
   :pattern ((height (core!ops.range.Range./Range/start x)))
   :qid prelude_datatype_height_core!ops.range.Range./Range/start
   :skolemid skolem_prelude_datatype_height_core!ops.range.Range./Range/start
)))
(assert
 (forall ((x core!ops.range.Range.)) (!
   (=>
    (is-core!ops.range.Range./Range x)
    (height_lt (height (core!ops.range.Range./Range/end x)) (height (Poly%core!ops.range.Range.
       x
   ))))
   :pattern ((height (core!ops.range.Range./Range/end x)))
   :qid prelude_datatype_height_core!ops.range.Range./Range/end
   :skolemid skolem_prelude_datatype_height_core!ops.range.Range./Range/end
)))
(assert
 (forall ((x vstd!std_specs.range.RangeGhostIterator.)) (!
   (= x (%Poly%vstd!std_specs.range.RangeGhostIterator. (Poly%vstd!std_specs.range.RangeGhostIterator.
      x
   )))
   :pattern ((Poly%vstd!std_specs.range.RangeGhostIterator. x))
   :qid internal_vstd__std_specs__range__RangeGhostIterator_box_axiom_definition
   :skolemid skolem_internal_vstd__std_specs__range__RangeGhostIterator_box_axiom_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&))
    (= x (Poly%vstd!std_specs.range.RangeGhostIterator. (%Poly%vstd!std_specs.range.RangeGhostIterator.
       x
   ))))
   :pattern ((has_type x (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&)))
   :qid internal_vstd__std_specs__range__RangeGhostIterator_unbox_axiom_definition
   :skolemid skolem_internal_vstd__std_specs__range__RangeGhostIterator_unbox_axiom_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type) (_start! Poly) (_cur! Poly) (_end! Poly)) (!
   (=>
    (and
     (has_type _start! A&)
     (has_type _cur! A&)
     (has_type _end! A&)
    )
    (has_type (Poly%vstd!std_specs.range.RangeGhostIterator. (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator
       _start! _cur! _end!
      )
     ) (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&)
   ))
   :pattern ((has_type (Poly%vstd!std_specs.range.RangeGhostIterator. (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator
       _start! _cur! _end!
      )
     ) (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&)
   ))
   :qid internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator_constructor_definition
   :skolemid skolem_internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator_constructor_definition
)))
(assert
 (forall ((x vstd!std_specs.range.RangeGhostIterator.)) (!
   (= (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start x) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/?start
     x
   ))
   :pattern ((vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start x))
   :qid internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start_accessor_definition
   :skolemid skolem_internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start_accessor_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&))
    (has_type (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start (%Poly%vstd!std_specs.range.RangeGhostIterator.
       x
      )
     ) A&
   ))
   :pattern ((vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start (%Poly%vstd!std_specs.range.RangeGhostIterator.
      x
     )
    ) (has_type x (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&))
   )
   :qid internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start_invariant_definition
   :skolemid skolem_internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start_invariant_definition
)))
(assert
 (forall ((x vstd!std_specs.range.RangeGhostIterator.)) (!
   (= (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur x) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/?cur
     x
   ))
   :pattern ((vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur x))
   :qid internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur_accessor_definition
   :skolemid skolem_internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur_accessor_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&))
    (has_type (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (%Poly%vstd!std_specs.range.RangeGhostIterator.
       x
      )
     ) A&
   ))
   :pattern ((vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (%Poly%vstd!std_specs.range.RangeGhostIterator.
      x
     )
    ) (has_type x (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&))
   )
   :qid internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur_invariant_definition
   :skolemid skolem_internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur_invariant_definition
)))
(assert
 (forall ((x vstd!std_specs.range.RangeGhostIterator.)) (!
   (= (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end x) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/?end
     x
   ))
   :pattern ((vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end x))
   :qid internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end_accessor_definition
   :skolemid skolem_internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end_accessor_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&))
    (has_type (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (%Poly%vstd!std_specs.range.RangeGhostIterator.
       x
      )
     ) A&
   ))
   :pattern ((vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (%Poly%vstd!std_specs.range.RangeGhostIterator.
      x
     )
    ) (has_type x (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&))
   )
   :qid internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end_invariant_definition
   :skolemid skolem_internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end_invariant_definition
)))
(assert
 (forall ((x vstd!std_specs.range.RangeGhostIterator.)) (!
   (=>
    (is-vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator x)
    (height_lt (height (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start
       x
      )
     ) (height (Poly%vstd!std_specs.range.RangeGhostIterator. x))
   ))
   :pattern ((height (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start
      x
   )))
   :qid prelude_datatype_height_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start
   :skolemid skolem_prelude_datatype_height_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start
)))
(assert
 (forall ((x vstd!std_specs.range.RangeGhostIterator.)) (!
   (=>
    (is-vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator x)
    (height_lt (height (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur
       x
      )
     ) (height (Poly%vstd!std_specs.range.RangeGhostIterator. x))
   ))
   :pattern ((height (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur x)))
   :qid prelude_datatype_height_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur
   :skolemid skolem_prelude_datatype_height_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur
)))
(assert
 (forall ((x vstd!std_specs.range.RangeGhostIterator.)) (!
   (=>
    (is-vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator x)
    (height_lt (height (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end
       x
      )
     ) (height (Poly%vstd!std_specs.range.RangeGhostIterator. x))
   ))
   :pattern ((height (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end x)))
   :qid prelude_datatype_height_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end
   :skolemid skolem_prelude_datatype_height_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end
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
 (forall ((x tuple%1.)) (!
   (= x (%Poly%tuple%1. (Poly%tuple%1. x)))
   :pattern ((Poly%tuple%1. x))
   :qid internal_crate__tuple__1_box_axiom_definition
   :skolemid skolem_internal_crate__tuple__1_box_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%tuple%1. T%0&. T%0&))
    (= x (Poly%tuple%1. (%Poly%tuple%1. x)))
   )
   :pattern ((has_type x (TYPE%tuple%1. T%0&. T%0&)))
   :qid internal_crate__tuple__1_unbox_axiom_definition
   :skolemid skolem_internal_crate__tuple__1_unbox_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (_0! Poly)) (!
   (=>
    (has_type _0! T%0&)
    (has_type (Poly%tuple%1. (tuple%1./tuple%1 _0!)) (TYPE%tuple%1. T%0&. T%0&))
   )
   :pattern ((has_type (Poly%tuple%1. (tuple%1./tuple%1 _0!)) (TYPE%tuple%1. T%0&. T%0&)))
   :qid internal_tuple__1./tuple__1_constructor_definition
   :skolemid skolem_internal_tuple__1./tuple__1_constructor_definition
)))
(assert
 (forall ((x tuple%1.)) (!
   (= (tuple%1./tuple%1/0 x) (tuple%1./tuple%1/?0 x))
   :pattern ((tuple%1./tuple%1/0 x))
   :qid internal_tuple__1./tuple__1/0_accessor_definition
   :skolemid skolem_internal_tuple__1./tuple__1/0_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%tuple%1. T%0&. T%0&))
    (has_type (tuple%1./tuple%1/0 (%Poly%tuple%1. x)) T%0&)
   )
   :pattern ((tuple%1./tuple%1/0 (%Poly%tuple%1. x)) (has_type x (TYPE%tuple%1. T%0&. T%0&)))
   :qid internal_tuple__1./tuple__1/0_invariant_definition
   :skolemid skolem_internal_tuple__1./tuple__1/0_invariant_definition
)))
(assert
 (forall ((x tuple%1.)) (!
   (=>
    (is-tuple%1./tuple%1 x)
    (height_lt (height (tuple%1./tuple%1/0 x)) (height (Poly%tuple%1. x)))
   )
   :pattern ((height (tuple%1./tuple%1/0 x)))
   :qid prelude_datatype_height_tuple%1./tuple%1/0
   :skolemid skolem_prelude_datatype_height_tuple%1./tuple%1/0
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (deep Bool) (x Poly) (y Poly)) (!
   (=>
    (and
     (has_type x (TYPE%tuple%1. T%0&. T%0&))
     (has_type y (TYPE%tuple%1. T%0&. T%0&))
     (ext_eq deep T%0& (tuple%1./tuple%1/0 (%Poly%tuple%1. x)) (tuple%1./tuple%1/0 (%Poly%tuple%1.
        y
    ))))
    (ext_eq deep (TYPE%tuple%1. T%0&. T%0&) x y)
   )
   :pattern ((ext_eq deep (TYPE%tuple%1. T%0&. T%0&) x y))
   :qid internal_tuple__1./tuple__1_ext_equal_definition
   :skolemid skolem_internal_tuple__1./tuple__1_ext_equal_definition
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
(declare-fun str%strslice_is_ascii (strslice%.) Bool)
(declare-fun str%strslice_len (strslice%.) Int)
(declare-fun str%strslice_get_char (strslice%. Int) Int)
(declare-fun str%new_strlit (Int) strslice%.)
(declare-fun str%from_strlit (strslice%.) Int)
(assert
 (forall ((x Int)) (!
   (= (str%from_strlit (str%new_strlit x)) x)
   :pattern ((str%new_strlit x))
   :qid prelude_strlit_injective
   :skolemid skolem_prelude_strlit_injective
)))

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
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (=>
    (tr_bound%vstd!pervasive.ForLoopGhostIterator. Self%&. Self%&)
    (and
     (sized (proj%%vstd!pervasive.ForLoopGhostIterator./ExecIter Self%&. Self%&))
     (sized (proj%%vstd!pervasive.ForLoopGhostIterator./Item Self%&. Self%&))
     (sized (proj%%vstd!pervasive.ForLoopGhostIterator./Decrease Self%&. Self%&))
   ))
   :pattern ((tr_bound%vstd!pervasive.ForLoopGhostIterator. Self%&. Self%&))
   :qid internal_vstd__pervasive__ForLoopGhostIterator_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__pervasive__ForLoopGhostIterator_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (=>
    (tr_bound%vstd!pervasive.ForLoopGhostIteratorNew. Self%&. Self%&)
    (sized (proj%%vstd!pervasive.ForLoopGhostIteratorNew./GhostIter Self%&. Self%&))
   )
   :pattern ((tr_bound%vstd!pervasive.ForLoopGhostIteratorNew. Self%&. Self%&))
   :qid internal_vstd__pervasive__ForLoopGhostIteratorNew_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__pervasive__ForLoopGhostIteratorNew_trait_type_bounds_definition
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
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type)) (!
   true
   :pattern ((tr_bound%core!slice.index.SliceIndex. Self%&. Self%& T&. T&))
   :qid internal_core__slice__index__SliceIndex_trait_type_bounds_definition
   :skolemid skolem_internal_core__slice__index__SliceIndex_trait_type_bounds_definition
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
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (=>
    (tr_bound%core!clone.Clone. Self%&. Self%&)
    (sized Self%&.)
   )
   :pattern ((tr_bound%core!clone.Clone. Self%&. Self%&))
   :qid internal_core__clone__Clone_trait_type_bounds_definition
   :skolemid skolem_internal_core__clone__Clone_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   true
   :pattern ((tr_bound%core!cmp.PartialEq. Self%&. Self%& Rhs&. Rhs&))
   :qid internal_core__cmp__PartialEq_trait_type_bounds_definition
   :skolemid skolem_internal_core__cmp__PartialEq_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   (=>
    (tr_bound%core!cmp.PartialOrd. Self%&. Self%& Rhs&. Rhs&)
    (tr_bound%core!cmp.PartialEq. Self%&. Self%& Rhs&. Rhs&)
   )
   :pattern ((tr_bound%core!cmp.PartialOrd. Self%&. Self%& Rhs&. Rhs&))
   :qid internal_core__cmp__PartialOrd_trait_type_bounds_definition
   :skolemid skolem_internal_core__cmp__PartialOrd_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Idx&. Dcr) (Idx& Type)) (!
   true
   :pattern ((tr_bound%core!ops.index.Index. Self%&. Self%& Idx&. Idx&))
   :qid internal_core__ops__index__Index_trait_type_bounds_definition
   :skolemid skolem_internal_core__ops__index__Index_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Idx&. Dcr) (Idx& Type)) (!
   (=>
    (tr_bound%core!ops.index.IndexMut. Self%&. Self%& Idx&. Idx&)
    (tr_bound%core!ops.index.Index. Self%&. Self%& Idx&. Idx&)
   )
   :pattern ((tr_bound%core!ops.index.IndexMut. Self%&. Self%& Idx&. Idx&))
   :qid internal_core__ops__index__IndexMut_trait_type_bounds_definition
   :skolemid skolem_internal_core__ops__index__IndexMut_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   true
   :pattern ((tr_bound%core!alloc.Allocator. Self%&. Self%&))
   :qid internal_core__alloc__Allocator_trait_type_bounds_definition
   :skolemid skolem_internal_core__alloc__Allocator_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (=>
    (tr_bound%core!iter.traits.iterator.Iterator. Self%&. Self%&)
    (sized (proj%%core!iter.traits.iterator.Iterator./Item Self%&. Self%&))
   )
   :pattern ((tr_bound%core!iter.traits.iterator.Iterator. Self%&. Self%&))
   :qid internal_core__iter__traits__iterator__Iterator_trait_type_bounds_definition
   :skolemid skolem_internal_core__iter__traits__iterator__Iterator_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (=>
    (tr_bound%core!iter.range.Step. Self%&. Self%&)
    (and
     (sized Self%&.)
     (tr_bound%core!clone.Clone. Self%&. Self%&)
     (tr_bound%core!cmp.PartialOrd. Self%&. Self%& Self%&. Self%&)
   ))
   :pattern ((tr_bound%core!iter.range.Step. Self%&. Self%&))
   :qid internal_core__iter__range__Step_trait_type_bounds_definition
   :skolemid skolem_internal_core__iter__range__Step_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   true
   :pattern ((tr_bound%vstd!std_specs.core.TrustedSpecSealed. Self%&. Self%&))
   :qid internal_vstd__std_specs__core__TrustedSpecSealed_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__std_specs__core__TrustedSpecSealed_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Idx&. Dcr) (Idx& Type)) (!
   (=>
    (tr_bound%vstd!std_specs.core.IndexSetTrustedSpec. Self%&. Self%& Idx&. Idx&)
    (and
     (tr_bound%core!ops.index.IndexMut. Self%&. Self%& Idx&. Idx&)
     (tr_bound%vstd!std_specs.core.TrustedSpecSealed. Self%&. Self%&)
     (sized Idx&.)
   ))
   :pattern ((tr_bound%vstd!std_specs.core.IndexSetTrustedSpec. Self%&. Self%& Idx&. Idx&))
   :qid internal_vstd__std_specs__core__IndexSetTrustedSpec_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__std_specs__core__IndexSetTrustedSpec_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (=>
    (tr_bound%core!ops.arith.Neg. Self%&. Self%&)
    (sized (proj%%core!ops.arith.Neg./Output Self%&. Self%&))
   )
   :pattern ((tr_bound%core!ops.arith.Neg. Self%&. Self%&))
   :qid internal_core__ops__arith__Neg_trait_type_bounds_definition
   :skolemid skolem_internal_core__ops__arith__Neg_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (=>
    (tr_bound%vstd!std_specs.ops.NegSpec. Self%&. Self%&)
    (tr_bound%core!ops.arith.Neg. Self%&. Self%&)
   )
   :pattern ((tr_bound%vstd!std_specs.ops.NegSpec. Self%&. Self%&))
   :qid internal_vstd__std_specs__ops__NegSpec_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__std_specs__ops__NegSpec_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   (=>
    (tr_bound%core!ops.arith.Add. Self%&. Self%& Rhs&. Rhs&)
    (and
     (sized Rhs&.)
     (sized (proj%%core!ops.arith.Add./Output Self%&. Self%& Rhs&. Rhs&))
   ))
   :pattern ((tr_bound%core!ops.arith.Add. Self%&. Self%& Rhs&. Rhs&))
   :qid internal_core__ops__arith__Add_trait_type_bounds_definition
   :skolemid skolem_internal_core__ops__arith__Add_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   (=>
    (tr_bound%vstd!std_specs.ops.AddSpec. Self%&. Self%& Rhs&. Rhs&)
    (and
     (tr_bound%core!ops.arith.Add. Self%&. Self%& Rhs&. Rhs&)
     (sized Rhs&.)
   ))
   :pattern ((tr_bound%vstd!std_specs.ops.AddSpec. Self%&. Self%& Rhs&. Rhs&))
   :qid internal_vstd__std_specs__ops__AddSpec_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__std_specs__ops__AddSpec_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   (=>
    (tr_bound%core!ops.arith.Sub. Self%&. Self%& Rhs&. Rhs&)
    (and
     (sized Rhs&.)
     (sized (proj%%core!ops.arith.Sub./Output Self%&. Self%& Rhs&. Rhs&))
   ))
   :pattern ((tr_bound%core!ops.arith.Sub. Self%&. Self%& Rhs&. Rhs&))
   :qid internal_core__ops__arith__Sub_trait_type_bounds_definition
   :skolemid skolem_internal_core__ops__arith__Sub_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   (=>
    (tr_bound%vstd!std_specs.ops.SubSpec. Self%&. Self%& Rhs&. Rhs&)
    (and
     (tr_bound%core!ops.arith.Sub. Self%&. Self%& Rhs&. Rhs&)
     (sized Rhs&.)
   ))
   :pattern ((tr_bound%vstd!std_specs.ops.SubSpec. Self%&. Self%& Rhs&. Rhs&))
   :qid internal_vstd__std_specs__ops__SubSpec_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__std_specs__ops__SubSpec_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   (=>
    (tr_bound%core!ops.arith.Mul. Self%&. Self%& Rhs&. Rhs&)
    (and
     (sized Rhs&.)
     (sized (proj%%core!ops.arith.Mul./Output Self%&. Self%& Rhs&. Rhs&))
   ))
   :pattern ((tr_bound%core!ops.arith.Mul. Self%&. Self%& Rhs&. Rhs&))
   :qid internal_core__ops__arith__Mul_trait_type_bounds_definition
   :skolemid skolem_internal_core__ops__arith__Mul_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   (=>
    (tr_bound%vstd!std_specs.ops.MulSpec. Self%&. Self%& Rhs&. Rhs&)
    (and
     (tr_bound%core!ops.arith.Mul. Self%&. Self%& Rhs&. Rhs&)
     (sized Rhs&.)
   ))
   :pattern ((tr_bound%vstd!std_specs.ops.MulSpec. Self%&. Self%& Rhs&. Rhs&))
   :qid internal_vstd__std_specs__ops__MulSpec_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__std_specs__ops__MulSpec_trait_type_bounds_definition
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
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (=>
    (tr_bound%vstd!std_specs.range.StepSpec. Self%&. Self%&)
    (sized Self%&.)
   )
   :pattern ((tr_bound%vstd!std_specs.range.StepSpec. Self%&. Self%&))
   :qid internal_vstd__std_specs__range__StepSpec_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__std_specs__range__StepSpec_trait_type_bounds_definition
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
 (= (proj%%vstd!view.View./V $slice STRSLICE) $)
)
(assert
 (= (proj%vstd!view.View./V $slice STRSLICE) (TYPE%vstd!seq.Seq. $ CHAR))
)
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
 (= (proj%%vstd!view.View./V $ (UINT 32)) $)
)
(assert
 (= (proj%vstd!view.View./V $ (UINT 32)) (UINT 32))
)
(assert
 (= (proj%%vstd!view.View./V $ (UINT 64)) $)
)
(assert
 (= (proj%vstd!view.View./V $ (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%vstd!view.View./V $ (UINT 128)) $)
)
(assert
 (= (proj%vstd!view.View./V $ (UINT 128)) (UINT 128))
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
 (= (proj%%vstd!view.View./V $ CHAR) $)
)
(assert
 (= (proj%vstd!view.View./V $ CHAR) CHAR)
)
(assert
 (forall ((A0&. Dcr) (A0& Type)) (!
   (= (proj%%vstd!view.View./V (DST A0&.) (TYPE%tuple%1. A0&. A0&)) (DST (proj%%vstd!view.View./V
      A0&. A0&
   )))
   :pattern ((proj%%vstd!view.View./V (DST A0&.) (TYPE%tuple%1. A0&. A0&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A0&. Dcr) (A0& Type)) (!
   (= (proj%vstd!view.View./V (DST A0&.) (TYPE%tuple%1. A0&. A0&)) (TYPE%tuple%1. (proj%%vstd!view.View./V
      A0&. A0&
     ) (proj%vstd!view.View./V A0&. A0&)
   ))
   :pattern ((proj%vstd!view.View./V (DST A0&.) (TYPE%tuple%1. A0&. A0&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
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
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!pervasive.ForLoopGhostIteratorNew./GhostIter $ (TYPE%core!ops.range.Range.
      A&. A&
     )
    ) $
   )
   :pattern ((proj%%vstd!pervasive.ForLoopGhostIteratorNew./GhostIter $ (TYPE%core!ops.range.Range.
      A&. A&
   )))
   :qid internal_proj____vstd!pervasive.ForLoopGhostIteratorNew./GhostIter_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!pervasive.ForLoopGhostIteratorNew./GhostIter_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!pervasive.ForLoopGhostIteratorNew./GhostIter $ (TYPE%core!ops.range.Range.
      A&. A&
     )
    ) (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&)
   )
   :pattern ((proj%vstd!pervasive.ForLoopGhostIteratorNew./GhostIter $ (TYPE%core!ops.range.Range.
      A&. A&
   )))
   :qid internal_proj__vstd!pervasive.ForLoopGhostIteratorNew./GhostIter_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!pervasive.ForLoopGhostIteratorNew./GhostIter_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!pervasive.ForLoopGhostIterator./ExecIter $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
     )
    ) $
   )
   :pattern ((proj%%vstd!pervasive.ForLoopGhostIterator./ExecIter $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
   )))
   :qid internal_proj____vstd!pervasive.ForLoopGhostIterator./ExecIter_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!pervasive.ForLoopGhostIterator./ExecIter_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!pervasive.ForLoopGhostIterator./ExecIter $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
     )
    ) (TYPE%core!ops.range.Range. A&. A&)
   )
   :pattern ((proj%vstd!pervasive.ForLoopGhostIterator./ExecIter $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
   )))
   :qid internal_proj__vstd!pervasive.ForLoopGhostIterator./ExecIter_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!pervasive.ForLoopGhostIterator./ExecIter_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!pervasive.ForLoopGhostIterator./Item $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
     )
    ) A&.
   )
   :pattern ((proj%%vstd!pervasive.ForLoopGhostIterator./Item $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
   )))
   :qid internal_proj____vstd!pervasive.ForLoopGhostIterator./Item_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!pervasive.ForLoopGhostIterator./Item_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!pervasive.ForLoopGhostIterator./Item $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
     )
    ) A&
   )
   :pattern ((proj%vstd!pervasive.ForLoopGhostIterator./Item $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
   )))
   :qid internal_proj__vstd!pervasive.ForLoopGhostIterator./Item_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!pervasive.ForLoopGhostIterator./Item_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!pervasive.ForLoopGhostIterator./Decrease $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
     )
    ) $
   )
   :pattern ((proj%%vstd!pervasive.ForLoopGhostIterator./Decrease $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
   )))
   :qid internal_proj____vstd!pervasive.ForLoopGhostIterator./Decrease_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!pervasive.ForLoopGhostIterator./Decrease_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!pervasive.ForLoopGhostIterator./Decrease $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
     )
    ) INT
   )
   :pattern ((proj%vstd!pervasive.ForLoopGhostIterator./Decrease $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
   )))
   :qid internal_proj__vstd!pervasive.ForLoopGhostIterator./Decrease_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!pervasive.ForLoopGhostIterator./Decrease_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!view.View./V $ (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&))
    $
   )
   :pattern ((proj%%vstd!view.View./V $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
   )))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!view.View./V $ (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&))
    (TYPE%vstd!seq.Seq. A&. A&)
   )
   :pattern ((proj%vstd!view.View./V $ (TYPE%vstd!std_specs.range.RangeGhostIterator. A&.
      A&
   )))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) USIZE $ USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) USIZE $ USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) USIZE (REF $) USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) USIZE (REF $) USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (UINT 8) $ (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (UINT 8) $ (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (UINT 8) (REF $) (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (UINT 8) (REF $) (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (UINT 32) $ (UINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (UINT 32) $ (UINT 32)) (UINT 32))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (UINT 32) (REF $) (UINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (UINT 32) (REF $) (UINT 32)) (UINT 32))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (UINT 64) $ (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (UINT 64) $ (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (UINT 64) (REF $) (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (UINT 64) (REF $) (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (UINT 128) $ (UINT 128)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (UINT 128) $ (UINT 128)) (UINT 128))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (UINT 128) (REF $) (UINT 128)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (UINT 128) (REF $) (UINT 128)) (UINT 128))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (SINT 32) $ (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (SINT 32) $ (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (SINT 32) (REF $) (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (SINT 32) (REF $) (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ USIZE $ USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ USIZE $ USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ USIZE (REF $) USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ USIZE (REF $) USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (UINT 8) $ (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (UINT 8) $ (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (UINT 8) (REF $) (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (UINT 8) (REF $) (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (UINT 32) $ (UINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (UINT 32) $ (UINT 32)) (UINT 32))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (UINT 32) (REF $) (UINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (UINT 32) (REF $) (UINT 32)) (UINT 32))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (UINT 64) $ (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (UINT 64) $ (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (UINT 64) (REF $) (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (UINT 64) (REF $) (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (UINT 128) $ (UINT 128)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (UINT 128) $ (UINT 128)) (UINT 128))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (UINT 128) (REF $) (UINT 128)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (UINT 128) (REF $) (UINT 128)) (UINT 128))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (SINT 32) $ (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (SINT 32) $ (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (SINT 32) (REF $) (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (SINT 32) (REF $) (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ TYPE%core!time.Duration. $ TYPE%core!time.Duration.)
  $
))
(assert
 (= (proj%core!ops.arith.Add./Output $ TYPE%core!time.Duration. $ TYPE%core!time.Duration.)
  TYPE%core!time.Duration.
))
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) USIZE $ USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) USIZE $ USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) USIZE (REF $) USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) USIZE (REF $) USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) (UINT 8) $ (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) (UINT 8) $ (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) (UINT 8) (REF $) (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) (UINT 8) (REF $) (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) (UINT 32) $ (UINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) (UINT 32) $ (UINT 32)) (UINT 32))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) (UINT 32) (REF $) (UINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) (UINT 32) (REF $) (UINT 32)) (UINT 32))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) (UINT 64) $ (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) (UINT 64) $ (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) (UINT 64) (REF $) (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) (UINT 64) (REF $) (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) (UINT 128) $ (UINT 128)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) (UINT 128) $ (UINT 128)) (UINT 128))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) (UINT 128) (REF $) (UINT 128)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) (UINT 128) (REF $) (UINT 128)) (UINT 128))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) (SINT 32) $ (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) (SINT 32) $ (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) (SINT 32) (REF $) (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) (SINT 32) (REF $) (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ USIZE $ USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ USIZE $ USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ USIZE (REF $) USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ USIZE (REF $) USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ (UINT 8) $ (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ (UINT 8) $ (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ (UINT 8) (REF $) (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ (UINT 8) (REF $) (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ (UINT 32) $ (UINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ (UINT 32) $ (UINT 32)) (UINT 32))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ (UINT 32) (REF $) (UINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ (UINT 32) (REF $) (UINT 32)) (UINT 32))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ (UINT 64) $ (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ (UINT 64) $ (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ (UINT 64) (REF $) (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ (UINT 64) (REF $) (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ (UINT 128) $ (UINT 128)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ (UINT 128) $ (UINT 128)) (UINT 128))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ (UINT 128) (REF $) (UINT 128)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ (UINT 128) (REF $) (UINT 128)) (UINT 128))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ (SINT 32) $ (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ (SINT 32) $ (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ (SINT 32) (REF $) (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ (SINT 32) (REF $) (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ TYPE%core!time.Duration. $ TYPE%core!time.Duration.)
  $
))
(assert
 (= (proj%core!ops.arith.Sub./Output $ TYPE%core!time.Duration. $ TYPE%core!time.Duration.)
  TYPE%core!time.Duration.
))
(assert
 (= (proj%%core!ops.arith.Mul./Output (REF $) USIZE $ USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output (REF $) USIZE $ USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Mul./Output (REF $) USIZE (REF $) USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output (REF $) USIZE (REF $) USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Mul./Output (REF $) (UINT 8) $ (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output (REF $) (UINT 8) $ (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Mul./Output (REF $) (UINT 8) (REF $) (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output (REF $) (UINT 8) (REF $) (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Mul./Output (REF $) (UINT 32) $ (UINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output (REF $) (UINT 32) $ (UINT 32)) (UINT 32))
)
(assert
 (= (proj%%core!ops.arith.Mul./Output (REF $) (UINT 32) (REF $) (UINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output (REF $) (UINT 32) (REF $) (UINT 32)) (UINT 32))
)
(assert
 (= (proj%%core!ops.arith.Mul./Output (REF $) (UINT 64) $ (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output (REF $) (UINT 64) $ (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Mul./Output (REF $) (UINT 64) (REF $) (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output (REF $) (UINT 64) (REF $) (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Mul./Output (REF $) (UINT 128) $ (UINT 128)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output (REF $) (UINT 128) $ (UINT 128)) (UINT 128))
)
(assert
 (= (proj%%core!ops.arith.Mul./Output (REF $) (UINT 128) (REF $) (UINT 128)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output (REF $) (UINT 128) (REF $) (UINT 128)) (UINT 128))
)
(assert
 (= (proj%%core!ops.arith.Mul./Output (REF $) (SINT 32) $ (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output (REF $) (SINT 32) $ (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Mul./Output (REF $) (SINT 32) (REF $) (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output (REF $) (SINT 32) (REF $) (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Mul./Output $ USIZE $ USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output $ USIZE $ USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Mul./Output $ USIZE (REF $) USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output $ USIZE (REF $) USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Mul./Output $ (UINT 8) $ (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output $ (UINT 8) $ (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Mul./Output $ (UINT 8) (REF $) (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output $ (UINT 8) (REF $) (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Mul./Output $ (UINT 32) $ (UINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output $ (UINT 32) $ (UINT 32)) (UINT 32))
)
(assert
 (= (proj%%core!ops.arith.Mul./Output $ (UINT 32) (REF $) (UINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output $ (UINT 32) (REF $) (UINT 32)) (UINT 32))
)
(assert
 (= (proj%%core!ops.arith.Mul./Output $ (UINT 32) $ TYPE%core!time.Duration.) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output $ (UINT 32) $ TYPE%core!time.Duration.) TYPE%core!time.Duration.)
)
(assert
 (= (proj%%core!ops.arith.Mul./Output $ (UINT 64) $ (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output $ (UINT 64) $ (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Mul./Output $ (UINT 64) (REF $) (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output $ (UINT 64) (REF $) (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Mul./Output $ (UINT 128) $ (UINT 128)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output $ (UINT 128) $ (UINT 128)) (UINT 128))
)
(assert
 (= (proj%%core!ops.arith.Mul./Output $ (UINT 128) (REF $) (UINT 128)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output $ (UINT 128) (REF $) (UINT 128)) (UINT 128))
)
(assert
 (= (proj%%core!ops.arith.Mul./Output $ (SINT 32) $ (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output $ (SINT 32) $ (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Mul./Output $ (SINT 32) (REF $) (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output $ (SINT 32) (REF $) (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Mul./Output $ TYPE%core!time.Duration. $ (UINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Mul./Output $ TYPE%core!time.Duration. $ (UINT 32)) TYPE%core!time.Duration.)
)
(assert
 (= (proj%%core!ops.arith.Neg./Output (REF $) (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Neg./Output (REF $) (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Neg./Output $ (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Neg./Output $ (SINT 32)) (SINT 32))
)
(assert
 (forall ((T&. Dcr) (T& Type) (I&. Dcr) (I& Type) (N&. Dcr) (N& Type)) (!
   (= (proj%%core!ops.index.Index./Output $ (ARRAY T&. T& N&. N&) I&. I&) (proj%%core!ops.index.Index./Output
     $slice (SLICE T&. T&) I&. I&
   ))
   :pattern ((proj%%core!ops.index.Index./Output $ (ARRAY T&. T& N&. N&) I&. I&))
   :qid internal_proj____core!ops.index.Index./Output_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____core!ops.index.Index./Output_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (I&. Dcr) (I& Type) (N&. Dcr) (N& Type)) (!
   (= (proj%core!ops.index.Index./Output $ (ARRAY T&. T& N&. N&) I&. I&) (proj%core!ops.index.Index./Output
     $slice (SLICE T&. T&) I&. I&
   ))
   :pattern ((proj%core!ops.index.Index./Output $ (ARRAY T&. T& N&. N&) I&. I&))
   :qid internal_proj__core!ops.index.Index./Output_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__core!ops.index.Index./Output_assoc_type_impl_false_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (I&. Dcr) (I& Type)) (!
   (= (proj%%core!ops.index.Index./Output $slice (SLICE T&. T&) I&. I&) (proj%%core!slice.index.SliceIndex./Output
     I&. I& $slice (SLICE T&. T&)
   ))
   :pattern ((proj%%core!ops.index.Index./Output $slice (SLICE T&. T&) I&. I&))
   :qid internal_proj____core!ops.index.Index./Output_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____core!ops.index.Index./Output_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (I&. Dcr) (I& Type)) (!
   (= (proj%core!ops.index.Index./Output $slice (SLICE T&. T&) I&. I&) (proj%core!slice.index.SliceIndex./Output
     I&. I& $slice (SLICE T&. T&)
   ))
   :pattern ((proj%core!ops.index.Index./Output $slice (SLICE T&. T&) I&. I&))
   :qid internal_proj__core!ops.index.Index./Output_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__core!ops.index.Index./Output_assoc_type_impl_false_definition
)))
(assert
 (forall ((I&. Dcr) (I& Type)) (!
   (= (proj%%core!ops.index.Index./Output $slice STRSLICE I&. I&) (proj%%core!slice.index.SliceIndex./Output
     I&. I& $slice STRSLICE
   ))
   :pattern ((proj%%core!ops.index.Index./Output $slice STRSLICE I&. I&))
   :qid internal_proj____core!ops.index.Index./Output_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____core!ops.index.Index./Output_assoc_type_impl_true_definition
)))
(assert
 (forall ((I&. Dcr) (I& Type)) (!
   (= (proj%core!ops.index.Index./Output $slice STRSLICE I&. I&) (proj%core!slice.index.SliceIndex./Output
     I&. I& $slice STRSLICE
   ))
   :pattern ((proj%core!ops.index.Index./Output $slice STRSLICE I&. I&))
   :qid internal_proj__core!ops.index.Index./Output_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__core!ops.index.Index./Output_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%core!iter.traits.iterator.Iterator./Item $ (TYPE%core!ops.range.Range. A&.
      A&
     )
    ) A&.
   )
   :pattern ((proj%%core!iter.traits.iterator.Iterator./Item $ (TYPE%core!ops.range.Range.
      A&. A&
   )))
   :qid internal_proj____core!iter.traits.iterator.Iterator./Item_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____core!iter.traits.iterator.Iterator./Item_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%core!iter.traits.iterator.Iterator./Item $ (TYPE%core!ops.range.Range. A&.
      A&
     )
    ) A&
   )
   :pattern ((proj%core!iter.traits.iterator.Iterator./Item $ (TYPE%core!ops.range.Range.
      A&. A&
   )))
   :qid internal_proj__core!iter.traits.iterator.Iterator./Item_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__core!iter.traits.iterator.Iterator./Item_assoc_type_impl_false_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%%core!slice.index.SliceIndex./Output $ USIZE $slice (SLICE T&. T&)) T&.)
   :pattern ((proj%%core!slice.index.SliceIndex./Output $ USIZE $slice (SLICE T&. T&)))
   :qid internal_proj____core!slice.index.SliceIndex./Output_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____core!slice.index.SliceIndex./Output_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%core!slice.index.SliceIndex./Output $ USIZE $slice (SLICE T&. T&)) T&)
   :pattern ((proj%core!slice.index.SliceIndex./Output $ USIZE $slice (SLICE T&. T&)))
   :qid internal_proj__core!slice.index.SliceIndex./Output_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__core!slice.index.SliceIndex./Output_assoc_type_impl_false_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%%core!slice.index.SliceIndex./Output $ (TYPE%core!ops.range.Range. $ USIZE)
     $slice (SLICE T&. T&)
    ) $slice
   )
   :pattern ((proj%%core!slice.index.SliceIndex./Output $ (TYPE%core!ops.range.Range. $
      USIZE
     ) $slice (SLICE T&. T&)
   ))
   :qid internal_proj____core!slice.index.SliceIndex./Output_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____core!slice.index.SliceIndex./Output_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%core!slice.index.SliceIndex./Output $ (TYPE%core!ops.range.Range. $ USIZE)
     $slice (SLICE T&. T&)
    ) (SLICE T&. T&)
   )
   :pattern ((proj%core!slice.index.SliceIndex./Output $ (TYPE%core!ops.range.Range. $
      USIZE
     ) $slice (SLICE T&. T&)
   ))
   :qid internal_proj__core!slice.index.SliceIndex./Output_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__core!slice.index.SliceIndex./Output_assoc_type_impl_false_definition
)))
(assert
 (= (proj%%core!slice.index.SliceIndex./Output $ (TYPE%core!ops.range.Range. $ USIZE)
   $slice STRSLICE
  ) $slice
))
(assert
 (= (proj%core!slice.index.SliceIndex./Output $ (TYPE%core!ops.range.Range. $ USIZE)
   $slice STRSLICE
  ) STRSLICE
))
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  ) $
))
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  ) $
))
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))
(assert
 (= (proj%%core!ops.arith.Mul./Output (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  ) $
))
(assert
 (= (proj%core!ops.arith.Mul./Output (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))
(assert
 (= (proj%%core!ops.arith.Neg./Output (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
  $
))
(assert
 (= (proj%core!ops.arith.Neg./Output (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
  TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Function-Decl vstd::seq::Seq::len
(declare-fun vstd!seq.Seq.len.? (Dcr Type Poly) Int)

;; Function-Decl vstd::seq::Seq::index
(declare-fun vstd!seq.Seq.index.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::impl&%0::spec_index
(declare-fun vstd!seq.impl&%0.spec_index.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::Seq::empty
(declare-fun vstd!seq.Seq.empty.? (Dcr Type) Poly)

;; Function-Decl vstd::seq::Seq::new
(declare-fun vstd!seq.Seq.new.? (Dcr Type Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::Seq::push
(declare-fun vstd!seq.Seq.push.? (Dcr Type Poly Poly) Poly)

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

;; Function-Decl vstd::array::spec_array_fill_for_copy_type
(declare-fun vstd!array.spec_array_fill_for_copy_type.? (Dcr Type Dcr Type Poly) %%Function%%)

;; Function-Decl vstd::raw_ptr::view_reverse_for_eq
(declare-fun vstd!raw_ptr.view_reverse_for_eq.? (Dcr Type Poly) Poly)

;; Function-Decl vstd::raw_ptr::view_reverse_for_eq_sized
(declare-fun vstd!raw_ptr.view_reverse_for_eq_sized.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::std_specs::range::StepSpec::spec_is_lt
(declare-fun vstd!std_specs.range.StepSpec.spec_is_lt.? (Dcr Type Poly Poly) Poly)
(declare-fun vstd!std_specs.range.StepSpec.spec_is_lt%default%.? (Dcr Type Poly Poly)
 Poly
)

;; Function-Decl vstd::std_specs::range::StepSpec::spec_steps_between_int
(declare-fun vstd!std_specs.range.StepSpec.spec_steps_between_int.? (Dcr Type Poly
  Poly
 ) Poly
)
(declare-fun vstd!std_specs.range.StepSpec.spec_steps_between_int%default%.? (Dcr Type
  Poly Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::range::StepSpec::spec_forward_checked
(declare-fun vstd!std_specs.range.StepSpec.spec_forward_checked.? (Dcr Type Poly Poly)
 Poly
)
(declare-fun vstd!std_specs.range.StepSpec.spec_forward_checked%default%.? (Dcr Type
  Poly Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::range::StepSpec::spec_forward_checked_int
(declare-fun vstd!std_specs.range.StepSpec.spec_forward_checked_int.? (Dcr Type Poly
  Poly
 ) Poly
)
(declare-fun vstd!std_specs.range.StepSpec.spec_forward_checked_int%default%.? (Dcr
  Type Poly Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::range::spec_range_next
(declare-fun vstd!std_specs.range.spec_range_next.? (Dcr Type Poly) tuple%2.)

;; Function-Decl vstd::std_specs::core::IndexSetTrustedSpec::spec_index_set_requires
(declare-fun vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.? (Dcr
  Type Dcr Type Poly Poly
 ) Poly
)
(declare-fun vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires%default%.?
 (Dcr Type Dcr Type Poly Poly) Poly
)

;; Function-Decl vstd::std_specs::core::IndexSetTrustedSpec::spec_index_set_ensures
(declare-fun vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.? (Dcr
  Type Dcr Type Poly Poly Poly Poly
 ) Poly
)
(declare-fun vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures%default%.?
 (Dcr Type Dcr Type Poly Poly Poly Poly) Poly
)

;; Function-Decl vstd::arithmetic::power::pow
(declare-fun vstd!arithmetic.power.pow.? (Poly Poly) Int)

;; Function-Decl vstd::arithmetic::power2::pow2
(declare-fun vstd!arithmetic.power2.pow2.? (Poly) Int)

;; Function-Decl vstd::pervasive::strictly_cloned
(declare-fun vstd!pervasive.strictly_cloned.? (Dcr Type Poly Poly) Bool)

;; Function-Decl vstd::pervasive::cloned
(declare-fun vstd!pervasive.cloned.? (Dcr Type Poly Poly) Bool)

;; Function-Decl vstd::std_specs::ops::NegSpec::neg_req
(declare-fun vstd!std_specs.ops.NegSpec.neg_req.? (Dcr Type Poly) Poly)
(declare-fun vstd!std_specs.ops.NegSpec.neg_req%default%.? (Dcr Type Poly) Poly)

;; Function-Decl vstd::std_specs::ops::NegSpec::obeys_neg_spec
(declare-fun vstd!std_specs.ops.NegSpec.obeys_neg_spec.? (Dcr Type) Poly)
(declare-fun vstd!std_specs.ops.NegSpec.obeys_neg_spec%default%.? (Dcr Type) Poly)

;; Function-Decl vstd::std_specs::ops::NegSpec::neg_spec
(declare-fun vstd!std_specs.ops.NegSpec.neg_spec.? (Dcr Type Poly) Poly)
(declare-fun vstd!std_specs.ops.NegSpec.neg_spec%default%.? (Dcr Type Poly) Poly)

;; Function-Decl vstd::std_specs::ops::AddSpec::add_req
(declare-fun vstd!std_specs.ops.AddSpec.add_req.? (Dcr Type Dcr Type Poly Poly) Poly)
(declare-fun vstd!std_specs.ops.AddSpec.add_req%default%.? (Dcr Type Dcr Type Poly
  Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::ops::AddSpec::obeys_add_spec
(declare-fun vstd!std_specs.ops.AddSpec.obeys_add_spec.? (Dcr Type Dcr Type) Poly)
(declare-fun vstd!std_specs.ops.AddSpec.obeys_add_spec%default%.? (Dcr Type Dcr Type)
 Poly
)

;; Function-Decl vstd::std_specs::ops::AddSpec::add_spec
(declare-fun vstd!std_specs.ops.AddSpec.add_spec.? (Dcr Type Dcr Type Poly Poly) Poly)
(declare-fun vstd!std_specs.ops.AddSpec.add_spec%default%.? (Dcr Type Dcr Type Poly
  Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::ops::SubSpec::sub_req
(declare-fun vstd!std_specs.ops.SubSpec.sub_req.? (Dcr Type Dcr Type Poly Poly) Poly)
(declare-fun vstd!std_specs.ops.SubSpec.sub_req%default%.? (Dcr Type Dcr Type Poly
  Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::ops::SubSpec::obeys_sub_spec
(declare-fun vstd!std_specs.ops.SubSpec.obeys_sub_spec.? (Dcr Type Dcr Type) Poly)
(declare-fun vstd!std_specs.ops.SubSpec.obeys_sub_spec%default%.? (Dcr Type Dcr Type)
 Poly
)

;; Function-Decl vstd::std_specs::ops::SubSpec::sub_spec
(declare-fun vstd!std_specs.ops.SubSpec.sub_spec.? (Dcr Type Dcr Type Poly Poly) Poly)
(declare-fun vstd!std_specs.ops.SubSpec.sub_spec%default%.? (Dcr Type Dcr Type Poly
  Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::ops::MulSpec::mul_req
(declare-fun vstd!std_specs.ops.MulSpec.mul_req.? (Dcr Type Dcr Type Poly Poly) Poly)
(declare-fun vstd!std_specs.ops.MulSpec.mul_req%default%.? (Dcr Type Dcr Type Poly
  Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::ops::MulSpec::obeys_mul_spec
(declare-fun vstd!std_specs.ops.MulSpec.obeys_mul_spec.? (Dcr Type Dcr Type) Poly)
(declare-fun vstd!std_specs.ops.MulSpec.obeys_mul_spec%default%.? (Dcr Type Dcr Type)
 Poly
)

;; Function-Decl vstd::std_specs::ops::MulSpec::mul_spec
(declare-fun vstd!std_specs.ops.MulSpec.mul_spec.? (Dcr Type Dcr Type Poly Poly) Poly)
(declare-fun vstd!std_specs.ops.MulSpec.mul_spec%default%.? (Dcr Type Dcr Type Poly
  Poly
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

;; Function-Decl vstd::std_specs::option::is_some
(declare-fun vstd!std_specs.option.is_some.? (Dcr Type Poly) Bool)

;; Function-Decl vstd::std_specs::option::is_none
(declare-fun vstd!std_specs.option.is_none.? (Dcr Type Poly) Bool)

;; Function-Decl vstd::std_specs::option::spec_unwrap
(declare-fun vstd!std_specs.option.spec_unwrap.? (Dcr Type Poly) Poly)

;; Function-Decl vstd::std_specs::option::spec_unwrap_or
(declare-fun vstd!std_specs.option.spec_unwrap_or.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::pervasive::ForLoopGhostIterator::exec_invariant
(declare-fun vstd!pervasive.ForLoopGhostIterator.exec_invariant.? (Dcr Type Poly Poly)
 Poly
)
(declare-fun vstd!pervasive.ForLoopGhostIterator.exec_invariant%default%.? (Dcr Type
  Poly Poly
 ) Poly
)

;; Function-Decl vstd::pervasive::ForLoopGhostIterator::ghost_invariant
(declare-fun vstd!pervasive.ForLoopGhostIterator.ghost_invariant.? (Dcr Type Poly Poly)
 Poly
)
(declare-fun vstd!pervasive.ForLoopGhostIterator.ghost_invariant%default%.? (Dcr Type
  Poly Poly
 ) Poly
)

;; Function-Decl vstd::pervasive::ForLoopGhostIterator::ghost_ensures
(declare-fun vstd!pervasive.ForLoopGhostIterator.ghost_ensures.? (Dcr Type Poly) Poly)
(declare-fun vstd!pervasive.ForLoopGhostIterator.ghost_ensures%default%.? (Dcr Type
  Poly
 ) Poly
)

;; Function-Decl vstd::pervasive::ForLoopGhostIterator::ghost_decrease
(declare-fun vstd!pervasive.ForLoopGhostIterator.ghost_decrease.? (Dcr Type Poly)
 Poly
)
(declare-fun vstd!pervasive.ForLoopGhostIterator.ghost_decrease%default%.? (Dcr Type
  Poly
 ) Poly
)

;; Function-Decl vstd::pervasive::ForLoopGhostIterator::ghost_peek_next
(declare-fun vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.? (Dcr Type Poly)
 Poly
)
(declare-fun vstd!pervasive.ForLoopGhostIterator.ghost_peek_next%default%.? (Dcr Type
  Poly
 ) Poly
)

;; Function-Decl vstd::pervasive::ForLoopGhostIterator::ghost_advance
(declare-fun vstd!pervasive.ForLoopGhostIterator.ghost_advance.? (Dcr Type Poly Poly)
 Poly
)
(declare-fun vstd!pervasive.ForLoopGhostIterator.ghost_advance%default%.? (Dcr Type
  Poly Poly
 ) Poly
)

;; Function-Decl vstd::pervasive::ForLoopGhostIteratorNew::ghost_iter
(declare-fun vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter.? (Dcr Type Poly) Poly)
(declare-fun vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter%default%.? (Dcr Type
  Poly
 ) Poly
)

;; Function-Decl vstd::pervasive::arbitrary
(declare-fun vstd!pervasive.arbitrary.? (Dcr Type) Poly)

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

;; Function-Decl curve25519_dalek::specs::field_specs::field_mul
(declare-fun curve25519_dalek!specs.field_specs.field_mul.? (Poly Poly) Int)

;; Function-Decl curve25519_dalek::backend::serial::u64::subtle_assumes::choice_is_true
(declare-fun curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (
  Poly
 ) Bool
)

;; Function-Decl curve25519_dalek::specs::field_specs::u64_5_bounded
(declare-fun curve25519_dalek!specs.field_specs.u64_5_bounded.? (Poly Poly) Bool)

;; Function-Decl curve25519_dalek::specs::field_specs::fe51_limbs_bounded
(declare-fun curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly Poly) Bool)

;; Function-Decl curve25519_dalek::specs::field_specs::field_neg
(declare-fun curve25519_dalek!specs.field_specs.field_neg.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::mask51
(declare-fun curve25519_dalek!specs.field_specs_u64.mask51.? () Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::spec_reduce
(declare-fun curve25519_dalek!specs.field_specs_u64.spec_reduce.? (Poly) %%Function%%)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::sixteen_p_vec
(declare-fun curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.? () %%Function%%)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::pre_reduce_limbs
(declare-fun curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.? (Poly) %%Function%%)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::spec_negate
(declare-fun curve25519_dalek!specs.field_specs_u64.spec_negate.? (Poly) %%Function%%)

;; Function-Decl curve25519_dalek::specs::proba_specs::is_uniform_bytes
(declare-fun curve25519_dalek!specs.proba_specs.is_uniform_bytes.? (Poly) Bool)

;; Function-Decl curve25519_dalek::specs::proba_specs::is_uniform_field_element
(declare-fun curve25519_dalek!specs.proba_specs.is_uniform_field_element.? (Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::core_specs::u8_32_as_nat
(declare-fun curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::field_sub
(declare-fun curve25519_dalek!specs.field_specs.field_sub.? (Poly Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::field_add
(declare-fun curve25519_dalek!specs.field_specs.field_add.? (Poly Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::sum_of_limbs_bounded
(declare-fun curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? (Poly Poly Poly)
 Bool
)

;; Function-Decl vstd::std_specs::core::iter_into_iter_spec
(declare-fun vstd!std_specs.core.iter_into_iter_spec.? (Dcr Type Poly) Poly)

;; Function-Decl curve25519_dalek::backend::serial::u64::field::LOW_51_BIT_MASK
(declare-fun curve25519_dalek!backend.serial.u64.field.LOW_51_BIT_MASK.? () Int)

;; Function-Decl curve25519_dalek::specs::field_specs::spec_add_fe51_limbs
(declare-fun curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.? (Poly Poly)
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)

;; Function-Decl curve25519_dalek::specs::field_specs::spec_sub_limbs
(declare-fun curve25519_dalek!specs.field_specs.spec_sub_limbs.? (Poly Poly) curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::backend::serial::u64::field::impl&%16::ZERO
(declare-fun curve25519_dalek!backend.serial.u64.field.impl&%16.ZERO.? () curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::backend::serial::u64::field::impl&%16::ONE
(declare-fun curve25519_dalek!backend.serial.u64.field.impl&%16.ONE.? () curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::backend::serial::u64::field::impl&%16::MINUS_ONE
(declare-fun curve25519_dalek!backend.serial.u64.field.impl&%16.MINUS_ONE.? () curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::negate_lemmas::all_neg_limbs_positive
(declare-fun curve25519_dalek!lemmas.field_lemmas.negate_lemmas.all_neg_limbs_positive.?
 (Poly) Bool
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c0_0_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_0_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c1_0_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_0_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c2_0_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_0_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c3_0_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_0_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c4_0_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_0_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c0_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c1_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c2_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c3_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c4_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::carry_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.carry_val.? (Poly)
 Int
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::a0_0_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_0_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::a1_0_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_0_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::a2_0_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a2_0_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::a3_0_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a3_0_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::a4_0_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a4_0_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::a0_1_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_1_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::a1_1_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_1_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::a0_2_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_2_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::term_product_bounds_spec
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.term_product_bounds_spec.?
 (Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::ci_0_val_boundaries
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_0_val_boundaries.?
 (Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::ci_val_boundaries
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_val_boundaries.?
 (Poly) Bool
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::ai_val_boundaries
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ai_val_boundaries.?
 (Poly) Bool
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::pow2k_loop_return
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.?
 (Poly) %%Function%%
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::pow2k_loop_boundary_spec
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_boundary_spec.?
 (Poly) Bool
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::mul_lemmas::mul_c0_0_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c0_0_val.? (Poly Poly)
 Int
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::mul_lemmas::mul_c1_0_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c1_0_val.? (Poly Poly)
 Int
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::mul_lemmas::mul_c2_0_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c2_0_val.? (Poly Poly)
 Int
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::mul_lemmas::mul_c3_0_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c3_0_val.? (Poly Poly)
 Int
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::mul_lemmas::mul_c4_0_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c4_0_val.? (Poly Poly)
 Int
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::mul_lemmas::mul_c0_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c0_val.? (Poly Poly)
 Int
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::mul_lemmas::mul_c1_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c1_val.? (Poly Poly)
 Int
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::mul_lemmas::mul_c2_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c2_val.? (Poly Poly)
 Int
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::mul_lemmas::mul_c3_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c3_val.? (Poly Poly)
 Int
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::mul_lemmas::mul_c4_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c4_val.? (Poly Poly)
 Int
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::mul_lemmas::mul_return
(declare-fun curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_return.? (Poly Poly)
 %%Function%%
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::mul_lemmas::mul_term_product_bounds_spec
(declare-fun curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_term_product_bounds_spec.?
 (Poly Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::mul_lemmas::mul_ci_0_val_boundaries
(declare-fun curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_ci_0_val_boundaries.?
 (Poly Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::mul_lemmas::mul_ci_val_boundaries
(declare-fun curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_ci_val_boundaries.?
 (Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::mul_lemmas::mul_out_val_boundaries
(declare-fun curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_out_val_boundaries.?
 (Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::mul_lemmas::mul_boundary_spec
(declare-fun curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_boundary_spec.? (
  Poly Poly
 ) Bool
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::load8_lemmas::load8_at_or_version_rec
(declare-fun curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_or_version_rec.?
 (Poly Poly Poly) Int
)
(declare-fun curve25519_dalek!lemmas.field_lemmas.load8_lemmas.rec%load8_at_or_version_rec.?
 (Poly Poly Poly Fuel) Int
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::load8_lemmas::load8_at_plus_version_rec
(declare-fun curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_plus_version_rec.?
 (Poly Poly Poly) Int
)
(declare-fun curve25519_dalek!lemmas.field_lemmas.load8_lemmas.rec%load8_at_plus_version_rec.?
 (Poly Poly Poly Fuel) Int
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::limbs_to_bytes_lemmas::bytes_match_limbs_packing
(declare-fun curve25519_dalek!lemmas.field_lemmas.limbs_to_bytes_lemmas.bytes_match_limbs_packing.?
 (Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::core_specs::spec_load8_at
(declare-fun curve25519_dalek!specs.core_specs.spec_load8_at.? (Poly Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::fe51_as_nat
(declare-fun curve25519_dalek!specs.field_specs.fe51_as_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::compute_q_arr
(declare-fun curve25519_dalek!specs.field_specs_u64.compute_q_arr.? (Poly) %%Function%%)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::compute_q_spec
(declare-fun curve25519_dalek!specs.field_specs_u64.compute_q_spec.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::compute_unmasked_limbs
(declare-fun curve25519_dalek!specs.field_specs_u64.compute_unmasked_limbs.? (Poly
  Poly
 ) %%Function%%
)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::reduce_with_q_spec
(declare-fun curve25519_dalek!specs.field_specs_u64.reduce_with_q_spec.? (Poly Poly)
 %%Function%%
)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::bit_arrange
(declare-fun curve25519_dalek!specs.field_specs_u64.bit_arrange.? (Poly) %%Function%%)

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
    :qid user_vstd__seq__axiom_seq_empty_1
    :skolemid skolem_user_vstd__seq__axiom_seq_empty_1
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
    :qid user_vstd__seq__axiom_seq_new_len_2
    :skolemid skolem_user_vstd__seq__axiom_seq_new_len_2
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
    :qid user_vstd__seq__axiom_seq_new_index_3
    :skolemid skolem_user_vstd__seq__axiom_seq_new_index_3
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
    :qid user_vstd__seq__axiom_seq_push_len_4
    :skolemid skolem_user_vstd__seq__axiom_seq_push_len_4
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
    :qid user_vstd__seq__axiom_seq_push_index_same_5
    :skolemid skolem_user_vstd__seq__axiom_seq_push_index_same_5
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
    :qid user_vstd__seq__axiom_seq_push_index_different_6
    :skolemid skolem_user_vstd__seq__axiom_seq_push_index_different_6
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
    :qid user_vstd__seq__axiom_seq_update_len_7
    :skolemid skolem_user_vstd__seq__axiom_seq_update_len_7
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
    :qid user_vstd__seq__axiom_seq_update_same_8
    :skolemid skolem_user_vstd__seq__axiom_seq_update_same_8
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
    :qid user_vstd__seq__axiom_seq_update_different_9
    :skolemid skolem_user_vstd__seq__axiom_seq_update_different_9
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
          :qid user_vstd__seq__axiom_seq_ext_equal_10
          :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_10
    ))))))
    :pattern ((ext_eq false (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_11
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_11
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
          :qid user_vstd__seq__axiom_seq_ext_equal_deep_12
          :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_12
    ))))))
    :pattern ((ext_eq true (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_deep_13
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_13
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
    :qid user_vstd__slice__axiom_spec_len_14
    :skolemid skolem_user_vstd__slice__axiom_spec_len_14
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
          :qid user_vstd__slice__axiom_slice_ext_equal_15
          :skolemid skolem_user_vstd__slice__axiom_slice_ext_equal_15
    ))))))
    :pattern ((ext_eq false (SLICE T&. T&) a1! a2!))
    :qid user_vstd__slice__axiom_slice_ext_equal_16
    :skolemid skolem_user_vstd__slice__axiom_slice_ext_equal_16
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
    :qid user_vstd__slice__axiom_slice_has_resolved_17
    :skolemid skolem_user_vstd__slice__axiom_slice_has_resolved_17
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
    :qid user_vstd__array__array_len_matches_n_18
    :skolemid skolem_user_vstd__array__array_len_matches_n_18
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
    :qid user_vstd__array__lemma_array_index_19
    :skolemid skolem_user_vstd__array__lemma_array_index_19
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
    :qid user_vstd__array__axiom_spec_array_as_slice_20
    :skolemid skolem_user_vstd__array__axiom_spec_array_as_slice_20
))))

;; Function-Axioms vstd::array::spec_array_fill_for_copy_type
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (t! Poly)) (!
   (=>
    (has_type t! T&)
    (has_type (Poly%array%. (vstd!array.spec_array_fill_for_copy_type.? T&. T& N&. N& t!))
     (ARRAY T&. T& N&. N&)
   ))
   :pattern ((vstd!array.spec_array_fill_for_copy_type.? T&. T& N&. N& t!))
   :qid internal_vstd!array.spec_array_fill_for_copy_type.?_pre_post_definition
   :skolemid skolem_internal_vstd!array.spec_array_fill_for_copy_type.?_pre_post_definition
)))

;; Broadcast vstd::array::axiom_spec_array_fill_for_copy_type
(assert
 (=>
  (fuel_bool fuel%vstd!array.axiom_spec_array_fill_for_copy_type.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (t! Poly)) (!
    (=>
     (has_type t! T&)
     (=>
      (and
       (sized T&.)
       (uInv SZ (const_int N&))
      )
      (forall ((i$ Poly)) (!
        (=>
         (has_type i$ INT)
         (=>
          (let
           ((tmp%%$ (%I i$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ (const_int N&))
          ))
          (= (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) (Poly%array%.
              (vstd!array.spec_array_fill_for_copy_type.? T&. T& N&. N& t!)
             )
            ) i$
           ) t!
        )))
        :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
           (Poly%array%. (vstd!array.spec_array_fill_for_copy_type.? T&. T& N&. N& t!))
          ) i$
        ))
        :qid user_vstd__array__axiom_spec_array_fill_for_copy_type_21
        :skolemid skolem_user_vstd__array__axiom_spec_array_fill_for_copy_type_21
    ))))
    :pattern ((vstd!array.spec_array_fill_for_copy_type.? T&. T& N&. N& t!))
    :qid user_vstd__array__axiom_spec_array_fill_for_copy_type_22
    :skolemid skolem_user_vstd__array__axiom_spec_array_fill_for_copy_type_22
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
         :qid user_vstd__array__axiom_array_ext_equal_23
         :skolemid skolem_user_vstd__array__axiom_array_ext_equal_23
    )))))
    :pattern ((ext_eq false (ARRAY T&. T& N&. N&) a1! a2!))
    :qid user_vstd__array__axiom_array_ext_equal_24
    :skolemid skolem_user_vstd__array__axiom_array_ext_equal_24
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
    :qid user_vstd__array__axiom_array_has_resolved_25
    :skolemid skolem_user_vstd__array__axiom_array_has_resolved_25
))))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $slice STRSLICE)
)

;; Broadcast vstd::string::axiom_str_literal_len
(assert
 (=>
  (fuel_bool fuel%vstd!string.axiom_str_literal_len.)
  (forall ((s! Poly)) (!
    (=>
     (has_type s! STRSLICE)
     (= (vstd!seq.Seq.len.? $ CHAR (vstd!view.View.view.? $slice STRSLICE s!)) (str%strslice_len
       (%Poly%strslice%. s!)
    )))
    :pattern ((vstd!seq.Seq.len.? $ CHAR (vstd!view.View.view.? $slice STRSLICE s!)))
    :qid user_vstd__string__axiom_str_literal_len_26
    :skolemid skolem_user_vstd__string__axiom_str_literal_len_26
))))

;; Broadcast vstd::string::axiom_str_literal_get_char
(assert
 (=>
  (fuel_bool fuel%vstd!string.axiom_str_literal_get_char.)
  (forall ((s! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type s! STRSLICE)
      (has_type i! INT)
     )
     (= (%I (vstd!seq.Seq.index.? $ CHAR (vstd!view.View.view.? $slice STRSLICE s!) i!))
      (str%strslice_get_char (%Poly%strslice%. s!) (%I i!))
    ))
    :pattern ((vstd!seq.Seq.index.? $ CHAR (vstd!view.View.view.? $slice STRSLICE s!) i!))
    :qid user_vstd__string__axiom_str_literal_get_char_27
    :skolemid skolem_user_vstd__string__axiom_str_literal_get_char_27
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
    :qid user_vstd__raw_ptr__ptrs_mut_eq_28
    :skolemid skolem_user_vstd__raw_ptr__ptrs_mut_eq_28
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
    :qid user_vstd__raw_ptr__ptrs_mut_eq_sized_29
    :skolemid skolem_user_vstd__raw_ptr__ptrs_mut_eq_sized_29
))))

;; Function-Axioms vstd::std_specs::range::StepSpec::spec_is_lt
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly) (other! Poly)) (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type other! Self%&)
    )
    (has_type (vstd!std_specs.range.StepSpec.spec_is_lt.? Self%&. Self%& self! other!)
     BOOL
   ))
   :pattern ((vstd!std_specs.range.StepSpec.spec_is_lt.? Self%&. Self%& self! other!))
   :qid internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::range::StepSpec::spec_steps_between_int
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly) (end! Poly)) (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type end! Self%&)
    )
    (has_type (vstd!std_specs.range.StepSpec.spec_steps_between_int.? Self%&. Self%& self!
      end!
     ) INT
   ))
   :pattern ((vstd!std_specs.range.StepSpec.spec_steps_between_int.? Self%&. Self%& self!
     end!
   ))
   :qid internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::range::StepSpec::spec_forward_checked
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly) (count! Poly)) (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type count! USIZE)
    )
    (has_type (vstd!std_specs.range.StepSpec.spec_forward_checked.? Self%&. Self%& self!
      count!
     ) (TYPE%core!option.Option. Self%&. Self%&)
   ))
   :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked.? Self%&. Self%& self!
     count!
   ))
   :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::range::StepSpec::spec_forward_checked_int
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly) (count! Poly)) (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type count! INT)
    )
    (has_type (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? Self%&. Self%&
      self! count!
     ) (TYPE%core!option.Option. Self%&. Self%&)
   ))
   :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked_int.? Self%&. Self%&
     self! count!
   ))
   :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::range::impl&%6::spec_is_lt
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%6.spec_is_lt.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%6.spec_is_lt.)
  (forall ((self! Poly) (other! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 8) self! other!) (B (< (%I self!)
       (%I other!)
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 8) self! other!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%6::spec_forward_checked_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%6.spec_forward_checked_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%6.spec_forward_checked_int.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 8) self! count!)
     (Poly%core!option.Option. (ite
       (<= (Add (%I self!) (%I count!)) 255)
       (core!option.Option./Some (I (uClip 8 (Add (%I self!) (%I count!)))))
       core!option.Option./None
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 8) self!
      count!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%6::spec_forward_checked
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%6.spec_forward_checked.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%6.spec_forward_checked.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (UINT 8) self! count!)
     (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 8) self! count!)
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (UINT 8) self! count!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
))))

;; Function-Axioms vstd::std_specs::range::spec_range_next
(assert
 (forall ((A&. Dcr) (A& Type) (a! Poly)) (!
   (=>
    (has_type a! (TYPE%core!ops.range.Range. A&. A&))
    (has_type (Poly%tuple%2. (vstd!std_specs.range.spec_range_next.? A&. A& a!)) (TYPE%tuple%2.
      $ (TYPE%core!ops.range.Range. A&. A&) $ (TYPE%core!option.Option. A&. A&)
   )))
   :pattern ((vstd!std_specs.range.spec_range_next.? A&. A& a!))
   :qid internal_vstd!std_specs.range.spec_range_next.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.range.spec_range_next.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::range::impl&%6::spec_steps_between_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%6.spec_steps_between_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%6.spec_steps_between_int.)
  (forall ((self! Poly) (end! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (UINT 8) self! end!)
     (I (Sub (%I end!) (%I self!)))
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (UINT 8) self!
      end!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.range.StepSpec. $ (UINT 8))
)

;; Broadcast vstd::std_specs::range::axiom_spec_range_next_u8
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.axiom_spec_range_next_u8.)
  (forall ((range! Poly)) (!
    (=>
     (has_type range! (TYPE%core!ops.range.Range. $ (UINT 8)))
     (and
      (=>
       (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 8) (core!ops.range.Range./Range/start
          (%Poly%core!ops.range.Range. range!)
         ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       ))
       (let
        ((tmp%%$ (%Poly%core!option.Option. (vstd!std_specs.range.StepSpec.spec_forward_checked.?
            $ (UINT 8) (core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. range!))
            (I 1)
        ))))
        (=>
         (is-core!option.Option./Some tmp%%$)
         (let
          ((n$ (%I (core!option.Option./Some/0 $ (UINT 8) (%Poly%core!option.Option. (Poly%core!option.Option.
                tmp%%$
          ))))))
          (= (vstd!std_specs.range.spec_range_next.? $ (UINT 8) range!) (tuple%2./tuple%2 (Poly%core!ops.range.Range.
             (core!ops.range.Range./Range (I n$) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range.
                range!
             )))
            ) (Poly%core!option.Option. (core!option.Option./Some (core!ops.range.Range./Range/start
               (%Poly%core!ops.range.Range. range!)
      )))))))))
      (=>
       (not (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 8) (core!ops.range.Range./Range/start
           (%Poly%core!ops.range.Range. range!)
          ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       )))
       (= (vstd!std_specs.range.spec_range_next.? $ (UINT 8) range!) (tuple%2./tuple%2 range!
         (Poly%core!option.Option. core!option.Option./None)
    )))))
    :pattern ((vstd!std_specs.range.spec_range_next.? $ (UINT 8) range!))
    :qid user_vstd__std_specs__range__axiom_spec_range_next_u8_30
    :skolemid skolem_user_vstd__std_specs__range__axiom_spec_range_next_u8_30
))))

;; Function-Axioms vstd::std_specs::range::impl&%8::spec_is_lt
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%8.spec_is_lt.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%8.spec_is_lt.)
  (forall ((self! Poly) (other! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 32) self! other!) (B (< (%I self!)
       (%I other!)
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 32) self! other!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%8::spec_forward_checked_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%8.spec_forward_checked_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%8.spec_forward_checked_int.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 32) self! count!)
     (Poly%core!option.Option. (ite
       (<= (Add (%I self!) (%I count!)) 4294967295)
       (core!option.Option./Some (I (uClip 32 (Add (%I self!) (%I count!)))))
       core!option.Option./None
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 32) self!
      count!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%8::spec_forward_checked
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%8.spec_forward_checked.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%8.spec_forward_checked.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (UINT 32) self! count!)
     (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 32) self! count!)
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (UINT 32) self! count!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%8::spec_steps_between_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%8.spec_steps_between_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%8.spec_steps_between_int.)
  (forall ((self! Poly) (end! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (UINT 32) self! end!)
     (I (Sub (%I end!) (%I self!)))
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (UINT 32) self!
      end!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.range.StepSpec. $ (UINT 32))
)

;; Broadcast vstd::std_specs::range::axiom_spec_range_next_u32
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.axiom_spec_range_next_u32.)
  (forall ((range! Poly)) (!
    (=>
     (has_type range! (TYPE%core!ops.range.Range. $ (UINT 32)))
     (and
      (=>
       (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 32) (core!ops.range.Range./Range/start
          (%Poly%core!ops.range.Range. range!)
         ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       ))
       (let
        ((tmp%%$ (%Poly%core!option.Option. (vstd!std_specs.range.StepSpec.spec_forward_checked.?
            $ (UINT 32) (core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. range!))
            (I 1)
        ))))
        (=>
         (is-core!option.Option./Some tmp%%$)
         (let
          ((n$ (%I (core!option.Option./Some/0 $ (UINT 32) (%Poly%core!option.Option. (Poly%core!option.Option.
                tmp%%$
          ))))))
          (= (vstd!std_specs.range.spec_range_next.? $ (UINT 32) range!) (tuple%2./tuple%2 (Poly%core!ops.range.Range.
             (core!ops.range.Range./Range (I n$) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range.
                range!
             )))
            ) (Poly%core!option.Option. (core!option.Option./Some (core!ops.range.Range./Range/start
               (%Poly%core!ops.range.Range. range!)
      )))))))))
      (=>
       (not (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 32) (core!ops.range.Range./Range/start
           (%Poly%core!ops.range.Range. range!)
          ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       )))
       (= (vstd!std_specs.range.spec_range_next.? $ (UINT 32) range!) (tuple%2./tuple%2 range!
         (Poly%core!option.Option. core!option.Option./None)
    )))))
    :pattern ((vstd!std_specs.range.spec_range_next.? $ (UINT 32) range!))
    :qid user_vstd__std_specs__range__axiom_spec_range_next_u32_31
    :skolemid skolem_user_vstd__std_specs__range__axiom_spec_range_next_u32_31
))))

;; Function-Axioms vstd::std_specs::range::impl&%9::spec_is_lt
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%9.spec_is_lt.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%9.spec_is_lt.)
  (forall ((self! Poly) (other! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 64) self! other!) (B (< (%I self!)
       (%I other!)
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 64) self! other!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%9::spec_forward_checked_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%9.spec_forward_checked_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%9.spec_forward_checked_int.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 64) self! count!)
     (Poly%core!option.Option. (ite
       (<= (Add (%I self!) (%I count!)) 18446744073709551615)
       (core!option.Option./Some (I (uClip 64 (Add (%I self!) (%I count!)))))
       core!option.Option./None
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 64) self!
      count!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%9::spec_forward_checked
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%9.spec_forward_checked.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%9.spec_forward_checked.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (UINT 64) self! count!)
     (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 64) self! count!)
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (UINT 64) self! count!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%9::spec_steps_between_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%9.spec_steps_between_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%9.spec_steps_between_int.)
  (forall ((self! Poly) (end! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (UINT 64) self! end!)
     (I (Sub (%I end!) (%I self!)))
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (UINT 64) self!
      end!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.range.StepSpec. $ (UINT 64))
)

;; Broadcast vstd::std_specs::range::axiom_spec_range_next_u64
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.axiom_spec_range_next_u64.)
  (forall ((range! Poly)) (!
    (=>
     (has_type range! (TYPE%core!ops.range.Range. $ (UINT 64)))
     (and
      (=>
       (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 64) (core!ops.range.Range./Range/start
          (%Poly%core!ops.range.Range. range!)
         ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       ))
       (let
        ((tmp%%$ (%Poly%core!option.Option. (vstd!std_specs.range.StepSpec.spec_forward_checked.?
            $ (UINT 64) (core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. range!))
            (I 1)
        ))))
        (=>
         (is-core!option.Option./Some tmp%%$)
         (let
          ((n$ (%I (core!option.Option./Some/0 $ (UINT 64) (%Poly%core!option.Option. (Poly%core!option.Option.
                tmp%%$
          ))))))
          (= (vstd!std_specs.range.spec_range_next.? $ (UINT 64) range!) (tuple%2./tuple%2 (Poly%core!ops.range.Range.
             (core!ops.range.Range./Range (I n$) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range.
                range!
             )))
            ) (Poly%core!option.Option. (core!option.Option./Some (core!ops.range.Range./Range/start
               (%Poly%core!ops.range.Range. range!)
      )))))))))
      (=>
       (not (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 64) (core!ops.range.Range./Range/start
           (%Poly%core!ops.range.Range. range!)
          ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       )))
       (= (vstd!std_specs.range.spec_range_next.? $ (UINT 64) range!) (tuple%2./tuple%2 range!
         (Poly%core!option.Option. core!option.Option./None)
    )))))
    :pattern ((vstd!std_specs.range.spec_range_next.? $ (UINT 64) range!))
    :qid user_vstd__std_specs__range__axiom_spec_range_next_u64_32
    :skolemid skolem_user_vstd__std_specs__range__axiom_spec_range_next_u64_32
))))

;; Function-Axioms vstd::std_specs::range::impl&%10::spec_is_lt
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%10.spec_is_lt.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%10.spec_is_lt.)
  (forall ((self! Poly) (other! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 128) self! other!) (B (< (%I self!)
       (%I other!)
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 128) self! other!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%10::spec_forward_checked_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%10.spec_forward_checked_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%10.spec_forward_checked_int.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 128) self! count!)
     (Poly%core!option.Option. (ite
       (<= (Add (%I self!) (%I count!)) 340282366920938463463374607431768211455)
       (core!option.Option./Some (I (uClip 128 (Add (%I self!) (%I count!)))))
       core!option.Option./None
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 128) self!
      count!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%10::spec_forward_checked
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%10.spec_forward_checked.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%10.spec_forward_checked.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (UINT 128) self! count!)
     (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 128) self! count!)
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (UINT 128) self!
      count!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%10::spec_steps_between_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%10.spec_steps_between_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%10.spec_steps_between_int.)
  (forall ((self! Poly) (end! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (UINT 128) self! end!)
     (I (Sub (%I end!) (%I self!)))
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (UINT 128) self!
      end!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.range.StepSpec. $ (UINT 128))
)

;; Broadcast vstd::std_specs::range::axiom_spec_range_next_u128
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.axiom_spec_range_next_u128.)
  (forall ((range! Poly)) (!
    (=>
     (has_type range! (TYPE%core!ops.range.Range. $ (UINT 128)))
     (and
      (=>
       (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 128) (core!ops.range.Range./Range/start
          (%Poly%core!ops.range.Range. range!)
         ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       ))
       (let
        ((tmp%%$ (%Poly%core!option.Option. (vstd!std_specs.range.StepSpec.spec_forward_checked.?
            $ (UINT 128) (core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. range!))
            (I 1)
        ))))
        (=>
         (is-core!option.Option./Some tmp%%$)
         (let
          ((n$ (%I (core!option.Option./Some/0 $ (UINT 128) (%Poly%core!option.Option. (Poly%core!option.Option.
                tmp%%$
          ))))))
          (= (vstd!std_specs.range.spec_range_next.? $ (UINT 128) range!) (tuple%2./tuple%2 (
             Poly%core!ops.range.Range. (core!ops.range.Range./Range (I n$) (core!ops.range.Range./Range/end
               (%Poly%core!ops.range.Range. range!)
             ))
            ) (Poly%core!option.Option. (core!option.Option./Some (core!ops.range.Range./Range/start
               (%Poly%core!ops.range.Range. range!)
      )))))))))
      (=>
       (not (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 128) (core!ops.range.Range./Range/start
           (%Poly%core!ops.range.Range. range!)
          ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       )))
       (= (vstd!std_specs.range.spec_range_next.? $ (UINT 128) range!) (tuple%2./tuple%2 range!
         (Poly%core!option.Option. core!option.Option./None)
    )))))
    :pattern ((vstd!std_specs.range.spec_range_next.? $ (UINT 128) range!))
    :qid user_vstd__std_specs__range__axiom_spec_range_next_u128_33
    :skolemid skolem_user_vstd__std_specs__range__axiom_spec_range_next_u128_33
))))

;; Function-Axioms vstd::std_specs::range::impl&%11::spec_is_lt
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%11.spec_is_lt.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%11.spec_is_lt.)
  (forall ((self! Poly) (other! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_is_lt.? $ USIZE self! other!) (B (< (%I self!)
       (%I other!)
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_is_lt.? $ USIZE self! other!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%11::spec_forward_checked_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%11.spec_forward_checked_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%11.spec_forward_checked_int.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ USIZE self! count!)
     (Poly%core!option.Option. (ite
       (<= (Add (%I self!) (%I count!)) (- (uHi SZ) 1))
       (core!option.Option./Some (I (uClip SZ (Add (%I self!) (%I count!)))))
       core!option.Option./None
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ USIZE self! count!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%11::spec_forward_checked
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%11.spec_forward_checked.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%11.spec_forward_checked.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked.? $ USIZE self! count!) (vstd!std_specs.range.StepSpec.spec_forward_checked_int.?
      $ USIZE self! count!
    ))
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked.? $ USIZE self! count!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%11::spec_steps_between_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%11.spec_steps_between_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%11.spec_steps_between_int.)
  (forall ((self! Poly) (end! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ USIZE self! end!) (I (
       Sub (%I end!) (%I self!)
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ USIZE self! end!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.range.StepSpec. $ USIZE)
)

;; Broadcast vstd::std_specs::range::axiom_spec_range_next_usize
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.axiom_spec_range_next_usize.)
  (forall ((range! Poly)) (!
    (=>
     (has_type range! (TYPE%core!ops.range.Range. $ USIZE))
     (and
      (=>
       (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ USIZE (core!ops.range.Range./Range/start
          (%Poly%core!ops.range.Range. range!)
         ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       ))
       (let
        ((tmp%%$ (%Poly%core!option.Option. (vstd!std_specs.range.StepSpec.spec_forward_checked.?
            $ USIZE (core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. range!))
            (I 1)
        ))))
        (=>
         (is-core!option.Option./Some tmp%%$)
         (let
          ((n$ (%I (core!option.Option./Some/0 $ USIZE (%Poly%core!option.Option. (Poly%core!option.Option.
                tmp%%$
          ))))))
          (= (vstd!std_specs.range.spec_range_next.? $ USIZE range!) (tuple%2./tuple%2 (Poly%core!ops.range.Range.
             (core!ops.range.Range./Range (I n$) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range.
                range!
             )))
            ) (Poly%core!option.Option. (core!option.Option./Some (core!ops.range.Range./Range/start
               (%Poly%core!ops.range.Range. range!)
      )))))))))
      (=>
       (not (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ USIZE (core!ops.range.Range./Range/start
           (%Poly%core!ops.range.Range. range!)
          ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       )))
       (= (vstd!std_specs.range.spec_range_next.? $ USIZE range!) (tuple%2./tuple%2 range!
         (Poly%core!option.Option. core!option.Option./None)
    )))))
    :pattern ((vstd!std_specs.range.spec_range_next.? $ USIZE range!))
    :qid user_vstd__std_specs__range__axiom_spec_range_next_usize_34
    :skolemid skolem_user_vstd__std_specs__range__axiom_spec_range_next_usize_34
))))

;; Function-Axioms vstd::std_specs::range::impl&%14::spec_is_lt
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%14.spec_is_lt.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%14.spec_is_lt.)
  (forall ((self! Poly) (other! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (SINT 32) self! other!) (B (< (%I self!)
       (%I other!)
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_is_lt.? $ (SINT 32) self! other!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%14::spec_forward_checked_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%14.spec_forward_checked_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%14.spec_forward_checked_int.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (SINT 32) self! count!)
     (Poly%core!option.Option. (ite
       (<= (Add (%I self!) (%I count!)) 2147483647)
       (core!option.Option./Some (I (iClip 32 (Add (%I self!) (%I count!)))))
       core!option.Option./None
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (SINT 32) self!
      count!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%14::spec_forward_checked
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%14.spec_forward_checked.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%14.spec_forward_checked.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (SINT 32) self! count!)
     (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (SINT 32) self! count!)
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (SINT 32) self! count!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%14::spec_steps_between_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%14.spec_steps_between_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%14.spec_steps_between_int.)
  (forall ((self! Poly) (end! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (SINT 32) self! end!)
     (I (Sub (%I end!) (%I self!)))
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (SINT 32) self!
      end!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.range.StepSpec. $ (SINT 32))
)

;; Broadcast vstd::std_specs::range::axiom_spec_range_next_i32
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.axiom_spec_range_next_i32.)
  (forall ((range! Poly)) (!
    (=>
     (has_type range! (TYPE%core!ops.range.Range. $ (SINT 32)))
     (and
      (=>
       (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (SINT 32) (core!ops.range.Range./Range/start
          (%Poly%core!ops.range.Range. range!)
         ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       ))
       (let
        ((tmp%%$ (%Poly%core!option.Option. (vstd!std_specs.range.StepSpec.spec_forward_checked.?
            $ (SINT 32) (core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. range!))
            (I 1)
        ))))
        (=>
         (is-core!option.Option./Some tmp%%$)
         (let
          ((n$ (%I (core!option.Option./Some/0 $ (SINT 32) (%Poly%core!option.Option. (Poly%core!option.Option.
                tmp%%$
          ))))))
          (= (vstd!std_specs.range.spec_range_next.? $ (SINT 32) range!) (tuple%2./tuple%2 (Poly%core!ops.range.Range.
             (core!ops.range.Range./Range (I n$) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range.
                range!
             )))
            ) (Poly%core!option.Option. (core!option.Option./Some (core!ops.range.Range./Range/start
               (%Poly%core!ops.range.Range. range!)
      )))))))))
      (=>
       (not (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (SINT 32) (core!ops.range.Range./Range/start
           (%Poly%core!ops.range.Range. range!)
          ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       )))
       (= (vstd!std_specs.range.spec_range_next.? $ (SINT 32) range!) (tuple%2./tuple%2 range!
         (Poly%core!option.Option. core!option.Option./None)
    )))))
    :pattern ((vstd!std_specs.range.spec_range_next.? $ (SINT 32) range!))
    :qid user_vstd__std_specs__range__axiom_spec_range_next_i32_35
    :skolemid skolem_user_vstd__std_specs__range__axiom_spec_range_next_i32_35
))))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!alloc.Allocator. $ ALLOCATOR_GLOBAL)
)

;; Function-Specs core::clone::Clone::clone
(declare-fun ens%core!clone.Clone.clone. (Dcr Type Poly Poly) Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly) (%return! Poly)) (!
   (= (ens%core!clone.Clone.clone. Self%&. Self%& self! %return!) (has_type %return! Self%&))
   :pattern ((ens%core!clone.Clone.clone. Self%&. Self%& self! %return!))
   :qid internal_ens__core!clone.Clone.clone._definition
   :skolemid skolem_internal_ens__core!clone.Clone.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (Self%&. Dcr) (Self%& Type)) (!
   (=>
    (has_type closure%$ (TYPE%tuple%1. (REF Self%&.) Self%&))
    (=>
     (let
      ((self$ (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$))))
      true
     )
     (closure_req (FNDEF%core!clone.Clone.clone. Self%&. Self%&) (DST (REF Self%&.)) (TYPE%tuple%1.
       (REF Self%&.) Self%&
      ) (F fndef_singleton) closure%$
   )))
   :pattern ((closure_req (FNDEF%core!clone.Clone.clone. Self%&. Self%&) (DST (REF Self%&.))
     (TYPE%tuple%1. (REF Self%&.) Self%&) (F fndef_singleton) closure%$
   ))
   :qid user_core__clone__Clone__clone_36
   :skolemid skolem_user_core__clone__Clone__clone_36
)))

;; Function-Axioms vstd::std_specs::core::IndexSetTrustedSpec::spec_index_set_requires
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Idx&. Dcr) (Idx& Type) (self! Poly) (index! Poly))
  (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type index! Idx&)
    )
    (has_type (vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.? Self%&.
      Self%& Idx&. Idx& self! index!
     ) BOOL
   ))
   :pattern ((vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.? Self%&.
     Self%& Idx&. Idx& self! index!
   ))
   :qid internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::core::IndexSetTrustedSpec::spec_index_set_ensures
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Idx&. Dcr) (Idx& Type) (self! Poly) (new_container!
    Poly
   ) (index! Poly) (val! Poly)
  ) (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type new_container! Self%&)
     (has_type index! Idx&)
     (has_type val! (proj%core!ops.index.Index./Output Self%&. Self%& Idx&. Idx&))
    )
    (has_type (vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.? Self%&.
      Self%& Idx&. Idx& self! new_container! index! val!
     ) BOOL
   ))
   :pattern ((vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.? Self%&.
     Self%& Idx&. Idx& self! new_container! index! val!
   ))
   :qid internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.?_pre_post_definition
)))

;; Function-Specs core::clone::impls::impl&%6::clone
(declare-fun ens%core!clone.impls.impl&%6.clone. (Poly Poly) Bool)
(assert
 (forall ((x! Poly) (res! Poly)) (!
   (= (ens%core!clone.impls.impl&%6.clone. x! res!) (and
     (ens%core!clone.Clone.clone. $ (UINT 8) x! res!)
     (= res! x!)
   ))
   :pattern ((ens%core!clone.impls.impl&%6.clone. x! res!))
   :qid internal_ens__core!clone.impls.impl&__6.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__6.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) (UINT 8)))
     (has_type res$ (UINT 8))
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ (UINT 8)) (DST (REF $)) (TYPE%tuple%1.
       (REF $) (UINT 8)
      ) (F fndef_singleton) closure%$ res$
     )
     (let
      ((x$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (%I res$) x$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ (UINT 8)) (DST (REF $)) (TYPE%tuple%1.
      (REF $) (UINT 8)
     ) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__clone__impls__impl&%6__clone_37
   :skolemid skolem_user_core__clone__impls__impl&%6__clone_37
)))

;; Function-Specs core::clone::impls::impl&%8::clone
(declare-fun ens%core!clone.impls.impl&%8.clone. (Poly Poly) Bool)
(assert
 (forall ((x! Poly) (res! Poly)) (!
   (= (ens%core!clone.impls.impl&%8.clone. x! res!) (and
     (ens%core!clone.Clone.clone. $ (UINT 32) x! res!)
     (= res! x!)
   ))
   :pattern ((ens%core!clone.impls.impl&%8.clone. x! res!))
   :qid internal_ens__core!clone.impls.impl&__8.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__8.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) (UINT 32)))
     (has_type res$ (UINT 32))
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ (UINT 32)) (DST (REF $)) (TYPE%tuple%1.
       (REF $) (UINT 32)
      ) (F fndef_singleton) closure%$ res$
     )
     (let
      ((x$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (%I res$) x$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ (UINT 32)) (DST (REF $)) (TYPE%tuple%1.
      (REF $) (UINT 32)
     ) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__clone__impls__impl&%8__clone_38
   :skolemid skolem_user_core__clone__impls__impl&%8__clone_38
)))

;; Function-Specs core::clone::impls::impl&%14::clone
(declare-fun ens%core!clone.impls.impl&%14.clone. (Poly Poly) Bool)
(assert
 (forall ((x! Poly) (res! Poly)) (!
   (= (ens%core!clone.impls.impl&%14.clone. x! res!) (and
     (ens%core!clone.Clone.clone. $ (SINT 32) x! res!)
     (= res! x!)
   ))
   :pattern ((ens%core!clone.impls.impl&%14.clone. x! res!))
   :qid internal_ens__core!clone.impls.impl&__14.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__14.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) (SINT 32)))
     (has_type res$ (SINT 32))
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ (SINT 32)) (DST (REF $)) (TYPE%tuple%1.
       (REF $) (SINT 32)
      ) (F fndef_singleton) closure%$ res$
     )
     (let
      ((x$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (%I res$) x$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ (SINT 32)) (DST (REF $)) (TYPE%tuple%1.
      (REF $) (SINT 32)
     ) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__clone__impls__impl&%14__clone_39
   :skolemid skolem_user_core__clone__impls__impl&%14__clone_39
)))

;; Function-Specs core::clone::impls::impl&%9::clone
(declare-fun ens%core!clone.impls.impl&%9.clone. (Poly Poly) Bool)
(assert
 (forall ((x! Poly) (res! Poly)) (!
   (= (ens%core!clone.impls.impl&%9.clone. x! res!) (and
     (ens%core!clone.Clone.clone. $ (UINT 64) x! res!)
     (= res! x!)
   ))
   :pattern ((ens%core!clone.impls.impl&%9.clone. x! res!))
   :qid internal_ens__core!clone.impls.impl&__9.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__9.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) (UINT 64)))
     (has_type res$ (UINT 64))
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ (UINT 64)) (DST (REF $)) (TYPE%tuple%1.
       (REF $) (UINT 64)
      ) (F fndef_singleton) closure%$ res$
     )
     (let
      ((x$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (%I res$) x$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ (UINT 64)) (DST (REF $)) (TYPE%tuple%1.
      (REF $) (UINT 64)
     ) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__clone__impls__impl&%9__clone_40
   :skolemid skolem_user_core__clone__impls__impl&%9__clone_40
)))

;; Function-Specs core::clone::impls::impl&%10::clone
(declare-fun ens%core!clone.impls.impl&%10.clone. (Poly Poly) Bool)
(assert
 (forall ((x! Poly) (res! Poly)) (!
   (= (ens%core!clone.impls.impl&%10.clone. x! res!) (and
     (ens%core!clone.Clone.clone. $ (UINT 128) x! res!)
     (= res! x!)
   ))
   :pattern ((ens%core!clone.impls.impl&%10.clone. x! res!))
   :qid internal_ens__core!clone.impls.impl&__10.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__10.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) (UINT 128)))
     (has_type res$ (UINT 128))
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ (UINT 128)) (DST (REF $)) (TYPE%tuple%1.
       (REF $) (UINT 128)
      ) (F fndef_singleton) closure%$ res$
     )
     (let
      ((x$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (%I res$) x$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ (UINT 128)) (DST (REF $)) (
      TYPE%tuple%1. (REF $) (UINT 128)
     ) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__clone__impls__impl&%10__clone_41
   :skolemid skolem_user_core__clone__impls__impl&%10__clone_41
)))

;; Function-Specs core::clone::impls::impl&%5::clone
(declare-fun ens%core!clone.impls.impl&%5.clone. (Poly Poly) Bool)
(assert
 (forall ((x! Poly) (res! Poly)) (!
   (= (ens%core!clone.impls.impl&%5.clone. x! res!) (and
     (ens%core!clone.Clone.clone. $ USIZE x! res!)
     (= res! x!)
   ))
   :pattern ((ens%core!clone.impls.impl&%5.clone. x! res!))
   :qid internal_ens__core!clone.impls.impl&__5.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__5.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) USIZE))
     (has_type res$ USIZE)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ USIZE) (DST (REF $)) (TYPE%tuple%1. (
        REF $
       ) USIZE
      ) (F fndef_singleton) closure%$ res$
     )
     (let
      ((x$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (%I res$) x$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ USIZE) (DST (REF $)) (TYPE%tuple%1.
      (REF $) USIZE
     ) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__clone__impls__impl&%5__clone_42
   :skolemid skolem_user_core__clone__impls__impl&%5__clone_42
)))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_twice
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_twice. (Int Int) Bool)
(declare-const %%global_location_label%%5 Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_twice. x! m!) (=>
     %%global_location_label%%5
     (> m! 0)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mod_twice. x! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mod_twice._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mod_twice._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mod_twice. (Int Int) Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mod_twice. x! m!) (= (EucMod (EucMod x! m!) m!)
     (EucMod x! m!)
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mod_twice. x! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mod_twice._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mod_twice._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mod_twice
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mod_twice.)
  (forall ((x! Int) (m! Int)) (!
    (=>
     (> m! 0)
     (= (EucMod (EucMod x! m!) m!) (EucMod x! m!))
    )
    :pattern ((EucMod (EucMod x! m!) m!))
    :qid user_vstd__arithmetic__div_mod__lemma_mod_twice_43
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_twice_43
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_sub_mod_noop
(declare-fun req%vstd!arithmetic.div_mod.lemma_sub_mod_noop. (Int Int Int) Bool)
(declare-const %%global_location_label%%6 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_sub_mod_noop. x! y! m!) (=>
     %%global_location_label%%6
     (< 0 m!)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_sub_mod_noop. x! y! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_sub_mod_noop._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_sub_mod_noop._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_sub_mod_noop. (Int Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_sub_mod_noop. x! y! m!) (= (EucMod (Sub (EucMod
        x! m!
       ) (EucMod y! m!)
      ) m!
     ) (EucMod (Sub x! y!) m!)
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_sub_mod_noop. x! y! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_sub_mod_noop._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_sub_mod_noop._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_sub_mod_noop
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_sub_mod_noop.)
  (forall ((x! Int) (y! Int) (m! Int)) (!
    (=>
     (< 0 m!)
     (= (EucMod (Sub (EucMod x! m!) (EucMod y! m!)) m!) (EucMod (Sub x! y!) m!))
    )
    :pattern ((EucMod (Sub x! y!) m!))
    :qid user_vstd__arithmetic__div_mod__lemma_sub_mod_noop_44
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_sub_mod_noop_44
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mul_mod_noop_general
(declare-fun req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_general. (Int Int Int)
 Bool
)
(declare-const %%global_location_label%%7 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_general. x! y! m!) (=>
     %%global_location_label%%7
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
    :qid user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_general_45
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_general_45
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mul_mod_noop
(declare-fun req%vstd!arithmetic.div_mod.lemma_mul_mod_noop. (Int Int Int) Bool)
(declare-const %%global_location_label%%8 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mul_mod_noop. x! y! m!) (=>
     %%global_location_label%%8
     (< 0 m!)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mul_mod_noop. x! y! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mul_mod_noop._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mul_mod_noop._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mul_mod_noop. (Int Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mul_mod_noop. x! y! m!) (= (EucMod (Mul (EucMod
        x! m!
       ) (EucMod y! m!)
      ) m!
     ) (EucMod (Mul x! y!) m!)
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mul_mod_noop. x! y! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mul_mod_noop._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mul_mod_noop._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mul_mod_noop
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop.)
  (forall ((x! Int) (y! Int) (m! Int)) (!
    (=>
     (< 0 m!)
     (= (EucMod (Mul (EucMod x! m!) (EucMod y! m!)) m!) (EucMod (Mul x! y!) m!))
    )
    :pattern ((EucMod (Mul x! y!) m!))
    :qid user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_46
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_46
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_strict_inequality
(declare-fun req%vstd!arithmetic.mul.lemma_mul_strict_inequality. (Int Int Int) Bool)
(declare-const %%global_location_label%%9 Bool)
(declare-const %%global_location_label%%10 Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (req%vstd!arithmetic.mul.lemma_mul_strict_inequality. x! y! z!) (and
     (=>
      %%global_location_label%%9
      (< x! y!)
     )
     (=>
      %%global_location_label%%10
      (> z! 0)
   )))
   :pattern ((req%vstd!arithmetic.mul.lemma_mul_strict_inequality. x! y! z!))
   :qid internal_req__vstd!arithmetic.mul.lemma_mul_strict_inequality._definition
   :skolemid skolem_internal_req__vstd!arithmetic.mul.lemma_mul_strict_inequality._definition
)))
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_strict_inequality. (Int Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_strict_inequality. x! y! z!) (< (Mul x! z!) (
      Mul y! z!
   )))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_strict_inequality. x! y! z!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_strict_inequality._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_strict_inequality._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_strict_inequality
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_strict_inequality.)
  (forall ((x! Int) (y! Int) (z! Int)) (!
    (=>
     (and
      (< x! y!)
      (> z! 0)
     )
     (< (Mul x! z!) (Mul y! z!))
    )
    :pattern ((Mul x! z!) (Mul y! z!))
    :qid user_vstd__arithmetic__mul__lemma_mul_strict_inequality_47
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_strict_inequality_47
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_left_inequality
(declare-fun req%vstd!arithmetic.mul.lemma_mul_left_inequality. (Int Int Int) Bool)
(declare-const %%global_location_label%%11 Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (req%vstd!arithmetic.mul.lemma_mul_left_inequality. x! y! z!) (=>
     %%global_location_label%%11
     (< 0 x!)
   ))
   :pattern ((req%vstd!arithmetic.mul.lemma_mul_left_inequality. x! y! z!))
   :qid internal_req__vstd!arithmetic.mul.lemma_mul_left_inequality._definition
   :skolemid skolem_internal_req__vstd!arithmetic.mul.lemma_mul_left_inequality._definition
)))
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_left_inequality. (Int Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_left_inequality. x! y! z!) (and
     (=>
      (<= y! z!)
      (<= (Mul x! y!) (Mul x! z!))
     )
     (=>
      (< y! z!)
      (< (Mul x! y!) (Mul x! z!))
   )))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_left_inequality. x! y! z!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_left_inequality._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_left_inequality._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_left_inequality
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_left_inequality.)
  (forall ((x! Int) (y! Int) (z! Int)) (!
    (=>
     (< 0 x!)
     (and
      (=>
       (<= y! z!)
       (<= (Mul x! y!) (Mul x! z!))
      )
      (=>
       (< y! z!)
       (< (Mul x! y!) (Mul x! z!))
    )))
    :pattern ((Mul x! y!) (Mul x! z!))
    :qid user_vstd__arithmetic__mul__lemma_mul_left_inequality_48
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_left_inequality_48
))))

;; Function-Specs vstd::arithmetic::power::lemma_pow1
(declare-fun ens%vstd!arithmetic.power.lemma_pow1. (Int) Bool)
(assert
 (forall ((b! Int)) (!
   (= (ens%vstd!arithmetic.power.lemma_pow1. b!) (= (vstd!arithmetic.power.pow.? (I b!)
      (I 1)
     ) b!
   ))
   :pattern ((ens%vstd!arithmetic.power.lemma_pow1. b!))
   :qid internal_ens__vstd!arithmetic.power.lemma_pow1._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.power.lemma_pow1._definition
)))

;; Broadcast vstd::arithmetic::power::lemma_pow1
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.power.lemma_pow1.)
  (forall ((b! Poly)) (!
    (=>
     (has_type b! INT)
     (= (vstd!arithmetic.power.pow.? b! (I 1)) (%I b!))
    )
    :pattern ((vstd!arithmetic.power.pow.? b! (I 1)))
    :qid user_vstd__arithmetic__power__lemma_pow1_49
    :skolemid skolem_user_vstd__arithmetic__power__lemma_pow1_49
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

;; Function-Specs core::clone::impls::impl&%21::clone
(declare-fun ens%core!clone.impls.impl&%21.clone. (Poly Poly) Bool)
(assert
 (forall ((b! Poly) (%return! Poly)) (!
   (= (ens%core!clone.impls.impl&%21.clone. b! %return!) (and
     (ens%core!clone.Clone.clone. $ BOOL b! %return!)
     (= %return! b!)
   ))
   :pattern ((ens%core!clone.impls.impl&%21.clone. b! %return!))
   :qid internal_ens__core!clone.impls.impl&__21.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__21.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (%return$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) BOOL))
     (has_type %return$ BOOL)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ BOOL) (DST (REF $)) (TYPE%tuple%1. (REF
        $
       ) BOOL
      ) (F fndef_singleton) closure%$ %return$
     )
     (let
      ((b$ (%B (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (%B %return$) b$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ BOOL) (DST (REF $)) (TYPE%tuple%1.
      (REF $) BOOL
     ) (F fndef_singleton) closure%$ %return$
   ))
   :qid user_core__clone__impls__impl&%21__clone_50
   :skolemid skolem_user_core__clone__impls__impl&%21__clone_50
)))

;; Function-Specs core::clone::impls::impl&%22::clone
(declare-fun ens%core!clone.impls.impl&%22.clone. (Poly Poly) Bool)
(assert
 (forall ((c! Poly) (%return! Poly)) (!
   (= (ens%core!clone.impls.impl&%22.clone. c! %return!) (and
     (ens%core!clone.Clone.clone. $ CHAR c! %return!)
     (= %return! c!)
   ))
   :pattern ((ens%core!clone.impls.impl&%22.clone. c! %return!))
   :qid internal_ens__core!clone.impls.impl&__22.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__22.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (%return$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) CHAR))
     (has_type %return$ CHAR)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ CHAR) (DST (REF $)) (TYPE%tuple%1. (REF
        $
       ) CHAR
      ) (F fndef_singleton) closure%$ %return$
     )
     (let
      ((c$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (%I %return$) c$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ CHAR) (DST (REF $)) (TYPE%tuple%1.
      (REF $) CHAR
     ) (F fndef_singleton) closure%$ %return$
   ))
   :qid user_core__clone__impls__impl&%22__clone_51
   :skolemid skolem_user_core__clone__impls__impl&%22__clone_51
)))

;; Function-Specs core::clone::impls::impl&%3::clone
(declare-fun ens%core!clone.impls.impl&%3.clone. (Dcr Type Poly Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (b! Poly) (res! Poly)) (!
   (= (ens%core!clone.impls.impl&%3.clone. T&. T& b! res!) (and
     (ens%core!clone.Clone.clone. (REF T&.) T& b! res!)
     (= res! b!)
   ))
   :pattern ((ens%core!clone.impls.impl&%3.clone. T&. T& b! res!))
   :qid internal_ens__core!clone.impls.impl&__3.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__3.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF (REF T&.)) T&))
     (has_type res$ T&)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. (REF T&.) T&) (DST (REF (REF T&.))) (TYPE%tuple%1.
       (REF (REF T&.)) T&
      ) (F fndef_singleton) closure%$ res$
     )
     (let
      ((b$ (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$))))
      (= res$ b$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. (REF T&.) T&) (DST (REF (REF T&.)))
     (TYPE%tuple%1. (REF (REF T&.)) T&) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__clone__impls__impl&%3__clone_52
   :skolemid skolem_user_core__clone__impls__impl&%3__clone_52
)))

;; Function-Axioms vstd::pervasive::strictly_cloned
(assert
 (fuel_bool_default fuel%vstd!pervasive.strictly_cloned.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!pervasive.strictly_cloned.)
  (forall ((T&. Dcr) (T& Type) (a! Poly) (b! Poly)) (!
    (= (vstd!pervasive.strictly_cloned.? T&. T& a! b!) (closure_ens (FNDEF%core!clone.Clone.clone.
       T&. T&
      ) (DST (REF T&.)) (TYPE%tuple%1. (REF T&.) T&) (F fndef_singleton) (Poly%tuple%1.
       (tuple%1./tuple%1 a!)
      ) b!
    ))
    :pattern ((vstd!pervasive.strictly_cloned.? T&. T& a! b!))
    :qid internal_vstd!pervasive.strictly_cloned.?_definition
    :skolemid skolem_internal_vstd!pervasive.strictly_cloned.?_definition
))))

;; Function-Axioms vstd::pervasive::cloned
(assert
 (fuel_bool_default fuel%vstd!pervasive.cloned.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!pervasive.cloned.)
  (forall ((T&. Dcr) (T& Type) (a! Poly) (b! Poly)) (!
    (= (vstd!pervasive.cloned.? T&. T& a! b!) (or
      (vstd!pervasive.strictly_cloned.? T&. T& a! b!)
      (= a! b!)
    ))
    :pattern ((vstd!pervasive.cloned.? T&. T& a! b!))
    :qid internal_vstd!pervasive.cloned.?_definition
    :skolemid skolem_internal_vstd!pervasive.cloned.?_definition
))))

;; Function-Specs core::array::impl&%20::clone
(declare-fun ens%core!array.impl&%20.clone. (Dcr Type Dcr Type Poly Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (a! Poly) (res! Poly)) (!
   (= (ens%core!array.impl&%20.clone. T&. T& N&. N& a! res!) (and
     (ens%core!clone.Clone.clone. $ (ARRAY T&. T& N&. N&) a! res!)
     (forall ((i$ Poly)) (!
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ (const_int N&))
         ))
         (vstd!pervasive.cloned.? T&. T& (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.?
            $ (ARRAY T&. T& N&. N&) a!
           ) i$
          ) (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) res!)
           i$
       ))))
       :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
          a!
         ) i$
       ))
       :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
          res!
         ) i$
       ))
       :pattern ((vstd!pervasive.cloned.? T&. T& (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.?
           $ (ARRAY T&. T& N&. N&) a!
          ) i$
         ) (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) res!)
          i$
       )))
       :qid user_core__array__impl&%20__clone_53
       :skolemid skolem_user_core__array__impl&%20__clone_53
     ))
     (=>
      (ext_eq false (TYPE%vstd!seq.Seq. T&. T&) (vstd!view.View.view.? $ (ARRAY T&. T& N&.
         N&
        ) a!
       ) (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) res!)
      )
      (= (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) a!) (vstd!view.View.view.? $ (ARRAY
         T&. T& N&. N&
        ) res!
   )))))
   :pattern ((ens%core!array.impl&%20.clone. T&. T& N&. N& a! res!))
   :qid internal_ens__core!array.impl&__20.clone._definition
   :skolemid skolem_internal_ens__core!array.impl&__20.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly) (T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) (ARRAY T&. T& N&. N&)))
     (has_type res$ (ARRAY T&. T& N&. N&))
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ (ARRAY T&. T& N&. N&)) (DST (REF $))
      (TYPE%tuple%1. (REF $) (ARRAY T&. T& N&. N&)) (F fndef_singleton) closure%$ res$
     )
     (let
      ((a$ (%Poly%array%. (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (and
       (forall ((i$ Poly)) (!
         (=>
          (has_type i$ INT)
          (=>
           (let
            ((tmp%%$ (%I i$)))
            (and
             (<= 0 tmp%%$)
             (< tmp%%$ (const_int N&))
           ))
           (vstd!pervasive.cloned.? T&. T& (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.?
              $ (ARRAY T&. T& N&. N&) (Poly%array%. a$)
             ) i$
            ) (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) res$)
             i$
         ))))
         :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
            (Poly%array%. a$)
           ) i$
         ))
         :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
            res$
           ) i$
         ))
         :pattern ((vstd!pervasive.cloned.? T&. T& (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.?
             $ (ARRAY T&. T& N&. N&) (Poly%array%. a$)
            ) i$
           ) (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) res$)
            i$
         )))
         :qid user_core__array__impl&%20__clone_54
         :skolemid skolem_user_core__array__impl&%20__clone_54
       ))
       (=>
        (ext_eq false (TYPE%vstd!seq.Seq. T&. T&) (vstd!view.View.view.? $ (ARRAY T&. T& N&.
           N&
          ) (Poly%array%. a$)
         ) (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) res$)
        )
        (= (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) (Poly%array%. a$)) (vstd!view.View.view.?
          $ (ARRAY T&. T& N&. N&) res$
   )))))))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ (ARRAY T&. T& N&. N&)) (DST
      (REF $)
     ) (TYPE%tuple%1. (REF $) (ARRAY T&. T& N&. N&)) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__array__impl&%20__clone_55
   :skolemid skolem_user_core__array__impl&%20__clone_55
)))

;; Function-Specs verus_builtin::impl&%5::clone
(declare-fun ens%verus_builtin!impl&%5.clone. (Dcr Type Poly Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (b! Poly) (res! Poly)) (!
   (= (ens%verus_builtin!impl&%5.clone. T&. T& b! res!) (and
     (ens%core!clone.Clone.clone. (TRACKED T&.) T& b! res!)
     (= res! b!)
   ))
   :pattern ((ens%verus_builtin!impl&%5.clone. T&. T& b! res!))
   :qid internal_ens__verus_builtin!impl&__5.clone._definition
   :skolemid skolem_internal_ens__verus_builtin!impl&__5.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF (TRACKED T&.)) T&))
     (has_type res$ T&)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. (TRACKED T&.) T&) (DST (REF (TRACKED T&.)))
      (TYPE%tuple%1. (REF (TRACKED T&.)) T&) (F fndef_singleton) closure%$ res$
     )
     (let
      ((b$ (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$))))
      (= res$ b$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. (TRACKED T&.) T&) (DST (REF (TRACKED
        T&.
      ))
     ) (TYPE%tuple%1. (REF (TRACKED T&.)) T&) (F fndef_singleton) closure%$ res$
   ))
   :qid user_verus_builtin__impl&%5__clone_56
   :skolemid skolem_user_verus_builtin__impl&%5__clone_56
)))

;; Function-Specs verus_builtin::impl&%3::clone
(declare-fun ens%verus_builtin!impl&%3.clone. (Dcr Type Poly Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (b! Poly) (res! Poly)) (!
   (= (ens%verus_builtin!impl&%3.clone. T&. T& b! res!) (and
     (ens%core!clone.Clone.clone. (GHOST T&.) T& b! res!)
     (= res! b!)
   ))
   :pattern ((ens%verus_builtin!impl&%3.clone. T&. T& b! res!))
   :qid internal_ens__verus_builtin!impl&__3.clone._definition
   :skolemid skolem_internal_ens__verus_builtin!impl&__3.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF (GHOST T&.)) T&))
     (has_type res$ T&)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. (GHOST T&.) T&) (DST (REF (GHOST T&.)))
      (TYPE%tuple%1. (REF (GHOST T&.)) T&) (F fndef_singleton) closure%$ res$
     )
     (let
      ((b$ (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$))))
      (= res$ b$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. (GHOST T&.) T&) (DST (REF (GHOST
        T&.
      ))
     ) (TYPE%tuple%1. (REF (GHOST T&.)) T&) (F fndef_singleton) closure%$ res$
   ))
   :qid user_verus_builtin__impl&%3__clone_57
   :skolemid skolem_user_verus_builtin__impl&%3__clone_57
)))

;; Function-Specs core::iter::traits::iterator::Iterator::next
(declare-fun ens%core!iter.traits.iterator.Iterator.next. (Dcr Type Poly Poly Poly)
 Bool
)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (pre%self! Poly) (self! Poly) (%return! Poly))
  (!
   (= (ens%core!iter.traits.iterator.Iterator.next. Self%&. Self%& pre%self! self! %return!)
    (and
     (has_type %return! (TYPE%core!option.Option. (proj%%core!iter.traits.iterator.Iterator./Item
        Self%&. Self%&
       ) (proj%core!iter.traits.iterator.Iterator./Item Self%&. Self%&)
     ))
     (has_type self! Self%&)
   ))
   :pattern ((ens%core!iter.traits.iterator.Iterator.next. Self%&. Self%& pre%self! self!
     %return!
   ))
   :qid internal_ens__core!iter.traits.iterator.Iterator.next._definition
   :skolemid skolem_internal_ens__core!iter.traits.iterator.Iterator.next._definition
)))

;; Function-Specs core::iter::traits::collect::impl&%0::into_iter
(declare-fun ens%core!iter.traits.collect.impl&%0.into_iter. (Dcr Type Poly Poly)
 Bool
)
(assert
 (forall ((I&. Dcr) (I& Type) (i! Poly) (r! Poly)) (!
   (= (ens%core!iter.traits.collect.impl&%0.into_iter. I&. I& i! r!) (and
     (has_type r! I&)
     (= r! i!)
   ))
   :pattern ((ens%core!iter.traits.collect.impl&%0.into_iter. I&. I& i! r!))
   :qid internal_ens__core!iter.traits.collect.impl&__0.into_iter._definition
   :skolemid skolem_internal_ens__core!iter.traits.collect.impl&__0.into_iter._definition
)))

;; Function-Specs vstd::std_specs::core::index_set
(declare-fun req%vstd!std_specs.core.index_set. (Dcr Type Dcr Type Dcr Type Poly Poly
  Poly
 ) Bool
)
(declare-const %%global_location_label%%12 Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (Idx&. Dcr) (Idx& Type) (E&. Dcr) (E& Type) (pre%container!
    Poly
   ) (index! Poly) (val! Poly)
  ) (!
   (= (req%vstd!std_specs.core.index_set. T&. T& Idx&. Idx& E&. E& pre%container! index!
     val!
    ) (=>
     %%global_location_label%%12
     (%B (vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.? T&. T& Idx&.
       Idx& pre%container! index!
   ))))
   :pattern ((req%vstd!std_specs.core.index_set. T&. T& Idx&. Idx& E&. E& pre%container!
     index! val!
   ))
   :qid internal_req__vstd!std_specs.core.index_set._definition
   :skolemid skolem_internal_req__vstd!std_specs.core.index_set._definition
)))
(declare-fun ens%vstd!std_specs.core.index_set. (Dcr Type Dcr Type Dcr Type Poly Poly
  Poly Poly
 ) Bool
)
(assert
 (forall ((T&. Dcr) (T& Type) (Idx&. Dcr) (Idx& Type) (E&. Dcr) (E& Type) (pre%container!
    Poly
   ) (container! Poly) (index! Poly) (val! Poly)
  ) (!
   (= (ens%vstd!std_specs.core.index_set. T&. T& Idx&. Idx& E&. E& pre%container! container!
     index! val!
    ) (and
     (has_type container! T&)
     (%B (vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.? T&. T& Idx&.
       Idx& pre%container! container! index! val!
   ))))
   :pattern ((ens%vstd!std_specs.core.index_set. T&. T& Idx&. Idx& E&. E& pre%container!
     container! index! val!
   ))
   :qid internal_ens__vstd!std_specs.core.index_set._definition
   :skolemid skolem_internal_ens__vstd!std_specs.core.index_set._definition
)))

;; Function-Axioms vstd::std_specs::ops::NegSpec::neg_req
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly)) (!
   (=>
    (has_type self! Self%&)
    (has_type (vstd!std_specs.ops.NegSpec.neg_req.? Self%&. Self%& self!) BOOL)
   )
   :pattern ((vstd!std_specs.ops.NegSpec.neg_req.? Self%&. Self%& self!))
   :qid internal_vstd!std_specs.ops.NegSpec.neg_req.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.ops.NegSpec.neg_req.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::ops::NegSpec::obeys_neg_spec
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (has_type (vstd!std_specs.ops.NegSpec.obeys_neg_spec.? Self%&. Self%&) BOOL)
   :pattern ((vstd!std_specs.ops.NegSpec.obeys_neg_spec.? Self%&. Self%&))
   :qid internal_vstd!std_specs.ops.NegSpec.obeys_neg_spec.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.ops.NegSpec.obeys_neg_spec.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::ops::NegSpec::neg_spec
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly)) (!
   (=>
    (has_type self! Self%&)
    (has_type (vstd!std_specs.ops.NegSpec.neg_spec.? Self%&. Self%& self!) (proj%core!ops.arith.Neg./Output
      Self%&. Self%&
   )))
   :pattern ((vstd!std_specs.ops.NegSpec.neg_spec.? Self%&. Self%& self!))
   :qid internal_vstd!std_specs.ops.NegSpec.neg_spec.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.ops.NegSpec.neg_spec.?_pre_post_definition
)))

;; Function-Specs core::ops::arith::Neg::neg
(declare-fun req%core!ops.arith.Neg.neg. (Dcr Type Poly) Bool)
(declare-const %%global_location_label%%13 Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly)) (!
   (= (req%core!ops.arith.Neg.neg. Self%&. Self%& self!) (=>
     %%global_location_label%%13
     (%B (vstd!std_specs.ops.NegSpec.neg_req.? Self%&. Self%& self!))
   ))
   :pattern ((req%core!ops.arith.Neg.neg. Self%&. Self%& self!))
   :qid internal_req__core!ops.arith.Neg.neg._definition
   :skolemid skolem_internal_req__core!ops.arith.Neg.neg._definition
)))
(declare-fun ens%core!ops.arith.Neg.neg. (Dcr Type Poly Poly) Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly) (ret! Poly)) (!
   (= (ens%core!ops.arith.Neg.neg. Self%&. Self%& self! ret!) (and
     (has_type ret! (proj%core!ops.arith.Neg./Output Self%&. Self%&))
     (=>
      (%B (vstd!std_specs.ops.NegSpec.obeys_neg_spec.? Self%&. Self%&))
      (= ret! (vstd!std_specs.ops.NegSpec.neg_spec.? Self%&. Self%& self!))
   )))
   :pattern ((ens%core!ops.arith.Neg.neg. Self%&. Self%& self! ret!))
   :qid internal_ens__core!ops.arith.Neg.neg._definition
   :skolemid skolem_internal_ens__core!ops.arith.Neg.neg._definition
)))

;; Function-Axioms vstd::std_specs::ops::AddSpec::add_req
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly))
  (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type rhs! Rhs&)
    )
    (has_type (vstd!std_specs.ops.AddSpec.add_req.? Self%&. Self%& Rhs&. Rhs& self! rhs!)
     BOOL
   ))
   :pattern ((vstd!std_specs.ops.AddSpec.add_req.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::ops::AddSpec::obeys_add_spec
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   (has_type (vstd!std_specs.ops.AddSpec.obeys_add_spec.? Self%&. Self%& Rhs&. Rhs&)
    BOOL
   )
   :pattern ((vstd!std_specs.ops.AddSpec.obeys_add_spec.? Self%&. Self%& Rhs&. Rhs&))
   :qid internal_vstd!std_specs.ops.AddSpec.obeys_add_spec.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.obeys_add_spec.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::ops::AddSpec::add_spec
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly))
  (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type rhs! Rhs&)
    )
    (has_type (vstd!std_specs.ops.AddSpec.add_spec.? Self%&. Self%& Rhs&. Rhs& self! rhs!)
     (proj%core!ops.arith.Add./Output Self%&. Self%& Rhs&. Rhs&)
   ))
   :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_pre_post_definition
)))

;; Function-Specs core::ops::arith::Add::add
(declare-fun req%core!ops.arith.Add.add. (Dcr Type Dcr Type Poly Poly) Bool)
(declare-const %%global_location_label%%14 Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly))
  (!
   (= (req%core!ops.arith.Add.add. Self%&. Self%& Rhs&. Rhs& self! rhs!) (=>
     %%global_location_label%%14
     (%B (vstd!std_specs.ops.AddSpec.add_req.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   ))
   :pattern ((req%core!ops.arith.Add.add. Self%&. Self%& Rhs&. Rhs& self! rhs!))
   :qid internal_req__core!ops.arith.Add.add._definition
   :skolemid skolem_internal_req__core!ops.arith.Add.add._definition
)))
(declare-fun ens%core!ops.arith.Add.add. (Dcr Type Dcr Type Poly Poly Poly) Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly)
   (ret! Poly)
  ) (!
   (= (ens%core!ops.arith.Add.add. Self%&. Self%& Rhs&. Rhs& self! rhs! ret!) (and
     (has_type ret! (proj%core!ops.arith.Add./Output Self%&. Self%& Rhs&. Rhs&))
     (=>
      (%B (vstd!std_specs.ops.AddSpec.obeys_add_spec.? Self%&. Self%& Rhs&. Rhs&))
      (= ret! (vstd!std_specs.ops.AddSpec.add_spec.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   )))
   :pattern ((ens%core!ops.arith.Add.add. Self%&. Self%& Rhs&. Rhs& self! rhs! ret!))
   :qid internal_ens__core!ops.arith.Add.add._definition
   :skolemid skolem_internal_ens__core!ops.arith.Add.add._definition
)))

;; Function-Axioms vstd::std_specs::ops::SubSpec::sub_req
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly))
  (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type rhs! Rhs&)
    )
    (has_type (vstd!std_specs.ops.SubSpec.sub_req.? Self%&. Self%& Rhs&. Rhs& self! rhs!)
     BOOL
   ))
   :pattern ((vstd!std_specs.ops.SubSpec.sub_req.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   :qid internal_vstd!std_specs.ops.SubSpec.sub_req.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_req.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::ops::SubSpec::obeys_sub_spec
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   (has_type (vstd!std_specs.ops.SubSpec.obeys_sub_spec.? Self%&. Self%& Rhs&. Rhs&)
    BOOL
   )
   :pattern ((vstd!std_specs.ops.SubSpec.obeys_sub_spec.? Self%&. Self%& Rhs&. Rhs&))
   :qid internal_vstd!std_specs.ops.SubSpec.obeys_sub_spec.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.obeys_sub_spec.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::ops::SubSpec::sub_spec
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly))
  (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type rhs! Rhs&)
    )
    (has_type (vstd!std_specs.ops.SubSpec.sub_spec.? Self%&. Self%& Rhs&. Rhs& self! rhs!)
     (proj%core!ops.arith.Sub./Output Self%&. Self%& Rhs&. Rhs&)
   ))
   :pattern ((vstd!std_specs.ops.SubSpec.sub_spec.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   :qid internal_vstd!std_specs.ops.SubSpec.sub_spec.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_spec.?_pre_post_definition
)))

;; Function-Specs core::ops::arith::Sub::sub
(declare-fun req%core!ops.arith.Sub.sub. (Dcr Type Dcr Type Poly Poly) Bool)
(declare-const %%global_location_label%%15 Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly))
  (!
   (= (req%core!ops.arith.Sub.sub. Self%&. Self%& Rhs&. Rhs& self! rhs!) (=>
     %%global_location_label%%15
     (%B (vstd!std_specs.ops.SubSpec.sub_req.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   ))
   :pattern ((req%core!ops.arith.Sub.sub. Self%&. Self%& Rhs&. Rhs& self! rhs!))
   :qid internal_req__core!ops.arith.Sub.sub._definition
   :skolemid skolem_internal_req__core!ops.arith.Sub.sub._definition
)))
(declare-fun ens%core!ops.arith.Sub.sub. (Dcr Type Dcr Type Poly Poly Poly) Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly)
   (ret! Poly)
  ) (!
   (= (ens%core!ops.arith.Sub.sub. Self%&. Self%& Rhs&. Rhs& self! rhs! ret!) (and
     (has_type ret! (proj%core!ops.arith.Sub./Output Self%&. Self%& Rhs&. Rhs&))
     (=>
      (%B (vstd!std_specs.ops.SubSpec.obeys_sub_spec.? Self%&. Self%& Rhs&. Rhs&))
      (= ret! (vstd!std_specs.ops.SubSpec.sub_spec.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   )))
   :pattern ((ens%core!ops.arith.Sub.sub. Self%&. Self%& Rhs&. Rhs& self! rhs! ret!))
   :qid internal_ens__core!ops.arith.Sub.sub._definition
   :skolemid skolem_internal_ens__core!ops.arith.Sub.sub._definition
)))

;; Function-Axioms vstd::std_specs::ops::MulSpec::mul_req
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly))
  (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type rhs! Rhs&)
    )
    (has_type (vstd!std_specs.ops.MulSpec.mul_req.? Self%&. Self%& Rhs&. Rhs& self! rhs!)
     BOOL
   ))
   :pattern ((vstd!std_specs.ops.MulSpec.mul_req.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   :qid internal_vstd!std_specs.ops.MulSpec.mul_req.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.ops.MulSpec.mul_req.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::ops::MulSpec::obeys_mul_spec
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   (has_type (vstd!std_specs.ops.MulSpec.obeys_mul_spec.? Self%&. Self%& Rhs&. Rhs&)
    BOOL
   )
   :pattern ((vstd!std_specs.ops.MulSpec.obeys_mul_spec.? Self%&. Self%& Rhs&. Rhs&))
   :qid internal_vstd!std_specs.ops.MulSpec.obeys_mul_spec.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.ops.MulSpec.obeys_mul_spec.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::ops::MulSpec::mul_spec
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly))
  (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type rhs! Rhs&)
    )
    (has_type (vstd!std_specs.ops.MulSpec.mul_spec.? Self%&. Self%& Rhs&. Rhs& self! rhs!)
     (proj%core!ops.arith.Mul./Output Self%&. Self%& Rhs&. Rhs&)
   ))
   :pattern ((vstd!std_specs.ops.MulSpec.mul_spec.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   :qid internal_vstd!std_specs.ops.MulSpec.mul_spec.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.ops.MulSpec.mul_spec.?_pre_post_definition
)))

;; Function-Specs core::ops::arith::Mul::mul
(declare-fun req%core!ops.arith.Mul.mul. (Dcr Type Dcr Type Poly Poly) Bool)
(declare-const %%global_location_label%%16 Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly))
  (!
   (= (req%core!ops.arith.Mul.mul. Self%&. Self%& Rhs&. Rhs& self! rhs!) (=>
     %%global_location_label%%16
     (%B (vstd!std_specs.ops.MulSpec.mul_req.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   ))
   :pattern ((req%core!ops.arith.Mul.mul. Self%&. Self%& Rhs&. Rhs& self! rhs!))
   :qid internal_req__core!ops.arith.Mul.mul._definition
   :skolemid skolem_internal_req__core!ops.arith.Mul.mul._definition
)))
(declare-fun ens%core!ops.arith.Mul.mul. (Dcr Type Dcr Type Poly Poly Poly) Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly)
   (ret! Poly)
  ) (!
   (= (ens%core!ops.arith.Mul.mul. Self%&. Self%& Rhs&. Rhs& self! rhs! ret!) (and
     (has_type ret! (proj%core!ops.arith.Mul./Output Self%&. Self%& Rhs&. Rhs&))
     (=>
      (%B (vstd!std_specs.ops.MulSpec.obeys_mul_spec.? Self%&. Self%& Rhs&. Rhs&))
      (= ret! (vstd!std_specs.ops.MulSpec.mul_spec.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   )))
   :pattern ((ens%core!ops.arith.Mul.mul. Self%&. Self%& Rhs&. Rhs& self! rhs! ret!))
   :qid internal_ens__core!ops.arith.Mul.mul._definition
   :skolemid skolem_internal_ens__core!ops.arith.Mul.mul._definition
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

;; Function-Axioms vstd::std_specs::option::is_some
(assert
 (fuel_bool_default fuel%vstd!std_specs.option.is_some.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.option.is_some.)
  (forall ((T&. Dcr) (T& Type) (option! Poly)) (!
    (= (vstd!std_specs.option.is_some.? T&. T& option!) (is-core!option.Option./Some (%Poly%core!option.Option.
       option!
    )))
    :pattern ((vstd!std_specs.option.is_some.? T&. T& option!))
    :qid internal_vstd!std_specs.option.is_some.?_definition
    :skolemid skolem_internal_vstd!std_specs.option.is_some.?_definition
))))

;; Function-Axioms vstd::std_specs::option::is_none
(assert
 (fuel_bool_default fuel%vstd!std_specs.option.is_none.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.option.is_none.)
  (forall ((T&. Dcr) (T& Type) (option! Poly)) (!
    (= (vstd!std_specs.option.is_none.? T&. T& option!) (is-core!option.Option./None (%Poly%core!option.Option.
       option!
    )))
    :pattern ((vstd!std_specs.option.is_none.? T&. T& option!))
    :qid internal_vstd!std_specs.option.is_none.?_definition
    :skolemid skolem_internal_vstd!std_specs.option.is_none.?_definition
))))

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
(declare-const %%global_location_label%%17 Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (option! Poly)) (!
   (= (req%vstd!std_specs.option.spec_unwrap. T&. T& option!) (=>
     %%global_location_label%%17
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

;; Function-Axioms vstd::std_specs::option::spec_unwrap_or
(assert
 (fuel_bool_default fuel%vstd!std_specs.option.spec_unwrap_or.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.option.spec_unwrap_or.)
  (forall ((T&. Dcr) (T& Type) (option! Poly) (default! Poly)) (!
    (= (vstd!std_specs.option.spec_unwrap_or.? T&. T& option! default!) (ite
      (is-core!option.Option./Some (%Poly%core!option.Option. option!))
      (let
       ((t$ (core!option.Option./Some/0 T&. T& (%Poly%core!option.Option. option!))))
       t$
      )
      default!
    ))
    :pattern ((vstd!std_specs.option.spec_unwrap_or.? T&. T& option! default!))
    :qid internal_vstd!std_specs.option.spec_unwrap_or.?_definition
    :skolemid skolem_internal_vstd!std_specs.option.spec_unwrap_or.?_definition
))))
(assert
 (forall ((T&. Dcr) (T& Type) (option! Poly) (default! Poly)) (!
   (=>
    (and
     (has_type option! (TYPE%core!option.Option. T&. T&))
     (has_type default! T&)
    )
    (has_type (vstd!std_specs.option.spec_unwrap_or.? T&. T& option! default!) T&)
   )
   :pattern ((vstd!std_specs.option.spec_unwrap_or.? T&. T& option! default!))
   :qid internal_vstd!std_specs.option.spec_unwrap_or.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.option.spec_unwrap_or.?_pre_post_definition
)))

;; Function-Specs core::option::impl&%5::clone
(declare-fun ens%core!option.impl&%5.clone. (Dcr Type Poly Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (opt! Poly) (res! Poly)) (!
   (= (ens%core!option.impl&%5.clone. T&. T& opt! res!) (and
     (ens%core!clone.Clone.clone. $ (TYPE%core!option.Option. T&. T&) opt! res!)
     (=>
      (is-core!option.Option./None (%Poly%core!option.Option. opt!))
      (is-core!option.Option./None (%Poly%core!option.Option. res!))
     )
     (=>
      (is-core!option.Option./Some (%Poly%core!option.Option. opt!))
      (and
       (is-core!option.Option./Some (%Poly%core!option.Option. res!))
       (vstd!pervasive.cloned.? T&. T& (core!option.Option./Some/0 T&. T& (%Poly%core!option.Option.
          opt!
         )
        ) (core!option.Option./Some/0 T&. T& (%Poly%core!option.Option. res!))
   )))))
   :pattern ((ens%core!option.impl&%5.clone. T&. T& opt! res!))
   :qid internal_ens__core!option.impl&__5.clone._definition
   :skolemid skolem_internal_ens__core!option.impl&__5.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) (TYPE%core!option.Option. T&. T&)))
     (has_type res$ (TYPE%core!option.Option. T&. T&))
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ (TYPE%core!option.Option. T&. T&)) (
       DST (REF $)
      ) (TYPE%tuple%1. (REF $) (TYPE%core!option.Option. T&. T&)) (F fndef_singleton) closure%$
      res$
     )
     (let
      ((opt$ (%Poly%core!option.Option. (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (and
       (=>
        (is-core!option.Option./None opt$)
        (is-core!option.Option./None (%Poly%core!option.Option. res$))
       )
       (=>
        (is-core!option.Option./Some opt$)
        (and
         (is-core!option.Option./Some (%Poly%core!option.Option. res$))
         (vstd!pervasive.cloned.? T&. T& (core!option.Option./Some/0 T&. T& (%Poly%core!option.Option.
            (Poly%core!option.Option. opt$)
           )
          ) (core!option.Option./Some/0 T&. T& (%Poly%core!option.Option. res$))
   )))))))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ (TYPE%core!option.Option. T&.
       T&
      )
     ) (DST (REF $)) (TYPE%tuple%1. (REF $) (TYPE%core!option.Option. T&. T&)) (F fndef_singleton)
     closure%$ res$
   ))
   :qid user_core__option__impl&%5__clone_58
   :skolemid skolem_user_core__option__impl&%5__clone_58
)))

;; Function-Specs core::iter::range::impl&%6::next
(declare-fun ens%core!iter.range.impl&%6.next. (Dcr Type Poly Poly Poly) Bool)
(assert
 (forall ((A&. Dcr) (A& Type) (pre%range! Poly) (range! Poly) (r! Poly)) (!
   (= (ens%core!iter.range.impl&%6.next. A&. A& pre%range! range! r!) (and
     (ens%core!iter.traits.iterator.Iterator.next. $ (TYPE%core!ops.range.Range. A&. A&)
      pre%range! range! r!
     )
     (= (tuple%2./tuple%2 range! r!) (vstd!std_specs.range.spec_range_next.? A&. A& pre%range!))
   ))
   :pattern ((ens%core!iter.range.impl&%6.next. A&. A& pre%range! range! r!))
   :qid internal_ens__core!iter.range.impl&__6.next._definition
   :skolemid skolem_internal_ens__core!iter.range.impl&__6.next._definition
)))

;; Function-Specs alloc::boxed::impl&%13::clone
(declare-fun ens%alloc!boxed.impl&%13.clone. (Dcr Type Dcr Type Poly Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (A&. Dcr) (A& Type) (b! Poly) (res! Poly)) (!
   (= (ens%alloc!boxed.impl&%13.clone. T&. T& A&. A& b! res!) (and
     (ens%core!clone.Clone.clone. (BOX A&. A& T&.) T& b! res!)
     (vstd!pervasive.cloned.? T&. T& b! res!)
   ))
   :pattern ((ens%alloc!boxed.impl&%13.clone. T&. T& A&. A& b! res!))
   :qid internal_ens__alloc!boxed.impl&__13.clone._definition
   :skolemid skolem_internal_ens__alloc!boxed.impl&__13.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly) (T&. Dcr) (T& Type) (A&. Dcr) (A& Type)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF (BOX A&. A& T&.)) T&))
     (has_type res$ T&)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. (BOX A&. A& T&.) T&) (DST (REF (BOX A&. A&
         T&.
       ))
      ) (TYPE%tuple%1. (REF (BOX A&. A& T&.)) T&) (F fndef_singleton) closure%$ res$
     )
     (let
      ((b$ (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$))))
      (vstd!pervasive.cloned.? T&. T& b$ res$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. (BOX A&. A& T&.) T&) (DST (REF
       (BOX A&. A& T&.)
      )
     ) (TYPE%tuple%1. (REF (BOX A&. A& T&.)) T&) (F fndef_singleton) closure%$ res$
   ))
   :qid user_alloc__boxed__impl&%13__clone_59
   :skolemid skolem_user_alloc__boxed__impl&%13__clone_59
)))

;; Function-Specs vstd::array::array_index_get
(declare-fun req%vstd!array.array_index_get. (Dcr Type Dcr Type %%Function%% Int)
 Bool
)
(declare-const %%global_location_label%%18 Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (ar! %%Function%%) (i! Int)) (!
   (= (req%vstd!array.array_index_get. T&. T& N&. N& ar! i!) (=>
     %%global_location_label%%18
     (let
      ((tmp%%$ i!))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ (const_int N&))
   ))))
   :pattern ((req%vstd!array.array_index_get. T&. T& N&. N& ar! i!))
   :qid internal_req__vstd!array.array_index_get._definition
   :skolemid skolem_internal_req__vstd!array.array_index_get._definition
)))
(declare-fun ens%vstd!array.array_index_get. (Dcr Type Dcr Type %%Function%% Int Poly)
 Bool
)
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (ar! %%Function%%) (i! Int) (out! Poly))
  (!
   (= (ens%vstd!array.array_index_get. T&. T& N&. N& ar! i! out!) (and
     (has_type out! T&)
     (= out! (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
        (Poly%array%. ar!)
       ) (I i!)
   ))))
   :pattern ((ens%vstd!array.array_index_get. T&. T& N&. N& ar! i! out!))
   :qid internal_ens__vstd!array.array_index_get._definition
   :skolemid skolem_internal_ens__vstd!array.array_index_get._definition
)))

;; Function-Specs vstd::array::array_as_slice
(declare-fun ens%vstd!array.array_as_slice. (Dcr Type Dcr Type %%Function%% Poly)
 Bool
)
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (ar! %%Function%%) (out! Poly)) (
   !
   (= (ens%vstd!array.array_as_slice. T&. T& N&. N& ar! out!) (and
     (has_type out! (SLICE T&. T&))
     (= (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) (Poly%array%. ar!)) (vstd!view.View.view.?
       $slice (SLICE T&. T&) out!
   ))))
   :pattern ((ens%vstd!array.array_as_slice. T&. T& N&. N& ar! out!))
   :qid internal_ens__vstd!array.array_as_slice._definition
   :skolemid skolem_internal_ens__vstd!array.array_as_slice._definition
)))

;; Function-Specs vstd::array::array_fill_for_copy_types
(declare-fun ens%vstd!array.array_fill_for_copy_types. (Dcr Type Dcr Type Poly %%Function%%)
 Bool
)
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (t! Poly) (res! %%Function%%)) (!
   (= (ens%vstd!array.array_fill_for_copy_types. T&. T& N&. N& t! res!) (and
     (has_type (Poly%array%. res!) (ARRAY T&. T& N&. N&))
     (= res! (vstd!array.spec_array_fill_for_copy_type.? T&. T& N&. N& t!))
   ))
   :pattern ((ens%vstd!array.array_fill_for_copy_types. T&. T& N&. N& t! res!))
   :qid internal_ens__vstd!array.array_fill_for_copy_types._definition
   :skolemid skolem_internal_ens__vstd!array.array_fill_for_copy_types._definition
)))

;; Function-Axioms vstd::pervasive::ForLoopGhostIterator::exec_invariant
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly) (exec_iter! Poly)) (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type exec_iter! (proj%vstd!pervasive.ForLoopGhostIterator./ExecIter Self%&. Self%&))
    )
    (has_type (vstd!pervasive.ForLoopGhostIterator.exec_invariant.? Self%&. Self%& self!
      exec_iter!
     ) BOOL
   ))
   :pattern ((vstd!pervasive.ForLoopGhostIterator.exec_invariant.? Self%&. Self%& self!
     exec_iter!
   ))
   :qid internal_vstd!pervasive.ForLoopGhostIterator.exec_invariant.?_pre_post_definition
   :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.exec_invariant.?_pre_post_definition
)))

;; Function-Axioms vstd::pervasive::ForLoopGhostIterator::ghost_invariant
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly) (init! Poly)) (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type init! (TYPE%core!option.Option. (REF Self%&.) Self%&))
    )
    (has_type (vstd!pervasive.ForLoopGhostIterator.ghost_invariant.? Self%&. Self%& self!
      init!
     ) BOOL
   ))
   :pattern ((vstd!pervasive.ForLoopGhostIterator.ghost_invariant.? Self%&. Self%& self!
     init!
   ))
   :qid internal_vstd!pervasive.ForLoopGhostIterator.ghost_invariant.?_pre_post_definition
   :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.ghost_invariant.?_pre_post_definition
)))

;; Function-Axioms vstd::pervasive::ForLoopGhostIterator::ghost_ensures
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly)) (!
   (=>
    (has_type self! Self%&)
    (has_type (vstd!pervasive.ForLoopGhostIterator.ghost_ensures.? Self%&. Self%& self!)
     BOOL
   ))
   :pattern ((vstd!pervasive.ForLoopGhostIterator.ghost_ensures.? Self%&. Self%& self!))
   :qid internal_vstd!pervasive.ForLoopGhostIterator.ghost_ensures.?_pre_post_definition
   :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.ghost_ensures.?_pre_post_definition
)))

;; Function-Axioms vstd::pervasive::ForLoopGhostIterator::ghost_decrease
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly)) (!
   (=>
    (has_type self! Self%&)
    (has_type (vstd!pervasive.ForLoopGhostIterator.ghost_decrease.? Self%&. Self%& self!)
     (TYPE%core!option.Option. (proj%%vstd!pervasive.ForLoopGhostIterator./Decrease Self%&.
       Self%&
      ) (proj%vstd!pervasive.ForLoopGhostIterator./Decrease Self%&. Self%&)
   )))
   :pattern ((vstd!pervasive.ForLoopGhostIterator.ghost_decrease.? Self%&. Self%& self!))
   :qid internal_vstd!pervasive.ForLoopGhostIterator.ghost_decrease.?_pre_post_definition
   :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.ghost_decrease.?_pre_post_definition
)))

;; Function-Axioms vstd::pervasive::ForLoopGhostIterator::ghost_peek_next
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly)) (!
   (=>
    (has_type self! Self%&)
    (has_type (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.? Self%&. Self%& self!)
     (TYPE%core!option.Option. (proj%%vstd!pervasive.ForLoopGhostIterator./Item Self%&.
       Self%&
      ) (proj%vstd!pervasive.ForLoopGhostIterator./Item Self%&. Self%&)
   )))
   :pattern ((vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.? Self%&. Self%& self!))
   :qid internal_vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?_pre_post_definition
   :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?_pre_post_definition
)))

;; Function-Axioms vstd::pervasive::ForLoopGhostIterator::ghost_advance
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly) (exec_iter! Poly)) (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type exec_iter! (proj%vstd!pervasive.ForLoopGhostIterator./ExecIter Self%&. Self%&))
    )
    (has_type (vstd!pervasive.ForLoopGhostIterator.ghost_advance.? Self%&. Self%& self!
      exec_iter!
     ) Self%&
   ))
   :pattern ((vstd!pervasive.ForLoopGhostIterator.ghost_advance.? Self%&. Self%& self!
     exec_iter!
   ))
   :qid internal_vstd!pervasive.ForLoopGhostIterator.ghost_advance.?_pre_post_definition
   :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.ghost_advance.?_pre_post_definition
)))

;; Function-Axioms vstd::pervasive::ForLoopGhostIteratorNew::ghost_iter
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly)) (!
   (=>
    (has_type self! Self%&)
    (has_type (vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter.? Self%&. Self%& self!)
     (proj%vstd!pervasive.ForLoopGhostIteratorNew./GhostIter Self%&. Self%&)
   ))
   :pattern ((vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter.? Self%&. Self%& self!))
   :qid internal_vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter.?_pre_post_definition
   :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter.?_pre_post_definition
)))

;; Function-Axioms vstd::pervasive::arbitrary
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (has_type (vstd!pervasive.arbitrary.? A&. A&) A&)
   :pattern ((vstd!pervasive.arbitrary.? A&. A&))
   :qid internal_vstd!pervasive.arbitrary.?_pre_post_definition
   :skolemid skolem_internal_vstd!pervasive.arbitrary.?_pre_post_definition
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

;; Function-Specs vstd::slice::slice_index_get
(declare-fun req%vstd!slice.slice_index_get. (Dcr Type Poly Int) Bool)
(declare-const %%global_location_label%%19 Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (slice! Poly) (i! Int)) (!
   (= (req%vstd!slice.slice_index_get. T&. T& slice! i!) (=>
     %%global_location_label%%19
     (let
      ((tmp%%$ i!))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ (vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&) slice!)))
   ))))
   :pattern ((req%vstd!slice.slice_index_get. T&. T& slice! i!))
   :qid internal_req__vstd!slice.slice_index_get._definition
   :skolemid skolem_internal_req__vstd!slice.slice_index_get._definition
)))
(declare-fun ens%vstd!slice.slice_index_get. (Dcr Type Poly Int Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (slice! Poly) (i! Int) (out! Poly)) (!
   (= (ens%vstd!slice.slice_index_get. T&. T& slice! i! out!) (and
     (has_type out! T&)
     (= out! (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&) slice!)
       (I i!)
   ))))
   :pattern ((ens%vstd!slice.slice_index_get. T&. T& slice! i! out!))
   :qid internal_ens__vstd!slice.slice_index_get._definition
   :skolemid skolem_internal_ens__vstd!slice.slice_index_get._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::field::FieldElement51::fmt
(declare-fun ens%curve25519_dalek!backend.serial.u64.field.impl&%2.fmt. (curve25519_dalek!backend.serial.u64.field.FieldElement51.
  core!fmt.Formatter. core!fmt.Formatter. core!result.Result.
 ) Bool
)
(assert
 (forall ((self! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (pre%f! core!fmt.Formatter.)
   (f! core!fmt.Formatter.) (%return! core!result.Result.)
  ) (!
   (= (ens%curve25519_dalek!backend.serial.u64.field.impl&%2.fmt. self! pre%f! f! %return!)
    (has_type (Poly%core!result.Result. %return!) (TYPE%core!result.Result. $ TYPE%tuple%0.
      $ TYPE%core!fmt.Error.
   )))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.field.impl&%2.fmt. self! pre%f!
     f! %return!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__2.fmt._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__2.fmt._definition
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

;; Function-Specs curve25519_dalek::backend::serial::u64::subtle_assumes::conditional_select_u64
(declare-fun ens%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_select_u64.
 (Int Int subtle!Choice. Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (choice! subtle!Choice.) (res! Int)) (!
   (= (ens%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_select_u64.
     a! b! choice! res!
    ) (and
     (uInv 64 res!)
     (=>
      (not (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
         choice!
      )))
      (= res! a!)
     )
     (=>
      (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
        choice!
      ))
      (= res! b!)
   )))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_select_u64.
     a! b! choice! res!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_select_u64._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_select_u64._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::subtle_assumes::conditional_swap_u64
(declare-fun ens%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_swap_u64.
 (Int Int Int Int subtle!Choice.) Bool
)
(assert
 (forall ((pre%a! Int) (a! Int) (pre%b! Int) (b! Int) (choice! subtle!Choice.)) (!
   (= (ens%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_swap_u64. pre%a!
     a! pre%b! b! choice!
    ) (and
     (uInv 64 a!)
     (uInv 64 b!)
     (=>
      (not (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
         choice!
      )))
      (and
       (= a! pre%a!)
       (= b! pre%b!)
     ))
     (=>
      (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
        choice!
      ))
      (and
       (= a! pre%b!)
       (= b! pre%a!)
   ))))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_swap_u64.
     pre%a! a! pre%b! b! choice!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_swap_u64._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_swap_u64._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::subtle_assumes::conditional_assign_u64
(declare-fun ens%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_assign_u64.
 (Int Int Int subtle!Choice.) Bool
)
(assert
 (forall ((pre%a! Int) (a! Int) (b! Int) (choice! subtle!Choice.)) (!
   (= (ens%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_assign_u64.
     pre%a! a! b! choice!
    ) (and
     (uInv 64 a!)
     (=>
      (not (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
         choice!
      )))
      (= a! pre%a!)
     )
     (=>
      (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
        choice!
      ))
      (= a! b!)
   )))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_assign_u64.
     pre%a! a! b! choice!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_assign_u64._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.subtle_assumes.conditional_assign_u64._definition
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
       :qid user_curve25519_dalek__specs__field_specs__u64_5_bounded_60
       :skolemid skolem_user_curve25519_dalek__specs__field_specs__u64_5_bounded_60
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

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::spec_reduce
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.spec_reduce.)
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
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.spec_reduce.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.spec_reduce.? limbs!) (let
      ((r$ (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I (uClip 64 (Add (uClip 64 (bitand
                (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                     (CONST_INT 5)
                    ) limbs!
                   ) (I 0)
                 ))
                ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
               )
              ) (Mul (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                     $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                    ) (I 4)
                  ))
                 ) (I 51)
                )
               ) 19
            )))
           ) (I (uClip 64 (Add (uClip 64 (bitand (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                    $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                   ) (I 1)
                 ))
                ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
               )
              ) (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
                     ARRAY $ (UINT 64) $ (CONST_INT 5)
                    ) limbs!
                   ) (I 0)
                 ))
                ) (I 51)
            ))))
           ) (I (uClip 64 (Add (uClip 64 (bitand (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                    $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                   ) (I 2)
                 ))
                ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
               )
              ) (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
                     ARRAY $ (UINT 64) $ (CONST_INT 5)
                    ) limbs!
                   ) (I 1)
                 ))
                ) (I 51)
            ))))
           ) (I (uClip 64 (Add (uClip 64 (bitand (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                    $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                   ) (I 3)
                 ))
                ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
               )
              ) (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
                     ARRAY $ (UINT 64) $ (CONST_INT 5)
                    ) limbs!
                   ) (I 2)
                 ))
                ) (I 51)
            ))))
           ) (I (uClip 64 (Add (uClip 64 (bitand (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                    $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                   ) (I 4)
                 ))
                ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
               )
              ) (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
                     ARRAY $ (UINT 64) $ (CONST_INT 5)
                    ) limbs!
                   ) (I 3)
                 ))
                ) (I 51)
      ))))))))))
      r$
    ))
    :pattern ((curve25519_dalek!specs.field_specs_u64.spec_reduce.? limbs!))
    :qid internal_curve25519_dalek!specs.field_specs_u64.spec_reduce.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.spec_reduce.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (has_type (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_reduce.? limbs!))
     (ARRAY $ (UINT 64) $ (CONST_INT 5))
   ))
   :pattern ((curve25519_dalek!specs.field_specs_u64.spec_reduce.? limbs!))
   :qid internal_curve25519_dalek!specs.field_specs_u64.spec_reduce.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.spec_reduce.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::sixteen_p_vec
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.)
  (= curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.? (%Poly%array%. (array_new
     $ (UINT 64) 5 (%%array%%0 (I 36028797018963664) (I 36028797018963952) (I 36028797018963952)
      (I 36028797018963952) (I 36028797018963952)
))))))
(assert
 (has_type (Poly%array%. curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.?) (ARRAY
   $ (UINT 64) $ (CONST_INT 5)
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::pre_reduce_limbs
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.? limbs!) (let
      ((r$ (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I (uClip 64 (Sub (%I (vstd!seq.Seq.index.?
                $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
                  curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.?
                 )
                ) (I 0)
               )
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) limbs!
                ) (I 0)
            ))))
           ) (I (uClip 64 (Sub (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                  $ (UINT 64) $ (CONST_INT 5)
                 ) (Poly%array%. curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.?)
                ) (I 1)
               )
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) limbs!
                ) (I 1)
            ))))
           ) (I (uClip 64 (Sub (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                  $ (UINT 64) $ (CONST_INT 5)
                 ) (Poly%array%. curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.?)
                ) (I 2)
               )
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) limbs!
                ) (I 2)
            ))))
           ) (I (uClip 64 (Sub (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                  $ (UINT 64) $ (CONST_INT 5)
                 ) (Poly%array%. curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.?)
                ) (I 3)
               )
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) limbs!
                ) (I 3)
            ))))
           ) (I (uClip 64 (Sub (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                  $ (UINT 64) $ (CONST_INT 5)
                 ) (Poly%array%. curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.?)
                ) (I 4)
               )
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) limbs!
                ) (I 4)
      ))))))))))
      r$
    ))
    :pattern ((curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.? limbs!))
    :qid internal_curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (has_type (Poly%array%. (curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.? limbs!))
     (ARRAY $ (UINT 64) $ (CONST_INT 5))
   ))
   :pattern ((curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.? limbs!))
   :qid internal_curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::spec_negate
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.spec_negate.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.spec_negate.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.spec_negate.? limbs!) (let
      ((r$ (curve25519_dalek!specs.field_specs_u64.spec_reduce.? (Poly%array%. (curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.?
           limbs!
      )))))
      r$
    ))
    :pattern ((curve25519_dalek!specs.field_specs_u64.spec_negate.? limbs!))
    :qid internal_curve25519_dalek!specs.field_specs_u64.spec_negate.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.spec_negate.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (has_type (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_negate.? limbs!))
     (ARRAY $ (UINT 64) $ (CONST_INT 5))
   ))
   :pattern ((curve25519_dalek!specs.field_specs_u64.spec_negate.? limbs!))
   :qid internal_curve25519_dalek!specs.field_specs_u64.spec_negate.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.spec_negate.?_pre_post_definition
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
       :qid user_curve25519_dalek__specs__field_specs__sum_of_limbs_bounded_61
       :skolemid skolem_user_curve25519_dalek__specs__field_specs__sum_of_limbs_bounded_61
    )))
    :pattern ((curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? fe1! fe2! bound!))
    :qid internal_curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.?_definition
))))

;; Function-Specs curve25519_dalek::core_assumes::zeroize_limbs5
(declare-fun ens%curve25519_dalek!core_assumes.zeroize_limbs5. (%%Function%% %%Function%%)
 Bool
)
(assert
 (forall ((pre%limbs! %%Function%%) (limbs! %%Function%%)) (!
   (= (ens%curve25519_dalek!core_assumes.zeroize_limbs5. pre%limbs! limbs!) (and
     (has_type (Poly%array%. limbs!) (ARRAY $ (UINT 64) $ (CONST_INT 5)))
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
         (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) (Poly%array%. limbs!)
            ) i$
           )
          ) 0
       )))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) (Poly%array%. limbs!)
         ) i$
       ))
       :qid user_curve25519_dalek__core_assumes__zeroize_limbs5_62
       :skolemid skolem_user_curve25519_dalek__core_assumes__zeroize_limbs5_62
   ))))
   :pattern ((ens%curve25519_dalek!core_assumes.zeroize_limbs5. pre%limbs! limbs!))
   :qid internal_ens__curve25519_dalek!core_assumes.zeroize_limbs5._definition
   :skolemid skolem_internal_ens__curve25519_dalek!core_assumes.zeroize_limbs5._definition
)))

;; Function-Axioms vstd::std_specs::core::iter_into_iter_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.core.iter_into_iter_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.core.iter_into_iter_spec.)
  (forall ((I&. Dcr) (I& Type) (i! Poly)) (!
    (= (vstd!std_specs.core.iter_into_iter_spec.? I&. I& i!) i!)
    :pattern ((vstd!std_specs.core.iter_into_iter_spec.? I&. I& i!))
    :qid internal_vstd!std_specs.core.iter_into_iter_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.core.iter_into_iter_spec.?_definition
))))
(assert
 (forall ((I&. Dcr) (I& Type) (i! Poly)) (!
   (=>
    (has_type i! I&)
    (has_type (vstd!std_specs.core.iter_into_iter_spec.? I&. I& i!) I&)
   )
   :pattern ((vstd!std_specs.core.iter_into_iter_spec.? I&. I& i!))
   :qid internal_vstd!std_specs.core.iter_into_iter_spec.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.core.iter_into_iter_spec.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::ops::impl&%15::obeys_neg_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%15.obeys_neg_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%15.obeys_neg_spec.)
  (= (vstd!std_specs.ops.NegSpec.obeys_neg_spec.? $ (SINT 32)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%15::neg_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%15.neg_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%15.neg_req.)
  (forall ((self! Poly)) (!
    (= (vstd!std_specs.ops.NegSpec.neg_req.? $ (SINT 32) self!) (B (= (iClip 32 (Sub 0 (%I
          self!
        ))
       ) (Sub 0 (%I self!))
    )))
    :pattern ((vstd!std_specs.ops.NegSpec.neg_req.? $ (SINT 32) self!))
    :qid internal_vstd!std_specs.ops.NegSpec.neg_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.NegSpec.neg_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%15::neg_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%15.neg_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%15.neg_spec.)
  (forall ((self! Poly)) (!
    (= (vstd!std_specs.ops.NegSpec.neg_spec.? $ (SINT 32) self!) (I (iClip 32 (Sub 0 (%I self!)))))
    :pattern ((vstd!std_specs.ops.NegSpec.neg_spec.? $ (SINT 32) self!))
    :qid internal_vstd!std_specs.ops.NegSpec.neg_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.NegSpec.neg_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%31::obeys_add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%31.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%31.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? $ USIZE $ USIZE) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%31::add_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%31.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%31.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? $ USIZE $ USIZE self! rhs!) (B (= (uClip SZ
        (Add (%I self!) (%I rhs!))
       ) (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? $ USIZE $ USIZE self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%31::add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%31.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%31.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? $ USIZE $ USIZE self! rhs!) (I (uClip SZ (
        Add (%I self!) (%I rhs!)
    ))))
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? $ USIZE $ USIZE self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%32::obeys_add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%32.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%32.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? $ (UINT 8) $ (UINT 8)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%32::add_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%32.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%32.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? $ (UINT 8) $ (UINT 8) self! rhs!) (B (= (uClip
        8 (Add (%I self!) (%I rhs!))
       ) (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? $ (UINT 8) $ (UINT 8) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%32::add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%32.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%32.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? $ (UINT 8) $ (UINT 8) self! rhs!) (I (uClip
       8 (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? $ (UINT 8) $ (UINT 8) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%34::obeys_add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%34.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%34.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? $ (UINT 32) $ (UINT 32)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%34::add_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%34.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%34.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? $ (UINT 32) $ (UINT 32) self! rhs!) (B (= (
        uClip 32 (Add (%I self!) (%I rhs!))
       ) (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? $ (UINT 32) $ (UINT 32) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%34::add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%34.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%34.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? $ (UINT 32) $ (UINT 32) self! rhs!) (I (uClip
       32 (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? $ (UINT 32) $ (UINT 32) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%35::obeys_add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%35.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%35.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? $ (UINT 64) $ (UINT 64)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%35::add_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%35.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%35.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? $ (UINT 64) $ (UINT 64) self! rhs!) (B (= (
        uClip 64 (Add (%I self!) (%I rhs!))
       ) (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? $ (UINT 64) $ (UINT 64) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%35::add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%35.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%35.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? $ (UINT 64) $ (UINT 64) self! rhs!) (I (uClip
       64 (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? $ (UINT 64) $ (UINT 64) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%36::obeys_add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%36.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%36.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? $ (UINT 128) $ (UINT 128)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%36::add_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%36.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%36.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? $ (UINT 128) $ (UINT 128) self! rhs!) (B (
       = (uClip 128 (Add (%I self!) (%I rhs!))) (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? $ (UINT 128) $ (UINT 128) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%36::add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%36.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%36.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? $ (UINT 128) $ (UINT 128) self! rhs!) (I
      (uClip 128 (Add (%I self!) (%I rhs!)))
    ))
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? $ (UINT 128) $ (UINT 128) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%40::obeys_add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%40.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%40.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? $ (SINT 32) $ (SINT 32)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%40::add_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%40.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%40.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? $ (SINT 32) $ (SINT 32) self! rhs!) (B (= (
        iClip 32 (Add (%I self!) (%I rhs!))
       ) (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? $ (SINT 32) $ (SINT 32) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%40::add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%40.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%40.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? $ (SINT 32) $ (SINT 32) self! rhs!) (I (iClip
       32 (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? $ (SINT 32) $ (SINT 32) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%43::obeys_sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%43.obeys_sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%43.obeys_sub_spec.)
  (= (vstd!std_specs.ops.SubSpec.obeys_sub_spec.? $ USIZE $ USIZE) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%43::sub_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%43.sub_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%43.sub_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_req.? $ USIZE $ USIZE self! rhs!) (B (= (uClip SZ
        (Sub (%I self!) (%I rhs!))
       ) (Sub (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_req.? $ USIZE $ USIZE self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%43::sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%43.sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%43.sub_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_spec.? $ USIZE $ USIZE self! rhs!) (I (uClip SZ (
        Sub (%I self!) (%I rhs!)
    ))))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_spec.? $ USIZE $ USIZE self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%44::obeys_sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%44.obeys_sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%44.obeys_sub_spec.)
  (= (vstd!std_specs.ops.SubSpec.obeys_sub_spec.? $ (UINT 8) $ (UINT 8)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%44::sub_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%44.sub_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%44.sub_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_req.? $ (UINT 8) $ (UINT 8) self! rhs!) (B (= (uClip
        8 (Sub (%I self!) (%I rhs!))
       ) (Sub (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_req.? $ (UINT 8) $ (UINT 8) self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%44::sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%44.sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%44.sub_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_spec.? $ (UINT 8) $ (UINT 8) self! rhs!) (I (uClip
       8 (Sub (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_spec.? $ (UINT 8) $ (UINT 8) self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%46::obeys_sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%46.obeys_sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%46.obeys_sub_spec.)
  (= (vstd!std_specs.ops.SubSpec.obeys_sub_spec.? $ (UINT 32) $ (UINT 32)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%46::sub_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%46.sub_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%46.sub_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_req.? $ (UINT 32) $ (UINT 32) self! rhs!) (B (= (
        uClip 32 (Sub (%I self!) (%I rhs!))
       ) (Sub (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_req.? $ (UINT 32) $ (UINT 32) self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%46::sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%46.sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%46.sub_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_spec.? $ (UINT 32) $ (UINT 32) self! rhs!) (I (uClip
       32 (Sub (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_spec.? $ (UINT 32) $ (UINT 32) self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%47::obeys_sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%47.obeys_sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%47.obeys_sub_spec.)
  (= (vstd!std_specs.ops.SubSpec.obeys_sub_spec.? $ (UINT 64) $ (UINT 64)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%47::sub_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%47.sub_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%47.sub_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_req.? $ (UINT 64) $ (UINT 64) self! rhs!) (B (= (
        uClip 64 (Sub (%I self!) (%I rhs!))
       ) (Sub (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_req.? $ (UINT 64) $ (UINT 64) self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%47::sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%47.sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%47.sub_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_spec.? $ (UINT 64) $ (UINT 64) self! rhs!) (I (uClip
       64 (Sub (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_spec.? $ (UINT 64) $ (UINT 64) self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%48::obeys_sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%48.obeys_sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%48.obeys_sub_spec.)
  (= (vstd!std_specs.ops.SubSpec.obeys_sub_spec.? $ (UINT 128) $ (UINT 128)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%48::sub_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%48.sub_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%48.sub_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_req.? $ (UINT 128) $ (UINT 128) self! rhs!) (B (
       = (uClip 128 (Sub (%I self!) (%I rhs!))) (Sub (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_req.? $ (UINT 128) $ (UINT 128) self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%48::sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%48.sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%48.sub_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_spec.? $ (UINT 128) $ (UINT 128) self! rhs!) (I
      (uClip 128 (Sub (%I self!) (%I rhs!)))
    ))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_spec.? $ (UINT 128) $ (UINT 128) self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%52::obeys_sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%52.obeys_sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%52.obeys_sub_spec.)
  (= (vstd!std_specs.ops.SubSpec.obeys_sub_spec.? $ (SINT 32) $ (SINT 32)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%52::sub_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%52.sub_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%52.sub_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_req.? $ (SINT 32) $ (SINT 32) self! rhs!) (B (= (
        iClip 32 (Sub (%I self!) (%I rhs!))
       ) (Sub (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_req.? $ (SINT 32) $ (SINT 32) self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%52::sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%52.sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%52.sub_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_spec.? $ (SINT 32) $ (SINT 32) self! rhs!) (I (iClip
       32 (Sub (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_spec.? $ (SINT 32) $ (SINT 32) self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%55::obeys_mul_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%55.obeys_mul_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%55.obeys_mul_spec.)
  (= (vstd!std_specs.ops.MulSpec.obeys_mul_spec.? $ USIZE $ USIZE) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%55::mul_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%55.mul_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%55.mul_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.MulSpec.mul_req.? $ USIZE $ USIZE self! rhs!) (B (= (uClip SZ
        (Mul (%I self!) (%I rhs!))
       ) (Mul (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.MulSpec.mul_req.? $ USIZE $ USIZE self! rhs!))
    :qid internal_vstd!std_specs.ops.MulSpec.mul_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.MulSpec.mul_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%55::mul_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%55.mul_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%55.mul_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.MulSpec.mul_spec.? $ USIZE $ USIZE self! rhs!) (I (uClip SZ (
        Mul (%I self!) (%I rhs!)
    ))))
    :pattern ((vstd!std_specs.ops.MulSpec.mul_spec.? $ USIZE $ USIZE self! rhs!))
    :qid internal_vstd!std_specs.ops.MulSpec.mul_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.MulSpec.mul_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%56::obeys_mul_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%56.obeys_mul_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%56.obeys_mul_spec.)
  (= (vstd!std_specs.ops.MulSpec.obeys_mul_spec.? $ (UINT 8) $ (UINT 8)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%56::mul_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%56.mul_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%56.mul_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.MulSpec.mul_req.? $ (UINT 8) $ (UINT 8) self! rhs!) (B (= (uClip
        8 (Mul (%I self!) (%I rhs!))
       ) (Mul (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.MulSpec.mul_req.? $ (UINT 8) $ (UINT 8) self! rhs!))
    :qid internal_vstd!std_specs.ops.MulSpec.mul_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.MulSpec.mul_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%56::mul_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%56.mul_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%56.mul_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.MulSpec.mul_spec.? $ (UINT 8) $ (UINT 8) self! rhs!) (I (uClip
       8 (Mul (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.MulSpec.mul_spec.? $ (UINT 8) $ (UINT 8) self! rhs!))
    :qid internal_vstd!std_specs.ops.MulSpec.mul_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.MulSpec.mul_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%58::obeys_mul_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%58.obeys_mul_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%58.obeys_mul_spec.)
  (= (vstd!std_specs.ops.MulSpec.obeys_mul_spec.? $ (UINT 32) $ (UINT 32)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%58::mul_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%58.mul_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%58.mul_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.MulSpec.mul_req.? $ (UINT 32) $ (UINT 32) self! rhs!) (B (= (
        uClip 32 (Mul (%I self!) (%I rhs!))
       ) (Mul (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.MulSpec.mul_req.? $ (UINT 32) $ (UINT 32) self! rhs!))
    :qid internal_vstd!std_specs.ops.MulSpec.mul_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.MulSpec.mul_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%58::mul_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%58.mul_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%58.mul_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.MulSpec.mul_spec.? $ (UINT 32) $ (UINT 32) self! rhs!) (I (uClip
       32 (Mul (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.MulSpec.mul_spec.? $ (UINT 32) $ (UINT 32) self! rhs!))
    :qid internal_vstd!std_specs.ops.MulSpec.mul_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.MulSpec.mul_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%59::obeys_mul_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%59.obeys_mul_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%59.obeys_mul_spec.)
  (= (vstd!std_specs.ops.MulSpec.obeys_mul_spec.? $ (UINT 64) $ (UINT 64)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%59::mul_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%59.mul_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%59.mul_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.MulSpec.mul_req.? $ (UINT 64) $ (UINT 64) self! rhs!) (B (= (
        uClip 64 (Mul (%I self!) (%I rhs!))
       ) (Mul (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.MulSpec.mul_req.? $ (UINT 64) $ (UINT 64) self! rhs!))
    :qid internal_vstd!std_specs.ops.MulSpec.mul_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.MulSpec.mul_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%59::mul_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%59.mul_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%59.mul_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.MulSpec.mul_spec.? $ (UINT 64) $ (UINT 64) self! rhs!) (I (uClip
       64 (Mul (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.MulSpec.mul_spec.? $ (UINT 64) $ (UINT 64) self! rhs!))
    :qid internal_vstd!std_specs.ops.MulSpec.mul_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.MulSpec.mul_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%60::obeys_mul_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%60.obeys_mul_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%60.obeys_mul_spec.)
  (= (vstd!std_specs.ops.MulSpec.obeys_mul_spec.? $ (UINT 128) $ (UINT 128)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%60::mul_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%60.mul_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%60.mul_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.MulSpec.mul_req.? $ (UINT 128) $ (UINT 128) self! rhs!) (B (
       = (uClip 128 (Mul (%I self!) (%I rhs!))) (Mul (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.MulSpec.mul_req.? $ (UINT 128) $ (UINT 128) self! rhs!))
    :qid internal_vstd!std_specs.ops.MulSpec.mul_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.MulSpec.mul_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%60::mul_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%60.mul_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%60.mul_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.MulSpec.mul_spec.? $ (UINT 128) $ (UINT 128) self! rhs!) (I
      (uClip 128 (Mul (%I self!) (%I rhs!)))
    ))
    :pattern ((vstd!std_specs.ops.MulSpec.mul_spec.? $ (UINT 128) $ (UINT 128) self! rhs!))
    :qid internal_vstd!std_specs.ops.MulSpec.mul_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.MulSpec.mul_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%64::obeys_mul_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%64.obeys_mul_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%64.obeys_mul_spec.)
  (= (vstd!std_specs.ops.MulSpec.obeys_mul_spec.? $ (SINT 32) $ (SINT 32)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%64::mul_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%64.mul_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%64.mul_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.MulSpec.mul_req.? $ (SINT 32) $ (SINT 32) self! rhs!) (B (= (
        iClip 32 (Mul (%I self!) (%I rhs!))
       ) (Mul (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.MulSpec.mul_req.? $ (SINT 32) $ (SINT 32) self! rhs!))
    :qid internal_vstd!std_specs.ops.MulSpec.mul_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.MulSpec.mul_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%64::mul_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%64.mul_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%64.mul_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.MulSpec.mul_spec.? $ (SINT 32) $ (SINT 32) self! rhs!) (I (iClip
       32 (Mul (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.MulSpec.mul_spec.? $ (SINT 32) $ (SINT 32) self! rhs!))
    :qid internal_vstd!std_specs.ops.MulSpec.mul_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.MulSpec.mul_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%3::ghost_iter
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%3.ghost_iter.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%3.ghost_iter.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
     )
     (= (vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter.? $ (TYPE%core!ops.range.Range.
        A&. A&
       ) self!
      ) (Poly%vstd!std_specs.range.RangeGhostIterator. (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator
        (core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. self!)) (core!ops.range.Range./Range/start
         (%Poly%core!ops.range.Range. self!)
        ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. self!))
    ))))
    :pattern ((vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter.? $ (TYPE%core!ops.range.Range.
       A&. A&
      ) self!
    ))
    :qid internal_vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter.?_definition
    :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%4::exec_invariant
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%4.exec_invariant.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%4.exec_invariant.)
  (forall ((A&. Dcr) (A& Type) (self! Poly) (exec_iter! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
      (tr_bound%core!iter.range.Step. A&. A&)
     )
     (= (vstd!pervasive.ForLoopGhostIterator.exec_invariant.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
        A&. A&
       ) self! exec_iter!
      ) (B (and
        (= (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (%Poly%vstd!std_specs.range.RangeGhostIterator.
           self!
          )
         ) (core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. exec_iter!))
        )
        (= (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (%Poly%vstd!std_specs.range.RangeGhostIterator.
           self!
          )
         ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. exec_iter!))
    )))))
    :pattern ((vstd!pervasive.ForLoopGhostIterator.exec_invariant.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
       A&. A&
      ) self! exec_iter!
    ))
    :qid internal_vstd!pervasive.ForLoopGhostIterator.exec_invariant.?_definition
    :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.exec_invariant.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%4::ghost_invariant
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%4.ghost_invariant.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%4.ghost_invariant.)
  (forall ((A&. Dcr) (A& Type) (self! Poly) (init! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
      (tr_bound%core!iter.range.Step. A&. A&)
     )
     (= (vstd!pervasive.ForLoopGhostIterator.ghost_invariant.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
        A&. A&
       ) self! init!
      ) (B (and
        (and
         (or
          (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? A&. A& (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start
             (%Poly%vstd!std_specs.range.RangeGhostIterator. self!)
            ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (%Poly%vstd!std_specs.range.RangeGhostIterator.
              self!
          ))))
          (= (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start (%Poly%vstd!std_specs.range.RangeGhostIterator.
             self!
            )
           ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (%Poly%vstd!std_specs.range.RangeGhostIterator.
             self!
         ))))
         (or
          (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? A&. A& (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur
             (%Poly%vstd!std_specs.range.RangeGhostIterator. self!)
            ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (%Poly%vstd!std_specs.range.RangeGhostIterator.
              self!
          ))))
          (= (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (%Poly%vstd!std_specs.range.RangeGhostIterator.
             self!
            )
           ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (%Poly%vstd!std_specs.range.RangeGhostIterator.
             self!
        )))))
        (=>
         (is-core!option.Option./Some (%Poly%core!option.Option. init!))
         (let
          ((init$ (%Poly%vstd!std_specs.range.RangeGhostIterator. (core!option.Option./Some/0 (
               REF $
              ) (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&) (%Poly%core!option.Option.
               init!
          )))))
          (and
           (and
            (= (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start (%Poly%vstd!std_specs.range.RangeGhostIterator.
               (Poly%vstd!std_specs.range.RangeGhostIterator. init$)
              )
             ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (%Poly%vstd!std_specs.range.RangeGhostIterator.
               (Poly%vstd!std_specs.range.RangeGhostIterator. init$)
            )))
            (= (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start (%Poly%vstd!std_specs.range.RangeGhostIterator.
               (Poly%vstd!std_specs.range.RangeGhostIterator. init$)
              )
             ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start (%Poly%vstd!std_specs.range.RangeGhostIterator.
               self!
           ))))
           (= (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (%Poly%vstd!std_specs.range.RangeGhostIterator.
              (Poly%vstd!std_specs.range.RangeGhostIterator. init$)
             )
            ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (%Poly%vstd!std_specs.range.RangeGhostIterator.
              self!
    ))))))))))
    :pattern ((vstd!pervasive.ForLoopGhostIterator.ghost_invariant.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
       A&. A&
      ) self! init!
    ))
    :qid internal_vstd!pervasive.ForLoopGhostIterator.ghost_invariant.?_definition
    :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.ghost_invariant.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%4::ghost_ensures
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%4.ghost_ensures.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%4.ghost_ensures.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
      (tr_bound%core!iter.range.Step. A&. A&)
     )
     (= (vstd!pervasive.ForLoopGhostIterator.ghost_ensures.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
        A&. A&
       ) self!
      ) (B (not (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? A&. A& (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur
           (%Poly%vstd!std_specs.range.RangeGhostIterator. self!)
          ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (%Poly%vstd!std_specs.range.RangeGhostIterator.
            self!
    ))))))))
    :pattern ((vstd!pervasive.ForLoopGhostIterator.ghost_ensures.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
       A&. A&
      ) self!
    ))
    :qid internal_vstd!pervasive.ForLoopGhostIterator.ghost_ensures.?_definition
    :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.ghost_ensures.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%4::ghost_decrease
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%4.ghost_decrease.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%4.ghost_decrease.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
      (tr_bound%core!iter.range.Step. A&. A&)
     )
     (= (vstd!pervasive.ForLoopGhostIterator.ghost_decrease.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
        A&. A&
       ) self!
      ) (Poly%core!option.Option. (core!option.Option./Some (vstd!std_specs.range.StepSpec.spec_steps_between_int.?
         A&. A& (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (%Poly%vstd!std_specs.range.RangeGhostIterator.
           self!
          )
         ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (%Poly%vstd!std_specs.range.RangeGhostIterator.
           self!
    )))))))
    :pattern ((vstd!pervasive.ForLoopGhostIterator.ghost_decrease.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
       A&. A&
      ) self!
    ))
    :qid internal_vstd!pervasive.ForLoopGhostIterator.ghost_decrease.?_definition
    :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.ghost_decrease.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%4::ghost_peek_next
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%4.ghost_peek_next.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%4.ghost_peek_next.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
      (tr_bound%core!iter.range.Step. A&. A&)
     )
     (= (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
        A&. A&
       ) self!
      ) (Poly%core!option.Option. (core!option.Option./Some (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur
         (%Poly%vstd!std_specs.range.RangeGhostIterator. self!)
    )))))
    :pattern ((vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
       A&. A&
      ) self!
    ))
    :qid internal_vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?_definition
    :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%4::ghost_advance
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%4.ghost_advance.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%4.ghost_advance.)
  (forall ((A&. Dcr) (A& Type) (self! Poly) (_exec_iter! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
      (tr_bound%core!iter.range.Step. A&. A&)
     )
     (= (vstd!pervasive.ForLoopGhostIterator.ghost_advance.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
        A&. A&
       ) self! _exec_iter!
      ) (Poly%vstd!std_specs.range.RangeGhostIterator. (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator
        (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start (%Poly%vstd!std_specs.range.RangeGhostIterator.
          self!
         )
        ) (core!option.Option./Some/0 A&. A& (%Poly%core!option.Option. (vstd!std_specs.range.StepSpec.spec_forward_checked.?
           A&. A& (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (%Poly%vstd!std_specs.range.RangeGhostIterator.
             self!
            )
           ) (I 1)
         ))
        ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (%Poly%vstd!std_specs.range.RangeGhostIterator.
          self!
    ))))))
    :pattern ((vstd!pervasive.ForLoopGhostIterator.ghost_advance.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
       A&. A&
      ) self! _exec_iter!
    ))
    :qid internal_vstd!pervasive.ForLoopGhostIterator.ghost_advance.?_definition
    :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.ghost_advance.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%5::view
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%5.view.)
)
(declare-fun %%lambda%%1 (Dcr Type Poly Dcr Type) %%Function%%)
(assert
 (forall ((%%hole%%0 Dcr) (%%hole%%1 Type) (%%hole%%2 Poly) (%%hole%%3 Dcr) (%%hole%%4
    Type
   ) (i$ Poly)
  ) (!
   (= (%%apply%%0 (%%lambda%%1 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4) i$)
    (core!option.Option./Some/0 %%hole%%3 %%hole%%4 (%Poly%core!option.Option. (vstd!std_specs.range.StepSpec.spec_forward_checked_int.?
       %%hole%%0 %%hole%%1 %%hole%%2 i$
   ))))
   :pattern ((%%apply%%0 (%%lambda%%1 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4)
     i$
)))))
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%5.view.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
      (tr_bound%core!iter.range.Step. A&. A&)
     )
     (= (vstd!view.View.view.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&)
       self!
      ) (vstd!seq.Seq.new.? A&. A& $ (TYPE%fun%1. $ INT A&. A&) (I (nClip (%I (vstd!std_specs.range.StepSpec.spec_steps_between_int.?
           A&. A& (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start (%Poly%vstd!std_specs.range.RangeGhostIterator.
             self!
            )
           ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (%Poly%vstd!std_specs.range.RangeGhostIterator.
             self!
        )))))
       ) (Poly%fun%1. (mk_fun (%%lambda%%1 A&. A& (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start
           (%Poly%vstd!std_specs.range.RangeGhostIterator. self!)
          ) A&. A&
    ))))))
    :pattern ((vstd!view.View.view.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator. A&.
       A&
      ) self!
    ))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::std_specs::slice::impl&%1::spec_index_set_requires
(assert
 (fuel_bool_default fuel%vstd!std_specs.slice.impl&%1.spec_index_set_requires.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.slice.impl&%1.spec_index_set_requires.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (self! Poly) (index! Poly)) (!
    (=>
     (and
      (sized T&.)
      (uInv SZ (const_int N&))
     )
     (= (vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.? $ (ARRAY T&. T&
        N&. N&
       ) $ USIZE self! index!
      ) (B (let
        ((tmp%%$ (%I index!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (const_int N&))
    )))))
    :pattern ((vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.? $ (ARRAY
       T&. T& N&. N&
      ) $ USIZE self! index!
    ))
    :qid internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.?_definition
    :skolemid skolem_internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.?_definition
))))

;; Function-Axioms vstd::std_specs::slice::impl&%1::spec_index_set_ensures
(assert
 (fuel_bool_default fuel%vstd!std_specs.slice.impl&%1.spec_index_set_ensures.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.slice.impl&%1.spec_index_set_ensures.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (self! Poly) (new_container! Poly)
    (index! Poly) (val! Poly)
   ) (!
    (=>
     (and
      (sized T&.)
      (uInv SZ (const_int N&))
     )
     (= (vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.? $ (ARRAY T&. T&
        N&. N&
       ) $ USIZE self! new_container! index! val!
      ) (B (= (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) new_container!) (vstd!seq.Seq.update.?
         T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) self!) index! val!
    )))))
    :pattern ((vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.? $ (ARRAY
       T&. T& N&. N&
      ) $ USIZE self! new_container! index! val!
    ))
    :qid internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.?_definition
    :skolemid skolem_internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.?_definition
))))

;; Function-Axioms vstd::std_specs::slice::impl&%3::spec_index_set_requires
(assert
 (fuel_bool_default fuel%vstd!std_specs.slice.impl&%3.spec_index_set_requires.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.slice.impl&%3.spec_index_set_requires.)
  (forall ((T&. Dcr) (T& Type) (self! Poly) (index! Poly)) (!
    (=>
     (sized T&.)
     (= (vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.? $slice (SLICE
        T&. T&
       ) $ USIZE self! index!
      ) (B (let
        ((tmp%%$ (%I index!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&) self!)))
    )))))
    :pattern ((vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.? $slice
      (SLICE T&. T&) $ USIZE self! index!
    ))
    :qid internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.?_definition
    :skolemid skolem_internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.?_definition
))))

;; Function-Axioms vstd::std_specs::slice::impl&%3::spec_index_set_ensures
(assert
 (fuel_bool_default fuel%vstd!std_specs.slice.impl&%3.spec_index_set_ensures.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.slice.impl&%3.spec_index_set_ensures.)
  (forall ((T&. Dcr) (T& Type) (self! Poly) (new_container! Poly) (index! Poly) (val!
     Poly
    )
   ) (!
    (=>
     (sized T&.)
     (= (vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.? $slice (SLICE T&.
        T&
       ) $ USIZE self! new_container! index! val!
      ) (B (= (vstd!view.View.view.? $slice (SLICE T&. T&) new_container!) (vstd!seq.Seq.update.?
         T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&) self!) index! val!
    )))))
    :pattern ((vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.? $slice
      (SLICE T&. T&) $ USIZE self! new_container! index! val!
    ))
    :qid internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.?_definition
    :skolemid skolem_internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.?_definition
))))

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

;; Function-Axioms vstd::view::impl&%20::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%20.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%20.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ (UINT 32) self!) self!)
    :pattern ((vstd!view.View.view.? $ (UINT 32) self!))
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

;; Function-Axioms vstd::view::impl&%24::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%24.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%24.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ (UINT 128) self!) self!)
    :pattern ((vstd!view.View.view.? $ (UINT 128) self!))
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

;; Function-Axioms vstd::view::impl&%40::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%40.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%40.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ CHAR self!) self!)
    :pattern ((vstd!view.View.view.? $ CHAR self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%42::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%42.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%42.view.)
  (forall ((A0&. Dcr) (A0& Type) (self! Poly)) (!
    (=>
     (and
      (sized A0&.)
      (tr_bound%vstd!view.View. A0&. A0&)
     )
     (= (vstd!view.View.view.? (DST A0&.) (TYPE%tuple%1. A0&. A0&) self!) (Poly%tuple%1.
       (tuple%1./tuple%1 (vstd!view.View.view.? A0&. A0& (tuple%1./tuple%1/0 (%Poly%tuple%1.
           self!
    )))))))
    :pattern ((vstd!view.View.view.? (DST A0&.) (TYPE%tuple%1. A0&. A0&) self!))
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

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::LOW_51_BIT_MASK
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.LOW_51_BIT_MASK.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.LOW_51_BIT_MASK.)
  (= curve25519_dalek!backend.serial.u64.field.LOW_51_BIT_MASK.? 2251799813685247)
))
(assert
 (uInv 64 curve25519_dalek!backend.serial.u64.field.LOW_51_BIT_MASK.?)
)

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%5::obeys_add_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
    (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ) (B true)
)))

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%5::add_req
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
     ) (B (curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? self! rhs! (I 18446744073709551615)))
    )
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
    ))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs::spec_add_fe51_limbs
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.? a! b!) (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
      (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I (uClip 64 (Add (%I (vstd!seq.Seq.index.?
              $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
                (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                  a!
               )))
              ) (I 0)
             )
            ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
               ))
              ) (I 0)
          ))))
         ) (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                $ (UINT 64) $ (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!)
               ))
              ) (I 1)
             )
            ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
               ))
              ) (I 1)
          ))))
         ) (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                $ (UINT 64) $ (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!)
               ))
              ) (I 2)
             )
            ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
               ))
              ) (I 2)
          ))))
         ) (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                $ (UINT 64) $ (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!)
               ))
              ) (I 3)
             )
            ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
               ))
              ) (I 3)
          ))))
         ) (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                $ (UINT 64) $ (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!)
               ))
              ) (I 4)
             )
            ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
               ))
              ) (I 4)
    ))))))))))
    :pattern ((curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.? a! b!))
    :qid internal_curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type b! TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    )
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.?
       a! b!
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.? a! b!))
   :qid internal_curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%5::add_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
     ) (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.?
       self! rhs!
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
    ))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%8::obeys_sub_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.obeys_sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.obeys_sub_spec.)
  (= (vstd!std_specs.ops.SubSpec.obeys_sub_spec.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
    (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ) (B true)
)))

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%8::sub_req
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.sub_req.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.sub_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_req.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
     ) (B (and
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? self! (I 54))
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? rhs! (I 54))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_req.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
    ))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs::spec_sub_limbs
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.spec_sub_limbs.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.spec_sub_limbs.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.spec_sub_limbs.? a! b!) (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
      (%Poly%array%. (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_reduce.? (
          array_new $ (UINT 64) 5 (%%array%%0 (I (uClip 64 (Sub (Add (%I (vstd!seq.Seq.index.? $ (
                  UINT 64
                 ) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                    (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!)
                  ))
                 ) (I 0)
                )
               ) 36028797018963664
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                   (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
                 ))
                ) (I 0)
            ))))
           ) (I (uClip 64 (Sub (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
                  (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                    (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!)
                  ))
                 ) (I 1)
                )
               ) 36028797018963952
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                   (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
                 ))
                ) (I 1)
            ))))
           ) (I (uClip 64 (Sub (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
                  (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                    (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!)
                  ))
                 ) (I 2)
                )
               ) 36028797018963952
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                   (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
                 ))
                ) (I 2)
            ))))
           ) (I (uClip 64 (Sub (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
                  (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                    (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!)
                  ))
                 ) (I 3)
                )
               ) 36028797018963952
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                   (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
                 ))
                ) (I 3)
            ))))
           ) (I (uClip 64 (Sub (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
                  (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                    (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!)
                  ))
                 ) (I 4)
                )
               ) 36028797018963952
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                   (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
                 ))
                ) (I 4)
    ))))))))))))
    :pattern ((curve25519_dalek!specs.field_specs.spec_sub_limbs.? a! b!))
    :qid internal_curve25519_dalek!specs.field_specs.spec_sub_limbs.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.spec_sub_limbs.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type b! TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    )
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.field_specs.spec_sub_limbs.?
       a! b!
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!specs.field_specs.spec_sub_limbs.? a! b!))
   :qid internal_curve25519_dalek!specs.field_specs.spec_sub_limbs.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.spec_sub_limbs.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%8::sub_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.sub_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_spec.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
     ) (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.field_specs.spec_sub_limbs.?
       self! rhs!
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_spec.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
    ))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%11::obeys_mul_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%11.obeys_mul_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%11.obeys_mul_spec.)
  (= (vstd!std_specs.ops.MulSpec.obeys_mul_spec.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
    (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ) (B false)
)))

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%11::mul_req
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%11.mul_req.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%11.mul_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.MulSpec.mul_req.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
     ) (B (and
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? self! (I 54))
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? rhs! (I 54))
    )))
    :pattern ((vstd!std_specs.ops.MulSpec.mul_req.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
    ))
    :qid internal_vstd!std_specs.ops.MulSpec.mul_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.MulSpec.mul_req.?_definition
))))

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%11::mul_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%11.mul_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%11.mul_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.MulSpec.mul_spec.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
     ) (vstd!pervasive.arbitrary.? $ TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    )
    :pattern ((vstd!std_specs.ops.MulSpec.mul_spec.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
    ))
    :qid internal_vstd!std_specs.ops.MulSpec.mul_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.MulSpec.mul_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%13::obeys_neg_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%13.obeys_neg_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%13.obeys_neg_spec.)
  (= (vstd!std_specs.ops.NegSpec.obeys_neg_spec.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
   (B false)
)))

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%13::neg_req
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%13.neg_req.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%13.neg_req.)
  (forall ((self! Poly)) (!
    (= (vstd!std_specs.ops.NegSpec.neg_req.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      self!
     ) (B (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? self! (I 54)))
    )
    :pattern ((vstd!std_specs.ops.NegSpec.neg_req.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      self!
    ))
    :qid internal_vstd!std_specs.ops.NegSpec.neg_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.NegSpec.neg_req.?_definition
))))

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%13::neg_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%13.neg_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%13.neg_spec.)
  (forall ((self! Poly)) (!
    (= (vstd!std_specs.ops.NegSpec.neg_spec.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      self!
     ) (vstd!pervasive.arbitrary.? $ TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    )
    :pattern ((vstd!std_specs.ops.NegSpec.neg_spec.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      self!
    ))
    :qid internal_vstd!std_specs.ops.NegSpec.neg_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.NegSpec.neg_spec.?_definition
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

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%16::ONE
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%16.ONE.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%16.ONE.)
  (= curve25519_dalek!backend.serial.u64.field.impl&%16.ONE.? (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
    (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I 1) (I 0) (I 0) (I 0) (I 0))))
))))
(assert
 (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.field.impl&%16.ONE.?)
  TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%16::MINUS_ONE
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%16.MINUS_ONE.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%16.MINUS_ONE.)
  (= curve25519_dalek!backend.serial.u64.field.impl&%16.MINUS_ONE.? (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
    (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I 2251799813685228) (I 2251799813685247)
       (I 2251799813685247) (I 2251799813685247) (I 2251799813685247)
)))))))
(assert
 (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.field.impl&%16.MINUS_ONE.?)
  TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::negate_lemmas::all_neg_limbs_positive
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.all_neg_limbs_positive.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.all_neg_limbs_positive.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.negate_lemmas.all_neg_limbs_positive.? limbs!)
     (and
      (and
       (and
        (and
         (>= 36028797018963664 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
             (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
            ) (I 0)
         )))
         (>= 36028797018963952 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
             (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
            ) (I 1)
        ))))
        (>= 36028797018963952 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
            (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
           ) (I 2)
       ))))
       (>= 36028797018963952 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
           (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
          ) (I 3)
      ))))
      (>= 36028797018963952 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
          (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
         ) (I 4)
    )))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.negate_lemmas.all_neg_limbs_positive.?
      limbs!
    ))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.negate_lemmas.all_neg_limbs_positive.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.negate_lemmas.all_neg_limbs_positive.?_definition
))))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c0_0_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_0_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_0_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_0_val.? a!) (uClip 128 (Add
       (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) a!
          ) (I 0)
         )
        ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
            (CONST_INT 5)
           ) a!
          ) (I 0)
        ))
       ) (Mul 2 (Add (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
              $ (UINT 64) $ (CONST_INT 5)
             ) a!
            ) (I 1)
           )
          ) (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
                64
               ) $ (CONST_INT 5)
              ) a!
             ) (I 4)
          )))
         ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
              $ (CONST_INT 5)
             ) a!
            ) (I 2)
           )
          ) (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
                64
               ) $ (CONST_INT 5)
              ) a!
             ) (I 3)
    )))))))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_0_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_0_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_0_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 128 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_0_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_0_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_0_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_0_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c1_0_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_0_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_0_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_0_val.? a!) (uClip 128 (Add
       (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) a!
          ) (I 3)
         )
        ) (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
              64
             ) $ (CONST_INT 5)
            ) a!
           ) (I 3)
        )))
       ) (Mul 2 (Add (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
              $ (UINT 64) $ (CONST_INT 5)
             ) a!
            ) (I 0)
           )
          ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) a!
            ) (I 1)
          ))
         ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
              $ (CONST_INT 5)
             ) a!
            ) (I 2)
           )
          ) (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
                64
               ) $ (CONST_INT 5)
              ) a!
             ) (I 4)
    )))))))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_0_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_0_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_0_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 128 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_0_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_0_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_0_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_0_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c2_0_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_0_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_0_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_0_val.? a!) (uClip 128 (Add
       (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) a!
          ) (I 1)
         )
        ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
            (CONST_INT 5)
           ) a!
          ) (I 1)
        ))
       ) (Mul 2 (Add (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
              $ (UINT 64) $ (CONST_INT 5)
             ) a!
            ) (I 0)
           )
          ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) a!
            ) (I 2)
          ))
         ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
              $ (CONST_INT 5)
             ) a!
            ) (I 4)
           )
          ) (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
                64
               ) $ (CONST_INT 5)
              ) a!
             ) (I 3)
    )))))))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_0_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_0_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_0_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 128 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_0_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_0_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_0_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_0_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c3_0_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_0_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_0_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_0_val.? a!) (uClip 128 (Add
       (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) a!
          ) (I 4)
         )
        ) (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
              64
             ) $ (CONST_INT 5)
            ) a!
           ) (I 4)
        )))
       ) (Mul 2 (Add (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
              $ (UINT 64) $ (CONST_INT 5)
             ) a!
            ) (I 0)
           )
          ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) a!
            ) (I 3)
          ))
         ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
              $ (CONST_INT 5)
             ) a!
            ) (I 1)
           )
          ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) a!
            ) (I 2)
    ))))))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_0_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_0_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_0_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 128 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_0_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_0_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_0_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_0_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c4_0_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_0_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_0_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_0_val.? a!) (uClip 128 (Add
       (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) a!
          ) (I 2)
         )
        ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
            (CONST_INT 5)
           ) a!
          ) (I 2)
        ))
       ) (Mul 2 (Add (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
              $ (UINT 64) $ (CONST_INT 5)
             ) a!
            ) (I 0)
           )
          ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) a!
            ) (I 4)
          ))
         ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
              $ (CONST_INT 5)
             ) a!
            ) (I 1)
           )
          ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) a!
            ) (I 3)
    ))))))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_0_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_0_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_0_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 128 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_0_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_0_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_0_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_0_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c0_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_val.? a!) (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_0_val.?
      a!
    ))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 128 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c1_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_val.? a!) (uClip 128 (Add (
        curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_0_val.? a!
       ) (uClip 128 (uClip 64 (uClip 128 (bitshr (I (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_val.?
             a!
            )
           ) (I 51)
    )))))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 128 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c2_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_val.? a!) (uClip 128 (Add (
        curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_0_val.? a!
       ) (uClip 128 (uClip 64 (uClip 128 (bitshr (I (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_val.?
             a!
            )
           ) (I 51)
    )))))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 128 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c3_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_val.? a!) (uClip 128 (Add (
        curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_0_val.? a!
       ) (uClip 128 (uClip 64 (uClip 128 (bitshr (I (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_val.?
             a!
            )
           ) (I 51)
    )))))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 128 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c4_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_val.? a!) (uClip 128 (Add (
        curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_0_val.? a!
       ) (uClip 128 (uClip 64 (uClip 128 (bitshr (I (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_val.?
             a!
            )
           ) (I 51)
    )))))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 128 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::carry_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.carry_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.carry_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.carry_val.? a!) (uClip 64 (uClip
       128 (bitshr (I (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_val.? a!)) (I
         51
    )))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.carry_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.carry_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.carry_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 64 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.carry_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.carry_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.carry_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.carry_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::a0_0_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_0_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_0_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_0_val.? a!) (uClip 64 (bitand
       (I (uClip 64 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_val.? a!))) (I
        curve25519_dalek!specs.field_specs_u64.mask51.?
    ))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_0_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_0_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_0_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 64 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_0_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_0_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_0_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_0_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::a1_0_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_0_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_0_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_0_val.? a!) (uClip 64 (bitand
       (I (uClip 64 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_val.? a!))) (I
        curve25519_dalek!specs.field_specs_u64.mask51.?
    ))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_0_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_0_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_0_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 64 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_0_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_0_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_0_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_0_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::a2_0_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a2_0_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a2_0_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a2_0_val.? a!) (uClip 64 (bitand
       (I (uClip 64 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_val.? a!))) (I
        curve25519_dalek!specs.field_specs_u64.mask51.?
    ))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a2_0_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a2_0_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a2_0_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 64 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a2_0_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a2_0_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a2_0_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a2_0_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::a3_0_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a3_0_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a3_0_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a3_0_val.? a!) (uClip 64 (bitand
       (I (uClip 64 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_val.? a!))) (I
        curve25519_dalek!specs.field_specs_u64.mask51.?
    ))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a3_0_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a3_0_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a3_0_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 64 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a3_0_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a3_0_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a3_0_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a3_0_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::a4_0_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a4_0_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a4_0_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a4_0_val.? a!) (uClip 64 (bitand
       (I (uClip 64 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_val.? a!))) (I
        curve25519_dalek!specs.field_specs_u64.mask51.?
    ))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a4_0_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a4_0_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a4_0_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 64 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a4_0_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a4_0_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a4_0_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a4_0_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::a0_1_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_1_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_1_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_1_val.? a!) (uClip 64 (Add
       (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_0_val.? a!) (Mul (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.carry_val.?
         a!
        ) 19
    ))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_1_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_1_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_1_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 64 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_1_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_1_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_1_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_1_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::a1_1_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_1_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_1_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_1_val.? a!) (uClip 64 (Add
       (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_0_val.? a!) (uClip 64 (bitshr
         (I (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_1_val.? a!)) (I 51)
    )))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_1_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_1_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_1_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 64 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_1_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_1_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_1_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_1_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::a0_2_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_2_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_2_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_2_val.? a!) (uClip 64 (bitand
       (I (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_1_val.? a!)) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
    )))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_2_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_2_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_2_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 64 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_2_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_2_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_2_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_2_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::term_product_bounds_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.term_product_bounds_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.term_product_bounds_spec.)
  (forall ((a! Poly) (bound! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.term_product_bounds_spec.? a!
      bound!
     ) (and
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
                (and
                 (and
                  (and
                   (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                          $ (UINT 64) $ (CONST_INT 5)
                         ) a!
                        ) (I 0)
                      ))
                     ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                           UINT 64
                          ) $ (CONST_INT 5)
                         ) a!
                        ) (I 0)
                     )))
                    ) (Mul (%I bound!) (%I bound!))
                   )
                   (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                          $ (UINT 64) $ (CONST_INT 5)
                         ) a!
                        ) (I 1)
                      ))
                     ) (uClip 128 (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                           $ (UINT 64) $ (CONST_INT 5)
                          ) a!
                         ) (I 4)
                     ))))
                    ) (Mul 19 (Mul (%I bound!) (%I bound!)))
                  ))
                  (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                         $ (UINT 64) $ (CONST_INT 5)
                        ) a!
                       ) (I 2)
                     ))
                    ) (uClip 128 (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                          $ (UINT 64) $ (CONST_INT 5)
                         ) a!
                        ) (I 3)
                    ))))
                   ) (Mul 19 (Mul (%I bound!) (%I bound!)))
                 ))
                 (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                        $ (UINT 64) $ (CONST_INT 5)
                       ) a!
                      ) (I 3)
                    ))
                   ) (uClip 128 (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                         $ (UINT 64) $ (CONST_INT 5)
                        ) a!
                       ) (I 3)
                   ))))
                  ) (Mul 19 (Mul (%I bound!) (%I bound!)))
                ))
                (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                       $ (UINT 64) $ (CONST_INT 5)
                      ) a!
                     ) (I 0)
                   ))
                  ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                        UINT 64
                       ) $ (CONST_INT 5)
                      ) a!
                     ) (I 1)
                  )))
                 ) (Mul (%I bound!) (%I bound!))
               ))
               (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                      $ (UINT 64) $ (CONST_INT 5)
                     ) a!
                    ) (I 2)
                  ))
                 ) (uClip 128 (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                       $ (UINT 64) $ (CONST_INT 5)
                      ) a!
                     ) (I 4)
                 ))))
                ) (Mul 19 (Mul (%I bound!) (%I bound!)))
              ))
              (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                     $ (UINT 64) $ (CONST_INT 5)
                    ) a!
                   ) (I 1)
                 ))
                ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                      UINT 64
                     ) $ (CONST_INT 5)
                    ) a!
                   ) (I 1)
                )))
               ) (Mul (%I bound!) (%I bound!))
             ))
             (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                    $ (UINT 64) $ (CONST_INT 5)
                   ) a!
                  ) (I 0)
                ))
               ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                     UINT 64
                    ) $ (CONST_INT 5)
                   ) a!
                  ) (I 2)
               )))
              ) (Mul (%I bound!) (%I bound!))
            ))
            (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                   $ (UINT 64) $ (CONST_INT 5)
                  ) a!
                 ) (I 4)
               ))
              ) (uClip 128 (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                    $ (UINT 64) $ (CONST_INT 5)
                   ) a!
                  ) (I 3)
              ))))
             ) (Mul 19 (Mul (%I bound!) (%I bound!)))
           ))
           (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                  $ (UINT 64) $ (CONST_INT 5)
                 ) a!
                ) (I 4)
              ))
             ) (uClip 128 (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                   $ (UINT 64) $ (CONST_INT 5)
                  ) a!
                 ) (I 4)
             ))))
            ) (Mul 19 (Mul (%I bound!) (%I bound!)))
          ))
          (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                 $ (UINT 64) $ (CONST_INT 5)
                ) a!
               ) (I 0)
             ))
            ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                  UINT 64
                 ) $ (CONST_INT 5)
                ) a!
               ) (I 3)
            )))
           ) (Mul (%I bound!) (%I bound!))
         ))
         (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                $ (UINT 64) $ (CONST_INT 5)
               ) a!
              ) (I 1)
            ))
           ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                 UINT 64
                ) $ (CONST_INT 5)
               ) a!
              ) (I 2)
           )))
          ) (Mul (%I bound!) (%I bound!))
        ))
        (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
               $ (UINT 64) $ (CONST_INT 5)
              ) a!
             ) (I 2)
           ))
          ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                UINT 64
               ) $ (CONST_INT 5)
              ) a!
             ) (I 2)
          )))
         ) (Mul (%I bound!) (%I bound!))
       ))
       (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
              $ (UINT 64) $ (CONST_INT 5)
             ) a!
            ) (I 0)
          ))
         ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
               UINT 64
              ) $ (CONST_INT 5)
             ) a!
            ) (I 4)
         )))
        ) (Mul (%I bound!) (%I bound!))
      ))
      (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
             $ (UINT 64) $ (CONST_INT 5)
            ) a!
           ) (I 1)
         ))
        ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
              UINT 64
             ) $ (CONST_INT 5)
            ) a!
           ) (I 3)
        )))
       ) (Mul (%I bound!) (%I bound!))
    )))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.term_product_bounds_spec.?
      a! bound!
    ))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.term_product_bounds_spec.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.term_product_bounds_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::ci_0_val_boundaries
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_0_val_boundaries.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_0_val_boundaries.)
  (forall ((a! Poly) (bound! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_0_val_boundaries.? a! bound!)
     (and
      (and
       (and
        (and
         (< (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_0_val.? a!) (Mul 77 (Mul (%I
             bound!
            ) (%I bound!)
         )))
         (< (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_0_val.? a!) (Mul 59 (Mul (%I
             bound!
            ) (%I bound!)
        ))))
        (< (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_0_val.? a!) (Mul 41 (Mul (%I
            bound!
           ) (%I bound!)
       ))))
       (< (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_0_val.? a!) (Mul 23 (Mul (%I
           bound!
          ) (%I bound!)
      ))))
      (< (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_0_val.? a!) (Mul 5 (Mul (%I
          bound!
         ) (%I bound!)
    )))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_0_val_boundaries.?
      a! bound!
    ))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_0_val_boundaries.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_0_val_boundaries.?_definition
))))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::ci_val_boundaries
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_val_boundaries.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_val_boundaries.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_val_boundaries.? a!) (and
      (and
       (and
        (and
         (<= (uClip 128 (bitshr (I (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_val.?
              a!
             )
            ) (I 51)
           )
          ) (uClip 128 18446744073709551615)
         )
         (<= (uClip 128 (bitshr (I (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_val.?
              a!
             )
            ) (I 51)
           )
          ) (uClip 128 18446744073709551615)
        ))
        (<= (uClip 128 (bitshr (I (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_val.?
             a!
            )
           ) (I 51)
          )
         ) (uClip 128 18446744073709551615)
       ))
       (<= (uClip 128 (bitshr (I (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_val.?
            a!
           )
          ) (I 51)
         )
        ) (uClip 128 18446744073709551615)
      ))
      (<= (uClip 128 (bitshr (I (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_val.?
           a!
          )
         ) (I 51)
        )
       ) (uClip 128 18446744073709551615)
    )))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_val_boundaries.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_val_boundaries.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_val_boundaries.?_definition
))))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::ai_val_boundaries
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ai_val_boundaries.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ai_val_boundaries.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ai_val_boundaries.? a!) (and
      (and
       (and
        (and
         (and
          (and
           (and
            (and
             (< (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_0_val.? a!) (uClip 64 (bitshl
                (I 1) (I 51)
             )))
             (< (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_0_val.? a!) (uClip 64 (bitshl
                (I 1) (I 51)
            ))))
            (< (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a2_0_val.? a!) (uClip 64 (bitshl
               (I 1) (I 51)
           ))))
           (< (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a3_0_val.? a!) (uClip 64 (bitshl
              (I 1) (I 51)
          ))))
          (< (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a4_0_val.? a!) (uClip 64 (bitshl
             (I 1) (I 51)
         ))))
         (< (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.carry_val.? a!) 724618875532318195)
        )
        (< (Add (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_0_val.? a!) (Mul (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.carry_val.?
            a!
           ) 19
          )
         ) 18446744073709551615
       ))
       (< (Add (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_0_val.? a!) (uClip 64
          (bitshr (I (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_1_val.? a!)) (I 51))
         )
        ) (uClip 64 (bitshl (I 1) (I 52)))
      ))
      (< (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_2_val.? a!) (uClip 64 (bitshl
         (I 1) (I 51)
    )))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ai_val_boundaries.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ai_val_boundaries.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ai_val_boundaries.?_definition
))))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::pow2k_loop_return
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.? a!) (let
      ((a0$ (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_2_val.? a!)))
      (let
       ((a1$ (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_1_val.? a!)))
       (let
        ((a2$ (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a2_0_val.? a!)))
        (let
         ((a3$ (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a3_0_val.? a!)))
         (let
          ((a4$ (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a4_0_val.? a!)))
          (let
           ((r$ (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I a0$) (I a1$) (I a2$) (I a3$)
                (I a4$)
           )))))
           r$
    )))))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (has_type (Poly%array%. (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.?
       a!
      )
     ) (ARRAY $ (UINT 64) $ (CONST_INT 5))
   ))
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::pow2k_loop_boundary_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_boundary_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_boundary_spec.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_boundary_spec.? a!)
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
               (and
                (<= (Mul 19 (uClip 64 (bitshl (I 1) (I 54)))) 18446744073709551615)
                (<= (Mul 77 (Mul (uClip 64 (bitshl (I 1) (I 54))) (uClip 64 (bitshl (I 1) (I 54)))))
                 340282366920938463463374607431768211455
               ))
               (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.term_product_bounds_spec.? a! (
                 I (uClip 64 (bitshl (I 1) (I 54)))
              )))
              (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_0_val_boundaries.? a! (I (uClip
                 64 (bitshl (I 1) (I 54))
             ))))
             (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_val_boundaries.? a!)
            )
            (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ai_val_boundaries.? a!)
           )
           (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.?
                 a!
               ))
              ) (I 0)
             )
            ) (uClip 64 (bitshl (I 1) (I 52)))
          ))
          (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) (Poly%array%. (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.?
                a!
              ))
             ) (I 1)
            )
           ) (uClip 64 (bitshl (I 1) (I 52)))
         ))
         (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) (Poly%array%. (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.?
               a!
             ))
            ) (I 2)
           )
          ) (uClip 64 (bitshl (I 1) (I 52)))
        ))
        (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
             (CONST_INT 5)
            ) (Poly%array%. (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.?
              a!
            ))
           ) (I 3)
          )
         ) (uClip 64 (bitshl (I 1) (I 52)))
       ))
       (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
            (CONST_INT 5)
           ) (Poly%array%. (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.?
             a!
           ))
          ) (I 4)
         )
        ) (uClip 64 (bitshl (I 1) (I 52)))
      ))
      (< (uClip 64 (bitshl (I 1) (I 52))) (uClip 64 (bitshl (I 1) (I 54))))
    ))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_boundary_spec.?
      a!
    ))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_boundary_spec.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_boundary_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::mul_lemmas::mul_c0_0_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c0_0_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c0_0_val.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c0_0_val.? a! b!) (uClip 128
      (Add (Add (Add (Add (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
               ARRAY $ (UINT 64) $ (CONST_INT 5)
              ) a!
             ) (I 0)
            )
           ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) b!
             ) (I 0)
           ))
          ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
               $ (CONST_INT 5)
              ) a!
             ) (I 4)
            )
           ) (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
                 64
                ) $ (CONST_INT 5)
               ) b!
              ) (I 1)
          ))))
         ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
              $ (CONST_INT 5)
             ) a!
            ) (I 3)
           )
          ) (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
                64
               ) $ (CONST_INT 5)
              ) b!
             ) (I 2)
         ))))
        ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
             $ (CONST_INT 5)
            ) a!
           ) (I 2)
          )
         ) (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
               64
              ) $ (CONST_INT 5)
             ) b!
            ) (I 3)
        ))))
       ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) a!
          ) (I 1)
         )
        ) (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
              64
             ) $ (CONST_INT 5)
            ) b!
           ) (I 4)
    )))))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c0_0_val.? a! b!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c0_0_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c0_0_val.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
     (has_type b! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    )
    (uInv 128 (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c0_0_val.? a! b!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c0_0_val.? a! b!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c0_0_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c0_0_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::mul_lemmas::mul_c1_0_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c1_0_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c1_0_val.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c1_0_val.? a! b!) (uClip 128
      (Add (Add (Add (Add (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
               ARRAY $ (UINT 64) $ (CONST_INT 5)
              ) a!
             ) (I 1)
            )
           ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) b!
             ) (I 0)
           ))
          ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
               $ (CONST_INT 5)
              ) a!
             ) (I 0)
            )
           ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) b!
             ) (I 1)
          )))
         ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
              $ (CONST_INT 5)
             ) a!
            ) (I 4)
           )
          ) (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
                64
               ) $ (CONST_INT 5)
              ) b!
             ) (I 2)
         ))))
        ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
             $ (CONST_INT 5)
            ) a!
           ) (I 3)
          )
         ) (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
               64
              ) $ (CONST_INT 5)
             ) b!
            ) (I 3)
        ))))
       ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) a!
          ) (I 2)
         )
        ) (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
              64
             ) $ (CONST_INT 5)
            ) b!
           ) (I 4)
    )))))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c1_0_val.? a! b!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c1_0_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c1_0_val.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
     (has_type b! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    )
    (uInv 128 (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c1_0_val.? a! b!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c1_0_val.? a! b!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c1_0_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c1_0_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::mul_lemmas::mul_c2_0_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c2_0_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c2_0_val.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c2_0_val.? a! b!) (uClip 128
      (Add (Add (Add (Add (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
               ARRAY $ (UINT 64) $ (CONST_INT 5)
              ) a!
             ) (I 2)
            )
           ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) b!
             ) (I 0)
           ))
          ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
               $ (CONST_INT 5)
              ) a!
             ) (I 1)
            )
           ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) b!
             ) (I 1)
          )))
         ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
              $ (CONST_INT 5)
             ) a!
            ) (I 0)
           )
          ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) b!
            ) (I 2)
         )))
        ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
             $ (CONST_INT 5)
            ) a!
           ) (I 4)
          )
         ) (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
               64
              ) $ (CONST_INT 5)
             ) b!
            ) (I 3)
        ))))
       ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) a!
          ) (I 3)
         )
        ) (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
              64
             ) $ (CONST_INT 5)
            ) b!
           ) (I 4)
    )))))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c2_0_val.? a! b!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c2_0_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c2_0_val.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
     (has_type b! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    )
    (uInv 128 (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c2_0_val.? a! b!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c2_0_val.? a! b!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c2_0_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c2_0_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::mul_lemmas::mul_c3_0_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c3_0_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c3_0_val.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c3_0_val.? a! b!) (uClip 128
      (Add (Add (Add (Add (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
               ARRAY $ (UINT 64) $ (CONST_INT 5)
              ) a!
             ) (I 3)
            )
           ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) b!
             ) (I 0)
           ))
          ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
               $ (CONST_INT 5)
              ) a!
             ) (I 2)
            )
           ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) b!
             ) (I 1)
          )))
         ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
              $ (CONST_INT 5)
             ) a!
            ) (I 1)
           )
          ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) b!
            ) (I 2)
         )))
        ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
             $ (CONST_INT 5)
            ) a!
           ) (I 0)
          )
         ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
             (CONST_INT 5)
            ) b!
           ) (I 3)
        )))
       ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) a!
          ) (I 4)
         )
        ) (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
              64
             ) $ (CONST_INT 5)
            ) b!
           ) (I 4)
    )))))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c3_0_val.? a! b!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c3_0_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c3_0_val.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
     (has_type b! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    )
    (uInv 128 (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c3_0_val.? a! b!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c3_0_val.? a! b!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c3_0_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c3_0_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::mul_lemmas::mul_c4_0_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c4_0_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c4_0_val.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c4_0_val.? a! b!) (uClip 128
      (Add (Add (Add (Add (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
               ARRAY $ (UINT 64) $ (CONST_INT 5)
              ) a!
             ) (I 4)
            )
           ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) b!
             ) (I 0)
           ))
          ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
               $ (CONST_INT 5)
              ) a!
             ) (I 3)
            )
           ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) b!
             ) (I 1)
          )))
         ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
              $ (CONST_INT 5)
             ) a!
            ) (I 2)
           )
          ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) b!
            ) (I 2)
         )))
        ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
             $ (CONST_INT 5)
            ) a!
           ) (I 1)
          )
         ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
             (CONST_INT 5)
            ) b!
           ) (I 3)
        )))
       ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) a!
          ) (I 0)
         )
        ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
            (CONST_INT 5)
           ) b!
          ) (I 4)
    ))))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c4_0_val.? a! b!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c4_0_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c4_0_val.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
     (has_type b! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    )
    (uInv 128 (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c4_0_val.? a! b!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c4_0_val.? a! b!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c4_0_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c4_0_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::mul_lemmas::mul_c0_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c0_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c0_val.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c0_val.? a! b!) (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c0_0_val.?
      a! b!
    ))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c0_val.? a! b!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c0_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c0_val.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
     (has_type b! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    )
    (uInv 128 (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c0_val.? a! b!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c0_val.? a! b!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c0_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c0_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::mul_lemmas::mul_c1_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c1_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c1_val.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c1_val.? a! b!) (uClip 128
      (Add (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c1_0_val.? a! b!) (uClip
        128 (uClip 64 (uClip 128 (bitshr (I (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c0_val.?
             a! b!
            )
           ) (I 51)
    )))))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c1_val.? a! b!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c1_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c1_val.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
     (has_type b! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    )
    (uInv 128 (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c1_val.? a! b!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c1_val.? a! b!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c1_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c1_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::mul_lemmas::mul_c2_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c2_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c2_val.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c2_val.? a! b!) (uClip 128
      (Add (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c2_0_val.? a! b!) (uClip
        128 (uClip 64 (uClip 128 (bitshr (I (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c1_val.?
             a! b!
            )
           ) (I 51)
    )))))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c2_val.? a! b!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c2_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c2_val.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
     (has_type b! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    )
    (uInv 128 (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c2_val.? a! b!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c2_val.? a! b!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c2_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c2_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::mul_lemmas::mul_c3_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c3_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c3_val.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c3_val.? a! b!) (uClip 128
      (Add (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c3_0_val.? a! b!) (uClip
        128 (uClip 64 (uClip 128 (bitshr (I (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c2_val.?
             a! b!
            )
           ) (I 51)
    )))))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c3_val.? a! b!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c3_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c3_val.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
     (has_type b! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    )
    (uInv 128 (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c3_val.? a! b!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c3_val.? a! b!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c3_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c3_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::mul_lemmas::mul_c4_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c4_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c4_val.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c4_val.? a! b!) (uClip 128
      (Add (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c4_0_val.? a! b!) (uClip
        128 (uClip 64 (uClip 128 (bitshr (I (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c3_val.?
             a! b!
            )
           ) (I 51)
    )))))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c4_val.? a! b!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c4_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c4_val.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
     (has_type b! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    )
    (uInv 128 (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c4_val.? a! b!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c4_val.? a! b!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c4_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c4_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::mul_lemmas::mul_return
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_return.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_return.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_return.? a! b!) (%Poly%array%.
      (let
       ((c0$ (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c0_val.? a! b!)))
       (let
        ((c1$ (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c1_val.? a! b!)))
        (let
         ((c2$ (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c2_val.? a! b!)))
         (let
          ((c3$ (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c3_val.? a! b!)))
          (let
           ((c4$ (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c4_val.? a! b!)))
           (let
            ((out0$ (uClip 64 (bitand (I (uClip 64 c0$)) (I curve25519_dalek!specs.field_specs_u64.mask51.?)))))
            (let
             ((out1$ (uClip 64 (bitand (I (uClip 64 c1$)) (I curve25519_dalek!specs.field_specs_u64.mask51.?)))))
             (let
              ((out2$ (uClip 64 (bitand (I (uClip 64 c2$)) (I curve25519_dalek!specs.field_specs_u64.mask51.?)))))
              (let
               ((out3$ (uClip 64 (bitand (I (uClip 64 c3$)) (I curve25519_dalek!specs.field_specs_u64.mask51.?)))))
               (let
                ((out4$ (uClip 64 (bitand (I (uClip 64 c4$)) (I curve25519_dalek!specs.field_specs_u64.mask51.?)))))
                (let
                 ((carry$ (uClip 64 (uClip 128 (bitshr (I c4$) (I 51))))))
                 (let
                  ((out0$1 (uClip 64 (Add out0$ (Mul carry$ 19)))))
                  (let
                   ((out1$1 (uClip 64 (Add out1$ (uClip 64 (bitshr (I out0$1) (I 51)))))))
                   (let
                    ((out0$2 (uClip 64 (bitand (I out0$1) (I curve25519_dalek!specs.field_specs_u64.mask51.?)))))
                    (array_new $ (UINT 64) 5 (%%array%%0 (I out0$2) (I out1$1) (I out2$) (I out3$) (I out4$)))
    ))))))))))))))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_return.? a! b!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_return.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_return.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
     (has_type b! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    )
    (has_type (Poly%array%. (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_return.?
       a! b!
      )
     ) (ARRAY $ (UINT 64) $ (CONST_INT 5))
   ))
   :pattern ((curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_return.? a! b!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_return.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_return.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::mul_lemmas::mul_term_product_bounds_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_term_product_bounds_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_term_product_bounds_spec.)
  (forall ((a! Poly) (b! Poly) (bound! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_term_product_bounds_spec.?
      a! b! bound!
     ) (and
      (forall ((i$ Poly) (j$ Poly)) (!
        (=>
         (and
          (has_type i$ INT)
          (has_type j$ INT)
         )
         (=>
          (and
           (let
            ((tmp%%$ (%I i$)))
            (and
             (<= 0 tmp%%$)
             (< tmp%%$ 5)
           ))
           (let
            ((tmp%%$ (%I j$)))
            (and
             (<= 0 tmp%%$)
             (< tmp%%$ 5)
          )))
          (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                 $ (UINT 64) $ (CONST_INT 5)
                ) a!
               ) i$
             ))
            ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                  UINT 64
                 ) $ (CONST_INT 5)
                ) b!
               ) j$
            )))
           ) (Mul (%I bound!) (%I bound!))
        )))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) a!
          ) i$
         ) (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT
             5
            )
           ) b!
          ) j$
        ))
        :qid user_curve25519_dalek__lemmas__field_lemmas__mul_lemmas__mul_term_product_bounds_spec_63
        :skolemid skolem_user_curve25519_dalek__lemmas__field_lemmas__mul_lemmas__mul_term_product_bounds_spec_63
      ))
      (forall ((i$ Poly) (j$ Poly)) (!
        (=>
         (and
          (has_type i$ INT)
          (has_type j$ INT)
         )
         (=>
          (and
           (let
            ((tmp%%$ (%I i$)))
            (and
             (<= 0 tmp%%$)
             (< tmp%%$ 5)
           ))
           (let
            ((tmp%%$ (%I j$)))
            (and
             (<= 0 tmp%%$)
             (< tmp%%$ 5)
          )))
          (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                 $ (UINT 64) $ (CONST_INT 5)
                ) a!
               ) i$
             ))
            ) (uClip 128 (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                  $ (UINT 64) $ (CONST_INT 5)
                 ) b!
                ) j$
            ))))
           ) (Mul 19 (Mul (%I bound!) (%I bound!)))
        )))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) a!
          ) i$
         ) (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT
             5
            )
           ) b!
          ) j$
        ))
        :qid user_curve25519_dalek__lemmas__field_lemmas__mul_lemmas__mul_term_product_bounds_spec_64
        :skolemid skolem_user_curve25519_dalek__lemmas__field_lemmas__mul_lemmas__mul_term_product_bounds_spec_64
    ))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_term_product_bounds_spec.?
      a! b! bound!
    ))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_term_product_bounds_spec.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_term_product_bounds_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::mul_lemmas::mul_ci_0_val_boundaries
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_ci_0_val_boundaries.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_ci_0_val_boundaries.)
  (forall ((a! Poly) (b! Poly) (bound! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_ci_0_val_boundaries.? a! b!
      bound!
     ) (and
      (and
       (and
        (and
         (< (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c0_0_val.? a! b!) (Mul 77 (
            Mul (%I bound!) (%I bound!)
         )))
         (< (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c1_0_val.? a! b!) (Mul 59 (
            Mul (%I bound!) (%I bound!)
        ))))
        (< (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c2_0_val.? a! b!) (Mul 41 (
           Mul (%I bound!) (%I bound!)
       ))))
       (< (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c3_0_val.? a! b!) (Mul 23 (
          Mul (%I bound!) (%I bound!)
      ))))
      (< (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c4_0_val.? a! b!) (Mul 5 (Mul
         (%I bound!) (%I bound!)
    )))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_ci_0_val_boundaries.?
      a! b! bound!
    ))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_ci_0_val_boundaries.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_ci_0_val_boundaries.?_definition
))))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::mul_lemmas::mul_ci_val_boundaries
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_ci_val_boundaries.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_ci_val_boundaries.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_ci_val_boundaries.? a! b!)
     (and
      (and
       (and
        (and
         (<= (uClip 128 (bitshr (I (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c0_val.?
              a! b!
             )
            ) (I 51)
           )
          ) (uClip 128 18446744073709551615)
         )
         (<= (uClip 128 (bitshr (I (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c1_val.?
              a! b!
             )
            ) (I 51)
           )
          ) (uClip 128 18446744073709551615)
        ))
        (<= (uClip 128 (bitshr (I (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c2_val.?
             a! b!
            )
           ) (I 51)
          )
         ) (uClip 128 18446744073709551615)
       ))
       (<= (uClip 128 (bitshr (I (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c3_val.?
            a! b!
           )
          ) (I 51)
         )
        ) (uClip 128 18446744073709551615)
      ))
      (<= (uClip 128 (bitshr (I (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c4_val.?
           a! b!
          )
         ) (I 51)
        )
       ) (uClip 128 18446744073709551615)
    )))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_ci_val_boundaries.?
      a! b!
    ))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_ci_val_boundaries.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_ci_val_boundaries.?_definition
))))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::mul_lemmas::mul_out_val_boundaries
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_out_val_boundaries.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_out_val_boundaries.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_out_val_boundaries.? a! b!)
     (let
      ((c0$ (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c0_val.? a! b!)))
      (let
       ((c1$ (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c1_val.? a! b!)))
       (let
        ((c2$ (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c2_val.? a! b!)))
        (let
         ((c3$ (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c3_val.? a! b!)))
         (let
          ((c4$ (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_c4_val.? a! b!)))
          (let
           ((out0$ (uClip 64 (bitand (I (uClip 64 c0$)) (I curve25519_dalek!specs.field_specs_u64.mask51.?)))))
           (let
            ((out1$ (uClip 64 (bitand (I (uClip 64 c1$)) (I curve25519_dalek!specs.field_specs_u64.mask51.?)))))
            (let
             ((carry$ (uClip 64 (uClip 128 (bitshr (I c4$) (I 51))))))
             (let
              ((out0_1$ (uClip 64 (Add out0$ (Mul carry$ 19)))))
              (and
               (and
                (and
                 (and
                  (and
                   (and
                    (and
                     (and
                      (< out0$ (uClip 64 (bitshl (I 1) (I 51))))
                      (< out1$ (uClip 64 (bitshl (I 1) (I 51))))
                     )
                     (< (uClip 64 (bitand (I (uClip 64 c2$)) (I curve25519_dalek!specs.field_specs_u64.mask51.?)))
                      (uClip 64 (bitshl (I 1) (I 51)))
                    ))
                    (< (uClip 64 (bitand (I (uClip 64 c3$)) (I curve25519_dalek!specs.field_specs_u64.mask51.?)))
                     (uClip 64 (bitshl (I 1) (I 51)))
                   ))
                   (< (uClip 64 (bitand (I (uClip 64 c4$)) (I curve25519_dalek!specs.field_specs_u64.mask51.?)))
                    (uClip 64 (bitshl (I 1) (I 51)))
                  ))
                  (< carry$ 724618875532318195)
                 )
                 (< (Add out0$ (Mul carry$ 19)) 18446744073709551615)
                )
                (< (Add out1$ (uClip 64 (bitshr (I out0_1$) (I 51)))) (uClip 64 (bitshl (I 1) (I 52))))
               )
               (< (uClip 64 (bitand (I out0_1$) (I curve25519_dalek!specs.field_specs_u64.mask51.?)))
                (uClip 64 (bitshl (I 1) (I 51)))
    ))))))))))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_out_val_boundaries.?
      a! b!
    ))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_out_val_boundaries.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_out_val_boundaries.?_definition
))))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::mul_lemmas::mul_boundary_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_boundary_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_boundary_spec.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_boundary_spec.? a! b!) (and
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
                (<= (Mul 19 (uClip 64 (bitshl (I 1) (I 54)))) 18446744073709551615)
                (<= (Mul 77 (Mul (uClip 64 (bitshl (I 1) (I 54))) (uClip 64 (bitshl (I 1) (I 54)))))
                 340282366920938463463374607431768211455
               ))
               (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_term_product_bounds_spec.? a!
                b! (I (uClip 64 (bitshl (I 1) (I 54))))
              ))
              (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_ci_0_val_boundaries.? a! b! (
                I (uClip 64 (bitshl (I 1) (I 54)))
             )))
             (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_ci_val_boundaries.? a! b!)
            )
            (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_out_val_boundaries.? a! b!)
           )
           (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_return.? a! b!))
              ) (I 0)
             )
            ) (uClip 64 (bitshl (I 1) (I 52)))
          ))
          (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) (Poly%array%. (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_return.? a! b!))
             ) (I 1)
            )
           ) (uClip 64 (bitshl (I 1) (I 52)))
         ))
         (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) (Poly%array%. (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_return.? a! b!))
            ) (I 2)
           )
          ) (uClip 64 (bitshl (I 1) (I 52)))
        ))
        (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
             (CONST_INT 5)
            ) (Poly%array%. (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_return.? a! b!))
           ) (I 3)
          )
         ) (uClip 64 (bitshl (I 1) (I 52)))
       ))
       (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
            (CONST_INT 5)
           ) (Poly%array%. (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_return.? a! b!))
          ) (I 4)
         )
        ) (uClip 64 (bitshl (I 1) (I 52)))
      ))
      (< (uClip 64 (bitshl (I 1) (I 52))) (uClip 64 (bitshl (I 1) (I 54))))
    ))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_boundary_spec.? a! b!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_boundary_spec.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_boundary_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::load8_lemmas::load8_at_or_version_rec
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_or_version_rec.)
)
(declare-const fuel_nat%curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_or_version_rec.
 Fuel
)
(assert
 (forall ((input! Poly) (i! Poly) (k! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!lemmas.field_lemmas.load8_lemmas.rec%load8_at_or_version_rec.?
     input! i! k! fuel%
    ) (curve25519_dalek!lemmas.field_lemmas.load8_lemmas.rec%load8_at_or_version_rec.?
     input! i! k! zero
   ))
   :pattern ((curve25519_dalek!lemmas.field_lemmas.load8_lemmas.rec%load8_at_or_version_rec.?
     input! i! k! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_or_version_rec._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_or_version_rec._fuel_to_zero_definition
)))
(assert
 (forall ((input! Poly) (i! Poly) (k! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type input! (SLICE $ (UINT 8)))
     (has_type i! USIZE)
     (has_type k! NAT)
    )
    (= (curve25519_dalek!lemmas.field_lemmas.load8_lemmas.rec%load8_at_or_version_rec.?
      input! i! k! (succ fuel%)
     ) (ite
      (= (%I k!) 0)
      (uClip 64 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $slice (SLICE $
           (UINT 8)
          ) input!
         ) i!
      )))
      (uClip 64 (bitor (I (curve25519_dalek!lemmas.field_lemmas.load8_lemmas.rec%load8_at_or_version_rec.?
          input! i! (I (nClip (Sub (%I k!) 1))) fuel%
         )
        ) (I (uClip 64 (bitshl (I (uClip 64 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.?
                $slice (SLICE $ (UINT 8)) input!
               ) (I (Add (%I i!) (%I k!)))
            )))
           ) (I (nClip (Mul (%I k!) 8)))
   ))))))))
   :pattern ((curve25519_dalek!lemmas.field_lemmas.load8_lemmas.rec%load8_at_or_version_rec.?
     input! i! k! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_or_version_rec._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_or_version_rec._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_or_version_rec.)
  (forall ((input! Poly) (i! Poly) (k! Poly)) (!
    (=>
     (and
      (has_type input! (SLICE $ (UINT 8)))
      (has_type i! USIZE)
      (has_type k! NAT)
     )
     (= (curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_or_version_rec.? input!
       i! k!
      ) (curve25519_dalek!lemmas.field_lemmas.load8_lemmas.rec%load8_at_or_version_rec.?
       input! i! k! (succ fuel_nat%curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_or_version_rec.)
    )))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_or_version_rec.?
      input! i! k!
    ))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_or_version_rec.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_or_version_rec.?_definition
))))
(assert
 (forall ((input! Poly) (i! Poly) (k! Poly)) (!
   (=>
    (and
     (has_type input! (SLICE $ (UINT 8)))
     (has_type i! USIZE)
     (has_type k! NAT)
    )
    (uInv 64 (curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_or_version_rec.?
      input! i! k!
   )))
   :pattern ((curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_or_version_rec.?
     input! i! k!
   ))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_or_version_rec.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_or_version_rec.?_pre_post_definition
)))
(assert
 (forall ((input! Poly) (i! Poly) (k! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type input! (SLICE $ (UINT 8)))
     (has_type i! USIZE)
     (has_type k! NAT)
    )
    (uInv 64 (curve25519_dalek!lemmas.field_lemmas.load8_lemmas.rec%load8_at_or_version_rec.?
      input! i! k! fuel%
   )))
   :pattern ((curve25519_dalek!lemmas.field_lemmas.load8_lemmas.rec%load8_at_or_version_rec.?
     input! i! k! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.load8_lemmas.rec__load8_at_or_version_rec.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.load8_lemmas.rec__load8_at_or_version_rec.?_pre_post_rec_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::load8_lemmas::load8_at_plus_version_rec
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_plus_version_rec.)
)
(declare-const fuel_nat%curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_plus_version_rec.
 Fuel
)
(assert
 (forall ((input! Poly) (i! Poly) (k! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!lemmas.field_lemmas.load8_lemmas.rec%load8_at_plus_version_rec.?
     input! i! k! fuel%
    ) (curve25519_dalek!lemmas.field_lemmas.load8_lemmas.rec%load8_at_plus_version_rec.?
     input! i! k! zero
   ))
   :pattern ((curve25519_dalek!lemmas.field_lemmas.load8_lemmas.rec%load8_at_plus_version_rec.?
     input! i! k! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_plus_version_rec._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_plus_version_rec._fuel_to_zero_definition
)))
(assert
 (forall ((input! Poly) (i! Poly) (k! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type input! (SLICE $ (UINT 8)))
     (has_type i! USIZE)
     (has_type k! NAT)
    )
    (= (curve25519_dalek!lemmas.field_lemmas.load8_lemmas.rec%load8_at_plus_version_rec.?
      input! i! k! (succ fuel%)
     ) (ite
      (= (%I k!) 0)
      (uClip 64 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $slice (SLICE $
           (UINT 8)
          ) input!
         ) i!
      )))
      (uClip 64 (Add (curve25519_dalek!lemmas.field_lemmas.load8_lemmas.rec%load8_at_plus_version_rec.?
         input! i! (I (nClip (Sub (%I k!) 1))) fuel%
        ) (uClip 64 (bitshl (I (uClip 64 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.?
               $slice (SLICE $ (UINT 8)) input!
              ) (I (Add (%I i!) (%I k!)))
           )))
          ) (I (nClip (Mul (%I k!) 8)))
   )))))))
   :pattern ((curve25519_dalek!lemmas.field_lemmas.load8_lemmas.rec%load8_at_plus_version_rec.?
     input! i! k! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_plus_version_rec._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_plus_version_rec._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_plus_version_rec.)
  (forall ((input! Poly) (i! Poly) (k! Poly)) (!
    (=>
     (and
      (has_type input! (SLICE $ (UINT 8)))
      (has_type i! USIZE)
      (has_type k! NAT)
     )
     (= (curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_plus_version_rec.? input!
       i! k!
      ) (curve25519_dalek!lemmas.field_lemmas.load8_lemmas.rec%load8_at_plus_version_rec.?
       input! i! k! (succ fuel_nat%curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_plus_version_rec.)
    )))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_plus_version_rec.?
      input! i! k!
    ))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_plus_version_rec.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_plus_version_rec.?_definition
))))
(assert
 (forall ((input! Poly) (i! Poly) (k! Poly)) (!
   (=>
    (and
     (has_type input! (SLICE $ (UINT 8)))
     (has_type i! USIZE)
     (has_type k! NAT)
    )
    (uInv 64 (curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_plus_version_rec.?
      input! i! k!
   )))
   :pattern ((curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_plus_version_rec.?
     input! i! k!
   ))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_plus_version_rec.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_plus_version_rec.?_pre_post_definition
)))
(assert
 (forall ((input! Poly) (i! Poly) (k! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type input! (SLICE $ (UINT 8)))
     (has_type i! USIZE)
     (has_type k! NAT)
    )
    (uInv 64 (curve25519_dalek!lemmas.field_lemmas.load8_lemmas.rec%load8_at_plus_version_rec.?
      input! i! k! fuel%
   )))
   :pattern ((curve25519_dalek!lemmas.field_lemmas.load8_lemmas.rec%load8_at_plus_version_rec.?
     input! i! k! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.load8_lemmas.rec__load8_at_plus_version_rec.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.load8_lemmas.rec__load8_at_plus_version_rec.?_pre_post_rec_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::limbs_to_bytes_lemmas::bytes_match_limbs_packing
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.limbs_to_bytes_lemmas.bytes_match_limbs_packing.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.limbs_to_bytes_lemmas.bytes_match_limbs_packing.)
  (forall ((limbs! Poly) (bytes! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.limbs_to_bytes_lemmas.bytes_match_limbs_packing.?
      limbs! bytes!
     ) (and
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
                                    (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                                          CONST_INT 32
                                         )
                                        ) bytes!
                                       ) (I 0)
                                      )
                                     ) (uClip 8 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                           64
                                          ) $ (CONST_INT 5)
                                         ) limbs!
                                        ) (I 0)
                                    ))))
                                    (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                                          CONST_INT 32
                                         )
                                        ) bytes!
                                       ) (I 1)
                                      )
                                     ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                                            $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                                           ) (I 0)
                                         ))
                                        ) (I 8)
                                   )))))
                                   (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                                         CONST_INT 32
                                        )
                                       ) bytes!
                                      ) (I 2)
                                     )
                                    ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                                           $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                                          ) (I 0)
                                        ))
                                       ) (I 16)
                                  )))))
                                  (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                                        CONST_INT 32
                                       )
                                      ) bytes!
                                     ) (I 3)
                                    )
                                   ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                                          $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                                         ) (I 0)
                                       ))
                                      ) (I 24)
                                 )))))
                                 (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                                       CONST_INT 32
                                      )
                                     ) bytes!
                                    ) (I 4)
                                   )
                                  ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                                         $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                                        ) (I 0)
                                      ))
                                     ) (I 32)
                                )))))
                                (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                                      CONST_INT 32
                                     )
                                    ) bytes!
                                   ) (I 5)
                                  )
                                 ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                                        $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                                       ) (I 0)
                                     ))
                                    ) (I 40)
                               )))))
                               (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                                     CONST_INT 32
                                    )
                                   ) bytes!
                                  ) (I 6)
                                 )
                                ) (uClip 8 (uClip 64 (bitor (I (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64)
                                         (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 0)
                                       ))
                                      ) (I 48)
                                    ))
                                   ) (I (uClip 64 (bitshl (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
                                          (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                                         ) (I 1)
                                       ))
                                      ) (I 3)
                              ))))))))
                              (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                                    CONST_INT 32
                                   )
                                  ) bytes!
                                 ) (I 7)
                                )
                               ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                                      $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                                     ) (I 1)
                                   ))
                                  ) (I 5)
                             )))))
                             (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                                   CONST_INT 32
                                  )
                                 ) bytes!
                                ) (I 8)
                               )
                              ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                                     $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                                    ) (I 1)
                                  ))
                                 ) (I 13)
                            )))))
                            (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                                  CONST_INT 32
                                 )
                                ) bytes!
                               ) (I 9)
                              )
                             ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                                    $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                                   ) (I 1)
                                 ))
                                ) (I 21)
                           )))))
                           (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                                 CONST_INT 32
                                )
                               ) bytes!
                              ) (I 10)
                             )
                            ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                                  ) (I 1)
                                ))
                               ) (I 29)
                          )))))
                          (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                                CONST_INT 32
                               )
                              ) bytes!
                             ) (I 11)
                            )
                           ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                                  $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                                 ) (I 1)
                               ))
                              ) (I 37)
                         )))))
                         (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                               CONST_INT 32
                              )
                             ) bytes!
                            ) (I 12)
                           )
                          ) (uClip 8 (uClip 64 (bitor (I (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64)
                                   (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 1)
                                 ))
                                ) (I 45)
                              ))
                             ) (I (uClip 64 (bitshl (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
                                    (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                                   ) (I 2)
                                 ))
                                ) (I 6)
                        ))))))))
                        (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                              CONST_INT 32
                             )
                            ) bytes!
                           ) (I 13)
                          )
                         ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                                $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                               ) (I 2)
                             ))
                            ) (I 2)
                       )))))
                       (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                             CONST_INT 32
                            )
                           ) bytes!
                          ) (I 14)
                         )
                        ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                               $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                              ) (I 2)
                            ))
                           ) (I 10)
                      )))))
                      (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                            CONST_INT 32
                           )
                          ) bytes!
                         ) (I 15)
                        )
                       ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                              $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                             ) (I 2)
                           ))
                          ) (I 18)
                     )))))
                     (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                           CONST_INT 32
                          )
                         ) bytes!
                        ) (I 16)
                       )
                      ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                             $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                            ) (I 2)
                          ))
                         ) (I 26)
                    )))))
                    (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                          CONST_INT 32
                         )
                        ) bytes!
                       ) (I 17)
                      )
                     ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                            $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                           ) (I 2)
                         ))
                        ) (I 34)
                   )))))
                   (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                         CONST_INT 32
                        )
                       ) bytes!
                      ) (I 18)
                     )
                    ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                           $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                          ) (I 2)
                        ))
                       ) (I 42)
                  )))))
                  (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                        CONST_INT 32
                       )
                      ) bytes!
                     ) (I 19)
                    )
                   ) (uClip 8 (uClip 64 (bitor (I (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64)
                            (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 2)
                          ))
                         ) (I 50)
                       ))
                      ) (I (uClip 64 (bitshl (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
                             (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                            ) (I 3)
                          ))
                         ) (I 1)
                 ))))))))
                 (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                       CONST_INT 32
                      )
                     ) bytes!
                    ) (I 20)
                   )
                  ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                         $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                        ) (I 3)
                      ))
                     ) (I 7)
                )))))
                (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                      CONST_INT 32
                     )
                    ) bytes!
                   ) (I 21)
                  )
                 ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                        $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                       ) (I 3)
                     ))
                    ) (I 15)
               )))))
               (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                     CONST_INT 32
                    )
                   ) bytes!
                  ) (I 22)
                 )
                ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                       $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                      ) (I 3)
                    ))
                   ) (I 23)
              )))))
              (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                    CONST_INT 32
                   )
                  ) bytes!
                 ) (I 23)
                )
               ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                      $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                     ) (I 3)
                   ))
                  ) (I 31)
             )))))
             (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                   CONST_INT 32
                  )
                 ) bytes!
                ) (I 24)
               )
              ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                     $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                    ) (I 3)
                  ))
                 ) (I 39)
            )))))
            (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                  CONST_INT 32
                 )
                ) bytes!
               ) (I 25)
              )
             ) (uClip 8 (uClip 64 (bitor (I (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64)
                      (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 3)
                    ))
                   ) (I 47)
                 ))
                ) (I (uClip 64 (bitshl (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
                       (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                      ) (I 4)
                    ))
                   ) (I 4)
           ))))))))
           (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                 CONST_INT 32
                )
               ) bytes!
              ) (I 26)
             )
            ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                  ) (I 4)
                ))
               ) (I 4)
          )))))
          (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                CONST_INT 32
               )
              ) bytes!
             ) (I 27)
            )
           ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                  $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                 ) (I 4)
               ))
              ) (I 12)
         )))))
         (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
               CONST_INT 32
              )
             ) bytes!
            ) (I 28)
           )
          ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                 $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                ) (I 4)
              ))
             ) (I 20)
        )))))
        (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
              CONST_INT 32
             )
            ) bytes!
           ) (I 29)
          )
         ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
               ) (I 4)
             ))
            ) (I 28)
       )))))
       (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
             CONST_INT 32
            )
           ) bytes!
          ) (I 30)
         )
        ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
               $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
              ) (I 4)
            ))
           ) (I 36)
      )))))
      (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
            CONST_INT 32
           )
          ) bytes!
         ) (I 31)
        )
       ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
              $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
             ) (I 4)
           ))
          ) (I 44)
    ))))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.limbs_to_bytes_lemmas.bytes_match_limbs_packing.?
      limbs! bytes!
    ))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.limbs_to_bytes_lemmas.bytes_match_limbs_packing.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.limbs_to_bytes_lemmas.bytes_match_limbs_packing.?_definition
))))

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

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::compute_q_arr
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.compute_q_arr.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.compute_q_arr.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.compute_q_arr.? limbs!) (%Poly%array%. (
       let
       ((q0$ (uClip 64 (uClip 64 (bitshr (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (
                  vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                 ) (I 0)
                )
               ) 19
             ))
            ) (I 51)
       )))))
       (let
        ((q1$ (uClip 64 (uClip 64 (bitshr (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (
                   vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                  ) (I 1)
                 )
                ) q0$
              ))
             ) (I 51)
        )))))
        (let
         ((q2$ (uClip 64 (uClip 64 (bitshr (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (
                    vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                   ) (I 2)
                  )
                 ) q1$
               ))
              ) (I 51)
         )))))
         (let
          ((q3$ (uClip 64 (uClip 64 (bitshr (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (
                     vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                    ) (I 3)
                   )
                  ) q2$
                ))
               ) (I 51)
          )))))
          (let
           ((q4$ (uClip 64 (uClip 64 (bitshr (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (
                      vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                     ) (I 4)
                    )
                   ) q3$
                 ))
                ) (I 51)
           )))))
           (array_new $ (UINT 64) 5 (%%array%%0 (I q0$) (I q1$) (I q2$) (I q3$) (I q4$)))
    )))))))
    :pattern ((curve25519_dalek!specs.field_specs_u64.compute_q_arr.? limbs!))
    :qid internal_curve25519_dalek!specs.field_specs_u64.compute_q_arr.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.compute_q_arr.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (has_type (Poly%array%. (curve25519_dalek!specs.field_specs_u64.compute_q_arr.? limbs!))
     (ARRAY $ (UINT 64) $ (CONST_INT 5))
   ))
   :pattern ((curve25519_dalek!specs.field_specs_u64.compute_q_arr.? limbs!))
   :qid internal_curve25519_dalek!specs.field_specs_u64.compute_q_arr.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.compute_q_arr.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::compute_q_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.compute_q_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.compute_q_spec.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.compute_q_spec.? limbs!) (%I (vstd!seq.Seq.index.?
       $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
         (curve25519_dalek!specs.field_specs_u64.compute_q_arr.? limbs!)
        )
       ) (I 4)
    )))
    :pattern ((curve25519_dalek!specs.field_specs_u64.compute_q_spec.? limbs!))
    :qid internal_curve25519_dalek!specs.field_specs_u64.compute_q_spec.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.compute_q_spec.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 64 (curve25519_dalek!specs.field_specs_u64.compute_q_spec.? limbs!))
   )
   :pattern ((curve25519_dalek!specs.field_specs_u64.compute_q_spec.? limbs!))
   :qid internal_curve25519_dalek!specs.field_specs_u64.compute_q_spec.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.compute_q_spec.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::compute_unmasked_limbs
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.compute_unmasked_limbs.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.compute_unmasked_limbs.)
  (forall ((input_limbs! Poly) (q! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.compute_unmasked_limbs.? input_limbs! q!)
     (%Poly%array%. (let
       ((l0$ (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
               $ (UINT 64) $ (CONST_INT 5)
              ) input_limbs!
             ) (I 0)
            )
           ) (Mul 19 (%I q!))
       ))))
       (let
        ((l1$ (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                $ (UINT 64) $ (CONST_INT 5)
               ) input_limbs!
              ) (I 1)
             )
            ) (uClip 64 (bitshr (I l0$) (I 51)))
        ))))
        (let
         ((l2$ (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                 $ (UINT 64) $ (CONST_INT 5)
                ) input_limbs!
               ) (I 2)
              )
             ) (uClip 64 (bitshr (I l1$) (I 51)))
         ))))
         (let
          ((l3$ (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                  $ (UINT 64) $ (CONST_INT 5)
                 ) input_limbs!
                ) (I 3)
               )
              ) (uClip 64 (bitshr (I l2$) (I 51)))
          ))))
          (let
           ((l4$ (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                   $ (UINT 64) $ (CONST_INT 5)
                  ) input_limbs!
                 ) (I 4)
                )
               ) (uClip 64 (bitshr (I l3$) (I 51)))
           ))))
           (array_new $ (UINT 64) 5 (%%array%%0 (I l0$) (I l1$) (I l2$) (I l3$) (I l4$)))
    )))))))
    :pattern ((curve25519_dalek!specs.field_specs_u64.compute_unmasked_limbs.? input_limbs!
      q!
    ))
    :qid internal_curve25519_dalek!specs.field_specs_u64.compute_unmasked_limbs.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.compute_unmasked_limbs.?_definition
))))
(assert
 (forall ((input_limbs! Poly) (q! Poly)) (!
   (=>
    (and
     (has_type input_limbs! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
     (has_type q! (UINT 64))
    )
    (has_type (Poly%array%. (curve25519_dalek!specs.field_specs_u64.compute_unmasked_limbs.?
       input_limbs! q!
      )
     ) (ARRAY $ (UINT 64) $ (CONST_INT 5))
   ))
   :pattern ((curve25519_dalek!specs.field_specs_u64.compute_unmasked_limbs.? input_limbs!
     q!
   ))
   :qid internal_curve25519_dalek!specs.field_specs_u64.compute_unmasked_limbs.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.compute_unmasked_limbs.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::reduce_with_q_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.reduce_with_q_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.reduce_with_q_spec.)
  (forall ((input_limbs! Poly) (q! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.reduce_with_q_spec.? input_limbs! q!) (
      %Poly%array%. (let
       ((l$ (curve25519_dalek!specs.field_specs_u64.compute_unmasked_limbs.? input_limbs! q!)))
       (let
        ((l0$ (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
              $ (CONST_INT 5)
             ) (Poly%array%. l$)
            ) (I 0)
        ))))
        (let
         ((l1$ (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
               $ (CONST_INT 5)
              ) (Poly%array%. l$)
             ) (I 1)
         ))))
         (let
          ((l2$ (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
                $ (CONST_INT 5)
               ) (Poly%array%. l$)
              ) (I 2)
          ))))
          (let
           ((l3$ (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
                 $ (CONST_INT 5)
                ) (Poly%array%. l$)
               ) (I 3)
           ))))
           (let
            ((l4$ (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
                  $ (CONST_INT 5)
                 ) (Poly%array%. l$)
                ) (I 4)
            ))))
            (let
             ((l0_masked$ (uClip 64 (uClip 64 (bitand (I l0$) (I curve25519_dalek!specs.field_specs_u64.mask51.?))))))
             (let
              ((l1_masked$ (uClip 64 (uClip 64 (bitand (I l1$) (I curve25519_dalek!specs.field_specs_u64.mask51.?))))))
              (let
               ((l2_masked$ (uClip 64 (uClip 64 (bitand (I l2$) (I curve25519_dalek!specs.field_specs_u64.mask51.?))))))
               (let
                ((l3_masked$ (uClip 64 (uClip 64 (bitand (I l3$) (I curve25519_dalek!specs.field_specs_u64.mask51.?))))))
                (let
                 ((l4_masked$ (uClip 64 (uClip 64 (bitand (I l4$) (I curve25519_dalek!specs.field_specs_u64.mask51.?))))))
                 (array_new $ (UINT 64) 5 (%%array%%0 (I l0_masked$) (I l1_masked$) (I l2_masked$) (
                    I l3_masked$
                   ) (I l4_masked$)
    )))))))))))))))
    :pattern ((curve25519_dalek!specs.field_specs_u64.reduce_with_q_spec.? input_limbs!
      q!
    ))
    :qid internal_curve25519_dalek!specs.field_specs_u64.reduce_with_q_spec.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.reduce_with_q_spec.?_definition
))))
(assert
 (forall ((input_limbs! Poly) (q! Poly)) (!
   (=>
    (and
     (has_type input_limbs! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
     (has_type q! (UINT 64))
    )
    (has_type (Poly%array%. (curve25519_dalek!specs.field_specs_u64.reduce_with_q_spec.?
       input_limbs! q!
      )
     ) (ARRAY $ (UINT 64) $ (CONST_INT 5))
   ))
   :pattern ((curve25519_dalek!specs.field_specs_u64.reduce_with_q_spec.? input_limbs!
     q!
   ))
   :qid internal_curve25519_dalek!specs.field_specs_u64.reduce_with_q_spec.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.reduce_with_q_spec.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::bit_arrange
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.bit_arrange.)
)
(declare-fun %%array%%1 (Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly
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
    ((%%x%% (%%array%%1 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4 %%hole%%5 %%hole%%6
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
   :pattern ((%%array%%1 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4 %%hole%%5 %%hole%%6
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
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.bit_arrange.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.bit_arrange.? limbs!) (let
      ((s$ (%Poly%array%. (array_new $ (UINT 8) 32 (%%array%%1 (I (uClip 8 (%I (vstd!seq.Seq.index.?
               $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!)
               (I 0)
            )))
           ) (I (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                  ) (I 0)
                ))
               ) (I 8)
            )))
           ) (I (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                  ) (I 0)
                ))
               ) (I 16)
            )))
           ) (I (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                  ) (I 0)
                ))
               ) (I 24)
            )))
           ) (I (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                  ) (I 0)
                ))
               ) (I 32)
            )))
           ) (I (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                  ) (I 0)
                ))
               ) (I 40)
            )))
           ) (I (uClip 8 (uClip 64 (bitor (I (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64)
                     (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 0)
                   ))
                  ) (I 48)
                ))
               ) (I (uClip 64 (bitshl (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
                      (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                     ) (I 1)
                   ))
                  ) (I 3)
            ))))))
           ) (I (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                  ) (I 1)
                ))
               ) (I 5)
            )))
           ) (I (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                  ) (I 1)
                ))
               ) (I 13)
            )))
           ) (I (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                  ) (I 1)
                ))
               ) (I 21)
            )))
           ) (I (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                  ) (I 1)
                ))
               ) (I 29)
            )))
           ) (I (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                  ) (I 1)
                ))
               ) (I 37)
            )))
           ) (I (uClip 8 (uClip 64 (bitor (I (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64)
                     (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 1)
                   ))
                  ) (I 45)
                ))
               ) (I (uClip 64 (bitshl (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
                      (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                     ) (I 2)
                   ))
                  ) (I 6)
            ))))))
           ) (I (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                  ) (I 2)
                ))
               ) (I 2)
            )))
           ) (I (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                  ) (I 2)
                ))
               ) (I 10)
            )))
           ) (I (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                  ) (I 2)
                ))
               ) (I 18)
            )))
           ) (I (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                  ) (I 2)
                ))
               ) (I 26)
            )))
           ) (I (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                  ) (I 2)
                ))
               ) (I 34)
            )))
           ) (I (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                  ) (I 2)
                ))
               ) (I 42)
            )))
           ) (I (uClip 8 (uClip 64 (bitor (I (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64)
                     (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 2)
                   ))
                  ) (I 50)
                ))
               ) (I (uClip 64 (bitshl (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
                      (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                     ) (I 3)
                   ))
                  ) (I 1)
            ))))))
           ) (I (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                  ) (I 3)
                ))
               ) (I 7)
            )))
           ) (I (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                  ) (I 3)
                ))
               ) (I 15)
            )))
           ) (I (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                  ) (I 3)
                ))
               ) (I 23)
            )))
           ) (I (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                  ) (I 3)
                ))
               ) (I 31)
            )))
           ) (I (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                  ) (I 3)
                ))
               ) (I 39)
            )))
           ) (I (uClip 8 (uClip 64 (bitor (I (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64)
                     (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 3)
                   ))
                  ) (I 47)
                ))
               ) (I (uClip 64 (bitshl (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
                      (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                     ) (I 4)
                   ))
                  ) (I 4)
            ))))))
           ) (I (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                  ) (I 4)
                ))
               ) (I 4)
            )))
           ) (I (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                  ) (I 4)
                ))
               ) (I 12)
            )))
           ) (I (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                  ) (I 4)
                ))
               ) (I 20)
            )))
           ) (I (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                  ) (I 4)
                ))
               ) (I 28)
            )))
           ) (I (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                  ) (I 4)
                ))
               ) (I 36)
            )))
           ) (I (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                  ) (I 4)
                ))
               ) (I 44)
      )))))))))
      s$
    ))
    :pattern ((curve25519_dalek!specs.field_specs_u64.bit_arrange.? limbs!))
    :qid internal_curve25519_dalek!specs.field_specs_u64.bit_arrange.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.bit_arrange.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (has_type (Poly%array%. (curve25519_dalek!specs.field_specs_u64.bit_arrange.? limbs!))
     (ARRAY $ (UINT 8) $ (CONST_INT 32))
   ))
   :pattern ((curve25519_dalek!specs.field_specs_u64.bit_arrange.? limbs!))
   :qid internal_curve25519_dalek!specs.field_specs_u64.bit_arrange.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.bit_arrange.?_pre_post_definition
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
 (tr_bound%vstd!view.View. $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ (UINT 128))
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
 (tr_bound%vstd!view.View. $ CHAR)
)

;; Trait-Impl-Axiom
(assert
 (forall ((A0&. Dcr) (A0& Type)) (!
   (=>
    (and
     (sized A0&.)
     (tr_bound%vstd!view.View. A0&. A0&)
    )
    (tr_bound%vstd!view.View. (DST A0&.) (TYPE%tuple%1. A0&. A0&))
   )
   :pattern ((tr_bound%vstd!view.View. (DST A0&.) (TYPE%tuple%1. A0&. A0&)))
   :qid internal_vstd__view__impl&__42_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__42_trait_impl_definition
)))

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
 (tr_bound%core!cmp.PartialEq. $ BOOL $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Neg. $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.NegSpec. $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. $ USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. $ (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (UINT 32) $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. $ (UINT 32) $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. $ (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (UINT 128) $ (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. $ (UINT 128) $ (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. $ (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.SubSpec. $ USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.SubSpec. $ (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ (UINT 32) $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.SubSpec. $ (UINT 32) $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.SubSpec. $ (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ (UINT 128) $ (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.SubSpec. $ (UINT 128) $ (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.SubSpec. $ (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. $ USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.MulSpec. $ USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. $ (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.MulSpec. $ (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. $ (UINT 32) $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.MulSpec. $ (UINT 32) $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. $ (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.MulSpec. $ (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. $ (UINT 128) $ (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.MulSpec. $ (UINT 128) $ (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. $ (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.MulSpec. $ (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ (UINT 32) $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ (UINT 32) $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ (UINT 128) $ (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ (UINT 128) $ (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!cmp.PartialEq. T&. T& T&. T&)
    )
    (tr_bound%core!cmp.PartialEq. $ (TYPE%core!option.Option. T&. T&) $ (TYPE%core!option.Option.
      T&. T&
   )))
   :pattern ((tr_bound%core!cmp.PartialEq. $ (TYPE%core!option.Option. T&. T&) $ (TYPE%core!option.Option.
      T&. T&
   )))
   :qid internal_core__option__impl&__15_trait_impl_definition
   :skolemid skolem_internal_core__option__impl&__15_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!cmp.PartialOrd. T&. T& T&. T&)
    )
    (tr_bound%core!cmp.PartialOrd. $ (TYPE%core!option.Option. T&. T&) $ (TYPE%core!option.Option.
      T&. T&
   )))
   :pattern ((tr_bound%core!cmp.PartialOrd. $ (TYPE%core!option.Option. T&. T&) $ (TYPE%core!option.Option.
      T&. T&
   )))
   :qid internal_core__option__impl&__16_trait_impl_definition
   :skolemid skolem_internal_core__option__impl&__16_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized A&.)
     (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
    )
    (tr_bound%vstd!pervasive.ForLoopGhostIteratorNew. $ (TYPE%core!ops.range.Range. A&.
      A&
   )))
   :pattern ((tr_bound%vstd!pervasive.ForLoopGhostIteratorNew. $ (TYPE%core!ops.range.Range.
      A&. A&
   )))
   :qid internal_vstd__std_specs__range__impl&__3_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__range__impl&__3_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized A&.)
     (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
     (tr_bound%core!iter.range.Step. A&. A&)
    )
    (tr_bound%vstd!pervasive.ForLoopGhostIterator. $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
   )))
   :pattern ((tr_bound%vstd!pervasive.ForLoopGhostIterator. $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
   )))
   :qid internal_vstd__std_specs__range__impl&__4_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__range__impl&__4_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized A&.)
     (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
     (tr_bound%core!iter.range.Step. A&. A&)
    )
    (tr_bound%vstd!view.View. $ (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&))
   )
   :pattern ((tr_bound%vstd!view.View. $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
   )))
   :qid internal_vstd__std_specs__range__impl&__5_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__range__impl&__5_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (uInv SZ (const_int N&))
    )
    (tr_bound%vstd!std_specs.core.TrustedSpecSealed. $ (ARRAY T&. T& N&. N&))
   )
   :pattern ((tr_bound%vstd!std_specs.core.TrustedSpecSealed. $ (ARRAY T&. T& N&. N&)))
   :qid internal_vstd__std_specs__slice__impl&__0_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__slice__impl&__0_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (I&. Dcr) (I& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized I&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!ops.index.Index. $slice (SLICE T&. T&) I&. I&)
    )
    (tr_bound%core!ops.index.Index. $ (ARRAY T&. T& N&. N&) I&. I&)
   )
   :pattern ((tr_bound%core!ops.index.Index. $ (ARRAY T&. T& N&. N&) I&. I&))
   :qid internal_core__array__impl&__15_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__15_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (I&. Dcr) (I& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized I&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!ops.index.IndexMut. $slice (SLICE T&. T&) I&. I&)
    )
    (tr_bound%core!ops.index.IndexMut. $ (ARRAY T&. T& N&. N&) I&. I&)
   )
   :pattern ((tr_bound%core!ops.index.IndexMut. $ (ARRAY T&. T& N&. N&) I&. I&))
   :qid internal_core__array__impl&__16_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__16_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (I&. Dcr) (I& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized I&.)
     (tr_bound%core!slice.index.SliceIndex. I&. I& $slice (SLICE T&. T&))
    )
    (tr_bound%core!ops.index.Index. $slice (SLICE T&. T&) I&. I&)
   )
   :pattern ((tr_bound%core!ops.index.Index. $slice (SLICE T&. T&) I&. I&))
   :qid internal_core__slice__index__impl&__0_trait_impl_definition
   :skolemid skolem_internal_core__slice__index__impl&__0_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (I&. Dcr) (I& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized I&.)
     (tr_bound%core!slice.index.SliceIndex. I&. I& $slice (SLICE T&. T&))
    )
    (tr_bound%core!ops.index.IndexMut. $slice (SLICE T&. T&) I&. I&)
   )
   :pattern ((tr_bound%core!ops.index.IndexMut. $slice (SLICE T&. T&) I&. I&))
   :qid internal_core__slice__index__impl&__1_trait_impl_definition
   :skolemid skolem_internal_core__slice__index__impl&__1_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%core!slice.index.SliceIndex. $ USIZE $slice (SLICE T&. T&))
   )
   :pattern ((tr_bound%core!slice.index.SliceIndex. $ USIZE $slice (SLICE T&. T&)))
   :qid internal_core__slice__index__impl&__2_trait_impl_definition
   :skolemid skolem_internal_core__slice__index__impl&__2_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (uInv SZ (const_int N&))
    )
    (tr_bound%vstd!std_specs.core.IndexSetTrustedSpec. $ (ARRAY T&. T& N&. N&) $ USIZE)
   )
   :pattern ((tr_bound%vstd!std_specs.core.IndexSetTrustedSpec. $ (ARRAY T&. T& N&. N&)
     $ USIZE
   ))
   :qid internal_vstd__std_specs__slice__impl&__1_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__slice__impl&__1_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%vstd!std_specs.core.TrustedSpecSealed. $slice (SLICE T&. T&))
   )
   :pattern ((tr_bound%vstd!std_specs.core.TrustedSpecSealed. $slice (SLICE T&. T&)))
   :qid internal_vstd__std_specs__slice__impl&__2_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__slice__impl&__2_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%vstd!std_specs.core.IndexSetTrustedSpec. $slice (SLICE T&. T&) $ USIZE)
   )
   :pattern ((tr_bound%vstd!std_specs.core.IndexSetTrustedSpec. $slice (SLICE T&. T&)
     $ USIZE
   ))
   :qid internal_vstd__std_specs__slice__impl&__3_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__slice__impl&__3_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ CHAR)
)

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!clone.Clone. (CONST_PTR $) (PTR T&. T&))
   :pattern ((tr_bound%core!clone.Clone. (CONST_PTR $) (PTR T&. T&)))
   :qid internal_core__clone__impls__impl&__1_trait_impl_definition
   :skolemid skolem_internal_core__clone__impls__impl&__1_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!clone.Clone. $ (PTR T&. T&))
   :pattern ((tr_bound%core!clone.Clone. $ (PTR T&. T&)))
   :qid internal_core__clone__impls__impl&__2_trait_impl_definition
   :skolemid skolem_internal_core__clone__impls__impl&__2_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!clone.Clone. (REF T&.) T&)
   :pattern ((tr_bound%core!clone.Clone. (REF T&.) T&))
   :qid internal_core__clone__impls__impl&__3_trait_impl_definition
   :skolemid skolem_internal_core__clone__impls__impl&__3_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((Idx&. Dcr) (Idx& Type)) (!
   (=>
    (and
     (sized Idx&.)
     (tr_bound%core!clone.Clone. Idx&. Idx&)
    )
    (tr_bound%core!clone.Clone. $ (TYPE%core!ops.range.Range. Idx&. Idx&))
   )
   :pattern ((tr_bound%core!clone.Clone. $ (TYPE%core!ops.range.Range. Idx&. Idx&)))
   :qid internal_core__ops__range__impl&__46_trait_impl_definition
   :skolemid skolem_internal_core__ops__range__impl&__46_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!clone.Clone. T&. T&)
    )
    (tr_bound%core!clone.Clone. $ (ARRAY T&. T& N&. N&))
   )
   :pattern ((tr_bound%core!clone.Clone. $ (ARRAY T&. T& N&. N&)))
   :qid internal_core__array__impl&__20_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__20_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized E&.)
     (tr_bound%core!clone.Clone. T&. T&)
     (tr_bound%core!clone.Clone. E&. E&)
    )
    (tr_bound%core!clone.Clone. $ (TYPE%core!result.Result. T&. T& E&. E&))
   )
   :pattern ((tr_bound%core!clone.Clone. $ (TYPE%core!result.Result. T&. T& E&. E&)))
   :qid internal_core__result__impl&__5_trait_impl_definition
   :skolemid skolem_internal_core__result__impl&__5_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ TYPE%core!time.Duration.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ ALLOCATOR_GLOBAL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $slice STRSLICE $slice STRSLICE)
)

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type) (B&. Dcr) (B& Type)) (!
   (=>
    (tr_bound%core!cmp.PartialEq. A&. A& B&. B&)
    (tr_bound%core!cmp.PartialEq. (REF A&.) A& (REF B&.) B&)
   )
   :pattern ((tr_bound%core!cmp.PartialEq. (REF A&.) A& (REF B&.) B&))
   :qid internal_core__cmp__impls__impl&__9_trait_impl_definition
   :skolemid skolem_internal_core__cmp__impls__impl&__9_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (U&. Dcr) (U& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized U&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!cmp.PartialEq. T&. T& U&. U&)
    )
    (tr_bound%core!cmp.PartialEq. (REF $slice) (SLICE T&. T&) $ (ARRAY U&. U& N&. N&))
   )
   :pattern ((tr_bound%core!cmp.PartialEq. (REF $slice) (SLICE T&. T&) $ (ARRAY U&. U&
      N&. N&
   )))
   :qid internal_core__array__equality__impl&__4_trait_impl_definition
   :skolemid skolem_internal_core__array__equality__impl&__4_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!cmp.PartialEq. (CONST_PTR $) (PTR T&. T&) (CONST_PTR $) (PTR T&. T&))
   :pattern ((tr_bound%core!cmp.PartialEq. (CONST_PTR $) (PTR T&. T&) (CONST_PTR $) (PTR
      T&. T&
   )))
   :qid internal_core__ptr__const_ptr__impl&__6_trait_impl_definition
   :skolemid skolem_internal_core__ptr__const_ptr__impl&__6_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!cmp.PartialEq. $ (PTR T&. T&) $ (PTR T&. T&))
   :pattern ((tr_bound%core!cmp.PartialEq. $ (PTR T&. T&) $ (PTR T&. T&)))
   :qid internal_core__ptr__mut_ptr__impl&__6_trait_impl_definition
   :skolemid skolem_internal_core__ptr__mut_ptr__impl&__6_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ TYPE%tuple%0. $ TYPE%tuple%0.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ CHAR $ CHAR)
)

;; Trait-Impl-Axiom
(assert
 (forall ((Idx&. Dcr) (Idx& Type)) (!
   (=>
    (and
     (sized Idx&.)
     (tr_bound%core!cmp.PartialEq. Idx&. Idx& Idx&. Idx&)
    )
    (tr_bound%core!cmp.PartialEq. $ (TYPE%core!ops.range.Range. Idx&. Idx&) $ (TYPE%core!ops.range.Range.
      Idx&. Idx&
   )))
   :pattern ((tr_bound%core!cmp.PartialEq. $ (TYPE%core!ops.range.Range. Idx&. Idx&) $
     (TYPE%core!ops.range.Range. Idx&. Idx&)
   ))
   :qid internal_core__ops__range__impl&__49_trait_impl_definition
   :skolemid skolem_internal_core__ops__range__impl&__49_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (U&. Dcr) (U& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized U&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!cmp.PartialEq. T&. T& U&. U&)
    )
    (tr_bound%core!cmp.PartialEq. $ (ARRAY T&. T& N&. N&) $ (ARRAY U&. U& N&. N&))
   )
   :pattern ((tr_bound%core!cmp.PartialEq. $ (ARRAY T&. T& N&. N&) $ (ARRAY U&. U& N&.
      N&
   )))
   :qid internal_core__array__equality__impl&__0_trait_impl_definition
   :skolemid skolem_internal_core__array__equality__impl&__0_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (U&. Dcr) (U& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized U&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!cmp.PartialEq. T&. T& U&. U&)
    )
    (tr_bound%core!cmp.PartialEq. $ (ARRAY T&. T& N&. N&) $slice (SLICE U&. U&))
   )
   :pattern ((tr_bound%core!cmp.PartialEq. $ (ARRAY T&. T& N&. N&) $slice (SLICE U&. U&)))
   :qid internal_core__array__equality__impl&__1_trait_impl_definition
   :skolemid skolem_internal_core__array__equality__impl&__1_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (U&. Dcr) (U& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized U&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!cmp.PartialEq. T&. T& U&. U&)
    )
    (tr_bound%core!cmp.PartialEq. $ (ARRAY T&. T& N&. N&) (REF $slice) (SLICE U&. U&))
   )
   :pattern ((tr_bound%core!cmp.PartialEq. $ (ARRAY T&. T& N&. N&) (REF $slice) (SLICE
      U&. U&
   )))
   :qid internal_core__array__equality__impl&__3_trait_impl_definition
   :skolemid skolem_internal_core__array__equality__impl&__3_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (U&. Dcr) (U& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized U&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!cmp.PartialEq. T&. T& U&. U&)
    )
    (tr_bound%core!cmp.PartialEq. $slice (SLICE T&. T&) $ (ARRAY U&. U& N&. N&))
   )
   :pattern ((tr_bound%core!cmp.PartialEq. $slice (SLICE T&. T&) $ (ARRAY U&. U& N&. N&)))
   :qid internal_core__array__equality__impl&__2_trait_impl_definition
   :skolemid skolem_internal_core__array__equality__impl&__2_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (U&. Dcr) (U& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized U&.)
     (tr_bound%core!cmp.PartialEq. T&. T& U&. U&)
    )
    (tr_bound%core!cmp.PartialEq. $slice (SLICE T&. T&) $slice (SLICE U&. U&))
   )
   :pattern ((tr_bound%core!cmp.PartialEq. $slice (SLICE T&. T&) $slice (SLICE U&. U&)))
   :qid internal_core__slice__cmp__impl&__0_trait_impl_definition
   :skolemid skolem_internal_core__slice__cmp__impl&__0_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized E&.)
     (tr_bound%core!cmp.PartialEq. T&. T& T&. T&)
     (tr_bound%core!cmp.PartialEq. E&. E& E&. E&)
    )
    (tr_bound%core!cmp.PartialEq. $ (TYPE%core!result.Result. T&. T& E&. E&) $ (TYPE%core!result.Result.
      T&. T& E&. E&
   )))
   :pattern ((tr_bound%core!cmp.PartialEq. $ (TYPE%core!result.Result. T&. T& E&. E&)
     $ (TYPE%core!result.Result. T&. T& E&. E&)
   ))
   :qid internal_core__result__impl&__34_trait_impl_definition
   :skolemid skolem_internal_core__result__impl&__34_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ TYPE%core!time.Duration. $ TYPE%core!time.Duration.)
)

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!cmp.PartialEq. T&. T& T&. T&)
    )
    (tr_bound%core!cmp.PartialEq. (DST T&.) (TYPE%tuple%1. T&. T&) (DST T&.) (TYPE%tuple%1.
      T&. T&
   )))
   :pattern ((tr_bound%core!cmp.PartialEq. (DST T&.) (TYPE%tuple%1. T&. T&) (DST T&.)
     (TYPE%tuple%1. T&. T&)
   ))
   :qid internal_core__tuple__impl&__0_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__0_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((U&. Dcr) (U& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized U&.)
     (sized T&.)
     (tr_bound%core!cmp.PartialEq. U&. U& U&. U&)
     (tr_bound%core!cmp.PartialEq. T&. T& T&. T&)
    )
    (tr_bound%core!cmp.PartialEq. (DST T&.) (TYPE%tuple%2. U&. U& T&. T&) (DST T&.) (TYPE%tuple%2.
      U&. U& T&. T&
   )))
   :pattern ((tr_bound%core!cmp.PartialEq. (DST T&.) (TYPE%tuple%2. U&. U& T&. T&) (DST
      T&.
     ) (TYPE%tuple%2. U&. U& T&. T&)
   ))
   :qid internal_core__tuple__impl&__10_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__10_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!cmp.PartialOrd. (CONST_PTR $) (PTR T&. T&) (CONST_PTR $) (PTR T&. T&))
   :pattern ((tr_bound%core!cmp.PartialOrd. (CONST_PTR $) (PTR T&. T&) (CONST_PTR $) (
      PTR T&. T&
   )))
   :qid internal_core__ptr__const_ptr__impl&__9_trait_impl_definition
   :skolemid skolem_internal_core__ptr__const_ptr__impl&__9_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!cmp.PartialOrd. $ (PTR T&. T&) $ (PTR T&. T&))
   :pattern ((tr_bound%core!cmp.PartialOrd. $ (PTR T&. T&) $ (PTR T&. T&)))
   :qid internal_core__ptr__mut_ptr__impl&__9_trait_impl_definition
   :skolemid skolem_internal_core__ptr__mut_ptr__impl&__9_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ TYPE%tuple%0. $ TYPE%tuple%0.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ BOOL $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ CHAR $ CHAR)
)

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type) (B&. Dcr) (B& Type)) (!
   (=>
    (tr_bound%core!cmp.PartialOrd. A&. A& B&. B&)
    (tr_bound%core!cmp.PartialOrd. (REF A&.) A& (REF B&.) B&)
   )
   :pattern ((tr_bound%core!cmp.PartialOrd. (REF A&.) A& (REF B&.) B&))
   :qid internal_core__cmp__impls__impl&__10_trait_impl_definition
   :skolemid skolem_internal_core__cmp__impls__impl&__10_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!cmp.PartialOrd. T&. T& T&. T&)
    )
    (tr_bound%core!cmp.PartialOrd. $ (ARRAY T&. T& N&. N&) $ (ARRAY T&. T& N&. N&))
   )
   :pattern ((tr_bound%core!cmp.PartialOrd. $ (ARRAY T&. T& N&. N&) $ (ARRAY T&. T& N&.
      N&
   )))
   :qid internal_core__array__impl&__17_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__17_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized E&.)
     (tr_bound%core!cmp.PartialOrd. T&. T& T&. T&)
     (tr_bound%core!cmp.PartialOrd. E&. E& E&. E&)
    )
    (tr_bound%core!cmp.PartialOrd. $ (TYPE%core!result.Result. T&. T& E&. E&) $ (TYPE%core!result.Result.
      T&. T& E&. E&
   )))
   :pattern ((tr_bound%core!cmp.PartialOrd. $ (TYPE%core!result.Result. T&. T& E&. E&)
     $ (TYPE%core!result.Result. T&. T& E&. E&)
   ))
   :qid internal_core__result__impl&__35_trait_impl_definition
   :skolemid skolem_internal_core__result__impl&__35_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!cmp.PartialOrd. T&. T& T&. T&)
    )
    (tr_bound%core!cmp.PartialOrd. $slice (SLICE T&. T&) $slice (SLICE T&. T&))
   )
   :pattern ((tr_bound%core!cmp.PartialOrd. $slice (SLICE T&. T&) $slice (SLICE T&. T&)))
   :qid internal_core__slice__cmp__impl&__3_trait_impl_definition
   :skolemid skolem_internal_core__slice__cmp__impl&__3_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $slice STRSLICE $slice STRSLICE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ TYPE%core!time.Duration. $ TYPE%core!time.Duration.)
)

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!cmp.PartialOrd. T&. T& T&. T&)
    )
    (tr_bound%core!cmp.PartialOrd. (DST T&.) (TYPE%tuple%1. T&. T&) (DST T&.) (TYPE%tuple%1.
      T&. T&
   )))
   :pattern ((tr_bound%core!cmp.PartialOrd. (DST T&.) (TYPE%tuple%1. T&. T&) (DST T&.)
     (TYPE%tuple%1. T&. T&)
   ))
   :qid internal_core__tuple__impl&__4_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__4_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((U&. Dcr) (U& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized U&.)
     (sized T&.)
     (tr_bound%core!cmp.PartialOrd. U&. U& U&. U&)
     (tr_bound%core!cmp.PartialOrd. T&. T& T&. T&)
    )
    (tr_bound%core!cmp.PartialOrd. (DST T&.) (TYPE%tuple%2. U&. U& T&. T&) (DST T&.) (
      TYPE%tuple%2. U&. U& T&. T&
   )))
   :pattern ((tr_bound%core!cmp.PartialOrd. (DST T&.) (TYPE%tuple%2. U&. U& T&. T&) (DST
      T&.
     ) (TYPE%tuple%2. U&. U& T&. T&)
   ))
   :qid internal_core__tuple__impl&__14_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__14_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) USIZE (REF $) USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (UINT 8) (REF $) (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (UINT 32) $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (UINT 32) (REF $) (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (UINT 64) (REF $) (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (UINT 128) $ (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (UINT 128) (REF $) (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (SINT 32) (REF $) (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ USIZE (REF $) USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (UINT 8) (REF $) (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (UINT 32) (REF $) (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (UINT 64) (REF $) (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (UINT 128) (REF $) (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (SINT 32) (REF $) (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ TYPE%core!time.Duration. $ TYPE%core!time.Duration.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) USIZE (REF $) USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) (UINT 8) (REF $) (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) (UINT 32) $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) (UINT 32) (REF $) (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) (UINT 64) (REF $) (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) (UINT 128) $ (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) (UINT 128) (REF $) (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) (SINT 32) (REF $) (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ USIZE (REF $) USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ (UINT 8) (REF $) (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ (UINT 32) (REF $) (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ (UINT 64) (REF $) (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ (UINT 128) (REF $) (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ (SINT 32) (REF $) (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ TYPE%core!time.Duration. $ TYPE%core!time.Duration.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. (REF $) USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. (REF $) USIZE (REF $) USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. (REF $) (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. (REF $) (UINT 8) (REF $) (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. (REF $) (UINT 32) $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. (REF $) (UINT 32) (REF $) (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. (REF $) (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. (REF $) (UINT 64) (REF $) (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. (REF $) (UINT 128) $ (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. (REF $) (UINT 128) (REF $) (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. (REF $) (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. (REF $) (SINT 32) (REF $) (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. $ USIZE (REF $) USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. $ (UINT 8) (REF $) (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. $ (UINT 32) (REF $) (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. $ (UINT 32) $ TYPE%core!time.Duration.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. $ (UINT 64) (REF $) (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. $ (UINT 128) (REF $) (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. $ (SINT 32) (REF $) (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. $ TYPE%core!time.Duration. $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Neg. (REF $) (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (forall ((I&. Dcr) (I& Type)) (!
   (=>
    (and
     (sized I&.)
     (tr_bound%core!slice.index.SliceIndex. I&. I& $slice STRSLICE)
    )
    (tr_bound%core!ops.index.Index. $slice STRSLICE I&. I&)
   )
   :pattern ((tr_bound%core!ops.index.Index. $slice STRSLICE I&. I&))
   :qid internal_core__str__traits__impl&__4_trait_impl_definition
   :skolemid skolem_internal_core__str__traits__impl&__4_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((I&. Dcr) (I& Type)) (!
   (=>
    (and
     (sized I&.)
     (tr_bound%core!slice.index.SliceIndex. I&. I& $slice STRSLICE)
    )
    (tr_bound%core!ops.index.IndexMut. $slice STRSLICE I&. I&)
   )
   :pattern ((tr_bound%core!ops.index.IndexMut. $slice STRSLICE I&. I&))
   :qid internal_core__str__traits__impl&__5_trait_impl_definition
   :skolemid skolem_internal_core__str__traits__impl&__5_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!iter.range.Step. $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!iter.range.Step. $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!iter.range.Step. $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!iter.range.Step. $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!iter.range.Step. $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!iter.range.Step. $ (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!iter.range.Step. $ CHAR)
)

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized A&.)
     (tr_bound%core!iter.range.Step. A&. A&)
    )
    (tr_bound%core!iter.traits.iterator.Iterator. $ (TYPE%core!ops.range.Range. A&. A&))
   )
   :pattern ((tr_bound%core!iter.traits.iterator.Iterator. $ (TYPE%core!ops.range.Range.
      A&. A&
   )))
   :qid internal_core__iter__range__impl&__6_trait_impl_definition
   :skolemid skolem_internal_core__iter__range__impl&__6_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%core!slice.index.SliceIndex. $ (TYPE%core!ops.range.Range. $ USIZE) $slice
     (SLICE T&. T&)
   ))
   :pattern ((tr_bound%core!slice.index.SliceIndex. $ (TYPE%core!ops.range.Range. $ USIZE)
     $slice (SLICE T&. T&)
   ))
   :qid internal_core__slice__index__impl&__4_trait_impl_definition
   :skolemid skolem_internal_core__slice__index__impl&__4_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!slice.index.SliceIndex. $ (TYPE%core!ops.range.Range. $ USIZE) $slice
  STRSLICE
))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (tr_bound%core!alloc.Allocator. A&. A&)
    (tr_bound%core!alloc.Allocator. (REF A&.) A&)
   )
   :pattern ((tr_bound%core!alloc.Allocator. (REF A&.) A&))
   :qid internal_core__alloc__impl&__2_trait_impl_definition
   :skolemid skolem_internal_core__alloc__impl&__2_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (sized A&.)
    (tr_bound%core!clone.Clone. (TRACKED A&.) A&)
   )
   :pattern ((tr_bound%core!clone.Clone. (TRACKED A&.) A&))
   :qid internal_verus_builtin__impl&__5_trait_impl_definition
   :skolemid skolem_internal_verus_builtin__impl&__5_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (sized A&.)
    (tr_bound%core!clone.Clone. (GHOST A&.) A&)
   )
   :pattern ((tr_bound%core!clone.Clone. (GHOST A&.) A&))
   :qid internal_verus_builtin__impl&__3_trait_impl_definition
   :skolemid skolem_internal_verus_builtin__impl&__3_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!clone.Clone. T&. T&)
    )
    (tr_bound%core!clone.Clone. $ (TYPE%core!option.Option. T&. T&))
   )
   :pattern ((tr_bound%core!clone.Clone. $ (TYPE%core!option.Option. T&. T&)))
   :qid internal_core__option__impl&__5_trait_impl_definition
   :skolemid skolem_internal_core__option__impl&__5_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized A&.)
     (tr_bound%core!clone.Clone. T&. T&)
     (tr_bound%core!alloc.Allocator. A&. A&)
     (tr_bound%core!clone.Clone. A&. A&)
    )
    (tr_bound%core!clone.Clone. (BOX A&. A& T&.) T&)
   )
   :pattern ((tr_bound%core!clone.Clone. (BOX A&. A& T&.) T&))
   :qid internal_alloc__boxed__impl&__13_trait_impl_definition
   :skolemid skolem_internal_alloc__boxed__impl&__13_trait_impl_definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::mul_lemmas::lemma_mul_le
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_le. (Int
  Int Int Int
 ) Bool
)
(declare-const %%global_location_label%%20 Bool)
(declare-const %%global_location_label%%21 Bool)
(assert
 (forall ((a1! Int) (b1! Int) (a2! Int) (b2! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_le. a1! b1! a2!
     b2!
    ) (and
     (=>
      %%global_location_label%%20
      (<= a1! b1!)
     )
     (=>
      %%global_location_label%%21
      (<= a2! b2!)
   )))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_le. a1! b1!
     a2! b2!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_le._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_le._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_le. (Int
  Int Int Int
 ) Bool
)
(assert
 (forall ((a1! Int) (b1! Int) (a2! Int) (b2! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_le. a1! b1! a2!
     b2!
    ) (<= (nClip (Mul a1! a2!)) (nClip (Mul b1! b2!)))
   )
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_le. a1! b1!
     a2! b2!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_le._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_le._definition
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

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::load8_lemmas::lemma_load8_at_plus_version_is_spec
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.load8_lemmas.lemma_load8_at_plus_version_is_spec.
 (slice%<u8.>. Int) Bool
)
(assert
 (forall ((input! slice%<u8.>.) (i! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.load8_lemmas.lemma_load8_at_plus_version_is_spec.
     input! i!
    ) (= (curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_plus_version_rec.?
      (Poly%slice%<u8.>. input!) (I i!) (I 7)
     ) (curve25519_dalek!specs.core_specs.spec_load8_at.? (Poly%slice%<u8.>. input!) (I
       i!
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.load8_lemmas.lemma_load8_at_plus_version_is_spec.
     input! i!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.load8_lemmas.lemma_load8_at_plus_version_is_spec._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.load8_lemmas.lemma_load8_at_plus_version_is_spec._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::load8_lemmas::lemma_spec_load8_at_fits_u64
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.load8_lemmas.lemma_spec_load8_at_fits_u64.
 (slice%<u8.>. Int) Bool
)
(declare-const %%global_location_label%%22 Bool)
(assert
 (forall ((input! slice%<u8.>.) (i! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.load8_lemmas.lemma_spec_load8_at_fits_u64.
     input! i!
    ) (=>
     %%global_location_label%%22
     (< (Add i! 7) (vstd!slice.spec_slice_len.? $ (UINT 8) (Poly%slice%<u8.>. input!)))
   ))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.load8_lemmas.lemma_spec_load8_at_fits_u64.
     input! i!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.load8_lemmas.lemma_spec_load8_at_fits_u64._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.load8_lemmas.lemma_spec_load8_at_fits_u64._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.load8_lemmas.lemma_spec_load8_at_fits_u64.
 (slice%<u8.>. Int) Bool
)
(assert
 (forall ((input! slice%<u8.>.) (i! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.load8_lemmas.lemma_spec_load8_at_fits_u64.
     input! i!
    ) (<= (curve25519_dalek!specs.core_specs.spec_load8_at.? (Poly%slice%<u8.>. input!)
      (I i!)
     ) 18446744073709551615
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.load8_lemmas.lemma_spec_load8_at_fits_u64.
     input! i!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.load8_lemmas.lemma_spec_load8_at_fits_u64._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.load8_lemmas.lemma_spec_load8_at_fits_u64._definition
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

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::load8_lemmas::lemma_load8_at_rec_version_is_exec
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.load8_lemmas.lemma_load8_at_rec_version_is_exec.
 (slice%<u8.>. Int) Bool
)
(assert
 (forall ((input! slice%<u8.>.) (i! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.load8_lemmas.lemma_load8_at_rec_version_is_exec.
     input! i!
    ) (= (curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_or_version_rec.? (
       Poly%slice%<u8.>. input!
      ) (I i!) (I 7)
     ) (uClip 64 (bitor (I (uClip 64 (bitor (I (uClip 64 (bitor (I (uClip 64 (bitor (I (uClip 64 (bitor
                   (I (uClip 64 (bitor (I (uClip 64 (bitor (I (uClip 64 (%I (vstd!seq.Seq.index.? $ (UINT 8) (
                              vstd!view.View.view.? $slice (SLICE $ (UINT 8)) (Poly%slice%<u8.>. input!)
                             ) (I i!)
                          )))
                         ) (I (uClip 64 (bitshl (I (uClip 64 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.?
                                 $slice (SLICE $ (UINT 8)) (Poly%slice%<u8.>. input!)
                                ) (I (Add i! 1))
                             )))
                            ) (I 8)
                       )))))
                      ) (I (uClip 64 (bitshl (I (uClip 64 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.?
                              $slice (SLICE $ (UINT 8)) (Poly%slice%<u8.>. input!)
                             ) (I (Add i! 2))
                          )))
                         ) (I 16)
                    )))))
                   ) (I (uClip 64 (bitshl (I (uClip 64 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.?
                           $slice (SLICE $ (UINT 8)) (Poly%slice%<u8.>. input!)
                          ) (I (Add i! 3))
                       )))
                      ) (I 24)
                 )))))
                ) (I (uClip 64 (bitshl (I (uClip 64 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.?
                        $slice (SLICE $ (UINT 8)) (Poly%slice%<u8.>. input!)
                       ) (I (Add i! 4))
                    )))
                   ) (I 32)
              )))))
             ) (I (uClip 64 (bitshl (I (uClip 64 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.?
                     $slice (SLICE $ (UINT 8)) (Poly%slice%<u8.>. input!)
                    ) (I (Add i! 5))
                 )))
                ) (I 40)
           )))))
          ) (I (uClip 64 (bitshl (I (uClip 64 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.?
                  $slice (SLICE $ (UINT 8)) (Poly%slice%<u8.>. input!)
                 ) (I (Add i! 6))
              )))
             ) (I 48)
        )))))
       ) (I (uClip 64 (bitshl (I (uClip 64 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.?
               $slice (SLICE $ (UINT 8)) (Poly%slice%<u8.>. input!)
              ) (I (Add i! 7))
           )))
          ) (I 56)
   )))))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.load8_lemmas.lemma_load8_at_rec_version_is_exec.
     input! i!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.load8_lemmas.lemma_load8_at_rec_version_is_exec._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.load8_lemmas.lemma_load8_at_rec_version_is_exec._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::load8_lemmas::lemma_load8_at_versions_equivalent
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.load8_lemmas.lemma_load8_at_versions_equivalent.
 (slice%<u8.>. Int Int) Bool
)
(declare-const %%global_location_label%%23 Bool)
(assert
 (forall ((input! slice%<u8.>.) (i! Int) (k! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.load8_lemmas.lemma_load8_at_versions_equivalent.
     input! i! k!
    ) (=>
     %%global_location_label%%23
     (<= k! 7)
   ))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.load8_lemmas.lemma_load8_at_versions_equivalent.
     input! i! k!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.load8_lemmas.lemma_load8_at_versions_equivalent._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.load8_lemmas.lemma_load8_at_versions_equivalent._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.load8_lemmas.lemma_load8_at_versions_equivalent.
 (slice%<u8.>. Int Int) Bool
)
(assert
 (forall ((input! slice%<u8.>.) (i! Int) (k! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.load8_lemmas.lemma_load8_at_versions_equivalent.
     input! i! k!
    ) (= (curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_or_version_rec.? (
       Poly%slice%<u8.>. input!
      ) (I i!) (I k!)
     ) (curve25519_dalek!lemmas.field_lemmas.load8_lemmas.load8_at_plus_version_rec.? (
       Poly%slice%<u8.>. input!
      ) (I i!) (I k!)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.load8_lemmas.lemma_load8_at_versions_equivalent.
     input! i! k!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.load8_lemmas.lemma_load8_at_versions_equivalent._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.load8_lemmas.lemma_load8_at_versions_equivalent._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::field::load8_at
(declare-fun req%curve25519_dalek!backend.serial.u64.field.load8_at. (slice%<u8.>.
  Int
 ) Bool
)
(declare-const %%global_location_label%%24 Bool)
(assert
 (forall ((input! slice%<u8.>.) (i! Int)) (!
   (= (req%curve25519_dalek!backend.serial.u64.field.load8_at. input! i!) (=>
     %%global_location_label%%24
     (< (Add i! 7) (vstd!slice.spec_slice_len.? $ (UINT 8) (Poly%slice%<u8.>. input!)))
   ))
   :pattern ((req%curve25519_dalek!backend.serial.u64.field.load8_at. input! i!))
   :qid internal_req__curve25519_dalek!backend.serial.u64.field.load8_at._definition
   :skolemid skolem_internal_req__curve25519_dalek!backend.serial.u64.field.load8_at._definition
)))
(declare-fun ens%curve25519_dalek!backend.serial.u64.field.load8_at. (slice%<u8.>.
  Int Int
 ) Bool
)
(assert
 (forall ((input! slice%<u8.>.) (i! Int) (r! Int)) (!
   (= (ens%curve25519_dalek!backend.serial.u64.field.load8_at. input! i! r!) (and
     (uInv 64 r!)
     (= r! (curve25519_dalek!specs.core_specs.spec_load8_at.? (Poly%slice%<u8.>. input!)
       (I i!)
   ))))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.field.load8_at. input! i! r!))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.field.load8_at._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.field.load8_at._definition
)))

;; Function-Specs curve25519_dalek::specs::proba_specs::axiom_from_bytes_uniform
(declare-fun req%curve25519_dalek!specs.proba_specs.axiom_from_bytes_uniform. (%%Function%%
  curve25519_dalek!backend.serial.u64.field.FieldElement51.
 ) Bool
)
(declare-const %%global_location_label%%25 Bool)
(assert
 (forall ((bytes! %%Function%%) (fe! curve25519_dalek!backend.serial.u64.field.FieldElement51.))
  (!
   (= (req%curve25519_dalek!specs.proba_specs.axiom_from_bytes_uniform. bytes! fe!) (
     =>
     %%global_location_label%%25
     (= (curve25519_dalek!specs.field_specs.fe51_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        fe!
       )
      ) (EucMod (curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly%array%. bytes!))
       (vstd!arithmetic.power2.pow2.? (I 255))
   ))))
   :pattern ((req%curve25519_dalek!specs.proba_specs.axiom_from_bytes_uniform. bytes!
     fe!
   ))
   :qid internal_req__curve25519_dalek!specs.proba_specs.axiom_from_bytes_uniform._definition
   :skolemid skolem_internal_req__curve25519_dalek!specs.proba_specs.axiom_from_bytes_uniform._definition
)))
(declare-fun ens%curve25519_dalek!specs.proba_specs.axiom_from_bytes_uniform. (%%Function%%
  curve25519_dalek!backend.serial.u64.field.FieldElement51.
 ) Bool
)
(assert
 (forall ((bytes! %%Function%%) (fe! curve25519_dalek!backend.serial.u64.field.FieldElement51.))
  (!
   (= (ens%curve25519_dalek!specs.proba_specs.axiom_from_bytes_uniform. bytes! fe!) (
     =>
     (curve25519_dalek!specs.proba_specs.is_uniform_bytes.? (vstd!array.spec_array_as_slice.?
       $ (UINT 8) $ (CONST_INT 32) (Poly%array%. bytes!)
     ))
     (curve25519_dalek!specs.proba_specs.is_uniform_field_element.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       fe!
   ))))
   :pattern ((ens%curve25519_dalek!specs.proba_specs.axiom_from_bytes_uniform. bytes!
     fe!
   ))
   :qid internal_ens__curve25519_dalek!specs.proba_specs.axiom_from_bytes_uniform._definition
   :skolemid skolem_internal_ens__curve25519_dalek!specs.proba_specs.axiom_from_bytes_uniform._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::field::FieldElement51::from_bytes
(declare-fun ens%curve25519_dalek!backend.serial.u64.field.impl&%16.from_bytes. (%%Function%%
  curve25519_dalek!backend.serial.u64.field.FieldElement51.
 ) Bool
)
(assert
 (forall ((bytes! %%Function%%) (r! curve25519_dalek!backend.serial.u64.field.FieldElement51.))
  (!
   (= (ens%curve25519_dalek!backend.serial.u64.field.impl&%16.from_bytes. bytes! r!)
    (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. r!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (= (curve25519_dalek!specs.field_specs.fe51_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        r!
       )
      ) (EucMod (curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly%array%. bytes!))
       (vstd!arithmetic.power2.pow2.? (I 255))
     ))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       r!
      ) (I 51)
     )
     (=>
      (curve25519_dalek!specs.proba_specs.is_uniform_bytes.? (vstd!array.spec_array_as_slice.?
        $ (UINT 8) $ (CONST_INT 32) (Poly%array%. bytes!)
      ))
      (curve25519_dalek!specs.proba_specs.is_uniform_field_element.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        r!
   )))))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.field.impl&%16.from_bytes. bytes!
     r!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__16.from_bytes._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__16.from_bytes._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::reduce_lemmas::lemma_reduce_boundaries
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.reduce_lemmas.lemma_reduce_boundaries.
 (%%Function%%) Bool
)
(assert
 (forall ((limbs! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.reduce_lemmas.lemma_reduce_boundaries.
     limbs!
    ) (and
     (< (Add (uClip 64 (bitand (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
             $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs!)
            ) (I 0)
          ))
         ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
        )
       ) (Mul (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
              $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs!)
             ) (I 4)
           ))
          ) (I 51)
         )
        ) 19
       )
      ) (uClip 64 (bitshl (I 1) (I 52)))
     )
     (< (Add (uClip 64 (bitand (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
             $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs!)
            ) (I 1)
          ))
         ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
        )
       ) (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
              ARRAY $ (UINT 64) $ (CONST_INT 5)
             ) (Poly%array%. limbs!)
            ) (I 0)
          ))
         ) (I 51)
       ))
      ) (uClip 64 (bitshl (I 1) (I 52)))
     )
     (< (Add (uClip 64 (bitand (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
             $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs!)
            ) (I 2)
          ))
         ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
        )
       ) (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
              ARRAY $ (UINT 64) $ (CONST_INT 5)
             ) (Poly%array%. limbs!)
            ) (I 1)
          ))
         ) (I 51)
       ))
      ) (uClip 64 (bitshl (I 1) (I 52)))
     )
     (< (Add (uClip 64 (bitand (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
             $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs!)
            ) (I 3)
          ))
         ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
        )
       ) (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
              ARRAY $ (UINT 64) $ (CONST_INT 5)
             ) (Poly%array%. limbs!)
            ) (I 2)
          ))
         ) (I 51)
       ))
      ) (uClip 64 (bitshl (I 1) (I 52)))
     )
     (< (Add (uClip 64 (bitand (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
             $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs!)
            ) (I 4)
          ))
         ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
        )
       ) (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
              ARRAY $ (UINT 64) $ (CONST_INT 5)
             ) (Poly%array%. limbs!)
            ) (I 3)
          ))
         ) (I 51)
       ))
      ) (uClip 64 (bitshl (I 1) (I 52)))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.reduce_lemmas.lemma_reduce_boundaries.
     limbs!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.reduce_lemmas.lemma_reduce_boundaries._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.reduce_lemmas.lemma_reduce_boundaries._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::reduce_lemmas::proof_reduce
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.reduce_lemmas.proof_reduce.
 (%%Function%%) Bool
)
(assert
 (forall ((limbs! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.reduce_lemmas.proof_reduce. limbs!) (
     and
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
             ) (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_reduce.? (Poly%array%.
                limbs!
             )))
            ) i$
           )
          ) (uClip 64 (bitshl (I 1) (I 52)))
       )))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_reduce.? (Poly%array%.
             limbs!
          )))
         ) i$
       ))
       :qid user_curve25519_dalek__lemmas__field_lemmas__reduce_lemmas__proof_reduce_69
       :skolemid skolem_user_curve25519_dalek__lemmas__field_lemmas__reduce_lemmas__proof_reduce_69
     ))
     (=>
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
              ) (Poly%array%. limbs!)
             ) i$
            )
           ) (uClip 64 (bitshl (I 1) (I 51)))
        )))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) (Poly%array%. limbs!)
          ) i$
        ))
        :qid user_curve25519_dalek__lemmas__field_lemmas__reduce_lemmas__proof_reduce_70
        :skolemid skolem_user_curve25519_dalek__lemmas__field_lemmas__reduce_lemmas__proof_reduce_70
      ))
      (ext_eq false (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_reduce.?
         (Poly%array%. limbs!)
        )
       ) (Poly%array%. limbs!)
     ))
     (= (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_reduce.?
         (Poly%array%. limbs!)
       ))
      ) (Sub (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. limbs!))
       (Mul (curve25519_dalek!specs.field_specs_u64.p.? (I 0)) (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.?
             $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
               limbs!
              )
             ) (I 4)
           ))
          ) (I 51)
     )))))
     (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_reduce.?
          (Poly%array%. limbs!)
        ))
       ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
      ) (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. limbs!))
       (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.reduce_lemmas.proof_reduce. limbs!))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.reduce_lemmas.proof_reduce._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.reduce_lemmas.proof_reduce._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::as_bytes_lemmas::lemma_as_bytes_boundaries1
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.as_bytes_lemmas.lemma_as_bytes_boundaries1.
 (%%Function%%) Bool
)
(assert
 (forall ((raw_limbs! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.as_bytes_lemmas.lemma_as_bytes_boundaries1.
     raw_limbs!
    ) (and
     (< (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_reduce.? (Poly%array%.
             raw_limbs!
          )))
         ) (I 0)
        )
       ) 19
      ) 18446744073709551615
     )
     (< (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_reduce.? (Poly%array%.
             raw_limbs!
          )))
         ) (I 1)
        )
       ) 2
      ) 18446744073709551615
     )
     (< (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_reduce.? (Poly%array%.
             raw_limbs!
          )))
         ) (I 2)
        )
       ) 2
      ) 18446744073709551615
     )
     (< (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_reduce.? (Poly%array%.
             raw_limbs!
          )))
         ) (I 3)
        )
       ) 2
      ) 18446744073709551615
     )
     (< (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_reduce.? (Poly%array%.
             raw_limbs!
          )))
         ) (I 4)
        )
       ) 2
      ) 18446744073709551615
     )
     (forall ((i$ Poly)) (!
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 0 tmp%%$)
           (<= tmp%%$ 4)
         ))
         (<= (uClip 64 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                UINT 64
               ) $ (CONST_INT 5)
              ) (Poly%array%. (curve25519_dalek!specs.field_specs_u64.compute_q_arr.? (Poly%array%.
                 (curve25519_dalek!specs.field_specs_u64.spec_reduce.? (Poly%array%. raw_limbs!))
              )))
             ) i$
           ))
          ) 2
       )))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!specs.field_specs_u64.compute_q_arr.? (Poly%array%.
             (curve25519_dalek!specs.field_specs_u64.spec_reduce.? (Poly%array%. raw_limbs!))
          )))
         ) i$
       ))
       :qid user_curve25519_dalek__lemmas__field_lemmas__as_bytes_lemmas__lemma_as_bytes_boundaries1_71
       :skolemid skolem_user_curve25519_dalek__lemmas__field_lemmas__as_bytes_lemmas__lemma_as_bytes_boundaries1_71
     ))
     (<= (Add (uClip 64 (bitshl (I 1) (I 52))) 19) 18446744073709551615)
     (= (uClip 64 (bitshr (I (uClip 64 (Add (uClip 64 (bitshl (I 1) (I 52))) 19))) (I 51)))
      2
     )
     (= (uClip 64 (bitshr (I (uClip 64 (Add (uClip 64 (bitshl (I 1) (I 52))) 2))) (I 51)))
      2
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.as_bytes_lemmas.lemma_as_bytes_boundaries1.
     raw_limbs!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.as_bytes_lemmas.lemma_as_bytes_boundaries1._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.as_bytes_lemmas.lemma_as_bytes_boundaries1._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::reduce_lemmas::lemma_reduce_bound_2p
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.reduce_lemmas.lemma_reduce_bound_2p.
 (%%Function%%) Bool
)
(assert
 (forall ((limbs! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.reduce_lemmas.lemma_reduce_bound_2p. limbs!)
    (< (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_reduce.?
        (Poly%array%. limbs!)
      ))
     ) (nClip (Mul 2 (curve25519_dalek!specs.field_specs_u64.p.? (I 0))))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.reduce_lemmas.lemma_reduce_bound_2p.
     limbs!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.reduce_lemmas.lemma_reduce_bound_2p._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.reduce_lemmas.lemma_reduce_bound_2p._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::compute_q_lemmas::lemma_compute_q
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.compute_q_lemmas.lemma_compute_q.
 (%%Function%% Int) Bool
)
(declare-const %%global_location_label%%26 Bool)
(declare-const %%global_location_label%%27 Bool)
(declare-const %%global_location_label%%28 Bool)
(assert
 (forall ((limbs! %%Function%%) (q! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.compute_q_lemmas.lemma_compute_q. limbs!
     q!
    ) (and
     (=>
      %%global_location_label%%26
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
              ) (Poly%array%. limbs!)
             ) i$
            )
           ) (uClip 64 (bitshl (I 1) (I 52)))
        )))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) (Poly%array%. limbs!)
          ) i$
        ))
        :qid user_curve25519_dalek__lemmas__field_lemmas__compute_q_lemmas__lemma_compute_q_72
        :skolemid skolem_user_curve25519_dalek__lemmas__field_lemmas__compute_q_lemmas__lemma_compute_q_72
     )))
     (=>
      %%global_location_label%%27
      (< (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. limbs!)) (
        nClip (Mul 2 (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )))
     (=>
      %%global_location_label%%28
      (= q! (curve25519_dalek!specs.field_specs_u64.compute_q_spec.? (Poly%array%. limbs!)))
   )))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.compute_q_lemmas.lemma_compute_q.
     limbs! q!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.compute_q_lemmas.lemma_compute_q._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.compute_q_lemmas.lemma_compute_q._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.compute_q_lemmas.lemma_compute_q.
 (%%Function%% Int) Bool
)
(assert
 (forall ((limbs! %%Function%%) (q! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.compute_q_lemmas.lemma_compute_q. limbs!
     q!
    ) (and
     (or
      (= q! 0)
      (= q! 1)
     )
     (= (>= (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. limbs!))
       (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
      ) (= q! 1)
     )
     (= (< (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. limbs!))
       (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
      ) (= q! 0)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.compute_q_lemmas.lemma_compute_q.
     limbs! q!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.compute_q_lemmas.lemma_compute_q._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.compute_q_lemmas.lemma_compute_q._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::as_bytes_lemmas::lemma_as_bytes_boundaries2
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.as_bytes_lemmas.lemma_as_bytes_boundaries2.
 (%%Function%%) Bool
)
(assert
 (forall ((raw_limbs! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.as_bytes_lemmas.lemma_as_bytes_boundaries2.
     raw_limbs!
    ) (and
     (= curve25519_dalek!specs.field_specs_u64.mask51.? (Sub (uClip 64 (bitshl (I 1) (I 51)))
       1
     ))
     (<= (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
            (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!specs.field_specs_u64.compute_unmasked_limbs.?
              (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_reduce.? (Poly%array%. raw_limbs!)))
              (I (curve25519_dalek!specs.field_specs_u64.compute_q_spec.? (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_reduce.?
                  (Poly%array%. raw_limbs!)
            ))))))
           ) (I 0)
         ))
        ) (I 51)
       )
      ) 2
     )
     (<= (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
            (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!specs.field_specs_u64.compute_unmasked_limbs.?
              (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_reduce.? (Poly%array%. raw_limbs!)))
              (I (curve25519_dalek!specs.field_specs_u64.compute_q_spec.? (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_reduce.?
                  (Poly%array%. raw_limbs!)
            ))))))
           ) (I 1)
         ))
        ) (I 51)
       )
      ) 2
     )
     (<= (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
            (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!specs.field_specs_u64.compute_unmasked_limbs.?
              (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_reduce.? (Poly%array%. raw_limbs!)))
              (I (curve25519_dalek!specs.field_specs_u64.compute_q_spec.? (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_reduce.?
                  (Poly%array%. raw_limbs!)
            ))))))
           ) (I 2)
         ))
        ) (I 51)
       )
      ) 2
     )
     (<= (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
            (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!specs.field_specs_u64.compute_unmasked_limbs.?
              (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_reduce.? (Poly%array%. raw_limbs!)))
              (I (curve25519_dalek!specs.field_specs_u64.compute_q_spec.? (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_reduce.?
                  (Poly%array%. raw_limbs!)
            ))))))
           ) (I 3)
         ))
        ) (I 51)
       )
      ) 2
     )
     (<= (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
            (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!specs.field_specs_u64.compute_unmasked_limbs.?
              (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_reduce.? (Poly%array%. raw_limbs!)))
              (I (curve25519_dalek!specs.field_specs_u64.compute_q_spec.? (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_reduce.?
                  (Poly%array%. raw_limbs!)
            ))))))
           ) (I 4)
         ))
        ) (I 51)
       )
      ) 2
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.as_bytes_lemmas.lemma_as_bytes_boundaries2.
     raw_limbs!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.as_bytes_lemmas.lemma_as_bytes_boundaries2._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.as_bytes_lemmas.lemma_as_bytes_boundaries2._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::to_bytes_reduction_lemmas::lemma_to_bytes_reduction
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.to_bytes_reduction_lemmas.lemma_to_bytes_reduction.
 (%%Function%% %%Function%% Int) Bool
)
(declare-const %%global_location_label%%29 Bool)
(declare-const %%global_location_label%%30 Bool)
(declare-const %%global_location_label%%31 Bool)
(declare-const %%global_location_label%%32 Bool)
(declare-const %%global_location_label%%33 Bool)
(assert
 (forall ((input_limbs! %%Function%%) (final_limbs! %%Function%%) (q! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.to_bytes_reduction_lemmas.lemma_to_bytes_reduction.
     input_limbs! final_limbs! q!
    ) (and
     (=>
      %%global_location_label%%29
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
              ) (Poly%array%. input_limbs!)
             ) i$
            )
           ) (uClip 64 (bitshl (I 1) (I 52)))
        )))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) (Poly%array%. input_limbs!)
          ) i$
        ))
        :qid user_curve25519_dalek__lemmas__field_lemmas__to_bytes_reduction_lemmas__lemma_to_bytes_reduction_73
        :skolemid skolem_user_curve25519_dalek__lemmas__field_lemmas__to_bytes_reduction_lemmas__lemma_to_bytes_reduction_73
     )))
     (=>
      %%global_location_label%%30
      (or
       (= q! 0)
       (= q! 1)
     ))
     (=>
      %%global_location_label%%31
      (= (>= (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. input_limbs!))
        (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
       ) (= q! 1)
     ))
     (=>
      %%global_location_label%%32
      (< (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. input_limbs!))
       (nClip (Mul 2 (curve25519_dalek!specs.field_specs_u64.p.? (I 0))))
     ))
     (=>
      %%global_location_label%%33
      (= final_limbs! (curve25519_dalek!specs.field_specs_u64.reduce_with_q_spec.? (Poly%array%.
         input_limbs!
        ) (I q!)
   )))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.to_bytes_reduction_lemmas.lemma_to_bytes_reduction.
     input_limbs! final_limbs! q!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.to_bytes_reduction_lemmas.lemma_to_bytes_reduction._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.to_bytes_reduction_lemmas.lemma_to_bytes_reduction._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.to_bytes_reduction_lemmas.lemma_to_bytes_reduction.
 (%%Function%% %%Function%% Int) Bool
)
(assert
 (forall ((input_limbs! %%Function%%) (final_limbs! %%Function%%) (q! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.to_bytes_reduction_lemmas.lemma_to_bytes_reduction.
     input_limbs! final_limbs! q!
    ) (and
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
             ) (Poly%array%. final_limbs!)
            ) i$
           )
          ) (uClip 64 (bitshl (I 1) (I 51)))
       )))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) (Poly%array%. final_limbs!)
         ) i$
       ))
       :qid user_curve25519_dalek__lemmas__field_lemmas__to_bytes_reduction_lemmas__lemma_to_bytes_reduction_74
       :skolemid skolem_user_curve25519_dalek__lemmas__field_lemmas__to_bytes_reduction_lemmas__lemma_to_bytes_reduction_74
     ))
     (= (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. final_limbs!))
      (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. input_limbs!))
       (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.to_bytes_reduction_lemmas.lemma_to_bytes_reduction.
     input_limbs! final_limbs! q!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.to_bytes_reduction_lemmas.lemma_to_bytes_reduction._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.to_bytes_reduction_lemmas.lemma_to_bytes_reduction._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::limbs_to_bytes_lemmas::lemma_limbs_to_bytes
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.limbs_to_bytes_lemmas.lemma_limbs_to_bytes.
 (%%Function%% %%Function%%) Bool
)
(declare-const %%global_location_label%%34 Bool)
(declare-const %%global_location_label%%35 Bool)
(assert
 (forall ((limbs! %%Function%%) (bytes! %%Function%%)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.limbs_to_bytes_lemmas.lemma_limbs_to_bytes.
     limbs! bytes!
    ) (and
     (=>
      %%global_location_label%%34
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
              ) (Poly%array%. limbs!)
             ) i$
            )
           ) (uClip 64 (bitshl (I 1) (I 51)))
        )))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) (Poly%array%. limbs!)
          ) i$
        ))
        :qid user_curve25519_dalek__lemmas__field_lemmas__limbs_to_bytes_lemmas__lemma_limbs_to_bytes_75
        :skolemid skolem_user_curve25519_dalek__lemmas__field_lemmas__limbs_to_bytes_lemmas__lemma_limbs_to_bytes_75
     )))
     (=>
      %%global_location_label%%35
      (curve25519_dalek!lemmas.field_lemmas.limbs_to_bytes_lemmas.bytes_match_limbs_packing.?
       (Poly%array%. limbs!) (Poly%array%. bytes!)
   ))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.limbs_to_bytes_lemmas.lemma_limbs_to_bytes.
     limbs! bytes!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.limbs_to_bytes_lemmas.lemma_limbs_to_bytes._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.limbs_to_bytes_lemmas.lemma_limbs_to_bytes._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.limbs_to_bytes_lemmas.lemma_limbs_to_bytes.
 (%%Function%% %%Function%%) Bool
)
(assert
 (forall ((limbs! %%Function%%) (bytes! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.limbs_to_bytes_lemmas.lemma_limbs_to_bytes.
     limbs! bytes!
    ) (= (curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly%array%. bytes!)) (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
      (Poly%array%. limbs!)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.limbs_to_bytes_lemmas.lemma_limbs_to_bytes.
     limbs! bytes!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.limbs_to_bytes_lemmas.lemma_limbs_to_bytes._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.limbs_to_bytes_lemmas.lemma_limbs_to_bytes._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::field::FieldElement51::reduce
(declare-fun ens%curve25519_dalek!backend.serial.u64.field.impl&%16.reduce. (%%Function%%
  curve25519_dalek!backend.serial.u64.field.FieldElement51.
 ) Bool
)
(assert
 (forall ((limbs! %%Function%%) (r! curve25519_dalek!backend.serial.u64.field.FieldElement51.))
  (!
   (= (ens%curve25519_dalek!backend.serial.u64.field.impl&%16.reduce. limbs! r!) (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. r!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (= (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
       (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
         r!
       ))
      ) (curve25519_dalek!specs.field_specs_u64.spec_reduce.? (Poly%array%. limbs!))
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       r!
      ) (I 52)
     )
     (=>
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
              ) (Poly%array%. limbs!)
             ) i$
            )
           ) (uClip 64 (bitshl (I 1) (I 51)))
        )))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) (Poly%array%. limbs!)
          ) i$
        ))
        :qid user_curve25519_dalek__backend__serial__u64__field__FieldElement51__reduce_76
        :skolemid skolem_user_curve25519_dalek__backend__serial__u64__field__FieldElement51__reduce_76
      ))
      (ext_eq false (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
         (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           r!
        )))
       ) (Poly%array%. limbs!)
     ))
     (= (curve25519_dalek!specs.field_specs.fe51_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        r!
       )
      ) (Sub (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. limbs!))
       (Mul (curve25519_dalek!specs.field_specs_u64.p.? (I 0)) (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.?
             $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
               limbs!
              )
             ) (I 4)
           ))
          ) (I 51)
     )))))
     (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        r!
       )
      ) (curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.? (Poly%array%.
        limbs!
     )))
     (< (curve25519_dalek!specs.field_specs.fe51_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        r!
       )
      ) (nClip (Mul 2 (curve25519_dalek!specs.field_specs_u64.p.? (I 0))))
   )))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.field.impl&%16.reduce. limbs! r!))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__16.reduce._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__16.reduce._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::field::FieldElement51::as_bytes
(declare-fun ens%curve25519_dalek!backend.serial.u64.field.impl&%16.as_bytes. (curve25519_dalek!backend.serial.u64.field.FieldElement51.
  %%Function%%
 ) Bool
)
(assert
 (forall ((self! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (r! %%Function%%))
  (!
   (= (ens%curve25519_dalek!backend.serial.u64.field.impl&%16.as_bytes. self! r!) (and
     (has_type (Poly%array%. r!) (ARRAY $ (UINT 8) $ (CONST_INT 32)))
     (= (curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly%array%. r!)) (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
       (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. self!)
   ))))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.field.impl&%16.as_bytes. self! r!))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__16.as_bytes._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__16.as_bytes._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::div_mod_lemmas::lemma_mod_sum_factor
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_factor.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%36 Bool)
(assert
 (forall ((a! Int) (b! Int) (m! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_factor.
     a! b! m!
    ) (=>
     %%global_location_label%%36
     (> m! 0)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_factor.
     a! b! m!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_factor._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_factor._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_factor.
 (Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (m! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_factor.
     a! b! m!
    ) (= (EucMod (Add (Mul a! m!) b!) m!) (EucMod b! m!))
   )
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_factor.
     a! b! m!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_factor._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_factor._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::u64_5_as_nat_lemmas::lemma_u64_5_as_nat_add
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_u64_5_as_nat_add.
 (%%Function%% %%Function%%) Bool
)
(declare-const %%global_location_label%%37 Bool)
(assert
 (forall ((a! %%Function%%) (b! %%Function%%)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_u64_5_as_nat_add.
     a! b!
    ) (=>
     %%global_location_label%%37
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
         (<= (nClip (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $
                (UINT 64) $ (CONST_INT 5)
               ) (Poly%array%. b!)
              ) i$
             )
            ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                (CONST_INT 5)
               ) (Poly%array%. a!)
              ) i$
           )))
          ) 18446744073709551615
       )))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) (Poly%array%. b!)
         ) i$
       ))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) (Poly%array%. a!)
         ) i$
       ))
       :qid user_curve25519_dalek__lemmas__field_lemmas__u64_5_as_nat_lemmas__lemma_u64_5_as_nat_add_79
       :skolemid skolem_user_curve25519_dalek__lemmas__field_lemmas__u64_5_as_nat_lemmas__lemma_u64_5_as_nat_add_79
   ))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_u64_5_as_nat_add.
     a! b!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_u64_5_as_nat_add._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_u64_5_as_nat_add._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_u64_5_as_nat_add.
 (%%Function%% %%Function%%) Bool
)
(assert
 (forall ((a! %%Function%%) (b! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_u64_5_as_nat_add.
     a! b!
    ) (= (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (array_new $ (UINT 64) 5
       (%%array%%0 (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
              $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. a!)
             ) (I 0)
            )
           ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) (Poly%array%. b!)
             ) (I 0)
         ))))
        ) (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
               $ (UINT 64) $ (CONST_INT 5)
              ) (Poly%array%. a!)
             ) (I 1)
            )
           ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) (Poly%array%. b!)
             ) (I 1)
         ))))
        ) (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
               $ (UINT 64) $ (CONST_INT 5)
              ) (Poly%array%. a!)
             ) (I 2)
            )
           ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) (Poly%array%. b!)
             ) (I 2)
         ))))
        ) (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
               $ (UINT 64) $ (CONST_INT 5)
              ) (Poly%array%. a!)
             ) (I 3)
            )
           ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) (Poly%array%. b!)
             ) (I 3)
         ))))
        ) (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
               $ (UINT 64) $ (CONST_INT 5)
              ) (Poly%array%. a!)
             ) (I 4)
            )
           ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) (Poly%array%. b!)
             ) (I 4)
      )))))))
     ) (nClip (Add (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. a!))
       (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. b!))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_u64_5_as_nat_add.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_u64_5_as_nat_add._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_u64_5_as_nat_add._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::add_lemmas::lemma_field51_add
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_field51_add.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.field.FieldElement51.)
 Bool
)
(declare-const %%global_location_label%%38 Bool)
(assert
 (forall ((lhs! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (rhs! curve25519_dalek!backend.serial.u64.field.FieldElement51.))
  (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_field51_add. lhs! rhs!)
    (=>
     %%global_location_label%%38
     (curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       lhs!
      ) (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. rhs!) (I 18446744073709551615)
   )))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_field51_add. lhs!
     rhs!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_field51_add._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_field51_add._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_field51_add.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.field.FieldElement51.)
 Bool
)
(assert
 (forall ((lhs! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (rhs! curve25519_dalek!backend.serial.u64.field.FieldElement51.))
  (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_field51_add. lhs! rhs!)
    (and
     (= (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
         (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             lhs!
            ) (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. rhs!)
       )))))
      ) (nClip (Add (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
           (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             lhs!
         ))))
        ) (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
           (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             rhs!
     ))))))))
     (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          lhs!
         ) (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. rhs!)
       ))
      ) (curve25519_dalek!specs.field_specs.field_add.? (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
         (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. lhs!)
        )
       ) (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          rhs!
   )))))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_field51_add. lhs!
     rhs!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_field51_add._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_field51_add._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::field::impl&%6::add
(declare-fun ens%curve25519_dalek!backend.serial.u64.field.impl&%6.add. (Poly Poly
  Poly
 ) Bool
)
(assert
 (forall ((self! Poly) (_rhs! Poly) (output! Poly)) (!
   (= (ens%curve25519_dalek!backend.serial.u64.field.impl&%6.add. self! _rhs! output!)
    (and
     (ens%core!ops.arith.Add.add. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! _rhs!
      output!
     )
     (= (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. output!) (curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.?
       self! _rhs!
     ))
     (= (curve25519_dalek!specs.field_specs.fe51_as_nat.? output!) (nClip (Add (curve25519_dalek!specs.field_specs.fe51_as_nat.?
         self!
        ) (curve25519_dalek!specs.field_specs.fe51_as_nat.? _rhs!)
     )))
     (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? output!) (curve25519_dalek!specs.field_specs.field_add.?
       (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? self!)) (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
         _rhs!
     ))))
     (=>
      (and
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? self! (I 51))
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? _rhs! (I 51))
      )
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? output! (I 52))
     )
     (=>
      (and
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? self! (I 52))
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? _rhs! (I 52))
      )
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? output! (I 53))
   )))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.field.impl&%6.add. self! _rhs! output!))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__6.add._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__6.add._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::add_lemmas::lemma_field_add_16p_no_overflow
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_field_add_16p_no_overflow.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.field.FieldElement51.)
 Bool
)
(declare-const %%global_location_label%%39 Bool)
(declare-const %%global_location_label%%40 Bool)
(assert
 (forall ((lhs! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (rhs! curve25519_dalek!backend.serial.u64.field.FieldElement51.))
  (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_field_add_16p_no_overflow.
     lhs! rhs!
    ) (and
     (=>
      %%global_location_label%%39
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        lhs!
       ) (I 54)
     ))
     (=>
      %%global_location_label%%40
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        rhs!
       ) (I 54)
   ))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_field_add_16p_no_overflow.
     lhs! rhs!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_field_add_16p_no_overflow._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_field_add_16p_no_overflow._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_field_add_16p_no_overflow.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.field.FieldElement51.)
 Bool
)
(assert
 (forall ((lhs! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (rhs! curve25519_dalek!backend.serial.u64.field.FieldElement51.))
  (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_field_add_16p_no_overflow.
     lhs! rhs!
    ) (and
     (<= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
          $ (CONST_INT 5)
         ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
           (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             lhs!
         ))))
        ) (I 0)
       )
      ) (Sub 18446744073709551615 36028797018963664)
     )
     (<= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
          $ (CONST_INT 5)
         ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
           (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             lhs!
         ))))
        ) (I 1)
       )
      ) (Sub 18446744073709551615 36028797018963952)
     )
     (<= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
          $ (CONST_INT 5)
         ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
           (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             lhs!
         ))))
        ) (I 2)
       )
      ) (Sub 18446744073709551615 36028797018963952)
     )
     (<= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
          $ (CONST_INT 5)
         ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
           (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             lhs!
         ))))
        ) (I 3)
       )
      ) (Sub 18446744073709551615 36028797018963952)
     )
     (<= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
          $ (CONST_INT 5)
         ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
           (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             lhs!
         ))))
        ) (I 4)
       )
      ) (Sub 18446744073709551615 36028797018963952)
     )
     (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
          (CONST_INT 5)
         ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
           (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             rhs!
         ))))
        ) (I 0)
       )
      ) 36028797018963664
     )
     (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
          (CONST_INT 5)
         ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
           (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             rhs!
         ))))
        ) (I 1)
       )
      ) 36028797018963952
     )
     (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
          (CONST_INT 5)
         ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
           (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             rhs!
         ))))
        ) (I 2)
       )
      ) 36028797018963952
     )
     (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
          (CONST_INT 5)
         ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
           (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             rhs!
         ))))
        ) (I 3)
       )
      ) 36028797018963952
     )
     (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
          (CONST_INT 5)
         ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
           (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             rhs!
         ))))
        ) (I 4)
       )
      ) 36028797018963952
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_field_add_16p_no_overflow.
     lhs! rhs!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_field_add_16p_no_overflow._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_field_add_16p_no_overflow._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::u64_5_as_nat_lemmas::lemma_u64_5_as_nat_sub
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_u64_5_as_nat_sub.
 (%%Function%% %%Function%%) Bool
)
(declare-const %%global_location_label%%41 Bool)
(assert
 (forall ((a! %%Function%%) (b! %%Function%%)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_u64_5_as_nat_sub.
     a! b!
    ) (=>
     %%global_location_label%%41
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
         (<= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
              $ (CONST_INT 5)
             ) (Poly%array%. b!)
            ) i$
           )
          ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) (Poly%array%. a!)
            ) i$
       )))))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) (Poly%array%. b!)
         ) i$
       ))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) (Poly%array%. a!)
         ) i$
       ))
       :qid user_curve25519_dalek__lemmas__field_lemmas__u64_5_as_nat_lemmas__lemma_u64_5_as_nat_sub_83
       :skolemid skolem_user_curve25519_dalek__lemmas__field_lemmas__u64_5_as_nat_lemmas__lemma_u64_5_as_nat_sub_83
   ))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_u64_5_as_nat_sub.
     a! b!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_u64_5_as_nat_sub._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_u64_5_as_nat_sub._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_u64_5_as_nat_sub.
 (%%Function%% %%Function%%) Bool
)
(assert
 (forall ((a! %%Function%%) (b! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_u64_5_as_nat_sub.
     a! b!
    ) (= (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (array_new $ (UINT 64) 5
       (%%array%%0 (I (uClip 64 (Sub (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
              $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. a!)
             ) (I 0)
            )
           ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) (Poly%array%. b!)
             ) (I 0)
         ))))
        ) (I (uClip 64 (Sub (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
               $ (UINT 64) $ (CONST_INT 5)
              ) (Poly%array%. a!)
             ) (I 1)
            )
           ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) (Poly%array%. b!)
             ) (I 1)
         ))))
        ) (I (uClip 64 (Sub (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
               $ (UINT 64) $ (CONST_INT 5)
              ) (Poly%array%. a!)
             ) (I 2)
            )
           ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) (Poly%array%. b!)
             ) (I 2)
         ))))
        ) (I (uClip 64 (Sub (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
               $ (UINT 64) $ (CONST_INT 5)
              ) (Poly%array%. a!)
             ) (I 3)
            )
           ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) (Poly%array%. b!)
             ) (I 3)
         ))))
        ) (I (uClip 64 (Sub (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
               $ (UINT 64) $ (CONST_INT 5)
              ) (Poly%array%. a!)
             ) (I 4)
            )
           ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) (Poly%array%. b!)
             ) (I 4)
      )))))))
     ) (Sub (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. a!)) (
       curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. b!)
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_u64_5_as_nat_sub.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_u64_5_as_nat_sub._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_u64_5_as_nat_sub._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::to_bytes_reduction_lemmas::lemma_sub_constants_equal_16p
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.to_bytes_reduction_lemmas.lemma_sub_constants_equal_16p.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.to_bytes_reduction_lemmas.lemma_sub_constants_equal_16p.
     no%param
    ) (= (nClip (Add (nClip (Add (nClip (Add (nClip (Add 36028797018963664 (nClip (Mul (vstd!arithmetic.power2.pow2.?
                (I 51)
               ) 36028797018963952
            )))
           ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 102)) 36028797018963952))
          )
         ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 153)) 36028797018963952))
        )
       ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 204)) 36028797018963952))
      )
     ) (nClip (Mul 16 (curve25519_dalek!specs.field_specs_u64.p.? (I 0))))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.to_bytes_reduction_lemmas.lemma_sub_constants_equal_16p.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.to_bytes_reduction_lemmas.lemma_sub_constants_equal_16p._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.to_bytes_reduction_lemmas.lemma_sub_constants_equal_16p._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::field::impl&%9::sub
(declare-fun ens%curve25519_dalek!backend.serial.u64.field.impl&%9.sub. (Poly Poly
  Poly
 ) Bool
)
(assert
 (forall ((self! Poly) (_rhs! Poly) (output! Poly)) (!
   (= (ens%curve25519_dalek!backend.serial.u64.field.impl&%9.sub. self! _rhs! output!)
    (and
     (ens%core!ops.arith.Sub.sub. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! _rhs!
      output!
     )
     (= (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. output!) (curve25519_dalek!specs.field_specs.spec_sub_limbs.?
       self! _rhs!
     ))
     (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? output!) (curve25519_dalek!specs.field_specs.field_sub.?
       (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? self!)) (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
         _rhs!
     ))))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? output! (I 52))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? output! (I 54))
   ))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.field.impl&%9.sub. self! _rhs! output!))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__9.sub._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__9.sub._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::lemma_pow2k_loop_boundary
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.lemma_pow2k_loop_boundary.
 (%%Function%%) Bool
)
(declare-const %%global_location_label%%42 Bool)
(assert
 (forall ((a! %%Function%%)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.lemma_pow2k_loop_boundary.
     a!
    ) (=>
     %%global_location_label%%42
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
             ) (Poly%array%. a!)
            ) i$
           )
          ) (uClip 64 (bitshl (I 1) (I 54)))
       )))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) (Poly%array%. a!)
         ) i$
       ))
       :qid user_curve25519_dalek__lemmas__field_lemmas__pow2k_lemmas__lemma_pow2k_loop_boundary_87
       :skolemid skolem_user_curve25519_dalek__lemmas__field_lemmas__pow2k_lemmas__lemma_pow2k_loop_boundary_87
   ))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.lemma_pow2k_loop_boundary.
     a!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.lemma_pow2k_loop_boundary._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.lemma_pow2k_loop_boundary._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.lemma_pow2k_loop_boundary.
 (%%Function%%) Bool
)
(assert
 (forall ((a! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.lemma_pow2k_loop_boundary.
     a!
    ) (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_boundary_spec.? (Poly%array%.
      a!
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.lemma_pow2k_loop_boundary.
     a!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.lemma_pow2k_loop_boundary._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.lemma_pow2k_loop_boundary._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_pow_nat_is_nat
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nat_is_nat.
 (Int Int) Bool
)
(assert
 (forall ((v! Int) (i! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nat_is_nat. v! i!)
    (>= (vstd!arithmetic.power.pow.? (I v!) (I (vstd!arithmetic.power2.pow2.? (I i!))))
     0
   ))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nat_is_nat.
     v! i!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nat_is_nat._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nat_is_nat._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::lemma_pow2k_loop_value
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.lemma_pow2k_loop_value.
 (%%Function%% %%Function%% Int) Bool
)
(declare-const %%global_location_label%%43 Bool)
(declare-const %%global_location_label%%44 Bool)
(assert
 (forall ((a! %%Function%%) (limbs! %%Function%%) (i! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.lemma_pow2k_loop_value. a!
     limbs! i!
    ) (and
     (=>
      %%global_location_label%%43
      (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_boundary_spec.? (Poly%array%.
        a!
     )))
     (=>
      %%global_location_label%%44
      (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. a!))
        (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
       ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
            (Poly%array%. limbs!)
           )
          ) (I (vstd!arithmetic.power2.pow2.? (I i!)))
         )
        ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   )))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.lemma_pow2k_loop_value.
     a! limbs! i!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.lemma_pow2k_loop_value._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.lemma_pow2k_loop_value._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.lemma_pow2k_loop_value.
 (%%Function%% %%Function%% Int) Bool
)
(assert
 (forall ((a! %%Function%%) (limbs! %%Function%%) (i! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.lemma_pow2k_loop_value. a!
     limbs! i!
    ) (= (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.?
         (Poly%array%. a!)
       ))
      ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
          (Poly%array%. limbs!)
         )
        ) (I (vstd!arithmetic.power2.pow2.? (I (nClip (Add i! 1)))))
       )
      ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.lemma_pow2k_loop_value.
     a! limbs! i!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.lemma_pow2k_loop_value._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.lemma_pow2k_loop_value._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::field::m
(declare-fun ens%curve25519_dalek!backend.serial.u64.field.m. (Int Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int) (r! Int)) (!
   (= (ens%curve25519_dalek!backend.serial.u64.field.m. x! y! r!) (and
     (uInv 128 r!)
     (= r! (nClip (Mul x! y!)))
     (<= r! 340282366920938463463374607431768211455)
   ))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.field.m. x! y! r!))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.field.m._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.field.m._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::field::FieldElement51::pow2k
(declare-fun req%curve25519_dalek!backend.serial.u64.field.impl&%16.pow2k. (curve25519_dalek!backend.serial.u64.field.FieldElement51.
  Int
 ) Bool
)
(declare-const %%global_location_label%%45 Bool)
(declare-const %%global_location_label%%46 Bool)
(assert
 (forall ((self! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (k! Int))
  (!
   (= (req%curve25519_dalek!backend.serial.u64.field.impl&%16.pow2k. self! k!) (and
     (=>
      %%global_location_label%%45
      (> k! 0)
     )
     (=>
      %%global_location_label%%46
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        self!
       ) (I 54)
   ))))
   :pattern ((req%curve25519_dalek!backend.serial.u64.field.impl&%16.pow2k. self! k!))
   :qid internal_req__curve25519_dalek!backend.serial.u64.field.impl&__16.pow2k._definition
   :skolemid skolem_internal_req__curve25519_dalek!backend.serial.u64.field.impl&__16.pow2k._definition
)))
(declare-fun ens%curve25519_dalek!backend.serial.u64.field.impl&%16.pow2k. (curve25519_dalek!backend.serial.u64.field.FieldElement51.
  Int curve25519_dalek!backend.serial.u64.field.FieldElement51.
 ) Bool
)
(assert
 (forall ((self! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (k! Int)
   (r! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
  ) (!
   (= (ens%curve25519_dalek!backend.serial.u64.field.impl&%16.pow2k. self! k! r!) (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. r!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       r!
      ) (I 52)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       r!
      ) (I 54)
     )
     (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        r!
       )
      ) (curve25519_dalek!specs.field_specs_u64.field_canonical.? (I (nClip (vstd!arithmetic.power.pow.?
          (I (curve25519_dalek!specs.field_specs.fe51_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             self!
           ))
          ) (I (vstd!arithmetic.power2.pow2.? (I k!)))
   )))))))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.field.impl&%16.pow2k. self! k! r!))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__16.pow2k._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__16.pow2k._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::field::FieldElement51::square
(declare-fun req%curve25519_dalek!backend.serial.u64.field.impl&%16.square. (curve25519_dalek!backend.serial.u64.field.FieldElement51.)
 Bool
)
(declare-const %%global_location_label%%47 Bool)
(assert
 (forall ((self! curve25519_dalek!backend.serial.u64.field.FieldElement51.)) (!
   (= (req%curve25519_dalek!backend.serial.u64.field.impl&%16.square. self!) (=>
     %%global_location_label%%47
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       self!
      ) (I 54)
   )))
   :pattern ((req%curve25519_dalek!backend.serial.u64.field.impl&%16.square. self!))
   :qid internal_req__curve25519_dalek!backend.serial.u64.field.impl&__16.square._definition
   :skolemid skolem_internal_req__curve25519_dalek!backend.serial.u64.field.impl&__16.square._definition
)))
(declare-fun ens%curve25519_dalek!backend.serial.u64.field.impl&%16.square. (curve25519_dalek!backend.serial.u64.field.FieldElement51.
  curve25519_dalek!backend.serial.u64.field.FieldElement51.
 ) Bool
)
(assert
 (forall ((self! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (r! curve25519_dalek!backend.serial.u64.field.FieldElement51.))
  (!
   (= (ens%curve25519_dalek!backend.serial.u64.field.impl&%16.square. self! r!) (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. r!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       r!
      ) (I 52)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       r!
      ) (I 54)
     )
     (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        r!
       )
      ) (curve25519_dalek!specs.field_specs_u64.field_canonical.? (I (nClip (vstd!arithmetic.power.pow.?
          (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
              (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                self!
           )))))
          ) (I 2)
   )))))))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.field.impl&%16.square. self! r!))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__16.square._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__16.square._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::mul_lemmas::lemma_mul_boundary
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.lemma_mul_boundary.
 (%%Function%% %%Function%%) Bool
)
(declare-const %%global_location_label%%48 Bool)
(declare-const %%global_location_label%%49 Bool)
(assert
 (forall ((a! %%Function%%) (b! %%Function%%)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.lemma_mul_boundary. a! b!)
    (and
     (=>
      %%global_location_label%%48
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
              ) (Poly%array%. a!)
             ) i$
            )
           ) (uClip 64 (bitshl (I 1) (I 54)))
        )))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) (Poly%array%. a!)
          ) i$
        ))
        :qid user_curve25519_dalek__lemmas__field_lemmas__mul_lemmas__lemma_mul_boundary_89
        :skolemid skolem_user_curve25519_dalek__lemmas__field_lemmas__mul_lemmas__lemma_mul_boundary_89
     )))
     (=>
      %%global_location_label%%49
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
              ) (Poly%array%. b!)
             ) i$
            )
           ) (uClip 64 (bitshl (I 1) (I 54)))
        )))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) (Poly%array%. b!)
          ) i$
        ))
        :qid user_curve25519_dalek__lemmas__field_lemmas__mul_lemmas__lemma_mul_boundary_90
        :skolemid skolem_user_curve25519_dalek__lemmas__field_lemmas__mul_lemmas__lemma_mul_boundary_90
   )))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.lemma_mul_boundary.
     a! b!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.mul_lemmas.lemma_mul_boundary._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.mul_lemmas.lemma_mul_boundary._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.lemma_mul_boundary.
 (%%Function%% %%Function%%) Bool
)
(assert
 (forall ((a! %%Function%%) (b! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.lemma_mul_boundary. a! b!)
    (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_boundary_spec.? (Poly%array%.
      a!
     ) (Poly%array%. b!)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.lemma_mul_boundary.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.mul_lemmas.lemma_mul_boundary._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.mul_lemmas.lemma_mul_boundary._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::mul_lemmas::lemma_mul_value
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.lemma_mul_value.
 (%%Function%% %%Function%%) Bool
)
(declare-const %%global_location_label%%50 Bool)
(assert
 (forall ((a! %%Function%%) (b! %%Function%%)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.lemma_mul_value. a! b!) (=>
     %%global_location_label%%50
     (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_boundary_spec.? (Poly%array%.
       a!
      ) (Poly%array%. b!)
   )))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.lemma_mul_value. a!
     b!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.mul_lemmas.lemma_mul_value._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.mul_lemmas.lemma_mul_value._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.lemma_mul_value.
 (%%Function%% %%Function%%) Bool
)
(assert
 (forall ((a! %%Function%%) (b! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.lemma_mul_value. a! b!) (=
     (EucMod (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. (curve25519_dalek!lemmas.field_lemmas.mul_lemmas.mul_return.?
         (Poly%array%. a!) (Poly%array%. b!)
       ))
      ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     ) (EucMod (nClip (Mul (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%.
          a!
         )
        ) (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. b!))
       )
      ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.mul_lemmas.lemma_mul_value. a!
     b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.mul_lemmas.lemma_mul_value._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.mul_lemmas.lemma_mul_value._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::field::impl&%12::mul
(declare-fun ens%curve25519_dalek!backend.serial.u64.field.impl&%12.mul. (Poly Poly
  Poly
 ) Bool
)
(assert
 (forall ((self! Poly) (_rhs! Poly) (output! Poly)) (!
   (= (ens%curve25519_dalek!backend.serial.u64.field.impl&%12.mul. self! _rhs! output!)
    (and
     (ens%core!ops.arith.Mul.mul. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! _rhs!
      output!
     )
     (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? output!) (curve25519_dalek!specs.field_specs.field_mul.?
       (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? self!)) (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
         _rhs!
     ))))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? output! (I 52))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? output! (I 54))
   ))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.field.impl&%12.mul. self! _rhs!
     output!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__12.mul._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__12.mul._definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.SubSpec. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Mul. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.MulSpec. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::negate_lemmas::lemma_neg_no_underflow
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg_no_underflow.
 (%%Function%%) Bool
)
(declare-const %%global_location_label%%51 Bool)
(assert
 (forall ((limbs! %%Function%%)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg_no_underflow.
     limbs!
    ) (=>
     %%global_location_label%%51
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
             ) (Poly%array%. limbs!)
            ) i$
           )
          ) (uClip 64 (bitshl (I 1) (I 54)))
       )))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) (Poly%array%. limbs!)
         ) i$
       ))
       :qid user_curve25519_dalek__lemmas__field_lemmas__negate_lemmas__lemma_neg_no_underflow_92
       :skolemid skolem_user_curve25519_dalek__lemmas__field_lemmas__negate_lemmas__lemma_neg_no_underflow_92
   ))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg_no_underflow.
     limbs!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg_no_underflow._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg_no_underflow._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg_no_underflow.
 (%%Function%%) Bool
)
(assert
 (forall ((limbs! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg_no_underflow.
     limbs!
    ) (curve25519_dalek!lemmas.field_lemmas.negate_lemmas.all_neg_limbs_positive.? (Poly%array%.
      limbs!
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg_no_underflow.
     limbs!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg_no_underflow._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg_no_underflow._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::negate_lemmas::proof_negate
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.proof_negate.
 (%%Function%%) Bool
)
(declare-const %%global_location_label%%52 Bool)
(declare-const %%global_location_label%%53 Bool)
(assert
 (forall ((limbs! %%Function%%)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.proof_negate. limbs!) (
     and
     (=>
      %%global_location_label%%52
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
              ) (Poly%array%. limbs!)
             ) i$
            )
           ) (uClip 64 (bitshl (I 1) (I 54)))
        )))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) (Poly%array%. limbs!)
          ) i$
        ))
        :qid user_curve25519_dalek__lemmas__field_lemmas__negate_lemmas__proof_negate_93
        :skolemid skolem_user_curve25519_dalek__lemmas__field_lemmas__negate_lemmas__proof_negate_93
     )))
     (=>
      %%global_location_label%%53
      (curve25519_dalek!lemmas.field_lemmas.negate_lemmas.all_neg_limbs_positive.? (Poly%array%.
        limbs!
   )))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.proof_negate. limbs!))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.negate_lemmas.proof_negate._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.negate_lemmas.proof_negate._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.proof_negate.
 (%%Function%%) Bool
)
(assert
 (forall ((limbs! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.proof_negate. limbs!) (
     and
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
             ) (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_negate.? (Poly%array%.
                limbs!
             )))
            ) i$
           )
          ) (uClip 64 (bitshl (I 1) (I 52)))
       )))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_negate.? (Poly%array%.
             limbs!
          )))
         ) i$
       ))
       :qid user_curve25519_dalek__lemmas__field_lemmas__negate_lemmas__proof_negate_94
       :skolemid skolem_user_curve25519_dalek__lemmas__field_lemmas__negate_lemmas__proof_negate_94
     ))
     (= (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_negate.?
         (Poly%array%. limbs!)
       ))
      ) (Sub (Sub (nClip (Mul 16 (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))) (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
         (Poly%array%. limbs!)
        )
       ) (Mul (curve25519_dalek!specs.field_specs_u64.p.? (I 0)) (uClip 64 (bitshr (I (uClip
            64 (Sub 36028797018963952 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs!)
               ) (I 4)
           ))))
          ) (I 51)
     )))))
     (= (EucMod (nClip (Add (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%.
           (curve25519_dalek!specs.field_specs_u64.spec_negate.? (Poly%array%. limbs!))
          )
         ) (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. limbs!))
        )
       ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
      ) 0
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.proof_negate. limbs!))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.negate_lemmas.proof_negate._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.negate_lemmas.proof_negate._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::field::FieldElement51::negate
(declare-fun req%curve25519_dalek!backend.serial.u64.field.impl&%16.negate. (curve25519_dalek!backend.serial.u64.field.FieldElement51.)
 Bool
)
(declare-const %%global_location_label%%54 Bool)
(assert
 (forall ((pre%self! curve25519_dalek!backend.serial.u64.field.FieldElement51.)) (!
   (= (req%curve25519_dalek!backend.serial.u64.field.impl&%16.negate. pre%self!) (=>
     %%global_location_label%%54
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       pre%self!
      ) (I 54)
   )))
   :pattern ((req%curve25519_dalek!backend.serial.u64.field.impl&%16.negate. pre%self!))
   :qid internal_req__curve25519_dalek!backend.serial.u64.field.impl&__16.negate._definition
   :skolemid skolem_internal_req__curve25519_dalek!backend.serial.u64.field.impl&__16.negate._definition
)))
(declare-fun ens%curve25519_dalek!backend.serial.u64.field.impl&%16.negate. (curve25519_dalek!backend.serial.u64.field.FieldElement51.
  curve25519_dalek!backend.serial.u64.field.FieldElement51.
 ) Bool
)
(assert
 (forall ((pre%self! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (self!
    curve25519_dalek!backend.serial.u64.field.FieldElement51.
   )
  ) (!
   (= (ens%curve25519_dalek!backend.serial.u64.field.impl&%16.negate. pre%self! self!)
    (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. self!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       self!
      ) (I 52)
     )
     (= (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
         (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           self!
       ))))
      ) (Sub (Sub (nClip (Mul 16 (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))) (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
         (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
           (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             pre%self!
        )))))
       ) (Mul (curve25519_dalek!specs.field_specs_u64.p.? (I 0)) (uClip 64 (bitshr (I (uClip
            64 (Sub 36028797018963952 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                  (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                    pre%self!
                ))))
               ) (I 4)
           ))))
          ) (I 51)
     )))))
     (= (curve25519_dalek!specs.field_specs_u64.field_canonical.? (I (nClip (Add (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
           (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
             (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
               self!
           ))))
          ) (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
             (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
               pre%self!
       ))))))))
      ) 0
     )
     (= (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
       (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
         self!
       ))
      ) (curve25519_dalek!specs.field_specs_u64.spec_negate.? (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
         (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           pre%self!
   ))))))))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.field.impl&%16.negate. pre%self!
     self!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__16.negate._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__16.negate._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::negate_lemmas::lemma_neg
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg. (curve25519_dalek!backend.serial.u64.field.FieldElement51.)
 Bool
)
(declare-const %%global_location_label%%55 Bool)
(assert
 (forall ((elem! curve25519_dalek!backend.serial.u64.field.FieldElement51.)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg. elem!) (=>
     %%global_location_label%%55
     (= (EucMod (nClip (Add (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%.
           (curve25519_dalek!specs.field_specs_u64.spec_negate.? (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
              (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                elem!
          ))))))
         ) (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
              elem!
        ))))))
       ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
      ) 0
   )))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg. elem!))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg. (curve25519_dalek!backend.serial.u64.field.FieldElement51.)
 Bool
)
(assert
 (forall ((elem! curve25519_dalek!backend.serial.u64.field.FieldElement51.)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg. elem!) (= (EucMod
      (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_negate.?
         (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
           (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             elem!
       ))))))
      ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     ) (curve25519_dalek!specs.field_specs.field_neg.? (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
        (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. elem!)
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg. elem!))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.negate_lemmas.lemma_neg._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::field::impl&%14::neg
(declare-fun ens%curve25519_dalek!backend.serial.u64.field.impl&%14.neg. (Poly Poly)
 Bool
)
(assert
 (forall ((self! Poly) (output! Poly)) (!
   (= (ens%curve25519_dalek!backend.serial.u64.field.impl&%14.neg. self! output!) (and
     (ens%core!ops.arith.Neg.neg. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      self! output!
     )
     (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? output!) (curve25519_dalek!specs.field_specs.field_neg.?
       (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? self!))
     ))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? output! (I 52))
   ))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.field.impl&%14.neg. self! output!))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__14.neg._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__14.neg._definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Neg. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.NegSpec. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
)

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::u64_5_as_nat_lemmas::lemma_u64_5_as_nat_k
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_u64_5_as_nat_k.
 (%%Function%% Int) Bool
)
(declare-const %%global_location_label%%56 Bool)
(assert
 (forall ((a! %%Function%%) (k! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_u64_5_as_nat_k.
     a! k!
    ) (=>
     %%global_location_label%%56
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
         (<= (Mul k! (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
                64
               ) $ (CONST_INT 5)
              ) (Poly%array%. a!)
             ) i$
           ))
          ) 18446744073709551615
       )))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) (Poly%array%. a!)
         ) i$
       ))
       :qid user_curve25519_dalek__lemmas__field_lemmas__u64_5_as_nat_lemmas__lemma_u64_5_as_nat_k_95
       :skolemid skolem_user_curve25519_dalek__lemmas__field_lemmas__u64_5_as_nat_lemmas__lemma_u64_5_as_nat_k_95
   ))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_u64_5_as_nat_k.
     a! k!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_u64_5_as_nat_k._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_u64_5_as_nat_k._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_u64_5_as_nat_k.
 (%%Function%% Int) Bool
)
(assert
 (forall ((a! %%Function%%) (k! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_u64_5_as_nat_k.
     a! k!
    ) (= (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (array_new $ (UINT 64) 5
       (%%array%%0 (I (uClip 64 (Mul k! (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
              $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. a!)
             ) (I 0)
         ))))
        ) (I (uClip 64 (Mul k! (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
               ARRAY $ (UINT 64) $ (CONST_INT 5)
              ) (Poly%array%. a!)
             ) (I 1)
         ))))
        ) (I (uClip 64 (Mul k! (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
               ARRAY $ (UINT 64) $ (CONST_INT 5)
              ) (Poly%array%. a!)
             ) (I 2)
         ))))
        ) (I (uClip 64 (Mul k! (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
               ARRAY $ (UINT 64) $ (CONST_INT 5)
              ) (Poly%array%. a!)
             ) (I 3)
         ))))
        ) (I (uClip 64 (Mul k! (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
               ARRAY $ (UINT 64) $ (CONST_INT 5)
              ) (Poly%array%. a!)
             ) (I 4)
      )))))))
     ) (Mul k! (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. a!)))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_u64_5_as_nat_k.
     a! k!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_u64_5_as_nat_k._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.u64_5_as_nat_lemmas.lemma_u64_5_as_nat_k._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::field::FieldElement51::square2
(declare-fun req%curve25519_dalek!backend.serial.u64.field.impl&%16.square2. (curve25519_dalek!backend.serial.u64.field.FieldElement51.)
 Bool
)
(declare-const %%global_location_label%%57 Bool)
(assert
 (forall ((self! curve25519_dalek!backend.serial.u64.field.FieldElement51.)) (!
   (= (req%curve25519_dalek!backend.serial.u64.field.impl&%16.square2. self!) (=>
     %%global_location_label%%57
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       self!
      ) (I 54)
   )))
   :pattern ((req%curve25519_dalek!backend.serial.u64.field.impl&%16.square2. self!))
   :qid internal_req__curve25519_dalek!backend.serial.u64.field.impl&__16.square2._definition
   :skolemid skolem_internal_req__curve25519_dalek!backend.serial.u64.field.impl&__16.square2._definition
)))
(declare-fun ens%curve25519_dalek!backend.serial.u64.field.impl&%16.square2. (curve25519_dalek!backend.serial.u64.field.FieldElement51.
  curve25519_dalek!backend.serial.u64.field.FieldElement51.
 ) Bool
)
(assert
 (forall ((self! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (r! curve25519_dalek!backend.serial.u64.field.FieldElement51.))
  (!
   (= (ens%curve25519_dalek!backend.serial.u64.field.impl&%16.square2. self! r!) (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. r!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        r!
       )
      ) (curve25519_dalek!specs.field_specs_u64.field_canonical.? (I (nClip (Mul 2 (vstd!arithmetic.power.pow.?
           (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
               (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                 self!
            )))))
           ) (I 2)
     ))))))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       r!
      ) (I 53)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       r!
      ) (I 54)
   )))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.field.impl&%16.square2. self! r!))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__16.square2._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__16.square2._definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  $ TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Function-Specs curve25519_dalek::backend::serial::u64::field::FieldElement51::clone
(declare-fun ens%curve25519_dalek!backend.serial.u64.field.impl&%1.clone. (Poly Poly)
 Bool
)
(assert
 (forall ((self! Poly) (%return! Poly)) (!
   (= (ens%curve25519_dalek!backend.serial.u64.field.impl&%1.clone. self! %return!) (
     and
     (ens%core!clone.Clone.clone. $ TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      self! %return!
     )
     (= %return! self!)
   ))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.field.impl&%1.clone. self! %return!))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__1.clone._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__1.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (%return$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.))
     (has_type %return$ TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
      (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
      (F fndef_singleton) closure%$ %return$
     )
     (let
      ((self$ (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (tuple%1./tuple%1/0
          (%Poly%tuple%1. closure%$)
      ))))
      (= (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. %return$) self$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (F fndef_singleton) closure%$ %return$
   ))
   :qid user_curve25519_dalek__backend__serial__u64__field__FieldElement51__clone_105
   :skolemid skolem_user_curve25519_dalek__backend__serial__u64__field__FieldElement51__clone_105
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
)

;; Trait-Impl-Axiom
(assert
 (forall ((VERUS_SPEC__A&. Dcr) (VERUS_SPEC__A& Type)) (!
   (=>
    (tr_bound%core!ops.arith.Neg. VERUS_SPEC__A&. VERUS_SPEC__A&)
    (tr_bound%vstd!std_specs.ops.NegSpec. VERUS_SPEC__A&. VERUS_SPEC__A&)
   )
   :pattern ((tr_bound%vstd!std_specs.ops.NegSpec. VERUS_SPEC__A&. VERUS_SPEC__A&))
   :qid internal_vstd__std_specs__ops__impl&__0_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__ops__impl&__0_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((Rhs&. Dcr) (Rhs& Type) (VERUS_SPEC__A&. Dcr) (VERUS_SPEC__A& Type)) (!
   (=>
    (and
     (sized Rhs&.)
     (tr_bound%core!ops.arith.Add. VERUS_SPEC__A&. VERUS_SPEC__A& Rhs&. Rhs&)
    )
    (tr_bound%vstd!std_specs.ops.AddSpec. VERUS_SPEC__A&. VERUS_SPEC__A& Rhs&. Rhs&)
   )
   :pattern ((tr_bound%vstd!std_specs.ops.AddSpec. VERUS_SPEC__A&. VERUS_SPEC__A& Rhs&.
     Rhs&
   ))
   :qid internal_vstd__std_specs__ops__impl&__2_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__ops__impl&__2_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((Rhs&. Dcr) (Rhs& Type) (VERUS_SPEC__A&. Dcr) (VERUS_SPEC__A& Type)) (!
   (=>
    (and
     (sized Rhs&.)
     (tr_bound%core!ops.arith.Sub. VERUS_SPEC__A&. VERUS_SPEC__A& Rhs&. Rhs&)
    )
    (tr_bound%vstd!std_specs.ops.SubSpec. VERUS_SPEC__A&. VERUS_SPEC__A& Rhs&. Rhs&)
   )
   :pattern ((tr_bound%vstd!std_specs.ops.SubSpec. VERUS_SPEC__A&. VERUS_SPEC__A& Rhs&.
     Rhs&
   ))
   :qid internal_vstd__std_specs__ops__impl&__3_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__ops__impl&__3_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((Rhs&. Dcr) (Rhs& Type) (VERUS_SPEC__A&. Dcr) (VERUS_SPEC__A& Type)) (!
   (=>
    (and
     (sized Rhs&.)
     (tr_bound%core!ops.arith.Mul. VERUS_SPEC__A&. VERUS_SPEC__A& Rhs&. Rhs&)
    )
    (tr_bound%vstd!std_specs.ops.MulSpec. VERUS_SPEC__A&. VERUS_SPEC__A& Rhs&. Rhs&)
   )
   :pattern ((tr_bound%vstd!std_specs.ops.MulSpec. VERUS_SPEC__A&. VERUS_SPEC__A& Rhs&.
     Rhs&
   ))
   :qid internal_vstd__std_specs__ops__impl&__4_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__ops__impl&__4_trait_impl_definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::field::FieldElement51::zeroize
(declare-fun ens%curve25519_dalek!backend.serial.u64.field.impl&%3.zeroize. (curve25519_dalek!backend.serial.u64.field.FieldElement51.
  curve25519_dalek!backend.serial.u64.field.FieldElement51.
 ) Bool
)
(assert
 (forall ((pre%self! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (self!
    curve25519_dalek!backend.serial.u64.field.FieldElement51.
   )
  ) (!
   (= (ens%curve25519_dalek!backend.serial.u64.field.impl&%3.zeroize. pre%self! self!)
    (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. self!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
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
         (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
               (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                 self!
             ))))
            ) i$
           )
          ) 0
       )))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
              self!
          ))))
         ) i$
       ))
       :qid user_curve25519_dalek__backend__serial__u64__field__FieldElement51__zeroize_106
       :skolemid skolem_user_curve25519_dalek__backend__serial__u64__field__FieldElement51__zeroize_106
   ))))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.field.impl&%3.zeroize. pre%self!
     self!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__3.zeroize._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__3.zeroize._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::field::FieldElement51::add_assign
(declare-fun req%curve25519_dalek!backend.serial.u64.field.impl&%4.add_assign. (curve25519_dalek!backend.serial.u64.field.FieldElement51.
  curve25519_dalek!backend.serial.u64.field.FieldElement51.
 ) Bool
)
(declare-const %%global_location_label%%58 Bool)
(assert
 (forall ((pre%self! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (_rhs!
    curve25519_dalek!backend.serial.u64.field.FieldElement51.
   )
  ) (!
   (= (req%curve25519_dalek!backend.serial.u64.field.impl&%4.add_assign. pre%self! _rhs!)
    (=>
     %%global_location_label%%58
     (curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       pre%self!
      ) (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _rhs!) (I 18446744073709551615)
   )))
   :pattern ((req%curve25519_dalek!backend.serial.u64.field.impl&%4.add_assign. pre%self!
     _rhs!
   ))
   :qid internal_req__curve25519_dalek!backend.serial.u64.field.impl&__4.add_assign._definition
   :skolemid skolem_internal_req__curve25519_dalek!backend.serial.u64.field.impl&__4.add_assign._definition
)))
(declare-fun ens%curve25519_dalek!backend.serial.u64.field.impl&%4.add_assign. (curve25519_dalek!backend.serial.u64.field.FieldElement51.
  curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.field.FieldElement51.
 ) Bool
)
(assert
 (forall ((pre%self! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (self!
    curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ) (_rhs! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
  ) (!
   (= (ens%curve25519_dalek!backend.serial.u64.field.impl&%4.add_assign. pre%self! self!
     _rhs!
    ) (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. self!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (= self! (curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        pre%self!
       ) (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _rhs!)
     ))
     (= (curve25519_dalek!specs.field_specs.fe51_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        self!
       )
      ) (nClip (Add (curve25519_dalek!specs.field_specs.fe51_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          pre%self!
         )
        ) (curve25519_dalek!specs.field_specs.fe51_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          _rhs!
     )))))
     (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        self!
       )
      ) (curve25519_dalek!specs.field_specs.field_add.? (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
         (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. pre%self!)
        )
       ) (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          _rhs!
   )))))))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.field.impl&%4.add_assign. pre%self!
     self! _rhs!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__4.add_assign._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__4.add_assign._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::field::FieldElement51::sub_assign
(declare-fun req%curve25519_dalek!backend.serial.u64.field.impl&%7.sub_assign. (curve25519_dalek!backend.serial.u64.field.FieldElement51.
  curve25519_dalek!backend.serial.u64.field.FieldElement51.
 ) Bool
)
(declare-const %%global_location_label%%59 Bool)
(assert
 (forall ((pre%self! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (_rhs!
    curve25519_dalek!backend.serial.u64.field.FieldElement51.
   )
  ) (!
   (= (req%curve25519_dalek!backend.serial.u64.field.impl&%7.sub_assign. pre%self! _rhs!)
    (=>
     %%global_location_label%%59
     (and
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        pre%self!
       ) (I 54)
      )
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        _rhs!
       ) (I 54)
   ))))
   :pattern ((req%curve25519_dalek!backend.serial.u64.field.impl&%7.sub_assign. pre%self!
     _rhs!
   ))
   :qid internal_req__curve25519_dalek!backend.serial.u64.field.impl&__7.sub_assign._definition
   :skolemid skolem_internal_req__curve25519_dalek!backend.serial.u64.field.impl&__7.sub_assign._definition
)))
(declare-fun ens%curve25519_dalek!backend.serial.u64.field.impl&%7.sub_assign. (curve25519_dalek!backend.serial.u64.field.FieldElement51.
  curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.field.FieldElement51.
 ) Bool
)
(assert
 (forall ((pre%self! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (self!
    curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ) (_rhs! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
  ) (!
   (= (ens%curve25519_dalek!backend.serial.u64.field.impl&%7.sub_assign. pre%self! self!
     _rhs!
    ) (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. self!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       self!
      ) (I 52)
     )
     (= self! (curve25519_dalek!specs.field_specs.spec_sub_limbs.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        pre%self!
       ) (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _rhs!)
     ))
     (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        self!
       )
      ) (curve25519_dalek!specs.field_specs.field_sub.? (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
         (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. pre%self!)
        )
       ) (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          _rhs!
   )))))))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.field.impl&%7.sub_assign. pre%self!
     self! _rhs!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__7.sub_assign._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__7.sub_assign._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::field::FieldElement51::mul_assign
(declare-fun req%curve25519_dalek!backend.serial.u64.field.impl&%10.mul_assign. (curve25519_dalek!backend.serial.u64.field.FieldElement51.
  curve25519_dalek!backend.serial.u64.field.FieldElement51.
 ) Bool
)
(declare-const %%global_location_label%%60 Bool)
(declare-const %%global_location_label%%61 Bool)
(assert
 (forall ((pre%self! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (_rhs!
    curve25519_dalek!backend.serial.u64.field.FieldElement51.
   )
  ) (!
   (= (req%curve25519_dalek!backend.serial.u64.field.impl&%10.mul_assign. pre%self! _rhs!)
    (and
     (=>
      %%global_location_label%%60
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        pre%self!
       ) (I 54)
     ))
     (=>
      %%global_location_label%%61
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        _rhs!
       ) (I 54)
   ))))
   :pattern ((req%curve25519_dalek!backend.serial.u64.field.impl&%10.mul_assign. pre%self!
     _rhs!
   ))
   :qid internal_req__curve25519_dalek!backend.serial.u64.field.impl&__10.mul_assign._definition
   :skolemid skolem_internal_req__curve25519_dalek!backend.serial.u64.field.impl&__10.mul_assign._definition
)))
(declare-fun ens%curve25519_dalek!backend.serial.u64.field.impl&%10.mul_assign. (curve25519_dalek!backend.serial.u64.field.FieldElement51.
  curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.field.FieldElement51.
 ) Bool
)
(assert
 (forall ((pre%self! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (self!
    curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ) (_rhs! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
  ) (!
   (= (ens%curve25519_dalek!backend.serial.u64.field.impl&%10.mul_assign. pre%self! self!
     _rhs!
    ) (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. self!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        self!
       )
      ) (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
         (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. pre%self!)
        )
       ) (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          _rhs!
     )))))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       self!
      ) (I 54)
   )))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.field.impl&%10.mul_assign. pre%self!
     self! _rhs!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__10.mul_assign._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__10.mul_assign._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::field::FieldElement51::conditional_select
(declare-fun ens%curve25519_dalek!backend.serial.u64.field.impl&%15.conditional_select.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.field.FieldElement51.
  subtle!Choice. curve25519_dalek!backend.serial.u64.field.FieldElement51.
 ) Bool
)
(assert
 (forall ((a! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (b! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
   (choice! subtle!Choice.) (result! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
  ) (!
   (= (ens%curve25519_dalek!backend.serial.u64.field.impl&%15.conditional_select. a! b!
     choice! result!
    ) (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. result!)
      TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
     )
     (=>
      (not (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
         choice!
      )))
      (= (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
        (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          result!
        ))
       ) (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
        (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          a!
     )))))
     (=>
      (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
        choice!
      ))
      (= (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
        (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          result!
        ))
       ) (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
        (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          b!
   )))))))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.field.impl&%15.conditional_select.
     a! b! choice! result!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__15.conditional_select._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__15.conditional_select._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::field::FieldElement51::conditional_swap
(declare-fun ens%curve25519_dalek!backend.serial.u64.field.impl&%15.conditional_swap.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.field.FieldElement51.
  curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.field.FieldElement51.
  subtle!Choice.
 ) Bool
)
(assert
 (forall ((pre%a! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (a! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
   (pre%b! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (b! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
   (choice! subtle!Choice.)
  ) (!
   (= (ens%curve25519_dalek!backend.serial.u64.field.impl&%15.conditional_swap. pre%a!
     a! pre%b! b! choice!
    ) (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (=>
      (not (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
         choice!
      )))
      (and
       (= (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
         (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           a!
         ))
        ) (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
         (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           pre%a!
       ))))
       (= (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
         (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           b!
         ))
        ) (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
         (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           pre%b!
     ))))))
     (=>
      (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
        choice!
      ))
      (and
       (= (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
         (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           a!
         ))
        ) (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
         (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           pre%b!
       ))))
       (= (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
         (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           b!
         ))
        ) (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
         (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           pre%a!
   ))))))))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.field.impl&%15.conditional_swap.
     pre%a! a! pre%b! b! choice!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__15.conditional_swap._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__15.conditional_swap._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::field::FieldElement51::conditional_assign
(declare-fun ens%curve25519_dalek!backend.serial.u64.field.impl&%15.conditional_assign.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.field.FieldElement51.
  curve25519_dalek!backend.serial.u64.field.FieldElement51. subtle!Choice.
 ) Bool
)
(assert
 (forall ((pre%self! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (self!
    curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ) (other! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (choice! subtle!Choice.)
  ) (!
   (= (ens%curve25519_dalek!backend.serial.u64.field.impl&%15.conditional_assign. pre%self!
     self! other! choice!
    ) (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. self!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (=>
      (not (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
         choice!
      )))
      (= (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
        (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          self!
        ))
       ) (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
        (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          pre%self!
     )))))
     (=>
      (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
        choice!
      ))
      (= (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
        (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          self!
        ))
       ) (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
        (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          other!
     )))))
     (=>
      (not (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
         choice!
      )))
      (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
         self!
        )
       ) (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
         pre%self!
     ))))
     (=>
      (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
        choice!
      ))
      (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
         self!
        )
       ) (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
         other!
     ))))
     (=>
      (and
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
         pre%self!
        ) (I 54)
       )
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
         other!
        ) (I 54)
      ))
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        self!
       ) (I 54)
   ))))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.field.impl&%15.conditional_assign.
     pre%self! self! other! choice!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__15.conditional_assign._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__15.conditional_assign._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::field::FieldElement51::from_limbs
(declare-fun ens%curve25519_dalek!backend.serial.u64.field.impl&%16.from_limbs. (%%Function%%
  curve25519_dalek!backend.serial.u64.field.FieldElement51.
 ) Bool
)
(assert
 (forall ((limbs! %%Function%%) (result! curve25519_dalek!backend.serial.u64.field.FieldElement51.))
  (!
   (= (ens%curve25519_dalek!backend.serial.u64.field.impl&%16.from_limbs. limbs! result!)
    (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. result!)
      TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
     )
     (= result! (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
       (%Poly%array%. (Poly%array%. limbs!))
   ))))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.field.impl&%16.from_limbs. limbs!
     result!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__16.from_limbs._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__16.from_limbs._definition
)))

;; Function-Def curve25519_dalek::backend::serial::u64::field::FieldElement51::from_limbs
;; curve25519-dalek/src/backend/serial/u64/field.rs:777:5: 777:79 (#0)
(get-info :all-statistics)
(push)
 (declare-const result! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
 (declare-const limbs! %%Function%%)
 (assert
  fuel_defaults
 )
 (assert
  (has_type (Poly%array%. limbs!) (ARRAY $ (UINT 64) $ (CONST_INT 5)))
 )
 ;; postcondition not satisfied
 (declare-const %%location_label%%0 Bool)
 (assert
  (not (=>
    (= result! (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
      (%Poly%array%. (Poly%array%. limbs!))
    ))
    (=>
     %%location_label%%0
     (= result! (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
       (%Poly%array%. (Poly%array%. limbs!))
 ))))))
 (get-info :version)
 (set-option :rlimit 30000000)
 (check-sat)
 (set-option :rlimit 0)
(pop)
