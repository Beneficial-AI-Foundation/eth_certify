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

;; MODULE 'module lemmas::montgomery_curve_lemmas'
;; curve25519-dalek/src/lemmas/montgomery_curve_lemmas.rs:904:7: 904:34 (#0)

;; query spun off because: spinoff_all

;; Fuel
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_self_0. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_twice. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor.
 FuelId
)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_bound. FuelId)
(declare-const fuel%vstd!arithmetic.power2.lemma_pow2_adds. FuelId)
(declare-const fuel%vstd!arithmetic.power2.lemma_pow2_strictly_increases. FuelId)
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
(declare-const fuel%vstd!seq.axiom_seq_empty. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_new_len. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_new_index. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_push_len. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_push_index_same. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_push_index_different. FuelId)
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
(declare-const fuel%vstd!view.impl&%48.view. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.constants.APLUS2_OVER_FOUR.
 FuelId
)
(declare-const fuel%curve25519_dalek!backend.serial.u64.constants.MONTGOMERY_A. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.constants.MONTGOMERY_A_NEG.
 FuelId
)
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
(declare-const fuel%curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xdbl_projective.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xadd_projective.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xdbladd_projective.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.montgomery_curve_lemmas.local_pow2_m.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.montgomery_curve_lemmas.local_u5_nat_m.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.montgomery_curve_lemmas.local_p_m. FuelId)
(declare-const fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_valid_edwards_y_coordinate.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_identity. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_add. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_double. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.fe51_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.fe51_as_canonical_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_element_from_bytes. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_add. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_sub. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_mul. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_neg. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_square. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_inv. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.is_square. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_sqrt. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.p. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.field_canonical. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.montgomery_specs.montgomery_rhs. FuelId)
(declare-const fuel%curve25519_dalek!specs.montgomery_specs.canonical_sqrt. FuelId)
(declare-const fuel%curve25519_dalek!specs.montgomery_specs.is_valid_u_coordinate.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.montgomery_specs.canonical_montgomery_lift.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.montgomery_specs.montgomery_neg. FuelId)
(declare-const fuel%curve25519_dalek!specs.montgomery_specs.montgomery_add. FuelId)
(declare-const fuel%curve25519_dalek!specs.montgomery_specs.montgomery_sub. FuelId)
(declare-const fuel%curve25519_dalek!specs.montgomery_specs.u_coordinate. FuelId)
(declare-const fuel%curve25519_dalek!specs.montgomery_specs.is_equal_to_minus_one.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.montgomery_specs.montgomery_u_from_edwards_y.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.montgomery_specs.edwards_y_from_montgomery_u.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.montgomery_specs.projective_u_coordinate.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.montgomery_specs.projective_represents_montgomery_or_infinity.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.montgomery_specs.projective_represents_montgomery_or_infinity_nat.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.montgomery_specs.spec_x25519_basepoint_u.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.montgomery_specs.montgomery_affine_u. FuelId)
(declare-const fuel%curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul_u.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.montgomery_specs.spec_elligator_encode.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.primality_specs.is_prime. FuelId)
(declare-const fuel%curve25519_dalek!constants.X25519_BASEPOINT. FuelId)
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
 (distinct fuel%vstd!arithmetic.div_mod.lemma_mod_self_0. fuel%vstd!arithmetic.div_mod.lemma_mod_twice.
  fuel%vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor. fuel%vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish.
  fuel%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish. fuel%vstd!arithmetic.div_mod.lemma_mod_bound.
  fuel%vstd!arithmetic.power2.lemma_pow2_adds. fuel%vstd!arithmetic.power2.lemma_pow2_strictly_increases.
  fuel%vstd!array.array_view. fuel%vstd!array.impl&%0.view. fuel%vstd!array.impl&%2.spec_index.
  fuel%vstd!array.lemma_array_index. fuel%vstd!array.array_len_matches_n. fuel%vstd!array.axiom_array_ext_equal.
  fuel%vstd!array.axiom_array_has_resolved. fuel%vstd!raw_ptr.impl&%3.view. fuel%vstd!raw_ptr.ptrs_mut_eq.
  fuel%vstd!raw_ptr.ptrs_mut_eq_sized. fuel%vstd!seq.impl&%0.spec_index. fuel%vstd!seq.axiom_seq_index_decreases.
  fuel%vstd!seq.axiom_seq_empty. fuel%vstd!seq.axiom_seq_new_len. fuel%vstd!seq.axiom_seq_new_index.
  fuel%vstd!seq.axiom_seq_push_len. fuel%vstd!seq.axiom_seq_push_index_same. fuel%vstd!seq.axiom_seq_push_index_different.
  fuel%vstd!seq.axiom_seq_ext_equal. fuel%vstd!seq.axiom_seq_ext_equal_deep. fuel%vstd!slice.impl&%2.spec_index.
  fuel%vstd!slice.axiom_spec_len. fuel%vstd!slice.axiom_slice_ext_equal. fuel%vstd!slice.axiom_slice_has_resolved.
  fuel%vstd!view.impl&%0.view. fuel%vstd!view.impl&%2.view. fuel%vstd!view.impl&%4.view.
  fuel%vstd!view.impl&%6.view. fuel%vstd!view.impl&%12.view. fuel%vstd!view.impl&%14.view.
  fuel%vstd!view.impl&%16.view. fuel%vstd!view.impl&%22.view. fuel%vstd!view.impl&%26.view.
  fuel%vstd!view.impl&%44.view. fuel%vstd!view.impl&%48.view. fuel%curve25519_dalek!backend.serial.u64.constants.APLUS2_OVER_FOUR.
  fuel%curve25519_dalek!backend.serial.u64.constants.MONTGOMERY_A. fuel%curve25519_dalek!backend.serial.u64.constants.MONTGOMERY_A_NEG.
  fuel%curve25519_dalek!backend.serial.u64.constants.EDWARDS_D. fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.
  fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.
  fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.
  fuel%curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xdbl_projective. fuel%curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xadd_projective.
  fuel%curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xdbladd_projective. fuel%curve25519_dalek!lemmas.montgomery_curve_lemmas.local_pow2_m.
  fuel%curve25519_dalek!lemmas.montgomery_curve_lemmas.local_u5_nat_m. fuel%curve25519_dalek!lemmas.montgomery_curve_lemmas.local_p_m.
  fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat. fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.
  fuel%curve25519_dalek!specs.edwards_specs.is_valid_edwards_y_coordinate. fuel%curve25519_dalek!specs.edwards_specs.edwards_identity.
  fuel%curve25519_dalek!specs.edwards_specs.edwards_add. fuel%curve25519_dalek!specs.edwards_specs.edwards_double.
  fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul. fuel%curve25519_dalek!specs.field_specs.fe51_as_nat.
  fuel%curve25519_dalek!specs.field_specs.fe51_as_canonical_nat. fuel%curve25519_dalek!specs.field_specs.field_element_from_bytes.
  fuel%curve25519_dalek!specs.field_specs.field_add. fuel%curve25519_dalek!specs.field_specs.field_sub.
  fuel%curve25519_dalek!specs.field_specs.field_mul. fuel%curve25519_dalek!specs.field_specs.field_neg.
  fuel%curve25519_dalek!specs.field_specs.field_square. fuel%curve25519_dalek!specs.field_specs.field_inv.
  fuel%curve25519_dalek!specs.field_specs.is_square. fuel%curve25519_dalek!specs.field_specs.field_sqrt.
  fuel%curve25519_dalek!specs.field_specs_u64.p. fuel%curve25519_dalek!specs.field_specs_u64.field_canonical.
  fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical. fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.
  fuel%curve25519_dalek!specs.montgomery_specs.montgomery_rhs. fuel%curve25519_dalek!specs.montgomery_specs.canonical_sqrt.
  fuel%curve25519_dalek!specs.montgomery_specs.is_valid_u_coordinate. fuel%curve25519_dalek!specs.montgomery_specs.canonical_montgomery_lift.
  fuel%curve25519_dalek!specs.montgomery_specs.montgomery_neg. fuel%curve25519_dalek!specs.montgomery_specs.montgomery_add.
  fuel%curve25519_dalek!specs.montgomery_specs.montgomery_sub. fuel%curve25519_dalek!specs.montgomery_specs.u_coordinate.
  fuel%curve25519_dalek!specs.montgomery_specs.is_equal_to_minus_one. fuel%curve25519_dalek!specs.montgomery_specs.montgomery_u_from_edwards_y.
  fuel%curve25519_dalek!specs.montgomery_specs.edwards_y_from_montgomery_u. fuel%curve25519_dalek!specs.montgomery_specs.projective_u_coordinate.
  fuel%curve25519_dalek!specs.montgomery_specs.projective_represents_montgomery_or_infinity.
  fuel%curve25519_dalek!specs.montgomery_specs.projective_represents_montgomery_or_infinity_nat.
  fuel%curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul. fuel%curve25519_dalek!specs.montgomery_specs.spec_x25519_basepoint_u.
  fuel%curve25519_dalek!specs.montgomery_specs.montgomery_affine_u. fuel%curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul_u.
  fuel%curve25519_dalek!specs.montgomery_specs.spec_elligator_encode. fuel%curve25519_dalek!specs.primality_specs.is_prime.
  fuel%curve25519_dalek!constants.X25519_BASEPOINT. fuel%vstd!array.group_array_axioms.
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
   (fuel_bool_default fuel%vstd!seq.axiom_seq_empty.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_new_len.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_new_index.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_push_len.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_push_index_same.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_push_index_different.)
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
  ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. 0) (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
   0
  ) (curve25519_dalek!montgomery.MontgomeryPoint. 0) (curve25519_dalek!montgomery.ProjectivePoint.
   0
  ) (tuple%0. 0) (tuple%2. 0) (tuple%4. 0)
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
  ) ((curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Infinity) (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite
    (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite/?u Int) (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite/?v
     Int
   ))
  ) ((curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint (curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint/?0
     %%Function%%
   ))
  ) ((curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint (curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint/?U
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint/?W curve25519_dalek!backend.serial.u64.field.FieldElement51.)
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
(declare-fun curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite/u (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)
 Int
)
(declare-fun curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite/v (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)
 Int
)
(declare-fun curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint/0 (curve25519_dalek!montgomery.MontgomeryPoint.)
 %%Function%%
)
(declare-fun curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint/U (curve25519_dalek!montgomery.ProjectivePoint.)
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint/W (curve25519_dalek!montgomery.ProjectivePoint.)
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
(declare-const TYPE%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. Type)
(declare-const TYPE%curve25519_dalek!montgomery.MontgomeryPoint. Type)
(declare-const TYPE%curve25519_dalek!montgomery.ProjectivePoint. Type)
(declare-fun TYPE%tuple%2. (Dcr Type Dcr Type) Type)
(declare-fun TYPE%tuple%4. (Dcr Type Dcr Type Dcr Type Dcr Type) Type)
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
(declare-fun Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)
 Poly
)
(declare-fun %Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. (Poly)
 curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
)
(declare-fun Poly%curve25519_dalek!montgomery.MontgomeryPoint. (curve25519_dalek!montgomery.MontgomeryPoint.)
 Poly
)
(declare-fun %Poly%curve25519_dalek!montgomery.MontgomeryPoint. (Poly) curve25519_dalek!montgomery.MontgomeryPoint.)
(declare-fun Poly%curve25519_dalek!montgomery.ProjectivePoint. (curve25519_dalek!montgomery.ProjectivePoint.)
 Poly
)
(declare-fun %Poly%curve25519_dalek!montgomery.ProjectivePoint. (Poly) curve25519_dalek!montgomery.ProjectivePoint.)
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
 (forall ((x curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)) (!
   (= x (%Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
      x
   )))
   :pattern ((Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. x))
   :qid internal_curve25519_dalek__specs__montgomery_specs__MontgomeryAffine_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__specs__montgomery_specs__MontgomeryAffine_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)
    (= x (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. (%Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
       x
   ))))
   :pattern ((has_type x TYPE%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.))
   :qid internal_curve25519_dalek__specs__montgomery_specs__MontgomeryAffine_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__specs__montgomery_specs__MontgomeryAffine_unbox_axiom_definition
)))
(assert
 (has_type (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Infinity)
  TYPE%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
))
(assert
 (forall ((_u! Int) (_v! Int)) (!
   (=>
    (and
     (<= 0 _u!)
     (<= 0 _v!)
    )
    (has_type (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite
       _u! _v!
      )
     ) TYPE%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
      (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite _u! _v!)
     ) TYPE%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
   ))
   :qid internal_curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)) (!
   (= (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite/u x) (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite/?u
     x
   ))
   :pattern ((curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite/u x))
   :qid internal_curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite/u_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite/u_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)
    (<= 0 (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite/u (%Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
       x
   ))))
   :pattern ((curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite/u (%Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
      x
     )
    ) (has_type x TYPE%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)
   )
   :qid internal_curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite/u_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite/u_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)) (!
   (= (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite/v x) (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite/?v
     x
   ))
   :pattern ((curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite/v x))
   :qid internal_curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite/v_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite/v_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)
    (<= 0 (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite/v (%Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
       x
   ))))
   :pattern ((curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite/v (%Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
      x
     )
    ) (has_type x TYPE%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)
   )
   :qid internal_curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite/v_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite/v_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!montgomery.MontgomeryPoint.)) (!
   (= x (%Poly%curve25519_dalek!montgomery.MontgomeryPoint. (Poly%curve25519_dalek!montgomery.MontgomeryPoint.
      x
   )))
   :pattern ((Poly%curve25519_dalek!montgomery.MontgomeryPoint. x))
   :qid internal_curve25519_dalek__montgomery__MontgomeryPoint_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__montgomery__MontgomeryPoint_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!montgomery.MontgomeryPoint.)
    (= x (Poly%curve25519_dalek!montgomery.MontgomeryPoint. (%Poly%curve25519_dalek!montgomery.MontgomeryPoint.
       x
   ))))
   :pattern ((has_type x TYPE%curve25519_dalek!montgomery.MontgomeryPoint.))
   :qid internal_curve25519_dalek__montgomery__MontgomeryPoint_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__montgomery__MontgomeryPoint_unbox_axiom_definition
)))
(assert
 (forall ((_0! %%Function%%)) (!
   (=>
    (has_type (Poly%array%. _0!) (ARRAY $ (UINT 8) $ (CONST_INT 32)))
    (has_type (Poly%curve25519_dalek!montgomery.MontgomeryPoint. (curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint
       _0!
      )
     ) TYPE%curve25519_dalek!montgomery.MontgomeryPoint.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!montgomery.MontgomeryPoint. (curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint
       _0!
      )
     ) TYPE%curve25519_dalek!montgomery.MontgomeryPoint.
   ))
   :qid internal_curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!montgomery.MontgomeryPoint.)) (!
   (= (curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint/0 x) (curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint/?0
     x
   ))
   :pattern ((curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint/0 x))
   :qid internal_curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint/0_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint/0_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!montgomery.MontgomeryPoint.)
    (has_type (Poly%array%. (curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint/0
       (%Poly%curve25519_dalek!montgomery.MontgomeryPoint. x)
      )
     ) (ARRAY $ (UINT 8) $ (CONST_INT 32))
   ))
   :pattern ((curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint/0 (%Poly%curve25519_dalek!montgomery.MontgomeryPoint.
      x
     )
    ) (has_type x TYPE%curve25519_dalek!montgomery.MontgomeryPoint.)
   )
   :qid internal_curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint/0_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint/0_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!montgomery.ProjectivePoint.)) (!
   (= x (%Poly%curve25519_dalek!montgomery.ProjectivePoint. (Poly%curve25519_dalek!montgomery.ProjectivePoint.
      x
   )))
   :pattern ((Poly%curve25519_dalek!montgomery.ProjectivePoint. x))
   :qid internal_curve25519_dalek__montgomery__ProjectivePoint_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__montgomery__ProjectivePoint_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!montgomery.ProjectivePoint.)
    (= x (Poly%curve25519_dalek!montgomery.ProjectivePoint. (%Poly%curve25519_dalek!montgomery.ProjectivePoint.
       x
   ))))
   :pattern ((has_type x TYPE%curve25519_dalek!montgomery.ProjectivePoint.))
   :qid internal_curve25519_dalek__montgomery__ProjectivePoint_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__montgomery__ProjectivePoint_unbox_axiom_definition
)))
(assert
 (forall ((_U! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (_W! curve25519_dalek!backend.serial.u64.field.FieldElement51.))
  (!
   (=>
    (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _U!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _W!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    )
    (has_type (Poly%curve25519_dalek!montgomery.ProjectivePoint. (curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint
       _U! _W!
      )
     ) TYPE%curve25519_dalek!montgomery.ProjectivePoint.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!montgomery.ProjectivePoint. (curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint
       _U! _W!
      )
     ) TYPE%curve25519_dalek!montgomery.ProjectivePoint.
   ))
   :qid internal_curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!montgomery.ProjectivePoint.)) (!
   (= (curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint/U x) (curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint/?U
     x
   ))
   :pattern ((curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint/U x))
   :qid internal_curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint/U_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint/U_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!montgomery.ProjectivePoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint/U
       (%Poly%curve25519_dalek!montgomery.ProjectivePoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint/U (%Poly%curve25519_dalek!montgomery.ProjectivePoint.
      x
     )
    ) (has_type x TYPE%curve25519_dalek!montgomery.ProjectivePoint.)
   )
   :qid internal_curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint/U_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint/U_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!montgomery.ProjectivePoint.)) (!
   (= (curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint/W x) (curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint/?W
     x
   ))
   :pattern ((curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint/W x))
   :qid internal_curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint/W_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint/W_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!montgomery.ProjectivePoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint/W
       (%Poly%curve25519_dalek!montgomery.ProjectivePoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint/W (%Poly%curve25519_dalek!montgomery.ProjectivePoint.
      x
     )
    ) (has_type x TYPE%curve25519_dalek!montgomery.ProjectivePoint.)
   )
   :qid internal_curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint/W_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint/W_invariant_definition
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

;; Function-Decl curve25519_dalek::specs::edwards_specs::spec_ed25519_basepoint
(declare-fun curve25519_dalek!specs.edwards_specs.spec_ed25519_basepoint.? (Poly)
 tuple%2.
)

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

;; Function-Decl curve25519_dalek::backend::serial::u64::constants::APLUS2_OVER_FOUR
(declare-fun curve25519_dalek!backend.serial.u64.constants.APLUS2_OVER_FOUR.? () curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::backend::serial::u64::constants::MONTGOMERY_A
(declare-fun curve25519_dalek!backend.serial.u64.constants.MONTGOMERY_A.? () curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::backend::serial::u64::constants::MONTGOMERY_A_NEG
(declare-fun curve25519_dalek!backend.serial.u64.constants.MONTGOMERY_A_NEG.? () curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::lemmas::montgomery_curve_lemmas::spec_xdbl_projective
(declare-fun curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xdbl_projective.?
 (Poly Poly) tuple%2.
)

;; Function-Decl curve25519_dalek::lemmas::montgomery_curve_lemmas::spec_xadd_projective
(declare-fun curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xadd_projective.?
 (Poly Poly Poly Poly Poly) tuple%2.
)

;; Function-Decl curve25519_dalek::lemmas::montgomery_curve_lemmas::spec_xdbladd_projective
(declare-fun curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xdbladd_projective.?
 (Poly Poly Poly Poly Poly) tuple%4.
)

;; Function-Decl curve25519_dalek::lemmas::montgomery_curve_lemmas::local_pow2_m
(declare-fun curve25519_dalek!lemmas.montgomery_curve_lemmas.local_pow2_m.? (Poly)
 Int
)
(declare-fun curve25519_dalek!lemmas.montgomery_curve_lemmas.rec%local_pow2_m.? (Poly
  Fuel
 ) Int
)

;; Function-Decl curve25519_dalek::lemmas::montgomery_curve_lemmas::local_u5_nat_m
(declare-fun curve25519_dalek!lemmas.montgomery_curve_lemmas.local_u5_nat_m.? (Poly)
 Int
)

;; Function-Decl curve25519_dalek::lemmas::montgomery_curve_lemmas::local_p_m
(declare-fun curve25519_dalek!lemmas.montgomery_curve_lemmas.local_p_m.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_on_edwards_curve
(declare-fun curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.? (Poly Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_valid_edwards_y_coordinate
(declare-fun curve25519_dalek!specs.edwards_specs.is_valid_edwards_y_coordinate.?
 (Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::field_specs::field_element_from_bytes
(declare-fun curve25519_dalek!specs.field_specs.field_element_from_bytes.? (Poly)
 Int
)

;; Function-Decl curve25519_dalek::specs::field_specs::is_square
(declare-fun curve25519_dalek!specs.field_specs.is_square.? (Poly) Bool)

;; Function-Decl curve25519_dalek::specs::montgomery_specs::spec_elligator_encode
(declare-fun curve25519_dalek!specs.montgomery_specs.spec_elligator_encode.? (Poly)
 Int
)

;; Function-Decl curve25519_dalek::specs::montgomery_specs::edwards_y_from_montgomery_u
(declare-fun curve25519_dalek!specs.montgomery_specs.edwards_y_from_montgomery_u.?
 (Poly) Int
)

;; Function-Decl curve25519_dalek::specs::field_specs::fe51_as_nat
(declare-fun curve25519_dalek!specs.field_specs.fe51_as_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::field_sqrt
(declare-fun curve25519_dalek!specs.field_specs.field_sqrt.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::montgomery_specs::montgomery_rhs
(declare-fun curve25519_dalek!specs.montgomery_specs.montgomery_rhs.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::montgomery_specs::canonical_sqrt
(declare-fun curve25519_dalek!specs.montgomery_specs.canonical_sqrt.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::montgomery_specs::is_valid_u_coordinate
(declare-fun curve25519_dalek!specs.montgomery_specs.is_valid_u_coordinate.? (Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::montgomery_specs::canonical_montgomery_lift
(declare-fun curve25519_dalek!specs.montgomery_specs.canonical_montgomery_lift.? (
  Poly
 ) curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
)

;; Function-Decl curve25519_dalek::specs::montgomery_specs::montgomery_neg
(declare-fun curve25519_dalek!specs.montgomery_specs.montgomery_neg.? (Poly) curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)

;; Function-Decl curve25519_dalek::specs::montgomery_specs::montgomery_add
(declare-fun curve25519_dalek!specs.montgomery_specs.montgomery_add.? (Poly Poly)
 curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
)

;; Function-Decl curve25519_dalek::specs::montgomery_specs::montgomery_sub
(declare-fun curve25519_dalek!specs.montgomery_specs.montgomery_sub.? (Poly Poly)
 curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
)

;; Function-Decl curve25519_dalek::specs::montgomery_specs::u_coordinate
(declare-fun curve25519_dalek!specs.montgomery_specs.u_coordinate.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::montgomery_specs::is_equal_to_minus_one
(declare-fun curve25519_dalek!specs.montgomery_specs.is_equal_to_minus_one.? (Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::montgomery_specs::montgomery_u_from_edwards_y
(declare-fun curve25519_dalek!specs.montgomery_specs.montgomery_u_from_edwards_y.?
 (Poly) Int
)

;; Function-Decl curve25519_dalek::specs::montgomery_specs::projective_u_coordinate
(declare-fun curve25519_dalek!specs.montgomery_specs.projective_u_coordinate.? (Poly)
 Int
)

;; Function-Decl curve25519_dalek::specs::montgomery_specs::projective_represents_montgomery_or_infinity
(declare-fun curve25519_dalek!specs.montgomery_specs.projective_represents_montgomery_or_infinity.?
 (Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::montgomery_specs::projective_represents_montgomery_or_infinity_nat
(declare-fun curve25519_dalek!specs.montgomery_specs.projective_represents_montgomery_or_infinity_nat.?
 (Poly Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::montgomery_specs::montgomery_scalar_mul
(declare-fun curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul.? (Poly
  Poly
 ) curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
)
(declare-fun curve25519_dalek!specs.montgomery_specs.rec%montgomery_scalar_mul.? (
  Poly Poly Fuel
 ) curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
)

;; Function-Decl curve25519_dalek::constants::X25519_BASEPOINT
(declare-fun curve25519_dalek!constants.X25519_BASEPOINT.? () curve25519_dalek!montgomery.MontgomeryPoint.)

;; Function-Decl curve25519_dalek::specs::montgomery_specs::spec_x25519_basepoint_u
(declare-fun curve25519_dalek!specs.montgomery_specs.spec_x25519_basepoint_u.? (Poly)
 Int
)

;; Function-Decl curve25519_dalek::specs::montgomery_specs::montgomery_affine_u
(declare-fun curve25519_dalek!specs.montgomery_specs.montgomery_affine_u.? (Poly)
 Int
)

;; Function-Decl curve25519_dalek::specs::montgomery_specs::montgomery_scalar_mul_u
(declare-fun curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul_u.? (Poly
  Poly
 ) Int
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
          :qid user_vstd__seq__axiom_seq_ext_equal_7
          :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_7
    ))))))
    :pattern ((ext_eq false (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_8
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_8
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
          :qid user_vstd__seq__axiom_seq_ext_equal_deep_9
          :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_9
    ))))))
    :pattern ((ext_eq true (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_deep_10
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_10
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
    :qid user_vstd__slice__axiom_spec_len_11
    :skolemid skolem_user_vstd__slice__axiom_spec_len_11
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
          :qid user_vstd__slice__axiom_slice_ext_equal_12
          :skolemid skolem_user_vstd__slice__axiom_slice_ext_equal_12
    ))))))
    :pattern ((ext_eq false (SLICE T&. T&) a1! a2!))
    :qid user_vstd__slice__axiom_slice_ext_equal_13
    :skolemid skolem_user_vstd__slice__axiom_slice_ext_equal_13
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
    :qid user_vstd__slice__axiom_slice_has_resolved_14
    :skolemid skolem_user_vstd__slice__axiom_slice_has_resolved_14
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
    :qid user_vstd__array__array_len_matches_n_15
    :skolemid skolem_user_vstd__array__array_len_matches_n_15
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
    :qid user_vstd__array__lemma_array_index_16
    :skolemid skolem_user_vstd__array__lemma_array_index_16
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

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_self_0
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_self_0. (Int) Bool)
(declare-const %%global_location_label%%6 Bool)
(assert
 (forall ((m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_self_0. m!) (=>
     %%global_location_label%%6
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
    :qid user_vstd__arithmetic__div_mod__lemma_mod_twice_23
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_twice_23
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_division_less_than_divisor
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor. (Int
  Int
 ) Bool
)
(declare-const %%global_location_label%%8 Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor. x! m!) (=>
     %%global_location_label%%8
     (> m! 0)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor. x! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor. (Int
  Int
 ) Bool
)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor. x! m!) (let
     ((tmp%%$ (EucMod x! m!)))
     (and
      (<= 0 tmp%%$)
      (< tmp%%$ m!)
   )))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor. x! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mod_division_less_than_divisor
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor.)
  (forall ((x! Int) (m! Int)) (!
    (=>
     (> m! 0)
     (let
      ((tmp%%$ (EucMod x! m!)))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ m!)
    )))
    :pattern ((EucMod x! m!))
    :qid user_vstd__arithmetic__div_mod__lemma_mod_division_less_than_divisor_24
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_division_less_than_divisor_24
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
    :qid user_vstd__arithmetic__div_mod__lemma_mod_add_multiples_vanish_25
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_add_multiples_vanish_25
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_multiples_vanish
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish. (Int Int Int)
 Bool
)
(declare-const %%global_location_label%%10 Bool)
(assert
 (forall ((a! Int) (b! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish. a! b! m!) (=>
     %%global_location_label%%10
     (< 0 m!)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish. a! b! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mod_multiples_vanish._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mod_multiples_vanish._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish. (Int Int Int)
 Bool
)
(assert
 (forall ((a! Int) (b! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish. a! b! m!) (= (EucMod (Add
       (Mul m! a!) b!
      ) m!
     ) (EucMod b! m!)
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish. a! b! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mod_multiples_vanish._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mod_multiples_vanish._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mod_multiples_vanish
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish.)
  (forall ((a! Int) (b! Int) (m! Int)) (!
    (=>
     (< 0 m!)
     (= (EucMod (Add (Mul m! a!) b!) m!) (EucMod b! m!))
    )
    :pattern ((EucMod (Add (Mul m! a!) b!) m!))
    :qid user_vstd__arithmetic__div_mod__lemma_mod_multiples_vanish_26
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_multiples_vanish_26
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
    :qid user_vstd__arithmetic__div_mod__lemma_mod_bound_27
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_bound_27
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
    :qid user_vstd__arithmetic__power2__lemma_pow2_adds_28
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_adds_28
))))

;; Function-Specs vstd::arithmetic::power2::lemma_pow2_strictly_increases
(declare-fun req%vstd!arithmetic.power2.lemma_pow2_strictly_increases. (Int Int) Bool)
(declare-const %%global_location_label%%12 Bool)
(assert
 (forall ((e1! Int) (e2! Int)) (!
   (= (req%vstd!arithmetic.power2.lemma_pow2_strictly_increases. e1! e2!) (=>
     %%global_location_label%%12
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
    :qid user_vstd__arithmetic__power2__lemma_pow2_strictly_increases_29
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_strictly_increases_29
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

;; Function-Specs vstd::arithmetic::power2::lemma2_to64_rest
(declare-fun ens%vstd!arithmetic.power2.lemma2_to64_rest. (Int) Bool)
(assert
 (forall ((no%param Int)) (!
   (= (ens%vstd!arithmetic.power2.lemma2_to64_rest. no%param) (and
     (= (vstd!arithmetic.power2.pow2.? (I 33)) 8589934592)
     (= (vstd!arithmetic.power2.pow2.? (I 34)) 17179869184)
     (= (vstd!arithmetic.power2.pow2.? (I 35)) 34359738368)
     (= (vstd!arithmetic.power2.pow2.? (I 36)) 68719476736)
     (= (vstd!arithmetic.power2.pow2.? (I 37)) 137438953472)
     (= (vstd!arithmetic.power2.pow2.? (I 38)) 274877906944)
     (= (vstd!arithmetic.power2.pow2.? (I 39)) 549755813888)
     (= (vstd!arithmetic.power2.pow2.? (I 40)) 1099511627776)
     (= (vstd!arithmetic.power2.pow2.? (I 41)) 2199023255552)
     (= (vstd!arithmetic.power2.pow2.? (I 42)) 4398046511104)
     (= (vstd!arithmetic.power2.pow2.? (I 43)) 8796093022208)
     (= (vstd!arithmetic.power2.pow2.? (I 44)) 17592186044416)
     (= (vstd!arithmetic.power2.pow2.? (I 45)) 35184372088832)
     (= (vstd!arithmetic.power2.pow2.? (I 46)) 70368744177664)
     (= (vstd!arithmetic.power2.pow2.? (I 47)) 140737488355328)
     (= (vstd!arithmetic.power2.pow2.? (I 48)) 281474976710656)
     (= (vstd!arithmetic.power2.pow2.? (I 49)) 562949953421312)
     (= (vstd!arithmetic.power2.pow2.? (I 50)) 1125899906842624)
     (= (vstd!arithmetic.power2.pow2.? (I 51)) 2251799813685248)
     (= (vstd!arithmetic.power2.pow2.? (I 52)) 4503599627370496)
     (= (vstd!arithmetic.power2.pow2.? (I 53)) 9007199254740992)
     (= (vstd!arithmetic.power2.pow2.? (I 54)) 18014398509481984)
     (= (vstd!arithmetic.power2.pow2.? (I 55)) 36028797018963968)
     (= (vstd!arithmetic.power2.pow2.? (I 56)) 72057594037927936)
     (= (vstd!arithmetic.power2.pow2.? (I 57)) 144115188075855872)
     (= (vstd!arithmetic.power2.pow2.? (I 58)) 288230376151711744)
     (= (vstd!arithmetic.power2.pow2.? (I 59)) 576460752303423488)
     (= (vstd!arithmetic.power2.pow2.? (I 60)) 1152921504606846976)
     (= (vstd!arithmetic.power2.pow2.? (I 61)) 2305843009213693952)
     (= (vstd!arithmetic.power2.pow2.? (I 62)) 4611686018427387904)
     (= (vstd!arithmetic.power2.pow2.? (I 63)) 9223372036854775808)
     (= (vstd!arithmetic.power2.pow2.? (I 64)) 18446744073709551616)
   ))
   :pattern ((ens%vstd!arithmetic.power2.lemma2_to64_rest. no%param))
   :qid internal_ens__vstd!arithmetic.power2.lemma2_to64_rest._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.power2.lemma2_to64_rest._definition
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

;; Function-Axioms curve25519_dalek::specs::edwards_specs::spec_ed25519_basepoint
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.spec_ed25519_basepoint.?
       no%param
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.spec_ed25519_basepoint.? no%param))
   :qid internal_curve25519_dalek!specs.edwards_specs.spec_ed25519_basepoint.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.spec_ed25519_basepoint.?_pre_post_definition
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

;; Function-Axioms curve25519_dalek::backend::serial::u64::constants::APLUS2_OVER_FOUR
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.constants.APLUS2_OVER_FOUR.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.constants.APLUS2_OVER_FOUR.)
  (= curve25519_dalek!backend.serial.u64.constants.APLUS2_OVER_FOUR.? (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
    (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I 121666) (I 0) (I 0) (I 0) (I 0))))
))))
(assert
 (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.constants.APLUS2_OVER_FOUR.?)
  TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Function-Axioms curve25519_dalek::backend::serial::u64::constants::MONTGOMERY_A
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.constants.MONTGOMERY_A.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.constants.MONTGOMERY_A.)
  (= curve25519_dalek!backend.serial.u64.constants.MONTGOMERY_A.? (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
    (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I 486662) (I 0) (I 0) (I 0) (I 0))))
))))
(assert
 (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.constants.MONTGOMERY_A.?)
  TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Function-Axioms curve25519_dalek::backend::serial::u64::constants::MONTGOMERY_A_NEG
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.constants.MONTGOMERY_A_NEG.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.constants.MONTGOMERY_A_NEG.)
  (= curve25519_dalek!backend.serial.u64.constants.MONTGOMERY_A_NEG.? (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
    (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I 2251799813198567) (I 2251799813685247)
       (I 2251799813685247) (I 2251799813685247) (I 2251799813685247)
)))))))
(assert
 (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.constants.MONTGOMERY_A_NEG.?)
  TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Function-Axioms curve25519_dalek::lemmas::montgomery_curve_lemmas::spec_xdbl_projective
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xdbl_projective.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xdbl_projective.)
  (forall ((U! Poly) (W! Poly)) (!
    (= (curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xdbl_projective.? U! W!)
     (let
      ((t0$ (curve25519_dalek!specs.field_specs.field_add.? U! W!)))
      (let
       ((t1$ (curve25519_dalek!specs.field_specs.field_sub.? U! W!)))
       (let
        ((t4$ (curve25519_dalek!specs.field_specs.field_square.? (I t0$))))
        (let
         ((t5$ (curve25519_dalek!specs.field_specs.field_square.? (I t1$))))
         (let
          ((t6$ (curve25519_dalek!specs.field_specs.field_sub.? (I t4$) (I t5$))))
          (let
           ((a24$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
               curve25519_dalek!backend.serial.u64.constants.APLUS2_OVER_FOUR.?
           ))))
           (let
            ((t13$ (curve25519_dalek!specs.field_specs.field_mul.? (I a24$) (I t6$))))
            (let
             ((t15$ (curve25519_dalek!specs.field_specs.field_add.? (I t13$) (I t5$))))
             (let
              ((U2$ (curve25519_dalek!specs.field_specs.field_mul.? (I t4$) (I t5$))))
              (let
               ((W2$ (curve25519_dalek!specs.field_specs.field_mul.? (I t6$) (I t15$))))
               (tuple%2./tuple%2 (I U2$) (I W2$))
    )))))))))))
    :pattern ((curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xdbl_projective.? U!
      W!
    ))
    :qid internal_curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xdbl_projective.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xdbl_projective.?_definition
))))
(assert
 (forall ((U! Poly) (W! Poly)) (!
   (=>
    (and
     (has_type U! NAT)
     (has_type W! NAT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xdbl_projective.?
       U! W!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xdbl_projective.? U!
     W!
   ))
   :qid internal_curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xdbl_projective.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xdbl_projective.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::montgomery_curve_lemmas::spec_xadd_projective
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xadd_projective.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xadd_projective.)
  (forall ((U_P! Poly) (W_P! Poly) (U_Q! Poly) (W_Q! Poly) (affine_PmQ! Poly)) (!
    (= (curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xadd_projective.? U_P! W_P!
      U_Q! W_Q! affine_PmQ!
     ) (let
      ((t0$ (curve25519_dalek!specs.field_specs.field_add.? U_P! W_P!)))
      (let
       ((t1$ (curve25519_dalek!specs.field_specs.field_sub.? U_P! W_P!)))
       (let
        ((t2$ (curve25519_dalek!specs.field_specs.field_add.? U_Q! W_Q!)))
        (let
         ((t3$ (curve25519_dalek!specs.field_specs.field_sub.? U_Q! W_Q!)))
         (let
          ((t7$ (curve25519_dalek!specs.field_specs.field_mul.? (I t0$) (I t3$))))
          (let
           ((t8$ (curve25519_dalek!specs.field_specs.field_mul.? (I t1$) (I t2$))))
           (let
            ((t9$ (curve25519_dalek!specs.field_specs.field_add.? (I t7$) (I t8$))))
            (let
             ((t10$ (curve25519_dalek!specs.field_specs.field_sub.? (I t7$) (I t8$))))
             (let
              ((U_PpQ$ (curve25519_dalek!specs.field_specs.field_square.? (I t9$))))
              (let
               ((W_PpQ$ (curve25519_dalek!specs.field_specs.field_mul.? affine_PmQ! (I (curve25519_dalek!specs.field_specs.field_square.?
                    (I t10$)
               )))))
               (tuple%2./tuple%2 (I U_PpQ$) (I W_PpQ$))
    )))))))))))
    :pattern ((curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xadd_projective.? U_P!
      W_P! U_Q! W_Q! affine_PmQ!
    ))
    :qid internal_curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xadd_projective.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xadd_projective.?_definition
))))
(assert
 (forall ((U_P! Poly) (W_P! Poly) (U_Q! Poly) (W_Q! Poly) (affine_PmQ! Poly)) (!
   (=>
    (and
     (has_type U_P! NAT)
     (has_type W_P! NAT)
     (has_type U_Q! NAT)
     (has_type W_Q! NAT)
     (has_type affine_PmQ! NAT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xadd_projective.?
       U_P! W_P! U_Q! W_Q! affine_PmQ!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xadd_projective.? U_P!
     W_P! U_Q! W_Q! affine_PmQ!
   ))
   :qid internal_curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xadd_projective.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xadd_projective.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::montgomery_curve_lemmas::spec_xdbladd_projective
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xdbladd_projective.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xdbladd_projective.)
  (forall ((U_P! Poly) (W_P! Poly) (U_Q! Poly) (W_Q! Poly) (affine_PmQ! Poly)) (!
    (= (curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xdbladd_projective.? U_P!
      W_P! U_Q! W_Q! affine_PmQ!
     ) (let
      ((tmp%%$ (curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xdbl_projective.? U_P!
         W_P!
      )))
      (let
       ((U2$ (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$))))))
       (let
        ((W2$ (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$))))))
        (let
         ((tmp%%$1 (curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xadd_projective.? U_P!
            W_P! U_Q! W_Q! affine_PmQ!
         )))
         (let
          ((U3$ (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$1))))))
          (let
           ((W3$ (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$1))))))
           (tuple%4./tuple%4 (I U2$) (I W2$) (I U3$) (I W3$))
    )))))))
    :pattern ((curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xdbladd_projective.?
      U_P! W_P! U_Q! W_Q! affine_PmQ!
    ))
    :qid internal_curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xdbladd_projective.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xdbladd_projective.?_definition
))))
(assert
 (forall ((U_P! Poly) (W_P! Poly) (U_Q! Poly) (W_Q! Poly) (affine_PmQ! Poly)) (!
   (=>
    (and
     (has_type U_P! NAT)
     (has_type W_P! NAT)
     (has_type U_Q! NAT)
     (has_type W_Q! NAT)
     (has_type affine_PmQ! NAT)
    )
    (has_type (Poly%tuple%4. (curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xdbladd_projective.?
       U_P! W_P! U_Q! W_Q! affine_PmQ!
      )
     ) (TYPE%tuple%4. $ NAT $ NAT $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xdbladd_projective.?
     U_P! W_P! U_Q! W_Q! affine_PmQ!
   ))
   :qid internal_curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xdbladd_projective.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xdbladd_projective.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::montgomery_curve_lemmas::local_pow2_m
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.montgomery_curve_lemmas.local_pow2_m.)
)
(declare-const fuel_nat%curve25519_dalek!lemmas.montgomery_curve_lemmas.local_pow2_m.
 Fuel
)
(assert
 (forall ((n! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!lemmas.montgomery_curve_lemmas.rec%local_pow2_m.? n! fuel%) (
     curve25519_dalek!lemmas.montgomery_curve_lemmas.rec%local_pow2_m.? n! zero
   ))
   :pattern ((curve25519_dalek!lemmas.montgomery_curve_lemmas.rec%local_pow2_m.? n! fuel%))
   :qid internal_curve25519_dalek!lemmas.montgomery_curve_lemmas.local_pow2_m._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.montgomery_curve_lemmas.local_pow2_m._fuel_to_zero_definition
)))
(assert
 (forall ((n! Poly) (fuel% Fuel)) (!
   (=>
    (has_type n! NAT)
    (= (curve25519_dalek!lemmas.montgomery_curve_lemmas.rec%local_pow2_m.? n! (succ fuel%))
     (ite
      (= (%I n!) 0)
      1
      (nClip (Mul 2 (curve25519_dalek!lemmas.montgomery_curve_lemmas.rec%local_pow2_m.? (I
          (nClip (Sub (%I n!) 1))
         ) fuel%
   ))))))
   :pattern ((curve25519_dalek!lemmas.montgomery_curve_lemmas.rec%local_pow2_m.? n! (succ
      fuel%
   )))
   :qid internal_curve25519_dalek!lemmas.montgomery_curve_lemmas.local_pow2_m._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.montgomery_curve_lemmas.local_pow2_m._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.montgomery_curve_lemmas.local_pow2_m.)
  (forall ((n! Poly)) (!
    (=>
     (has_type n! NAT)
     (= (curve25519_dalek!lemmas.montgomery_curve_lemmas.local_pow2_m.? n!) (curve25519_dalek!lemmas.montgomery_curve_lemmas.rec%local_pow2_m.?
       n! (succ fuel_nat%curve25519_dalek!lemmas.montgomery_curve_lemmas.local_pow2_m.)
    )))
    :pattern ((curve25519_dalek!lemmas.montgomery_curve_lemmas.local_pow2_m.? n!))
    :qid internal_curve25519_dalek!lemmas.montgomery_curve_lemmas.local_pow2_m.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.montgomery_curve_lemmas.local_pow2_m.?_definition
))))
(assert
 (forall ((n! Poly)) (!
   (=>
    (has_type n! NAT)
    (<= 0 (curve25519_dalek!lemmas.montgomery_curve_lemmas.local_pow2_m.? n!))
   )
   :pattern ((curve25519_dalek!lemmas.montgomery_curve_lemmas.local_pow2_m.? n!))
   :qid internal_curve25519_dalek!lemmas.montgomery_curve_lemmas.local_pow2_m.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.montgomery_curve_lemmas.local_pow2_m.?_pre_post_definition
)))
(assert
 (forall ((n! Poly) (fuel% Fuel)) (!
   (=>
    (has_type n! NAT)
    (<= 0 (curve25519_dalek!lemmas.montgomery_curve_lemmas.rec%local_pow2_m.? n! fuel%))
   )
   :pattern ((curve25519_dalek!lemmas.montgomery_curve_lemmas.rec%local_pow2_m.? n! fuel%))
   :qid internal_curve25519_dalek!lemmas.montgomery_curve_lemmas.rec__local_pow2_m.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.montgomery_curve_lemmas.rec__local_pow2_m.?_pre_post_rec_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::montgomery_curve_lemmas::local_u5_nat_m
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.montgomery_curve_lemmas.local_u5_nat_m.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.montgomery_curve_lemmas.local_u5_nat_m.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!lemmas.montgomery_curve_lemmas.local_u5_nat_m.? limbs!) (nClip
      (Add (nClip (Add (nClip (Add (nClip (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
               ) (I 0)
              )
             ) (nClip (Mul (curve25519_dalek!lemmas.montgomery_curve_lemmas.local_pow2_m.? (I 51))
               (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (
                    CONST_INT 5
                   )
                  ) limbs!
                 ) (I 1)
            )))))
           ) (nClip (Mul (curve25519_dalek!lemmas.montgomery_curve_lemmas.local_pow2_m.? (I 102))
             (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (
                  CONST_INT 5
                 )
                ) limbs!
               ) (I 2)
          )))))
         ) (nClip (Mul (curve25519_dalek!lemmas.montgomery_curve_lemmas.local_pow2_m.? (I 153))
           (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (
                CONST_INT 5
               )
              ) limbs!
             ) (I 3)
        )))))
       ) (nClip (Mul (curve25519_dalek!lemmas.montgomery_curve_lemmas.local_pow2_m.? (I 204))
         (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (
              CONST_INT 5
             )
            ) limbs!
           ) (I 4)
    )))))))
    :pattern ((curve25519_dalek!lemmas.montgomery_curve_lemmas.local_u5_nat_m.? limbs!))
    :qid internal_curve25519_dalek!lemmas.montgomery_curve_lemmas.local_u5_nat_m.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.montgomery_curve_lemmas.local_u5_nat_m.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (<= 0 (curve25519_dalek!lemmas.montgomery_curve_lemmas.local_u5_nat_m.? limbs!))
   )
   :pattern ((curve25519_dalek!lemmas.montgomery_curve_lemmas.local_u5_nat_m.? limbs!))
   :qid internal_curve25519_dalek!lemmas.montgomery_curve_lemmas.local_u5_nat_m.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.montgomery_curve_lemmas.local_u5_nat_m.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::montgomery_curve_lemmas::local_p_m
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.montgomery_curve_lemmas.local_p_m.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.montgomery_curve_lemmas.local_p_m.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!lemmas.montgomery_curve_lemmas.local_p_m.? no%param) (nClip (Sub
       (curve25519_dalek!lemmas.montgomery_curve_lemmas.local_pow2_m.? (I 255)) 19
    )))
    :pattern ((curve25519_dalek!lemmas.montgomery_curve_lemmas.local_p_m.? no%param))
    :qid internal_curve25519_dalek!lemmas.montgomery_curve_lemmas.local_p_m.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.montgomery_curve_lemmas.local_p_m.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (<= 0 (curve25519_dalek!lemmas.montgomery_curve_lemmas.local_p_m.? no%param))
   )
   :pattern ((curve25519_dalek!lemmas.montgomery_curve_lemmas.local_p_m.? no%param))
   :qid internal_curve25519_dalek!lemmas.montgomery_curve_lemmas.local_p_m.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.montgomery_curve_lemmas.local_p_m.?_pre_post_definition
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

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_valid_edwards_y_coordinate
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_valid_edwards_y_coordinate.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_valid_edwards_y_coordinate.)
  (forall ((y! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_valid_edwards_y_coordinate.? y!) (let
      ((d$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?
      ))))
      (let
       ((y2$ (curve25519_dalek!specs.field_specs.field_square.? y!)))
       (let
        ((u$ (curve25519_dalek!specs.field_specs.field_sub.? (I y2$) (I 1))))
        (let
         ((v$ (curve25519_dalek!specs.field_specs.field_add.? (I (curve25519_dalek!specs.field_specs.field_mul.?
              (I d$) (I y2$)
             )
            ) (I 1)
         )))
         (=>
          (not (= (EucMod u$ (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
          (and
           (not (= (EucMod v$ (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
           (exists ((r$ Poly)) (!
             (and
              (has_type r$ NAT)
              (and
               (< (%I r$) (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
               (or
                (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_square.?
                    r$
                   )
                  ) (I v$)
                 ) (EucMod u$ (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
                )
                (= (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_square.?
                    r$
                   )
                  ) (I v$)
                 ) (curve25519_dalek!specs.field_specs.field_neg.? (I u$))
             ))))
             :pattern ((curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_square.?
                 r$
                )
               ) (I v$)
              ) (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_square.?
                 r$
                )
               ) (I v$)
             ))
             :qid user_curve25519_dalek__specs__edwards_specs__is_valid_edwards_y_coordinate_30
             :skolemid skolem_user_curve25519_dalek__specs__edwards_specs__is_valid_edwards_y_coordinate_30
    )))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_valid_edwards_y_coordinate.? y!))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_valid_edwards_y_coordinate.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_valid_edwards_y_coordinate.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs::field_element_from_bytes
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_element_from_bytes.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_element_from_bytes.)
  (forall ((bytes! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_element_from_bytes.? bytes!) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
      (I (EucMod (curve25519_dalek!specs.core_specs.u8_32_as_nat.? bytes!) (vstd!arithmetic.power2.pow2.?
         (I 255)
    )))))
    :pattern ((curve25519_dalek!specs.field_specs.field_element_from_bytes.? bytes!))
    :qid internal_curve25519_dalek!specs.field_specs.field_element_from_bytes.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_element_from_bytes.?_definition
))))
(assert
 (forall ((bytes! Poly)) (!
   (=>
    (has_type bytes! (ARRAY $ (UINT 8) $ (CONST_INT 32)))
    (<= 0 (curve25519_dalek!specs.field_specs.field_element_from_bytes.? bytes!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_element_from_bytes.? bytes!))
   :qid internal_curve25519_dalek!specs.field_specs.field_element_from_bytes.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_element_from_bytes.?_pre_post_definition
)))

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
       :qid user_curve25519_dalek__specs__field_specs__is_square_31
       :skolemid skolem_user_curve25519_dalek__specs__field_specs__is_square_31
    )))
    :pattern ((curve25519_dalek!specs.field_specs.is_square.? a!))
    :qid internal_curve25519_dalek!specs.field_specs.is_square.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.is_square.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::montgomery_specs::spec_elligator_encode
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.montgomery_specs.spec_elligator_encode.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.montgomery_specs.spec_elligator_encode.)
  (forall ((r! Poly)) (!
    (= (curve25519_dalek!specs.montgomery_specs.spec_elligator_encode.? r!) (let
      ((A$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          curve25519_dalek!backend.serial.u64.constants.MONTGOMERY_A.?
      ))))
      (let
       ((r_sq$ (curve25519_dalek!specs.field_specs.field_square.? r!)))
       (let
        ((two_r_sq$ (curve25519_dalek!specs.field_specs.field_mul.? (I 2) (I r_sq$))))
        (let
         ((d_denom$ (curve25519_dalek!specs.field_specs.field_add.? (I 1) (I two_r_sq$))))
         (let
          ((d$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_neg.?
               (I A$)
              )
             ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I d_denom$)))
          )))
          (let
           ((d_sq$ (curve25519_dalek!specs.field_specs.field_square.? (I d$))))
           (let
            ((A_d$ (curve25519_dalek!specs.field_specs.field_mul.? (I A$) (I d$))))
            (let
             ((inner$ (curve25519_dalek!specs.field_specs.field_add.? (I (curve25519_dalek!specs.field_specs.field_add.?
                  (I d_sq$) (I A_d$)
                 )
                ) (I 1)
             )))
             (let
              ((eps$ (curve25519_dalek!specs.field_specs.field_mul.? (I d$) (I inner$))))
              (let
               ((eps_is_square$ (curve25519_dalek!specs.field_specs.is_square.? (I eps$))))
               (ite
                eps_is_square$
                d$
                (curve25519_dalek!specs.field_specs.field_neg.? (I (curve25519_dalek!specs.field_specs.field_add.?
                   (I d$) (I A$)
    )))))))))))))))
    :pattern ((curve25519_dalek!specs.montgomery_specs.spec_elligator_encode.? r!))
    :qid internal_curve25519_dalek!specs.montgomery_specs.spec_elligator_encode.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.spec_elligator_encode.?_definition
))))
(assert
 (forall ((r! Poly)) (!
   (=>
    (has_type r! NAT)
    (<= 0 (curve25519_dalek!specs.montgomery_specs.spec_elligator_encode.? r!))
   )
   :pattern ((curve25519_dalek!specs.montgomery_specs.spec_elligator_encode.? r!))
   :qid internal_curve25519_dalek!specs.montgomery_specs.spec_elligator_encode.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.spec_elligator_encode.?_pre_post_definition
)))

;; Function-Specs curve25519_dalek::specs::montgomery_specs::edwards_y_from_montgomery_u
(declare-fun req%curve25519_dalek!specs.montgomery_specs.edwards_y_from_montgomery_u.
 (Poly) Bool
)
(declare-const %%global_location_label%%15 Bool)
(assert
 (forall ((u! Poly)) (!
   (= (req%curve25519_dalek!specs.montgomery_specs.edwards_y_from_montgomery_u. u!) (
     =>
     %%global_location_label%%15
     (not (= (%I u!) (curve25519_dalek!specs.field_specs.field_sub.? (I 0) (I 1))))
   ))
   :pattern ((req%curve25519_dalek!specs.montgomery_specs.edwards_y_from_montgomery_u.
     u!
   ))
   :qid internal_req__curve25519_dalek!specs.montgomery_specs.edwards_y_from_montgomery_u._definition
   :skolemid skolem_internal_req__curve25519_dalek!specs.montgomery_specs.edwards_y_from_montgomery_u._definition
)))

;; Function-Axioms curve25519_dalek::specs::montgomery_specs::edwards_y_from_montgomery_u
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.montgomery_specs.edwards_y_from_montgomery_u.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.montgomery_specs.edwards_y_from_montgomery_u.)
  (forall ((u! Poly)) (!
    (= (curve25519_dalek!specs.montgomery_specs.edwards_y_from_montgomery_u.? u!) (let
      ((denom$ (curve25519_dalek!specs.field_specs.field_add.? u! (I 1))))
      (let
       ((numerator$ (curve25519_dalek!specs.field_specs.field_sub.? u! (I 1))))
       (curve25519_dalek!specs.field_specs.field_mul.? (I numerator$) (I (curve25519_dalek!specs.field_specs.field_inv.?
          (I denom$)
    ))))))
    :pattern ((curve25519_dalek!specs.montgomery_specs.edwards_y_from_montgomery_u.? u!))
    :qid internal_curve25519_dalek!specs.montgomery_specs.edwards_y_from_montgomery_u.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.edwards_y_from_montgomery_u.?_definition
))))
(assert
 (forall ((u! Poly)) (!
   (=>
    (has_type u! NAT)
    (<= 0 (curve25519_dalek!specs.montgomery_specs.edwards_y_from_montgomery_u.? u!))
   )
   :pattern ((curve25519_dalek!specs.montgomery_specs.edwards_y_from_montgomery_u.? u!))
   :qid internal_curve25519_dalek!specs.montgomery_specs.edwards_y_from_montgomery_u.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.edwards_y_from_montgomery_u.?_pre_post_definition
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

;; Function-Specs curve25519_dalek::specs::field_specs::field_sqrt
(declare-fun req%curve25519_dalek!specs.field_specs.field_sqrt. (Poly) Bool)
(declare-const %%global_location_label%%16 Bool)
(assert
 (forall ((a! Poly)) (!
   (= (req%curve25519_dalek!specs.field_specs.field_sqrt. a!) (=>
     %%global_location_label%%16
     (curve25519_dalek!specs.field_specs.is_square.? a!)
   ))
   :pattern ((req%curve25519_dalek!specs.field_specs.field_sqrt. a!))
   :qid internal_req__curve25519_dalek!specs.field_specs.field_sqrt._definition
   :skolemid skolem_internal_req__curve25519_dalek!specs.field_specs.field_sqrt._definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::field_sqrt
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_sqrt.)
)
(declare-fun %%choose%%0 (Type Int Int) Poly)
(assert
 (forall ((%%hole%%0 Type) (%%hole%%1 Int) (%%hole%%2 Int)) (!
   (=>
    (exists ((y$ Poly)) (!
      (and
       (has_type y$ %%hole%%0)
       (and
        (< (%I y$) %%hole%%1)
        (= (curve25519_dalek!specs.field_specs.field_mul.? y$ y$) %%hole%%2)
      ))
      :pattern ((curve25519_dalek!specs.field_specs.field_mul.? y$ y$))
      :qid user_curve25519_dalek__specs__field_specs__field_sqrt_32
      :skolemid skolem_user_curve25519_dalek__specs__field_specs__field_sqrt_32
    ))
    (exists ((y$ Poly)) (!
      (and
       (and
        (has_type y$ %%hole%%0)
        (and
         (< (%I y$) %%hole%%1)
         (= (curve25519_dalek!specs.field_specs.field_mul.? y$ y$) %%hole%%2)
       ))
       (= (%%choose%%0 %%hole%%0 %%hole%%1 %%hole%%2) y$)
      )
      :pattern ((curve25519_dalek!specs.field_specs.field_mul.? y$ y$))
   )))
   :pattern ((%%choose%%0 %%hole%%0 %%hole%%1 %%hole%%2))
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_sqrt.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_sqrt.? a!) (%I (as_type (%%choose%%0 NAT
        (curve25519_dalek!specs.field_specs_u64.p.? (I 0)) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
         a!
        )
       ) NAT
    )))
    :pattern ((curve25519_dalek!specs.field_specs.field_sqrt.? a!))
    :qid internal_curve25519_dalek!specs.field_specs.field_sqrt.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_sqrt.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! NAT)
    (<= 0 (curve25519_dalek!specs.field_specs.field_sqrt.? a!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_sqrt.? a!))
   :qid internal_curve25519_dalek!specs.field_specs.field_sqrt.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_sqrt.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::montgomery_specs::montgomery_rhs
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.montgomery_specs.montgomery_rhs.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.montgomery_specs.montgomery_rhs.)
  (forall ((u! Poly)) (!
    (= (curve25519_dalek!specs.montgomery_specs.montgomery_rhs.? u!) (let
      ((A$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          curve25519_dalek!backend.serial.u64.constants.MONTGOMERY_A.?
      ))))
      (let
       ((u2$ (curve25519_dalek!specs.field_specs.field_mul.? u! u!)))
       (let
        ((u3$ (curve25519_dalek!specs.field_specs.field_mul.? (I u2$) u!)))
        (let
         ((Au2$ (curve25519_dalek!specs.field_specs.field_mul.? (I A$) (I u2$))))
         (curve25519_dalek!specs.field_specs.field_add.? (I (curve25519_dalek!specs.field_specs.field_add.?
            (I u3$) (I Au2$)
           )
          ) u!
    ))))))
    :pattern ((curve25519_dalek!specs.montgomery_specs.montgomery_rhs.? u!))
    :qid internal_curve25519_dalek!specs.montgomery_specs.montgomery_rhs.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.montgomery_rhs.?_definition
))))
(assert
 (forall ((u! Poly)) (!
   (=>
    (has_type u! NAT)
    (<= 0 (curve25519_dalek!specs.montgomery_specs.montgomery_rhs.? u!))
   )
   :pattern ((curve25519_dalek!specs.montgomery_specs.montgomery_rhs.? u!))
   :qid internal_curve25519_dalek!specs.montgomery_specs.montgomery_rhs.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.montgomery_rhs.?_pre_post_definition
)))

;; Function-Specs curve25519_dalek::specs::montgomery_specs::canonical_sqrt
(declare-fun req%curve25519_dalek!specs.montgomery_specs.canonical_sqrt. (Poly) Bool)
(declare-const %%global_location_label%%17 Bool)
(assert
 (forall ((r! Poly)) (!
   (= (req%curve25519_dalek!specs.montgomery_specs.canonical_sqrt. r!) (=>
     %%global_location_label%%17
     (curve25519_dalek!specs.field_specs.is_square.? r!)
   ))
   :pattern ((req%curve25519_dalek!specs.montgomery_specs.canonical_sqrt. r!))
   :qid internal_req__curve25519_dalek!specs.montgomery_specs.canonical_sqrt._definition
   :skolemid skolem_internal_req__curve25519_dalek!specs.montgomery_specs.canonical_sqrt._definition
)))

;; Function-Axioms curve25519_dalek::specs::montgomery_specs::canonical_sqrt
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.montgomery_specs.canonical_sqrt.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.montgomery_specs.canonical_sqrt.)
  (forall ((r! Poly)) (!
    (= (curve25519_dalek!specs.montgomery_specs.canonical_sqrt.? r!) (let
      ((s1$ (curve25519_dalek!specs.field_specs.field_sqrt.? r!)))
      (let
       ((s2$ (curve25519_dalek!specs.field_specs.field_neg.? (I s1$))))
       (ite
        (= (EucMod s1$ 2) 0)
        s1$
        s2$
    ))))
    :pattern ((curve25519_dalek!specs.montgomery_specs.canonical_sqrt.? r!))
    :qid internal_curve25519_dalek!specs.montgomery_specs.canonical_sqrt.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.canonical_sqrt.?_definition
))))
(assert
 (forall ((r! Poly)) (!
   (=>
    (has_type r! NAT)
    (<= 0 (curve25519_dalek!specs.montgomery_specs.canonical_sqrt.? r!))
   )
   :pattern ((curve25519_dalek!specs.montgomery_specs.canonical_sqrt.? r!))
   :qid internal_curve25519_dalek!specs.montgomery_specs.canonical_sqrt.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.canonical_sqrt.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::montgomery_specs::is_valid_u_coordinate
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.montgomery_specs.is_valid_u_coordinate.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.montgomery_specs.is_valid_u_coordinate.)
  (forall ((u! Poly)) (!
    (= (curve25519_dalek!specs.montgomery_specs.is_valid_u_coordinate.? u!) (curve25519_dalek!specs.field_specs.is_square.?
      (I (curve25519_dalek!specs.montgomery_specs.montgomery_rhs.? u!))
    ))
    :pattern ((curve25519_dalek!specs.montgomery_specs.is_valid_u_coordinate.? u!))
    :qid internal_curve25519_dalek!specs.montgomery_specs.is_valid_u_coordinate.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.is_valid_u_coordinate.?_definition
))))

;; Function-Specs curve25519_dalek::specs::montgomery_specs::canonical_montgomery_lift
(declare-fun req%curve25519_dalek!specs.montgomery_specs.canonical_montgomery_lift.
 (Poly) Bool
)
(declare-const %%global_location_label%%18 Bool)
(assert
 (forall ((u! Poly)) (!
   (= (req%curve25519_dalek!specs.montgomery_specs.canonical_montgomery_lift. u!) (=>
     %%global_location_label%%18
     (curve25519_dalek!specs.montgomery_specs.is_valid_u_coordinate.? u!)
   ))
   :pattern ((req%curve25519_dalek!specs.montgomery_specs.canonical_montgomery_lift. u!))
   :qid internal_req__curve25519_dalek!specs.montgomery_specs.canonical_montgomery_lift._definition
   :skolemid skolem_internal_req__curve25519_dalek!specs.montgomery_specs.canonical_montgomery_lift._definition
)))

;; Function-Axioms curve25519_dalek::specs::montgomery_specs::canonical_montgomery_lift
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.montgomery_specs.canonical_montgomery_lift.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.montgomery_specs.canonical_montgomery_lift.)
  (forall ((u! Poly)) (!
    (= (curve25519_dalek!specs.montgomery_specs.canonical_montgomery_lift.? u!) (let
      ((v$ (curve25519_dalek!specs.montgomery_specs.canonical_sqrt.? (I (curve25519_dalek!specs.montgomery_specs.montgomery_rhs.?
           u!
      )))))
      (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite (%I (I (EucMod (%I u!)
          (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
        ))
       ) (%I (I v$))
    )))
    :pattern ((curve25519_dalek!specs.montgomery_specs.canonical_montgomery_lift.? u!))
    :qid internal_curve25519_dalek!specs.montgomery_specs.canonical_montgomery_lift.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.canonical_montgomery_lift.?_definition
))))
(assert
 (forall ((u! Poly)) (!
   (=>
    (has_type u! NAT)
    (has_type (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. (curve25519_dalek!specs.montgomery_specs.canonical_montgomery_lift.?
       u!
      )
     ) TYPE%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
   ))
   :pattern ((curve25519_dalek!specs.montgomery_specs.canonical_montgomery_lift.? u!))
   :qid internal_curve25519_dalek!specs.montgomery_specs.canonical_montgomery_lift.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.canonical_montgomery_lift.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::montgomery_specs::montgomery_neg
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.montgomery_specs.montgomery_neg.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.montgomery_specs.montgomery_neg.)
  (forall ((P! Poly)) (!
    (= (curve25519_dalek!specs.montgomery_specs.montgomery_neg.? P!) (ite
      (is-curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Infinity (%Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
        P!
      ))
      curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Infinity
      (let
       ((u$ (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite/u (%Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
           P!
       ))))
       (let
        ((v$ (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite/v (%Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
            P!
        ))))
        (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite (%I (I u$)) (%I (
           I (curve25519_dalek!specs.field_specs.field_neg.? (I v$))
    )))))))
    :pattern ((curve25519_dalek!specs.montgomery_specs.montgomery_neg.? P!))
    :qid internal_curve25519_dalek!specs.montgomery_specs.montgomery_neg.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.montgomery_neg.?_definition
))))
(assert
 (forall ((P! Poly)) (!
   (=>
    (has_type P! TYPE%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)
    (has_type (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. (curve25519_dalek!specs.montgomery_specs.montgomery_neg.?
       P!
      )
     ) TYPE%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
   ))
   :pattern ((curve25519_dalek!specs.montgomery_specs.montgomery_neg.? P!))
   :qid internal_curve25519_dalek!specs.montgomery_specs.montgomery_neg.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.montgomery_neg.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::montgomery_specs::montgomery_add
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.montgomery_specs.montgomery_add.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.montgomery_specs.montgomery_add.)
  (forall ((P! Poly) (Q! Poly)) (!
    (= (curve25519_dalek!specs.montgomery_specs.montgomery_add.? P! Q!) (let
      ((tmp%%$ (tuple%2./tuple%2 P! Q!)))
      (ite
       (and
        (is-tuple%2./tuple%2 tmp%%$)
        (is-curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Infinity (%Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
          (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$)))
       )))
       (%Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. Q!)
       (ite
        (and
         (is-tuple%2./tuple%2 tmp%%$)
         (is-curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Infinity (%Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
           (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$)))
        )))
        (%Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. P!)
        (let
         ((u1$ (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite/u (%Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
             (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$)))
         ))))
         (let
          ((v1$ (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite/v (%Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
              (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$)))
          ))))
          (let
           ((u2$ (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite/u (%Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
               (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$)))
           ))))
           (let
            ((v2$ (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite/v (%Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
                (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$)))
            ))))
            (let
             ((A$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                 curve25519_dalek!backend.serial.u64.constants.MONTGOMERY_A.?
             ))))
             (ite
              (and
               (= u1$ u2$)
               (= (curve25519_dalek!specs.field_specs.field_add.? (I v1$) (I v2$)) 0)
              )
              curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Infinity
              (ite
               (and
                (= u1$ u2$)
                (= v1$ v2$)
               )
               (let
                ((u1_sq$ (curve25519_dalek!specs.field_specs.field_square.? (I u1$))))
                (let
                 ((numerator$ (curve25519_dalek!specs.field_specs.field_add.? (I (curve25519_dalek!specs.field_specs.field_add.?
                      (I (curve25519_dalek!specs.field_specs.field_mul.? (I 3) (I u1_sq$))) (I (curve25519_dalek!specs.field_specs.field_mul.?
                        (I (curve25519_dalek!specs.field_specs.field_mul.? (I 2) (I A$))) (I u1$)
                     )))
                    ) (I 1)
                 )))
                 (let
                  ((denominator$ (curve25519_dalek!specs.field_specs.field_mul.? (I 2) (I v1$))))
                  (let
                   ((lambda$ (curve25519_dalek!specs.field_specs.field_mul.? (I numerator$) (I (curve25519_dalek!specs.field_specs.field_inv.?
                        (I denominator$)
                   )))))
                   (let
                    ((lambda_sq$ (curve25519_dalek!specs.field_specs.field_square.? (I lambda$))))
                    (let
                     ((u3$ (curve25519_dalek!specs.field_specs.field_sub.? (I (curve25519_dalek!specs.field_specs.field_sub.?
                          (I lambda_sq$) (I A$)
                         )
                        ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I 2) (I u1$)))
                     )))
                     (let
                      ((v3$ (curve25519_dalek!specs.field_specs.field_sub.? (I (curve25519_dalek!specs.field_specs.field_mul.?
                           (I lambda$) (I (curve25519_dalek!specs.field_specs.field_sub.? (I u1$) (I u3$)))
                          )
                         ) (I v1$)
                      )))
                      (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite (%I (I u3$)) (%I
                        (I v3$)
               )))))))))
               (let
                ((numerator$ (curve25519_dalek!specs.field_specs.field_sub.? (I v2$) (I v1$))))
                (let
                 ((denominator$ (curve25519_dalek!specs.field_specs.field_sub.? (I u2$) (I u1$))))
                 (let
                  ((lambda$ (curve25519_dalek!specs.field_specs.field_mul.? (I numerator$) (I (curve25519_dalek!specs.field_specs.field_inv.?
                       (I denominator$)
                  )))))
                  (let
                   ((lambda_sq$ (curve25519_dalek!specs.field_specs.field_square.? (I lambda$))))
                   (let
                    ((u3$ (curve25519_dalek!specs.field_specs.field_sub.? (I (curve25519_dalek!specs.field_specs.field_sub.?
                         (I (curve25519_dalek!specs.field_specs.field_sub.? (I lambda_sq$) (I A$))) (I u1$)
                        )
                       ) (I u2$)
                    )))
                    (let
                     ((v3$ (curve25519_dalek!specs.field_specs.field_sub.? (I (curve25519_dalek!specs.field_specs.field_mul.?
                          (I lambda$) (I (curve25519_dalek!specs.field_specs.field_sub.? (I u1$) (I u3$)))
                         )
                        ) (I v1$)
                     )))
                     (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite (%I (I u3$)) (%I
                       (I v3$)
    )))))))))))))))))))
    :pattern ((curve25519_dalek!specs.montgomery_specs.montgomery_add.? P! Q!))
    :qid internal_curve25519_dalek!specs.montgomery_specs.montgomery_add.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.montgomery_add.?_definition
))))
(assert
 (forall ((P! Poly) (Q! Poly)) (!
   (=>
    (and
     (has_type P! TYPE%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)
     (has_type Q! TYPE%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)
    )
    (has_type (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. (curve25519_dalek!specs.montgomery_specs.montgomery_add.?
       P! Q!
      )
     ) TYPE%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
   ))
   :pattern ((curve25519_dalek!specs.montgomery_specs.montgomery_add.? P! Q!))
   :qid internal_curve25519_dalek!specs.montgomery_specs.montgomery_add.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.montgomery_add.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::montgomery_specs::montgomery_sub
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.montgomery_specs.montgomery_sub.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.montgomery_specs.montgomery_sub.)
  (forall ((P! Poly) (Q! Poly)) (!
    (= (curve25519_dalek!specs.montgomery_specs.montgomery_sub.? P! Q!) (curve25519_dalek!specs.montgomery_specs.montgomery_add.?
      P! (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. (curve25519_dalek!specs.montgomery_specs.montgomery_neg.?
        Q!
    ))))
    :pattern ((curve25519_dalek!specs.montgomery_specs.montgomery_sub.? P! Q!))
    :qid internal_curve25519_dalek!specs.montgomery_specs.montgomery_sub.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.montgomery_sub.?_definition
))))
(assert
 (forall ((P! Poly) (Q! Poly)) (!
   (=>
    (and
     (has_type P! TYPE%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)
     (has_type Q! TYPE%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)
    )
    (has_type (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. (curve25519_dalek!specs.montgomery_specs.montgomery_sub.?
       P! Q!
      )
     ) TYPE%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
   ))
   :pattern ((curve25519_dalek!specs.montgomery_specs.montgomery_sub.? P! Q!))
   :qid internal_curve25519_dalek!specs.montgomery_specs.montgomery_sub.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.montgomery_sub.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::montgomery_specs::u_coordinate
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.montgomery_specs.u_coordinate.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.montgomery_specs.u_coordinate.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.montgomery_specs.u_coordinate.? point!) (ite
      (is-curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Infinity (%Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
        point!
      ))
      0
      (let
       ((u$ (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite/u (%Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
           point!
       ))))
       u$
    )))
    :pattern ((curve25519_dalek!specs.montgomery_specs.u_coordinate.? point!))
    :qid internal_curve25519_dalek!specs.montgomery_specs.u_coordinate.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.u_coordinate.?_definition
))))
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)
    (<= 0 (curve25519_dalek!specs.montgomery_specs.u_coordinate.? point!))
   )
   :pattern ((curve25519_dalek!specs.montgomery_specs.u_coordinate.? point!))
   :qid internal_curve25519_dalek!specs.montgomery_specs.u_coordinate.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.u_coordinate.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::montgomery_specs::is_equal_to_minus_one
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.montgomery_specs.is_equal_to_minus_one.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.montgomery_specs.is_equal_to_minus_one.)
  (forall ((u! Poly)) (!
    (= (curve25519_dalek!specs.montgomery_specs.is_equal_to_minus_one.? u!) (= (%I u!)
      (curve25519_dalek!specs.field_specs.field_sub.? (I 0) (I 1))
    ))
    :pattern ((curve25519_dalek!specs.montgomery_specs.is_equal_to_minus_one.? u!))
    :qid internal_curve25519_dalek!specs.montgomery_specs.is_equal_to_minus_one.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.is_equal_to_minus_one.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::montgomery_specs::montgomery_u_from_edwards_y
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.montgomery_specs.montgomery_u_from_edwards_y.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.montgomery_specs.montgomery_u_from_edwards_y.)
  (forall ((y! Poly)) (!
    (= (curve25519_dalek!specs.montgomery_specs.montgomery_u_from_edwards_y.? y!) (let
      ((denom$ (curve25519_dalek!specs.field_specs.field_sub.? (I 1) y!)))
      (ite
       (= denom$ 0)
       0
       (let
        ((numerator$ (curve25519_dalek!specs.field_specs.field_add.? (I 1) y!)))
        (curve25519_dalek!specs.field_specs.field_mul.? (I numerator$) (I (curve25519_dalek!specs.field_specs.field_inv.?
           (I denom$)
    )))))))
    :pattern ((curve25519_dalek!specs.montgomery_specs.montgomery_u_from_edwards_y.? y!))
    :qid internal_curve25519_dalek!specs.montgomery_specs.montgomery_u_from_edwards_y.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.montgomery_u_from_edwards_y.?_definition
))))
(assert
 (forall ((y! Poly)) (!
   (=>
    (has_type y! NAT)
    (<= 0 (curve25519_dalek!specs.montgomery_specs.montgomery_u_from_edwards_y.? y!))
   )
   :pattern ((curve25519_dalek!specs.montgomery_specs.montgomery_u_from_edwards_y.? y!))
   :qid internal_curve25519_dalek!specs.montgomery_specs.montgomery_u_from_edwards_y.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.montgomery_u_from_edwards_y.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::montgomery_specs::projective_u_coordinate
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.montgomery_specs.projective_u_coordinate.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.montgomery_specs.projective_u_coordinate.)
  (forall ((P! Poly)) (!
    (= (curve25519_dalek!specs.montgomery_specs.projective_u_coordinate.? P!) (let
      ((U$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint/U (%Poly%curve25519_dalek!montgomery.ProjectivePoint.
            P!
      ))))))
      (let
       ((W$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint/W (%Poly%curve25519_dalek!montgomery.ProjectivePoint.
             P!
       ))))))
       (ite
        (= W$ 0)
        0
        (curve25519_dalek!specs.field_specs.field_mul.? (I U$) (I (curve25519_dalek!specs.field_specs.field_inv.?
           (I W$)
    )))))))
    :pattern ((curve25519_dalek!specs.montgomery_specs.projective_u_coordinate.? P!))
    :qid internal_curve25519_dalek!specs.montgomery_specs.projective_u_coordinate.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.projective_u_coordinate.?_definition
))))
(assert
 (forall ((P! Poly)) (!
   (=>
    (has_type P! TYPE%curve25519_dalek!montgomery.ProjectivePoint.)
    (<= 0 (curve25519_dalek!specs.montgomery_specs.projective_u_coordinate.? P!))
   )
   :pattern ((curve25519_dalek!specs.montgomery_specs.projective_u_coordinate.? P!))
   :qid internal_curve25519_dalek!specs.montgomery_specs.projective_u_coordinate.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.projective_u_coordinate.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::montgomery_specs::projective_represents_montgomery_or_infinity
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.montgomery_specs.projective_represents_montgomery_or_infinity.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.montgomery_specs.projective_represents_montgomery_or_infinity.)
  (forall ((P_proj! Poly) (P_aff! Poly)) (!
    (= (curve25519_dalek!specs.montgomery_specs.projective_represents_montgomery_or_infinity.?
      P_proj! P_aff!
     ) (ite
      (is-curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Infinity (%Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
        P_aff!
      ))
      (and
       (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint/W (%Poly%curve25519_dalek!montgomery.ProjectivePoint.
            P_proj!
         )))
        ) 0
       )
       (not (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint/U (%Poly%curve25519_dalek!montgomery.ProjectivePoint.
             P_proj!
          )))
         ) 0
      )))
      (let
       ((u$ (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite/u (%Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
           P_aff!
       ))))
       (let
        ((W$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
            (curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint/W (%Poly%curve25519_dalek!montgomery.ProjectivePoint.
              P_proj!
        ))))))
        (let
         ((U$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             (curve25519_dalek!montgomery.ProjectivePoint./ProjectivePoint/U (%Poly%curve25519_dalek!montgomery.ProjectivePoint.
               P_proj!
         ))))))
         (and
          (not (= W$ 0))
          (= U$ (curve25519_dalek!specs.field_specs.field_mul.? (I u$) (I W$)))
    ))))))
    :pattern ((curve25519_dalek!specs.montgomery_specs.projective_represents_montgomery_or_infinity.?
      P_proj! P_aff!
    ))
    :qid internal_curve25519_dalek!specs.montgomery_specs.projective_represents_montgomery_or_infinity.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.projective_represents_montgomery_or_infinity.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::montgomery_specs::projective_represents_montgomery_or_infinity_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.montgomery_specs.projective_represents_montgomery_or_infinity_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.montgomery_specs.projective_represents_montgomery_or_infinity_nat.)
  (forall ((U! Poly) (W! Poly) (P_aff! Poly)) (!
    (= (curve25519_dalek!specs.montgomery_specs.projective_represents_montgomery_or_infinity_nat.?
      U! W! P_aff!
     ) (ite
      (is-curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Infinity (%Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
        P_aff!
      ))
      (and
       (= (%I W!) 0)
       (not (= (%I U!) 0))
      )
      (let
       ((u$ (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite/u (%Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
           P_aff!
       ))))
       (and
        (not (= (%I W!) 0))
        (= (%I U!) (curve25519_dalek!specs.field_specs.field_mul.? (I u$) W!))
    ))))
    :pattern ((curve25519_dalek!specs.montgomery_specs.projective_represents_montgomery_or_infinity_nat.?
      U! W! P_aff!
    ))
    :qid internal_curve25519_dalek!specs.montgomery_specs.projective_represents_montgomery_or_infinity_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.projective_represents_montgomery_or_infinity_nat.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::montgomery_specs::montgomery_scalar_mul
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul.)
)
(declare-const fuel_nat%curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul.
 Fuel
)
(assert
 (forall ((P! Poly) (n! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!specs.montgomery_specs.rec%montgomery_scalar_mul.? P! n! fuel%)
    (curve25519_dalek!specs.montgomery_specs.rec%montgomery_scalar_mul.? P! n! zero)
   )
   :pattern ((curve25519_dalek!specs.montgomery_specs.rec%montgomery_scalar_mul.? P! n!
     fuel%
   ))
   :qid internal_curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul._fuel_to_zero_definition
)))
(assert
 (forall ((P! Poly) (n! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type P! TYPE%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)
     (has_type n! NAT)
    )
    (= (curve25519_dalek!specs.montgomery_specs.rec%montgomery_scalar_mul.? P! n! (succ
       fuel%
      )
     ) (ite
      (= (%I n!) 0)
      curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Infinity
      (curve25519_dalek!specs.montgomery_specs.montgomery_add.? P! (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
        (curve25519_dalek!specs.montgomery_specs.rec%montgomery_scalar_mul.? P! (I (nClip (Sub
            (%I n!) 1
          ))
         ) fuel%
   ))))))
   :pattern ((curve25519_dalek!specs.montgomery_specs.rec%montgomery_scalar_mul.? P! n!
     (succ fuel%)
   ))
   :qid internal_curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul.)
  (forall ((P! Poly) (n! Poly)) (!
    (=>
     (and
      (has_type P! TYPE%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)
      (has_type n! NAT)
     )
     (= (curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul.? P! n!) (curve25519_dalek!specs.montgomery_specs.rec%montgomery_scalar_mul.?
       P! n! (succ fuel_nat%curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul.)
    )))
    :pattern ((curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul.? P! n!))
    :qid internal_curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul.?_definition
))))
(assert
 (forall ((P! Poly) (n! Poly)) (!
   (=>
    (and
     (has_type P! TYPE%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)
     (has_type n! NAT)
    )
    (has_type (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. (curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul.?
       P! n!
      )
     ) TYPE%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
   ))
   :pattern ((curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul.? P! n!))
   :qid internal_curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul.?_pre_post_definition
)))
(assert
 (forall ((P! Poly) (n! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type P! TYPE%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)
     (has_type n! NAT)
    )
    (has_type (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. (curve25519_dalek!specs.montgomery_specs.rec%montgomery_scalar_mul.?
       P! n! fuel%
      )
     ) TYPE%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
   ))
   :pattern ((curve25519_dalek!specs.montgomery_specs.rec%montgomery_scalar_mul.? P! n!
     fuel%
   ))
   :qid internal_curve25519_dalek!specs.montgomery_specs.rec__montgomery_scalar_mul.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.rec__montgomery_scalar_mul.?_pre_post_rec_definition
)))

;; Function-Axioms curve25519_dalek::constants::X25519_BASEPOINT
(assert
 (fuel_bool_default fuel%curve25519_dalek!constants.X25519_BASEPOINT.)
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
  (fuel_bool fuel%curve25519_dalek!constants.X25519_BASEPOINT.)
  (= curve25519_dalek!constants.X25519_BASEPOINT.? (curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint
    (%Poly%array%. (array_new $ (UINT 8) 32 (%%array%%1 (I 9) (I 0) (I 0) (I 0) (I 0) (I
        0
       ) (I 0) (I 0) (I 0) (I 0) (I 0) (I 0) (I 0) (I 0) (I 0) (I 0) (I 0) (I 0) (I 0) (
        I 0
       ) (I 0) (I 0) (I 0) (I 0) (I 0) (I 0) (I 0) (I 0) (I 0) (I 0) (I 0) (I 0)
)))))))
(assert
 (has_type (Poly%curve25519_dalek!montgomery.MontgomeryPoint. curve25519_dalek!constants.X25519_BASEPOINT.?)
  TYPE%curve25519_dalek!montgomery.MontgomeryPoint.
))

;; Function-Axioms curve25519_dalek::specs::montgomery_specs::spec_x25519_basepoint_u
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.montgomery_specs.spec_x25519_basepoint_u.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.montgomery_specs.spec_x25519_basepoint_u.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!specs.montgomery_specs.spec_x25519_basepoint_u.? no%param) (curve25519_dalek!specs.field_specs.field_element_from_bytes.?
      (Poly%array%. (curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint/0 (%Poly%curve25519_dalek!montgomery.MontgomeryPoint.
         (Poly%curve25519_dalek!montgomery.MontgomeryPoint. curve25519_dalek!constants.X25519_BASEPOINT.?)
    )))))
    :pattern ((curve25519_dalek!specs.montgomery_specs.spec_x25519_basepoint_u.? no%param))
    :qid internal_curve25519_dalek!specs.montgomery_specs.spec_x25519_basepoint_u.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.spec_x25519_basepoint_u.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (<= 0 (curve25519_dalek!specs.montgomery_specs.spec_x25519_basepoint_u.? no%param))
   )
   :pattern ((curve25519_dalek!specs.montgomery_specs.spec_x25519_basepoint_u.? no%param))
   :qid internal_curve25519_dalek!specs.montgomery_specs.spec_x25519_basepoint_u.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.spec_x25519_basepoint_u.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::montgomery_specs::montgomery_affine_u
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.montgomery_specs.montgomery_affine_u.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.montgomery_specs.montgomery_affine_u.)
  (forall ((P! Poly)) (!
    (= (curve25519_dalek!specs.montgomery_specs.montgomery_affine_u.? P!) (ite
      (is-curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Infinity (%Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
        P!
      ))
      0
      (let
       ((u$ (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite/u (%Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
           P!
       ))))
       u$
    )))
    :pattern ((curve25519_dalek!specs.montgomery_specs.montgomery_affine_u.? P!))
    :qid internal_curve25519_dalek!specs.montgomery_specs.montgomery_affine_u.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.montgomery_affine_u.?_definition
))))
(assert
 (forall ((P! Poly)) (!
   (=>
    (has_type P! TYPE%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)
    (<= 0 (curve25519_dalek!specs.montgomery_specs.montgomery_affine_u.? P!))
   )
   :pattern ((curve25519_dalek!specs.montgomery_specs.montgomery_affine_u.? P!))
   :qid internal_curve25519_dalek!specs.montgomery_specs.montgomery_affine_u.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.montgomery_affine_u.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::montgomery_specs::montgomery_scalar_mul_u
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul_u.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul_u.)
  (forall ((u! Poly) (n! Poly)) (!
    (= (curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul_u.? u! n!) (curve25519_dalek!specs.montgomery_specs.montgomery_affine_u.?
      (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. (curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul.?
        (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite
          (%I u!) (%I (I (curve25519_dalek!specs.montgomery_specs.canonical_sqrt.? (I (curve25519_dalek!specs.montgomery_specs.montgomery_rhs.?
               u!
         ))))))
        ) n!
    ))))
    :pattern ((curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul_u.? u! n!))
    :qid internal_curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul_u.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul_u.?_definition
))))
(assert
 (forall ((u! Poly) (n! Poly)) (!
   (=>
    (and
     (has_type u! NAT)
     (has_type n! NAT)
    )
    (<= 0 (curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul_u.? u! n!))
   )
   :pattern ((curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul_u.? u! n!))
   :qid internal_curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul_u.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul_u.?_pre_post_definition
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
        :qid user_curve25519_dalek__specs__primality_specs__is_prime_33
        :skolemid skolem_user_curve25519_dalek__specs__primality_specs__is_prime_33
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
(declare-const %%global_location_label%%19 Bool)
(assert
 (forall ((a! Int)) (!
   (= (req%curve25519_dalek!specs.field_specs.field_inv_property. a!) (=>
     %%global_location_label%%19
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
(declare-const %%global_location_label%%20 Bool)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_mul_zero_left.
     a! b!
    ) (=>
     %%global_location_label%%20
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
(declare-const %%global_location_label%%21 Bool)
(assert
 (forall ((a! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_inv_mul_cancel.
     a!
    ) (=>
     %%global_location_label%%21
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

;; Function-Specs curve25519_dalek::lemmas::montgomery_curve_lemmas::lemma_xdbl_degenerate_gives_w_zero
(declare-fun req%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_xdbl_degenerate_gives_w_zero.
 (Int Int) Bool
)
(declare-const %%global_location_label%%22 Bool)
(assert
 (forall ((U! Int) (W! Int)) (!
   (= (req%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_xdbl_degenerate_gives_w_zero.
     U! W!
    ) (=>
     %%global_location_label%%22
     (or
      (= U! 0)
      (= W! 0)
   )))
   :pattern ((req%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_xdbl_degenerate_gives_w_zero.
     U! W!
   ))
   :qid internal_req__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_xdbl_degenerate_gives_w_zero._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_xdbl_degenerate_gives_w_zero._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_xdbl_degenerate_gives_w_zero.
 (Int Int) Bool
)
(assert
 (forall ((U! Int) (W! Int)) (!
   (= (ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_xdbl_degenerate_gives_w_zero.
     U! W!
    ) (let
     ((tmp%%$ (curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xdbl_projective.? (I U!)
        (I W!)
     )))
     (let
      ((W2$ (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$))))))
      (= W2$ 0)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_xdbl_degenerate_gives_w_zero.
     U! W!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_xdbl_degenerate_gives_w_zero._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_xdbl_degenerate_gives_w_zero._definition
)))

;; Function-Specs curve25519_dalek::lemmas::montgomery_curve_lemmas::axiom_xdbl_projective_correct
(declare-fun req%curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_xdbl_projective_correct.
 (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. Int Int) Bool
)
(declare-const %%global_location_label%%23 Bool)
(assert
 (forall ((P! curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.) (U! Int) (W!
    Int
   )
  ) (!
   (= (req%curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_xdbl_projective_correct.
     P! U! W!
    ) (=>
     %%global_location_label%%23
     (curve25519_dalek!specs.montgomery_specs.projective_represents_montgomery_or_infinity_nat.?
      (I U!) (I W!) (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. P!)
   )))
   :pattern ((req%curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_xdbl_projective_correct.
     P! U! W!
   ))
   :qid internal_req__curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_xdbl_projective_correct._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_xdbl_projective_correct._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_xdbl_projective_correct.
 (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. Int Int) Bool
)
(assert
 (forall ((P! curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.) (U! Int) (W!
    Int
   )
  ) (!
   (= (ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_xdbl_projective_correct.
     P! U! W!
    ) (let
     ((tmp%%$ (curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xdbl_projective.? (I U!)
        (I W!)
     )))
     (let
      ((U2$ (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$))))))
      (let
       ((W2$ (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$))))))
       (curve25519_dalek!specs.montgomery_specs.projective_represents_montgomery_or_infinity_nat.?
        (I U2$) (I W2$) (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. (curve25519_dalek!specs.montgomery_specs.montgomery_add.?
          (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. P!) (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
           P!
   ))))))))
   :pattern ((ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_xdbl_projective_correct.
     P! U! W!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_xdbl_projective_correct._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_xdbl_projective_correct._definition
)))

;; Function-Specs curve25519_dalek::lemmas::montgomery_curve_lemmas::lemma_montgomery_add_identity_left
(declare-fun ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_add_identity_left.
 (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.) Bool
)
(assert
 (forall ((P! curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)) (!
   (= (ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_add_identity_left.
     P!
    ) (= (curve25519_dalek!specs.montgomery_specs.montgomery_add.? (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
       curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Infinity
      ) (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. P!)
     ) P!
   ))
   :pattern ((ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_add_identity_left.
     P!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_add_identity_left._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_add_identity_left._definition
)))

;; Function-Specs curve25519_dalek::lemmas::montgomery_curve_lemmas::axiom_montgomery_add_associative
(declare-fun ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_montgomery_add_associative.
 (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
  curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
 ) Bool
)
(assert
 (forall ((P! curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.) (Q! curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)
   (R! curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)
  ) (!
   (= (ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_montgomery_add_associative.
     P! Q! R!
    ) (= (curve25519_dalek!specs.montgomery_specs.montgomery_add.? (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
       (curve25519_dalek!specs.montgomery_specs.montgomery_add.? (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
         P!
        ) (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. Q!)
       )
      ) (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. R!)
     ) (curve25519_dalek!specs.montgomery_specs.montgomery_add.? (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
       P!
      ) (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. (curve25519_dalek!specs.montgomery_specs.montgomery_add.?
        (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. Q!) (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
         R!
   ))))))
   :pattern ((ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_montgomery_add_associative.
     P! Q! R!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_montgomery_add_associative._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_montgomery_add_associative._definition
)))

;; Function-Specs curve25519_dalek::lemmas::montgomery_curve_lemmas::lemma_montgomery_scalar_mul_add
(declare-fun ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_scalar_mul_add.
 (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. Int Int) Bool
)
(assert
 (forall ((P! curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.) (m! Int) (n!
    Int
   )
  ) (!
   (= (ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_scalar_mul_add.
     P! m! n!
    ) (= (curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul.? (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
       P!
      ) (I (nClip (Add m! n!)))
     ) (curve25519_dalek!specs.montgomery_specs.montgomery_add.? (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
       (curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul.? (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
         P!
        ) (I m!)
       )
      ) (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. (curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul.?
        (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. P!) (I n!)
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_scalar_mul_add.
     P! m! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_scalar_mul_add._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_scalar_mul_add._definition
)))

;; Function-Specs curve25519_dalek::lemmas::montgomery_curve_lemmas::lemma_montgomery_scalar_mul_double
(declare-fun ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_scalar_mul_double.
 (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. Int) Bool
)
(assert
 (forall ((P! curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.) (n! Int))
  (!
   (= (ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_scalar_mul_double.
     P! n!
    ) (= (curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul.? (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
       P!
      ) (I (nClip (Mul 2 n!)))
     ) (curve25519_dalek!specs.montgomery_specs.montgomery_add.? (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
       (curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul.? (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
         P!
        ) (I n!)
       )
      ) (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. (curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul.?
        (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. P!) (I n!)
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_scalar_mul_double.
     P! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_scalar_mul_double._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_scalar_mul_double._definition
)))

;; Function-Specs curve25519_dalek::lemmas::montgomery_curve_lemmas::lemma_montgomery_scalar_mul_succ
(declare-fun ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_scalar_mul_succ.
 (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. Int) Bool
)
(assert
 (forall ((P! curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.) (n! Int))
  (!
   (= (ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_scalar_mul_succ.
     P! n!
    ) (= (curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul.? (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
       P!
      ) (I (nClip (Add n! 1)))
     ) (curve25519_dalek!specs.montgomery_specs.montgomery_add.? (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
       P!
      ) (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. (curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul.?
        (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. P!) (I n!)
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_scalar_mul_succ.
     P! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_scalar_mul_succ._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_scalar_mul_succ._definition
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

;; Function-Specs curve25519_dalek::lemmas::montgomery_curve_lemmas::lemma_montgomery_add_inverse
(declare-fun ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_add_inverse.
 (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.) Bool
)
(assert
 (forall ((P! curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)) (!
   (= (ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_add_inverse.
     P!
    ) (= (curve25519_dalek!specs.montgomery_specs.montgomery_add.? (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
       P!
      ) (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. (curve25519_dalek!specs.montgomery_specs.montgomery_neg.?
        (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. P!)
      ))
     ) curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Infinity
   ))
   :pattern ((ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_add_inverse.
     P!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_add_inverse._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_add_inverse._definition
)))

;; Function-Specs curve25519_dalek::lemmas::montgomery_curve_lemmas::lemma_montgomery_add_identity
(declare-fun ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_add_identity.
 (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.) Bool
)
(assert
 (forall ((P! curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)) (!
   (= (ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_add_identity.
     P!
    ) (= (curve25519_dalek!specs.montgomery_specs.montgomery_add.? (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
       P!
      ) (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Infinity)
     ) P!
   ))
   :pattern ((ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_add_identity.
     P!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_add_identity._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_add_identity._definition
)))

;; Function-Specs curve25519_dalek::lemmas::montgomery_curve_lemmas::axiom_xadd_projective_correct
(declare-fun req%curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_xadd_projective_correct.
 (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
  Int Int Int Int Int
 ) Bool
)
(declare-const %%global_location_label%%24 Bool)
(declare-const %%global_location_label%%25 Bool)
(declare-const %%global_location_label%%26 Bool)
(declare-const %%global_location_label%%27 Bool)
(declare-const %%global_location_label%%28 Bool)
(assert
 (forall ((P! curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.) (Q! curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)
   (U_P! Int) (W_P! Int) (U_Q! Int) (W_Q! Int) (affine_PmQ! Int)
  ) (!
   (= (req%curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_xadd_projective_correct.
     P! Q! U_P! W_P! U_Q! W_Q! affine_PmQ!
    ) (and
     (=>
      %%global_location_label%%24
      (curve25519_dalek!specs.montgomery_specs.projective_represents_montgomery_or_infinity_nat.?
       (I U_P!) (I W_P!) (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
        P!
     )))
     (=>
      %%global_location_label%%25
      (curve25519_dalek!specs.montgomery_specs.projective_represents_montgomery_or_infinity_nat.?
       (I U_Q!) (I W_Q!) (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
        Q!
     )))
     (=>
      %%global_location_label%%26
      (not (= P! Q!))
     )
     (=>
      %%global_location_label%%27
      (not (= affine_PmQ! 0))
     )
     (=>
      %%global_location_label%%28
      (or
       (= affine_PmQ! (curve25519_dalek!specs.montgomery_specs.u_coordinate.? (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
          (curve25519_dalek!specs.montgomery_specs.montgomery_sub.? (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
            P!
           ) (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. Q!)
       ))))
       (= affine_PmQ! (curve25519_dalek!specs.montgomery_specs.u_coordinate.? (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
          (curve25519_dalek!specs.montgomery_specs.montgomery_sub.? (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
            Q!
           ) (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. P!)
   ))))))))
   :pattern ((req%curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_xadd_projective_correct.
     P! Q! U_P! W_P! U_Q! W_Q! affine_PmQ!
   ))
   :qid internal_req__curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_xadd_projective_correct._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_xadd_projective_correct._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_xadd_projective_correct.
 (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
  Int Int Int Int Int
 ) Bool
)
(assert
 (forall ((P! curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.) (Q! curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)
   (U_P! Int) (W_P! Int) (U_Q! Int) (W_Q! Int) (affine_PmQ! Int)
  ) (!
   (= (ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_xadd_projective_correct.
     P! Q! U_P! W_P! U_Q! W_Q! affine_PmQ!
    ) (let
     ((tmp%%$ (curve25519_dalek!lemmas.montgomery_curve_lemmas.spec_xadd_projective.? (I U_P!)
        (I W_P!) (I U_Q!) (I W_Q!) (I affine_PmQ!)
     )))
     (let
      ((U_PpQ$ (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$))))))
      (let
       ((W_PpQ$ (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$))))))
       (curve25519_dalek!specs.montgomery_specs.projective_represents_montgomery_or_infinity_nat.?
        (I U_PpQ$) (I W_PpQ$) (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
         (curve25519_dalek!specs.montgomery_specs.montgomery_add.? (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
           P!
          ) (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. Q!)
   )))))))
   :pattern ((ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_xadd_projective_correct.
     P! Q! U_P! W_P! U_Q! W_Q! affine_PmQ!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_xadd_projective_correct._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_xadd_projective_correct._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::lemma_euclid_prime
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_euclid_prime.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%29 Bool)
(declare-const %%global_location_label%%30 Bool)
(assert
 (forall ((a! Int) (b! Int) (p! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_euclid_prime.
     a! b! p!
    ) (and
     (=>
      %%global_location_label%%29
      (curve25519_dalek!specs.primality_specs.is_prime.? (I p!))
     )
     (=>
      %%global_location_label%%30
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

;; Function-Specs curve25519_dalek::lemmas::montgomery_curve_lemmas::lemma_field_sqrt_zero
(declare-fun ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_field_sqrt_zero.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_field_sqrt_zero. no%param)
    (= (curve25519_dalek!specs.field_specs.field_sqrt.? (I 0)) 0)
   )
   :pattern ((ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_field_sqrt_zero.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_field_sqrt_zero._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_field_sqrt_zero._definition
)))

;; Function-Specs curve25519_dalek::lemmas::montgomery_curve_lemmas::lemma_canonical_sqrt_zero
(declare-fun ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_canonical_sqrt_zero.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_canonical_sqrt_zero.
     no%param
    ) (= (curve25519_dalek!specs.montgomery_specs.canonical_sqrt.? (I 0)) 0)
   )
   :pattern ((ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_canonical_sqrt_zero.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_canonical_sqrt_zero._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_canonical_sqrt_zero._definition
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

;; Function-Specs curve25519_dalek::lemmas::montgomery_curve_lemmas::lemma_canonical_montgomery_lift_zero
(declare-fun ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_canonical_montgomery_lift_zero.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_canonical_montgomery_lift_zero.
     no%param
    ) (= (curve25519_dalek!specs.montgomery_specs.canonical_montgomery_lift.? (I 0)) (
      curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Finite (%I (I 0)) (%I (I
        0
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_canonical_montgomery_lift_zero.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_canonical_montgomery_lift_zero._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_canonical_montgomery_lift_zero._definition
)))

;; Function-Specs curve25519_dalek::lemmas::montgomery_curve_lemmas::lemma_montgomery_add_zero_point_doubles_to_infinity
(declare-fun ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_add_zero_point_doubles_to_infinity.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_add_zero_point_doubles_to_infinity.
     no%param
    ) (let
     ((P$ (curve25519_dalek!specs.montgomery_specs.canonical_montgomery_lift.? (I 0))))
     (= (curve25519_dalek!specs.montgomery_specs.montgomery_add.? (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
        P$
       ) (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. P$)
      ) curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Infinity
   )))
   :pattern ((ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_add_zero_point_doubles_to_infinity.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_add_zero_point_doubles_to_infinity._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_add_zero_point_doubles_to_infinity._definition
)))

;; Function-Specs curve25519_dalek::lemmas::montgomery_curve_lemmas::lemma_montgomery_scalar_mul_zero_point_closed
(declare-fun ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_scalar_mul_zero_point_closed.
 (Int) Bool
)
(assert
 (forall ((n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_scalar_mul_zero_point_closed.
     n!
    ) (let
     ((P$ (curve25519_dalek!specs.montgomery_specs.canonical_montgomery_lift.? (I 0))))
     (let
      ((R$ (curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul.? (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
          P$
         ) (I n!)
      )))
      (or
       (= R$ curve25519_dalek!specs.montgomery_specs.MontgomeryAffine./Infinity)
       (= R$ P$)
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_scalar_mul_zero_point_closed.
     n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_scalar_mul_zero_point_closed._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_scalar_mul_zero_point_closed._definition
)))

;; Function-Specs curve25519_dalek::lemmas::montgomery_curve_lemmas::lemma_u_coordinate_scalar_mul_canonical_lift_zero
(declare-fun ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_u_coordinate_scalar_mul_canonical_lift_zero.
 (Int) Bool
)
(assert
 (forall ((n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_u_coordinate_scalar_mul_canonical_lift_zero.
     n!
    ) (let
     ((P$ (curve25519_dalek!specs.montgomery_specs.canonical_montgomery_lift.? (I 0))))
     (= (curve25519_dalek!specs.montgomery_specs.u_coordinate.? (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
        (curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul.? (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
          P$
         ) (I n!)
       ))
      ) 0
   )))
   :pattern ((ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_u_coordinate_scalar_mul_canonical_lift_zero.
     n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_u_coordinate_scalar_mul_canonical_lift_zero._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_u_coordinate_scalar_mul_canonical_lift_zero._definition
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

;; Function-Specs curve25519_dalek::lemmas::montgomery_curve_lemmas::lemma_projective_represents_implies_u_coordinate
(declare-fun req%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_projective_represents_implies_u_coordinate.
 (curve25519_dalek!montgomery.ProjectivePoint. curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)
 Bool
)
(declare-const %%global_location_label%%32 Bool)
(assert
 (forall ((P_proj! curve25519_dalek!montgomery.ProjectivePoint.) (P_aff! curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.))
  (!
   (= (req%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_projective_represents_implies_u_coordinate.
     P_proj! P_aff!
    ) (=>
     %%global_location_label%%32
     (curve25519_dalek!specs.montgomery_specs.projective_represents_montgomery_or_infinity.?
      (Poly%curve25519_dalek!montgomery.ProjectivePoint. P_proj!) (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
       P_aff!
   ))))
   :pattern ((req%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_projective_represents_implies_u_coordinate.
     P_proj! P_aff!
   ))
   :qid internal_req__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_projective_represents_implies_u_coordinate._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_projective_represents_implies_u_coordinate._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_projective_represents_implies_u_coordinate.
 (curve25519_dalek!montgomery.ProjectivePoint. curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)
 Bool
)
(assert
 (forall ((P_proj! curve25519_dalek!montgomery.ProjectivePoint.) (P_aff! curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.))
  (!
   (= (ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_projective_represents_implies_u_coordinate.
     P_proj! P_aff!
    ) (= (curve25519_dalek!specs.montgomery_specs.projective_u_coordinate.? (Poly%curve25519_dalek!montgomery.ProjectivePoint.
       P_proj!
      )
     ) (EucMod (curve25519_dalek!specs.montgomery_specs.u_coordinate.? (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
        P_aff!
       )
      ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_projective_represents_implies_u_coordinate.
     P_proj! P_aff!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_projective_represents_implies_u_coordinate._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_projective_represents_implies_u_coordinate._definition
)))

;; Function-Specs curve25519_dalek::lemmas::montgomery_curve_lemmas::lemma_montgomery_add_u_coord_reduced
(declare-fun req%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_add_u_coord_reduced.
 (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
  Int
 ) Bool
)
(declare-const %%global_location_label%%33 Bool)
(declare-const %%global_location_label%%34 Bool)
(declare-const %%global_location_label%%35 Bool)
(assert
 (forall ((P! curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.) (Q! curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)
   (u0! Int)
  ) (!
   (= (req%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_add_u_coord_reduced.
     P! Q! u0!
    ) (and
     (=>
      %%global_location_label%%33
      (not (= u0! 0))
     )
     (=>
      %%global_location_label%%34
      (= P! (curve25519_dalek!specs.montgomery_specs.canonical_montgomery_lift.? (I u0!)))
     )
     (=>
      %%global_location_label%%35
      (< (curve25519_dalek!specs.montgomery_specs.u_coordinate.? (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
         Q!
        )
       ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   ))))
   :pattern ((req%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_add_u_coord_reduced.
     P! Q! u0!
   ))
   :qid internal_req__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_add_u_coord_reduced._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_add_u_coord_reduced._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_add_u_coord_reduced.
 (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
  Int
 ) Bool
)
(assert
 (forall ((P! curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.) (Q! curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)
   (u0! Int)
  ) (!
   (= (ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_add_u_coord_reduced.
     P! Q! u0!
    ) (< (curve25519_dalek!specs.montgomery_specs.u_coordinate.? (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
       (curve25519_dalek!specs.montgomery_specs.montgomery_add.? (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
         P!
        ) (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine. Q!)
      ))
     ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_add_u_coord_reduced.
     P! Q! u0!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_add_u_coord_reduced._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_add_u_coord_reduced._definition
)))

;; Function-Specs curve25519_dalek::lemmas::montgomery_curve_lemmas::lemma_canonical_scalar_mul_u_coord_reduced
(declare-fun req%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_canonical_scalar_mul_u_coord_reduced.
 (Int Int) Bool
)
(declare-const %%global_location_label%%36 Bool)
(assert
 (forall ((u0! Int) (n! Int)) (!
   (= (req%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_canonical_scalar_mul_u_coord_reduced.
     u0! n!
    ) (=>
     %%global_location_label%%36
     (not (= u0! 0))
   ))
   :pattern ((req%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_canonical_scalar_mul_u_coord_reduced.
     u0! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_canonical_scalar_mul_u_coord_reduced._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_canonical_scalar_mul_u_coord_reduced._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_canonical_scalar_mul_u_coord_reduced.
 (Int Int) Bool
)
(assert
 (forall ((u0! Int) (n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_canonical_scalar_mul_u_coord_reduced.
     u0! n!
    ) (let
     ((P$ (curve25519_dalek!specs.montgomery_specs.canonical_montgomery_lift.? (I u0!))))
     (let
      ((R$ (curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul.? (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
          P$
         ) (I n!)
      )))
      (< (curve25519_dalek!specs.montgomery_specs.u_coordinate.? (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
         R$
        )
       ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_canonical_scalar_mul_u_coord_reduced.
     u0! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_canonical_scalar_mul_u_coord_reduced._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_canonical_scalar_mul_u_coord_reduced._definition
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

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::field_algebra_lemmas::lemma_field_sub_add_cancel
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_add_cancel.
 (Int Int) Bool
)
(declare-const %%global_location_label%%37 Bool)
(declare-const %%global_location_label%%38 Bool)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_field_sub_add_cancel.
     a! b!
    ) (and
     (=>
      %%global_location_label%%37
      (< a! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
     )
     (=>
      %%global_location_label%%38
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
(declare-const %%global_location_label%%39 Bool)
(declare-const %%global_location_label%%40 Bool)
(assert
 (forall ((a! Int) (b! Int) (c! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.field_algebra_lemmas.lemma_solve_for_left_factor.
     a! b! c!
    ) (and
     (=>
      %%global_location_label%%39
      (not (= (EucMod b! (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0))
     )
     (=>
      %%global_location_label%%40
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

;; Function-Specs curve25519_dalek::lemmas::montgomery_curve_lemmas::lemma_montgomery_scalar_mul_one
(declare-fun ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_scalar_mul_one.
 (curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.) Bool
)
(assert
 (forall ((P! curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.)) (!
   (= (ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_scalar_mul_one.
     P!
    ) (= (curve25519_dalek!specs.montgomery_specs.montgomery_scalar_mul.? (Poly%curve25519_dalek!specs.montgomery_specs.MontgomeryAffine.
       P!
      ) (I 1)
     ) P!
   ))
   :pattern ((ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_scalar_mul_one.
     P!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_scalar_mul_one._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_montgomery_scalar_mul_one._definition
)))

;; Function-Specs curve25519_dalek::lemmas::montgomery_curve_lemmas::axiom_486660_not_quadratic_residue
(declare-fun ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_486660_not_quadratic_residue.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_486660_not_quadratic_residue.
     no%param
    ) (not (curve25519_dalek!specs.field_specs.is_square.? (I 486660)))
   )
   :pattern ((ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_486660_not_quadratic_residue.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_486660_not_quadratic_residue._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_486660_not_quadratic_residue._definition
)))

;; Function-Specs curve25519_dalek::lemmas::montgomery_curve_lemmas::axiom_2_times_486661_not_qr
(declare-fun ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_2_times_486661_not_qr.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_2_times_486661_not_qr.
     no%param
    ) (not (curve25519_dalek!specs.field_specs.is_square.? (I (EucMod (nClip (Mul 2 486661))
        (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_2_times_486661_not_qr.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_2_times_486661_not_qr._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.axiom_2_times_486661_not_qr._definition
)))

;; Function-Specs curve25519_dalek::lemmas::montgomery_curve_lemmas::lemma_inv_preserves_non_qr
(declare-fun req%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_inv_preserves_non_qr.
 (Int) Bool
)
(declare-const %%global_location_label%%41 Bool)
(declare-const %%global_location_label%%42 Bool)
(assert
 (forall ((a! Int)) (!
   (= (req%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_inv_preserves_non_qr.
     a!
    ) (and
     (=>
      %%global_location_label%%41
      (not (curve25519_dalek!specs.field_specs.is_square.? (I (curve25519_dalek!specs.field_specs_u64.field_canonical.?
          (I a!)
     )))))
     (=>
      %%global_location_label%%42
      (not (= (curve25519_dalek!specs.field_specs_u64.field_canonical.? (I a!)) 0))
   )))
   :pattern ((req%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_inv_preserves_non_qr.
     a!
   ))
   :qid internal_req__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_inv_preserves_non_qr._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_inv_preserves_non_qr._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_inv_preserves_non_qr.
 (Int) Bool
)
(assert
 (forall ((a! Int)) (!
   (= (ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_inv_preserves_non_qr.
     a!
    ) (not (curve25519_dalek!specs.field_specs.is_square.? (I (curve25519_dalek!specs.field_specs.field_inv.?
        (I (curve25519_dalek!specs.field_specs_u64.field_canonical.? (I a!)))
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_inv_preserves_non_qr.
     a!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_inv_preserves_non_qr._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_inv_preserves_non_qr._definition
)))

;; Function-Specs curve25519_dalek::lemmas::montgomery_curve_lemmas::lemma_p_gt_small
(declare-fun req%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_p_gt_small.
 (Int) Bool
)
(declare-const %%global_location_label%%43 Bool)
(assert
 (forall ((n! Int)) (!
   (= (req%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_p_gt_small. n!) (=>
     %%global_location_label%%43
     (< n! 1048576)
   ))
   :pattern ((req%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_p_gt_small. n!))
   :qid internal_req__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_p_gt_small._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_p_gt_small._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_p_gt_small.
 (Int) Bool
)
(assert
 (forall ((n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_p_gt_small. n!) (< n!
     (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_p_gt_small. n!))
   :qid internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_p_gt_small._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.montgomery_curve_lemmas.lemma_p_gt_small._definition
)))

;; Function-Def curve25519_dalek::lemmas::montgomery_curve_lemmas::lemma_p_gt_small
;; curve25519-dalek/src/lemmas/montgomery_curve_lemmas.rs:904:7: 904:34 (#0)
(get-info :all-statistics)
(push)
 (declare-const n! Int)
 (declare-const tmp%1 Bool)
 (declare-const tmp%2 Bool)
 (declare-const tmp%3 Bool)
 (assert
  fuel_defaults
 )
 (assert
  (<= 0 n!)
 )
 (assert
  (< n! 1048576)
 )
 ;; assertion failed
 (declare-const %%location_label%%0 Bool)
 ;; assertion failed
 (declare-const %%location_label%%1 Bool)
 ;; assertion failed
 (declare-const %%location_label%%2 Bool)
 ;; assertion failed
 (declare-const %%location_label%%3 Bool)
 ;; assertion failed
 (declare-const %%location_label%%4 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%5 Bool)
 ;; postcondition not satisfied
 (declare-const %%location_label%%6 Bool)
 (assert
  (not (=>
    (ens%curve25519_dalek!specs.field_specs_u64.pow255_gt_19. 0)
    (=>
     (ens%vstd!arithmetic.power2.lemma2_to64. 0)
     (and
      (=>
       (ens%vstd!arithmetic.power2.lemma2_to64. 0)
       (=>
        %%location_label%%0
        (= (vstd!arithmetic.power2.pow2.? (I 5)) 32)
      ))
      (=>
       (= (vstd!arithmetic.power2.pow2.? (I 5)) 32)
       (=>
        (ens%vstd!arithmetic.power2.lemma_pow2_adds. 5 5)
        (=>
         (= tmp%1 (= (vstd!arithmetic.power2.pow2.? (I 10)) 1024))
         (and
          (=>
           %%location_label%%1
           tmp%1
          )
          (=>
           tmp%1
           (=>
            (ens%vstd!arithmetic.power2.lemma_pow2_adds. 10 10)
            (=>
             (= tmp%2 (= (vstd!arithmetic.power2.pow2.? (I 20)) 1048576))
             (and
              (=>
               %%location_label%%2
               tmp%2
              )
              (=>
               tmp%2
               (=>
                (ens%vstd!arithmetic.power2.lemma_pow2_adds. 20 1)
                (and
                 (=>
                  (ens%vstd!arithmetic.power2.lemma2_to64. 0)
                  (=>
                   %%location_label%%3
                   (= (vstd!arithmetic.power2.pow2.? (I 1)) 2)
                 ))
                 (=>
                  (= (vstd!arithmetic.power2.pow2.? (I 1)) 2)
                  (=>
                   (= tmp%3 (= (vstd!arithmetic.power2.pow2.? (I 21)) 2097152))
                   (and
                    (=>
                     %%location_label%%4
                     tmp%3
                    )
                    (=>
                     tmp%3
                     (and
                      (=>
                       %%location_label%%5
                       (req%vstd!arithmetic.power2.lemma_pow2_strictly_increases. 21 255)
                      )
                      (=>
                       (ens%vstd!arithmetic.power2.lemma_pow2_strictly_increases. 21 255)
                       (=>
                        %%location_label%%6
                        (< n! (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
 )))))))))))))))))))))))
 (get-info :version)
 (set-option :rlimit 30000000)
 (check-sat)
 (set-option :rlimit 0)
(pop)
