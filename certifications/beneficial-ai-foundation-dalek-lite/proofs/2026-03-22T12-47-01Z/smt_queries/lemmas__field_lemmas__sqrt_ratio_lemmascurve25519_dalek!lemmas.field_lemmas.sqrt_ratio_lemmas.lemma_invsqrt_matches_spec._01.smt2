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

;; MODULE 'module lemmas::field_lemmas::sqrt_ratio_lemmas'
;; curve25519-dalek/src/lemmas/field_lemmas/sqrt_ratio_lemmas.rs:1641:1: 1641:75 (#0)

;; query spun off because: spinoff_all

;; Fuel
(declare-const fuel%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_twice. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_multiples_basic. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_add_mod_noop. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_sub_mod_noop. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_bound. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_general. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_associative. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_commutative. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_sub. FuelId)
(declare-const fuel%vstd!arithmetic.power.lemma_pow1. FuelId)
(declare-const fuel%vstd!arithmetic.power.lemma_pow_adds. FuelId)
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
(declare-const fuel%vstd!view.impl&%32.view. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.constants.SQRT_M1. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.field_specs.u64_5_bounded. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.fe51_limbs_bounded. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.fe51_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.fe51_as_canonical_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_add. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_sub. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_mul. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_neg. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_square. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_inv. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.is_square. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.spec_fe51_as_bytes. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.is_sqrt_ratio. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.is_sqrt_ratio_times_i. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.is_negative. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_abs. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.nat_invsqrt. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.sqrt_m1. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.p. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.field_canonical. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.mask51. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.spec_reduce. FuelId)
(declare-const fuel%curve25519_dalek!specs.primality_specs.is_prime. FuelId)
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
 (distinct fuel%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. fuel%vstd!arithmetic.div_mod.lemma_mod_twice.
  fuel%vstd!arithmetic.div_mod.lemma_mod_multiples_basic. fuel%vstd!arithmetic.div_mod.lemma_add_mod_noop.
  fuel%vstd!arithmetic.div_mod.lemma_sub_mod_noop. fuel%vstd!arithmetic.div_mod.lemma_mod_bound.
  fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left. fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right.
  fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_general. fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop.
  fuel%vstd!arithmetic.mul.lemma_mul_is_associative. fuel%vstd!arithmetic.mul.lemma_mul_is_commutative.
  fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_sub. fuel%vstd!arithmetic.power.lemma_pow1.
  fuel%vstd!arithmetic.power.lemma_pow_adds. fuel%vstd!array.array_view. fuel%vstd!array.impl&%0.view.
  fuel%vstd!array.impl&%2.spec_index. fuel%vstd!array.lemma_array_index. fuel%vstd!array.array_len_matches_n.
  fuel%vstd!array.axiom_array_ext_equal. fuel%vstd!array.axiom_array_has_resolved.
  fuel%vstd!raw_ptr.impl&%3.view. fuel%vstd!raw_ptr.ptrs_mut_eq. fuel%vstd!raw_ptr.ptrs_mut_eq_sized.
  fuel%vstd!seq.impl&%0.spec_index. fuel%vstd!seq.axiom_seq_index_decreases. fuel%vstd!seq.axiom_seq_new_len.
  fuel%vstd!seq.axiom_seq_new_index. fuel%vstd!seq.axiom_seq_ext_equal. fuel%vstd!seq.axiom_seq_ext_equal_deep.
  fuel%vstd!slice.impl&%2.spec_index. fuel%vstd!slice.axiom_spec_len. fuel%vstd!slice.axiom_slice_ext_equal.
  fuel%vstd!slice.axiom_slice_has_resolved. fuel%vstd!view.impl&%0.view. fuel%vstd!view.impl&%2.view.
  fuel%vstd!view.impl&%4.view. fuel%vstd!view.impl&%6.view. fuel%vstd!view.impl&%12.view.
  fuel%vstd!view.impl&%14.view. fuel%vstd!view.impl&%16.view. fuel%vstd!view.impl&%22.view.
  fuel%vstd!view.impl&%26.view. fuel%vstd!view.impl&%32.view. fuel%curve25519_dalek!backend.serial.u64.constants.SQRT_M1.
  fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd. fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.
  fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.
  fuel%curve25519_dalek!specs.field_specs.u64_5_bounded. fuel%curve25519_dalek!specs.field_specs.fe51_limbs_bounded.
  fuel%curve25519_dalek!specs.field_specs.fe51_as_nat. fuel%curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.
  fuel%curve25519_dalek!specs.field_specs.field_add. fuel%curve25519_dalek!specs.field_specs.field_sub.
  fuel%curve25519_dalek!specs.field_specs.field_mul. fuel%curve25519_dalek!specs.field_specs.field_neg.
  fuel%curve25519_dalek!specs.field_specs.field_square. fuel%curve25519_dalek!specs.field_specs.field_inv.
  fuel%curve25519_dalek!specs.field_specs.is_square. fuel%curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.
  fuel%curve25519_dalek!specs.field_specs.is_sqrt_ratio. fuel%curve25519_dalek!specs.field_specs.is_sqrt_ratio_times_i.
  fuel%curve25519_dalek!specs.field_specs.is_negative. fuel%curve25519_dalek!specs.field_specs.field_abs.
  fuel%curve25519_dalek!specs.field_specs.nat_invsqrt. fuel%curve25519_dalek!specs.field_specs.sqrt_m1.
  fuel%curve25519_dalek!specs.field_specs_u64.p. fuel%curve25519_dalek!specs.field_specs_u64.field_canonical.
  fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical. fuel%curve25519_dalek!specs.field_specs_u64.mask51.
  fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat. fuel%curve25519_dalek!specs.field_specs_u64.spec_reduce.
  fuel%curve25519_dalek!specs.primality_specs.is_prime. fuel%vstd!array.group_array_axioms.
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
(declare-sort subtle!Choice. 0)
(declare-sort vstd!raw_ptr.Provenance. 0)
(declare-sort vstd!seq.Seq<u8.>. 0)
(declare-sort allocator_global%. 0)
(declare-datatypes ((vstd!raw_ptr.PtrData. 0) (curve25519_dalek!backend.serial.u64.field.FieldElement51.
   0
  ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. 0) (tuple%0.
   0
  )
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
  ) ((tuple%0./tuple%0))
))
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
(declare-fun TYPE%fun%1. (Dcr Type Dcr Type) Type)
(declare-const TYPE%vstd!raw_ptr.Provenance. Type)
(declare-fun TYPE%vstd!raw_ptr.PtrData. (Dcr Type) Type)
(declare-fun TYPE%vstd!seq.Seq. (Dcr Type) Type)
(declare-const TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. Type)
(declare-const TYPE%subtle!Choice. Type)
(declare-const TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
 Type
)
(declare-fun Poly%fun%1. (%%Function%%) Poly)
(declare-fun %Poly%fun%1. (Poly) %%Function%%)
(declare-fun Poly%array%. (%%Function%%) Poly)
(declare-fun %Poly%array%. (Poly) %%Function%%)
(declare-fun Poly%subtle!Choice. (subtle!Choice.) Poly)
(declare-fun %Poly%subtle!Choice. (Poly) subtle!Choice.)
(declare-fun Poly%vstd!raw_ptr.Provenance. (vstd!raw_ptr.Provenance.) Poly)
(declare-fun %Poly%vstd!raw_ptr.Provenance. (Poly) vstd!raw_ptr.Provenance.)
(declare-fun Poly%vstd!seq.Seq<u8.>. (vstd!seq.Seq<u8.>.) Poly)
(declare-fun %Poly%vstd!seq.Seq<u8.>. (Poly) vstd!seq.Seq<u8.>.)
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

;; Function-Decl curve25519_dalek::specs::field_specs::field_square
(declare-fun curve25519_dalek!specs.field_specs.field_square.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::field_sub
(declare-fun curve25519_dalek!specs.field_specs.field_sub.? (Poly Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::field_add
(declare-fun curve25519_dalek!specs.field_specs.field_add.? (Poly Poly) Int)

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

;; Function-Decl curve25519_dalek::specs::field_specs::is_sqrt_ratio
(declare-fun curve25519_dalek!specs.field_specs.is_sqrt_ratio.? (Poly Poly Poly) Bool)

;; Function-Decl curve25519_dalek::specs::field_specs::is_square
(declare-fun curve25519_dalek!specs.field_specs.is_square.? (Poly) Bool)

;; Function-Decl curve25519_dalek::specs::field_specs::fe51_as_nat
(declare-fun curve25519_dalek!specs.field_specs.fe51_as_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::spec_fe51_as_bytes
(declare-fun curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.? (Poly) vstd!seq.Seq<u8.>.)

;; Function-Decl curve25519_dalek::specs::field_specs::is_sqrt_ratio_times_i
(declare-fun curve25519_dalek!specs.field_specs.is_sqrt_ratio_times_i.? (Poly Poly
  Poly
 ) Bool
)

;; Function-Decl curve25519_dalek::specs::primality_specs::is_prime
(declare-fun curve25519_dalek!specs.primality_specs.is_prime.? (Poly) Bool)

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

;; Function-Specs vstd::arithmetic::div_mod::lemma_fundamental_div_mod
(declare-fun req%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. (Int Int) Bool)
(declare-const %%global_location_label%%6 Bool)
(assert
 (forall ((x! Int) (d! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. x! d!) (=>
     %%global_location_label%%6
     (not (= d! 0))
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. x! d!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_fundamental_div_mod._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_fundamental_div_mod._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. (Int Int) Bool)
(assert
 (forall ((x! Int) (d! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. x! d!) (= x! (Add (Mul d!
       (EucDiv x! d!)
      ) (EucMod x! d!)
   )))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. x! d!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_fundamental_div_mod._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_fundamental_div_mod._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_fundamental_div_mod
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_fundamental_div_mod.)
  (forall ((x! Int) (d! Int)) (!
    (=>
     (not (= d! 0))
     (= x! (Add (Mul d! (EucDiv x! d!)) (EucMod x! d!)))
    )
    :pattern ((Add (Mul d! (EucDiv x! d!)) (EucMod x! d!)))
    :qid user_vstd__arithmetic__div_mod__lemma_fundamental_div_mod_18
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_fundamental_div_mod_18
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_twice
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_twice. (Int Int) Bool)
(declare-const %%global_location_label%%7 Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_twice. x! m!) (=>
     %%global_location_label%%7
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
    :qid user_vstd__arithmetic__div_mod__lemma_mod_twice_19
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_twice_19
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
    :qid user_vstd__arithmetic__div_mod__lemma_mod_multiples_basic_20
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_multiples_basic_20
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_add_mod_noop
(declare-fun req%vstd!arithmetic.div_mod.lemma_add_mod_noop. (Int Int Int) Bool)
(declare-const %%global_location_label%%9 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_add_mod_noop. x! y! m!) (=>
     %%global_location_label%%9
     (< 0 m!)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_add_mod_noop. x! y! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_add_mod_noop._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_add_mod_noop._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_add_mod_noop. (Int Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_add_mod_noop. x! y! m!) (= (EucMod (Add (EucMod
        x! m!
       ) (EucMod y! m!)
      ) m!
     ) (EucMod (Add x! y!) m!)
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_add_mod_noop. x! y! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_add_mod_noop._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_add_mod_noop._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_add_mod_noop
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_add_mod_noop.)
  (forall ((x! Int) (y! Int) (m! Int)) (!
    (=>
     (< 0 m!)
     (= (EucMod (Add (EucMod x! m!) (EucMod y! m!)) m!) (EucMod (Add x! y!) m!))
    )
    :pattern ((EucMod (Add x! y!) m!))
    :qid user_vstd__arithmetic__div_mod__lemma_add_mod_noop_21
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_add_mod_noop_21
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_sub_mod_noop
(declare-fun req%vstd!arithmetic.div_mod.lemma_sub_mod_noop. (Int Int Int) Bool)
(declare-const %%global_location_label%%10 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_sub_mod_noop. x! y! m!) (=>
     %%global_location_label%%10
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
    :qid user_vstd__arithmetic__div_mod__lemma_sub_mod_noop_22
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_sub_mod_noop_22
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_bound
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_bound. (Int Int) Bool)
(declare-const %%global_location_label%%11 Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_bound. x! m!) (=>
     %%global_location_label%%11
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
    :qid user_vstd__arithmetic__div_mod__lemma_mod_bound_23
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_bound_23
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mul_mod_noop_left
(declare-fun req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left. (Int Int Int) Bool)
(declare-const %%global_location_label%%12 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left. x! y! m!) (=>
     %%global_location_label%%12
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
    :qid user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_left_24
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_left_24
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mul_mod_noop_right
(declare-fun req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. (Int Int Int) Bool)
(declare-const %%global_location_label%%13 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. x! y! m!) (=>
     %%global_location_label%%13
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
    :qid user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_right_25
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_right_25
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mul_mod_noop_general
(declare-fun req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_general. (Int Int Int)
 Bool
)
(declare-const %%global_location_label%%14 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_general. x! y! m!) (=>
     %%global_location_label%%14
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
    :qid user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_general_26
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_general_26
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mul_mod_noop
(declare-fun req%vstd!arithmetic.div_mod.lemma_mul_mod_noop. (Int Int Int) Bool)
(declare-const %%global_location_label%%15 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mul_mod_noop. x! y! m!) (=>
     %%global_location_label%%15
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
    :qid user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_27
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_27
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_basics
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_basics. (Int) Bool)
(assert
 (forall ((x! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_basics. x!) (and
     (= (Mul 0 x!) 0)
     (= (Mul x! 0) 0)
     (= (Mul x! 1) x!)
     (= (Mul 1 x!) x!)
   ))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_basics. x!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_basics._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_basics._definition
)))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_is_associative
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_is_associative. (Int Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_is_associative. x! y! z!) (= (Mul x! (Mul y! z!))
     (Mul (Mul x! y!) z!)
   ))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_is_associative. x! y! z!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_is_associative._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_is_associative._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_is_associative
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_is_associative.)
  (forall ((x! Int) (y! Int) (z! Int)) (!
    (= (Mul x! (Mul y! z!)) (Mul (Mul x! y!) z!))
    :pattern ((Mul x! (Mul y! z!)))
    :pattern ((Mul (Mul x! y!) z!))
    :qid user_vstd__arithmetic__mul__lemma_mul_is_associative_28
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_associative_28
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_is_commutative
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_is_commutative. (Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_is_commutative. x! y!) (= (Mul x! y!) (Mul y!
      x!
   )))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_is_commutative. x! y!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_is_commutative._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_is_commutative._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_is_commutative
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_is_commutative.)
  (forall ((x! Int) (y! Int)) (!
    (= (Mul x! y!) (Mul y! x!))
    :pattern ((Mul x! y!))
    :qid user_vstd__arithmetic__mul__lemma_mul_is_commutative_29
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_commutative_29
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_is_distributive_sub
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_is_distributive_sub. (Int Int Int)
 Bool
)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_is_distributive_sub. x! y! z!) (= (Mul x! (Sub
       y! z!
      )
     ) (Sub (Mul x! y!) (Mul x! z!))
   ))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_is_distributive_sub. x! y! z!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_is_distributive_sub._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_is_distributive_sub._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_is_distributive_sub
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_sub.)
  (forall ((x! Int) (y! Int) (z! Int)) (!
    (= (Mul x! (Sub y! z!)) (Sub (Mul x! y!) (Mul x! z!)))
    :pattern ((Mul x! (Sub y! z!)))
    :qid user_vstd__arithmetic__mul__lemma_mul_is_distributive_sub_30
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_distributive_sub_30
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
    :qid user_vstd__arithmetic__power__lemma_pow1_31
    :skolemid skolem_user_vstd__arithmetic__power__lemma_pow1_31
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
    :qid user_vstd__arithmetic__power__lemma_pow_adds_32
    :skolemid skolem_user_vstd__arithmetic__power__lemma_pow_adds_32
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
(declare-const %%global_location_label%%16 Bool)
(declare-const %%global_location_label%%17 Bool)
(assert
 (forall ((a! Poly) (m! Poly)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.
     a! m!
    ) (and
     (=>
      %%global_location_label%%16
      (> (%I m!) 1)
     )
     (=>
      %%global_location_label%%17
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
       :qid user_curve25519_dalek__specs__field_specs__u64_5_bounded_33
       :skolemid skolem_user_curve25519_dalek__specs__field_specs__u64_5_bounded_33
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

;; Function-Axioms curve25519_dalek::specs::field_specs::is_square
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.is_square.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.is_square.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.is_square.? a!) (exists ((y$ Poly)) (!
       (and
        (has_type y$ NAT)
        (= (curve25519_dalek!specs.field_specs.field_mul.? y$ y$) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
          a!
       )))
       :pattern ((curve25519_dalek!specs.field_specs.field_mul.? y$ y$))
       :qid user_curve25519_dalek__specs__field_specs__is_square_34
       :skolemid skolem_user_curve25519_dalek__specs__field_specs__is_square_34
    )))
    :pattern ((curve25519_dalek!specs.field_specs.is_square.? a!))
    :qid internal_curve25519_dalek!specs.field_specs.is_square.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.is_square.?_definition
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

;; Function-Axioms curve25519_dalek::specs::field_specs::spec_fe51_as_bytes
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.)
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
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.)
  (forall ((fe! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.? fe!) (%Poly%vstd!seq.Seq<u8.>.
      (let
       ((limbs$ (curve25519_dalek!specs.field_specs_u64.spec_reduce.? (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe!)
       )))))
       (let
        ((q0$ (uClip 64 (bitshr (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                  $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs$)
                 ) (I 0)
                )
               ) 19
             ))
            ) (I 51)
        ))))
        (let
         ((q1$ (uClip 64 (bitshr (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs$)
                  ) (I 1)
                 )
                ) q0$
              ))
             ) (I 51)
         ))))
         (let
          ((q2$ (uClip 64 (bitshr (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                    $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs$)
                   ) (I 2)
                  )
                 ) q1$
               ))
              ) (I 51)
          ))))
          (let
           ((q3$ (uClip 64 (bitshr (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                     $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs$)
                    ) (I 3)
                   )
                  ) q2$
                ))
               ) (I 51)
           ))))
           (let
            ((q$ (uClip 64 (bitshr (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                      $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs$)
                     ) (I 4)
                    )
                   ) q3$
                 ))
                ) (I 51)
            ))))
            (let
             ((limbs0_adj$ (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                    $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs$)
                   ) (I 0)
                  )
                 ) (Mul 19 q$)
             ))))
             (let
              ((limbs1_adj$ (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                     $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs$)
                    ) (I 1)
                   )
                  ) (uClip 64 (bitshr (I limbs0_adj$) (I 51)))
              ))))
              (let
               ((limbs0_canon$ (uClip 64 (uClip 64 (bitand (I limbs0_adj$) (I curve25519_dalek!specs.field_specs_u64.mask51.?))))))
               (let
                ((limbs2_adj$ (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                       $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs$)
                      ) (I 2)
                     )
                    ) (uClip 64 (bitshr (I limbs1_adj$) (I 51)))
                ))))
                (let
                 ((limbs1_canon$ (uClip 64 (uClip 64 (bitand (I limbs1_adj$) (I curve25519_dalek!specs.field_specs_u64.mask51.?))))))
                 (let
                  ((limbs3_adj$ (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                         $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs$)
                        ) (I 3)
                       )
                      ) (uClip 64 (bitshr (I limbs2_adj$) (I 51)))
                  ))))
                  (let
                   ((limbs2_canon$ (uClip 64 (uClip 64 (bitand (I limbs2_adj$) (I curve25519_dalek!specs.field_specs_u64.mask51.?))))))
                   (let
                    ((limbs4_adj$ (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                           $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs$)
                          ) (I 4)
                         )
                        ) (uClip 64 (bitshr (I limbs3_adj$) (I 51)))
                    ))))
                    (let
                     ((limbs3_canon$ (uClip 64 (uClip 64 (bitand (I limbs3_adj$) (I curve25519_dalek!specs.field_specs_u64.mask51.?))))))
                     (let
                      ((limbs4_canon$ (uClip 64 (uClip 64 (bitand (I limbs4_adj$) (I curve25519_dalek!specs.field_specs_u64.mask51.?))))))
                      (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (array_new $ (UINT 8)
                        32 (%%array%%1 (I (uClip 8 limbs0_canon$)) (I (uClip 8 (uClip 64 (bitshr (I limbs0_canon$)
                             (I 8)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs0_canon$) (I 16))))) (I (uClip 8 (uClip 64 (
                             bitshr (I limbs0_canon$) (I 24)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs0_canon$) (I 32))))) (I (uClip 8 (uClip 64 (
                             bitshr (I limbs0_canon$) (I 40)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitor (I (uClip 64 (bitshr (I limbs0_canon$) (I 48)))) (I (uClip
                               64 (bitshl (I limbs1_canon$) (I 3))
                          )))))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs1_canon$) (I 5))))) (I (uClip 8 (uClip 64 (bitshr
                             (I limbs1_canon$) (I 13)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs1_canon$) (I 21))))) (I (uClip 8 (uClip 64 (
                             bitshr (I limbs1_canon$) (I 29)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs1_canon$) (I 37))))) (I (uClip 8 (uClip 64 (
                             bitor (I (uClip 64 (bitshr (I limbs1_canon$) (I 45)))) (I (uClip 64 (bitshl (I limbs2_canon$)
                                (I 6)
                          ))))))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs2_canon$) (I 2))))) (I (uClip 8 (uClip 64 (bitshr
                             (I limbs2_canon$) (I 10)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs2_canon$) (I 18))))) (I (uClip 8 (uClip 64 (
                             bitshr (I limbs2_canon$) (I 26)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs2_canon$) (I 34))))) (I (uClip 8 (uClip 64 (
                             bitshr (I limbs2_canon$) (I 42)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitor (I (uClip 64 (bitshr (I limbs2_canon$) (I 50)))) (I (uClip
                               64 (bitshl (I limbs3_canon$) (I 1))
                          )))))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs3_canon$) (I 7))))) (I (uClip 8 (uClip 64 (bitshr
                             (I limbs3_canon$) (I 15)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs3_canon$) (I 23))))) (I (uClip 8 (uClip 64 (
                             bitshr (I limbs3_canon$) (I 31)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs3_canon$) (I 39))))) (I (uClip 8 (uClip 64 (
                             bitor (I (uClip 64 (bitshr (I limbs3_canon$) (I 47)))) (I (uClip 64 (bitshl (I limbs4_canon$)
                                (I 4)
                          ))))))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs4_canon$) (I 4))))) (I (uClip 8 (uClip 64 (bitshr
                             (I limbs4_canon$) (I 12)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs4_canon$) (I 20))))) (I (uClip 8 (uClip 64 (
                             bitshr (I limbs4_canon$) (I 28)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs4_canon$) (I 36))))) (I (uClip 8 (uClip 64 (
                             bitshr (I limbs4_canon$) (I 44)
    )))))))))))))))))))))))))
    :pattern ((curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.? fe!))
    :qid internal_curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.?_definition
))))

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
        :qid user_curve25519_dalek__specs__primality_specs__is_prime_35
        :skolemid skolem_user_curve25519_dalek__specs__primality_specs__is_prime_35
    ))))
    :pattern ((curve25519_dalek!specs.primality_specs.is_prime.? n!))
    :qid internal_curve25519_dalek!specs.primality_specs.is_prime.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.primality_specs.is_prime.?_definition
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
(declare-const %%global_location_label%%18 Bool)
(assert
 (forall ((a! Int)) (!
   (= (req%curve25519_dalek!specs.field_specs.field_inv_property. a!) (=>
     %%global_location_label%%18
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
(declare-const %%global_location_label%%19 Bool)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_left.
     a! b!
    ) (=>
     %%global_location_label%%19
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

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::lemma_euclid_prime
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_euclid_prime.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%20 Bool)
(declare-const %%global_location_label%%21 Bool)
(assert
 (forall ((a! Int) (b! Int) (p! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_euclid_prime.
     a! b! p!
    ) (and
     (=>
      %%global_location_label%%20
      (curve25519_dalek!specs.primality_specs.is_prime.? (I p!))
     )
     (=>
      %%global_location_label%%21
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
(declare-const %%global_location_label%%22 Bool)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_right.
     a! b!
    ) (=>
     %%global_location_label%%22
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

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_pow_nonnegative
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nonnegative.
 (Int Int) Bool
)
(declare-const %%global_location_label%%23 Bool)
(assert
 (forall ((base! Int) (n! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nonnegative. base!
     n!
    ) (=>
     %%global_location_label%%23
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

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::lemma_mod_sub_eq_implies_zero
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_mod_sub_eq_implies_zero.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%24 Bool)
(declare-const %%global_location_label%%25 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_mod_sub_eq_implies_zero.
     x! y! m!
    ) (and
     (=>
      %%global_location_label%%24
      (> m! 0)
     )
     (=>
      %%global_location_label%%25
      (= (EucMod x! m!) (EucMod y! m!))
   )))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_mod_sub_eq_implies_zero.
     x! y! m!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_mod_sub_eq_implies_zero._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_mod_sub_eq_implies_zero._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_mod_sub_eq_implies_zero.
 (Int Int Int) Bool
)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_mod_sub_eq_implies_zero.
     x! y! m!
    ) (= (EucMod (Sub x! y!) m!) 0)
   )
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_mod_sub_eq_implies_zero.
     x! y! m!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_mod_sub_eq_implies_zero._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_mod_sub_eq_implies_zero._definition
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

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_nonzero_product
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_nonzero_product.
 (Int Int) Bool
)
(declare-const %%global_location_label%%26 Bool)
(declare-const %%global_location_label%%27 Bool)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_nonzero_product.
     a! b!
    ) (and
     (=>
      %%global_location_label%%26
      (not (= (EucMod a! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
     )
     (=>
      %%global_location_label%%27
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

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_mul_left_cancel
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_left_cancel.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%28 Bool)
(declare-const %%global_location_label%%29 Bool)
(assert
 (forall ((a! Int) (b! Int) (c! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_left_cancel.
     a! b! c!
    ) (and
     (=>
      %%global_location_label%%28
      (not (= (EucMod a! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
     )
     (=>
      %%global_location_label%%29
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

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::as_bytes_lemmas::lemma_is_negative_equals_parity
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.as_bytes_lemmas.lemma_is_negative_equals_parity.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51.) Bool
)
(assert
 (forall ((fe! curve25519_dalek!backend.serial.u64.field.FieldElement51.)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.as_bytes_lemmas.lemma_is_negative_equals_parity.
     fe!
    ) (= (= (uClip 8 (bitand (I (%I (vstd!seq.Seq.index.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>.
            (curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
              fe!
            ))
           ) (I 0)
         ))
        ) (I 1)
       )
      ) 1
     ) (= (EucMod (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
         fe!
        )
       ) 2
      ) 1
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.as_bytes_lemmas.lemma_is_negative_equals_parity.
     fe!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.as_bytes_lemmas.lemma_is_negative_equals_parity._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.as_bytes_lemmas.lemma_is_negative_equals_parity._definition
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

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_add_sub_cancel
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_sub_cancel.
 (Int Int) Bool
)
(declare-const %%global_location_label%%30 Bool)
(declare-const %%global_location_label%%31 Bool)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_add_sub_cancel.
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

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_inv_of_inv
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_of_inv.
 (Int) Bool
)
(assert
 (forall ((x! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_of_inv.
     x!
    ) (= (curve25519_dalek!specs.field_specs.field_inv.? (I (curve25519_dalek!specs.field_specs.field_inv.?
        (I x!)
      ))
     ) (EucMod x! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_of_inv.
     x!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_of_inv._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_of_inv._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_solve_for_left_factor
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_solve_for_left_factor.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%32 Bool)
(declare-const %%global_location_label%%33 Bool)
(assert
 (forall ((a! Int) (b! Int) (c! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_solve_for_left_factor.
     a! b! c!
    ) (and
     (=>
      %%global_location_label%%32
      (not (= (EucMod b! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
     )
     (=>
      %%global_location_label%%33
      (= (curve25519_dalek!specs.field_specs.field_mul.? (I a!) (I b!)) (EucMod c! (curve25519_dalek!specs.field_specs_u64.p.?
         (I 0)
   ))))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_solve_for_left_factor.
     a! b! c!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_solve_for_left_factor._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_solve_for_left_factor._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_solve_for_left_factor.
 (Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (c! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_solve_for_left_factor.
     a! b! c!
    ) (= (EucMod a! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) (curve25519_dalek!specs.field_specs.field_mul.?
      (I c!) (I (curve25519_dalek!specs.field_specs.field_inv.? (I b!)))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_solve_for_left_factor.
     a! b! c!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_solve_for_left_factor._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_solve_for_left_factor._definition
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
(declare-const %%global_location_label%%34 Bool)
(assert
 (forall ((a! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_neg_nonzero.
     a!
    ) (=>
     %%global_location_label%%34
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

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_square_of_pow_mod
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_square_of_pow_mod.
 (Int Int) Bool
)
(declare-const %%global_location_label%%35 Bool)
(assert
 (forall ((x! Int) (k! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_square_of_pow_mod.
     x! k!
    ) (=>
     %%global_location_label%%35
     (>= x! 0)
   ))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_square_of_pow_mod.
     x! k!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_square_of_pow_mod._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_square_of_pow_mod._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_square_of_pow_mod.
 (Int Int) Bool
)
(assert
 (forall ((x! Int) (k! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_square_of_pow_mod.
     x! k!
    ) (and
     (>= (vstd!arithmetic.power.pow.? (I x!) (I k!)) 0)
     (>= (vstd!arithmetic.power.pow.? (I x!) (I (nClip (Mul 2 k!)))) 0)
     (= (curve25519_dalek!specs.field_specs.field_square.? (I (EucMod (nClip (vstd!arithmetic.power.pow.?
           (I x!) (I k!)
          )
         ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
       ))
      ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I x!) (I (nClip (Mul 2 k!))))) (curve25519_dalek!specs.field_specs_u64.p.?
        (I 0)
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_square_of_pow_mod.
     x! k!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_square_of_pow_mod._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_square_of_pow_mod._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_v_times_sq_uv3_eq_u_times_w
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_v_times_sq_uv3_eq_u_times_w.
 (Int Int) Bool
)
(assert
 (forall ((u_val! Int) (v_val! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_v_times_sq_uv3_eq_u_times_w.
     u_val! v_val!
    ) (let
     ((v3$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_square.?
          (I v_val!)
         )
        ) (I v_val!)
     )))
     (let
      ((v7$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_square.?
           (I v3$)
          )
         ) (I v_val!)
      )))
      (let
       ((w$ (curve25519_dalek!specs.field_specs.field_mul.? (I u_val!) (I v7$))))
       (let
        ((uv3$ (curve25519_dalek!specs.field_specs.field_mul.? (I u_val!) (I v3$))))
        (= (curve25519_dalek!specs.field_specs.field_mul.? (I v_val!) (I (curve25519_dalek!specs.field_specs.field_square.?
            (I uv3$)
          ))
         ) (curve25519_dalek!specs.field_specs.field_mul.? (I u_val!) (I w$))
   ))))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_v_times_sq_uv3_eq_u_times_w.
     u_val! v_val!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_v_times_sq_uv3_eq_u_times_w._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_v_times_sq_uv3_eq_u_times_w._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_mul_square_canonical
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_square_canonical.
 (Int Int) Bool
)
(assert
 (forall ((r! Int) (v! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_square_canonical.
     r! v!
    ) (and
     (= (curve25519_dalek!specs.field_specs.field_mul.? (I v!) (I (curve25519_dalek!specs.field_specs.field_square.?
         (I r!)
       ))
      ) (curve25519_dalek!specs.field_specs_u64.field_canonical.? (I (nClip (Mul (nClip (Mul
            r! r!
           )
          ) v!
     )))))
     (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_square.?
         (I r!)
        )
       ) (I v!)
      ) (curve25519_dalek!specs.field_specs_u64.field_canonical.? (I (nClip (Mul (nClip (Mul
            r! r!
           )
          ) v!
   )))))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_square_canonical.
     r! v!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_square_canonical._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_square_canonical._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::lemma_p_is_odd
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_p_is_odd.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_p_is_odd.
     no%param
    ) (= (EucMod (curve25519_dalek!specs.field_specs_u64.p.? (I 0)) 2) 1)
   )
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_p_is_odd.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_p_is_odd._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_p_is_odd._definition
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

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_m1_lemmas::axiom_sqrt_m1_not_square
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.axiom_sqrt_m1_not_square.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.axiom_sqrt_m1_not_square.
     no%param
    ) (not (curve25519_dalek!specs.field_specs.is_square.? (I (curve25519_dalek!specs.field_specs.sqrt_m1.?
        (I 0)
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.axiom_sqrt_m1_not_square.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.axiom_sqrt_m1_not_square._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.axiom_sqrt_m1_not_square._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_m1_lemmas::axiom_neg_sqrt_m1_not_square
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.axiom_neg_sqrt_m1_not_square.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.axiom_neg_sqrt_m1_not_square.
     no%param
    ) (not (curve25519_dalek!specs.field_specs.is_square.? (I (nClip (Sub (curve25519_dalek!specs.field_specs_u64.p.?
          (I 0)
         ) (curve25519_dalek!specs.field_specs.sqrt_m1.? (I 0))
   ))))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.axiom_neg_sqrt_m1_not_square.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.axiom_neg_sqrt_m1_not_square._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.axiom_neg_sqrt_m1_not_square._definition
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

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_m1_lemmas::lemma_multiply_by_i_flips_sign
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_multiply_by_i_flips_sign.
 (Int) Bool
)
(assert
 (forall ((r! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_multiply_by_i_flips_sign.
     r!
    ) (and
     (= (curve25519_dalek!specs.field_specs.field_square.? (I (curve25519_dalek!specs.field_specs.field_mul.?
         (I r!) (I (curve25519_dalek!specs.field_specs.sqrt_m1.? (I 0)))
       ))
      ) (curve25519_dalek!specs.field_specs.field_neg.? (I (curve25519_dalek!specs.field_specs.field_square.?
         (I r!)
     ))))
     (= (EucMod (EucMod (nClip (Mul (EucMod (nClip (Mul r! (curve25519_dalek!specs.field_specs.sqrt_m1.?
              (I 0)
            ))
           ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
          ) (nClip (Mul r! (curve25519_dalek!specs.field_specs.sqrt_m1.? (I 0))))
         )
        ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
       ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
      ) (nClip (EucMod (Sub (curve25519_dalek!specs.field_specs_u64.p.? (I 0)) (EucMod (nClip
           (Mul r! r!)
          ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
         )
        ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_multiply_by_i_flips_sign.
     r!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_multiply_by_i_flips_sign._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_multiply_by_i_flips_sign._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_m1_lemmas::lemma_u_times_inv_iu_is_neg_i
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_u_times_inv_iu_is_neg_i.
 (Int Int) Bool
)
(declare-const %%global_location_label%%36 Bool)
(declare-const %%global_location_label%%37 Bool)
(declare-const %%global_location_label%%38 Bool)
(assert
 (forall ((u! Int) (i! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_u_times_inv_iu_is_neg_i.
     u! i!
    ) (and
     (=>
      %%global_location_label%%36
      (not (= (EucMod u! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
     )
     (=>
      %%global_location_label%%37
      (= i! (curve25519_dalek!specs.field_specs.sqrt_m1.? (I 0)))
     )
     (=>
      %%global_location_label%%38
      (not (= (EucMod i! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
   )))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_u_times_inv_iu_is_neg_i.
     u! i!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_u_times_inv_iu_is_neg_i._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_u_times_inv_iu_is_neg_i._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_u_times_inv_iu_is_neg_i.
 (Int Int) Bool
)
(assert
 (forall ((u! Int) (i! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_u_times_inv_iu_is_neg_i.
     u! i!
    ) (let
     ((iu$ (curve25519_dalek!specs.field_specs.field_mul.? (I i!) (I u!))))
     (let
      ((inv_iu$ (curve25519_dalek!specs.field_specs.field_inv.? (I iu$))))
      (= (curve25519_dalek!specs.field_specs.field_mul.? (I u!) (I inv_iu$)) (curve25519_dalek!specs.field_specs.field_neg.?
        (I i!)
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_u_times_inv_iu_is_neg_i.
     u! i!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_u_times_inv_iu_is_neg_i._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_u_times_inv_iu_is_neg_i._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_m1_lemmas::lemma_neg_u_times_inv_iu_is_i
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_neg_u_times_inv_iu_is_i.
 (Int Int) Bool
)
(declare-const %%global_location_label%%39 Bool)
(declare-const %%global_location_label%%40 Bool)
(declare-const %%global_location_label%%41 Bool)
(assert
 (forall ((u! Int) (i! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_neg_u_times_inv_iu_is_i.
     u! i!
    ) (and
     (=>
      %%global_location_label%%39
      (not (= (EucMod u! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
     )
     (=>
      %%global_location_label%%40
      (= i! (curve25519_dalek!specs.field_specs.sqrt_m1.? (I 0)))
     )
     (=>
      %%global_location_label%%41
      (not (= (EucMod i! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
   )))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_neg_u_times_inv_iu_is_i.
     u! i!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_neg_u_times_inv_iu_is_i._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_neg_u_times_inv_iu_is_i._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_neg_u_times_inv_iu_is_i.
 (Int Int) Bool
)
(assert
 (forall ((u! Int) (i! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_neg_u_times_inv_iu_is_i.
     u! i!
    ) (let
     ((neg_u$ (curve25519_dalek!specs.field_specs.field_neg.? (I u!))))
     (let
      ((iu$ (curve25519_dalek!specs.field_specs.field_mul.? (I i!) (I u!))))
      (let
       ((inv_iu$ (curve25519_dalek!specs.field_specs.field_inv.? (I iu$))))
       (= (curve25519_dalek!specs.field_specs.field_mul.? (I neg_u$) (I inv_iu$)) (EucMod
         i! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   ))))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_neg_u_times_inv_iu_is_i.
     u! i!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_neg_u_times_inv_iu_is_i._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_neg_u_times_inv_iu_is_i._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::lemma_p_divisibility_facts
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_p_divisibility_facts.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_p_divisibility_facts.
     no%param
    ) (let
     ((pn$ (curve25519_dalek!specs.field_specs_u64.p.? (I 0))))
     (let
      ((k$ (nClip (EucDiv (Sub pn$ 5) 8))))
      (let
       ((quarter$ (nClip (EucDiv (Sub pn$ 1) 4))))
       (let
        ((half$ (nClip (EucDiv (Sub pn$ 1) 2))))
        (and
         (and
          (and
           (and
            (and
             (and
              (and
               (and
                (= (EucMod (Sub pn$ 5) 8) 0)
                (= (EucMod (Sub pn$ 1) 4) 0)
               )
               (= (EucMod (Sub pn$ 1) 2) 0)
              )
              (= (nClip (Mul 8 k$)) (Sub pn$ 5))
             )
             (= (nClip (Mul 4 quarter$)) (Sub pn$ 1))
            )
            (= (nClip (Mul 2 half$)) (Sub pn$ 1))
           )
           (= quarter$ (nClip (Add (nClip (Mul 2 k$)) 1)))
          )
          (= half$ (nClip (Mul 2 quarter$)))
         )
         (= k$ (nClip (Sub (vstd!arithmetic.power2.pow2.? (I 252)) 3)))
   ))))))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_p_divisibility_facts.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_p_divisibility_facts._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_p_divisibility_facts._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_m1_lemmas::lemma_fourth_root_of_unity
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_fourth_root_of_unity.
 (Int) Bool
)
(declare-const %%global_location_label%%42 Bool)
(assert
 (forall ((x! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_fourth_root_of_unity.
     x!
    ) (=>
     %%global_location_label%%42
     (not (= (EucMod x! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
   ))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_fourth_root_of_unity.
     x!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_fourth_root_of_unity._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_fourth_root_of_unity._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_fourth_root_of_unity.
 (Int) Bool
)
(assert
 (forall ((x! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_fourth_root_of_unity.
     x!
    ) (let
     ((y$ (EucMod (nClip (vstd!arithmetic.power.pow.? (I x!) (I (nClip (EucDiv (Sub (curve25519_dalek!specs.field_specs_u64.p.?
               (I 0)
              ) 1
             ) 4
         ))))
        ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     )))
     (let
      ((i$ (curve25519_dalek!specs.field_specs.sqrt_m1.? (I 0))))
      (or
       (or
        (or
         (= y$ 1)
         (= y$ (nClip (Sub (curve25519_dalek!specs.field_specs_u64.p.? (I 0)) 1)))
        )
        (= y$ i$)
       )
       (= y$ (nClip (Sub (curve25519_dalek!specs.field_specs_u64.p.? (I 0)) i$)))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_fourth_root_of_unity.
     x!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_fourth_root_of_unity._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_m1_lemmas.lemma_fourth_root_of_unity._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_ratio_lemmas::lemma_is_sqrt_ratio_to_field
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_is_sqrt_ratio_to_field.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%43 Bool)
(assert
 (forall ((x! Int) (u! Int) (v! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_is_sqrt_ratio_to_field.
     x! u! v!
    ) (=>
     %%global_location_label%%43
     (curve25519_dalek!specs.field_specs.is_sqrt_ratio.? (I u!) (I v!) (I x!))
   ))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_is_sqrt_ratio_to_field.
     x! u! v!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_is_sqrt_ratio_to_field._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_is_sqrt_ratio_to_field._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_is_sqrt_ratio_to_field.
 (Int Int Int) Bool
)
(assert
 (forall ((x! Int) (u! Int) (v! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_is_sqrt_ratio_to_field.
     x! u! v!
    ) (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_square.?
        (I x!)
       )
      ) (I v!)
     ) (EucMod u! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_is_sqrt_ratio_to_field.
     x! u! v!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_is_sqrt_ratio_to_field._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_is_sqrt_ratio_to_field._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_ratio_lemmas::lemma_algebraic_chain_base
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_algebraic_chain_base.
 (Int Int Int Int Int) Bool
)
(declare-const %%global_location_label%%44 Bool)
(declare-const %%global_location_label%%45 Bool)
(declare-const %%global_location_label%%46 Bool)
(declare-const %%global_location_label%%47 Bool)
(declare-const %%global_location_label%%48 Bool)
(declare-const %%global_location_label%%49 Bool)
(declare-const %%global_location_label%%50 Bool)
(declare-const %%global_location_label%%51 Bool)
(assert
 (forall ((u! Int) (v! Int) (x! Int) (r! Int) (i! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_algebraic_chain_base.
     u! v! x! r! i!
    ) (and
     (=>
      %%global_location_label%%44
      (not (= (EucMod v! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
     )
     (=>
      %%global_location_label%%45
      (not (= (EucMod u! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
     )
     (=>
      %%global_location_label%%46
      (not (= (EucMod x! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
     )
     (=>
      %%global_location_label%%47
      (< x! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%48
      (< r! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%49
      (= i! (curve25519_dalek!specs.field_specs.sqrt_m1.? (I 0)))
     )
     (=>
      %%global_location_label%%50
      (not (= (EucMod i! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
     )
     (=>
      %%global_location_label%%51
      (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_square.?
          (I x!)
         )
        ) (I v!)
       ) (EucMod (nClip (Mul i! u!)) (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
   ))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_algebraic_chain_base.
     u! v! x! r! i!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_algebraic_chain_base._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_algebraic_chain_base._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_algebraic_chain_base.
 (Int Int Int Int Int) Bool
)
(assert
 (forall ((u! Int) (v! Int) (x! Int) (r! Int) (i! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_algebraic_chain_base.
     u! v! x! r! i!
    ) (let
     ((q$ (curve25519_dalek!specs.field_specs.field_mul.? (I r!) (I (curve25519_dalek!specs.field_specs.field_inv.?
          (I x!)
     )))))
     (let
      ((r_squared_v$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_square.?
           (I r!)
          )
         ) (I v!)
      )))
      (let
       ((iu$ (curve25519_dalek!specs.field_specs.field_mul.? (I i!) (I u!))))
       (let
        ((inv_iu$ (curve25519_dalek!specs.field_specs.field_inv.? (I iu$))))
        (= (curve25519_dalek!specs.field_specs.field_square.? (I q$)) (curve25519_dalek!specs.field_specs.field_mul.?
          (I r_squared_v$) (I inv_iu$)
   )))))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_algebraic_chain_base.
     u! v! x! r! i!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_algebraic_chain_base._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_algebraic_chain_base._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_ratio_lemmas::lemma_no_square_root_when_times_i
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_no_square_root_when_times_i.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%52 Bool)
(declare-const %%global_location_label%%53 Bool)
(declare-const %%global_location_label%%54 Bool)
(declare-const %%global_location_label%%55 Bool)
(assert
 (forall ((u! Int) (v! Int) (r! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_no_square_root_when_times_i.
     u! v! r!
    ) (and
     (=>
      %%global_location_label%%52
      (not (= (EucMod v! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
     )
     (=>
      %%global_location_label%%53
      (not (= (EucMod u! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
     )
     (=>
      %%global_location_label%%54
      (< r! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%55
      (exists ((x$ Poly)) (!
        (and
         (has_type x$ NAT)
         (and
          (< (%I x$) (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
          (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_square.?
              x$
             )
            ) (I v!)
           ) (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.sqrt_m1.?
              (I 0)
             )
            ) (I u!)
        ))))
        :pattern ((curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_square.?
            x$
           )
          ) (I v!)
        ))
        :qid user_curve25519_dalek__lemmas__field_lemmas__sqrt_ratio_lemmas__lemma_no_square_root_when_times_i_52
        :skolemid skolem_user_curve25519_dalek__lemmas__field_lemmas__sqrt_ratio_lemmas__lemma_no_square_root_when_times_i_52
   )))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_no_square_root_when_times_i.
     u! v! r!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_no_square_root_when_times_i._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_no_square_root_when_times_i._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_no_square_root_when_times_i.
 (Int Int Int) Bool
)
(assert
 (forall ((u! Int) (v! Int) (r! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_no_square_root_when_times_i.
     u! v! r!
    ) (and
     (not (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_square.?
          (I r!)
         )
        ) (I v!)
       ) (curve25519_dalek!specs.field_specs_u64.field_canonical.? (I u!))
     ))
     (not (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_square.?
          (I r!)
         )
        ) (I v!)
       ) (curve25519_dalek!specs.field_specs.field_neg.? (I u!))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_no_square_root_when_times_i.
     u! v! r!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_no_square_root_when_times_i._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_no_square_root_when_times_i._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_ratio_lemmas::lemma_sqrt_ratio_check_value
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_check_value.
 (Int Int) Bool
)
(declare-const %%global_location_label%%56 Bool)
(assert
 (forall ((u_val! Int) (v_val! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_check_value.
     u_val! v_val!
    ) (=>
     %%global_location_label%%56
     (not (= (EucMod v_val! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
   ))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_check_value.
     u_val! v_val!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_check_value._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_check_value._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_check_value.
 (Int Int) Bool
)
(assert
 (forall ((u_val! Int) (v_val! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_check_value.
     u_val! v_val!
    ) (let
     ((v3$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_square.?
          (I v_val!)
         )
        ) (I v_val!)
     )))
     (let
      ((v7$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_square.?
           (I v3$)
          )
         ) (I v_val!)
      )))
      (let
       ((w$ (curve25519_dalek!specs.field_specs.field_mul.? (I u_val!) (I v7$))))
       (let
        ((uv3$ (curve25519_dalek!specs.field_specs.field_mul.? (I u_val!) (I v3$))))
        (let
         ((k$ (nClip (EucDiv (Sub (curve25519_dalek!specs.field_specs_u64.p.? (I 0)) 5) 8))))
         (let
          ((pow_result$ (EucMod (nClip (vstd!arithmetic.power.pow.? (I w$) (I k$))) (curve25519_dalek!specs.field_specs_u64.p.?
              (I 0)
          ))))
          (let
           ((r$ (curve25519_dalek!specs.field_specs.field_mul.? (I uv3$) (I pow_result$))))
           (let
            ((check$ (curve25519_dalek!specs.field_specs.field_mul.? (I v_val!) (I (curve25519_dalek!specs.field_specs.field_square.?
                 (I r$)
            )))))
            (let
             ((quarter$ (nClip (EucDiv (Sub (curve25519_dalek!specs.field_specs_u64.p.? (I 0)) 1)
                 4
             ))))
             (let
              ((fourth_root$ (EucMod (nClip (vstd!arithmetic.power.pow.? (I w$) (I quarter$))) (curve25519_dalek!specs.field_specs_u64.p.?
                  (I 0)
              ))))
              (and
               (and
                (>= (vstd!arithmetic.power.pow.? (I w$) (I k$)) 0)
                (>= (vstd!arithmetic.power.pow.? (I w$) (I quarter$)) 0)
               )
               (= check$ (curve25519_dalek!specs.field_specs.field_mul.? (I u_val!) (I fourth_root$)))
   ))))))))))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_check_value.
     u_val! v_val!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_check_value._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_check_value._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_ratio_lemmas::lemma_conditional_negate_makes_even
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_conditional_negate_makes_even.
 (Int Bool) Bool
)
(declare-const %%global_location_label%%57 Bool)
(declare-const %%global_location_label%%58 Bool)
(assert
 (forall ((r_nat! Int) (negated! Bool)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_conditional_negate_makes_even.
     r_nat! negated!
    ) (and
     (=>
      %%global_location_label%%57
      (< r_nat! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%58
      (= negated! (= (EucMod r_nat! 2) 1))
   )))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_conditional_negate_makes_even.
     r_nat! negated!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_conditional_negate_makes_even._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_conditional_negate_makes_even._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_conditional_negate_makes_even.
 (Int Bool) Bool
)
(assert
 (forall ((r_nat! Int) (negated! Bool)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_conditional_negate_makes_even.
     r_nat! negated!
    ) (and
     (=>
      negated!
      (= (EucMod (curve25519_dalek!specs.field_specs.field_neg.? (I r_nat!)) 2) 0)
     )
     (=>
      (not negated!)
      (= (EucMod r_nat! 2) 0)
     )
     (= (EucMod (ite
        negated!
        (curve25519_dalek!specs.field_specs.field_neg.? (I r_nat!))
        r_nat!
       ) 2
      ) 0
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_conditional_negate_makes_even.
     r_nat! negated!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_conditional_negate_makes_even._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_conditional_negate_makes_even._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_ratio_lemmas::lemma_negate_makes_nonnegative
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_negate_makes_nonnegative.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.field.FieldElement51.
  subtle!Choice.
 ) Bool
)
(declare-const %%global_location_label%%59 Bool)
(declare-const %%global_location_label%%60 Bool)
(declare-const %%global_location_label%%61 Bool)
(declare-const %%global_location_label%%62 Bool)
(declare-const %%global_location_label%%63 Bool)
(declare-const %%global_location_label%%64 Bool)
(assert
 (forall ((r_before! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (r_after!
    curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ) (is_neg! subtle!Choice.)
  ) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_negate_makes_nonnegative.
     r_before! r_after! is_neg!
    ) (and
     (=>
      %%global_location_label%%59
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        r_before!
       ) (I 52)
     ))
     (=>
      %%global_location_label%%60
      (= (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
         is_neg!
        )
       ) (= (uClip 8 (bitand (I (%I (vstd!seq.Seq.index.? $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. (
               curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                r_before!
              ))
             ) (I 0)
           ))
          ) (I 1)
         )
        ) 1
     )))
     (=>
      %%global_location_label%%61
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        r_after!
       ) (I 54)
     ))
     (=>
      %%global_location_label%%62
      (=>
       (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
         is_neg!
       ))
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
         r_after!
        ) (I 52)
     )))
     (=>
      %%global_location_label%%63
      (=>
       (not (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
          is_neg!
       )))
       (= r_after! r_before!)
     ))
     (=>
      %%global_location_label%%64
      (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
         r_after!
        )
       ) (ite
        (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
          is_neg!
        ))
        (curve25519_dalek!specs.field_specs.field_neg.? (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
           (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. r_before!)
        )))
        (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          r_before!
   )))))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_negate_makes_nonnegative.
     r_before! r_after! is_neg!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_negate_makes_nonnegative._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_negate_makes_nonnegative._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_negate_makes_nonnegative.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.field.FieldElement51.
  subtle!Choice.
 ) Bool
)
(assert
 (forall ((r_before! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (r_after!
    curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ) (is_neg! subtle!Choice.)
  ) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_negate_makes_nonnegative.
     r_before! r_after! is_neg!
    ) (and
     (= (EucMod (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
         r_after!
        )
       ) 2
      ) 0
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       r_after!
      ) (I 52)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_negate_makes_nonnegative.
     r_before! r_after! is_neg!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_negate_makes_nonnegative._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_negate_makes_nonnegative._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_ratio_lemmas::lemma_eq_neg_times_i_implies_zero
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_eq_neg_times_i_implies_zero.
 (Int) Bool
)
(declare-const %%global_location_label%%65 Bool)
(declare-const %%global_location_label%%66 Bool)
(assert
 (forall ((u! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_eq_neg_times_i_implies_zero.
     u!
    ) (and
     (=>
      %%global_location_label%%65
      (< u! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%66
      (= u! (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_neg.?
          (I u!)
         )
        ) (I (curve25519_dalek!specs.field_specs.sqrt_m1.? (I 0)))
   )))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_eq_neg_times_i_implies_zero.
     u!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_eq_neg_times_i_implies_zero._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_eq_neg_times_i_implies_zero._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_eq_neg_times_i_implies_zero.
 (Int) Bool
)
(assert
 (forall ((u! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_eq_neg_times_i_implies_zero.
     u!
    ) (= u! 0)
   )
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_eq_neg_times_i_implies_zero.
     u!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_eq_neg_times_i_implies_zero._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_eq_neg_times_i_implies_zero._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_ratio_lemmas::lemma_uv7_nonzero
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_uv7_nonzero.
 (Int Int) Bool
)
(declare-const %%global_location_label%%67 Bool)
(declare-const %%global_location_label%%68 Bool)
(declare-const %%global_location_label%%69 Bool)
(declare-const %%global_location_label%%70 Bool)
(assert
 (forall ((u_nat! Int) (v_nat! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_uv7_nonzero. u_nat!
     v_nat!
    ) (and
     (=>
      %%global_location_label%%67
      (< u_nat! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%68
      (< v_nat! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%69
      (not (= u_nat! 0))
     )
     (=>
      %%global_location_label%%70
      (not (= v_nat! 0))
   )))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_uv7_nonzero.
     u_nat! v_nat!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_uv7_nonzero._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_uv7_nonzero._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_uv7_nonzero.
 (Int Int) Bool
)
(assert
 (forall ((u_nat! Int) (v_nat! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_uv7_nonzero. u_nat!
     v_nat!
    ) (let
     ((v3$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_square.?
          (I v_nat!)
         )
        ) (I v_nat!)
     )))
     (let
      ((v7$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_square.?
           (I v3$)
          )
         ) (I v_nat!)
      )))
      (let
       ((w$ (curve25519_dalek!specs.field_specs.field_mul.? (I u_nat!) (I v7$))))
       (not (= (EucMod w$ (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_uv7_nonzero.
     u_nat! v_nat!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_uv7_nonzero._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_uv7_nonzero._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_ratio_lemmas::lemma_check_fourth_root_pattern
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_check_fourth_root_pattern.
 (Int Int Int Int) Bool
)
(declare-const %%global_location_label%%71 Bool)
(declare-const %%global_location_label%%72 Bool)
(declare-const %%global_location_label%%73 Bool)
(declare-const %%global_location_label%%74 Bool)
(declare-const %%global_location_label%%75 Bool)
(declare-const %%global_location_label%%76 Bool)
(declare-const %%global_location_label%%77 Bool)
(assert
 (forall ((u_nat! Int) (v_nat! Int) (check_nat! Int) (r_orig_nat! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_check_fourth_root_pattern.
     u_nat! v_nat! check_nat! r_orig_nat!
    ) (and
     (=>
      %%global_location_label%%71
      (< u_nat! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%72
      (< v_nat! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%73
      (< check_nat! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%74
      (not (= u_nat! 0))
     )
     (=>
      %%global_location_label%%75
      (not (= v_nat! 0))
     )
     (=>
      %%global_location_label%%76
      (= check_nat! (curve25519_dalek!specs.field_specs.field_mul.? (I v_nat!) (I (curve25519_dalek!specs.field_specs.field_square.?
          (I r_orig_nat!)
     )))))
     (=>
      %%global_location_label%%77
      (let
       ((v3$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_square.?
            (I v_nat!)
           )
          ) (I v_nat!)
       )))
       (let
        ((v7$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_square.?
             (I v3$)
            )
           ) (I v_nat!)
        )))
        (let
         ((w$ (curve25519_dalek!specs.field_specs.field_mul.? (I u_nat!) (I v7$))))
         (let
          ((uv3$ (curve25519_dalek!specs.field_specs.field_mul.? (I u_nat!) (I v3$))))
          (let
           ((k$ (nClip (EucDiv (Sub (curve25519_dalek!specs.field_specs_u64.p.? (I 0)) 5) 8))))
           (let
            ((pow_result$ (EucMod (nClip (vstd!arithmetic.power.pow.? (I w$) (I k$))) (curve25519_dalek!specs.field_specs_u64.p.?
                (I 0)
            ))))
            (= r_orig_nat! (curve25519_dalek!specs.field_specs.field_mul.? (I uv3$) (I pow_result$)))
   )))))))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_check_fourth_root_pattern.
     u_nat! v_nat! check_nat! r_orig_nat!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_check_fourth_root_pattern._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_check_fourth_root_pattern._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_check_fourth_root_pattern.
 (Int Int Int Int) Bool
)
(assert
 (forall ((u_nat! Int) (v_nat! Int) (check_nat! Int) (r_orig_nat! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_check_fourth_root_pattern.
     u_nat! v_nat! check_nat! r_orig_nat!
    ) (or
     (or
      (or
       (= check_nat! u_nat!)
       (= check_nat! (curve25519_dalek!specs.field_specs.field_neg.? (I u_nat!)))
      )
      (= check_nat! (curve25519_dalek!specs.field_specs.field_mul.? (I u_nat!) (I (curve25519_dalek!specs.field_specs.sqrt_m1.?
          (I 0)
     )))))
     (= check_nat! (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_neg.?
         (I u_nat!)
        )
       ) (I (curve25519_dalek!specs.field_specs.sqrt_m1.? (I 0)))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_check_fourth_root_pattern.
     u_nat! v_nat! check_nat! r_orig_nat!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_check_fourth_root_pattern._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_check_fourth_root_pattern._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_ratio_lemmas::lemma_sqrt_ratio_zero_propagation
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_zero_propagation.
 (Int Int Int Int) Bool
)
(declare-const %%global_location_label%%78 Bool)
(declare-const %%global_location_label%%79 Bool)
(assert
 (forall ((u_nat! Int) (v_nat! Int) (r_orig_nat! Int) (check_nat! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_zero_propagation.
     u_nat! v_nat! r_orig_nat! check_nat!
    ) (and
     (=>
      %%global_location_label%%78
      (= check_nat! (curve25519_dalek!specs.field_specs.field_mul.? (I v_nat!) (I (curve25519_dalek!specs.field_specs.field_square.?
          (I r_orig_nat!)
     )))))
     (=>
      %%global_location_label%%79
      (let
       ((v3$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_square.?
            (I v_nat!)
           )
          ) (I v_nat!)
       )))
       (let
        ((v7$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_square.?
             (I v3$)
            )
           ) (I v_nat!)
        )))
        (let
         ((w$ (curve25519_dalek!specs.field_specs.field_mul.? (I u_nat!) (I v7$))))
         (let
          ((uv3$ (curve25519_dalek!specs.field_specs.field_mul.? (I u_nat!) (I v3$))))
          (let
           ((k$ (nClip (EucDiv (Sub (curve25519_dalek!specs.field_specs_u64.p.? (I 0)) 5) 8))))
           (let
            ((pow_result$ (EucMod (nClip (vstd!arithmetic.power.pow.? (I w$) (I k$))) (curve25519_dalek!specs.field_specs_u64.p.?
                (I 0)
            ))))
            (= r_orig_nat! (curve25519_dalek!specs.field_specs.field_mul.? (I uv3$) (I pow_result$)))
   )))))))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_zero_propagation.
     u_nat! v_nat! r_orig_nat! check_nat!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_zero_propagation._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_zero_propagation._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_zero_propagation.
 (Int Int Int Int) Bool
)
(assert
 (forall ((u_nat! Int) (v_nat! Int) (r_orig_nat! Int) (check_nat! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_zero_propagation.
     u_nat! v_nat! r_orig_nat! check_nat!
    ) (and
     (=>
      (= u_nat! 0)
      (and
       (= r_orig_nat! 0)
       (= check_nat! 0)
     ))
     (=>
      (= v_nat! 0)
      (and
       (= r_orig_nat! 0)
       (= check_nat! 0)
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_zero_propagation.
     u_nat! v_nat! r_orig_nat! check_nat!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_zero_propagation._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_zero_propagation._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_ratio_lemmas::lemma_zero_is_sqrt_ratio
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_zero_is_sqrt_ratio.
 (Int) Bool
)
(assert
 (forall ((v_nat! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_zero_is_sqrt_ratio.
     v_nat!
    ) (curve25519_dalek!specs.field_specs.is_sqrt_ratio.? (I 0) (I v_nat!) (I 0))
   )
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_zero_is_sqrt_ratio.
     v_nat!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_zero_is_sqrt_ratio._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_zero_is_sqrt_ratio._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_ratio_lemmas::lemma_sqrt_ratio_correctness
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_correctness.
 (Int Int Int Int Int Bool Bool Bool Bool) Bool
)
(declare-const %%global_location_label%%80 Bool)
(declare-const %%global_location_label%%81 Bool)
(declare-const %%global_location_label%%82 Bool)
(declare-const %%global_location_label%%83 Bool)
(declare-const %%global_location_label%%84 Bool)
(declare-const %%global_location_label%%85 Bool)
(declare-const %%global_location_label%%86 Bool)
(declare-const %%global_location_label%%87 Bool)
(declare-const %%global_location_label%%88 Bool)
(declare-const %%global_location_label%%89 Bool)
(declare-const %%global_location_label%%90 Bool)
(declare-const %%global_location_label%%91 Bool)
(declare-const %%global_location_label%%92 Bool)
(declare-const %%global_location_label%%93 Bool)
(assert
 (forall ((u_nat! Int) (v_nat! Int) (check_nat! Int) (r_orig_nat! Int) (r_nat! Int)
   (correct_sign! Bool) (flipped_sign! Bool) (flipped_sign_i! Bool) (was_nonzero_sq!
    Bool
   )
  ) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_correctness.
     u_nat! v_nat! check_nat! r_orig_nat! r_nat! correct_sign! flipped_sign! flipped_sign_i!
     was_nonzero_sq!
    ) (and
     (=>
      %%global_location_label%%80
      (< u_nat! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%81
      (< v_nat! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%82
      (< check_nat! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%83
      (< r_orig_nat! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%84
      (< r_nat! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%85
      (= check_nat! (curve25519_dalek!specs.field_specs.field_mul.? (I v_nat!) (I (curve25519_dalek!specs.field_specs.field_square.?
          (I r_orig_nat!)
     )))))
     (=>
      %%global_location_label%%86
      (= correct_sign! (= check_nat! u_nat!))
     )
     (=>
      %%global_location_label%%87
      (= flipped_sign! (= check_nat! (curve25519_dalek!specs.field_specs.field_neg.? (I u_nat!))))
     )
     (=>
      %%global_location_label%%88
      (= flipped_sign_i! (= check_nat! (curve25519_dalek!specs.field_specs.field_mul.? (I (
           curve25519_dalek!specs.field_specs.field_neg.? (I u_nat!)
          )
         ) (I (curve25519_dalek!specs.field_specs.sqrt_m1.? (I 0)))
     ))))
     (=>
      %%global_location_label%%89
      (= was_nonzero_sq! (or
        correct_sign!
        flipped_sign!
     )))
     (=>
      %%global_location_label%%90
      (= r_nat! (ite
        (or
         flipped_sign!
         flipped_sign_i!
        )
        (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.sqrt_m1.?
           (I 0)
          )
         ) (I r_orig_nat!)
        )
        r_orig_nat!
     )))
     (=>
      %%global_location_label%%91
      (=>
       (and
        (not (= v_nat! 0))
        (not (= u_nat! 0))
       )
       (or
        (or
         (or
          (= check_nat! u_nat!)
          (= check_nat! (curve25519_dalek!specs.field_specs.field_neg.? (I u_nat!)))
         )
         (= check_nat! (curve25519_dalek!specs.field_specs.field_mul.? (I u_nat!) (I (curve25519_dalek!specs.field_specs.sqrt_m1.?
             (I 0)
        )))))
        (= check_nat! (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_neg.?
            (I u_nat!)
           )
          ) (I (curve25519_dalek!specs.field_specs.sqrt_m1.? (I 0)))
     )))))
     (=>
      %%global_location_label%%92
      (=>
       (= u_nat! 0)
       (and
        (= r_orig_nat! 0)
        (= check_nat! 0)
     )))
     (=>
      %%global_location_label%%93
      (=>
       (= v_nat! 0)
       (and
        (= r_orig_nat! 0)
        (= check_nat! 0)
   )))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_correctness.
     u_nat! v_nat! check_nat! r_orig_nat! r_nat! correct_sign! flipped_sign! flipped_sign_i!
     was_nonzero_sq!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_correctness._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_correctness._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_correctness.
 (Int Int Int Int Int Bool Bool Bool Bool) Bool
)
(assert
 (forall ((u_nat! Int) (v_nat! Int) (check_nat! Int) (r_orig_nat! Int) (r_nat! Int)
   (correct_sign! Bool) (flipped_sign! Bool) (flipped_sign_i! Bool) (was_nonzero_sq!
    Bool
   )
  ) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_correctness.
     u_nat! v_nat! check_nat! r_orig_nat! r_nat! correct_sign! flipped_sign! flipped_sign_i!
     was_nonzero_sq!
    ) (and
     (=>
      (= u_nat! 0)
      (and
       was_nonzero_sq!
       (= r_nat! 0)
     ))
     (=>
      (and
       (= v_nat! 0)
       (not (= u_nat! 0))
      )
      (and
       (not was_nonzero_sq!)
       (= r_nat! 0)
     ))
     (=>
      (and
       was_nonzero_sq!
       (not (= v_nat! 0))
      )
      (curve25519_dalek!specs.field_specs.is_sqrt_ratio.? (I u_nat!) (I v_nat!) (I r_nat!))
     )
     (=>
      (and
       (and
        (not was_nonzero_sq!)
        (not (= v_nat! 0))
       )
       (not (= u_nat! 0))
      )
      (curve25519_dalek!specs.field_specs.is_sqrt_ratio_times_i.? (I u_nat!) (I v_nat!)
       (I r_nat!)
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_correctness.
     u_nat! v_nat! check_nat! r_orig_nat! r_nat! correct_sign! flipped_sign! flipped_sign_i!
     was_nonzero_sq!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_correctness._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_correctness._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_ratio_lemmas::lemma_nonneg_square_root_unique
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_nonneg_square_root_unique.
 (Int Int) Bool
)
(declare-const %%global_location_label%%94 Bool)
(declare-const %%global_location_label%%95 Bool)
(declare-const %%global_location_label%%96 Bool)
(declare-const %%global_location_label%%97 Bool)
(declare-const %%global_location_label%%98 Bool)
(assert
 (forall ((r! Int) (s! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_nonneg_square_root_unique.
     r! s!
    ) (and
     (=>
      %%global_location_label%%94
      (< r! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%95
      (< s! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%96
      (= (EucMod r! 2) 0)
     )
     (=>
      %%global_location_label%%97
      (= (EucMod s! 2) 0)
     )
     (=>
      %%global_location_label%%98
      (= (curve25519_dalek!specs.field_specs.field_square.? (I r!)) (curve25519_dalek!specs.field_specs.field_square.?
        (I s!)
   )))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_nonneg_square_root_unique.
     r! s!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_nonneg_square_root_unique._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_nonneg_square_root_unique._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_nonneg_square_root_unique.
 (Int Int) Bool
)
(assert
 (forall ((r! Int) (s! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_nonneg_square_root_unique.
     r! s!
    ) (= r! s!)
   )
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_nonneg_square_root_unique.
     r! s!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_nonneg_square_root_unique._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_nonneg_square_root_unique._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_ratio_lemmas::lemma_nat_invsqrt_satisfies_relation
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_nat_invsqrt_satisfies_relation.
 (Int) Bool
)
(declare-const %%global_location_label%%99 Bool)
(assert
 (forall ((a! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_nat_invsqrt_satisfies_relation.
     a!
    ) (=>
     %%global_location_label%%99
     (not (= (EucMod a! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
   ))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_nat_invsqrt_satisfies_relation.
     a!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_nat_invsqrt_satisfies_relation._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_nat_invsqrt_satisfies_relation._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_nat_invsqrt_satisfies_relation.
 (Int) Bool
)
(assert
 (forall ((a! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_nat_invsqrt_satisfies_relation.
     a!
    ) (let
     ((s$ (curve25519_dalek!specs.field_specs.nat_invsqrt.? (I a!))))
     (and
      (and
       (< s$ (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
       (= (EucMod s$ 2) 0)
      )
      (or
       (curve25519_dalek!specs.field_specs.is_sqrt_ratio.? (I 1) (I a!) (I s$))
       (curve25519_dalek!specs.field_specs.is_sqrt_ratio_times_i.? (I 1) (I a!) (I s$))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_nat_invsqrt_satisfies_relation.
     a!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_nat_invsqrt_satisfies_relation._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_nat_invsqrt_satisfies_relation._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_ratio_lemmas::lemma_invsqrt_unique
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_unique.
 (Int Int) Bool
)
(declare-const %%global_location_label%%100 Bool)
(declare-const %%global_location_label%%101 Bool)
(declare-const %%global_location_label%%102 Bool)
(declare-const %%global_location_label%%103 Bool)
(assert
 (forall ((a! Int) (r! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_unique.
     a! r!
    ) (and
     (=>
      %%global_location_label%%100
      (not (= (EucMod a! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
     )
     (=>
      %%global_location_label%%101
      (< r! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%102
      (not (curve25519_dalek!specs.field_specs.is_negative.? (I r!)))
     )
     (=>
      %%global_location_label%%103
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

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_ratio_lemmas::lemma_sqrt_ratio_mutual_exclusion
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_mutual_exclusion.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%104 Bool)
(assert
 (forall ((u! Int) (v! Int) (r! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_mutual_exclusion.
     u! v! r!
    ) (=>
     %%global_location_label%%104
     (not (= (EucMod u! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
   ))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_mutual_exclusion.
     u! v! r!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_mutual_exclusion._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_mutual_exclusion._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_mutual_exclusion.
 (Int Int Int) Bool
)
(assert
 (forall ((u! Int) (v! Int) (r! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_mutual_exclusion.
     u! v! r!
    ) (not (and
      (curve25519_dalek!specs.field_specs.is_sqrt_ratio.? (I u!) (I v!) (I r!))
      (curve25519_dalek!specs.field_specs.is_sqrt_ratio_times_i.? (I u!) (I v!) (I r!))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_mutual_exclusion.
     u! v! r!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_mutual_exclusion._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_sqrt_ratio_mutual_exclusion._definition
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

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::sqrt_ratio_lemmas::lemma_invsqrt_matches_spec
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_matches_spec.
 (Int Int) Bool
)
(declare-const %%global_location_label%%105 Bool)
(declare-const %%global_location_label%%106 Bool)
(declare-const %%global_location_label%%107 Bool)
(declare-const %%global_location_label%%108 Bool)
(declare-const %%global_location_label%%109 Bool)
(assert
 (forall ((big_i_nat! Int) (v_u2_sqr_nat! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_matches_spec.
     big_i_nat! v_u2_sqr_nat!
    ) (and
     (=>
      %%global_location_label%%105
      (= (EucMod big_i_nat! 2) 0)
     )
     (=>
      %%global_location_label%%106
      (=>
       (= v_u2_sqr_nat! 0)
       (= big_i_nat! 0)
     ))
     (=>
      %%global_location_label%%107
      (=>
       (not (= v_u2_sqr_nat! 0))
       (or
        (curve25519_dalek!specs.field_specs.is_sqrt_ratio.? (I 1) (I v_u2_sqr_nat!) (I big_i_nat!))
        (curve25519_dalek!specs.field_specs.is_sqrt_ratio_times_i.? (I 1) (I v_u2_sqr_nat!)
         (I big_i_nat!)
     ))))
     (=>
      %%global_location_label%%108
      (< big_i_nat! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%109
      (< v_u2_sqr_nat! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
   )))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_matches_spec.
     big_i_nat! v_u2_sqr_nat!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_matches_spec._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_matches_spec._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_matches_spec.
 (Int Int) Bool
)
(assert
 (forall ((big_i_nat! Int) (v_u2_sqr_nat! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_matches_spec.
     big_i_nat! v_u2_sqr_nat!
    ) (= big_i_nat! (curve25519_dalek!specs.field_specs.nat_invsqrt.? (I v_u2_sqr_nat!)))
   )
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_matches_spec.
     big_i_nat! v_u2_sqr_nat!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_matches_spec._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_matches_spec._definition
)))

;; Function-Def curve25519_dalek::lemmas::field_lemmas::sqrt_ratio_lemmas::lemma_invsqrt_matches_spec
;; curve25519-dalek/src/lemmas/field_lemmas/sqrt_ratio_lemmas.rs:1641:1: 1641:75 (#0)
(get-info :all-statistics)
(push)
 (declare-const big_i_nat! Int)
 (declare-const v_u2_sqr_nat! Int)
 (declare-const tmp%1 Int)
 (declare-const tmp%2 Int)
 (declare-const tmp%3 Int)
 (assert
  fuel_defaults
 )
 (assert
  (<= 0 big_i_nat!)
 )
 (assert
  (<= 0 v_u2_sqr_nat!)
 )
 (assert
  (= (EucMod big_i_nat! 2) 0)
 )
 (assert
  (=>
   (= v_u2_sqr_nat! 0)
   (= big_i_nat! 0)
 ))
 (assert
  (=>
   (not (= v_u2_sqr_nat! 0))
   (or
    (curve25519_dalek!specs.field_specs.is_sqrt_ratio.? (I 1) (I v_u2_sqr_nat!) (I big_i_nat!))
    (curve25519_dalek!specs.field_specs.is_sqrt_ratio_times_i.? (I 1) (I v_u2_sqr_nat!)
     (I big_i_nat!)
 ))))
 (assert
  (< big_i_nat! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
 )
 (assert
  (< v_u2_sqr_nat! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
 )
 (declare-const %%switch_label%%0 Bool)
 ;; precondition not satisfied
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
 ;; precondition not satisfied
 (declare-const %%location_label%%6 Bool)
 ;; assertion failed
 (declare-const %%location_label%%7 Bool)
 ;; postcondition not satisfied
 (declare-const %%location_label%%8 Bool)
 (assert
  (not (or
    (and
     (=>
      (not (= v_u2_sqr_nat! 0))
      (and
       (=>
        (= tmp%1 (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
        (and
         (=>
          %%location_label%%0
          (req%vstd!arithmetic.div_mod.lemma_small_mod. big_i_nat! tmp%1)
         )
         (=>
          (ens%vstd!arithmetic.div_mod.lemma_small_mod. big_i_nat! tmp%1)
          (=>
           %%location_label%%1
           (not (curve25519_dalek!specs.field_specs.is_negative.? (I big_i_nat!)))
       ))))
       (=>
        (not (curve25519_dalek!specs.field_specs.is_negative.? (I big_i_nat!)))
        (and
         (and
          (=>
           (= tmp%2 (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
           (and
            (=>
             %%location_label%%2
             (req%vstd!arithmetic.div_mod.lemma_small_mod. v_u2_sqr_nat! tmp%2)
            )
            (=>
             (ens%vstd!arithmetic.div_mod.lemma_small_mod. v_u2_sqr_nat! tmp%2)
             (=>
              %%location_label%%3
              (= (EucMod v_u2_sqr_nat! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) v_u2_sqr_nat!)
          ))))
          (=>
           (= (EucMod v_u2_sqr_nat! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) v_u2_sqr_nat!)
           (and
            (=>
             %%location_label%%4
             (req%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_unique.
              v_u2_sqr_nat! big_i_nat!
            ))
            (=>
             (ens%curve25519_dalek!lemmas.field_lemmas.sqrt_ratio_lemmas.lemma_invsqrt_unique.
              v_u2_sqr_nat! big_i_nat!
             )
             (=>
              %%location_label%%5
              (= big_i_nat! (curve25519_dalek!specs.field_specs.nat_invsqrt.? (I v_u2_sqr_nat!)))
         )))))
         (=>
          (= big_i_nat! (curve25519_dalek!specs.field_specs.nat_invsqrt.? (I v_u2_sqr_nat!)))
          %%switch_label%%0
     )))))
     (=>
      (not (not (= v_u2_sqr_nat! 0)))
      (and
       (=>
        (= tmp%3 (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
        (and
         (=>
          %%location_label%%6
          (req%vstd!arithmetic.div_mod.lemma_small_mod. 0 tmp%3)
         )
         (=>
          (ens%vstd!arithmetic.div_mod.lemma_small_mod. 0 tmp%3)
          (=>
           %%location_label%%7
           (= (EucMod 0 (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0)
       ))))
       (=>
        (= (EucMod 0 (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0)
        %%switch_label%%0
    ))))
    (and
     (not %%switch_label%%0)
     (=>
      %%location_label%%8
      (= big_i_nat! (curve25519_dalek!specs.field_specs.nat_invsqrt.? (I v_u2_sqr_nat!)))
 )))))
 (get-info :version)
 (set-option :rlimit 30000000)
 (check-sat)
 (set-option :rlimit 0)
(pop)
